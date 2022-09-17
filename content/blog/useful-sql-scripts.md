+++
title = "Useful SQL Scripts"
date = 2022-09-16T23:05:07+01:00
+++

I've had these SQL Server scripts kicking around on my hard drive for a while
now, so thought I'd post them here for posterity.

### Find Duplicate Foreign-keys

For some reason SQL Server allows duplicate foreign keys. This script finds them
for you.

```sql
WITH FKData
AS (
    SELECT fk.parent_object_id
        ,fkc.parent_column_id
        ,fk.referenced_object_id
        ,fkc.referenced_column_id
        ,FKCount = COUNT(*)
    FROM sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
    GROUP BY fk.parent_object_id
        ,fkc.parent_column_id
        ,fk.referenced_object_id
        ,fkc.referenced_column_id
    HAVING COUNT(*) > 1
    )
    ,DuplicateFK
AS (
    SELECT FKName = fk.Name
        ,ParentSchema = s1.Name
        ,ParentTable = t1.Name
        ,ParentColumn = c1.Name
        ,ReferencedTable = t2.Name
        ,ReferencedColumn = c2.Name
    FROM sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
    INNER JOIN FKData f ON fk.parent_object_id = f.parent_object_id
        AND fk.referenced_object_id = f.referenced_object_id
        AND fkc.parent_column_id = f.parent_column_id
        AND fkc.referenced_column_id = f.referenced_column_id
    INNER JOIN sys.tables t1 ON f.parent_object_id = t1.object_id
    INNER JOIN sys.columns c1 ON f.parent_object_id = c1.object_id
        AND f.parent_column_id = c1.column_id
    INNER JOIN sys.schemas s1 ON t1.schema_id = s1.schema_id
    INNER JOIN sys.tables t2 ON f.referenced_object_id = t2.object_id
    INNER JOIN sys.columns c2 ON f.referenced_object_id = c2.object_id
        AND f.referenced_column_id = c2.column_id
    )
SELECT FKName
    ,ParentSchema
    ,ParentTable
    ,ParentColumn
    ,ReferencedTable
    ,ReferencedColumn
    ,DropStmt = 'ALTER TABLE ' + ParentSchema + '.' + ParentTable + ' DROP CONSTRAINT ' + FKName
FROM DuplicateFK
ORDER BY ParentTable
    ,FKName
```

### Find Auto-generated Key Names

When creating foreign-keys, SQL Server allows you to neglect to specify a name
for them, and instead generated a name for you. This script finds them for you
so you can give them a better one.

```sql
-- primary keys
SELECT kc.[name] AS 'primary key', o.[name] 'table' FROM sys.key_constraints kc
  JOIN sys.objects o ON o.object_id = kc.parent_object_id
  WHERE kc.[name] LIKE 'PK[_][_]%'

-- foreign keys
SELECT fk.[name] AS 'foreign key', o.[name] 'table' FROM sys.foreign_keys fk
  JOIN sys.objects o ON o.object_id = fk.parent_object_id
  WHERE fk.[name] LIKE 'FK[_][_]%'

-- default constraints
SELECT dc.[name] 'default constraint', o.[name] 'table' FROM sys.default_constraints dc
  JOIN sys.objects o ON o.object_id = dc.parent_object_id
  WHERE dc.[name] LIKE 'DF[_][_]%'

-- check constraints
SELECT cc.[name] 'check constraint', o.[name] 'table' FROM sys.check_constraints cc
  JOIN sys.objects o ON o.object_id = cc.parent_object_id
  WHERE cc.[name] LIKE 'CK[_][_]%'
```

### Extended Property Views

If you're a degenerate sociopath, you probably use SQL Server Management Studio to create tables.
This code will list all of the diagram extended property records that doing so creates.

```sql
SELECT o.[name], ep.[name]
  FROM sys.extended_properties ep
  LEFT JOIN sys.objects o ON o.object_id = ep.major_id
  WHERE [ep].[name] LIKE 'MS_DiagramPane%' OR [ep].[name] = 'MS_DiagramPaneCount'
  ORDER BY o.[name]
```
