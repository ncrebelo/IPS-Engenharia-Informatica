-- 2.1.6
-- Execução  das stored  procedures:  “Adição  de  Produto  a  Encomenda”,  
-- “Alteração  de Quantidade de Produto” e “Alterar Estado de Produto”,
-- se executadas “simultaneamente” em sessões concorrentes num cenário de conflito;

-- Adição de Produto a Encomenda
GO
CREATE PROCEDURE sp_AdicionarAEncomenda
@SalesOrderNumber nvarchar(20), @ProductID int, @Quantity int
AS
BEGIN
BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON
	BEGIN TRAN
	
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
		
		COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

-- Alteração de Quantidade de Produto na Encomenda
GO
CREATE PROCEDURE sp_AlterarQTDProdutoNaEncomenda
@SalesOrderNumber nvarchar(20), @ProductID int, @alterarQTD int, @operador nchar(1)
AS
BEGIN
BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON
	BEGIN TRAN
	
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
		
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO


-- Alterar Estado de Produto
GO
CREATE Procedure sp_AlterarEstadoProduto
(@ProductID int)
AS
BEGIN
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON
	BEGIN TRAN
	
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
	COMMIT TRAN
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	END CATCH
END
GO

-- A execução do processo de envio para a sede dos dados relativos
-- às vendas efetuadas no âmbito de uma promoção, deve garantir que alterações
-- efetuadas às vendas no decorrer deste processo não são incluídas;

CREATE PROCEDURE sp_SendPromotionSaleData
AS
BEGIN
BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SET NOCOUNT ON
	BEGIN TRAN
		SELECT SUM(sod.OrderTotal) AS 'Total of Sales with Discount/Promotions', COUNT(sod.SalesOrderDetailID) AS 'Quantity of Sales with Discount/Promotions'
		FROM SalesOrderDetail sod
		JOIN SalesOrder so ON so.SalesOrderNumber = sod.SalesOrderNumber
		WHERE Discount > 0 AND OrderDate < GETDATE()
	COMMIT TRAN
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	END CATCH
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

-- TESTES para a 2ª parte do 2.1.6
-- novas encomendas
exec sp_NovaEncomenda 300
exec sp_NovaEncomenda 310
exec sp_NovaEncomenda 320

-- pesquisar e obter salesordernumber
select *
from SalesOrder

-- adicionar produtos à encomenda
exec sp_AdicionarAEncomenda 'SO75124',212,2
exec sp_AdicionarAEncomenda 'SO75125',350,5
exec sp_AdicionarAEncomenda 'SO75126',300,10

-- aplicar descontos sobre o valor da encomenda
exec sp_AplicarDescontoValor 'SO75124', 100000
exec sp_AplicarDescontoValor 'SO75125', 500000
exec sp_AplicarDescontoPercentagem 'SO75126', 10

exec sp_SendPromotionSaleData
 