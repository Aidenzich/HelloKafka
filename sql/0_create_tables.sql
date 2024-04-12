--create where
USE master;  
GO

IF DB_ID (N'sink_db2') IS NULL  
--create sink database 
CREATE DATABASE sink_db2
COLLATE SQL_Latin1_General_CP1_CI_AS  
WITH TRUSTWORTHY ON, DB_CHAINING ON;  
GO

IF DB_ID (N'source_db2') IS NULL
--create source database 
CREATE DATABASE source_db2  
COLLATE SQL_Latin1_General_CP1_CI_AS  
WITH TRUSTWORTHY ON, DB_CHAINING ON;  
GO

--create table
USE source_db2
GO

CREATE TABLE source_db2.dbo.test_table (
	id int IDENTITY(0,1) NOT NULL,
	[text] varchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT test_table_PK PRIMARY KEY (id)
);

CREATE TABLE source_db2.dbo.test_table2 (
	id int IDENTITY(0,1) NOT NULL,
	[text] varchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT test_table2_PK PRIMARY KEY (id)
);
