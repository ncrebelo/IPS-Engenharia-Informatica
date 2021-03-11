--  Lógica para Tabela ErrorLog
GO
CREATE OR ALTER FUNCTION fnGetErrorCode
(@ErrorCode int)
RETURNS nvarchar(100)
AS
    BEGIN
  RETURN(
            SELECT ErrorMessage
  FROM ERROR_Messages
  WHERE ErrorCode = @ErrorCode
        )
END
GO

-- Funcão auxiliar para ErrorLog
GO
CREATE FUNCTION fn_GetErrorMessage
(@ErrorCode int)
RETURNS nvarchar(100)
AS
    BEGIN
  RETURN (
            SELECT ErrorMessage
  FROM Error_Messages
  WHERE ErrorCode = @ErrorCode
                )
END
GO


-- ErrorLog
GO
CREATE Procedure sp_PreencherErrorLog
  @ErrorCode int,
  @ErrorUser nvarchar(30),
  @ErrorDetail nvarchar(100)
AS
BEGIN
  IF EXISTS (SELECT ErrorCode
  FROM Error_Messages
  WHERE ErrorCode = @ErrorCode)
    BEGIN
    INSERT INTO ERROR_LOG
      (ErrorCode, ErrorDetail, ErrorUser, ErrorTimeStamp)
    VALUES
      (@ErrorCode, @ErrorDetail, @ErrorUser, CURRENT_TIMESTAMP);

    PRINT dbo.fn_GetErrorMessage(@ErrorCode) + @ErrorDetail;

  END
END
GO

