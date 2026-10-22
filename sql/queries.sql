-- ============================================================
-- E-COMMERCE CUSTOMER ANALYTICS & RETENTION INTELLIGENCE
--
-- Author: Bhavesh Pawar
-- Database: MySQL 8.0+
-- Dataset: Synthetic E-Commerce Data
-- Currency: INR
-- Analysis Date: 2026-10-01
--
-- Analytical Focus:
-- 1. Business KPI Development
-- 2. Revenue Analytics
-- 3. Customer Behavior Analysis
-- 4. Cohort Retention Analysis
-- 5. RFM Customer Segmentation
-- 6. Data Quality Reconciliation
-- ============================================================


CREATE DATABASE IF NOT EXISTS ecommerce_customer_analytics;

USE ecommerce_customer_analytics;


-- ============================================================
-- SECTION 1: RESET PROJECT OBJECTS
-- ============================================================

-- Remove analytical views before dropping their tables.

DROP VIEW IF EXISTS rfm_scores;

DROP VIEW IF EXISTS customer_value;

DROP VIEW IF EXISTS order_facts;


-- Drop tables in foreign key dependency order.

DROP TABLE IF EXISTS order_items;

DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS customers;


-- ============================================================
-- SECTION 2: DATABASE SCHEMA
-- ============================================================


-- ------------------------------------------------------------
-- 1. Customers Table
-- ------------------------------------------------------------

CREATE TABLE customers (

    customer_id INT PRIMARY KEY,

    customer_name VARCHAR(100) NOT NULL,

    city VARCHAR(60) NOT NULL,

    signup_date DATE NOT NULL

) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 2. Products Table
-- ------------------------------------------------------------

CREATE TABLE products (

    product_id INT PRIMARY KEY,

    product_name VARCHAR(100) NOT NULL,

    category VARCHAR(50) NOT NULL,

    list_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_product_price
        CHECK (list_price > 0)

) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 3. Orders Table
-- ------------------------------------------------------------

CREATE TABLE orders (

    order_id INT PRIMARY KEY,

    customer_id INT NOT NULL,

    order_date DATE NOT NULL,

    order_status VARCHAR(20) NOT NULL,

    CONSTRAINT chk_order_status
        CHECK (
            order_status IN (
                'COMPLETED',
                'CANCELLED',
                'PENDING'
            )
        ),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)

) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 4. Order Items Table
-- ------------------------------------------------------------

CREATE TABLE order_items (

    order_item_id INT PRIMARY KEY,

    order_id INT NOT NULL,

    product_id INT NOT NULL,

    quantity INT NOT NULL,

    unit_price DECIMAL(10,2) NOT NULL,

    discount_percent DECIMAL(5,2)
        NOT NULL DEFAULT 0,

    CONSTRAINT chk_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_unit_price
        CHECK (unit_price > 0),

    CONSTRAINT chk_discount
        CHECK (
            discount_percent
            BETWEEN 0 AND 100
        ),

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)

) ENGINE = InnoDB;


-- ============================================================
-- SECTION 3: INSERT SYNTHETIC DATA
-- ============================================================


-- ------------------------------------------------------------
-- 5. Insert Customers
-- ------------------------------------------------------------

INSERT INTO customers (
    customer_id,
    customer_name,
    city,
    signup_date
)
VALUES

(1, 'Asha Sharma', 'Mumbai', '2025-12-10'),

(2, 'Rahul Patil', 'Pune', '2025-12-15'),

(3, 'Priya Singh', 'Navi Mumbai', '2026-01-10'),

(4, 'Aman Khan', 'Thane', '2026-02-01'),

(5, 'Neha Joshi', 'Mumbai', '2026-03-05'),

(6, 'Rohan Mehta', 'Pune', '2026-03-10'),

(7, 'Sneha Kulkarni', 'Navi Mumbai', '2026-04-01'),

(8, 'Arjun Desai', 'Mumbai', '2026-05-05'),

(9, 'Pooja Shah', 'Thane', '2026-06-01'),

(10, 'Karan Gupta', 'Pune', '2026-07-01'),

(11, 'Meera Nair', 'Mumbai', '2026-08-05'),

(12, 'Vikram Rao', 'Navi Mumbai', '2026-08-15');


-- ------------------------------------------------------------
-- 6. Insert Products
-- ------------------------------------------------------------

INSERT INTO products (
    product_id,
    product_name,
    category,
    list_price
)
VALUES

(101, 'Wireless Earbuds', 'Electronics', 1500),

