USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spRetailSalesDataLoad
AS
BEGIN

IF OBJECT_ID('dbo.RetailSalesData', 'U') IS NOT NULL
TRUNCATE TABLE dbo.RetailSalesData

INSERT INTO dbo.RetailSalesData
(
	SalesKey
	,StoreKey
	,ProductKey
	,Datekey
	,ProductCategoryKey
	,ProductSubcategoryKey
	,ChannelKey
	,GeographyKey
	,PromotionKey
	,UnitCost
	,UnitPrice
	,SalesQuantity
	,ReturnQuantity
	,ReturnAmount
	,DiscountQuantity
	,DiscountAmount
	,TotalCost
	,SalesAmount
	,Profit
	,StoreType
	,StoreName
	,StoreDescription
	,ZipCode
	,AddressLine1
	,AddressLine2
	,EmployeeCount
	,ProductName
	,ProductDescription
	,Manufacturer
	,BrandName
	,ClassName
	,ColorName
	,FullDateLabel
	,CalendarDayOfWeekLabel
	,CalendarWeekLabel
	,CalendarMonthLabel
	,CalendarQuarterLabel
	,CalendarYearLabel
	,NorthAmericaSeason
	,ProductSubcategoryName
	,ProductSubcategoryDescription
	,ProductCategoryName
	,ProductCategoryDescription
	,ChannelName
	,ChannelDescription
	,GeographyType
	,ContinentName
	,CityName
	,StateProvinceName
	,RegionCountryName
	,PromotionName
	,PromotionDescription
	,DiscountPercent
	,PromotionType
	,PromotionCategory
)
SELECT
	F.SalesKey
	,S.StoreKey
	,P.ProductKey
	,CAST(CONVERT(VARCHAR,D.Datekey, 112) AS INT) AS DateKey
	,PC.ProductCategoryKey
	,PS.ProductSubcategoryKey
	,CH.ChannelKey
	,G.GeographyKey
	,PRO.PromotionKey
	,F.UnitCost
	,F.UnitPrice
	,F.SalesQuantity
	,F.ReturnQuantity
	,F.ReturnAmount
	,F.DiscountQuantity
	,F.DiscountAmount
	,F.TotalCost
	,F.SalesAmount
	,F.SalesAmount - F.TotalCost AS Profit
	,S.StoreType
	,S.StoreName
	,S.StoreDescription
	,S.ZipCode
	,S.AddressLine1
	,S.AddressLine2
	,S.EmployeeCount
	,P.ProductName
	,P.ProductDescription
	,P.Manufacturer
	,P.BrandName
	,P.ClassName
	,P.ColorName
	,D.FullDateLabel
	,D.CalendarDayOfWeekLabel
	,D.CalendarWeekLabel
	,D.CalendarMonthLabel
	,D.CalendarQuarterLabel
	,D.CalendarYearLabel
	,D.NorthAmericaSeason
	,PS.ProductSubcategoryName
	,PS.ProductSubcategoryDescription
	,PC.ProductCategoryName
	,PC.ProductCategoryDescription
	,CH.ChannelName
	,CH.ChannelDescription
	,G.GeographyType
	,G.ContinentName
	,G.CityName
	,G.StateProvinceName
	,G.RegionCountryName
	,PRO.PromotionName
	,PRO.PromotionDescription
	,PRO.DiscountPercent
	,PRO.PromotionType
	,PRO.PromotionCategory
FROM ContosoRetailDW.dbo.FactSales AS F
INNER JOIN ContosoRetailDW.dbo.DimStore AS S
ON F.StoreKey = S.StoreKey
INNER JOIN ContosoRetailDW.dbo.DimProduct AS P
ON F.ProductKey = P.ProductKey
INNER JOIN ContosoRetailDW.dbo.DimDate AS D
ON F.DateKey = D.Datekey
INNER JOIN ContosoRetailDW.dbo.DimProductSubcategory AS PS
ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
INNER JOIN ContosoRetailDW.dbo.DimProductCategory AS PC
ON PS.ProductCategoryKey = PC.ProductCategoryKey
INNER JOIN ContosoRetailDW.dbo.DimChannel AS CH
ON F.channelKey = CH.ChannelKey
INNER JOIN ContosoRetailDW.dbo.DimGeography AS G
ON S.GeographyKey = G.GeographyKey
INNER JOIN ContosoRetailDW.dbo.DimPromotion AS PRO
ON F.PromotionKey = PRO.PromotionKey
WHERE G.ContinentName = 'North America';
END

