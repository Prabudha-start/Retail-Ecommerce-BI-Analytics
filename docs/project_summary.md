# Retail E-Commerce BI Analytics

## From transactions to decisions

This project asks a simple business question:

> **What can a retail business actually learn when revenue, customers, products, payments, and delivery are treated as one connected story?**

The analysis uses the Brazilian E-Commerce Public Dataset by Olist to build an end-to-end Business Intelligence workflow — from raw relational tables through Python-based exploration and SQL analysis to an executive Power BI dashboard.

The goal is not simply to report what happened. It is to make the data easier to question, interpret, and act on.

---

## The business lenses

The project examines the business through six connected lenses:

| Lens | What it helps answer |
|---|---|
| Revenue | How much business is being generated, and how does it change over time? |
| Products | Which categories contribute most to sales? |
| Customers | Who is buying, where are they located, and how does purchasing behaviour vary? |
| Delivery | How long does fulfillment take, and where are delays concentrated? |
| Payments | Which payment methods and installment patterns dominate transactions? |
| Experience | What relationship can we observe between operational performance and customer ratings? |

---

## Analytical workflow

```text
Raw Olist Tables
      ↓
Data Understanding
      ↓
Cleaning + Validation + Feature Engineering
      ↓
Exploratory Analysis in Python
      ↓
SQL Analysis Layer
      ↓
Business KPIs + Questions
      ↓
Power BI Dashboard
      ↓
Insights + Decision Opportunities
```

Each stage exists for a reason: establish what the data contains, make it trustworthy enough to analyse, investigate the patterns, then communicate those patterns in a form a decision-maker can use.

---

## Dataset

**Source:** Brazilian E-Commerce Public Dataset by Olist

The raw project data is distributed across relational tables covering customers, orders, order items, products, payments, and reviews.

Key source-table sizes observed during the analysis include:

- Orders: 99,441 rows
- Customers: 99,441 rows
- Order items: 112,650 rows
- Products: 32,951 rows
- Payments: 103,886 rows
- Reviews: 99,224 rows

A merged analytical dataset is then created for downstream analysis. Because several source tables are one-to-many relationships, row counts after joins are not interpreted as order counts without first considering the analytical grain.

---

## Core analytical questions

### Commercial
- Which product categories generate the most revenue?
- How does revenue change over time?
- Which categories deserve deeper commercial investigation?

### Customer
- How many distinct customers are represented?
- Where are customers concentrated geographically?
- What does the purchasing pattern look like at customer level?

### Operations
- How long does an order take to reach the customer?
- Where are late deliveries concentrated?
- How does freight value vary across the business?

### Payments
- Which payment methods account for the largest share of transaction value?
- How common are installment payments?

### Experience
- What do customer review scores look like?
- Are operational signals worth investigating alongside customer satisfaction?

---

## Deliverables

### Python notebooks

- `01_data_understanding.ipynb` — establish the dataset structure, entities, relationships, and initial quality picture.
- `02_data_cleaning_feature_engineering.ipynb` — load, validate, merge, clean, and prepare the analytical data.
- `03_exploratory_data_analysis.ipynb` — investigate commercial, customer, operational, and payment patterns.
- `04_sql_database_setup.ipynb` — create the SQL analysis layer and demonstrate business-oriented querying.

### Power BI

The `dashboard/` directory contains the Power BI report and `images/` contains exported dashboard views for quick review from GitHub.

---

## Analytical principles

This project deliberately separates **a metric from the story told about the metric**.

For example, a late-delivery rate can tell us how frequently deliveries missed their estimate. It does not, by itself, tell us why they were late or prove that a particular intervention will improve performance.

Where the analysis identifies an opportunity, the intended next step is therefore further investigation rather than pretending correlation is causation.

---

## Technology

- Python
- Pandas
- NumPy
- Matplotlib
- SQL / SQLite
- SQLAlchemy
- Jupyter Notebook
- Power BI
- Git / GitHub

---

## Portfolio intent

I built this as more than a collection of charts. I wanted the project to demonstrate the part of analytics that often gets lost between code and dashboards: **judgement**.

The interesting question is rarely just *"What is the number?"* It is *"Why does this number deserve attention, and what should we investigate next?"*

That is the standard I am using throughout this project.
