GO
CREATE OR ALTER PROCEDURE spGeneratorInsert
  @Schema VARCHAR(50) = '',
  @Table VARCHAR(50)
AS
DECLARE @ColumnName VARCHAR(50), @DataType VARCHAR(50), @MaxLength INTEGER, @Nullable VARCHAR(5), @Params VARCHAR(MAX) = '', @Columns VARCHAR(MAX) = '', @ColumnsValues VARCHAR(MAX) = '', @ConstraintType VARCHAR(255), @Error VARCHAR(255)

DECLARE SchemaColumns CURSOR FOR (SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table AND COLUMNPROPERTY(object_id(TABLE_SCHEMA+'.'+TABLE_NAME), COLUMN_NAME, 'IsIdentity') <> 1)

OPEN SchemaColumns

FETCH NEXT FROM SchemaColumns INTO @ColumnName, @DataType, @MaxLength, @Nullable

WHILE @@Fetch_Status=0
        BEGIN
  SET @Columns += @ColumnName
  SET @ColumnsValues += '@' + @ColumnName

  DECLARE @Param VARCHAR(255) = '@' + @ColumnName + ' ' + @DataType

  IF (@MaxLength > 0)
                        SET @Param += ' (' + cast(@MaxLength AS VARCHAR) +')'

  IF (@Nullable = 'YES')
                            SET @Param += ' = NULL'


  FETCH NEXT FROM SchemaColumns INTO @ColumnName, @DataType, @MaxLength, @Nullable

  IF @@Fetch_Status=0
                            BEGIN
    SET @Param += ', '
    SET @Columns += ', '
    SET @ColumnsValues += ', '
  END
  SET @Params += @Param
END


CLOSE SchemaColumns
DEALLOCATE SchemaColumns

DECLARE @Condition VARCHAR (MAX), @Conditions VARCHAR(MAX) = ''

DECLARE Constraints CURSOR FOR (SELECT
  REPLACE(REPLACE(REPLACE(REPLACE(c.CHECK_CLAUSE, '[', '@'), ']', ''), '(', ''), ')', '') AS Options,
  CU.COLUMN_NAME, ta.CONSTRAINT_TYPE

FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
  left JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS AS c on c.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
    AND c.CONSTRAINT_CATALOG = cu.TABLE_CATALOG
  INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
  inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cu.TABLE_NAME = @Table AND (ta.CONSTRAINT_TYPE = 'unique' or ta.CONSTRAINT_TYPE = 'check') AND COLUMNPROPERTY(object_id(cl.TABLE_SCHEMA+'.'+cl.TABLE_NAME), cl.COLUMN_NAME, 'IsIdentity') <> 1
)

OPEN Constraints

FETCH NEXT FROM Constraints INTO @Condition, @ColumnName, @ConstraintType


