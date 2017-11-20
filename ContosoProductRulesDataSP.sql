USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spProductRulesDataLoad
AS 
BEGIN

IF OBJECT_ID('dbo.ProductRulesData','U') IS NOT NULL
TRUNCATE TABLE dbo.ProductRulesData

INSERT INTO ContosoRetailDW.dbo.ProductRulesData
(
	SalesOrderNum
	,ProductOne
	,ProductTwo
	,ProductThree
	,ProductFour
	,ProductFive
	,ProductSix
	,ProductSeven
	,ProductEight
	,ProductNine
	,ProductTen
)
SELECT
	SalesOrderNumber AS SalesOrderNum
	,[1] AS ProductOne
	,[2] AS ProductTwo
	,[3] AS ProductThree
	,[4] AS ProductFour
	,[5] AS ProductFive
	,[6] AS ProductSix
	,[7] AS ProcuctSeven
	,[8] AS ProductEight
	,[9] AS ProductNine
	,[10] AS ProductTen
FROM
	(
		SELECT
			F.SalesOrderLineNumber
			,F.SalesOrderNumber
			,P.ProductName
		FROM ContosoRetailDW.dbo.FactOnlineSales AS F
		INNER JOIN ContosoRetailDW.dbo.DimProduct AS P
		ON F.ProductKey = P.ProductKey
	) AS SourceTable
PIVOT
(
	MAX(ProductName)
	FOR SalesOrderLineNumber IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10])
) AS PivotTable;
END