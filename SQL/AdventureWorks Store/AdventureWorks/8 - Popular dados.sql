use AdventureWorks;
 
-- atualizar o SaleStatus para Closed para todos os SalesOrder antes da data da migração
Update SalesOrder SET SaleStatus = 'Closed'
 
-- Company
GO
CREATE PROCEDURE sp_PopulateCompany
  (@STGroupID int,
  @EmailAdrress nvarchar(70),
  @Phone nvarchar(20))
AS
BEGIN
  INSERT INTO Company
    (SalesTerritoryGroupID, EmailAddress,Phone)
  VALUES
    (@STGroupID, @EmailAdrress, @Phone);
END
GO
 
EXEC sp_PopulateCompany 1,'European.Company@adventureworks.com','(91)5642387';
EXEC sp_PopulateCompany 3,'N.America.Company@adventureworks.com','(92)8899775';
EXEC sp_PopulateCompany 4,'Pacific.Company@adventureworks.com','(93)9945137';
 
 
-- ErrorMessages
GO
CREATE PROCEDURE sp_PopularErrorMessages
  (@ErrorMessage nvarchar(100))
AS
BEGIN
  INSERT INTO Error_Messages
    (ErrorMessage)
  VALUES
    (@ErrorMessage);
END
GO
 
EXEC sp_PopularErrorMessages 'ERRO:9000>> The table does not contain the foreign key(s) in the specified table(s): ';
EXEC sp_PopularErrorMessages 'ERRO:9010>> Non existing Table: ';
EXEC sp_PopularErrorMessages 'ERRO:9020>> SalesOrderNumber does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9030>> ProductID does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9040>> CustomerID does not exist ';
EXEC sp_PopularErrorMessages 'ERRO:9050>> The quantity has to be bigger than 1: ';
EXEC sp_PopularErrorMessages 'ERRO:9060>> No price has been associated with the product code: ';
EXEC sp_PopularErrorMessages 'ERRO:9070>> Duplicate ProductID in the cart: ';
EXEC sp_PopularErrorMessages 'ERRO:9080>> Duplicate carts are not allowed: ';
EXEC sp_PopularErrorMessages 'ERRO:9090>> Wrong Operation: ';
EXEC sp_PopularErrorMessages 'ERRO:9100>> Employee does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9110>> Password needs to be reset. Add @NewPassword variable with a new passoword value: ';
EXEC sp_PopularErrorMessages 'ERRO:9120>> Duplicate Employee Number: ';
EXEC sp_PopularErrorMessages 'ERRO:9130>> Duplicate Employee Email: ';
EXEC sp_PopularErrorMessages 'ERRO:9140>> Please answer all 3 questions correctly: ';
EXEC sp_PopularErrorMessages 'ERRO:9150>> ProductModelName does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9160>> ProductSizeID does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9170>> ProductWeightID does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9180>> StatusName does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9190>> LanguageCode does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9200>> Category does not exist: ';
EXEC sp_PopularErrorMessages 'ERRO:9210>> Value does not match with condition: ';
EXEC sp_PopularErrorMessages 'ERRO:9220>> Constraint error: ';
EXEC sp_PopularErrorMessages 'ERRO:9230>> This is FK in another table: ';
EXEC sp_PopularErrorMessages 'ERRO:9240>> Must be unique value: ';
EXEC sp_PopularErrorMessages 'ERRO:9250>> You should reset password, add the parameter @NewPassword with a new passoword value!'
EXEC sp_PopularErrorMessages 'ERRO:9260>> ProductLanguage does not exist'
EXEC sp_PopularErrorMessages 'ERRO:9260>> ProductSubCategory does not exist'
 
-- Promotions
GO
CREATE PROCEDURE sp_PopularPromotions
  (@PromotionCode nvarchar(3),
  @PromotionType nvarchar(100),
  @PromotionStartDate date,
  @PromotionEndDate date)
AS
BEGIN
  INSERT INTO Promotions
    (PromotionCode,PromotionType,PromotionStartDate,PromotionEndDate)
  VALUES
    (@PromotionCode, @PromotionType, @PromotionStartDate, @PromotionEndDate);
END
GO
 
EXEC sp_PopularPromotions '10%','10% off on all purchases','2019-01-01', '2019-01-31';
EXEC sp_PopularPromotions '20%','20% off on all purchases','2019-03-01', '2019-03-31';
EXEC sp_PopularPromotions '30%','30% off on all purchases','2019-06-01', '2019-06-30';
EXEC sp_PopularPromotions '40%','40% off on all purchases','2019-09-01', '2019-09-30';
EXEC sp_PopularPromotions '50%','50% off on all purchases','2019-11-10', '2019-11-24';
 


 
--Employee

EXEC spInsertEmployee 1,'Freddy','Charles','Krueger','user1','1@gmail.com','',''
EXEC spInsertEmployee 2,'Jason','','Voorhees','user2','2@gmail.com','',''
EXEC spInsertEmployee 3,'Mike','','Myers','user3','3@gmail.com','',''
 
-- QuestionList
GO
CREATE PROCEDURE sp_PopulateQuestionList
  (@Question nvarchar(max))
AS
BEGIN
  INSERT INTO QuestionList
    (Question)
  VALUES
    (@Question);
END
GO
 
EXEC sp_PopulateQuestionList 'Do you like dogs?';
EXEC sp_PopulateQuestionList 'Do you like cats?';
EXEC sp_PopulateQuestionList 'Are you vaccinated?';
EXEC sp_PopulateQuestionList 'Are you an employee?'
EXEC sp_PopulateQuestionList 'Are you a human?'
EXEC sp_PopulateQuestionList 'Are you a robot?'
EXEC sp_PopulateQuestionList 'Are you female?'
EXEC sp_PopulateQuestionList 'Are you male?'
EXEC sp_PopulateQuestionList 'Are you good at your job?'
 
 
-- QuestionAnswer
GO
CREATE PROCEDURE sp_PopulateQuestionAnswer
  (@QuestionID int,
  @employeeNumber int,
  @answer nvarchar(max))
AS
BEGIN
  INSERT INTO QuestionAnswer
    (QuestionID,EmployeeNumber,Answer)
  VALUES
    (@QuestionID, @employeeNumber, @answer);
END
GO
 
EXEC sp_PopulateQuestionAnswer 1,1,'yes'
EXEC sp_PopulateQuestionAnswer 2,1,'yes'
EXEC sp_PopulateQuestionAnswer 3,1,'yes'
EXEC sp_PopulateQuestionAnswer 4,2,'yes'
EXEC sp_PopulateQuestionAnswer 5,2,'yes'
EXEC sp_PopulateQuestionAnswer 6,2,'yes'
EXEC sp_PopulateQuestionAnswer 7,3,'yes'
EXEC sp_PopulateQuestionAnswer 8,3,'yes'
EXEC sp_PopulateQuestionAnswer 9,3,'yes'
