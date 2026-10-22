\# 📚 Data Dictionary



This document describes the database tables and columns used in the \*\*E-Commerce Customer Analytics \& Retention Intelligence\*\* project.



\---



\## 👤 customers



Stores basic customer information.



| Column | Data Type | Description |

|---|---|---|

| `customer\_id` | INT | Unique identifier for each customer |

| `customer\_name` | VARCHAR(100) | Customer's full name |

| `city` | VARCHAR(60) | Customer's city |

| `signup\_date` | DATE | Date when the customer joined |



\*\*Primary Key:\*\* `customer\_id`



\---



\## 📦 products



Stores product information used in customer orders.



| Column | Data Type | Description |

|---|---|---|

| `product\_id` | INT | Unique identifier for each product |

| `product\_name` | VARCHAR(100) | Name of the product |

| `category` | VARCHAR(50) | Product category |

| `list\_price` | DECIMAL(10,2) | Standard listed price of the product |



\*\*Primary Key:\*\* `product\_id`



\### Constraint



`list\_price` must be greater than zero.



\---



\## 🧾 orders



Stores order-level information.



| Column | Data Type | Description |

|---|---|---|

| `order\_id` | INT | Unique identifier for each order |

| `customer\_id` | INT | Customer who placed the order |

| `order\_date` | DATE | Date when the order was placed |

| `order\_status` | VARCHAR(20) | Current status of the order |



\*\*Primary Key:\*\* `order\_id`



\*\*Foreign Key:\*\* `customer\_id` → `customers.customer\_id`



\### Allowed Order Status Values



\- `COMPLETED`

\- `CANCELLED`

\- `PENDING`



Only completed orders are included in recognized revenue calculations.



\---



\## 🛒 order\_items



Stores individual products included within each order.



| Column | Data Type | Description |

|---|---|---|

| `order\_item\_id` | INT | Unique identifier for an order item |

| `order\_id` | INT | Order containing the item |

| `product\_id` | INT | Product purchased |

| `quantity` | INT | Number of units purchased |

| `unit\_price` | DECIMAL(10,2) | Product price at the time of purchase |

| `discount\_percent` | DECIMAL(5,2) | Percentage discount applied to the item |



\*\*Primary Key:\*\* `order\_item\_id`



\*\*Foreign Keys:\*\*



\- `order\_id` → `orders.order\_id`

\- `product\_id` → `products.product\_id`



\### Constraints



\- `quantity > 0`

\- `unit\_price > 0`

\- `discount\_percent BETWEEN 0 AND 100`



\---



\## 🔗 Database Relationships



```text

customers

&#x20;   │

&#x20;   │ 1

&#x20;   │

&#x20;   └────────< orders

&#x20;                 │

&#x20;                 │ 1

&#x20;                 │

&#x20;                 └────────< order\_items >──────── products

```



A customer can place multiple orders.



An order can contain multiple order items.



Each order item references one product.



\---



\## 💰 Revenue Calculation



Revenue is calculated at the order-item level:



```text

Revenue =

Quantity × Unit Price × (1 - Discount Percentage / 100)

```



Only items belonging to `COMPLETED` orders contribute to business revenue.



\---



\## 📊 Analytical Views



The project also creates reusable SQL views.



\### `order\_facts`



Provides order-level analytical information including calculated order revenue.



\### `customer\_value`



Provides customer-level metrics including:



\- Completed orders

\- Lifetime revenue

\- Last completed purchase date



\### `rfm\_scores`



Provides customer-level RFM metrics:



\- Recency

\- Frequency

\- Monetary value

\- Recency score

\- Frequency score

\- Monetary score



\---



\## 🎯 Purpose



This data dictionary makes the database structure easier to understand and provides documentation for analysts, developers, and anyone reviewing the project.

