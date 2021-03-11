use AdventureWorks;

-- LanguageType
INSERT INTO LanguageType VALUES('EN', 'English')
INSERT INTO LanguageType VALUES('FR', 'French')
INSERT INTO LanguageType VALUES('ES', 'Spanish')

-- ProductParentCategory English
INSERT INTO ProductParentCategory(ProductParentCategoryName, LanguageCode) select EnglishProductCategoryName, 'EN' 
			from AdventureWorksOldData.dbo.Products group by EnglishProductCategoryName;

-- ProductParentCategory French			
INSERT INTO ProductParentCategory(ProductParentCategoryName, LanguageCode) select FrenchProductCategoryName, 'FR' 
			from AdventureWorksOldData.dbo.Products group by FrenchProductCategoryName;

-- ProductParentCategory Spanish	
INSERT INTO ProductParentCategory(ProductParentCategoryName, LanguageCode) select SpanishProductCategoryName, 'ES' 
			from AdventureWorksOldData.dbo.Products group by SpanishProductCategoryName;

-- ProductSubCategory English
INSERT INTO ProductSubCategory(ProductSubCategoryName, ProductParentCategoryID, LanguageCode)
select sc.EnglishProductSubcategoryName, pc.ProductParentCategoryID, 'EN' from AdventureWorksOldData.dbo.Products p
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductParentCategory pc on pc.ProductParentCategoryName = p.EnglishProductCategoryName
group by sc.EnglishProductSubcategoryName, pc.ProductParentCategoryID order by sc.EnglishProductSubcategoryName;

-- ProductSubCategory French
INSERT INTO ProductSubCategory(ProductSubCategoryName, ProductParentCategoryID, LanguageCode)
select sc.FrenchProductSubcategoryName, pc.ProductParentCategoryID, 'FR' from AdventureWorksOldData.dbo.Products p
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductParentCategory pc on pc.ProductParentCategoryName = p.FrenchProductCategoryName
group by sc.FrenchProductSubcategoryName, pc.ProductParentCategoryID order by sc.FrenchProductSubcategoryName;

-- ProductSubCategory Spanish
INSERT INTO ProductSubCategory(ProductSubCategoryName, ProductParentCategoryID, LanguageCode)
select sc.SpanishProductSubcategoryName, pc.ProductParentCategoryID, 'ES' from AdventureWorksOldData.dbo.Products p
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductParentCategory pc on pc.ProductParentCategoryName = p.SpanishProductCategoryName
group by sc.SpanishProductSubcategoryName, pc.ProductParentCategoryID order by sc.SpanishProductSubcategoryName;

-- ProductModelName
INSERT INTO AdventureWorks.dbo.ProductModel(ProductModelName) select ModelName from AdventureWorksOldData.dbo.products group by ModelName;

-- ProductColor
INSERT INTO ProductColor(ProductColorName, LanguageCode) select Color, 'EN' from AdventureWorksOldData.dbo.products group by Color;

-- ProductSizeRange
INSERT INTO ProductSizeRange select SizeRange, SizeUnitMeasureCode from AdventureWorksOldData.dbo.products group by SizeRange, SizeUnitMeasureCode;

-- ProductSize
INSERT INTO ProductSize(SizeRange, Size) SELECT psr.SizeRange, [Size] FROM AdventureWorksOldData.dbo.Products p inner join ProductSizeRange psr on psr.SizeRange = p.SizeRange where size is not null group by [Size], psr.SizeRange;

-- ProductWeight
INSERT INTO ProductWeight(WeightUnitMeasureCode, Weight) select WeightUnitMeasureCode, Weight from AdventureWorksOldData.dbo.Products where Weight is not null group by Weight, WeightUnitMeasureCode;

-- Currency
INSERT INTO Currency(CurrencyCode, CurrencyName, LanguageCode) select CurrencyAlternateKey, CurrencyName, 'EN' from AdventureWorksOldData.dbo.Currency

-- Status
INSERT INTO Status select [Status] from AdventureWorksOldData.dbo.Products where status is not null group by [Status]; 

-- Product
SET IDENTITY_INSERT Product ON
INSERT INTO Product(
    ProductID,
    ProductModelName, ProductSizeID, ProductWeightID,
    StandardCost, FinishedGoodsFlag, SafetyStockLevel, ListPrice,
    DaysToManufacture, ProductLine, DealerPrice, Class, Style, StatusName)
SELECT
    p.ProductKey,
    p.ModelName, 
    ps.ProductSizeID,
    pw.ProductWeightID,
    p.StandardCost,
    p.FinishedGoodsFlag,
    p.SafetyStockLevel,
    p.ListPrice,
    p.DaysToManufacture,
    p.ProductLine,
    p.DealerPrice,
    p.Class,
    p.Style,
    s.StatusName
from AdventureWorksOldData.dbo.Products p 
inner join AdventureWorksOldData.dbo.ProductSubCategory psc on p.ProductSubcategoryKey = psc.ProductSubcategoryKey
left join ProductSize ps on p.[Size] = ps.[Size] 
left join ProductWeight pw on p.Weight = pw.Weight
left join [Status] s on s.StatusName = p.[Status]
SET IDENTITY_INSERT Product OFF

