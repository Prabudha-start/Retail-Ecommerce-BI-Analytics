# KPI Dictionary

A dashboard becomes more trustworthy when every headline number has a clear definition.

This document records the intended meaning of the project's core metrics and the main analytical guardrails used when interpreting them.

## Core KPIs

| KPI | Definition | Analytical note |
|---|---|---|
| Revenue | Sum of the merchandise value represented by the project's revenue measure | Confirm the underlying grain before aggregating after one-to-many joins. |
| Orders | Count of distinct `order_id` values | Do not count rows in the merged master table as orders. |
| Customers | Count of distinct `customer_unique_id` values | `customer_id` and `customer_unique_id` represent different analytical concepts in the Olist data. |
| Average Order Value | Revenue divided by distinct orders | Interpret alongside the revenue definition used in the report. |
| Average Delivery Days | Average elapsed days from purchase to customer delivery for eligible delivered orders | Exclude records without the required delivery timestamps. |
| Late Delivery Rate | Share of eligible delivered orders where customer delivery occurred after the estimated delivery date | This measures lateness against the estimate; it does not explain the cause. |
| Average Review Score | Mean review score across eligible review records | Review coverage and one-to-many relationships should be considered before comparing groups. |
| Freight Value | Sum or average of `freight_value`, depending on the visual | Always state the aggregation because freight is stored at order-item level. |
| Payment Mix | Share of payment value by `payment_type` | Payment data can contain multiple payment records for an order. |

## Grain matters

The source data is relational rather than a single flat transaction table. In particular, orders can have multiple order items, payment records, and review records.

That means a naive multi-table join can multiply rows. Any metric derived from the merged dataset should therefore be checked against an order-level or item-level denominator appropriate to the question.

## Interpretation guardrails

- A high-revenue category is not automatically a high-profit category because cost and margin data are not available in the source dataset.
- A relationship between delivery performance and review scores should be treated as an analytical signal, not proof of causation.
- Payment mix describes observed transaction behaviour; it does not establish that a payment-method incentive would change customer behaviour.
- Geographic differences may reflect customer mix, seller distribution, distance, or other factors not captured by the dataset.
- The Olist dataset is historical and should not be presented as current market performance.

## Why this matters

The purpose of a KPI dictionary is not bureaucracy. It is to make the analysis reproducible and make conversations about the numbers easier.

If two people can look at the same dashboard and mean two different things by "orders" or "revenue," the dashboard has a definition problem before it has a visual-design problem.
