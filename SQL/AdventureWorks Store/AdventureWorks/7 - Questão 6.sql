use AdventureWorks;
-- 6.A) Editar, Adicionar e Remover Produtos, Categorias e Sub-Categorias
 
--Adicionar Categorias e Sub-Categorias
EXEC spGeneratorInsert @Table="ProductParentCategory"
EXEC spGeneratorInsert @Table="ProductSubCategory"
 
--Editar Categorias e Sub-Categorias
EXEC spGeneratorUpdate @Table="ProductParentCategory"
EXEC spGeneratorUpdate @Table="ProductSubCategory"
 
--Remover Categorias e Sub-Categorias
EXEC spGeneratorDelete @Table="ProductParentCategory"
EXEC spGeneratorDelete @Table="ProductSubCategory"
 
 
-- 6.B) Associar Produto a Sub-Categoria/Categoria
GO
create procedure spAssociateProductWithProductSubCategory @ProductID int, @ProductSubCategoryID int, @LanguageCode VARCHAR(2) AS
 
if(not exists (select * from ProductLanguage where ProductID = @ProductID and LanguageCode = @LanguageCode))
    BEGIN
        DECLARE @temp nvarchar(100) = ' ProductID:' + cast(@ProductID as VARCHAR) + ' LanguageCode: ' + @LanguageCode
        EXEC sp_PreencherErrorLog 9260, '', @temp 
        RETURN
    END
 
if (not exists (select * from ProductSubCategory where ProductSubCategoryID = @ProductSubCategoryID and LanguageCode = @LanguageCode))
  BEGIN
        DECLARE @temp1 nvarchar(100) = ' ProductSubCategoryID:' + cast(@ProductSubCategoryID as VARCHAR) + ' LanguageCode: ' + @LanguageCode
        EXEC sp_PreencherErrorLog 9270, '', @temp1
        RETURN
    END
 
 
update ProductLanguage set ProductSubCategoryID = @ProductSubCategoryID where ProductID = @ProductID and LanguageCode = @LanguageCode 
 
 
-- 6.C) Definir uma promoção na encomenda
-- 6.D) Alterar as datas de Início e Fim de uma promoção (não deve ser possível atribuir uma promoção que não esteja ativa)
-- 6.E) Alterar o Estado dos Produtos
GO
CREATE Procedure sp_AlterarEstadoProduto
(@ProductID int)
AS
BEGIN
    IF NOT EXISTS (SELECT ProductID FROM Product WHERE ProductID = @ProductID)
    BEGIN
        DECLARE @temp nvarchar(100);
        SET @temp = CAST(@ProductID AS varchar);
        EXEC sp_PreencherErrorLog 9030, '', @temp;
        RETURN;
    END
    DECLARE @CurrentStatus nvarchar(7);
    SET @CurrentStatus = (SELECT StatusName FROM Product WHERE ProductID = @ProductID);
    IF @CurrentStatus IS NULL
    BEGIN
        UPDATE Product SET StatusName = 'Current' WHERE ProductID = @ProductID
    END
    ELSE
    BEGIN
        UPDATE Product SET StatusName = NULL WHERE ProductID = @ProductID
    END
END
GO
 
-- Criação de Encomenda
GO
CREATE PROCEDURE sp_NovaEncomenda
@CustomerID int
AS
BEGIN
    DECLARE @a nvarchar(20) = (SELECT TOP 1 VALUE
        FROM string_split
            ((SELECT TOP 1 SalesOrderNumber
            FROM SalesOrder
            ORDER BY 1 DESC), 'O')
        ORDER BY 1);
    DECLARE @newint  BIGint = (select(LEFT(@a,5)));
    DECLARE @cast  BIGint= CAST(@newint AS BIGINT);
    DECLARE @final BIGINT = @newint + 1;
    DECLARE @newString nvarchar(20) = concat('SO',@final);
    DECLARE @newOrderDate date = CONVERT(date, getdate());
    DECLARE @newDueDate date = DATEADD(day, 3, @newOrderDate);
    DECLARE @newShipDate date = DATEADD(day, 4, @newOrderDate);
    INSERT INTO AdventureWorks.dbo.SalesOrder(SalesOrderNumber, CustomerID, OrderDate, DueDate, ShipDate)
    VALUES (@newString, @CustomerID,@newOrderDate, @newDueDate, @newShipDate);
END
GO
 
-- Trigger para atualizar o carrinho
GO
CREATE TRIGGER AtualizarCarrinho ON  AdventureWorks.dbo.SalesOrderDetail
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
END
GO
 
