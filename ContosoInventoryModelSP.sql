USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spGenerateInventoryModel
AS
BEGIN

IF OBJECT_ID('dbo.Models' ,'U') IS NOT NULL
TRUNCATE TABLE dbo.Models

INSERT INTO ContosoRetailDW.dbo.Models
(
	Model
)
EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
		@LANGUAGE = N'R'
		, @SCRIPT = N'  
			RetailInventoryData <- rxFactors(RetailInventoryData, factorInfo = c("StoreType","ProductName","ClassName","CalendarMonthLabel","NorthAmericaSeason","CityName"), sortLevels = TRUE)
			model <- rxDTree(OnHandQuantity ~ StoreType + ProductName + ClassName + CalendarMonthLabel + NorthAmericaSeason + CityName, data = RetailInventoryData)
			TrainedModel <- data.frame(as.raw(serialize(model, connection = NULL)));'
		,@input_data_1 = N'
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
		,@input_data_1_name = N'RetailInventoryData'
		,@output_data_1_name = N'TrainedModel';
	END
GO