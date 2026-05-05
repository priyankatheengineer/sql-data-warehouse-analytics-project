/*
===============================================================================
DDL Script: Create Gold Tables with Indexing
===============================================================================
Script Purpose:
    This script creates the Gold layer tables (Dimension & Fact) in the 
    data warehouse instead of views, making them production-ready.

    It includes:
    - Creation of dimension and fact tables (Star Schema)
    - Loading data from Silver layer
    - Indexing strategy for performance optimization

    Performance Optimizations:
    - Surrogate keys using IDENTITY
    - Indexing on join columns and filter columns
    - Optimized for analytical queries

Usage:
    - Run after loading Silver layer
    - Suitable for reporting, BI tools, and analytics
===============================================================================
*/

-- =============================================================================
-- Create Dimension Table: gold.dim_customers
-- =============================================================================


IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    customer_number NVARCHAR(50),
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    country NVARCHAR(50),
    marital_status NVARCHAR(50),
    gender NVARCHAR(10),
    birthdate DATE,
    create_date DATE
);
GO

INSERT INTO gold.dim_customers (
    customer_id, customer_number, first_name, last_name,
    country, marital_status, gender, birthdate, create_date
)
SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    la.cntry,
    ci.cst_marital_status,
    CASE 
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END,
    ca.bdate,
    ci.cst_create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

CREATE NONCLUSTERED INDEX idx_dim_customers_id
ON gold.dim_customers(customer_id);
GO


-- =============================================================================
-- Create Dimension Table: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO

CREATE TABLE gold.dim_products (
    product_key INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    product_number NVARCHAR(50),
    product_name NVARCHAR(255),
    category_id NVARCHAR(50),
    category NVARCHAR(100),
    subcategory NVARCHAR(100),
    maintenance NVARCHAR(50),
    cost DECIMAL(10,2),
    product_line NVARCHAR(50),
    start_date DATE
);
GO

INSERT INTO gold.dim_products (
    product_id, product_number, product_name,
    category_id, category, subcategory, maintenance,
    cost, product_line, start_date
)
SELECT
    pn.prd_id,
    pn.prd_key,
    pn.prd_nm,
    pn.cat_id,
    pc.cat,
    pc.subcat,
    pc.maintenance,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id;
GO

CREATE NONCLUSTERED INDEX idx_dim_products_number
ON gold.dim_products(product_number);
GO


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales (
    order_number NVARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE NOT NULL,   -- ✅ FIX: prevent NULL issues
    shipping_date DATE,
    due_date DATE,
    sales_amount DECIMAL(12,2),
    quantity INT,
    price DECIMAL(10,2)
);
GO

INSERT INTO gold.fact_sales (
    order_number, product_key, customer_key,
    order_date, shipping_date, due_date,
    sales_amount, quantity, price
)
SELECT
    sd.sls_ord_num,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt,
    sd.sls_ship_dt,
    sd.sls_due_dt,
    sd.sls_sales,
    sd.sls_quantity,
    sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO

-- =============================================================================
-- Indexing Strategy for Fact Table
-- =============================================================================

CREATE CLUSTERED INDEX idx_fact_sales_order_date
ON gold.fact_sales(order_date);
GO

CREATE NONCLUSTERED INDEX idx_fact_sales_keys
ON gold.fact_sales(product_key, customer_key);
GO

CREATE NONCLUSTERED INDEX idx_fact_sales_cover
ON gold.fact_sales(product_key, customer_key)
INCLUDE (sales_amount, quantity);
GO


