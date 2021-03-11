 -- Espaço ocupado por registo de cada tabela;
GO
CREATE OR ALTER PROCEDURE spSizeRow AS
 
DECLARE TablesName CURSOR FOR (select TABLE_NAME from INFORMATION_SCHEMA.TABLES)
DECLARE @Script VARCHAR(max), @TableName VARCHAR(70), @Date DATETIME = GETDATE(), @TName VARCHAR(70), @Rows int, @Reserved VARCHAR(70), @Data VARCHAR(70), @IndexSize VARCHAR(70), @Unused VARCHAR(70), @CreatedAt VARCHAR(70)
DECLARE @TableSpaceUsed TABLE (TableName varchar(70), RowID varchar(70), RowsSize int)
declare @TablePK VARCHAR(70)
 
OPEN TablesName
 
FETCH NEXT FROM TablesName INTO @TableName
 
WHILE @@FETCH_STATUS=0
BEGIN
    set @TablePK = (SELECT TOP 1 cl.COLUMN_NAME
    FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
    inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
    WHERE cu.TABLE_NAME = @TableName AND ta.CONSTRAINT_TYPE = 'PRIMARY KEY')
 
    set @Script = 'select ''' + @TableName + ''' as TableName, ' + @TablePK +' as ID, (0'
    
    select @Script = @Script + ' + isnull(datalength(' + name + '), 1)' 
            from  sys.columns 
            where object_id = object_id(@TableName)
            and   is_computed = 0
    set @Script = @Script + ') as rowsize from ' + @TableName
    
    INSERT INTO @TableSpaceUsed EXEC (@Script)
    FETCH NEXT FROM TablesName INTO @TableName
END
 
CLOSE TablesName
DEALLOCATE TablesName
 
SELECT * FROM @TableSpaceUsed
GO 
 
 
--Espaço ocupado por cada tabela com o número atual de registos;
GO 
CREATE OR ALTER PROCEDURE spSizeTable AS
DECLARE TablesName CURSOR FOR (select TABLE_NAME from INFORMATION_SCHEMA.TABLES)
DECLARE @TableName VARCHAR(70), @Date DATETIME = GETDATE(), @TName VARCHAR(70), @Rows int, @Reserved VARCHAR(70), @Data VARCHAR(70), @IndexSize VARCHAR(70), @Unused VARCHAR(70), @CreatedAt VARCHAR(70)
DECLARE @TableSpaceUsed TABLE (name varchar(70), rows int, reserved varchar(70), data varchar(70), index_sixe varchar(70), unused varchar(70))
 
OPEN TablesName
 
FETCH NEXT FROM TablesName INTO @TableName
 
WHILE @@FETCH_STATUS=0
BEGIN
    INSERT INTO @TableSpaceUsed EXEC sp_spaceused @TableName
    FETCH NEXT FROM TablesName INTO @TableName
END
 
CLOSE TablesName
DEALLOCATE TablesName
 
SELECT * FROM @TableSpaceUsed
GO
 
--Propor uma taxa de crescimento por tabela (inferindo dos dados existentes);
 
Employee        8 KB
QuestionList        0 KB
QuestionAnswer  0 KB
Error_Messages  8 KB
Error_Log   8 KB
Promotions  0 KB
Company  0 KB
Country 8 KB
StateProvince   8 KB    
City    16 KB   
PostalCode  16 KB
Address 1032 KB
CustomerAddress 312 KB
Customer    3664 KB
Education   8 KB
Occupation  8 KB
SentEmail   0 KB
Currency    8 KB
SalesOrder  1432 KB
SalesOrderDetail    3664 KB 
SalesTerritoryGroup 8 KB
Monitoring  32 KB
SalesTerritoryRegion    8 KB    
vMonitoring 0 KB
ProductColor     8 KB
MonitoringStructure 0 KB
ProductSubCategory  8 KB
vMonitoringStructure    0 KB    
ProductLanguage 496 KB
ProductModel    8 KB    
MonitoringSize  8 KB
Product 48 KB
ProductSize 8 KB    
ProductWeight   8 KB
ProductSizeRange    8 KB    
Status  8 KB
LanguageType    8 KB
 
 
 
TOTAL = 10,91 KB ou 0,0109
Admitindo (1000x maior) = 10 910 KB ou 10,91 MB
Ao fim de 3 anos = 32,73 KB ou 0,032 MB
Ao fim de 5 anos = 54,55 KB ou 0,054 MB
 
 
 
-- Dimensionar o no e tipos de acessos.
 
 

