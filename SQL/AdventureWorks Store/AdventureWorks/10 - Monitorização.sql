-- Uma stored procedure que recorra ao catalogo para gerar entradas numa tabela(s) dedicada(s) onde deve constar a seguinte informação relativa à bases de dados: todos os campos de todas as tabelas, com os seus tipos de dados, tamanho respetivo e restrições associadas (no caso de chaves estrangeiras, deve ser indicada qual a tabela referenciada e o tipo de ação definido para a manutenção da integridade referencial nas operações de “update” e “delete”. Deverá manter histórico de alterações do esquema da BD nas sucessivas execuções da sp.
GO
CREATE OR ALTER PROCEDURE spMonitoringStructure
AS
DECLARE @DATE DATETIME = GETDATE()
INSERT INTO MonitoringStructure(TableName, ColumnName, DataType, Length, ReferencedTable, ReferencedColumn, UpdateRule, DeleteRule, CreatedAt)
SELECT
  c.TABLE_NAME,
  c.COLUMN_NAME,
  c.DATA_TYPE, 
  c.CHARACTER_MAXIMUM_LENGTH,
  kcu1.TABLE_NAME as 'REFERENCED_TABLE',
  kcu1.COLUMN_NAME as 'REFERENCED_COLUMN',
  rc.UPDATE_RULE,
  rc.DELETE_RULE,
  @DATE
FROM INFORMATION_SCHEMA.COLUMNS c
left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu on kcu.TABLE_NAME = c.TABLE_NAME and kcu.COLUMN_NAME = c.COLUMN_NAME
left join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc on rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu1 on kcu1.CONSTRAINT_NAME = RC.UNIQUE_CONSTRAINT_NAME and kcu1.ORDINAL_POSITION = kcu.ORDINAL_POSITION
GO


-- Uma view que disponibilize os dados relativos à execução mais recente, presentes na tabela do ponto anterior.
GO 
CREATE OR ALTER VIEW vMonitoringStructure AS
SELECT * from MonitoringStructure where CreatedAt = (SELECT top 1 CreatedAt from MonitoringStructure order by CreatedAt desc)
GO


-- Uma stored procedure que registe, também em tabela dedicada, por cada tabela da base de dados o seu número de registos e estimativa mais fiável do espaço ocupado. Deverá manter histórico dos resultados das sucessivas execuções da sp. 
GO
CREATE OR ALTER PROCEDURE spMonitoringSize AS
DECLARE TablesName CURSOR FOR (select TABLE_NAME from INFORMATION_SCHEMA.TABLES)
DECLARE @TableName VARCHAR(50)
DECLARE @Date DATETIME = GETDATE(), @TName VARCHAR(50), @Rows int, @Reserved VARCHAR(50), @Data VARCHAR(50), @IndexSize VARCHAR(50), @Unused VARCHAR(50), @CreatedAt VARCHAR(50)
DECLARE @TableSpaceUsed TABLE (name varchar(20), rows int, reserved varchar(20), data varchar(20), index_sixe varchar(20), unuded varchar(20))
 
OPEN TablesName
 
FETCH NEXT FROM TablesName INTO @TableName
 
WHILE @@FETCH_STATUS=0
BEGIN
    INSERT INTO @TableSpaceUsed EXEC sp_spaceused @TableName
    FETCH NEXT FROM TablesName INTO @TableName
END
 
CLOSE TablesName
DEALLOCATE TablesName
 
 
 
DECLARE TableSize CURSOR FOR (SELECT * FROM @TableSpaceUsed)
 
OPEN TableSize
 
FETCH NEXT FROM TableSize INTO @TName, @Rows, @Reserved, @Data, @IndexSize, @Unused
 
WHILE @@FETCH_STATUS=0
BEGIN
 INSERT INTO MonitoringSize(TableName, Rows, Reserved, Data, IndexSize, Unused, CreatedAt) VALUES(@TName, @Rows, @Reserved, @Data, @IndexSize, @Unused, @Date)
 
 FETCH NEXT FROM TableSize INTO @TName, @Rows, @Reserved, @Data, @IndexSize, @Unused
END 
 
CLOSE TableSize
DEALLOCATE TableSize
 

GO


