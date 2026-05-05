/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source → Bronze)
===============================================================================
Purpose:
    This stored procedure ingests raw data from external CSV files into 
    the Bronze layer tables.

    It performs the following steps:
    - Clears existing data using TRUNCATE
    - Loads fresh data using BULK INSERT
    - Captures execution time for each table load and batch load
    - Logs progress messages for monitoring

    The Bronze layer stores raw, untransformed data exactly as received 
    from source systems (CRM and ERP).

Parameters:
    None

Usage:
    EXEC bronze.load_bronze;

Notes:
    - Ensure file paths are accessible to SQL Server
    - Requires proper permissions for BULK INSERT
===============================================================================
*/



/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source → Bronze)
===============================================================================
Purpose:
    Loads raw data from CSV files into Bronze tables.

    Steps:
    - Truncate existing data
    - Load fresh data using BULK INSERT
    - Track execution time per table and overall batch
    - Log progress for monitoring

Notes:
    - Ensure file paths are accessible
    - Requires BULK INSERT permissions
===============================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @start_time DATETIME2,
        @end_time DATETIME2,
        @batch_start_time DATETIME2,
        @batch_end_time DATETIME2;

    BEGIN TRY
        SET @batch_start_time = SYSDATETIME();

        PRINT '------------------------------------------------';
        RAISERROR('Loading CRM Tables', 0, 1) WITH NOWAIT;
        PRINT '------------------------------------------------';

        -- ================= CRM: Customer =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'crm_cust_info Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        -- ================= CRM: Product =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'crm_prd_info Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        -- ================= CRM: Sales =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'crm_sales_details Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        PRINT '------------------------------------------------';
        RAISERROR('Loading ERP Tables', 0, 1) WITH NOWAIT;
        PRINT '------------------------------------------------';

        -- ================= ERP: Customer =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'erp_cust_az12 Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        -- ================= ERP: Location =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'erp_loc_a101 Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        -- ================= ERP: Category =================
        SET @start_time = SYSDATETIME();

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'E:\data-engineering\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();
        PRINT 'erp_px_cat_g1v2 Load Duration: ' + 
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';


        -- ================= Batch Duration =================
        SET @batch_end_time = SYSDATETIME();

        PRINT '------------------------------------------------';
        PRINT 'Total Batch Duration: ' + 
              CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '------------------------------------------------';

    END TRY

    BEGIN CATCH
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
    END CATCH
END;
