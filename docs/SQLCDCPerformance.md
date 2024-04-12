# Change Data Capture Performence Considerations

## The aspects that influence performance impact of enabling CDC:

| Aspect | Details |
|-|-|
| The number of tracked CDC-enabled tables | ...|
| Frequency of changes in the tracked tables | ...|
| Space available in the source database | Notice that CDC artifacts (e.g. CT tables, cdc_jobs etc.) are stored in the same database |
| Whether the database is single or **pooled**.  | In elastic pools, in addition to considering the number of tables that have CDC enabled, pay attention to the number of databases those tables belong to |
|| Databases in a pool share resources among them (such as disk space), so enabling CDC on multiple databases runs the risk of reaching the max size of the elastic pool disk size |
||  Monitor resources such as CPU, memory and log throughput |


## How to regularly clean up cdc data?
Use [sys.sp_cdc_change_job][2]
  - Default: 52494800 (100 years)


## Reference
| Article Title | Link |
|-|-|
| What is change data capture (CDC)? | [link][1]|
| sys.sp_cdc_change_job (Transact-SQL) | [link][2] |
| Which are the downsides of not deleting the CDC records in change tables? | [link][3]|

[1]: https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver16
[2]: https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sys-sp-cdc-change-job-transact-sql?view=sql-server-ver16
[3]: https://dba.stackexchange.com/questions/245865/which-are-the-downsides-of-not-deleting-the-cdc-records-in-change-tables