\# 📊 E-Commerce Analytics Results



This document summarizes the key findings generated from the \*\*E-Commerce Customer Analytics \& Retention Intelligence\*\* SQL project.



The analysis uses synthetic transactional data and considers only `COMPLETED` orders when calculating recognized revenue and customer value.



\---



\## 🏆 Executive KPI Summary



| KPI | Result |

|---|---:|

| Total Customers | 12 |

| Purchasing Customers | 11 |

| Completed Orders | 24 |

| Total Revenue | ₹53,375.00 |

| Average Order Value | ₹2,223.96 |

| Repeat Customers | 9 |

| Repeat Purchase Rate | 81.82% |



The dataset generated \*\*₹53,375 in completed-order revenue\*\* across 24 completed transactions.



Nine of the eleven purchasing customers placed at least two completed orders, producing a strong \*\*81.82% repeat purchase rate\*\* within the synthetic dataset.



\---



\## 📈 Monthly Revenue Performance



| Month | Completed Orders | Revenue |

|---|---:|---:|

| January 2026 | 2 | ₹3,500 |

| February 2026 | 2 | ₹6,000 |

| March 2026 | 2 | ₹4,700 |

| April 2026 | 3 | ₹5,400 |

| May 2026 | 3 | ₹5,620 |

| June 2026 | 2 | ₹2,700 |

| July 2026 | 2 | ₹4,800 |

| August 2026 | 2 | ₹4,020 |

| September 2026 | 6 | ₹16,635 |



\### Key Finding



\*\*September 2026 was the strongest revenue month\*\*, generating ₹16,635 from six completed orders.



September alone represented approximately \*\*31.17% of total completed-order revenue\*\* in the dataset.



\---



\## 👤 Highest-Value Customers



| Rank | Customer | Completed Orders | Lifetime Revenue |

|---|---|---:|---:|

| 1 | Asha Sharma | 4 | ₹11,310 |

| 2 | Priya Singh | 3 | ₹8,175 |

| 3 | Rahul Patil | 3 | ₹7,220 |

| 4 | Rohan Mehta | 2 | ₹5,050 |

| 5 | Karan Gupta | 2 | ₹5,000 |



\### Key Finding



\*\*Asha Sharma was the highest-value customer\*\*, generating ₹11,310 across four completed purchases.



High-value repeat customers represent strong candidates for loyalty programs, personalized promotions, and VIP retention strategies.



\---



\## 📦 Product Performance



| Product | Category | Units Sold | Revenue |

|---|---|---:|---:|

| Smart Watch | Electronics | 5 | ₹16,625 |

| Mechanical Keyboard | Electronics | 4 | ₹10,640 |

| Wireless Earbuds | Electronics | 6 | ₹8,850 |

| Office Backpack | Accessories | 4 | ₹7,900 |

| Laptop Stand | Accessories | 5 | ₹5,760 |

| Notebook Set | Stationery | 9 | ₹3,600 |



\### Key Finding



The \*\*Smart Watch\*\* generated the highest product revenue at \*\*₹16,625\*\*.



Although the Notebook Set had the highest number of units among some lower-priced products, its lower unit price resulted in substantially lower revenue.



This demonstrates why both \*\*sales volume and revenue contribution\*\* should be considered when evaluating product performance.



\---



\## 🗂️ Category Performance



| Category | Units Sold | Revenue |

|---|---:|---:|

| Electronics | 15 | ₹36,115 |

| Accessories | 9 | ₹13,660 |

| Stationery | 9 | ₹3,600 |



\### Key Finding



\*\*Electronics dominated revenue performance\*\*, generating ₹36,115.



This represents approximately \*\*67.66% of total completed-order revenue\*\*.



Electronics therefore represents the most commercially important category in the current dataset.



\---



\## 🔁 Repeat Purchase Behavior



The project identified:



```text

Purchasing Customers: 11

Repeat Customers:      9

Repeat Purchase Rate:  81.82%

```



A repeat customer is defined as a customer with at least \*\*two completed orders\*\*.



The high repeat purchase rate indicates strong recurring purchasing behavior within the synthetic dataset.



In a real business environment, this metric would be useful for measuring customer loyalty and evaluating retention strategies.



\---



\## 📅 Cohort Retention Insights



Customers were assigned to cohorts based on the month of their \*\*first completed purchase\*\*.



Each cohort was then analyzed to determine whether customers returned in later months.



For example, the January 2026 cohort contained two customers.



```text

Month 0 → 100% active

Month 1 → 50% active

Month 2 → 50% active

```



The analysis demonstrates how SQL can be used to move beyond transaction reporting and evaluate \*\*customer retention over time\*\*.



Because the dataset is intentionally small, cohort percentages can change significantly based on the activity of a single customer.



\---



\## 👥 RFM Segmentation



Customers were evaluated using three dimensions:



| Dimension | Meaning |

|---|---|

| Recency | How recently the customer purchased |

| Frequency | How many completed purchases they made |

| Monetary | How much completed-order revenue they generated |



The project uses `NTILE(5)` to assign Recency, Frequency, and Monetary scores.



These scores are then converted into customer segments such as:



```text

Champions

Loyal Customers

At-Risk High Value

Recent Customers

Developing Customers

```



This enables customer-level marketing strategies instead of treating every customer identically.



\---



\## 💡 Business Interpretation



The results suggest that the business should prioritize its \*\*Electronics category\*\*, which contributes the majority of revenue.



High-value repeat customers should receive loyalty and retention incentives, while valuable customers with declining activity should be targeted using personalized win-back campaigns.



Recent customers should be encouraged to make a second purchase, since converting first-time buyers into repeat customers can improve long-term customer value.



Product performance should be evaluated using both units sold and revenue because high-volume products are not necessarily the highest-revenue products.



\---



\## ✅ Revenue Validation



Revenue was independently calculated using:



```text

Order-Level Revenue View

&#x20;       ↓

Compared Against

&#x20;       ↓

Direct Order-Item Revenue Calculation

```



The project verifies that both calculations produce the same total.



```text

Revenue Reconciliation Status: RECONCILED

```



This validation helps ensure that the reported KPIs are based on consistent calculations.



\---



\## 🎯 Final Conclusion



The project demonstrates how SQL can transform transactional e-commerce data into decision-ready business information.



Starting from relational tables, the analysis progresses through revenue modeling, customer value analysis, product performance, cohort retention, RFM segmentation, and business recommendations.



\### Final Analytical Flow



```text

Raw Transactions

&#x20;      ↓

Validated Data

&#x20;      ↓

Revenue Model

&#x20;      ↓

Business KPIs

&#x20;      ↓

Customer Analytics

&#x20;      ↓

Retention Analysis

&#x20;      ↓

RFM Segmentation

&#x20;      ↓

Business Recommendations

```



The final result is a reusable SQL analytics workflow that demonstrates practical skills relevant to \*\*Data Analyst, SQL Analyst, Business Intelligence, and Data Engineering roles\*\*.

