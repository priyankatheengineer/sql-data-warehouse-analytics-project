/*
===============================================================================
Analytics Script - Gold Layer (Business Insights)
===============================================================================
Script Purpose:
    This script generates business insights from the Gold layer tables
    using fact and dimension data modeled in a star schema.

    It includes:
    - Customer Insights (CLV, top customers, retention)
    - Product Performance (top/low products, revenue contribution)
    - Sales Trends (daily, monthly, growth analysis)

    These queries are used for:
    - Business reporting
    - Dashboarding (Power BI / Tableau)
    - Decision-making

Usage Notes:
    - Run after Gold layer is loaded and validated
    - Optimized using indexed columns (order_date, keys)
===============================================================================
*/

-- ====================================================================
-- 1. Customer Insights
-- ====================================================================

-- Top 10 Customers by Revenue
SELECT TOP 10
    c.customer_key,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-- Customer Lifetime Value (CLV)
SELECT 
    c.customer_key,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM(f.sales_amount) AS lifetime_value
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY lifetime_value DESC;


-- Repeat Customers (Retention)
SELECT 
    c.customer_key,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(f.order_number) AS total_orders
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
HAVING COUNT(f.order_number) > 1
ORDER BY total_orders DESC;


-- ====================================================================
-- 2. Product Performance
-- ====================================================================

-- Top 10 Products by Quantity Sold
SELECT TOP 10
    p.product_key,
    p.product_name,
    SUM(f.quantity) AS total_quantity_sold
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY 
    p.product_key,
    p.product_name
ORDER BY total_quantity_sold DESC;


-- Revenue Contribution by Product
SELECT 
    p.product_key,
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY 
    p.product_key,
    p.product_name
ORDER BY total_revenue DESC;


-- Low Performing Products (Least Revenue)
SELECT 
    p.product_key,
    p.product_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY 
    p.product_key,
    p.product_name
ORDER BY revenue ASC;


-- ====================================================================
-- 3. Sales Trends
-- ====================================================================

-- Monthly Sales Trend
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY 
    YEAR(order_date),
    MONTH(order_date)
ORDER BY year, month;


-- Daily Sales Trend
SELECT 
    order_date,
    SUM(sales_amount) AS daily_sales,
    SUM(quantity) AS daily_quantity
FROM gold.fact_sales
GROUP BY order_date
ORDER BY order_date;


-- Month-over-Month Growth (MoM)
WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(sales_amount) AS revenue
    FROM gold.fact_sales
    GROUP BY 
        YEAR(order_date),
        MONTH(order_date)
)
SELECT 
    year,
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year, month) AS growth
FROM monthly_sales
ORDER BY year, month;


-- ====================================================================
-- 4. Key Business KPIs
-- ====================================================================

-- Overall Business Metrics
SELECT 
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_revenue,
    SUM(quantity) AS total_quantity,
    AVG(sales_amount) AS avg_order_value
FROM gold.fact_sales;


-- Revenue by Country
SELECT 
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;