(102, 'Smart Watch', 'Electronics', 3500),

(103, 'Laptop Stand', 'Accessories', 1200),

(104, 'Office Backpack', 'Accessories', 2000),

(105, 'Mechanical Keyboard', 'Electronics', 2800),

(106, 'Notebook Set', 'Stationery', 400);


-- ------------------------------------------------------------
-- 7. Insert Orders
-- ------------------------------------------------------------

INSERT INTO orders (
    order_id,
    customer_id,
    order_date,
    order_status
)
VALUES

(1, 1, '2026-01-05', 'COMPLETED'),
(2, 1, '2026-02-10', 'COMPLETED'),
(3, 1, '2026-05-15', 'COMPLETED'),
(4, 1, '2026-09-12', 'COMPLETED'),

(5, 2, '2026-01-15', 'COMPLETED'),
(6, 2, '2026-03-20', 'COMPLETED'),
(7, 2, '2026-08-10', 'COMPLETED'),

(8, 3, '2026-02-05', 'COMPLETED'),
(9, 3, '2026-04-10', 'COMPLETED'),
(10, 3, '2026-09-18', 'COMPLETED'),

(11, 4, '2026-03-05', 'COMPLETED'),
(12, 4, '2026-05-20', 'COMPLETED'),

(13, 5, '2026-04-01', 'COMPLETED'),
(14, 5, '2026-07-15', 'COMPLETED'),

(15, 6, '2026-04-12', 'COMPLETED'),
(16, 6, '2026-09-05', 'COMPLETED'),

(17, 7, '2026-05-10', 'COMPLETED'),
(18, 7, '2026-06-20', 'COMPLETED'),

(19, 8, '2026-06-05', 'COMPLETED'),
(20, 8, '2026-09-22', 'COMPLETED'),

(21, 9, '2026-07-08', 'COMPLETED'),

(22, 10, '2026-08-02', 'COMPLETED'),
(23, 10, '2026-09-25', 'COMPLETED'),

(24, 11, '2026-09-10', 'COMPLETED'),

(25, 12, '2026-09-15', 'CANCELLED'),

(26, 12, '2026-09-20', 'PENDING'),

(27, 1, '2026-09-28', 'CANCELLED');


-- ------------------------------------------------------------
-- 8. Insert Order Items
-- ------------------------------------------------------------

INSERT INTO order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percent
)
VALUES

(1, 1, 101, 1, 1500, 0),
(2, 1, 106, 2, 400, 0),

(3, 2, 102, 1, 3500, 10),

(4, 3, 105, 1, 2800, 5),

(5, 4, 104, 1, 2000, 0),
(6, 4, 103, 1, 1200, 0),

(7, 5, 103, 1, 1200, 0),

(8, 6, 102, 1, 3500, 0),

(9, 7, 105, 1, 2800, 10),

(10, 8, 101, 2, 1500, 5),

(11, 9, 104, 1, 2000, 0),

(12, 10, 102, 1, 3500, 5),

(13, 11, 106, 3, 400, 0),

(14, 12, 103, 2, 1200, 10),

(15, 13, 101, 1, 1500, 0),

(16, 14, 105, 1, 2800, 0),

(17, 15, 104, 1, 2000, 5),

(18, 16, 102, 1, 3500, 10),

(19, 17, 106, 2, 400, 0),

(20, 18, 101, 1, 1500, 0),

(21, 19, 103, 1, 1200, 0),

(22, 20, 105, 1, 2800, 5),

(23, 21, 104, 1, 2000, 0),

(24, 22, 101, 1, 1500, 0),

(25, 23, 102, 1, 3500, 0),

(26, 24, 106, 2, 400, 0),

(27, 25, 105, 1, 2800, 0),

(28, 26, 101, 1, 1500, 0),

(29, 27, 102, 1, 3500, 0);


-- ============================================================
-- SECTION 4: DATA QUALITY CHECKS
-- ============================================================


-- ------------------------------------------------------------
-- 9. Check Dataset Size
-- ------------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM customers)
        AS total_customers,

    (SELECT COUNT(*) FROM products)
        AS total_products,

    (SELECT COUNT(*) FROM orders)
        AS total_orders,

    (SELECT COUNT(*) FROM order_items)
        AS total_order_items;


-- ------------------------------------------------------------
-- 10. Check Invalid Item Values
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS invalid_item_count
FROM order_items
WHERE quantity <= 0
   OR unit_price <= 0
   OR discount_percent NOT BETWEEN 0 AND 100;


