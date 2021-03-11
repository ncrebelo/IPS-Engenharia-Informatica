drop database AdventureWorks

 
-- Criação dos FileGroups

CREATE DATABASE[AdventureWorks] 
ON PRIMARY
( NAME = primaryFG, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks_Project\primaryFG.mdf',
 SIZE = 2048KB , FILEGROWTH = 1024KB ),

FILEGROUP [FG_Customer] 
( NAME = FG_Customer1, 
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks_Project\FG_Customer1.ndf',
  SIZE = 5120KB , FILEGROWTH = 1024KB ),

  FILEGROUP [FG_Sales] 
( NAME = FG_Sales1, 
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks_Project\FG_Sales1.ndf',
  SIZE = 5632KB , FILEGROWTH = 2048KB ),

  FILEGROUP [FG_Product] 
( NAME = FG_Product1, 
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks_Project\FG_Product1.ndf', 
  SIZE = 2048KB , FILEGROWTH = 512KB ) 
 
 
use AdventureWorks;
 
CREATE TABLE Country
(
    CountryCode nvarchar(3) NOT NULL UNIQUE, -- PK
    CountryName nvarchar(50) NOT NULL,
    SalesTerritoryGroupID int -- FK
    PRIMARY KEY (CountryCode)
	ON[FG_Customer]
);
 
CREATE TABLE StateProvince
(
    StateProvinceCode nvarchar(3) UNIQUE NOT NULL, -- PK
    StateProvinceName nvarchar(50) NOT NULL,
    CountryCode nvarchar(3) NOT NULL, -- FK
    PRIMARY KEY (StateProvinceCode)
	ON[FG_Customer]
);
 
CREATE TABLE City
(
    CityID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    CityName nvarchar(50) NOT NULL,
    StateProvinceCode nvarchar(3) NOT NULL, -- FK
    PRIMARY KEY (CityID)
	ON[FG_Customer]
);
 
CREATE TABLE PostalCode
(
    PostalCodeID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    PostalCode nvarchar(15) NOT NULL,
    CityID int NOT NULL, -- FK
    PRIMARY KEY (PostalCodeID)
	ON[FG_Customer]
);
 
CREATE TABLE Address
(
    AddressID int NOT NULL UNIQUE IDENTITY(1, 1), --PK
    AddressLine1 nvarchar(120),
    AddressLine2 nvarchar(120),
    PostalCodeID int NOT NULL, -- FK
    PRIMARY KEY (AddressID)
	ON[FG_Customer]
);
 
CREATE TABLE CustomerAddress
(
    CustomerID int, -- PK, FK
    AddressID int -- PK, FK
    PRIMARY KEY (CustomerID, AddressID)
	ON[FG_Customer]
);
 
CREATE TABLE Customer
(
    CustomerID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
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
    EducationID int, -- FK
    OccupationID int, -- FK
    HouseOwnerFlag bit,
    NumberCarsOwned tinyint,
    Phone nvarchar(20),
    DateFirstPurchase date null,
    CommuteDistance nvarchar(15) null,
    CountryCode NVARCHAR(3) -- FK
    PRIMARY KEY (CustomerID)
	ON[FG_Customer]
);
 
CREATE TABLE Education
(
    EducationID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    Title nvarchar(128) NOT NULL,
    PRIMARY KEY (EducationID)
	ON[FG_Customer]
);
 
CREATE TABLE Occupation
(
    OccupationID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    Title nvarchar(128) NOT NULL,
    PRIMARY KEY (OccupationID)
	ON[FG_Customer]
);
 
CREATE TABLE SentEmail
(
    SentEmailID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    EmployeeNumber nvarchar(30) NOT NULL, -- FK
    Subject nvarchar(100),
    Content nvarchar(MAX),
    CreatedAt datetime
    PRIMARY KEY (SentEmailID)
	ON[PRIMARY]
);
 
CREATE TABLE Currency
(
    CurrencyID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    CurrencyCode nchar(3) UNIQUE NOT NULL,
    CurrencyName nvarchar(50) NOT NULL,
    LanguageCode nvarchar(10) NOT NULL,-- FK
    PRIMARY KEY (CurrencyID)
	ON[FG_Sales]
);
 
CREATE TABLE SalesOrder
(
    SalesOrderNumber nvarchar(20) UNIQUE NOT NULL, -- PK
    CustomerID int NOT NULL, -- FK
    OrderDate date NOT NULL,
    DueDate date NOT NULL,
    ShipDate date NOT NULL,
    SalesAmount money,
    SaleStatus nvarchar(7) DEFAULT 'Open'
    PRIMARY KEY (SalesOrderNumber)
	ON[FG_Sales]
);
 
