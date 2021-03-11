--Verificação da nova BD
-- Total monetário de vendas por ano
select FORMAT(OrderDate, 'yyyy') as YearDate, sum(SalesAmount) as Amount from AdventureWorksOldData.dbo.Sales group by FORMAT(OrderDate, 'yyyy')
 
select FORMAT(OrderDate, 'yyyy') as YearDate, sum(SalesAmount) as Amount from SalesOrder group by FORMAT(OrderDate, 'yyyy')

-- Total monetário de vendas por ano por “Sales Territory Country”
select SalesTerritoryCountry as Country, FORMAT(OrderDate, 'yyyy') as YearDate, sum(SalesAmount) as Amount from AdventureWorksOldData.dbo.Sales group by FORMAT(OrderDate, 'yyyy'), SalesTerritoryCountry
 
select cc.CountryName as Country, FORMAT(OrderDate, 'yyyy') as YearDate, sum(SalesAmount) as Amount from SalesOrder so 
inner JOIN Customer c on so.CustomerID = c.CustomerID 
inner JOIN Country cc on cc.CountryCode = c.CountryCode
group by  FORMAT(OrderDate, 'yyyy'), cc.CountryName

-- Total monetário de vendas por ano por “Product Subcategory”
select sc.EnglishProductSubcategoryName as ProductSubCategoryName, FORMAT(OrderDate, 'yyyy')  as YearDate, sum(SalesAmount) as Amount from AdventureWorksOldData.dbo.Sales s
inner join AdventureWorksOldData.dbo.Products p on s.ProductKey = p.ProductKey
inner join AdventureWorksOldData.dbo.ProductSubCategory sc on sc.ProductSubcategoryKey = p.ProductSubcategoryKey
GROUP by FORMAT(OrderDate, 'yyyy') , sc.EnglishProductSubcategoryName order by ProductSubCategoryName, YearDate
 
select sc.ProductSubCategoryName, FORMAT(OrderDate, 'yyyy') as YearDate, sum(sd.UnitPrice * sd.OrderQty) as Amount from SalesOrder so
inner join  SalesOrderDetail sd on sd.SalesOrderNumber = so.SalesOrderNumber
inner join Product p on p.ProductID = sd.ProductID
inner join ProductLanguage pl on pl.ProductID = p.ProductID and pl.LanguageCode = 'EN'
inner join ProductSubCategory sc on sc.ProductSubCategoryID = pl.ProductSubCategoryID
group by FORMAT(OrderDate, 'yyyy'), pl.ProductSubCategoryID, sc.ProductSubCategoryName order by sc.ProductSubCategoryName, YearDate

-- Total monetário de vendas por ano por “Product Category”
select p.EnglishProductCategoryName as ProductParentCategoryName, format(s.OrderDate, 'yyyy') as YearDate, sum(s.SalesAmount) as Amount from AdventureWorksOldData.dbo.Sales s
inner join AdventureWorksOldData.dbo.Products p on p.ProductKey = s.ProductKey
group by p.EnglishProductCategoryName, format(s.OrderDate, 'yyyy')
 
select pc.ProductParentCategoryName, format(s.OrderDate, 'yyyy') as YearDate, sum(sd.OrderQty * sd.UnitPrice) as Amount from SalesOrder s
inner join SalesOrderDetail sd on sd.SalesOrderNumber = s.SalesOrderNumber
inner join Product p on p.ProductID = sd.ProductID
inner join ProductLanguage pl on pl.ProductID = p.ProductID AND LanguageCode = 'EN'
inner join ProductSubCategory sc on sc.ProductSubCategoryID = pl.ProductSubCategoryID
inner join ProductParentCategory pc on pc.ProductParentCategoryID = sc.ProductParentCategoryID
group by pc.ProductParentCategoryName, format(s.OrderDate, 'yyyy')

-- Número de Clientes por ano por “Sales Territory Country”
select format(DateFirstPurchase, 'yyyy') as YearDate, c.CountryCode as Country, count(*) as Customers from Customer c
inner join Country cc on cc.CountryCode = c.CountryCode
group by format(DateFirstPurchase, 'yyyy'), c.CountryCode;
 
select format(DateFirstPurchase, 'yyyy') as YearDate, CountryRegionCode as Country, count(*) as Customers from AdventureWorksOldData.dbo.Customer
group by format(DateFirstPurchase, 'yyyy'), CountryRegionCode;


--2.A) Para os novos utilizadores a password do sistema deverá será alvo de reset na primeira entrada.
EXEC spLogin @EmailAddress="2@gmail.com", @Password = "50911"

