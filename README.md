# 🛒 E-Commerce Customer Analytics with SQL

A standalone **MySQL analytics project** focused on e-commerce revenue, customer behavior, retention, and segmentation.

The project transforms synthetic transactional data into business insights using SQL techniques such as joins, CTEs, window functions, reusable views, cohort analysis, and RFM segmentation.

---

## 📌 Project Overview

**Project:** E-Commerce Customer Analytics & Retention Intelligence  
**Database:** MySQL 8.0+  
**Domain:** E-Commerce / Retail Analytics  
**Dataset:** Synthetic transactional data  
**Currency:** INR  
**Analysis Date:** 2026-10-01  

The goal of this project is to simulate a real-world analytics workflow where SQL is used to answer business questions around:

- Revenue performance
- Customer value
- Repeat purchasing behavior
- Product and category performance
- Customer retention
- Customer segmentation
- Marketing actions

---

## 🎯 Business Questions

This project answers questions such as:

- How much revenue is the business generating?
- What is the average order value?
- Which products and categories generate the most revenue?
- Which customers generate the highest lifetime revenue?
- What percentage of customers make repeat purchases?
- How does monthly revenue change over time?
- Which customer cohorts retain best?
- Which customers are most valuable?
- Which customers are becoming inactive?
- Which customers should receive retention or loyalty campaigns?

---

## 🗂️ Database Schema

The project uses four main tables:

```text
CUSTOMERS
    |
    | customer_id
    v
ORDERS
    |
    | order_id
    v
ORDER_ITEMS
    |
    | product_id
    v
PRODUCTS
```

### `customers`

Stores customer information.

Key columns:

- `customer_id`
- `customer_name`
- `city`
- `signup_date`

### `products`

Stores product information.

Key columns:

- `product_id`
- `product_name`
- `category`
- `list_price`

### `orders`

Stores customer orders.

Key columns:

- `order_id`
- `customer_id`
- `order_date`
- `order_status`

### `order_items`

Stores products purchased inside each order.

Key columns:

- `order_item_id`
- `order_id`
- `product_id`
- `quantity`
- `unit_price`
- `discount_percent`

---

## 📊 Dataset

The synthetic dataset includes:

- 12 customers
- 6 products
- 27 orders
- 29 order-item records
- Completed, cancelled, and pending orders
- Multiple product categories
- Item-level discounts
- Repeat and one-time customers

The dataset is intentionally small enough to understand manually while still supporting realistic analytics.

---

## 🧮 Revenue Logic

Revenue is calculated at the order-item level.

```text
Line Revenue =
Quantity × Unit Price × (1 - Discount Percentage / 100)
```

Only `COMPLETED` orders contribute to recognized revenue.

Cancelled and pending orders are excluded from revenue, customer value, cohort, and RFM metrics.

---

## 📈 Key Metrics

The project calculates:

- Total revenue
- Completed orders
- Average order value
- Purchasing customers
- Monthly revenue
- Month-over-month revenue growth
- Product revenue
- Category revenue
- Customer lifetime revenue
- Repeat purchase rate
- Cohort retention
- RFM scores
- Customer segments

---

## 🔍 Analysis Workflow

```text
Create Database
      ↓
Create Relational Tables
      ↓
Insert Synthetic Data
      ↓
Validate Data Quality
      ↓
Build Order-Level Revenue View
      ↓
Calculate Business KPIs
      ↓
Analyze Revenue Trends
      ↓
Analyze Product Performance
      ↓
Analyze Customer Value
      ↓
Build Cohort Retention Analysis
      ↓
Calculate RFM Scores
      ↓
Segment Customers
      ↓
Generate Business Recommendations
      ↓
Validate Revenue Reconciliation
```

---

## 🧱 Reusable SQL Views

The project creates reusable analytical views to separate data preparation from business analysis.

### `order_facts`

Creates one record per order and calculates order-level revenue.

### `customer_value`

Calculates:

- Completed order frequency
- Customer lifetime revenue
- Most recent completed purchase

### `rfm_scores`

Calculates customer-level:

- Recency
- Frequency
- Monetary value
- RFM scores

---

## 📅 Cohort Retention Analysis

Customers are grouped based on the month of their **first completed purchase**.

The project then tracks whether those customers return in later calendar months.

Example:

