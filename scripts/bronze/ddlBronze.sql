/* 
==================================================================
DDL: Create Tables
==================================================================
This script creates new tables in the 'bronze' schema, after checking if they already exist.
If table exists, it is dropped and recreated.
Run this script to re-define entire DDL structure

WARNING:
  Running this script will drop entire tables.
  All data in the tables will be permanently deleted.
  Proceed with caution.
==================================================================
*/

--Check and drop if exists
IF OBJECT_ID ('bronze.crmCustInfo', 'U') IS NOT NULL
	DROP TABLE bronze.crmCustInfo;
--Create new table
CREATE TABLE bronze.crmCustInfo (
	cstID INT
	, cstKey NVARCHAR(50)
	, cstFirstName NVARCHAR(50)
	, cstLastName NVARCHAR(50)
	, cstMaritalStatus NVARCHAR(50)
	, cstGndr NVARCHAR(50)
	, cstCreateDate DATE
);
GO

IF OBJECT_ID ('bronze.crmPrdInfo', 'U') IS NOT NULL
	DROP TABLE bronze.crmPrdInfo;
CREATE TABLE bronze.crmPrdInfo (
	prdID INT
	, prdKey NVARCHAR(50)
	, prdNm NVARCHAR(50)
	, prdCost INT
	, prdLine NVARCHAR(50)
	, prdStartDt DATETIME
	, prdEndDt DATETIME
);
GO

IF OBJECT_ID ('bronze.crmSalesDetails', 'U') IS NOT NULL
	DROP TABLE bronze.crmSalesDetails;
CREATE TABLE bronze.crmSalesDetails (
	slsOrdNum NVARCHAR(50)
	, slsPrdKey NVARCHAR(50)
	, slsCustID INT
	, slsOrderDt INT
	, slsShipDt INT
	, slsDueDt INT
	, slsSales INT
	, slsQuantity INT
	, slsPrice INT
);
GO

IF OBJECT_ID ('bronze.erpCustAZ12', 'U') IS NOT NULL
	DROP TABLE bronze.erpCustAZ12;
CREATE TABLE bronze.erpCustAZ12 (
	cid NVARCHAR(50)
	, bdate DATE
	, gen NVARCHAR(50)
);
GO

IF OBJECT_ID ('bronze.erpLocA101', 'U') IS NOT NULL
	DROP TABLE bronze.erpLocA101;
CREATE TABLE bronze.erpLocA101 (
	cid NVARCHAR(50)
	, cntry NVARCHAR(50)
);
GO

IF OBJECT_ID ('bronze.erpPxCatG1V2', 'U') IS NOT NULL
	DROP TABLE bronze.erpPxCatG1V2;
CREATE TABLE bronze.erpPxCatG1V2 (
	id NVARCHAR(50)
	, cat NVARCHAR(50)
	, subcat NVARCHAR(100)
	, maintenance NVARCHAR(50)
);
GO