CREATE TABLE SalesOrderDetail
(
    SalesOrderDetailID int NOT NULL UNIQUE IDENTITY(1, 1), --PK
    SalesOrderNumber nvarchar(20) NOT NULL, --FK PK
    ProductID int NOT NULL, -- FK
    OrderQty smallint NOT NULL, 
    CurrencyID int, -- FK
    UnitPrice money NOT NULL,
    OrderTotal money NOT NULL,
    PromotionID int NULL -- FK
    PRIMARY KEY (SalesOrderDetailID)
	ON[FG_Sales]
);
 
CREATE TABLE SalesTerritoryGroup
(
    SalesTerritoryGroupID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    SalesTerritoryGroupName nvarchar(50) NOT NULL,
    PRIMARY KEY (SalesTerritoryGroupID)
	ON[FG_Sales]
);
 
CREATE TABLE SalesTerritoryRegion
(
    SalesTerritoryRegionID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    SalesTerritoryRegionName nvarchar(50) NOT NULL,
    SalesTerritoryGroupID int -- FK
    PRIMARY KEY (SalesTerritoryRegionID)
	ON[FG_Sales]
);
 
CREATE TABLE ProductColor
(
    ProductColorName nvarchar(50) UNIQUE NOT NULL, -- PK
    LanguageCode nvarchar(10) NOT NULL, -- FK
    PRIMARY KEY (ProductColorName)
	ON[FG_Product]
);
 
CREATE TABLE ProductParentCategory
(
    ProductParentCategoryID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    ProductParentCategoryName nvarchar (100) UNIQUE NOT NULL,
    LanguageCode nvarchar(10) NOT NULL -- FK
    PRIMARY KEY (ProductParentCategoryID)
	ON[FG_Product]
);
 
CREATE TABLE ProductSubCategory
(
    ProductSubCategoryID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    ProductSubCategoryName nvarchar (100) UNIQUE NOT NULL,
    ProductParentCategoryID int NOT NULL, --FK
    LanguageCode nvarchar(10) NOT NULL, -- FK
    PRIMARY KEY (ProductSubCategoryID)
	ON[FG_Product]
);
 
CREATE TABLE ProductLanguage
(
    LanguageCode NVARCHAR(10) NOT NULL, -- PK
    ProductID int NOT NULL, -- PK, FK
    ProductName nvarchar(50),
    ProductDescription nvarchar(MAX),
    ProductSubCategoryID int, -- FK
    ProductColorName nVARCHAR(50), --FK
    PRIMARY KEY (ProductID, LanguageCode)
	ON[FG_Product]
);
 
CREATE TABLE ProductModel
(
    ProductModelName nvarchar(50) UNIQUE NOT NULL,-- PK
    PRIMARY KEY (ProductModelName)
	ON[FG_Product]
);
 
CREATE TABLE Product
(
    ProductID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    ProductModelName NVARCHAR(50) NOT NULL, -- FK
    ProductSizeID int, -- FK
    ProductWeightID int, --FK
    StandardCost money,
    FinishedGoodsFlag bit NOT NULL,
    SafetyStockLevel smallint,
    ListPrice money,
    DaysToManufacture int,
    ProductLine nchar(3),
    DealerPrice money,
    Class nchar(2),
    Style nchar(2),
    StatusName nvarchar(7) -- FK
    PRIMARY KEY (ProductID)
	ON[FG_Product]
);
 
CREATE TABLE ProductSize
(
    ProductSizeID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    SizeRange NVARCHAR(15) NOT NULL, -- FK
    Size nvarchar (10)
    PRIMARY KEY (ProductSizeID)
	ON[FG_Product]
);
 
 
CREATE TABLE ProductWeight
(
    ProductWeightID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    WeightUnitMeasureCode nchar(3),
    Weight float,
    PRIMARY KEY (ProductWeightID)
	ON[FG_Product]
);
 
 
CREATE TABLE ProductSizeRange
(
    SizeRange NVARCHAR(15) UNIQUE NOT NULL, -- PK
    SizeUnitMeasureCode nchar(3),
    PRIMARY KEY (SizeRange)
	ON[FG_Product]
);
 
CREATE TABLE Status
(
    StatusName nvarchar(7) UNIQUE NOT NULL, -- PK
    PRIMARY KEY (StatusName)
	ON[FG_Product]
);
 
