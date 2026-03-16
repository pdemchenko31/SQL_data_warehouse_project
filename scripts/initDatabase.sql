/* 
==================================================================
Create Database and Schemas
==================================================================
This script creates a new database called 'PortfolioDataWarehouse' after checking if it already exists.
If database exists, it is dropped and recreated.
Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
  Running this script will drop the entire database.
  All data in the database will be permanently deleted.
  Proceed with caution.
*/

USE master;
GO

--DROP and RECREATE the 'PortfolioDataWarehouse' database IF EXISTS
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'PortfolioDataWarehouse')
BEGIN
	ALTER DATABASE PortfolioDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE PortfolioDataWarehouse;
END;
GO

-- CREATE the 'PortfolioDataWarehouse' database
CREATE DATABASE PortfolioDataWarehouse;
GO

USE PortfolioDataWarehouse;
GO

-- CREATE schemas for 'bronze', 'silver' and 'gold'
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