-- Adição de Produto a Encomenda
GO
CREATE PROCEDURE sp_AdicionarAEncomenda
@SalesOrderNumber nvarchar(20), @ProductID int, @Quantity int
AS
BEGIN
    DECLARE @temp nvarchar(100);
    DECLARE @CurrencyID int = 36;
    IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrder WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        EXEC sp_PreencherErrorLog 9020, '', @SalesOrderNumber;
        RETURN;
    END
    IF NOT EXISTS (SELECT ProductID FROM Product WHERE ProductID = @ProductID)
    BEGIN
        SET @temp = CAST(@ProductID AS varchar);
        EXEC sp_PreencherErrorLog 9030, '', @temp
        RETURN;
    END
    DECLARE @UnitPrice money = (SELECT ListPrice FROM Product WHERE ProductID = @ProductID);
    IF @UnitPrice IS NULL
    BEGIN
        SET @temp = CAST(@ProductID AS varchar);
        EXEC sp_PreencherErrorLog 9060, '', @temp;
        RETURN;
    END
    IF @Quantity < 1
    BEGIN
        SET @temp = CAST(@Quantity AS varchar);
        EXEC sp_PreencherErrorLog 9050, '', @temp;
        RETURN;
    END
    ELSE
        INSERT INTO SalesOrderDetail(SalesOrderNumber, ProductID, OrderQty, CurrencyID,UnitPrice, OrderTotal)
        VALUES (@SalesOrderNumber, @ProductID,  @Quantity,@CurrencyID ,@UnitPrice, (@Quantity * @UnitPrice));
END
GO
 
-- Alteração de Quantidade de Produto na Encomenda
GO
CREATE PROCEDURE sp_AlterarQTDProdutoNaEncomenda
@SalesOrderNumber nvarchar(20), @ProductID int, @alterarQTD int, @operador nchar(1)
AS
BEGIN
    DECLARE @temp nvarchar(100);
    IF (@operador NOT LIKE '+') AND (@operador NOT LIKE '-')
    BEGIN
        EXEC sp_PreencherErrorLog 9090, '', @operador;
        RETURN;
    END
    IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrderDetail WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        EXEC sp_PreencherErrorLog 9020, '', @SalesOrderNumber;
        RETURN;
    END
    IF NOT EXISTS (SELECT ProductID FROM SalesOrderDetail WHERE ProductID = @ProductID)
    BEGIN
        SET @temp = CAST(@ProductID AS varchar);
        EXEC sp_PreencherErrorLog 9030, '', @temp
        RETURN;
    END
    DECLARE @Quantity int = (SELECT OrderQty FROM SalesOrderDetail WHERE SalesOrderNumber = @SalesOrderNumber 
    AND ProductID = @ProductID)
    IF @operador LIKE '-'
    BEGIN
        IF (@Quantity - @alterarQTD) < 1
        BEGIN
            SET @temp = '' + CAST(@Quantity AS varchar) + ' - ' + CAST(@alterarQTD AS varchar) + ' = ' + 
            CAST((@Quantity - @alterarQTD) AS varchar);
            EXEC sp_PreencherErrorLog 9050, '', @temp;
            RETURN;
        end
        UPDATE SalesOrderDetail SET OrderQty = @Quantity - @alterarQTD WHERE SalesOrderNumber = @SalesOrderNumber 
        AND ProductID = @ProductID;
        UPDATE SalesOrderDetail SET OrderTotal = OrderQty * UnitPrice WHERE SalesOrderNumber = @SalesOrderNumber 
        AND ProductID = @ProductID;
    end
    ELSE IF @operador LIKE '+'
        UPDATE SalesOrderDetail SET OrderQty = @Quantity + @alterarQTD WHERE SalesOrderNumber = @SalesOrderNumber 
        AND ProductID = @ProductID;
        UPDATE SalesOrderDetail SET OrderTotal = OrderQty * UnitPrice WHERE SalesOrderNumber = @SalesOrderNumber 
        AND ProductID = @ProductID;
END
GO
 
-- Remoção de Produto de Encomenda 
GO
CREATE PROCEDURE sp_RemoverProdutoDaEncomenda
@SalesOrderNumber nvarchar(20), @ProductID int
AS
BEGIN
    DECLARE @temp nvarchar(100);
    IF NOT EXISTS (SELECT SalesOrderNumber FROM SalesOrderDetail WHERE SalesOrderNumber = @SalesOrderNumber)
    BEGIN
        EXEC sp_PreencherErrorLog 9020, '', @SalesOrderNumber;
        RETURN;
    END
    IF NOT EXISTS (SELECT ProductID FROM SalesOrderDetail WHERE ProductID = @ProductID)
    BEGIN
        SET @temp = CAST(@ProductID AS varchar);
        EXEC sp_PreencherErrorLog 9030, '', @temp;
        RETURN;
    END
    DELETE FROM SalesOrderDetail WHERE SalesOrderNumber = @SalesOrderNumber AND ProductID = @ProductID;
END
GO
 
-- Alteração do Estado da Encomenda 
-- Atualizado conforme Trigger AtualizarCarrinho

