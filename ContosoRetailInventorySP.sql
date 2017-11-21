USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spRetailInventoryDataLoad
AS
BEGIN

IF OBJECT_ID('dbo.RetailInventoryData', 'U') IS NOT NULL
TRUNCATE TABLE dbo.RetailInventoryData

INSERT INTO dbo.RetailInventoryData
(
	InventoryKey
	,StoreKey
	,ProductKey
	,ProductSubcategoryKey
	,Datekey
	,GeographyKey
	,OnHandQuantity
	,OnOrderQuantity
	,SafetyStockQuantity
	,UnitCost
	,DaysInStock
	,MinDayInStock
	,MaxDayInStock
	,StoreType
	,StoreName
	,StoreDescription
	,ZipCode
	,AddressLine1
	,AddressLine2
	,ProductName
	,ProductDescription
	,Manufacturer
	,BrandName
	,ClassName
	,ColorName
	,UnitPrice
	,ProductSubcategoryName
	,ProductSubcategoryDescription
	,FullDateLabel
	,CalendarYear
	,CalendarQuarterLabel
	,CalendarMonthLabel
	,CalendarWeekLabel
	,CalendarDayOfWeekLabel
	,IsHoliday
	,HolidayName
	,NorthAmericaSeason
	,CityName
	,StateProvinceName
	,RegionCountryName
	,ContinentName
)
SELECT
	F.InventoryKey
	,S.StoreKey
	,P.ProductKey
	,PSC.ProductSubcategoryKey
	,D.Datekey
	,G.GeographyKey
	,F.OnHandQuantity
	,F.OnOrderQuantity
	,F.SafetyStockQuantity
	,F.UnitCost
	,F.DaysInStock
	,F.MinDayInStock
	,F.MaxDayInStock
	,S.StoreType
	,S.StoreName
	,S.StoreDescription
	,S.ZipCode
	,S.AddressLine1
	,S.AddressLine2
	,P.ProductName
	,P.ProductDescription
	,P.Manufacturer
	,P.BrandName
	,P.ClassName
	,P.ColorName
	,P.UnitPrice
	,PSC.ProductSubcategoryName
	,PSC.ProductSubcategoryDescription
	,D.FullDateLabel
	,D.CalendarYear
	,D.CalendarQuarterLabel
	,D.CalendarMonthLabel
	,D.CalendarWeekLabel
	,D.CalendarDayOfWeekLabel
	,D.IsHoliday
	,D.HolidayName
	,D.NorthAmericaSeason
	,G.CityName
	,G.StateProvinceName
	,G.RegionCountryName
	,G.ContinentName
FROM ContosoRetailDW.dbo.FactInventory AS F
INNER JOIN ContosoRetailDW.dbo.DimStore AS S
ON F.StoreKey = S.StoreKey
INNER JOIN ContosoRetailDW.dbo.DimProduct AS P
ON F.ProductKey = P.ProductKey
INNER JOIN ContosoRetailDW.dbo.DimProductSubcategory AS PSC
ON P.ProductSubcategoryKey = PSC.ProductSubcategoryKey
INNER JOIN ContosoRetailDW.dbo.DimDate AS D
ON F.DateKey = D.Datekey
INNER JOIN ContosoRetailDW.dbo.DimGeography AS G
ON S.GeographyKey = G.GeographyKey
WHERE G.ContinentName = 'North America';
END