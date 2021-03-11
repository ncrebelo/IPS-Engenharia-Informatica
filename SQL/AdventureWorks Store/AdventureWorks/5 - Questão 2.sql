-- 2.A) Para os novos utilizadores a password do sistema deverá será alvo de reset na primeira entrada.
GO
CREATE OR ALTER PROCEDURE spLogin
  (@EmailAddress VARCHAR(255),
  @Password VARCHAR(255),
  @NewPassword VARCHAR(255) = NULL)
AS
BEGIN
 
  DECLARE CursorEmployee CURSOR FOR SELECT TOP 1
    EmployeeNumber, ResetPassword
  FROM Employee
  WHERE EmailAddress = @EmailAddress AND Password = @Password
 
  DECLARE @EmployeeNumber VARCHAR(50)
  DECLARE @ResetPassword CHAR
 
  OPEN CursorEmployee
 
  FETCH NEXT FROM CursorEmployee INTO @EmployeeNumber, @ResetPassword
 
  IF (@EmployeeNumber IS NULL)
     EXEC sp_PreencherErrorLog 9100, '''', @EmailAddress;
 
ELSE IF (@ResetPassword = 1)
    IF (@NewPassword IS NULL)
        EXEC sp_PreencherErrorLog 9250, '''', @EmailAddress;
    ELSE
        BEGIN
    UPDATE Employee SET [Password] = @NewPassword, ResetPassword = 0 WHERE EmployeeNumber = @EmployeeNumber
    PRINT 'Password reset. Your EmployeeNumber: ' + @EmployeeNumber
  END
ELSE
    PRINT 'Login successfull. Your EmployeeNumber: ' + @EmployeeNumber
 
  CLOSE CursorEmployee
  DEALLOCATE CursorEmployee
END
GO
 
-- 2.B) Sempre que é adicionado um novo utilizador ou este solicita a recuperação de password, o sistema deverá automaticamente gerar uma password e enviar e-mail ao mesmo com essa informação (no âmbito do projeto, poderá ser efetuada uma simulação de escrita numa tabela “sentEmails” em vez de configuração de servidor de e-mail).
GO
CREATE TRIGGER newPassword ON Employee AFTER INSERT AS
 
DECLARE @EmployeeNumber INTEGER = (select EmployeeNumber
from inserted)
DECLARE @Password VARCHAR(50) = ROUND(RAND() * 100000, 0)
 
UPDATE Employee SET [Password] = @Password, ResetPassword = 1 WHERE EmployeeNumber = @EmployeeNumber
INSERT INTO SentEmail
  (EmployeeNumber, Subject, Content, CreatedAt)
VALUES
  (@EmployeeNumber, 'You Passowrd', 'Password to access: ' + @Password, GETDATE())
GO
 
GO
CREATE OR ALTER PROCEDURE spRecoveryPassword
  (@EmailAddress VARCHAR(255),
  @Password VARCHAR(255))
AS
BEGIN
 
  DECLARE @EmployeeNumber NVARCHAR(30) =  (SELECT TOP 1
    EmployeeNumber
  FROM Employee
  WHERE EmailAddress = @EmailAddress AND Password = @Password)
 
  DECLARE @NewPassword VARCHAR(50) = ROUND(RAND() * 100000, 0)
 
  UPDATE Employee SET [Password] = @NewPassword, ResetPassword = 1 WHERE EmployeeNumber = @EmployeeNumber
  INSERT INTO SentEmail
    (EmployeeNumber, Subject, Content, CreatedAt)
  VALUES
    (@EmployeeNumber, 'You New Passowrd', 'New password to access: ' + @NewPassword, GETDATE())
END
GO
