\# 🧩 E-Commerce Database ER Diagram



This document shows the relational structure used in the \*\*E-Commerce Customer Analytics \& Retention Intelligence\*\* project.



\---



\## 📊 Entity Relationship Diagram



```mermaid

erDiagram



&#x20;   CUSTOMERS ||--o{ ORDERS : places

&#x20;   ORDERS ||--|{ ORDER\_ITEMS : contains

&#x20;   PRODUCTS ||--o{ ORDER\_ITEMS : included\_in



&#x20;   CUSTOMERS {

&#x20;       INT customer\_id PK

&#x20;       VARCHAR customer\_name

&#x20;       VARCHAR city

&#x20;       DATE signup\_date

&#x20;   }



&#x20;   PRODUCTS {

&#x20;       INT product\_id PK

&#x20;       VARCHAR product\_name

&#x20;       VARCHAR category

&#x20;       DECIMAL list\_price

&#x20;   }



&#x20;   ORDERS {

&#x20;       INT order\_id PK

&#x20;       INT customer\_id FK

&#x20;       DATE order\_date

&#x20;       VARCHAR order\_status

&#x20;   }



&#x20;   ORDER\_ITEMS {

&#x20;       INT order\_item\_id PK

&#x20;       INT order\_id FK

&#x20;       INT product\_id FK

&#x20;       INT quantity

&#x20;       DECIMAL unit\_price

&#x20;       DECIMAL discount\_percent

&#x20;   }

```



\---



\## 🔗 Relationships



\### Customers → Orders



One customer can place multiple orders.



```text

CUSTOMERS 1 ───────< MANY ORDERS

```



The relationship is created using:



```text

orders.customer\_id → customers.customer\_id

```



\---



\### Orders → Order Items



One order can contain multiple products.



```text

ORDERS 1 ───────< MANY ORDER\_ITEMS

```



The relationship is created using:



```text

order\_items.order\_id → orders.order\_id

```



\---



\### Products → Order Items



One product can appear in many different orders.



```text

PRODUCTS 1 ───────< MANY ORDER\_ITEMS

```



The relationship is created using:



```text

order\_items.product\_id → products.product\_id

```



\---



\## 🧠 Why `order\_items` Is Important



The `order\_items` table acts as the bridge between orders and products.



Without it, a single order would be limited to one product.



Using `order\_items` allows the database to support:



\- Multiple products per order

\- Different quantities

\- Historical product prices

\- Item-level discounts

\- Product-level revenue analysis



\---



\## 🔑 Primary Keys



| Table | Primary Key |

|---|---|

| `customers` | `customer\_id` |

| `products` | `product\_id` |

| `orders` | `order\_id` |

| `order\_items` | `order\_item\_id` |



\---



\## 🔗 Foreign Keys



| Table | Foreign Key | References |

|---|---|---|

| `orders` | `customer\_id` | `customers.customer\_id` |

| `order\_items` | `order\_id` | `orders.order\_id` |

| `order\_items` | `product\_id` | `products.product\_id` |



\---



\## 💰 Analytical Flow



The schema supports the following analytical path:



```text

Customer

&#x20;  ↓

Order

&#x20;  ↓

Order Items

&#x20;  ↓

Products

&#x20;  ↓

Revenue Calculation

&#x20;  ↓

Customer \& Product Analytics

```



This relational structure enables revenue analysis, customer lifetime value, product performance, cohort retention, and RFM customer segmentation.

