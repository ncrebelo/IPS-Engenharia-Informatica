CREATE DATABASE AdventureWorksOldData;
GO
use AdventureWorksOldData;

CREATE TABLE Currency(
	CurrencyKey int UNIQUE NOT NULL,
	CurrencyAlternateKey nchar(3) UNIQUE NOT NULL,
	CurrencyName nvarchar(50) NOT NULL,
	PRIMARY KEY (CurrencyKey)
);

CREATE TABLE Customer(
	CustomerKey int UNIQUE NOT NULL,
	Title nvarchar(8),
	FirstName nvarchar(50) NOT NULL,
	MiddleName nvarchar(50),
	LastName nvarchar(50) NOT NULL,
	NameStyle bit NOT NULL DEFAULT 0,
	BirthDate date NOT NULL,
	MaritalStatus nchar(1) NOT NULL,
	Gender nvarchar(1) NOT NULL,
	EmailAddress nvarchar(50) NOT NULL UNIQUE,
	YearlyIncome money,
	TotalChildren tinyint,
	NumberChildrenAtHome tinyint,
	Education nvarchar(40),
	Occupation nvarchar(100),
	HouseOwnerFlag bit,
	NumberCarsOwned tinyint,
	AddressLine1 nvarchar(50) NOT NULL,
	AddressLine2 nvarchar(50),
	City nvarchar(50) NOT NULL,
	StateProvinceCode nvarchar(3) NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryRegionCode nvarchar(3) NOT NULL,
	CountryRegionName nvarchar(50) NOT NULL,
	PostalCode nvarchar(15) NOT NULL,
	SalesTerritoryKey int,
	Phone nvarchar(20),
	DateFirstPurchase date,
	CommuteDistance nvarchar(15),
	PRIMARY KEY (CustomerKey)
);

CREATE TABLE Products(
	ProductKey int UNIQUE NOT NULL,
	ProductSubcategoryKey int NOT NULL,
	EnglishProductCategoryName nvarchar(80) NOT NULL,
	FrenchProductCategoryName nvarchar(80) NOT NULL,
	SpanishProductCategoryName nvarchar(80) NOT NULL,
	WeightUnitMeasureCode nchar(3),
	SizeUnitMeasureCode nchar(3),
	EnglishProductName nvarchar(80) NOT NULL,
	SpanishProductName nvarchar(80), 
	FrenchProductName nvarchar(80), 
	StandardCost money,
	FinishedGoodsFlag bit NOT NULL,
	Color nvarchar(15),
	SafetyStockLevel int,
	ListPrice money,
	Size nchar(3),
	SizeRange nvarchar(60), 
	Weight float,
	DaysToManufacture int,
	ProductLine nchar(3),
	DealerPrice money,
	Class nchar(2),
	Style nchar(2),
	ModelName nvarchar(80),
	EnglishDescription nvarchar(300),
	FrenchDescription nvarchar(300),
	Status nvarchar(7),
	PRIMARY KEY (ProductKey)
);

CREATE TABLE ProductSubCategory(
	ProductSubcategoryKey int UNIQUE NOT NULL,
	EnglishProductSubcategoryName nvarchar(30),
	SpanishProductSubcategoryName nvarchar(30),
	FrenchProductSubcategoryName nvarchar(30),
	PRIMARY KEY (ProductSubcategoryKey)
);

CREATE TABLE Sales(
	ProductKey int,
	CustomerKey int,
	CurrencyKey int,
	SalesTerritoryRegion nvarchar(30),
	SalesTerritoryCountry nvarchar(15),
	SalesOrderNumber nvarchar(20) NOT NULL,
	SalesOrderLineNumber int NOT NULL,
	OrderQuantity int NOT NULL,
	UnitPrice money,
	SalesAmount money,
	OrderDate date,
	DueDate date,
	ShipDate date,
);

CREATE TABLE SalesTerritory(
	SalesTerritoryKey int UNIQUE NOT NULL,
	SalesTerritoryRegion nvarchar(30),
	SalesTerritoryCountry nvarchar(15),
	SalesTerritoryGroup nvarchar(15),
	PRIMARY KEY (SalesTerritoryKey,SalesTerritoryRegion,SalesTerritoryCountry)
);

