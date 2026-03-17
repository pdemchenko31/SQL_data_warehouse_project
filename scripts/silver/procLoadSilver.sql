CREATE OR ALTER PROCEDURE silver.loadSilver AS
BEGIN
	DECLARE @startTime DATETIME, @endTime DATETIME, @batchStartTime DATETIME, @batchEndTime DATETIME;
	BEGIN TRY
		SET @batchStartTime = GETDATE();

		PRINT ('===================================');
		PRINT ('Loading Silver Layer');
		PRINT ('===================================');

		PRINT ('-----------------------------------');
		PRINT ('Loading data from CRM');
		PRINT ('-----------------------------------');

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.crmCustInfo');
		TRUNCATE TABLE silver.crmCustInfo;
		PRINT ('>> Inserting New Data Into: silver.crmCustInfo');
		INSERT INTO silver.crmCustInfo (
			cstID
			, cstKey
			, cstFirstName
			, cstLastName
			, cstMaritalStatus
			, cstGndr
			, cstCreateDate)

		SELECT
			cstID
			, cstKey
			, TRIM(cstFirstName) AS cstFirstName
			, TRIM(cstLastName) AS cstLastName
			, CASE TRIM(UPPER(cstMaritalStatus))
				WHEN 'S' THEN 'Single'
				WHEN 'M' THEN 'Maried'
				ELSE 'n/a'
			END AS cstMaritalStatus -- Normalize marital status to readable format
			, CASE TRIM(UPPER(cstGndr))
				WHEN 'F' THEN 'Female'
				WHEN 'M' THEN 'Male'
				ELSE 'n/a'
			END AS cstGndr -- Normalize gender values to readable format
			, cstCreateDate
		FROM(
			SELECT
			*
			, ROW_NUMBER () OVER (PARTITION BY cstID ORDER BY cstCreateDate DESC) as flagDup
			FROM bronze.crmCustInfo
			WHERE cstID IS NOT NULL
		)t WHERE flagDup = 1; -- Select the most recent record per customer
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.crmPrdInfo');
		TRUNCATE TABLE silver.crmPrdInfo;
		PRINT ('>> Inserting New Data Into: silver.crmPrdInfo');
		INSERT INTO silver.crmPrdInfo (
			prdID
			, catID
			, prdKey
			, prdNm
			, prdCost
			, prdLine
			, prdStartDt
			, prdEndDt)
		SELECT 
			prdID
			, REPLACE(SUBSTRING(prdKey, 1, 5), '-', '_') AS catID -- Extract category ID
			, SUBSTRING(prdKey, 7, LEN(prdKey)) AS prdKey         -- Extract product key
			, prdNm
			, ISNULL(prdCost, 0) AS prdCost
			, CASE UPPER(TRIM(prdLine))
				WHEN 'M' THEN 'Mounting'
				WHEN 'R' THEN 'Road'
				WHEN 'T' THEN 'Touring'
				WHEN 'S' THEN 'Other Sales'
				ELSE 'n/a'
			END AS prdLine -- Map product line codes to descriptive values
			, CAST(prdStartDt AS DATE)
			, CAST(
				LEAD(prdStartDt) OVER (PARTITION BY prdKey ORDER BY prdStartDt)-1 
				AS DATE
			  ) AS prdEndDt -- Calculate end date as one day before the next start date
		FROM bronze.crmPrdInfo;
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.crmSalesDetails');
		TRUNCATE TABLE silver.crmSalesDetails;
		PRINT ('>> Inserting New Data Into: silver.crmSalesDetails');
		INSERT INTO silver.crmSalesDetails(
			slsOrdNum 
			, slsPrdKey 
			, slsCustID 
			, slsOrderDt 
			, slsShipDt
			, slsDueDt
			, slsSales
			, slsQuantity 
			, slsPrice)

		SELECT 
			slsOrdNum
			, slsPrdKey
			, slsCustID
			, CASE WHEN slsOrderDt = 0 OR LEN(slsOrderDt) != 8 THEN NULL
				ELSE CAST(CAST(slsOrderDt AS VARCHAR) AS DATE)
			END AS slsOrderDt
			, CASE WHEN slsShipDt = 0 OR LEN(slsShipDt) != 8 THEN NULL
				ELSE CAST(CAST(slsShipDt AS VARCHAR) AS DATE)
			END AS slsShipDt
			, CASE WHEN slsDueDt = 0 OR LEN(slsDueDt) != 8 THEN NULL
				ELSE CAST(CAST(slsDueDt AS VARCHAR) AS DATE)
			END AS slsDueDt
			, CASE
				WHEN slsSales IS NULL OR slsSales <= 0 OR slsSales != slsQuantity * ABS(slsPrice) THEN slsQuantity * ABS(slsPrice) 
				ELSE slsSales
			END AS slsSales
			, slsQuantity
			, Case 
				WHEN slsPrice = 0 OR slsPrice IS NULL THEN slsSales / NULLIF(slsQuantity, 0)
				WHEN slsPrice < 0 THEN ABS(slsPrice) 
				ELSE slsPrice 
			END AS slsPrice
		FROM bronze.crmSalesDetails
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		PRINT ('-----------------------------------');
		PRINT ('Loading data from ERP');
		PRINT ('-----------------------------------');

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.erpCustAZ12');
		TRUNCATE TABLE silver.erpCustAZ12;
		PRINT ('>> Inserting New Data Into: silver.erpCustAZ12');
		INSERT INTO silver.erpCustAZ12 (cid, bdate, gen)
		SELECT
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remove 'NAS' prefix if present
			ELSE cid
		END AS cid
		, CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate -- Set future birthdates to NULL
		, CASE
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'n/a'
		END AS gen -- Normalized gender values and handle unknown cases
		FROM bronze.erpCustAZ12
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.erpLocA101');
		TRUNCATE TABLE silver.erpLocA101;
		PRINT ('>> Inserting New Data Into: silver.erpLocA101');
		INSERT INTO silver.erpLocA101 (cid, cntry)

		SELECT
		REPLACE(cid, '-', '') AS cid
		, CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry -- Normalize and Handle missing or blank country codes
		FROM bronze.erpLocA101;
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		SET @startTime = GETDATE();
		PRINT ('>> Truncating Table: silver.erpPxCatG1V2');
		TRUNCATE TABLE silver.erpPxCatG1V2;
		PRINT ('>> Inserting New Data Into: silver.erpPxCatG1V2');
		INSERT INTO silver.erpPxCatG1V2(
		id
		, cat
		, subcat
		, maintenance)

		SELECT
		id
		, cat
		, subcat
		, maintenance
		FROM bronze.erpPxCatG1V2;
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		SET @batchEndTime = GETDATE();
		PRINT ('===================================');
		PRINT ('SILVER LAYER LOADING COMPLETE');
		PRINT ('Load Duration: ' + CAST(DATEDIFF(second, @batchStartTime, @batchEndTime) AS NVARCHAR) + ' sec');
		PRINT ('===================================');
	END TRY
  -- Error message handling
	BEGIN CATCH
		PRINT ('===================================');
		PRINT ('ERROR OCCURED DURING LOADING BRONZE');
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT 'Error line: ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT ('===================================');
	END CATCH
END;
