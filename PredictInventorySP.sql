USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spPredictInventory
AS
DECLARE @Model VARBINARY(MAX) = (SELECT Model FROM Models WHERE ModelName = 'Default Model');
BEGIN
EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
	@language = N'R'
	,@script = 
		N'Model <- rxUnserializeModel(Model)
		InventoryPredictData <- data.frame(RetailInventoryData)
		InventoryPredictData <- rxFactors(InventoryPredictData, factorInfo = c("StoreType","ProductName","ClassName","CalendarMonthLabel","NorthAmericaSeason","CityName"), sortLevels = TRUE)
		pred <- rxPredict(Model, data = InventoryPredictData)
		OutputDataSet <- data.frame(cbind(InventoryPredictData,pred))'
	,@input_data_1 = 
		N'SELECT TOP 100
			StoreType
			,ProductName
			,ClassName
			,CalendarMonthLabel
			,NorthAmericaSeason
			,CityName
		FROM
			ContosoRetailDW.dbo.RetailInventoryData'
	,@input_data_1_name = N'RetailInventoryData'
	,@params = N'@Model VARBINARY(MAX)'
	,@Model = @Model
	WITH RESULT SETS (([StoreType] NVARCHAR(15),[ProductName] NVARCHAR(50), [ClassName] NVARCHAR(20), [CalendarMonthLabel] NVARCHAR(20),[NorthAmericaSeason] NVARCHAR(50), [CityName] NVARCHAR(100), [OnHandQuantity] FLOAT))
END
GO