-- ------------------------------------------------------------
-- 11. Identify Customers Without Orders
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- ------------------------------------------------------------
-- 12. Identify Orders Without Items
-- ------------------------------------------------------------

SELECT
    o.order_id,
    o.customer_id,
    o.order_status
FROM orders AS o
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE oi.order_item_id IS NULL;


-- ============================================================
-- SECTION 5: ORDER-LEVEL REVENUE MODEL
-- ============================================================


-- ------------------------------------------------------------
-- 13. Create Reusable Order Facts View
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW order_facts AS

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,

    SUM(
        ROUND(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100),
            2
        )
    ) AS order_revenue

FROM orders AS o

JOIN order_items AS oi
    ON o.order_id = oi.order_id

GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status;


-- ------------------------------------------------------------
-- 14. Inspect Order Revenue
-- ------------------------------------------------------------

SELECT *
FROM order_facts
ORDER BY order_id;


-- ============================================================
-- SECTION 6: EXECUTIVE BUSINESS KPIs
-- ============================================================


-- ------------------------------------------------------------
-- 15. Total Revenue, Orders and Average Order Value
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS completed_orders,

    ROUND(
        SUM(order_revenue),
        2
    ) AS total_revenue,

    ROUND(
        AVG(order_revenue),
        2
    ) AS average_order_value,

    COUNT(DISTINCT customer_id)
        AS purchasing_customers

FROM order_facts

WHERE order_status = 'COMPLETED';


-- ------------------------------------------------------------
-- 16. Order Status Distribution
-- ------------------------------------------------------------

SELECT
    order_status,

    COUNT(*) AS order_count,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders

FROM orders

GROUP BY order_status

ORDER BY order_count DESC;


-- ============================================================
-- SECTION 7: MONTHLY REVENUE ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- 17. Monthly Revenue and Order Volume
-- ------------------------------------------------------------

SELECT
    DATE_FORMAT(
        order_date,
        '%Y-%m'
    ) AS order_month,

    COUNT(*) AS completed_orders,

    ROUND(
        SUM(order_revenue),
        2
    ) AS monthly_revenue,

    ROUND(
        AVG(order_revenue),
        2
    ) AS average_order_value

FROM order_facts

WHERE order_status = 'COMPLETED'

GROUP BY
    DATE_FORMAT(order_date, '%Y-%m')

ORDER BY order_month;


-- ------------------------------------------------------------
-- 18. Month-over-Month Revenue Growth
-- ------------------------------------------------------------

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(
            order_date,
            '%Y-%m'
        ) AS order_month,

        SUM(order_revenue) AS revenue

    FROM order_facts

    WHERE order_status = 'COMPLETED'

    GROUP BY
        DATE_FORMAT(order_date, '%Y-%m')

),

revenue_comparison AS (

    SELECT
        order_month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue

    FROM monthly_revenue

)

