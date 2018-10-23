USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[sp_demand_forecast]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[sp_demand_forecast] AS

if object_id('EDW_SZ.demand_forecast') is not null  begin
Drop External Table EDW_SZ.demand_forecast end;

Create External Table EDW_SZ.demand_forecast
(
MonthNum int NOT Null,
Month3 VARCHAR(30) Null,
TotalNum int NOT Null,
RowNum int NOT Null,
ProductCategory VARCHAR(30) Null,
CategoryType VARCHAR(70) Null,
ProductType VARCHAR(70) Null,
MasterSKU VARCHAR(70) Null,
SKUColor VARCHAR(30) Null,
Variations VARCHAR(30) Null,
Hierarchy VARCHAR(30) Null,
Volume VARCHAR(30) Null,
Revenue VARCHAR(30) Null,
Price VARCHAR(30) Null,
SalesChannel VARCHAR(30) Null,
Version VARCHAR(30) Null
)
WITH (
DATA_SOURCE = [AzureStoragedl01-devhiveblob],
LOCATION = N'/hive/warehouse/edw_sz.db/demandforecast',
FILE_FORMAT = [AzureStorageFormatHiveText],
REJECT_TYPE = VALUE,
REJECT_VALUE = 0
)


if object_id('EDW.demandforecast') is not null begin 
Drop Table EDW.demandforecast end;
CREATE TABLE EDW.demandforecast WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(
select * from EDW_SZ.demand_forecast 
)
GO
