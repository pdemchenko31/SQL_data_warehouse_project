/*

*/
--Create procedure
CREATE OR ALTER PROCEDURE bronze.loadBronze AS
BEGIN
  -- Declare variables for time count
	DECLARE @startTime DATETIME, @endTime DATETIME, @batchStartTime DATETIME, @batchEndTime DATETIME;
	BEGIN TRY
    --Start time count of batch execution
		SET @batchStartTime = GETDATE();

		PRINT ('===================================');
		PRINT ('Loading Bronze Layer');
		PRINT ('===================================');

		PRINT ('-----------------------------------');
		PRINT ('Loading data from CRM');
		PRINT ('-----------------------------------');
    --Possible error handling
		PRINT('>> Handling Date Format');
		SET DATEFORMAT dmy;

    --Start time count of inserting data into the table
		SET @startTime = GETDATE();
    --Delete previous data
		PRINT('>> Truncating table: bronze.crmCustInfo');
		TRUNCATE TABLE bronze.crmCustInfo;
    --Insert new data
		PRINT('>> Inserting information into: bronze.crmCustInfo');
		BULK INSERT bronze.crmCustInfo
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
    --Stop time count and display execution duration
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		/* ================================= */
		
		SET @startTime = GETDATE();
		PRINT('>> Truncating table: bronze.crmPrdInfo');
		TRUNCATE TABLE bronze.crmPrdInfo;

		PRINT('>> Inserting information into: bronze.crmPrdInfo');
		BULK INSERT bronze.crmPrdInfo
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';
		/* ================================= */

		SET @startTime = GETDATE();
		PRINT('>> Truncating table: bronze.crmSalesDetails');
		TRUNCATE TABLE bronze.crmSalesDetails;

		PRINT('>> Inserting information into: bronze.crmSalesDetails');
		BULK INSERT bronze.crmSalesDetails
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		/* ================================= */

		PRINT ('-----------------------------------');
		PRINT ('Loading data from ERP');
		PRINT ('-----------------------------------');

		SET @startTime = GETDATE();
		PRINT('>> Truncating table: bronze.bronze.erpCustAZ12');
		TRUNCATE TABLE bronze.erpCustAZ12;

		PRINT('>> Inserting information into: bronze.bronze.erpCustAZ12');
		BULK INSERT bronze.erpCustAZ12
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		/* ================================= */

		SET @startTime = GETDATE();
		PRINT('>> Truncating table: bronze.erpLocA101');
		TRUNCATE TABLE bronze.erpLocA101;

		PRINT('>> Inserting information into: bronze.erpLocA101');
		BULK INSERT bronze.erpLocA101
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @endTime = GETDATE();
		PRINT '>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec';

		/* ================================= */

		SET @startTime = GETDATE();
		PRINT('>> Truncating table: bronze.erpPxCatG1V2');
		TRUNCATE TABLE bronze.erpPxCatG1V2;

		PRINT('>> Inserting information into: bronze.erpPxCatG1V2');
		BULK INSERT bronze.erpPxCatG1V2
		FROM 'C:\Users\Dr1ver\OneDrive\Рабочий стол\,\Data Analyst Learning\SQL\DWH_Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @endTime = GETDATE();
		PRINT ('>>Load time: ' + CAST(DATEDIFF(second, @startTime, @endTime) AS NVARCHAR) + 'sec');

    --Stop time count and display execution duration of the batch
		SET @batchEndTime = GETDATE();
		PRINT ('===================================');
		PRINT ('BRONZE LAYER LOADING COMPLETE');
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
END