SELECT
    order_month,

    ROUND(revenue, 2)
        AS current_revenue,

    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,

    ROUND(
        (
            revenue - previous_month_revenue
        ) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_percent

FROM revenue_comparison

ORDER BY order_month;


-- ============================================================
-- SECTION 8: PRODUCT AND CATEGORY ANALYTICS
-- ============================================================


-- ------------------------------------------------------------
-- 19. Revenue by Product Category
-- ------------------------------------------------------------

SELECT
    p.category,

    SUM(oi.quantity)
        AS units_sold,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS category_revenue

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'COMPLETED'

GROUP BY p.category

ORDER BY category_revenue DESC;


-- ------------------------------------------------------------
-- 20. Top Revenue-Generating Products
-- ------------------------------------------------------------

SELECT
    p.product_name,
    p.category,

    SUM(oi.quantity)
        AS total_units_sold,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS product_revenue

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'COMPLETED'

GROUP BY
    p.product_id,
    p.product_name,
    p.category

ORDER BY product_revenue DESC;


-- ============================================================
-- SECTION 9: CUSTOMER VALUE MODEL
-- ============================================================


-- ------------------------------------------------------------
-- 21. Create Customer Value View
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW customer_value AS

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    COUNT(
        CASE
            WHEN f.order_status = 'COMPLETED'
            THEN f.order_id
        END
    ) AS completed_orders,

    ROUND(
        COALESCE(
            SUM(
                CASE
                    WHEN f.order_status = 'COMPLETED'
                    THEN f.order_revenue
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS lifetime_revenue,

    MAX(
        CASE
            WHEN f.order_status = 'COMPLETED'
            THEN f.order_date
        END
    ) AS last_completed_order

FROM customers AS c

LEFT JOIN order_facts AS f
    ON c.customer_id = f.customer_id

GROUP BY
    c.customer_id,
    c.customer_name,
    c.city;


-- ------------------------------------------------------------
-- 22. Customer Lifetime Revenue
-- ------------------------------------------------------------

SELECT
    customer_id,
    customer_name,
    city,
    completed_orders,
    lifetime_revenue,
    last_completed_order

FROM customer_value

ORDER BY lifetime_revenue DESC;


-- ------------------------------------------------------------
-- 23. Top Five Customers
-- ------------------------------------------------------------

SELECT
    customer_name,
    completed_orders,
    lifetime_revenue

FROM customer_value

WHERE completed_orders > 0

ORDER BY lifetime_revenue DESC

LIMIT 5;


-- ------------------------------------------------------------
-- 24. Repeat Purchase Rate
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS purchasing_customers,

    SUM(
        CASE
            WHEN completed_orders >= 2
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN completed_orders >= 2
                THEN 1
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_purchase_rate

FROM customer_value

WHERE completed_orders > 0;


-- ============================================================
-- SECTION 10: COHORT RETENTION ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- 25. Identify First Completed Purchase
-- ------------------------------------------------------------

SELECT
    customer_id,

    MIN(order_date)
        AS first_purchase_date,

    DATE_FORMAT(
        MIN(order_date),
        '%Y-%m'
    ) AS cohort_month

FROM orders

WHERE order_status = 'COMPLETED'

GROUP BY customer_id

ORDER BY first_purchase_date;


-- ------------------------------------------------------------
-- 26. Monthly Cohort Retention Analysis
-- ------------------------------------------------------------

WITH first_purchase AS (

    SELECT
        customer_id,

        DATE_FORMAT(
            MIN(order_date),
            '%Y-%m-01'
        ) AS cohort_month

    FROM orders

    WHERE order_status = 'COMPLETED'

    GROUP BY customer_id

),

monthly_activity AS (

    SELECT DISTINCT
        customer_id,

        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month

    FROM orders

    WHERE order_status = 'COMPLETED'

),

cohort_activity AS (

    SELECT
        fp.customer_id,
        fp.cohort_month,

        TIMESTAMPDIFF(
            MONTH,
            CAST(fp.cohort_month AS DATE),
            CAST(ma.activity_month AS DATE)
        ) AS month_number

    FROM first_purchase AS fp

    JOIN monthly_activity AS ma
        ON fp.customer_id = ma.customer_id

),

cohort_sizes AS (

    SELECT
        cohort_month,

        COUNT(*) AS cohort_size

    FROM first_purchase

    GROUP BY cohort_month

)

SELECT
    ca.cohort_month,

    cs.cohort_size,

    ca.month_number,

    COUNT(DISTINCT ca.customer_id)
        AS active_customers,

    ROUND(
        COUNT(DISTINCT ca.customer_id)
        * 100.0
        / cs.cohort_size,
        2
    ) AS retention_percentage

FROM cohort_activity AS ca

JOIN cohort_sizes AS cs
    ON ca.cohort_month = cs.cohort_month

GROUP BY
    ca.cohort_month,
    cs.cohort_size,
    ca.month_number

ORDER BY
    ca.cohort_month,
    ca.month_number;


-- ------------------------------------------------------------
-- 27. Cohort Retention Matrix
-- ------------------------------------------------------------

WITH first_purchase AS (

    SELECT
        customer_id,

        DATE_FORMAT(
            MIN(order_date),
            '%Y-%m-01'
        ) AS cohort_month

    FROM orders

    WHERE order_status = 'COMPLETED'

    GROUP BY customer_id

),

monthly_activity AS (

    SELECT DISTINCT
        customer_id,

        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month

    FROM orders

    WHERE order_status = 'COMPLETED'

),

cohort_months AS (

    SELECT
        fp.customer_id,
        fp.cohort_month,

        TIMESTAMPDIFF(
            MONTH,
            CAST(fp.cohort_month AS DATE),
            CAST(ma.activity_month AS DATE)
        ) AS month_number

    FROM first_purchase AS fp

    JOIN monthly_activity AS ma
        ON fp.customer_id = ma.customer_id

),

cohort_sizes AS (

    SELECT
        cohort_month,
        COUNT(*) AS cohort_size

    FROM first_purchase

    GROUP BY cohort_month

)

SELECT
    cm.cohort_month,

    cs.cohort_size,

    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN month_number = 0
                THEN customer_id
            END
        ) / cs.cohort_size,
        2
    ) AS month_0,

    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN month_number = 1
                THEN customer_id
            END
        ) / cs.cohort_size,
        2
    ) AS month_1,

    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN month_number = 2
                THEN customer_id
            END
        ) / cs.cohort_size,
        2
    ) AS month_2,

    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN month_number = 3
                THEN customer_id
            END
        ) / cs.cohort_size,
        2
    ) AS month_3

