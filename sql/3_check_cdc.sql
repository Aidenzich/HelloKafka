SELECT name, is_cdc_enabled FROM sys.databases;

-- This script work when cdc is abailable
SELECT name, is_tracked_by_cdc FROM sys.databases; 