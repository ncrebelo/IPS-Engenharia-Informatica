-- Trigger para atualizar o carrinho
GO
CREATE TRIGGER AtualizarEncomenda ON  AdventureWorks.dbo.SalesOrderDetail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @SalesOrderNumber nvarchar(20);
    DECLARE @SalesOrderDetailID int;
 
-- INSERT
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted) 
    BEGIN   
        SET @SalesOrderNumber = (SELECT SalesOrderNumber FROM inserted);
        SET @SalesOrderDetailID = (SELECT SalesOrderDetailID FROM inserted);
    END
-- UPDATE
    ELSE IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN   
        SET @SalesOrderNumber = (SELECT SalesOrderNumber FROM inserted);
        SET @SalesOrderDetailID = (SELECT SalesOrderDetailID FROM inserted);
    END
-- DELETE
    ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(select * from inserted) 
    BEGIN
        SET @SalesOrderNumber = (SELECT SalesOrderNumber FROM deleted);
        SET @SalesOrderDetailID = (SELECT SalesOrderDetailID FROM deleted);
    END
    IF EXISTS (SELECT SalesOrderNumber FROM SalesOrder WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrderDetail WHERE SalesOrderNumber = @SalesOrderNumber)
        BEGIN
            UPDATE SalesOrder SET SalesAmount = NULL WHERE SalesOrderNumber = @SalesOrderNumber;
        END
        ELSE
        BEGIN
            UPDATE SalesOrder
            SET SalesAmount = a.SalesAmount
            FROM (
                SELECT SUM(OrderQty * UnitPrice) as SalesAmount
                FROM SalesOrderDetail
                WHERE SalesOrderNumber = @SalesOrderNumber) a
            WHERE SalesOrderNumber = @SalesOrderNumber; 
        END
        BEGIN 
            UPDATE SalesOrder
            SET SaleStatus = 'Closed' 
            WHERE SalesOrderNumber = @SalesOrderNumber;
        END
    END
    IF EXISTS (SELECT SalesOrderDetailID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID)
    BEGIN
        UPDATE SalesOrderDetail
        SET PromotionID = (SELECT PromotionID FROM Promotions WHERE getdate() between PromotionStartDate AND PromotionEndDate)
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
        IF EXISTS (SELECT PromotionID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID AND  PromotionID = 1)
        UPDATE SalesOrderDetail
        SET OrderTotal = (OrderQty * UnitPrice) * 0.9
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
        ELSE IF EXISTS (SELECT PromotionID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID AND  PromotionID = 2)
        UPDATE SalesOrderDetail
        SET OrderTotal = (OrderQty * UnitPrice) * 0.8
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
        ELSE IF EXISTS (SELECT PromotionID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID AND  PromotionID = 3)
        UPDATE SalesOrderDetail
        SET OrderTotal = (OrderQty * UnitPrice) * 0.7
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
        ELSE IF EXISTS (SELECT PromotionID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID AND  PromotionID = 4)
        UPDATE SalesOrderDetail
        SET OrderTotal = (OrderQty * UnitPrice) * 0.6
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
        ELSE IF EXISTS (SELECT PromotionID FROM SalesOrderDetail WHERE SalesOrderDetailID = @SalesOrderDetailID AND  PromotionID = 5)
        UPDATE SalesOrderDetail
        SET OrderTotal = (OrderQty * UnitPrice) * 0.5
            FROM SalesOrderDetail
            WHERE SalesOrderDetailID = @SalesOrderDetailID
    END
	BEGIN
		UPDATE SalesOrderDetail
        SET PromotionID = (SELECT PromotionID FROM Promotions WHERE PromotionID = 6)
		WHERE Discount > 0
	END
END
GO