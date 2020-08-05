+++
title = "sp_MSforeachtable Table Filtering"
description = "How to filter the tables that sp_MSforeachtable acts upon."
tags = ["T-SQL", "SQL Server"]
categories = ["Programming", "Databases"]
date = 2020-08-05
+++

SQL Server provides the handy `sp_MSforeachtable` stored procedure for executing
the specified T-SQL for each table in a database. But what if you only want to
run it for certain tables? I found myself in this boat but a bunch of the
recommendations I came across didn't work. The `whereand` parameter was clearly
what I wanted. However, say we wanted to filter out all tables whos names didn't
start with "Foo":

```sql
EXEC sp_MSforeachtable @command1='print ''?''', @whereand='AND name LIKE ''Foo%'''
```

resulted in:

```
Msg 209, Level 16, State 1, Line 1
Ambiguous column name 'name'.
```

and

```sql
EXEC sp_MSforeachtable @command1='print ''?''', @whereand='AND ? LIKE ''Foo%'''
```

resulted in:

```
Msg 102, Level 15, State 1, Line 1
Incorrect syntax near '?'.
```

What to do? After looking at the code for the procedure, I noticed that it uses
`sys.all_objects` (aliased as `syso`), so we can use the `object_name` function
and the `object_id` field of `sys.all_objects` to get at the table name:

```sql
EXEC sp_MSforeachtable @command1='print ''?''', @whereand='AND object_name(object_id) LIKE ''Foo%'''
```

or:

```sql
EXEC sp_MSforeachtable @command1='print ''?''', @whereand='AND syso.name LIKE ''Foo%'''
```
