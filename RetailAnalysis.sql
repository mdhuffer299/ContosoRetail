/*
	Restore ContosoRetailDW from .BAK file.
	In order to run R scripts in SQL server 2016/2017, you must enable the ability to execute external scripts on your SQL Server Instance.
	After executing the script you must restart the server instance.
*/
EXEC SP_CONFIGURE 'EXTERNAL SCRIPTS ENABLED',1
RECONFIGURE WITH OVERRIDE;

/*
	In order to excute the apriori rules model, you must enable and have the correct permissions to create and manage external libraries on the instance and/or the databases involved in the analysis.
	To enable the ability to create external libraries, you must use the command line.  Instructions for this can be found here:  https://docs.microsoft.com/en-us/sql/advanced-analytics/r/r-package-how-to-enable-or-disable
	Once enabled you must download and save a zip file with your package/libraries and create the external library below.
*/
CREATE EXTERNAL LIBRARY arules
FROM (CONTENT = 'C:\Users\mhuffer\Desktop\RServicesLibs\arules_1.5-4.zip')
WITH (LANGUAGE = 'R');

/*
	Step 1: Execute the create script for ContosoRetailDW.dbo.ProductRulesData located in the ContosoRetailTable.sql file .
	Step 2: Execute the create script for ContosoRetailDW.dbo.RetailRulesOutput located in the ContosoRetailTable.sql file.
	Step 3: Execute the script to create the stored procedure spProductRulesDataLoad located in the ContosoProductRulesDataSP script.
	Step 4: Execute the script to create the stored procedure spRetailRules located in the RetailRulesSP script.
	Step 5: Execute the below lines to load the data and run the Apriori associative rules model
*/
EXECUTE spProductRulesDataLoad;

EXECUTE spRetailRules @InputQuery =
		N'SELECT
			ProductOne
			,ProductTwo
			,ProductThree
			,ProductFour
			,ProductFive
			,ProductSix
			,ProductSeven
			,ProductEight
			,ProductNine
			,ProductTen
		FROM
			ContosoRetailDW.dbo.ProductRulesData
		WHERE ProductTwo IS NOT NULL';

--Run to view the results of the Apriori Model
SELECT * FROM ContosoRetailDW.dbo.RetailRulesOutput;

/*
Decision Tree Regression Model for predicting Inventory

	Step 1: Execute the create script for ContosoRetailDW.dbo.RetailInventoryData located in the ContosoRetailTable.sql file.
	Step 2: Execute the create script for ContosoRetailDW.dbo.Models located in the ContosoRetailTable.sql file.
	Step 3: Execute the script to create the stored procedure spRetailInventoryDataLoad located in the ContosoRetailInventory.sql file.
	Step 4: Execute the script to create the stored procedure spGenerateInventoryModel located in the ContosoInventoryModelSP script.
	Step 5: Execute the script to create the stored procedure spPredictInventory located in the PredictInventorySP script.
	Step 6: Execute the below lines to load the data and run the Decision Tree Regression model
*/

EXECUTE spRetailInventoryDataLoad;

EXECUTE spGenerateModel
@SCRIPT = N'  
		RetailInventoryData <- rxFactors(RetailInventoryData, factorInfo = c("StoreType","ProductName","ClassName","CalendarMonthLabel","NorthAmericaSeason","CityName"), sortLevels = TRUE)
		model.dtree <- rxDTree(OnHandQuantity ~ StoreType + ProductName + ClassName + CalendarMonthLabel + NorthAmericaSeason + CityName, data = RetailInventoryData)
		TrainedModel <- data.frame(rxSerializeModel(model.dtree));'
,@InputData = N'
		SELECT TOP 100000
			OnHandQuantity
			,StoreType
			,ProductName
			,ClassName
			,CalendarMonthLabel
			,NorthAmericaSeason
			,CityName
		FROM
			ContosoRetailDW.dbo.RetailInventoryData'
,@InputDataName = N'RetailInventoryData'
,@OutputDataName = N'TrainedModel';

EXECUTE spPredictInventory;


--Predict PROFIT
EXECUTE spRetailPriceLoad;


--Generate the Model for Predicting Profit based on data from the RetailPrice Dataset
EXECUTE spGenerateModel
@Script =
	N'
	model <- rxLinMod(Profit ~ FullDate + TotalCost + StoreType + StoreName + ColorName + NorthAmericaSeason + ProductSubcategoryName, data = TrainData)
	TrainedModel <- data.frame(rxSerializeModel(model))'
,@InputData =
	N'
	SELECT
		FullDate
		,TotalCost
		,SalesAmount
		,Profit
		,StoreType
		,StoreName
		,ColorName
		,NorthAmericaSeason
		,HolidaySeason
		,ProductCategoryName
		,ProductSubcategoryName
		,CityName
		,PromotionName
		,DiscountPercent
		,PromotionType
	FROM RetailPrice
	WHERE FullDate < 20090101'
,@InputDataName = N'TrainData'
,@OutputDataName = N'TrainedModel';

EXECUTE spPredictProfit;

--Predict UnitPrice
EXECUTE spRetailSalesDataLoad;

--Generates the Trained Model that predicts UnitPrice from the RetailSales Dataset
EXECUTE spGenerateModel
@Script =
	N'model.LinMod <- rxLinMod(UnitPrice ~ UnitCost + SalesQuantity + StoreType + EmployeeCount + BrandName + ColorName + CalendarDayOfWeekLabel + CalendarMonthLabel + NorthAmericaSeason + ProductSubcategoryName + CityName, data = TrainData)
	TrainedModel <- data.frame(rxSerializeModel(model.LinMod))' 
,@InputData = 
	N'SELECT
      UnitCost
      ,UnitPrice
      ,SalesQuantity
      ,StoreType
      ,EmployeeCount
      ,BrandName
      ,ColorName
      ,CalendarDayOfWeekLabel
      ,CalendarMonthLabel
      ,NorthAmericaSeason
      ,ProductSubcategoryName
      ,CityName
	FROM ContosoRetailDW.dbo.RetailSalesData
	WHERE DateKey < 20090101'
,@InputDataName = N'TrainData'
,@OutputDataName = N'TrainedModel';

EXECUTE spPredictUnitPrice;

SELECT
	ActualUnitPrice
	,PredictUnitPrice
	,ActualUnitPrice - PredictUnitPrice AS Diff	
FROM UnitPricePredict;