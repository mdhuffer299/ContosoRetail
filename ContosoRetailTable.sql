USE ContosoRetailDW;
GO

--Execute the following Scripts for Apiori Associative Rules Model
CREATE TABLE ContosoRetailDW.dbo.RetailRulesOutput
(
	Rules NVARCHAR(MAX)
	,Support FLOAT
	,Confidence FLOAT
	,Lift FLOAT
	,Count INT
)

CREATE TABLE ContosoRetailDW.dbo.ProductRulesData
(
	SalesOrderNum NVARCHAR(20)
	,ProductOne NVARCHAR(500)
	,ProductTwo NVARCHAR(500)
	,ProductThree NVARCHAR(500)
	,ProductFour NVARCHAR(500)
	,ProductFive NVARCHAR(500)
	,ProductSix NVARCHAR(500)
	,ProductSeven NVARCHAR(500)
	,ProductEight NVARCHAR(500)
	,ProductNine NVARCHAR(500)
	,ProductTen NVARCHAR(500)
)





--Tables for Regression Model: Still working on
CREATE TABLE ContosoRetailDW.dbo.RetailSalesData
(
	SalesKey INT NOT NULL
	,StoreKey INT NOT NULL
	,ProductKey INT NOT NULL
	,Datekey DATETIME NOT NULL
	,ProductCategoryKey INT NOT NULL
	,ProductSubcategoryKey INT NOT NULL
	,ChannelKey INT NOT NULL
	,GeographyKey INT NOT NULL
	,PromotionKey INT NOT NULL
	,UnitCost MONEY
	,UnitPrice MONEY
	,SalesQuantity INT
	,ReturnQuantity INT
	,ReturnAmount MONEY
	,DiscountQuantity INT
	,DiscountAmount MONEY
	,TotalCost MONEY
	,SalesAmount MONEY
	,StoreType NVARCHAR(15)
	,StoreName NVARCHAR(100)
	,StoreDescription NVARCHAR(300)
	,ZipCode NVARCHAR(20)
	,AddressLine1 NVARCHAR(100)
	,AddressLine2 NVARCHAR(100)
	,EmployeeCount INT
	,ProductName NVARCHAR(500)
	,ProductDescription NVARCHAR(400)
	,Manufacturer NVARCHAR(50)
	,BrandName NVARCHAR(50)
	,ClassName NVARCHAR(20)
	,ColorName NVARCHAR(20)
	,FullDateLabel NVARCHAR(20)
	,CalendarDayOfWeekLabel NVARCHAR(10)
	,CalendarWeekLabel NVARCHAR(20)
	,CalendarMonthLabel NVARCHAR(20)
	,CalendarQuarterLabel NVARCHAR(20)
	,CalendarYearLabel NVARCHAR(20)
	,NorthAmericaSeason NVARCHAR(50)
	,ProductSubcategoryName NVARCHAR(50)
	,ProductSubcategoryDescription NVARCHAR(100)
	,ProductCategoryName NVARCHAR(30)
	,ProductCategoryDescription NVARCHAR(50)
	,ChannelName NVARCHAR(20)
	,ChannelDescription NVARCHAR(50)
	,GeographyType NVARCHAR(50)
	,ContinentName NVARCHAR(50)
	,CityName NVARCHAR(100)
	,StateProvinceName NVARCHAR(100)
	,RegionCountryName NVARCHAR(100)
	,PromotionName NVARCHAR(100)
	,PromotionDescription NVARCHAR(255)
	,DiscountPercent FLOAT
	,PromotionType NVARCHAR(50)
	,PromotionCategory NVARCHAR(50)
)

CREATE TABLE ContosoRetailDW.dbo.RetailInventoryData
(
	InventoryKey INT NOT NULL
	,StoreKey INT NOT NULL
	,ProductKey INT NOT NULL
	,ProductSubcategoryKey INT NOT NULL
	,Datekey DATETIME NOT NULL
	,GeographyKey INT NOT NULL
	,OnHandQuantity INT 
	,OnOrderQuantity INT
	,SafetyStockQuantity INT
	,UnitCost MONEY
	,DaysInStock INT
	,MinDayInStock INT
	,MaxDayInStock INT
	,StoreType NVARCHAR(15)
	,StoreName NVARCHAR(100)
	,StoreDescription NVARCHAR(300)
	,ZipCode NVARCHAR(20)
	,AddressLine1 NVARCHAR(100)
	,AddressLine2 NVARCHAR(100)
	,ProductName NVARCHAR(500)
	,ProductDescription NVARCHAR(400)
	,Manufacturer NVARCHAR(50)
	,BrandName NVARCHAR(50)
	,ClassName NVARCHAR(20)
	,ColorName NVARCHAR(20)
	,UnitPrice MONEY
	,ProductSubcategoryName NVARCHAR(50)
	,ProductSubcategoryDescription NVARCHAR(100)
	,FullDateLabel NVARCHAR(20)
	,CalendarYear INT
	,CalendarQuarterLabel NVARCHAR(20)
	,CalendarMonthLabel NVARCHAR(20)
	,CalendarWeekLabel NVARCHAR(20)
	,CalendarDayOfWeekLabel NVARCHAR(10)
	,IsHoliday INT
	,HolidayName NVARCHAR(20)
	,NorthAmericaSeason NVARCHAR(50)
	,CityName NVARCHAR(100)
	,StateProvinceName NVARCHAR(100)
	,RegionCountryName NVARCHAR(100)
	,ContinentName NVARCHAR(50)
)


CREATE TABLE ContosoRetailDW.dbo.Models
(
	Model_ID INT IDENTITY(1,1) NOT NULL 
	,Model VARBINARY(MAX) NOT NULL
	,DateCreated DATETIME DEFAULT GETDATE()
);