--2.B) Sempre que é adicionado um novo utilizador ou este solicita a recuperação de password, o sistema deverá automaticamente gerar uma password e enviar e-mail ao mesmo com essa informação (no âmbito do projeto, poderá ser efetuada uma simulação de escrita numa tabela “sentEmails” em vez de configuração de servidor de e-mail).
insert into Employee values('12453', 'Vendas', 'do', 'Sistema', 'adm', 'adm@adventure.com', 'workds', 1);

EXEC spRecoveryPassword @EmailAddress="Krueger@adventureworks.com", @Password = "abcde",
@Question1 = 1, @Answer1 = 'yes',
@Question2 = 2, @Answer2 = 'yes',
@Question3 = 3, @Answer3 = 'yes'


--5.A) Editar, Adicionar e Remover Utilizadores

EXEC spInsertEmployee @EmployeeNumber = 1234, @FirstName = "Administrador", @LastName = "Sistema", @UserName = "admin", @EmailAddress = "adm@gmail.com", @Password = "adm", @ResetPassword = 1

exec spUpdateEmployee @FirstName='xxxx', @LastName='yyyyy',  @UserName='kkkkk',  @EmailAddress='kkk@ggg.com',  @Password='kkkjk',  @ResetPassword=1, @EmployeeNumber=1234

exec spDeleteEmployee @EmployeeNumber = 001


--5.B) Recuperar Password – Um utilizador para poder recuperar a password deve ter definidas 3 questões às quais deve responder corretamente para efetuar a recuperação. Cada utilizador terá à escolha uma lista de questões às quais deve responder, sendo obrigatório selecionar pelo menos 3.

EXEC spLogin @EmailAddress="Krueger@adventureworks.com", @Password = "abcde", @NewPassword = "12345"

EXEC spRecoveryPassword @EmailAddress="Krueger@adventureworks.com", @Password = "abcde",
@Question1 = 1, @Answer1 = 'yes',
@Question2 = 2, @Answer2 = 'yes',
@Question3 = 3, @Answer3 = 'yes'


--6.A) Editar, Adicionar e Remover Produtos, Categorias e Sub-Categorias

EXEC spInsertProductParentCategory @ProductParentCategoryName="Freios", @LanguageCode='EN'

EXEC spUpdateProductParentCategory @ProductParentCategoryID = 16, @LanguageCode = 'ES', @ProductParentCategoryName= 'Freitos'

exec spDeleteProductParentCategory @ProductParentCategoryID = 15


exec spInsertProductSubCategory @ProductSubCategoryName = "Freio tipo C", @ProductParentCategoryID = 16, @LanguageCode="ES"

exec spUpdateProductSubCategory @ProductSubCategoryID = 112, @ProductSubCategoryName = "Freio tipo D", @ProductParentCategoryID = 16, @LanguageCode="ES"

exec spDeleteProductSubCategory @ProductSubCategoryID = 15

--6.B) Associar Produto a Sub-Categoria/Categoria

exec spAssociateProductWithProductSubCategory 210, 1, 'es'

--6.C) Definir uma promoção na encomenda

--Proporcionado pelo Trigger [AtualizarCarrinho]


--6.D) Alterar as datas de Início e Fim de uma promoção (não deve ser possível atribuir uma promoção que não esteja ativa)

update Promotions
SET PromotionStartDate = '2019-01-01', PromotionEndDate = '2019-01-31'
where PromotionID = 1;

--6.E) Alterar o Estado dos Produtos

Update Product
SET StatusName = ''
WHERE ProductID = 210


--Layout da BD

-- Espaço ocupado por registo de cada tabela;
exec spSizeRow

-- Espaço ocupado por cada tabela com o número atual de registos;
exec spSizeTable

-- Propor uma taxa de crescimento por tabela (inferindo dos dados existentes); -- 10 - Layout da BD

-- Dimensionar o no e tipos de acessos.


-- Monitorização

--Uma stored procedure que recorra ao catalogo para gerar entradas numa tabela(s) dedicada(s) onde deve constar a seguinte informação relativa à bases de dados: todos os campos de todas as tabelas, com os seus tipos de dados, tamanho respetivo e restrições associadas (no caso de chaves estrangeiras, deve ser indicada qual a tabela referenciada e o tipo de ação definido para a manutenção da integridade referencial nas operações de “update” e “delete”. Deverá manter histórico de alterações do esquema da BD nas sucessivas execuções da sp.
EXEC spMonitoringStructure

-- Uma view que disponibilize os dados relativos à execução mais recente, presentes na tabela do ponto anterior.
SELECT * FROM vMonitoringStructure

-- Uma stored procedure que registe, também em tabela dedicada, por cada tabela da base de dados o seu número de registos e estimativa mais fiável do espaço ocupado. Deverá manter histórico dos resultados das sucessivas execuções da sp.
EXEC spMonitoringSize
select * from MonitoringSize


