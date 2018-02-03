USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spPredictUnitPrice
AS
DECLARE @model VARBINARY(MAX) = (SELECT Model FROM Models WHERE ModelName = 'Default Model');
BEGIN

IF OBJECT_ID('ConstosoRetailDW.dbo.UnitPricePredict','U') IS NOT NULL
TRUNCATE TABLE ContosoRetailDW.dbo.UnitPricePredict

INSERT INTO UnitPricePredict
(
	UnitCost
	,SalesQuantity
	,StoreType
	,EmployeeCount
	,BrandName
	,ClassName
	,ColorName
	,CalendarDayOfWeekLabel
	,CalendarMonthLabel
	,NorthAmericaSeason
	,ProductSubcategoryName
	,CityName
	,ActualUnitPrice
	,PredictUnitPrice
)
EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
	@language = N'R'
	,@script = 
		N'model <- rxUnserializeModel(model)
		TestData <- data.frame(TestData)
		pred <- rxPredict(model, data = TestData, overwrite = TRUE)
		OutputDataSet <- data.frame(cbind(TestData,pred))'
	,@input_data_1 = 
		N'
		SELECT
			UnitCost
			,SalesQuantity
			,StoreType
			,EmployeeCount
			,BrandName
			,ClassName
			,ColorName
			,CalendarDayOfWeekLabel
			,CalendarMonthLabel
			,NorthAmericaSeason
			,ProductSubcategoryName
			,CityName
			,UnitPrice
		FROM RetailSalesData
		WHERE DateKey >= 20090101'
	,@input_data_1_name = N'TestData'
	,@params = N'@model VARBINARY(MAX)'
	,@model = @model
END
GO
