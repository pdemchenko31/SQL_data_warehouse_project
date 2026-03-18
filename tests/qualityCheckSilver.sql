/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crmCustInfo'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cstID,
    COUNT(*) 
FROM silver.crmCustInfo
GROUP BY cstID
HAVING COUNT(*) > 1 OR cstID IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    cstKey 
FROM silver.crmCustInfo
WHERE cstKey != TRIM(cstKey);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cstMaritalStatus 
FROM silver.crmCustInfo;

-- ====================================================================
-- Checking 'silver.crmPrdInfo'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    prdID,
    COUNT(*) 
FROM silver.crmPrdInfo
GROUP BY prdID
HAVING COUNT(*) > 1 OR prdID IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    prdNm 
FROM silver.crmPrdInfo
WHERE prdNm != TRIM(prdNm);

-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
SELECT 
    prdCost 
FROM silver.crmPrdInfo
WHERE prdCost < 0 OR prdCost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    prdLine 
FROM silver.crmPrdInfo;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT 
    * 
FROM silver.crmPrdInfo
WHERE prdEndDt < prdStartDt;

-- ====================================================================
-- Checking 'silver.crmSalesDetails'
-- ====================================================================
-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT 
    NULLIF(slsDueDt, 0) AS slsDueDt 
FROM bronze.crmSalesDetails
WHERE slsDueDt <= 0 
    OR LEN(slsDueDt) != 8 
    OR slsDueDt > 20500101 
    OR slsDueDt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT 
    * 
FROM silver.crmSalesDetails
WHERE slsOrderDt > slsShipDt 
   OR slsOrderDt > slsDueDt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
SELECT DISTINCT 
    slsSales,
    slsQuantity,
    slsPrice 
FROM silver.crmSalesDetails
WHERE slsSales != slsQuantity * slsPrice
   OR slsSales IS NULL 
   OR slsQuantity IS NULL 
   OR slsPrice IS NULL
   OR slsSales <= 0 
   OR slsQuantity <= 0 
   OR slsPrice <= 0
ORDER BY slsSales, slsQuantity, slsPrice;

-- ====================================================================
-- Checking 'silver.erpCustAZ12'
-- ====================================================================
-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT 
    bdate 
FROM silver.erpCustAZ12
WHERE bdate < '1920-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT 
    gen 
FROM silver.erpCustAZ12;

-- ====================================================================
-- Checking 'silver.erpLocA101'
-- ====================================================================
-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry 
FROM silver.erpLocA101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver.erpPxCatG1V2'
-- ====================================================================
-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    * 
FROM silver.erpPxCatG1V2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance 
FROM silver.erpPxCatG1V2;
