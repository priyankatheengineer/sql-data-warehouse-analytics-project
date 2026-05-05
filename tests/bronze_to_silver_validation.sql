/*
===============================================================================
Source-to-Target Verification (Bronze → Silver)
===============================================================================
Purpose:
    Validate data movement from Bronze to Silver layer to ensure:
    - No unintended data loss
    - Aggregates remain consistent
    - Differences are explainable (deduplication, cleansing)

Usage:
    Run after loading Silver layer
===============================================================================
*/

-- ====================================================================
-- Row Count Check
-- ====================================================================
-- Expectation: Counts should match OR differences should be explainable

SELECT 'bronze.crm_sales_details' AS table_name, COUNT(*) FROM bronze.crm_sales_details
UNION ALL
SELECT 'silver.crm_sales_details', COUNT(*) FROM silver.crm_sales_details;

-- ====================================================================
-- Aggregate Check (Sales)
-- ====================================================================
-- Expectation: Values should match OR differences should be explainable

SELECT 
    (SELECT SUM(sls_sales) FROM bronze.crm_sales_details) AS bronze_sales,
    (SELECT SUM(sls_sales) FROM silver.crm_sales_details) AS silver_sales;

-- ====================================================================
-- Key-Level Check
-- ====================================================================
-- Expectation: No unexpected data loss per key

SELECT sls_prd_key, COUNT(*) 
FROM bronze.crm_sales_details
GROUP BY sls_prd_key
EXCEPT
SELECT sls_prd_key, COUNT(*) 
FROM silver.crm_sales_details
GROUP BY sls_prd_key;