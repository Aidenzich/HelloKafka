USE source_db2
GO

EXEC sys.sp_cdc_enable_db
GO

-- Enable cdc on source_db2.dbo.test_table
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'test_table',
@role_name = NULL,
@supports_net_changes = 1
GO

-- Enable cdc on source_db2.dbo.test_table2
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'test_table2',
@role_name = NULL,
@supports_net_changes = 1
GO