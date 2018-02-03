USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spRetailRules @InputQuery NVARCHAR(MAX)
AS
BEGIN
IF OBJECT_ID('dbo.RetailRulesOutput' ,'U') IS NOT NULL
TRUNCATE TABLE dbo.RetailRulesOutput

INSERT INTO ContosoRetailDW.dbo.RetailRulesOutput
(
	Rules
	,Support
	,Confidence
	,Lift
	,[Count]
)
EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
	@LANGUAGE = N'R'
	, @SCRIPT = 
		N'
		library(arules)
	
		rules <- apriori(RulesData)
		ContosoRetailDW.dbo.RetailRulesOutput <- as(rules, "data.frame")'
	, @input_data_1 = @InputQuery
	,@input_data_1_name = N'RulesData'
	,@output_data_1_name = N'ContosoRetailDW.dbo.RetailRulesOutput';
END
