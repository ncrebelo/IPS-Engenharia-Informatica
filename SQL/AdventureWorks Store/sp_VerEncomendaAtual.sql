GO
CREATE OR ALTER PROCEDURE sp_VerEncomendaAtual
@CustomerID int, @CountryCode nchar(3)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON

	DECLARE @temp nvarchar(100);
	IF NOT EXISTS (SELECT CustomerID FROM SalesOrder WHERE CustomerID = @CustomerID AND SaleStatus = 'Open')
	BEGIN
		EXEC sp_PreencherErrorLog 9020, '', @CustomerID;
		RETURN;
	end
		
	SELECT	so.SalesOrderNumber,
			CustomerID,
			SalesAmount,
			(SELECT ProductName
			FROM ProductLanguage
			WHERE ProductID = 
					(SELECT p1.ProductID FROM Product p1 WHERE p1.ProductID = s.ProductID)
					AND
					LanguageCode = @CountryCode) AS Product,OrderQty,UnitPrice
			
    FROM SalesOrder so
		JOIN SalesOrderDetail s
			ON s.SalesOrderNumber = so.SalesOrderNumber
	
	WHERE 
		so.CustomerID = @CustomerID
		AND so.SaleStatus = 'Open';

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END