```text
January Cohort
   |
   ├── Month 0 → First purchase month
   ├── Month 1 → Returned next month?
   ├── Month 2 → Returned two months later?
   └── Month 3 → Returned three months later?
```

Retention rate is calculated as:

```text
Customers from cohort active in a given month
--------------------------------------------- × 100
Original cohort size
```

The SQL produces both:

- Long-form cohort retention results
- A retention matrix for easier reporting

---

## 👥 RFM Customer Segmentation

RFM stands for:

- **R - Recency**
- **F - Frequency**
- **M - Monetary Value**

### Recency

Measures how recently a customer made a completed purchase.

```text
Recency = Analysis Date - Last Completed Purchase
```

### Frequency

Measures the number of completed orders placed by a customer.

### Monetary

Measures the customer's total completed-order revenue.

Customers are scored using `NTILE(5)` and then grouped into business-friendly segments.

---

## 🏷️ Customer Segments

### Champions

Customers with strong recency, frequency, and monetary scores.

**Recommended action:**  
Offer VIP rewards, loyalty benefits, and early product access.

### Loyal Customers

Customers who purchase frequently and remain active.

**Recommended action:**  
Use referral incentives and personalized offers.

### At-Risk High Value

Historically valuable customers with poor recent activity.

**Recommended action:**  
Launch personalized win-back campaigns.

### Recent Customers

Customers with strong recency but limited purchase history.

**Recommended action:**  
Encourage a second purchase.

### Developing Customers

Customers who do not yet fit higher-value segments.

**Recommended action:**  
Use product recommendations and engagement campaigns.

---

## 📦 Product Analytics

The project measures:

- Units sold by category
- Revenue by product category
- Revenue by product
- Best-performing products

This can support:

- Merchandising decisions
- Marketing priorities
- Inventory planning
- Product promotion strategy

---

## 📈 Monthly Revenue Analysis

The project calculates monthly:

- Completed orders
- Revenue
- Average order value

It also uses `LAG()` to calculate month-over-month revenue growth.

```text
Current Month Revenue
        ↓
Previous Month Revenue
        ↓
Growth %
```

---

## 🔁 Repeat Purchase Analysis

Repeat purchase rate measures how many purchasing customers placed at least two completed orders.

```text
Customers with 2+ Completed Orders
---------------------------------- × 100
Customers with 1+ Completed Order
```

This metric helps evaluate customer retention and purchasing behavior.

---

## ✅ Data Quality Checks

The project includes validation queries for:

- Invalid quantity values
- Invalid prices
- Invalid discounts
- Customers without orders
- Orders without items
- Completed orders with non-positive revenue
- RFM customer coverage
- Revenue reconciliation

---

## 🧾 Revenue Reconciliation

Revenue is calculated using two separate approaches:

1. Order-level analytical view
2. Direct item-level calculation

The totals are compared to ensure consistency.

Possible result:

```text
RECONCILED
```

or:

```text
REVIEW REQUIRED
```

This demonstrates an important analytics engineering practice: **never trust a metric without validating it**.

---

## 🧠 SQL Concepts Demonstrated

This project uses:

- Relational schema design
- Primary keys
- Foreign keys
- `CHECK` constraints
- `JOIN`
- `LEFT JOIN`
- Aggregation
- `GROUP BY`
- `CASE`
- CTEs
- Window functions
- `LAG()`
- `NTILE()`
- `DATEDIFF()`
- `TIMESTAMPDIFF()`
- `DATE_FORMAT()`
- Reusable views
- Conditional aggregation
- Revenue reconciliation
- Data quality checks

---

## 🛠️ Technologies

- MySQL 8.0+
- SQL
- MySQL Workbench
- Git
- GitHub

---

## 📚 Project Documentation

The repository includes supporting documentation to make the analysis, database design, and results easier to review.

| File | Purpose |
|---|---|
| [`README.md`](README.md) | Main project overview, methodology, and analytical workflow |
| [`queries.sql`](queries.sql) | Complete MySQL database setup and analytical queries |
| [`DATA_DICTIONARY.md`](DATA_DICTIONARY.md) | Table, column, constraint, and relationship documentation |
| [`ER_DIAGRAM.md`](ER_DIAGRAM.md) | Entity Relationship Diagram and database relationship overview |
| [`RESULTS.md`](RESULTS.md) | Key KPIs, analytical findings, and business insights |
| [`data/`](data/) | Reusable CSV datasets used by the SQL analytics project |
| [`outputs/`](outputs/) | Exported SQL analysis results including KPIs, monthly revenue, and product/category performance |

