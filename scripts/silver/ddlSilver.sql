--Check and drop if exists
IF OBJECT_ID ('silver.crmCustInfo', 'U') IS NOT NULL
	DROP TABLE silver.crmCustInfo;
--Create new table
CREATE TABLE silver.crmCustInfo (
	cstID INT
	, cstKey NVARCHAR(50)
	, cstFirstName NVARCHAR(50)
	, cstLastName NVARCHAR(50)
	, cstMaritalStatus NVARCHAR(50)
	, cstGndr NVARCHAR(50)
	, cstCreateDate DATE
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crmPrdInfo', 'U') IS NOT NULL
	DROP TABLE silver.crmPrdInfo;
CREATE TABLE silver.crmPrdInfo (
	prdID INT
	, prdKey NVARCHAR(50)
	, prdNm NVARCHAR(50)
	, prdCost INT
	, prdLine NVARCHAR(50)
	, prdStartDt DATETIME
	, prdEndDt DATETIME
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crmSalesDetails', 'U') IS NOT NULL
	DROP TABLE silver.crmSalesDetails;
CREATE TABLE silver.crmSalesDetails (
	slsOrdNum NVARCHAR(50)
	, slsPrdKey NVARCHAR(50)
	, slsCustID INT
	, slsOrderDt INT
	, slsShipDt INT
	, slsDueDt INT
	, slsSales INT
	, slsQuantity INT
	, slsPrice INT
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erpCustAZ12', 'U') IS NOT NULL
	DROP TABLE silver.erpCustAZ12;
CREATE TABLE silver.erpCustAZ12 (
	cid NVARCHAR(50)
	, bdate DATE
	, gen NVARCHAR(50)
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erpLocA101', 'U') IS NOT NULL
	DROP TABLE silver.erpLocA101;
CREATE TABLE silver.erpLocA101 (
	cid NVARCHAR(50)
	, cntry NVARCHAR(50)
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erpPxCatG1V2', 'U') IS NOT NULL
	DROP TABLE silver.erpPxCatG1V2;
CREATE TABLE silver.erpPxCatG1V2 (
	id NVARCHAR(50)
	, cat NVARCHAR(50)
	, subcat NVARCHAR(100)
	, maintenance NVARCHAR(50)
	, dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
GO