CREATE TABLE LanguageType
(
    LanguageCode NVARCHAR(10) UNIQUE NOT NULL, -- PK
    LanguageName nvarchar(30) NOT NULL,
    PRIMARY KEY (LanguageCode)
	ON[FG_Product]
);
 
CREATE TABLE Employee
(
    EmployeeNumber nvarchar(30) UNIQUE NOT NULL, -- PK
    FirstName nvarchar(30) NOT NULL,
    MiddleName nvarchar(30),
    LastName nvarchar(30) NOT NULL,
    UserName nvarchar(30) NOT NULL,
    EmailAddress nvarchar(30) UNIQUE NOT NULL,
    Password nvarchar(50),
    ResetPassword nvarchar(50),
    PRIMARY KEY (EmployeeNumber)
	ON[PRIMARY]
);
 
CREATE TABLE QuestionList 
(
    QuestionID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    Question VARCHAR(MAX) NOT NULL,
    PRIMARY KEY (QuestionID)
	ON[PRIMARY]
)
 
CREATE TABLE QuestionAnswer 
(
    QuestionID int UNIQUE NOT NULL, -- PK
    EmployeeNumber nvarchar(30) NOT NULL, -- FK
    Answer VARCHAR(MAX) not null,
    PRIMARY KEY (QuestionID, EmployeeNumber)
	ON[PRIMARY]
)
 
CREATE TABLE Error_Messages
(
    ErrorCode int UNIQUE NOT NULL IDENTITY(9000, 10), -- PK
    ErrorMessage nvarchar(100),
    PRIMARY KEY (ErrorCode)
	ON[PRIMARY]
);
 
CREATE TABLE Error_Log
(
    ErrorLogID int UNIQUE NOT NULL IDENTITY(1, 1), -- PK
    ErrorCode int NOT NULL, -- FK
    ErrorDetail nvarchar(255),
    ErrorUser nvarchar(30) NOT NULL DEFAULT CURRENT_USER,
    ErrorTimeStamp datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ErrorLogID)
	ON[PRIMARY]
);
 
CREATE TABLE Promotions
(
    PromotionID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    PromotionCode nvarchar(3) NOT NULL,
    PromotionType nvarchar(100) NOT NULL,
    PromotionStartDate date NOT NULL,
    PromotionEndDate date NOT NULL,
    PRIMARY KEY (PromotionID)
	ON[FG_Sales]
);
 
CREATE TABLE Company
(
    CompanyID int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    SalesTerritoryGroupID int NOT NULL, -- FK
    EmailAddress nvarchar(50) NOT NULL UNIQUE,
    Phone NVARCHAR(20)
    PRIMARY KEY (CompanyID)
	ON[FG_Sales]
);
 
CREATE TABLE MonitoringStructure
(
    MonitoringStructureID  int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    TableName  VARCHAR(50) NOT NULL,
    ColumnName VARCHAR(50) NOT NULL,
    DataType VARCHAR(15) NOT NULL,
    Length int,
    ReferencedTable VARCHAR(50),
    ReferencedColumn VARCHAR(50),
    UpdateRule VARCHAR(20),
    DeleteRule VARCHAR(20),
    CreatedAt datetime NOT NULL,
    PRIMARY KEY (MonitoringStructureID)
	ON[PRIMARY]
)
 
 CREATE TABLE MonitoringSize
(
    MonitoringSizeID  int NOT NULL UNIQUE IDENTITY(1, 1), -- PK
    TableName  VARCHAR(50) NOT NULL,
    Rows int,
    Reserved VARCHAR(50),
    Data VARCHAR(50),
    IndexSize VARCHAR(20),
    Unused VARCHAR(20),
    CreatedAt datetime NOT NULL,
    PRIMARY KEY (MonitoringSizeID)
	ON[PRIMARY]
)
 
 
 
