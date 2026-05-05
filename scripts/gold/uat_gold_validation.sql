/*
===============================================================================
UAT Validation Script - Gold Layer
===============================================================================
Script Purpose:
    This script performs User Acceptance Testing (UAT) validations to ensure 
    the Gold Layer data is accurate, complete, and aligned with business expectations.

    It includes:
    - Row count validation (no data loss)
    - Aggregation checks (business metrics validation)
    - Referential integrity checks
    - Null checks on critical fields

Usage Notes:
    - Run after Gold layer is loaded
    - Compare results with expected business numbers
    - Investigate any mismatches
===============================================================================
*/

-- ====================================================================
-- 1. Row Count Validation (Source → Target)
-- ====================================================================
-- Ensure no data loss between Silver and Gold

-- Fact Table Row Count
SELECT 'Silver Count' AS layer, COUNT(*) AS total_rows 
FROM silver.crm_sales_details
UNION ALL
SELECT 'Gold Count', COUNT(*) 
FROM gold.fact_sales;


-- Dimension Table Row Count (Customers)
SELECT 'Silver Customers' AS layer, COUNT(DISTINCT cst_id) 
FROM silver.crm_cust_info
UNION ALL
SELECT 'Gold Customers', COUNT(*) 
FROM gold.dim_customers;


-- Dimension Table Row Count (Products)
SELECT 'Silver Products' AS layer, COUNT(DISTINCT prd_key) 
FROM silver.crm_prd_info
UNION ALL
SELECT 'Gold Products', COUNT(*) 
FROM gold.dim_products;


-- ====================================================================
-- 2. Aggregation Validation (Business Metrics)
-- ====================================================================
-- Ensure business KPIs match across layers

-- Total Sales Check
SELECT 'Silver Total Sales' AS source, SUM(sls_sales) AS total_sales
FROM silver.crm_sales_details
UNION ALL
SELECT 'Gold Total Sales', SUM(sales_amount)
FROM gold.fact_sales;


-- Total Quantity Check
SELECT 'Silver Total Quantity' AS source, SUM(sls_quantity)
FROM silver.crm_sales_details
UNION ALL
SELECT 'Gold Total Quantity', SUM(quantity)
FROM gold.fact_sales;


-- ====================================================================
-- 3. Referential Integrity Check
-- ====================================================================
-- Ensure fact table keys exist in dimension tables

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL 
   OR p.product_key IS NULL;


-- ====================================================================
-- 4. Null Checks (Critical Fields)
-- ====================================================================
-- Ensure no NULLs in important analytical columns

SELECT *
FROM gold.fact_sales
WHERE order_date IS NULL
   OR product_key IS NULL
   OR customer_key IS NULL
   OR sales_amount IS NULL;


-- ====================================================================
-- 5. Duplicate Check (Fact Table - Optional)
-- ====================================================================
-- Ensure no duplicate transactions

SELECT 
    order_number,
    product_key,
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.fact_sales
GROUP BY 
    order_number,
    product_key,
    customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- 6. Business Validation (Sample Check)
-- ====================================================================
-- Validate sample records with business users (manual verification)

SELECT TOP 10 *
FROM gold.fact_sales
ORDER BY order_date DESC;
