/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =========================================================
-- Creating gold.factSales
-- =========================================================

IF OBJECT_ID('gold.dimCustomers', 'V') IS NOT NULL
	DROP VIEW gold.dimCustomers;
GO

CREATE VIEW gold.dimCustomers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cstID) AS customerKey
	, ci.cstID AS customerID
	, ci.cstKey AS customerNumber
	, ci.cstFirstName AS firstName
	, ci.cstLastName AS lastName
	, cla.cntry AS country
	, CASE
		WHEN ci.cstGndr != 'n/a' THEN ci.cstGndr -- CRM is master table for gender info
		ELSE COALESCE(cia.gen, 'n/a')
	END AS gender
	, ci.cstMaritalStatus AS maritalStatus
	, cia.bdate AS birthdate
	, ci.cstCreateDate AS createDate
FROM silver.crmCustInfo ci
LEFT JOIN silver.erpCustAZ12 cia
	ON ci.cstKey = cia.cid
LEFT JOIN silver.erpLocA101 cla
	ON ci.cstKey = cla.cid

IF OBJECT_ID('gold.dimCustomers', 'V') IS NOT NULL
	DROP VIEW gold.dimCustomers;
GO

-- =========================================================
-- Creating gold.dimProducts
-- =========================================================

CREATE VIEW gold.dimProducts AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pd.prdStartDt, pd.prdKey) AS productKey
	,pd.prdID AS productID
	, pd.prdKey AS productNumber
	, pd.prdNm AS productName
	, pd.catID AS categoryID
	, pcd.cat AS category
	, pcd.subcat AS subcategory
	, pd.prdCost AS cost
	, pd.prdStartDt AS startDate
	, pd.prdEndDt AS endDate
	, pcd.maintenance
FROM silver.crmPrdInfo pd
LEFT JOIN silver.erpPxCatG1V2 pcd
	ON	  pd.catID = pcd.id
WHERE prdEndDt IS NULL; -- Filter out all historic data

-- =========================================================
-- Creating gold.dimCustomers
-- =========================================================

IF OBJECT_ID('gold.dimCustomers', 'V') IS NOT NULL
	DROP VIEW gold.dimCustomers;
GO

CREATE VIEW gold.factSales AS
SELECT
	sd.slsOrdNum AS orderNumber
	, pr.productKey
	, cs.customerKey
	, sd.slsOrderDt AS orderDate
	, sd.slsShipDt AS shippingDate
	, sd.slsDueDt AS dueDate
	, sd.slsSales AS salesAmount
	, sd.slsQuantity AS quantity
	, sd.slsPrice AS price
FROM silver.crmSalesDetails sd
LEFT JOIN gold.dimProducts pr
	ON sd.slsPrdKey = pr.productNumber
LEFT JOIN gold.dimCustomers cs
	ON sd.slsCustID = cs.customerID;
