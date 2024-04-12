# SpeedTest of Synchronize Database
## Sync One Table
### Enter 200,000 fake data into the source table.
```sql
DECLARE @i int = 0

WHILE @i < 200000
BEGIN
    SET @i = @i + 1
    INSERT INTO source_db2.dbo.test_table ([text]) 
    VALUES ('A directory is nothing but a location for storing files on the Linux system in a hierarchical format. For example, $HOME/Downloads/ would store all downloaded files or /tmp/ would store temporary files. This page shows how to see if a directory exist');
END
```
### Check Tables Count
```sql
SELECT COUNT(*) FROM dbo.test_table ;
SELECT  (
    SELECT COUNT(*) FROM   source_db2.dbo.test_table
) AS count1,(
    SELECT COUNT(*) FROM   sink_db2.dbo.test_table
) 
```
### Summary
| | Source Table | Sink Table |
|-|-|-|
| Total Spend Time | 3min | 3min 30s |


## Sync Multiple Table
### Enter 200,000 fake data into the source tables.
```sql
DECLARE @i int = 0

WHILE @i < 200000
BEGIN
    SET @i = @i + 1
    INSERT INTO source_db2.dbo.test_table ([text]) 
    VALUES ('A directory is nothing but a location for storing files on the Linux system in a hierarchical format. For example, $HOME/Downloads/ would store all downloaded files or /tmp/ would store temporary files. This page shows how to see if a directory exist');
    
    INSERT INTO source_db2.dbo.test_table2 ([text]) 
    VALUES ('A directory is 2');
END
```

```sql
DELETE FROM source_db2.dbo.test_table WHERE 1=1
DELETE FROM source_db2.dbo.test_table2 WHERE 1=1
DELETE FROM sink_db2.dbo.test_table2 WHERE 1=1
DELETE FROM sink_db2.dbo.test_table WHERE 1=1
```
### Check Tables Count
```sql
SELECT  (
    SELECT COUNT(*) FROM   source_db2.dbo.test_table
) AS count1,( 
    SELECT COUNT(*) FROM   source_db2.dbo.test_table2
) AS count2,(
    SELECT COUNT(*) FROM   sink_db2.dbo.test_table
) AS count3,
    ( SELECT COUNT(*) FROM   sink_db2.dbo.test_table2
) AS count4
```
### Summary
| | Source Table | Sink Table |
|-|-|-|
| 1 Broker / batch_size 1 / 1 machine | 5min 59s | 7min 00s |
| 2 Brokers / batch_size 1 / 1 machine  | 6min 09s | 7min 04s  |
| 2 Brokers / batch_size 3000 / 1 machine  | 5min 56s | 6min 48s  |