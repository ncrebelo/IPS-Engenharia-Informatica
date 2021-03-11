CREATE OR ALTER PROCEDURE sp_AplicarDescontoPercentagem
@SalesOrderNumber nvarchar(20), @discount decimal(4,2)
AS
BEGIN
    IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrder WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        EXEC sp_PreencherErrorLog 9020, '', @SalesOrderNumber;
        RETURN;
    END
	ELSE
	UPDATE SalesOrderDetail SET OrderTotal = OrderTotal - (OrderTotal / @discount), Discount = (OrderTotal / @discount) + @discount WHERE SalesOrderNumber = @SalesOrderNumber
	UPDATE SalesOrder SET SalesAmount = a.SalesAmount
				FROM (
                SELECT OrderTotal as SalesAmount
                FROM SalesOrderDetail
                WHERE SalesOrderNumber = @SalesOrderNumber) a
			    WHERE SalesOrderNumber = @SalesOrderNumber; 
END