-- ProductLanguage English
INSERT INTO ProductLanguage(LanguageCode, ProductID, ProductName, ProductDescription, ProductSubCategoryID, ProductColorName)
select 'EN', ProductKey, EnglishProductName, EnglishDescription, psc.ProductSubCategoryID, p.Color from AdventureWorksOldData.dbo.Products p 
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductSubCategory psc on psc.ProductSubCategoryName = sc.EnglishProductSubcategoryName
left join ProductColor pc on pc.ProductColorName = p.Color

-- ProductLanguage French
INSERT INTO ProductLanguage(LanguageCode, ProductID, ProductName, ProductDescription, ProductSubCategoryID, ProductColorName)
select 'FR', ProductKey,  FrenchProductName,  FrenchDescription, psc.ProductSubCategoryID, p.Color from AdventureWorksOldData.dbo.Products p 
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductSubCategory psc on psc.ProductSubCategoryName = sc. FrenchProductSubcategoryName
left join ProductColor pc on pc.ProductColorName = p.ColoR

-- ProductLanguage Spanish
INSERT INTO ProductLanguage(LanguageCode, ProductID, ProductName, ProductDescription, ProductSubCategoryID, ProductColorName)
select 'ES', ProductKey,  SpanishProductName,  SpanishProductCategoryName, psc.ProductSubCategoryID, p.Color from AdventureWorksOldData.dbo.Products p 
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join ProductSubCategory psc on psc.ProductSubCategoryName = sc. SpanishProductSubcategoryName
left join ProductColor pc on pc.ProductColorName = p.Color;

-- Lógica para Migração Tabela Customer

-- SalesTerritoryRegion
-- Função Auxiliar
GO
CREATE OR ALTER FUNCTION fn_getSalesTerritoryGroupFK
(@SalesTerritoryGroupName nvarchar(50))
RETURNS int
AS
BEGIN
	DECLARE @STGroupID int
	SELECT @STGroupID = SalesTerritoryGroupID FROM SalesTerritoryGroup
	WHERE SalesTerritoryGroupName = @SalesTerritoryGroupName;

	RETURN @STGroupID
END
GO

-- PostalCode
-- Função Auxiliar
GO
CREATE OR ALTER FUNCTION fn_getPostalCodeFK
(@CityName nvarchar(100))
RETURNS int
AS
BEGIN
	DECLARE @CityID int
	SELECT @CityID = CityID FROM City
	WHERE CityName = @CityName;

	RETURN @CityID
END
GO

-- Address
-- Função Auxiliar
GO
CREATE OR ALTER FUNCTION fn_getAddressFK
(@PostalCode nvarchar(15))
RETURNS int
AS
BEGIN
	DECLARE @PostalCodeID int
	SELECT @PostalCodeID = PostalCodeID FROM PostalCode
	WHERE PostalCode = @PostalCode;

	RETURN @PostalCodeID
END
GO

-- CustomerAddress
-- Função Auxiliar
GO
CREATE OR ALTER FUNCTION fn_getCustomerAddressFK
(@AddressLine1 nvarchar(100))
RETURNS int
AS
BEGIN
	DECLARE @AddressID int
	SELECT @AddressID = AddressID FROM Address
	WHERE AddressLine1 = @AddressLine1;

	RETURN @AddressID
END
GO

-- Occupation
INSERT INTO Occupation(Title) 
select Occupation 
from AdventureWorksOldData.dbo.Customer
group by Occupation
 
-- Education
INSERT INTO Education(Title) 
select Education 
from AdventureWorksOldData.dbo.Customer
group by Education
 
-- SalesTerritoryGroup
INSERT INTO SalesTerritoryGroup(SalesTerritoryGroupName) 
select SalesTerritoryGroup
from AdventureWorksOldData.dbo.SalesTerritory
group by SalesTerritoryGroup
 
-- SalesTerritoryRegion
SET IDENTITY_INSERT AdventureWorks.dbo.SalesTerritoryRegion ON;
INSERT INTO AdventureWorks.dbo.SalesTerritoryRegion
    (SalesTerritoryRegionID, SalesTerritoryRegionName, SalesTerritoryGroupID)
SELECT  SalesTerritoryKey, SalesTerritoryRegion,
        dbo.fn_getSalesTerritoryGroupFK(SalesTerritoryGroup)
FROM AdventureWorksOldData.dbo.SalesTerritory;
SET IDENTITY_INSERT AdventureWorks.dbo.SalesTerritoryRegion OFF;
 
-- Country
--EUROPE
INSERT INTO Country(CountryCode,CountryName,SalesTerritoryGroupID) 
select CountryRegionCode, CountryRegionName,1
from AdventureWorksOldData.dbo.Customer
WHERE CountryRegionCode NOT LIKE 'US' AND CountryRegionCode NOT LIKE 'CA' AND CountryRegionCode NOT LIKE 'AU'
GROUP BY CountryRegionCode, CountryRegionName
 
