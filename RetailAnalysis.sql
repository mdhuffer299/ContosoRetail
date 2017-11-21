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

EXECUTE spGenerateInventoryModel;

EXECUTE spPredictInventory;




/*
Making sure stores have the enough of the right products, based on sales and qunatity on hand 
(To model the inventory count or sales revenue, would need to look at a continuous distribution)

If we want to model the number of events? (Possible Possion model for count of inventory, count of Sales)
Big events occuring require special distribution of goods (Christmas, Sporting events, Concerts, etc...)
Location inforamtion may drive the purchase of particular items.

Look at Channel, Customer, Geo, Product, Promotion, Scenario, Store Dims
Focus on Sales and Inventory Facts
*/
--Still working on this
EXECUTE spRetailSalesDataLoad;

