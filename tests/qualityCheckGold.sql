/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dimCustomers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dimCustomers
-- Expectation: No results 
SELECT 
    customerKey,
    COUNT(*) AS duplicateCount
FROM gold.dimCustomers
GROUP BY customerKey
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.productKey'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dimProducts
-- Expectation: No results 
SELECT 
    productKey,
    COUNT(*) AS duplicateCount
FROM gold.dimProducts
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.factSales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.factSales f
LEFT JOIN gold.dimCustomers c
ON c.customer_key = f.customerKey
LEFT JOIN gold.dimProducts p
ON p.productKey = f.productKey
WHERE p.productKey IS NULL OR c.customerKey IS NULL  
