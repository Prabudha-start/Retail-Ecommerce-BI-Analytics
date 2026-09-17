# # Retail E-Commerce Business Intelligence Platform
End-to-end analytics project turning raw Brazilian e-commerce data into executive dashboards and business decisions using Python, SQL, and Power BI.

![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)

![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-blue)

![SQLite](https://img.shields.io/badge/SQL-SQLite-green)

![PowerBI](https://img.shields.io/badge/PowerBI-Dashboard-yellow?logo=powerbi)

An end-to-end Business Intelligence portfolio project that transforms raw Brazilian e-commerce data into executive-ready dashboards and actionable business insights using Python, SQL, and Power BI.

## Table of Contents

- Business Objective
- Tech Stack
- Skills Demonstrated
- Project Workflow
- Dataset
- Executive Dashboard
- Customer & Delivery Dashboard
- Business Questions Answered
- Business Impact
- Key Business Insights
- Repository Structure
- Future Improvements
- Author

---

# Business Objective

The objective of this project is to help business leaders understand:

- Revenue performance
- Customer purchasing behavior
- Delivery efficiency
- Product category performance
- Payment trends
- Customer satisfaction

The project demonstrates the complete analytics workflow from raw data to an executive-level business intelligence dashboard.

---

# Tech Stack

- Python
- Pandas
- NumPy
- SQL (SQLite)
- Power BI
- Git
- GitHub
- VS Code
- Jupyter Notebook

---
## How to Run This

1. Clone the repository
   git clone https://github.com/Prabudha-start/Retail-Pricing-Intelligence.git
   cd Retail-Pricing-Intelligence

2. Install dependencies
   pip install -r requirements.txt

3. Run the data cleaning and EDA notebooks in order (in notebooks/)

4. Load the cleaned data into the SQL database
   python sql/build_database.py
   (adjust this to whatever your actual script is called)

5. Open the Power BI file in dashboard/ to explore the dashboards, or view the exported screenshots in images/

---

# Skills Demonstrated

- Data Cleaning
- Feature Engineering
- Exploratory Data Analysis (EDA)
- SQL Querying
- KPI Development
- Data Visualization
- Dashboard Design
- Business Intelligence
- Business Storytelling

---

## Highlights

✔ Built end-to-end BI pipeline

✔ Cleaned 100K+ records

✔ Designed SQL database

✔ Developed 25+ KPIs

✔ Built two interactive Power BI dashboards

✔ Produced executive recommendations

---

# Project Workflow

```text
Raw Data
    │
    ▼
Data Cleaning & Feature Engineering (Python)
    │
    ▼
Exploratory Data Analysis (Python)
    │
    ▼
SQL Database Creation
    │
    ▼
Business KPI Development
    │
    ▼
Power BI Dashboard
    │
    ▼
Business Insights & Recommendations
```

---

# Dataset

**Source**

Brazilian E-Commerce Public Dataset by Olist

**Dataset Size**

- Approximately 99,000 Orders
- Approximately 96,000 Customers
- Over 100,000 Order Items

---

# Executive Dashboard

Designed for executives to monitor business performance through:

- Revenue KPIs
- Customer Metrics
- Revenue Trends
- Product Category Analysis
- Payment Method Analysis
- Executive Business Insights


## Executive Dashboard

![Executive Dashboard](images/Executive_Sales_Overview.png)

---

# Customer & Delivery Dashboard

Focused on customer experience and logistics performance through:

- Average Delivery Time
- Late Delivery Rate
- Customer Satisfaction
- Freight Cost Analysis
- Regional Delivery Performance
- Order Status Analysis

### Customer & Delivery Dashboard

![Customer & Delivery Dashboard](images/Customer_and_delivery_analysis.png)

---

# Business Questions Answered

- Which product categories generate the highest revenue?
- Which payment methods contribute the most revenue?
- How has revenue changed over time?
- Which states experience longer delivery times?
- What percentage of deliveries are delayed?
- How do delivery delays affect customer satisfaction?
- Which product categories incur the highest freight costs?

---

## Business Impact

- Revenue concentration in Home & Furniture and Health & Beauty signals where marketing and inventory investment would have the highest return
- A 6.34% late-delivery rate, concentrated in specific states, points to where logistics or carrier renegotiation would have the most impact
- 77% of revenue running through credit cards suggests payment-method incentives (installments, cashback) could be tested to shift lower-margin payment types
- Average 12-day delivery time is a clear benchmark for a logistics improvement target

---

# Key Business Insights

- Revenue exceeded **20.58M** across approximately **99K orders**.
- Credit Cards generated approximately **77%** of total revenue.
- Average customer rating remained high at **4.02 / 5**.
- Only **6.34%** of deliveries were delayed.
- Average delivery time was approximately **12 days**.
- Home & Furniture and Health & Beauty generated the highest revenue.

---

# Repository Structure

```text
Retail-Pricing-Intelligence/
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── notebooks/
│
├── sql/
│
├── dashboard/
│
├── reports/
│
├── images/
│
├── simulator/
│
├── README.md
│
└── requirements.txt
```

---

## Sample Queries

**Revenue by product category**
SELECT category, SUM(price) AS total_revenue
FROM order_items
JOIN products USING (product_id)
GROUP BY category
ORDER BY total_revenue DESC;

**Late delivery rate by state**
SELECT customer_state,
       ROUND(100.0 * SUM(CASE WHEN delivered_date > estimated_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct
FROM orders
GROUP BY customer_state
ORDER BY late_pct DESC;

**Average delivery time trend**
SELECT strftime('%Y-%m', order_date) AS month,
       AVG(julianday(delivered_date) - julianday(order_date)) AS avg_delivery_days
FROM orders
GROUP BY month
ORDER BY month;

---

# Future Improvements

- Dynamic Pricing Simulator
- Profitability Dashboard
- Customer Segmentation
- Predictive Sales Forecasting
- Inventory Optimization

---

---

# Author

**Prabudha Darabare**

Data Analytics | Business Intelligence | Prompt Engineering

- **LinkedIn:** [https://linkedin.com/in/prabudha-darabare](https://linkedin.com/in/prabudha-darabare)
- **GitHub:** https://github.com/Prabudha-start/Retail-Pricing-Intelligence

---

*Thank you for exploring this project. Feedback, suggestions, and collaborations are always welcome.*
