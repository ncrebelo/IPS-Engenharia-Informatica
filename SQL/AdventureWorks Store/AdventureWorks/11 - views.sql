-- VIEWS
use AdventureWorks;

GO
CREATE VIEW vw_ListCustomers
AS
	SELECT 
		CustomerID,Title,FirstName, MiddleName, LastName,
		BirthDate, Gender, EmailAddress, YearlyIncome,
	    EducationID, OccupationID, Phone, DateFirstPurchase, CountryCode
	FROM Customer 
GO

	
GO
CREATE VIEW vw_ListActiveProducts
AS
	SELECT ProductID, ProductModelName,StatusName
	FROM Product
	WHERE StatusName = 'Current'
GO

GO
CREATE VIEW vw_ListNONActiveProducts
AS
	SELECT ProductID, ProductModelName,StatusName
	FROM Product
	WHERE StatusName = ''
GO

GO 
CREATE VIEW vw_TopSellingProducts
AS
	SELECT TOP(10) ProductID, SUM(OrderQty) AS 'Quantity Sold'
	FROM SalesOrderDetail
	GROUP BY ProductID
	ORDER BY  SUM(OrderQty) DESC
GO