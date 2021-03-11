-- 5.A) Editar, Adicionar e Remover Utilizadores
 
--Adicionar
EXEC spGeneratorInsert @Table="Employee"
 
--Editar
EXEC spGeneratorUpdate @Table="Employee"
 
--Remover
EXEC spGeneratorDelete @Table="Employee"
 
 
 
--5.B) Recuperar Password – Um utilizador para poder recuperar a password deve ter definidas 3 questões às quais deve responder corretamente para efetuar a recuperação. Cada utilizador terá à escolha uma lista de questões às quais deve responder, sendo obrigatório selecionar pelo menos 3.
 
GO
CREATE OR ALTER PROCEDURE spRecoveryPassword
  (
  @EmailAddress VARCHAR(255),
  @Password VARCHAR(255),
  @Question1 INT = null,
  @Answer1 VARCHAR(MAX) = null,
  @Question2 INT = null,
  @Answer2 VARCHAR(MAX) = null,
  @Question3 INT = null,
  @Answer3 VARCHAR(MAX) = null)
AS
BEGIN
 
  DECLARE @EmployeeNumber NVARCHAR(30) =  (SELECT TOP 1
    EmployeeNumber
  FROM Employee
  WHERE EmailAddress = @EmailAddress AND Password = @Password)
 
  if (@EmployeeNumber IS NULL)
  BEGIN
    DECLARE @temp varchar(100) = CAST('Email: ' + @EmailAddress AS varchar);
    EXEC sp_PreencherErrorLog 9100, '', @temp;
    return;
  END
 
  DECLARE @CheckAnswer int = (select count(*)
  from QuestionAnswer
  where EmployeeNumber = @EmployeeNumber and
  ((QuestionID = @Question1 and Answer = @Answer1) OR
    (QuestionID = @Question2 and Answer = @Answer2) OR
    (QuestionID = @Question3 and Answer = @Answer3))
)
  if (@CheckAnswer <> 3)
  BEGIN
    SET @temp = CAST(@CheckAnswer AS varchar);
    EXEC sp_PreencherErrorLog 9140, '', @temp;
    return;
  END
 
  DECLARE @NewPassword VARCHAR(50) = ROUND(RAND() * 100000, 0)
 
  UPDATE Employee SET [Password] = @NewPassword, ResetPassword = 0 WHERE EmployeeNumber = @EmployeeNumber
  INSERT INTO SentEmail
    (EmployeeNumber, Subject, Content, CreatedAt)
  VALUES
    (@EmployeeNumber, 'Your New Password', 'New password to access: ' + @NewPassword, GETDATE())
END
GO
