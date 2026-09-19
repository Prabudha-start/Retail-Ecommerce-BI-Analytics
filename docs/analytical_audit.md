# Analytical Audit

## Purpose

A polished dashboard is only useful if its numbers survive scrutiny. This audit records the data-quality, grain, reconciliation, and interpretation risks identified during the repository review.

The corrective SQL model is now available at `sql/analytical_model.sql`.

## 1. Grain risk: corrected

The source contains multiple relational grains:

- `orders` → one row per order
- `order_items` → one row per item within an order
- `order_payments` → one row per payment record
- `order_reviews` → review-level records
- `customers` → customer/order-address records
- `products` → product-level attributes

The previous merged dataset contained **119,143 rows** versus **99,441 source orders**. That expansion is expected from one-to-many relationships, but it makes the merged table unsafe as a universal KPI source.

**Correction:** the new analytical model aggregates item, payment, and review tables to the required grain before joining them to the order-level base.

## 2. Payment-value inflation: corrected

Payment records were previously joined to order-item records. If an order had multiple items, its payment value could therefore appear on multiple rows.

A direct `SUM(payment_value)` over that mixed-grain table could inflate payment-based revenue and payment mix.

**Correction:** `v_order_payments` aggregates payments to one row per order, while `v_payment_mix` calculates payment-method composition directly from the payment table.

## 3. Category revenue: corrected

`price` and `freight_value` originate at order-item level. Category analysis should therefore use item-level merchandise value.

**Correction:** the category query in `sql/analytical_model.sql` aggregates `order_items.price` by product category rather than allocating order-level payment totals across products.

## 4. AOV and customer metrics: corrected

Average Order Value must use distinct orders and an order-level value. Customer value should likewise be calculated after establishing one value per order.

**Correction:** the analytical model provides one row per order in `v_order_analytics`, making distinct-order denominators explicit.

## 5. Delivery metrics: corrected

Delivery duration and lateness are order-level concepts.

**Correction:** delivery days and late-delivery classification are calculated from the order table, with eligible delivered orders used as the denominator. Missing delivery timestamps are not silently treated as zero days.

## 6. Data-quality checks added

The SQL model now includes checks for:

- Duplicate order IDs
- Duplicate customer IDs
- Duplicate product IDs
- Negative item prices
- Negative freight values
- Invalid review scores outside 1–5
- Negative payment values
- Delivery before purchase
- Approval before purchase
- Carrier handoff before purchase
- Analytical row-count / distinct-order reconciliation

These checks are designed to distinguish genuine anomalies from expected characteristics of the source data.

## 7. Historical KPI reconciliation

The earlier portfolio headline figures included approximately **20.58M revenue** and **6.34% late deliveries**. Those figures must now be recalculated against the corrected analytical model before they are treated as final dashboard KPIs.

Until that reconciliation is executed against the raw source files, those earlier figures should be regarded as **provisional**, not authoritative.

## 8. Expected versus suspicious behaviour

Not every unusual record is a data error. For example:

- Multiple payment rows for one order are expected.
- Multiple item rows for one order are expected.
- Missing reviews are expected because not every order has a review.
- Missing delivery dates can be legitimate for orders that were not delivered.
- Multiple reviews for an order require aggregation rather than automatic deletion.

The audit therefore avoids blanket deduplication. Records should only be removed when there is evidence that they violate the intended business grain or represent invalid values.

## 9. Recommended analytical architecture

```text
                    ┌── Customers
                    │
Orders ─────────────┼── Delivery / Status
   │                │
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

## 10. Final KPI QA rule

Before a KPI reaches the executive dashboard, answer three questions:

1. **What is the grain?**
2. **What is the denominator?**
3. **Can a one-to-many relationship duplicate the value being aggregated?**

If any answer is unclear, the KPI is not ready for publication.


## 11. Confirmed audit findings from raw source execution

The local audit notebook was executed against the raw Olist files. The following findings are now confirmed:

### Structural integrity

- 99,441 source orders
- 119,143 rows after the deliberately broad diagnostic join
- 99,441 distinct orders remain after that join
- Row multiplication factor: **1.198x**
- Duplicate order, customer, and product keys: **0**
- Referential-integrity orphan counts tested: **0**

The 1.198x expansion is therefore a **grain/model issue**, not evidence of duplicated orders.

### Value-domain checks

The tested invalid-value counts were:

- Negative item prices: **0**
- Zero item prices: **0**
- Negative freight values: **0**
- Negative payment values: **0**
- Invalid review scores: **0**
- Negative payment installments: **0**
- Zero-value payment records: **9**

The nine zero-value payment records should be retained unless a downstream business definition explicitly excludes them.

### Timestamp quality

The audit identified:

- **166** orders where carrier handoff is timestamped before purchase
- **23** orders where customer delivery is timestamped before carrier handoff
- **0** approval-before-purchase cases
- **0** delivery-before-purchase cases

The 189 timestamp-anomaly records should not be overwritten or "corrected" in the raw data. Instead, analytical logic should preserve the source timestamps and expose a quality flag when operational sequence validity matters.

### Payment reconciliation

Across **99,441 orders** checked:

- **260** differed from item value + freight by more than R$0.05
- **249** differed by more than R$1
- **98** differed by more than R$10
- Maximum absolute difference: **R$182.81**

The 98 orders with differences above R$10 were overwhelmingly card payments: **96 credit-card and 2 debit-card orders**.

A further check showed that all 98 had exactly **one payment record** and payment sequence **1**. Therefore, the discrepancy is **not caused by multiple payment rows being joined together**.

These payment values should **not** be altered to force reconciliation with item price + freight. Payment value and merchandise/item value remain separate measures with separate semantics. The analytical model therefore keeps payment values at payment/order grain and merchandise revenue at item/order grain.

### Delivery distribution

For orders with both purchase and customer-delivery timestamps:

- Count: **96,476**
- Mean delivery duration: **12.56 days**
- Median: **10.22 days**
- 95th percentile: **29.28 days**
- 99th percentile: **46.05 days**
- Maximum: **209.63 days**

The long tail is retained rather than arbitrarily clipped. Extreme durations should be investigated contextually when used for operational decisions.

## 12. Final data-quality decisions

| Finding | Decision |
|---|---|
| One-to-many join expansion | Correct through grain-safe analytical model |
| Duplicate primary keys | No action |
| Orphan foreign keys | No action |
| Missing review text | Retain as source characteristic |
| Missing delivery timestamps | Retain; use metric-specific eligibility rules |
| Invalid monetary values | None found in tested domains |
| Timestamp sequence anomalies | Preserve source; flag for affected operational analyses |
| Payment/item reconciliation differences | Preserve both measures; do not force equality |
| Extreme delivery durations | Retain; investigate contextually |

The raw source data is therefore **not being rewritten to manufacture cleaner numbers**. Corrections belong in the analytical layer and metric definitions.
