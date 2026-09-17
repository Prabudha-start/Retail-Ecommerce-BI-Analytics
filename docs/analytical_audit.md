# Analytical Audit

## Why this document exists

A polished dashboard is only useful if its numbers survive scrutiny. This audit records the main grain and metric risks identified during the repository review before the Power BI report is treated as portfolio-final.

## 1. The master table is not an order-level table

The current master dataset contains **119,143 rows**, while the source orders table contains **99,441 orders**.

That difference is expected from the relational structure: an order can have multiple items and multiple payment records. The merged dataset therefore behaves as a mixed-grain analytical table rather than one row per order.

**Rule:** use `COUNT(DISTINCT order_id)` for order counts. Never use row count as order count.

## 2. Payment values require special care

The current SQL notebook calculates revenue using `SUM(payment_value)` over the merged `olist_master` table.

Because payment records are joined to order-item records, an order with multiple items can repeat the same payment value across multiple rows. That can inflate payment-based revenue, payment mix, customer value, and related metrics if they are aggregated directly from the merged table.

**Portfolio standard:** payment metrics should be calculated from an order-level payment aggregation before being joined to item-level analysis, or directly from the original payment table.

## 3. Product/category analysis should use item-level value

`price` and `freight_value` originate at order-item level. They are appropriate for product and category analysis when aggregated at that grain.

For category revenue, aggregate item-level merchandise value rather than repeating order-level payment totals across items.

## 4. Customer value should be calculated at customer/order grain

Customer lifetime value and average order value should be calculated after establishing one value per order, then grouped by `customer_unique_id`.

This avoids multiplying customer value when an order contains multiple items or payment records.

## 5. Delivery metrics have an appropriate order-level denominator

Delivery time and late-delivery status describe an order experience. They should therefore be evaluated using distinct delivered orders with the required delivery timestamps.

The current SQL output shows 96,478 delivered orders and 6,535 late orders, with the late/on-time classification based on `delivery_delay > 0`.

## 6. Current portfolio numbers should be reconciled before final publication

The repository currently contains headline figures such as approximately 20.58M revenue and a 6.34% late-delivery rate. The SQL notebook contains related calculations using the merged master table, including 20,579,664.01 from `SUM(payment_value)` and 6,535 delayed orders.

These figures should not be treated as final portfolio KPIs until the underlying grain is reconciled and the same definitions are used across Python, SQL, and Power BI.

This is intentionally documented rather than hidden. A strong analytics portfolio should show that metric governance is part of the work.

## Recommended analytical model

```text
                 ┌── Customers
                 │
Orders ──────────┼── Delivery / Status
   │             │
   ├── Order-level Payments
   │
   ├── Order-level Reviews
   │
   └── Order Items ── Products / Categories

Order grain       → orders, AOV, delivery, late rate, customer value
Item grain        → product/category sales, freight, assortment
Payment grain     → payment mix, payment value, installments
Review grain      → review score and experience analysis
```

## Final QA rule

Before a KPI reaches the executive dashboard, answer three questions:

1. **What is the grain?**
2. **What is the denominator?**
3. **Can a one-to-many join duplicate the value being aggregated?**

If any answer is unclear, the KPI is not ready for publication.
