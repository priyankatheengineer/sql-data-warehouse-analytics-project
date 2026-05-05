/*
===============================================================================
Database Setup Script
===============================================================================
Script Purpose:
    This script initializes the 'DataWarehouse' database environment.

    It performs the following actions:
    - Checks if the 'DataWarehouse' database already exists
    - If it exists, forces disconnect of active sessions and drops the database
    - Creates a fresh 'DataWarehouse' database
    - Creates required schemas: bronze, silver, and gold

Warning:
    This script will permanently delete the existing 'DataWarehouse' database 
    along with all its data. Ensure backups are taken before execution.
===============================================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