ALTER TABLE Country
ADD FOREIGN KEY (SalesTerritoryGroupID) REFERENCES SalesTerritoryGroup(SalesTerritoryGroupID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE StateProvince
ADD FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
ON UPDATE CASCADE;
 
ALTER TABLE City
ADD FOREIGN KEY (StateProvinceCode) REFERENCES StateProvince(StateProvinceCode)
ON UPDATE CASCADE;
 
ALTER TABLE PostalCode
ADD FOREIGN KEY (CityID) REFERENCES City(CityID)
ON UPDATE CASCADE;
 
ALTER TABLE Address
ADD FOREIGN KEY (PostalCodeID) REFERENCES PostalCode(PostalCodeID)
ON UPDATE CASCADE;
 
ALTER TABLE CustomerAddress
ADD FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON UPDATE CASCADE;
 
ALTER TABLE CustomerAddress
ADD FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
ON UPDATE CASCADE;
 
ALTER TABLE Customer
ADD FOREIGN KEY (EducationID) REFERENCES Education(EducationID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE Customer
ADD FOREIGN KEY (OccupationID) REFERENCES Occupation(OccupationID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE Customer
ADD FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
 
 ALTER TABLE SentEmail
ADD FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE;
 
ALTER TABLE Currency
ADD FOREIGN KEY (LanguageCode) REFERENCES LanguageType(LanguageCode)
ON UPDATE CASCADE;
 
ALTER TABLE SalesOrder
ADD FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON UPDATE CASCADE;
 
ALTER TABLE SalesOrderDetail
ADD FOREIGN KEY (SalesOrderNumber) REFERENCES SalesOrder(SalesOrderNumber)
ON UPDATE CASCADE;
 
ALTER TABLE SalesOrderDetail
ADD FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
ON UPDATE CASCADE;
 
ALTER TABLE SalesOrderDetail
ADD FOREIGN KEY (CurrencyID) REFERENCES Currency(CurrencyID)
ON DELETE SET NULL
 
ALTER TABLE SalesTerritoryRegion
ADD FOREIGN KEY (SalesTerritoryGroupID) REFERENCES SalesTerritoryGroup(SalesTerritoryGroupID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE ProductColor
ADD FOREIGN KEY (LanguageCode) REFERENCES LanguageType(LanguageCode)
ON UPDATE CASCADE;
 
ALTER TABLE ProductParentCategory
ADD FOREIGN KEY (LanguageCode) REFERENCES LanguageType(LanguageCode)
ON UPDATE CASCADE;
 
ALTER TABLE ProductSubCategory
ADD FOREIGN KEY (ProductParentCategoryID) REFERENCES ProductParentCategory(ProductParentCategoryID)
ON UPDATE CASCADE;
 
 ALTER TABLE ProductSubCategory
ADD FOREIGN KEY (LanguageCode) REFERENCES LanguageType(LanguageCode)
 
ALTER TABLE ProductLanguage
ADD FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
ON UPDATE CASCADE;
 
ALTER TABLE ProductLanguage
ADD FOREIGN KEY (LanguageCode) REFERENCES LanguageType(LanguageCode)
 
ALTER TABLE ProductLanguage
ADD FOREIGN KEY (ProductSubCategoryID) REFERENCES ProductSubCategory(ProductSubCategoryID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE ProductLanguage
ADD FOREIGN KEY (ProductColorName) REFERENCES ProductColor(ProductColorName)
ON DELETE SET NULL
 
ALTER TABLE Product
ADD FOREIGN KEY (ProductModelName) REFERENCES ProductModel(ProductModelName)
ON UPDATE CASCADE;
 
ALTER TABLE Product
ADD FOREIGN KEY (ProductSizeID) REFERENCES ProductSize(ProductSizeID)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
 ALTER TABLE Product
ADD FOREIGN KEY (ProductWeightID) REFERENCES ProductWeight(ProductWeightID)
ON DELETE SET NULL
ON UPDATE CASCADE;
  
ALTER TABLE Product
ADD FOREIGN KEY (StatusName) REFERENCES Status(StatusName)
ON DELETE SET NULL
ON UPDATE CASCADE;
 
ALTER TABLE ProductSize
ADD FOREIGN KEY (SizeRange) REFERENCES ProductSizeRange(SizeRange)
ON UPDATE CASCADE; 
 
ALTER TABLE QuestionAnswer
ADD FOREIGN KEY (QuestionID) REFERENCES QuestionList(QuestionID)
ON UPDATE CASCADE;  
 
ALTER TABLE QuestionAnswer
ADD FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE;   
 
ALTER TABLE Error_Log
ADD FOREIGN KEY (ErrorCode) REFERENCES Error_Messages(ErrorCode)
ON DELETE NO ACTION
ON UPDATE CASCADE;
 
ALTER TABLE SalesOrderDetail
ADD FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
ON UPDATE CASCADE;
 
ALTER TABLE Company
ADD FOREIGN KEY (SalesTerritoryGroupID) REFERENCES SalesTerritoryGroup(SalesTerritoryGroupID)
ON UPDATE CASCADE;

