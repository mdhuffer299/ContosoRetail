USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spRetailPriceLoad
AS
BEGIN

IF OBJECT_ID('ContosoRetailDW.dbo.RetailPrice', 'U') IS NOT NULL
TRUNCATE TABLE ContosoRetailDW.dbo.RetailPrice;

INSERT INTO RetailPrice
(
	FullDate
	,TotalCost
	,SalesAmount
	,Profit
	,StoreType
	,StoreName
	,ProductName
	,ColorName
	,NorthAmericaSeason
	,HolidaySeason
	,ProductSubcategoryName
	,ProductCategoryName
	,CityName
	,PromotionName
	,DiscountPercent
	,PromotionType
)
SELECT
	CAST(CONVERT(VARCHAR,F.DateKey, 112) AS INT) AS FullDate
	,F.TotalCost
	,F.SalesAmount
	,F.SalesAmount - F.TotalCost AS Profit
	,S.StoreType
	,S.StoreName
	,P.ProductName
	,P.ColorName
	,D.NorthAmericaSeason
	,D.HolidayName
	,PS.ProductSubcategoryName
	,PC.ProductCategoryName
	,G.CityName
	,PR.PromotionName
	,PR.DiscountPercent
	,PR.PromotionType
FROM FactSales AS F
INNER JOIN DimDate AS D
ON F.DateKey = D.Datekey
INNER JOIN DimStore AS S
ON F.StoreKey = S.StoreKey
INNER JOIN DimProduct AS P
ON F.ProductKey = P.ProductKey
INNER JOIN DimProductSubcategory AS PS
ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
INNER JOIN DimProductCategory AS PC
ON PS.ProductCategoryKey = PC.ProductCategoryKey
INNER JOIN DimGeography AS G
ON S.GeographyKey = G.GeographyKey
INNER JOIN DimPromotion AS PR
ON F.PromotionKey = PR.PromotionKey
WHERE G.ContinentName = 'North America'
END;
GO