---

## 📁 Project Structure

```text
E-Commerce-Customer-Analytics-SQL/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
│
├── outputs/
│   ├── executive_kpis.csv
│   ├── monthly_revenue.csv
│   ├── product_performance.csv
│   └── category_performance.csv
│
├── README.md
├── queries.sql
├── DATA_DICTIONARY.md
├── ER_DIAGRAM.md
├── RESULTS.md
└── LICENSE
```

### Quick Navigation

- 📊 [View Analysis Results](RESULTS.md)
- 🧩 [View ER Diagram](ER_DIAGRAM.md)
- 📚 [View Data Dictionary](DATA_DICTIONARY.md)
- 📁 [View Dataset](data/)
- 💻 [View SQL Queries](queries.sql)
- 📤 [View Analysis Outputs](outputs/)

## 📤 Analysis Outputs

The `outputs/` folder contains reusable CSV exports generated from the SQL analysis.

Available outputs include:

- Executive business KPIs
- Monthly revenue performance
- Product-level performance
- Category-level performance

These files make it easier to reuse the SQL results in tools such as Excel, Python, Power BI, or Tableau.

---

## ▶️ How to Run

1. Open MySQL Workbench or another MySQL 8.0+ client.
2. Open `queries.sql`.
3. Run the script from the beginning.
4. The script creates its own project database.
5. Execute the analytical sections to inspect the results.

The script contains:

- Database setup
- Schema creation
- Synthetic data
- Data quality checks
- Revenue analysis
- Product analysis
- Customer analysis
- Cohort retention
- RFM segmentation
- Business recommendations
- Final validation

---

## 📌 Analytical Assumptions

- Only `COMPLETED` orders count toward revenue.
- Cancelled and pending orders are excluded from customer value metrics.
- Discounts are applied at the order-item level.
- Historical item prices are used for revenue calculations.
- Customer cohorts are based on first completed purchase.
- The fixed RFM analysis date is `2026-10-01`.
- Customers without completed purchases are excluded from RFM scoring.
- All financial values are assumed to be in INR.
- The dataset is synthetic and created for educational purposes.

---

## ⚠️ Project Limitations

This project uses a small synthetic dataset, so it is designed to demonstrate analytical methodology rather than production-scale performance.

Current limitations include:

- No real customer data
- No payment information
- No shipping costs
- No profit-margin calculations
- No marketing acquisition cost
- No predictive churn model
- No large-scale performance benchmarking

Because the dataset is small, some RFM bucket boundaries and cohort percentages can be sensitive to individual customers.

---

## 🚀 Future Improvements

Potential extensions include:

- Power BI dashboard
- Larger real-world dataset
- Customer acquisition channels
- Profit and margin analysis
- Customer acquisition cost
- Predicted customer lifetime value
- Churn prediction
- Revenue forecasting
- Marketing campaign analysis
- Automated reporting pipeline

---

## 🎯 Skills Demonstrated

This project demonstrates practical experience with:

- SQL data analysis
- Business KPI development
- Customer analytics
- Cohort analysis
- RFM segmentation
- Revenue analysis
- Analytical data modeling
- Data quality validation
- Business problem solving
- Translating SQL results into business actions

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

You are free to use, modify, and distribute the project in accordance with the license terms.

---

## 👨‍💻 Author

**Bhavesh Pawar**

Final-year B.Tech student specializing in **Artificial Intelligence & Data Science**, with interests in:

- Data Analytics
- SQL
- Python
- Machine Learning
- Data Engineering
- Business Intelligence

### Connect

**GitHub:**  
https://github.com/bhaveshpawar937-0948

**LinkedIn:**  
https://www.linkedin.com/in/bhavesh-pawar-ai/

---

## ⭐ Project Summary

```text
E-Commerce Data
      ↓
SQL Data Modeling
      ↓
Revenue Analysis
      ↓
Customer Behavior
      ↓
Cohort Retention
      ↓
RFM Segmentation
      ↓
Business Recommendations
```

This project demonstrates how SQL can move beyond simple querying and become a practical tool for **customer intelligence and business decision-making**.