--N.AMERICA
INSERT INTO Country(CountryCode,CountryName,SalesTerritoryGroupID) 
select CountryRegionCode, CountryRegionName,3
from AdventureWorksOldData.dbo.Customer
WHERE CountryRegionCode = 'US' OR CountryRegionCode = 'CA'
GROUP BY CountryRegionCode, CountryRegionName
 
--PACIFIC
INSERT INTO Country(CountryCode,CountryName,SalesTerritoryGroupID) 
select CountryRegionCode, CountryRegionName,4
from AdventureWorksOldData.dbo.Customer
WHERE CountryRegionCode = 'AU'
GROUP BY CountryRegionCode, CountryRegionName
 
 
-- StateProvince
INSERT INTO StateProvince(StateProvinceCode,StateProvinceName,CountryCode) 
select StateProvinceCode,StateProvinceName,CountryRegionCode
from AdventureWorksOldData.dbo.Customer
group by StateProvinceCode,StateProvinceName,CountryRegionCode
 
--City
INSERT INTO City(CityName,StateProvinceCode) 
select City,StateProvinceCode
from AdventureWorksOldData.dbo.Customer
group by City,StateProvinceCode
 
--PostalCode
INSERT INTO PostalCode(PostalCode,CityID) 
select PostalCode,
    dbo.fn_getPostalCodeFK(City)
from AdventureWorksOldData.dbo.Customer
GROUP BY PostalCode,
    dbo.fn_getPostalCodeFK(City)
 
-- Address
INSERT INTO Address(AddressLine1,AddressLine2,PostalCodeID) 
select AddressLine1,AddressLine2,
        dbo.fn_getAddressFK(PostalCode)
from AdventureWorksOldData.dbo.Customer
GROUP BY AddressLine1,AddressLine2,
        dbo.fn_getAddressFK(PostalCode)
        
-- Customer
INSERT INTO Customer(
Title,FirstName,MiddleName,LastName,NameStyle,
BirthDate,MaritalStatus,Gender,EmailAddress,YearlyIncome,
TotalChildren,NumberChildrenAtHome,EducationID,OccupationID,
HouseOwnerFlag,NumberCarsOwned,Phone,DateFirstPurchase,CommuteDistance, cc.CountryCode) 
SELECT
    c.Title,
    c.FirstName,
    c.MiddleName,
    c.LastName,
    c.NameStyle,
    c.BirthDate,
    c.MaritalStatus,
    c.Gender,
    c.EmailAddress,
    c.YearlyIncome,
    c.TotalChildren,
    c.NumberChildrenAtHome,
    edu.EducationID,
    ocu.OccupationID,
    c.HouseOwnerFlag,
    c.NumberCarsOwned,
    c.Phone,
    c.DateFirstPurchase,
    c.CommuteDistance,
    cc.CountryCode
FROM AdventureWorksOldData.dbo.Customer c
    INNER JOIN AdventureWorksOldData.dbo.Customer co ON c.CustomerKey = co.CustomerKey
    LEFT JOIN Education edu ON c.Education = edu.Title
    LEFT JOIN Occupation ocu ON c.Occupation = ocu.Title
    LEFT JOIN Country cc ON c.CountryRegionCode = cc.CountryCode
 
-- CustomerAddress
INSERT INTO CustomerAddress(CustomerID,AddressID)
SELECT c.CustomerID,dbo.fn_getCustomerAddressFK(AddressLine1)
FROM Customer 
RIGHT JOIN AdventureWorksOldData.dbo.Customer o ON o.CustomerKey = CustomerID
RIGHT JOIN Customer c ON c.EmailAddress = o.EmailAddress
ORDER BY c.CustomerID
 
-- SalesOrder
insert into SalesOrder(SalesOrderNumber, CustomerID, OrderDate, DueDate, ShipDate, SalesAmount) 
select SalesOrderNumber, (CustomerKey - 10999), OrderDate, DueDate, ShipDate, sum(SalesAmount) 
from AdventureWorksOldData.dbo.Sales group by SalesOrderNumber, CustomerKey, OrderDate, DueDate, ShipDate

-- SalesOrderDetail
insert into SalesOrderDetail(SalesOrderNumber, ProductID, OrderQty, CurrencyID, UnitPrice, OrderTotal) 
select 
SalesOrderNumber, 
ProductKey, OrderQuantity, cc.CurrencyID, UnitPrice,
UnitPrice * OrderQuantity
from AdventureWorksOldData.dbo.Sales s
inner join AdventureWorksOldData.dbo.Currency c on c.CurrencyKey = s.CurrencyKey 
inner join Currency cc on cc.CurrencyCode = c.CurrencyAlternateKey


drop FUNCTION fn_getSalesTerritoryGroupFK;
drop FUNCTION fn_getPostalCodeFK;
drop FUNCTION fn_getAddressFK;
drop FUNCTION fn_getCustomerAddressFK;

