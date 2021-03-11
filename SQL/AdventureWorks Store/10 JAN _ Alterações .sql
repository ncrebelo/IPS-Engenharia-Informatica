-- Adicionar a SalesOrderDetail
ALTER TABLE SalesOrderDetail
ADD Discount money;

-- Popular em Promotions
EXEC sp_PopularPromotions 'M','Manually applied discount','1900-01-01', '1900-12-31';
