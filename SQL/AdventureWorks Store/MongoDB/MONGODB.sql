use AdventureWorks;

-- ENUNCIADO MONGODB
-- ETAPA 2***************************************************************************************************************

--2.1 Criar em SQL Server as consultas necessárias...
-- Products
select p.ProductID,p.ProductModelName,sc.ProductSubCategoryName
from Product p
JOIN ProductLanguage pl ON pl.ProductID = p.ProductID
JOIN ProductSubCategory sc ON sc.ProductSubCategoryID = pl.ProductSubCategoryID
WHERE sc.LanguageCode = 'EN'

-- Customer
select c.EmailAddress, CountryName
from Customer c
JOIN Country co ON co.CountryCode = c.CountryCode

-- 2.2 & 2.3
-- IMPORT para MongoDB utilizando a consola
-- mongoimport --db AdventureWorksMDB --collection Clients --type csv --file C:\Clients.csv --headerline
-- mongoimport --db AdventureWorksMDB --collection Products --type csv --file C:\Products.csv --headerline

-- 2.4 
-- mongoimport --db AdventureWorksMDB --collection Comments_Evaluations --type csv --file C:\Comm_Eval.csv --headerline

--ETAPA 3***************************************************************************************************************
-- 3.1 - Listar o modelo e categoria do produto com os respetivos comentários
db.Comments_Evaluations.aggregate([{$lookup: { from: "Products",localField: "productId", foreignField: "_id",as: "ProdWithComment"}},
{ $replaceRoot: { newRoot: { $mergeObjects: [ { $arrayElemAt: [ "$ProdWithComment", 0 ] }, "$$ROOT" ] } }},
{ $project: { ProdWithComment: 0 } }])

-- 3.2 - Listar os produtos de uma determinada categoria 
db.Products.find({category:'Helmets'})

-- 3.3 - Listar os comentários de um dado utilizador
db.Comments_Evaluations.find({clientId: 300})
 
-- 3.4 - Listar os produtos que não têm comentários
db.Products.aggregate([{$lookup: { from: "Comments_Evaluations",localField: "_id", foreignField: "comment",as: "ProdWithOutComment"}},
{ $replaceRoot: { newRoot: { $mergeObjects: [ { $arrayElemAt: [ "$ProdWithOutComment", 0 ] }, "$$ROOT" ] } }},
{ $project: { ProdWithOutComment: 0 } }])

-- 3.5 - Obter o nº de comentários por cliente 
db.Comments_Evaluations.aggregate([{"$group":{_id:"$clientId",counter:{$sum:1}}}])

-- 3.6 - Obter a classificação média por produto 
db.Comments_Evaluations.aggregate([{"$group":{_id:"$productId",avgRating:{"$avg": "$rating"}}}])

-- 3.7 - Adicionar um comentário a um determinado produto
db.Comments_Evaluations.insert({_id:17,clientId:1600,productId: 215,comment:"HATE IT",rating:1,date:2019-05-05})

-- 3.8 - Remover os comentários de um dado utilizador 
db.Comments_Evaluations.remove({_id:16})

-- 3.9 - Obter a média de classificações dos clientes por País (Nome País, Média das Classificações).
db.Clients.aggregate([
  { $lookup : { from : 'Comments_Evaluations', localField : '_id', foreignField : 'clientId', as : 'combined'}},
  { $unwind:'$combined'},
  { $group: {_id: '$country',  avgRating: { $avg: "$combined.rating" } } }
]);

-- ETAPA 4***************************************************************************************************************

-- 4.1 - Exportar a informação relativa aos comentários para um ficheiro json (Comentarios.json). 
-- mongoexport --db AdventureWorksMDB --collection Comments_Evaluations --out C:\Users\rebel\Documents\output.json
-- 4.2 - Importar no SQL Server o ficheiro json para uma nova(s) tabela(s).

use AdventureWorks;
DECLARE @COMMRATINGS VARCHAR(MAX)

SELECT @COMMRATINGS = BulkColumn
FROM OPENROWSET(BULK 'C:\Users\rebel\Desktop\MongoDB\output.json',SINGLE_CLOB) JSON

IF(ISJSON(@COMMRATINGS) = 1)
	BEGIN
		PRINT 'FILE IS VALID';

		INSERT INTO Comments_Ratings
		SELECT * 
		FROM OPENJSON(@COMMRATINGS, '$.C.E')
		WITH(
			CommentRatingID		int				'$._id',
			CustomerID			int				'$.clientId',
			ProductID			int				'$.productId',
			Comments			nvarchar(200)	'$.comment',
			Rating				int				'$.rating',
			CreatedAt			nvarchar(10)	'$.date'
		)
END
	ELSE
		BEGIN
			PRINT 'FILE IS INVALID';
		END
-- 4.3 - Proceder à integração e normalização da informação importada para a base de dados criada no âmbito projeto.
-- Criação da tabela no SQL SERVER
CREATE TABLE Comments_Ratings
(
	CommmentRatingID int NOT NULL,
	CustomerID int NOT NULL, --FK
	ProductID int NOT NULL, -- FK
	Comments nvarchar(200),
	Rating int NOT NULL,
	CreatedAt nvarchar(10) NOT NULL
	PRIMARY KEY (CommmentRatingID)
);

ALTER TABLE Comments_Ratings
ADD FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
ON UPDATE NO ACTION;

ALTER TABLE Comments_Ratings
ADD FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON UPDATE NO ACTION;

-- 4.4 - Criar uma view com a média de classificações dos clientes por País (Nome País, Média das Classificações). 
GO
CREATE VIEW vw_AVGRatingPerCountry
AS
	select CountryName,AVG(Rating) AS 'Average'
	from Customer c
	JOIN Country x ON x.CountryCode = c.CountryCode
	JOIN Comments_Ratings cr ON cr.CustomerID = c.CustomerID
	GROUP BY CountryName
GO

-- Compare...
-- Para a 2ª parte da questão, remeter para o ficheiro (docx) "4.4 - Comparação"
