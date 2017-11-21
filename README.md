# ContosoRetail
Repo for Contoso Retail DW scripts.

Step 1: 
Restore ContosoRetailDW from .BAK file.
In order to run R scripts in SQL server 2016/2017, you must enable the ability to execute external scripts on your SQL Server Instance.
After executing the script you must restart the server instance.

Step 2:
In order to excute the apriori rules model, you must enable and have the correct permissions to create and manage external libraries on the instance and/or the databases involved in the analysis.
To enable the ability to create external libraries, you must use the command line.  Instructions for this can be found here: https://docs.microsoft.com/en-us/sql/advanced-analytics/r/r-package-how-to-enable-or-disable

Step 3:
Once enabled you must download and save a zip file with your package/libraries and create the external library below.
  
Step 4: 
Execute the create script for ContosoRetailDW.dbo.ProductRulesData located in the ContosoRetailTable.sql file.

Step 5:
Execute the create script for ContosoRetailDW.dbo.RetailRulesOutput located in the ContosoRetailTable.sql file.

Step 6:
Execute the script to create the stored procedure spProductRulesDataLoad located in the ContosoProductRulesDataSP script.

Step 7:
Execute the script to create the stored procedure spRetailRules located in the RetailRulesSP script.

Step 8:
Execute the below lines to load the data and run the Apriori associative rules model.

Decision Tree Regression Model for predicting Inventory

Step 1: Execute the create script for ContosoRetailDW.dbo.RetailInventoryData located in the ContosoRetailTable.sql file.
Step 2: Execute the create script for ContosoRetailDW.dbo.Models located in the ContosoRetailTable.sql file.
Step 3: Execute the script to create the stored procedure spRetailInventoryDataLoad located in the ContosoRetailInventory.sql file.
Step 4: Execute the script to create the stored procedure spGenerateInventoryModel located in the ContosoInventoryModelSP script.
Step 5: Execute the script to create the stored procedure spPredictInventory located in the PredictInventorySP script.
Step 6: Execute the below lines to load the data and run the Decision Tree Regression model