FROM cohort_months AS cm

JOIN cohort_sizes AS cs
    ON cm.cohort_month = cs.cohort_month

GROUP BY
    cm.cohort_month,
    cs.cohort_size

ORDER BY cm.cohort_month;


-- Note:
-- Month columns outside a cohort's observation period
-- are displayed as zero by this simple demonstration query.
-- A production retention dashboard should distinguish
-- unobserved future periods from observed zero retention.


-- ============================================================
-- SECTION 11: RFM CUSTOMER SEGMENTATION
-- ============================================================


-- ------------------------------------------------------------
-- 28. Create RFM Scoring View
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW rfm_scores AS

WITH rfm_base AS (

    SELECT
        customer_id,
        customer_name,
        city,

        DATEDIFF(
            '2026-10-01',
            last_completed_order
        ) AS recency_days,

        completed_orders AS frequency,

        lifetime_revenue AS monetary

    FROM customer_value

    WHERE completed_orders > 0

)

SELECT
    customer_id,
    customer_name,
    city,

    recency_days,
    frequency,
    monetary,

    NTILE(5) OVER (
        ORDER BY
            recency_days DESC,
            customer_id
    ) AS r_score,

    NTILE(5) OVER (
        ORDER BY
            frequency ASC,
            customer_id
    ) AS f_score,

    NTILE(5) OVER (
        ORDER BY
            monetary ASC,
            customer_id
    ) AS m_score

FROM rfm_base;


-- ------------------------------------------------------------
-- 29. Display RFM Scores
-- ------------------------------------------------------------

SELECT
    customer_name,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score

FROM rfm_scores

ORDER BY
    r_score DESC,
    f_score DESC,
    m_score DESC;


-- ------------------------------------------------------------
-- 30. Final Customer Segmentation
-- ------------------------------------------------------------

WITH customer_segments AS (

    SELECT
        customer_id,
        customer_name,
        city,

        recency_days,
        frequency,
        monetary,

        r_score,
        f_score,
        m_score,

        CASE

            WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
                THEN 'Champions'

            WHEN r_score >= 4
             AND f_score >= 3
                THEN 'Loyal Customers'

            WHEN r_score <= 2
             AND m_score >= 4
                THEN 'At-Risk High Value'

            WHEN r_score >= 4
                THEN 'Recent Customers'

            ELSE 'Developing Customers'

        END AS customer_segment

    FROM rfm_scores

)

SELECT
    customer_name,
    city,
    recency_days,
    frequency,
    monetary,

    CONCAT(
        r_score,
        f_score,
        m_score
    ) AS rfm_score,

    customer_segment

FROM customer_segments

ORDER BY
    monetary DESC,
    frequency DESC;


-- ============================================================
-- SECTION 12: BUSINESS RECOMMENDATIONS
-- ============================================================


-- ------------------------------------------------------------
-- 31. Generate Customer Marketing Recommendations
-- ------------------------------------------------------------

WITH segments AS (

    SELECT
        customer_name,
        monetary,
        recency_days,
        frequency,

        CASE

            WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
                THEN 'Champions'

            WHEN r_score >= 4
             AND f_score >= 3
                THEN 'Loyal Customers'

            WHEN r_score <= 2
             AND m_score >= 4
                THEN 'At-Risk High Value'

            WHEN r_score >= 4
                THEN 'Recent Customers'

            ELSE 'Developing Customers'

        END AS segment

    FROM rfm_scores

)

SELECT
    customer_name,
    segment,

    CASE

        WHEN segment = 'Champions'
            THEN 'Offer VIP loyalty rewards'

        WHEN segment = 'Loyal Customers'
            THEN 'Offer referral incentives'

        WHEN segment = 'At-Risk High Value'
            THEN 'Launch personalized win-back campaign'

        WHEN segment = 'Recent Customers'
            THEN 'Encourage second purchase'

        ELSE 'Send personalized product recommendations'

    END AS recommended_action

FROM segments

