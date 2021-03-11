CREATE OR ALTER PROCEDURE sp_AplicarDescontoValor
@SalesOrderNumber nvarchar(20), @discount money
AS
BEGIN
    IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrder WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        EXEC sp_PreencherErrorLog 9020, '', @SalesOrderNumber;
        RETURN;
    END
	ELSE
	UPDATE SalesOrderDetail SET OrderTotal = OrderTotal - @discount, Discount = @discount WHERE SalesOrderNumber = @SalesOrderNumber
	UPDATE SalesOrder SET SalesAmount = a.SalesAmount
				FROM (
                SELECT OrderTotal as SalesAmount
                FROM SalesOrderDetail
                WHERE SalesOrderNumber = @SalesOrderNumber) a
			    WHERE SalesOrderNumber = @SalesOrderNumber; 
END