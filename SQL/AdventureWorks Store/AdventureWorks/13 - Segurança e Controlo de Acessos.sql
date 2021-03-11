-- Criação de Login para servidor: AdventureWorks
use master;
CREATE LOGIN Cliente WITH PASSWORD = 'ClientePassword';
GO
CREATE LOGIN Employee WITH PASSWORD = 'EmployeePassword';
GO

-- Criação de utilizadores para cada login: AdventureWorks
use AdventureWorks;
GO
CREATE USER Cliente FOR LOGIN Cliente WITH DEFAULT_SCHEMA = dbo;
CREATE USER Employee FOR LOGIN Employee WITH DEFAULT_SCHEMA = dbo;


-- Criação e atribuição de roles 
use AdventureWorks;
GO
CREATE ROLE ClienteRole;
CREATE ROLE EmployeeRole;

-- Permissões Cliente
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ClienteRole; 
GRANT EXECUTE ON OBJECT::[dbo].[sp_NovaEncomenda] TO ClienteRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_AdicionarAEncomenda] TO ClienteRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_AlterarQTDProdutoNaEncomenda] TO ClienteRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_RemoverProdutoDaEncomenda] TO ClienteRole;
GRANT SELECT ON [dbo].[vw_ListActiveProducts] TO ClienteRole;
GRANT SELECT ON [dbo].[vw_ListNONActiveProducts] TO ClienteRole;

-- Permissões Utilizador
GRANT INSERT, UPDATE, DELETE ON SCHEMA::dbo TO EmployeeRole;
GRANT SELECT ON SCHEMA::dbo TO EmployeeRole;

-- Atribuir roles a utilizadores
EXEC sp_addrolemember 'ClienteRole', 'Cliente';
EXEC sp_addrolemember 'EmployeeRole', 'Employee';


-- Demonstração e testes 
EXECUTE AS USER = 'cliente'; 
-- 1) FALHA
select *
from customer
-- 2) FALHA
select *
from SalesOrder
-- 3) PASSA
select *
from dbo.vw_ListActiveProducts

EXECUTE AS USER = 'Employee'; 
-- PASSAM todos sem execeção
--1)
select *
from SalesOrder
--2)
select *
from vw_TopSellingProducts
--3)
UPDATE Customer
SET FirstName = 'NEW NAME'
where CustomerID  = 1
