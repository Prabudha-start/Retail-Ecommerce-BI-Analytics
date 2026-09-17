-- Retail E-Commerce BI Analytics
-- Grain-safe analytical model
--
-- Principle:
--   Keep order, item, payment and review measures at their natural grain.
--   Aggregate child tables before joining them to order-level analysis.
--
-- This script is intentionally separate from the raw/master join so that
-- Power BI and downstream analysis can use defensible business measures.

-- 1. ORDER-LEVEL BASE
DROP VIEW IF EXISTS v_order_base;
CREATE VIEW v_order_base AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_purchase_timestamp IS NOT NULL
        THEN (julianday(o.order_delivered_customer_date)
              - julianday(o.order_purchase_timestamp))
    END AS delivery_days,
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_estimated_delivery_date IS NOT NULL
        THEN (julianday(o.order_delivered_customer_date)
              - julianday(o.order_estimated_delivery_date))
    END AS delivery_delay_days
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;

-- 2. ORDER-LEVEL MERCHANDISE VALUE
-- One row per order. Price/freight originate at item grain.
DROP VIEW IF EXISTS v_order_value;
CREATE VIEW v_order_value AS
SELECT
    order_id,
    SUM(price) AS merchandise_value,
    SUM(freight_value) AS freight_value,
    SUM(price + freight_value) AS order_item_total,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id;

-- 3. ORDER-LEVEL PAYMENT VALUE
-- One row per order. This prevents payment values being repeated across items.
DROP VIEW IF EXISTS v_order_payments;
CREATE VIEW v_order_payments AS
SELECT
    order_id,
    SUM(payment_value) AS payment_value,
    COUNT(*) AS payment_record_count,
    MAX(payment_installments) AS max_installments
FROM order_payments
GROUP BY order_id;

-- 4. PAYMENT MIX AT PAYMENT GRAIN
-- Use this view directly for payment-method value/share analysis.
DROP VIEW IF EXISTS v_payment_mix;
CREATE VIEW v_payment_mix AS
SELECT
    payment_type,
    SUM(payment_value) AS payment_value,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT order_id) AS orders
FROM order_payments
GROUP BY payment_type;

-- 5. ORDER-LEVEL REVIEW SUMMARY
-- Reviews can contain more than one record for an order. Aggregate first.
DROP VIEW IF EXISTS v_order_reviews;
CREATE VIEW v_order_reviews AS
SELECT
    order_id,
    AVG(review_score) AS avg_review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id;

-- 6. ORDER-LEVEL ANALYTICAL TABLE
DROP VIEW IF EXISTS v_order_analytics;
CREATE VIEW v_order_analytics AS
SELECT
    b.*,
    v.merchandise_value,
    v.freight_value,
    v.order_item_total,
    v.item_count,
    p.payment_value,
    p.payment_record_count,
    p.max_installments,
    r.avg_review_score,
    r.review_count,
    CASE
        WHEN b.delivery_delay_days > 0 THEN 1
        WHEN b.delivery_delay_days IS NOT NULL THEN 0
    END AS is_late_delivery
FROM v_order_base b
LEFT JOIN v_order_value v ON b.order_id = v.order_id
LEFT JOIN v_order_payments p ON b.order_id = p.order_id
LEFT JOIN v_order_reviews r ON b.order_id = r.order_id;

-- 7. CORE KPI RECONCILIATION
-- These are order-level metrics and should be the source of executive KPIs.
SELECT
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_unique_id) AS customers,
    SUM(merchandise_value) AS merchandise_revenue,
    SUM(payment_value) AS payment_value,
    ROUND(SUM(merchandise_value) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS avg_order_value,
    ROUND(AVG(CASE WHEN order_delivered_customer_date IS NOT NULL
                   THEN delivery_days END), 2) AS avg_delivery_days,
    ROUND(100.0 * SUM(CASE WHEN is_late_delivery = 1 THEN 1 ELSE 0 END)
          / NULLIF(SUM(CASE WHEN delivery_delay_days IS NOT NULL THEN 1 ELSE 0 END), 0), 2)
          AS late_delivery_rate_pct,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM v_order_analytics;

-- 8. CATEGORY PERFORMANCE
-- Category revenue is item-grain merchandise value, not payment value.
SELECT
    COALESCE(p.product_category_name, 'Unknown') AS product_category_name,
    SUM(i.price) AS merchandise_revenue,
    SUM(i.freight_value) AS freight_value,
    COUNT(DISTINCT i.order_id) AS orders,
    COUNT(*) AS items
FROM order_items i
LEFT JOIN products p
    ON i.product_id = p.product_id
GROUP BY COALESCE(p.product_category_name, 'Unknown')
ORDER BY merchandise_revenue DESC;

-- 9. DATA QUALITY CHECKS
-- Primary-key uniqueness checks
SELECT 'orders_duplicate_order_id' AS check_name,
       COUNT(*) - COUNT(DISTINCT order_id) AS issue_count
FROM orders;

SELECT 'customers_duplicate_customer_id' AS check_name,
       COUNT(*) - COUNT(DISTINCT customer_id) AS issue_count
FROM customers;

SELECT 'products_duplicate_product_id' AS check_name,
       COUNT(*) - COUNT(DISTINCT product_id) AS issue_count
FROM products;

-- Value-domain checks
SELECT 'negative_item_price' AS check_name, COUNT(*) AS issue_count
FROM order_items
WHERE price < 0;

SELECT 'negative_freight_value' AS check_name, COUNT(*) AS issue_count
FROM order_items
WHERE freight_value < 0;

SELECT 'invalid_review_score' AS check_name, COUNT(*) AS issue_count
FROM order_reviews
WHERE review_score < 1 OR review_score > 5;

SELECT 'negative_payment_value' AS check_name, COUNT(*) AS issue_count
FROM order_payments
WHERE payment_value < 0;

-- Temporal consistency checks
SELECT 'delivery_before_purchase' AS check_name, COUNT(*) AS issue_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

SELECT 'approval_before_purchase' AS check_name, COUNT(*) AS issue_count
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;

SELECT 'carrier_before_purchase' AS check_name, COUNT(*) AS issue_count
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_carrier_date < order_purchase_timestamp;

-- 10. JOIN MULTIPLICATION DIAGNOSTIC
-- Compare row counts to distinct orders before any dashboard KPI is built.
SELECT
    (SELECT COUNT(*) FROM orders) AS source_order_rows,
    (SELECT COUNT(*) FROM v_order_analytics) AS analytical_order_rows,
    (SELECT COUNT(DISTINCT order_id) FROM v_order_analytics) AS analytical_distinct_orders;