WHILE @@Fetch_Status=0
    BEGIN

  IF (@ConstraintType = 'unique')
        SET @Conditions += 'IF EXISTS (SELECT * FROM '+ @Schema + @Table +' WHERE ' + @ColumnName + ' = @'+ @ColumnName  + ')
            BEGIN
                SET @temp = CAST((''' + @ColumnName  + ': ''+ @' + @ColumnName +') AS varchar);
                EXEC sp_PreencherErrorLog 9220, '''', @temp;
                RETURN
            END
        '
    ELSE
        SET @Conditions += 'IF NOT ('+ @Condition + ')
            BEGIN
                SET @temp = CAST(''' + @Condition +''' AS varchar);
                EXEC sp_PreencherErrorLog 9210, '''', @temp;
                RETURN
            END
        '

  FETCH NEXT FROM Constraints INTO @Condition, @ColumnName, @ConstraintType
END

CLOSE Constraints
DEALLOCATE Constraints


DECLARE @ParentColumn VARCHAR(50), @ReferencedTable VARCHAR(50), @ReferencedColumn VARCHAR(50), @ReferencedNullable TINYINT

DECLARE [References] CURSOR FOR (SELECT
  '@' + c1.name 'ParentColumn',
  OBJECT_NAME(fk.referenced_object_id) 'ReferencedTable',
  c2.name 'ReferencedColumn',
  c1.is_nullable
FROM
  sys.foreign_keys fk
  INNER JOIN
  sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
  INNER JOIN
  sys.columns c1 ON fkc.parent_column_id = c1.column_id AND fkc.parent_object_id = c1.object_id
  INNER JOIN
  sys.columns c2 ON fkc.referenced_column_id = c2.column_id AND fkc.referenced_object_id = c2.object_id
WHERE  OBJECT_NAME(fk.parent_object_id) = @Table)

OPEN [References]

FETCH NEXT FROM [References] INTO @ParentColumn, @ReferencedTable, @ReferencedColumn, @ReferencedNullable

WHILE @@Fetch_Status=0
    BEGIN
  SET @Conditions += 'IF ((('+ @ParentColumn +' IS NOT NULL) AND (NOT EXISTS (SELECT * FROM ' + @Schema + @ReferencedTable + ' WHERE ' + @ReferencedColumn + ' = ' + @ParentColumn+ '))) OR (('+ @ParentColumn +' IS NULL) AND ('+ cast(@ReferencedNullable as [varchar]) +' = 0)))
            BEGIN
                SET @temp = CAST((''' + @ParentColumn + ': '' + ' + @ParentColumn +') AS varchar);
                EXEC sp_PreencherErrorLog 9000, '''', @temp;
                RETURN
            END
        '

  FETCH NEXT FROM [References] INTO @ParentColumn, @ReferencedTable, @ReferencedColumn, @ReferencedNullable
END

CLOSE [References]
DEALLOCATE [References]

DECLARE @Script VARCHAR(MAX) = 'CREATE OR ALTER PROCEDURE spInsert' + @Table + ' ' + @Params + ' AS
    DECLARE @temp VARCHAR(250)
    ' + @Conditions + '
    INSERT INTO ' + @Schema + @Table + ' (' + @Columns +') VALUES ( ' + @ColumnsValues + ')'
EXEC (@Script)
GO

GO
CREATE PROCEDURE spGeneratorUpdate
  @Schema VARCHAR(50) = '',
  @Table VARCHAR(50)
AS
DECLARE @ColumnName VARCHAR(50), @DataType VARCHAR(50), @MaxLength INTEGER, @Nullable VARCHAR(5), @Params VARCHAR(MAX) = '', @Columns VARCHAR(MAX) = '', @ConstraintType VARCHAR(255), @Error VARCHAR(255), @Cond VARCHAR(MAX) = ''

DECLARE SchemaColumns CURSOR FOR (SELECT cl.COLUMN_NAME, cl.DATA_TYPE, cl.CHARACTER_MAXIMUM_LENGTH, cl.IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS cl
  left join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cu ON cl.COLUMN_NAME = cu.COLUMN_NAME AND cl.TABLE_CATALOG = cu.TABLE_CATALOG AND cl.TABLE_NAME = cu.TABLE_NAME
  left JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cl.TABLE_NAME = @Table AND cl.COLUMN_NAME not in (SELECT
    cl.COLUMN_NAME
  FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
      AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
      AND cl.TABLE_NAME = cu.TABLE_NAME
    inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
  WHERE cu.TABLE_NAME = @Table AND ta.CONSTRAINT_TYPE = 'PRIMARY KEY'))


OPEN SchemaColumns

FETCH NEXT FROM SchemaColumns INTO @ColumnName, @DataType, @MaxLength, @Nullable

WHILE @@Fetch_Status=0
        BEGIN
  SET @Columns += @ColumnName + ' = @' + @ColumnName

  DECLARE @Param VARCHAR(255) = ' @' + @ColumnName + ' ' + @DataType

  IF (@MaxLength > 0)
            SET @Param += ' (' + cast(@MaxLength AS VARCHAR) +')'

  IF (@Nullable = 'YES')
            SET @Param += ' = NULL'


  SET @Param += ', '
  FETCH NEXT FROM SchemaColumns INTO @ColumnName, @DataType, @MaxLength, @Nullable

  IF @@Fetch_Status=0
        SET @Columns += ', '
  SET @Params += @Param
END


CLOSE SchemaColumns
DEALLOCATE SchemaColumns

DECLARE @Condition VARCHAR (MAX), @Conditions VARCHAR(MAX) = ''

DECLARE Constraints CURSOR FOR (
SELECT
  REPLACE(REPLACE(REPLACE(REPLACE(c.CHECK_CLAUSE, '[', '@'), ']', ''), '(', ''), ')', '') AS Options,
  CU.COLUMN_NAME, ta.CONSTRAINT_TYPE

FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
  left JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS AS c on c.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
    AND c.CONSTRAINT_CATALOG = cu.TABLE_CATALOG
  INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
  inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cu.TABLE_NAME = @Table AND (ta.CONSTRAINT_TYPE = 'unique' or ta.CONSTRAINT_TYPE = 'check') AND COLUMNPROPERTY(object_id(cl.TABLE_SCHEMA+'.'+cl.TABLE_NAME), cl.COLUMN_NAME, 'IsIdentity') <> 1 AND cl.COLUMN_NAME not in (SELECT
    cl.COLUMN_NAME
  FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
      AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
      AND cl.TABLE_NAME = cu.TABLE_NAME
    inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
  WHERE cu.TABLE_NAME = @Table AND ta.CONSTRAINT_TYPE = 'PRIMARY KEY')

)

OPEN Constraints

FETCH NEXT FROM Constraints INTO @Condition, @ColumnName, @ConstraintType


WHILE @@Fetch_Status=0
    BEGIN

  IF (@ConstraintType = 'unique')
        SET @Conditions += 'IF EXISTS (SELECT * FROM '+ @Schema + @Table +' WHERE ' + @ColumnName + ' = @'+ @ColumnName  + ')
            BEGIN
                SET @temp = CAST((''' + @ColumnName  + ': ''+ @' + @ColumnName +') AS varchar);
                EXEC sp_PreencherErrorLog 9240, '''', @temp;
                RETURN
            END
        '
    ELSE
        SET @Conditions += 'IF NOT ('+ @Condition + ')
            BEGIN
                SET @temp = CAST(''' + @Condition +''' AS varchar);
                EXEC sp_PreencherErrorLog 9210, '''', @temp;
                RETURN
            END
        '

  FETCH NEXT FROM Constraints INTO @Condition, @ColumnName, @ConstraintType
END

CLOSE Constraints
DEALLOCATE Constraints


DECLARE @ParentColumn VARCHAR(50), @ReferencedTable VARCHAR(50), @ReferencedColumn VARCHAR(50), @ReferencedNullable TINYINT

DECLARE [References] CURSOR FOR (SELECT
  '@' + c1.name 'ParentColumn',
  OBJECT_NAME(fk.referenced_object_id) 'ReferencedTable',
  c2.name 'ReferencedColumn',
  c1.is_nullable
FROM
  sys.foreign_keys fk
  INNER JOIN
  sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
  INNER JOIN
  sys.columns c1 ON fkc.parent_column_id = c1.column_id AND fkc.parent_object_id = c1.object_id
  INNER JOIN
  sys.columns c2 ON fkc.referenced_column_id = c2.column_id AND fkc.referenced_object_id = c2.object_id
WHERE  OBJECT_NAME(fk.parent_object_id) = @Table)

OPEN [References]

FETCH NEXT FROM [References] INTO @ParentColumn, @ReferencedTable, @ReferencedColumn, @ReferencedNullable

WHILE @@Fetch_Status=0
    BEGIN
  SET @Conditions += 'IF ((('+ @ParentColumn +' IS NOT NULL) AND (NOT EXISTS (SELECT * FROM ' + @Schema + @ReferencedTable + ' WHERE ' + @ReferencedColumn + ' = ' + @ParentColumn+ '))) OR (('+ @ParentColumn +' IS NULL) AND ('+ cast(@ReferencedNullable as [varchar]) +' = 0)))
            BEGIN
                SET @temp = CAST((''' + @ParentColumn + ': '' +' + @ParentColumn +') AS varchar);
                EXEC sp_PreencherErrorLog 9000, '''', @temp;
                RETURN
            END
        '

  FETCH NEXT FROM [References] INTO @ParentColumn, @ReferencedTable, @ReferencedColumn, @ReferencedNullable
END

CLOSE [References]
DEALLOCATE [References]

DECLARE PKColumns CURSOR FOR (SELECT
  cl.COLUMN_NAME, cl.DATA_TYPE, cl.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
  INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
  inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cu.TABLE_NAME = @Table AND ta.CONSTRAINT_TYPE = 'PRIMARY KEY')


OPEN PKColumns

FETCH NEXT FROM PKColumns INTO @ColumnName, @DataType, @MaxLength

WHILE @@Fetch_Status=0
    BEGIN
  SET @Param = '@' + @ColumnName + ' ' + @DataType

  IF (@MaxLength > 0)
            SET @Param += ' (' + cast(@MaxLength AS VARCHAR) +')'

  SET @Cond += @ColumnName + ' = @' + @ColumnName

  FETCH NEXT FROM PKColumns INTO @ColumnName, @DataType, @MaxLength

  IF @@Fetch_Status=0
            BEGIN
    SET @Param += ', '
    SET @Cond += ' AND '
  END

  SET @Params += @Param
END

CLOSE PKColumns
DEALLOCATE PKColumns

DECLARE @Script VARCHAR(MAX) = 'CREATE OR ALTER PROCEDURE spUpdate' + @Table + @Params + ' AS
    DECLARE @temp VARCHAR(250)
    ' + @Conditions + '
    UPDATE ' + @Schema + @Table + ' SET ' + @Columns +' WHERE ' + @Cond
EXEC (@Script)

GO

GO
CREATE PROCEDURE spGeneratorDelete
  @Schema VARCHAR(50) = '',
  @Table VARCHAR(50)
AS

DECLARE @Params varchar(max) = '', @Param VARCHAR(255) = '', @Conditions VARCHAR(max) = '', @ColumnName VARCHAR(100) = '', @DataType VARCHAR(100) = '', @MaxLength int, @Cond VARCHAR(100) = '', @TablePK VARCHAR(100), @ColumnsPKCheck VARCHAR(MAX) = ''

DECLARE PKColumns CURSOR FOR (SELECT
  cl.COLUMN_NAME, cl.DATA_TYPE, cl.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
  INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
  inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cu.TABLE_NAME = @Table AND (ta.CONSTRAINT_TYPE = 'PRIMARY KEY'))


OPEN PKColumns

FETCH NEXT FROM PKColumns INTO @ColumnName, @DataType, @MaxLength

WHILE @@Fetch_Status=0
    BEGIN
  SET @Param = '@' + @ColumnName + ' ' + @DataType

  IF (@MaxLength > 0)
            SET @Param += ' (' + cast(@MaxLength AS VARCHAR) +')'

  SET @Cond += @ColumnName + ' = @' + @ColumnName

  SET @ColumnsPKCheck += @ColumnName

  FETCH NEXT FROM PKColumns INTO @ColumnName, @DataType, @MaxLength

  IF @@Fetch_Status=0
            BEGIN
    SET @Param += ', '
    SET @Cond += ' AND '
    SET @ColumnsPKCheck += ' AND '
  END

  SET @Params += @Param
END
CLOSE PKColumns
DEALLOCATE PKColumns

DECLARE TablesPKs CURSOR FOR (SELECT
  cu.TABLE_NAME
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS cu
  left JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS AS c on c.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
    AND c.CONSTRAINT_CATALOG = cu.TABLE_CATALOG
  INNER JOIN INFORMATION_SCHEMA.COLUMNS AS cl ON cl.COLUMN_NAME = cu.COLUMN_NAME
    AND cl.TABLE_CATALOG = cu.TABLE_CATALOG
    AND cl.TABLE_NAME = cu.TABLE_NAME
  inner JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ta ON ta.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
WHERE cu.COLUMN_NAME = @ColumnsPKCheck
  AND (ta.CONSTRAINT_TYPE = 'FOREIGN KEY') AND COLUMNPROPERTY(object_id(cl.TABLE_SCHEMA+'.'+cl.TABLE_NAME), cl.COLUMN_NAME, 'IsIdentity') <> 1)


OPEN TablesPKs
FETCH NEXT FROM TablesPKs INTO @TablePK

WHILE @@Fetch_Status=0
            BEGIN
  SET @Conditions += '
                IF (EXISTS (SELECT * FROM ' +  @TablePK + ' WHERE '+ @Cond + '))
                        BEGIN
                             SET @temp = CAST(''' + @TablePK +''' AS varchar);
                            EXEC sp_PreencherErrorLog 9230, '''', @temp;
                            RETURN
                        END
                '

  FETCH NEXT FROM TablesPKs INTO @TablePK
END

CLOSE TablesPKs
DEALLOCATE TablesPKs

DECLARE @Script VARCHAR(MAX) = 'CREATE OR ALTER PROCEDURE spDelete' + @Table + ' ' + @Params + ' AS
    DECLARE @temp VARCHAR(250)
    ' + @Conditions + '
    DELETE ' + @Schema + @Table + ' WHERE ' + @Cond
EXEC (@Script)
