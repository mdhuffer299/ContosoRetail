USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spPredictProfit
AS
DECLARE @model VARBINARY(MAX) = (SELECT Model FROM Models WHERE ModelName = 'Default Model');
BEGIN

IF OBJECT_ID('ConstosoRetailDW.dbo.ProfitPredict','U') IS NOT NULL
TRUNCATE TABLE ContosoRetailDW.dbo.ProfitPredict

INSERT INTO ProfitPredict
(
	FullDate
	,TotalCost
	,StoreType
	,StoreName
	,ColorName
	,NorthAmericaSeason
	,ProductSubcategoryName
	,ActualProfit
	,PredictedProfit
)
EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
	@language = N'R'
	,@script = 
		N'model <- rxUnserializeModel(model)
		TestDAta <- data.frame(TestData)
		pred <- rxPredict(model, data = TestData, overwrite = TRUE)
		OutputDataSet <- data.frame(cbind(TestData,pred))'
	,@input_data_1 = 
		N'
		SELECT
			FullDate
			,TotalCost
			,StoreType
			,StoreName
			,ColorName
			,NorthAmericaSeason
			,ProductSubcategoryName
			,Profit
		FROM RetailPrice
		WHERE FullDate >= 20090101'
	,@input_data_1_name = N'TestData'
	,@params = N'@model VARBINARY(MAX)'
	,@model = @model
END
GO
