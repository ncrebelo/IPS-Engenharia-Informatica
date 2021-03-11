-- 2.1.4
-- Níveis de acesso à informação

USE AdventureWorks;
GO

-- Criação de Login para servidor: AdventureWorks
use master;
CREATE LOGIN RegisteredUser WITH PASSWORD = 'RegisteredUser';
GO
CREATE LOGIN UnregisteredUser WITH PASSWORD = 'UnregisteredUser';
GO
CREATE LOGIN MarketingManager WITH PASSWORD = 'MarketingManager';
GO
CREATE LOGIN Administrator WITH PASSWORD = 'Administrator';

-- Criação de utilizadores para cada login: AdventureWorks
use AdventureWorks;
GO
CREATE USER RegisteredUser FOR LOGIN RegisteredUser WITH DEFAULT_SCHEMA = dbo;
CREATE USER UnregisteredUser FOR LOGIN UnregisteredUser WITH DEFAULT_SCHEMA = dbo;
CREATE USER MarketingManager FOR LOGIN MarketingManager WITH DEFAULT_SCHEMA = dbo;
CREATE USER Administrator FOR LOGIN Administrator WITH DEFAULT_SCHEMA = dbo;

-- Criação e atribuição de roles 
use AdventureWorks;
GO
CREATE ROLE RegisteredUserRole;
CREATE ROLE UnregisteredUserRole;
CREATE ROLE MarketingManagerRole;
CREATE ROLE AdministratorRole;

-- Permissões RegisteredUser
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO RegisteredUserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO RegisteredUserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Products TO RegisteredUserRole;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Customers TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_NovaEncomenda] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_AdicionarAEncomenda] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_AlterarQTDProdutoNaEncomenda] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_RemoverProdutoDaEncomenda] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[sp_VerEncomendaAtual] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[spRecoveryPassword] TO RegisteredUserRole;
GRANT EXECUTE ON OBJECT::[dbo].[spLogin] TO RegisteredUserRole;
GRANT SELECT ON [dbo].[vw_ListActiveProducts] TO RegisteredUserRole;
GRANT SELECT ON [dbo].[vw_ListNONActiveProducts] TO RegisteredUserRole;

-- Permissões UnregisteredUser
GRANT SELECT ON SCHEMA::Products TO UnregisteredUserRole;

-- Permissões MarketingManager
GRANT SELECT ON SCHEMA::Promotions TO MarketingManagerRole;

-- Permissões Administrator
GRANT CONTROL ON SCHEMA::Customers TO AdministradorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Customers TO AdministradorRole;
GRANT CONTROL ON SCHEMA::Products TO AdministradorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Products TO AdministradorRole;
GRANT CONTROL ON SCHEMA::Sales TO AdministradorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO AdministradorRole;
GRANT CONTROL ON SCHEMA::dbo TO AdministradorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO AdministradorRole;
GRANT EXECUTE ON SCHEMA::dbo TO AdministradorRole;
GRANT EXECUTE ON SCHEMA::Customers TO AdministradorRole;
GRANT EXECUTE ON SCHEMA::Sales TO AdministradorRole;
GRANT EXECUTE ON SCHEMA::Products TO AdministradorRole;

-- Atribuir roles a utilizadores
EXEC sp_addrolemember 'RegisteredUserRole', 'RegisteredUser';
EXEC sp_addrolemember 'UnregisteredUserRole', 'UnregisteredUser';
EXEC sp_addrolemember 'MarketingManagerRole', 'MarketingManager';
EXEC sp_addrolemember 'AdministradorRole', 'Administrator';