ORDER BY monetary DESC;


-- ============================================================
-- SECTION 13: REVENUE RECONCILIATION
-- ============================================================


-- ------------------------------------------------------------
-- 32. Verify Revenue Across Two Calculation Methods
-- ------------------------------------------------------------

WITH order_level_total AS (

    SELECT
        ROUND(
            SUM(order_revenue),
            2
        ) AS total_revenue

    FROM order_facts

    WHERE order_status = 'COMPLETED'

),

item_level_total AS (

    SELECT
        ROUND(
            SUM(
                ROUND(
                    oi.quantity
                    * oi.unit_price
                    * (
                        1
                        - oi.discount_percent / 100
                    ),
                    2
                )
            ),
            2
        ) AS total_revenue

    FROM order_items AS oi

    JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'COMPLETED'

)

SELECT
    olt.total_revenue
        AS order_level_revenue,

    ilt.total_revenue
        AS item_level_revenue,

    ROUND(
        olt.total_revenue
        - ilt.total_revenue,
        2
    ) AS revenue_difference,

    CASE

        WHEN olt.total_revenue = ilt.total_revenue
            THEN 'RECONCILED'

        ELSE 'REVIEW REQUIRED'

    END AS reconciliation_status

FROM order_level_total AS olt

CROSS JOIN item_level_total AS ilt;


-- ============================================================
-- SECTION 14: FINAL EXECUTIVE DASHBOARD
-- ============================================================


-- ------------------------------------------------------------
-- 33. Executive KPI Summary
-- ------------------------------------------------------------

WITH business_metrics AS (

    SELECT
        COUNT(*) AS completed_orders,

        COUNT(DISTINCT customer_id)
            AS purchasing_customers,

        SUM(order_revenue)
            AS total_revenue,

        AVG(order_revenue)
            AS average_order_value

    FROM order_facts

    WHERE order_status = 'COMPLETED'

),

customer_metrics AS (

    SELECT
        COUNT(*) AS total_customers,

        SUM(
            CASE
                WHEN completed_orders >= 2
                THEN 1
                ELSE 0
            END
        ) AS repeat_customers

    FROM customer_value

)

SELECT
    cm.total_customers,

    bm.purchasing_customers,

    bm.completed_orders,

    ROUND(
        bm.total_revenue,
        2
    ) AS total_revenue,

    ROUND(
        bm.average_order_value,
        2
    ) AS average_order_value,

    cm.repeat_customers,

    ROUND(
        cm.repeat_customers * 100.0
        / NULLIF(bm.purchasing_customers, 0),
        2
    ) AS repeat_purchase_rate

FROM business_metrics AS bm

CROSS JOIN customer_metrics AS cm;


-- ============================================================
-- SECTION 15: FINAL PROJECT VALIDATION
-- ============================================================


-- ------------------------------------------------------------
-- 34. Check All Completed Orders Have Positive Revenue
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS invalid_completed_orders

FROM order_facts

WHERE order_status = 'COMPLETED'
  AND order_revenue <= 0;


-- ------------------------------------------------------------
-- 35. Verify RFM Customer Coverage
-- ------------------------------------------------------------

SELECT
    (
        SELECT COUNT(*)
        FROM customer_value
        WHERE completed_orders > 0
    ) AS purchasing_customers,

    (
        SELECT COUNT(*)
        FROM rfm_scores
    ) AS rfm_scored_customers;


-- ------------------------------------------------------------
-- 36. Project Summary
-- ------------------------------------------------------------

SELECT
    'E-Commerce Customer Analytics & Retention Intelligence'
        AS project_name,

    'Cohort Retention and RFM Segmentation'
        AS primary_analysis,

    'Standalone SQL Portfolio Project'
        AS project_type,

    'MySQL 8.0+'
        AS database_platform;


-- ============================================================
-- END OF PROJECT
-- ============================================================

-- PROJECT DELIVERABLES:
--
-- 1. Relational E-Commerce Database
-- 2. Synthetic Transactional Dataset
-- 3. Data Quality Checks
-- 4. Revenue Analytics
-- 5. Monthly Revenue Trends
-- 6. Product Performance Analysis
-- 7. Customer Lifetime Revenue
-- 8. Repeat Purchase Analysis
-- 9. Cohort Retention Analysis
-- 10. RFM Customer Segmentation
-- 11. Business Recommendations
-- 12. Revenue Reconciliation
-- 13. Executive KPI Dashboard
--
-- AUTHOR: BHAVESH PAWAR
-- ============================================================