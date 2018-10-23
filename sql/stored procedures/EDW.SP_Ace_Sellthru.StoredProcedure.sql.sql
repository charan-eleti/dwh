USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_Ace_Sellthru]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_Ace_Sellthru] AS

if object_id('EDW_RZ.Ace_Sellthru') is not null begin 
DROP EXTERNAL TABLE EDW_RZ.Ace_Sellthru end;

CREATE EXTERNAL TABLE [EDW_RZ].[Ace_Sellthru]
(
Site [varchar](100) NULL,
SiteDescription [varchar](100) NULL,
Customer_# [varchar](100) NULL,
Customer_Name [varchar](100) NULL,
Address_Line_1 [varchar](100) NULL,
Address_Line_2  [varchar](100) NULL,
City [varchar](100) NULL,
State [varchar](100) NULL,
ZipCode [varchar](100) NULL,
Business_Class [varchar](100) NULL,
Format [varchar](100) NULL,
Manufacturer_# [varchar](100) NULL,
Manufacturer_Class_Code [varchar](100) NULL,
Merchandise_Class [varchar](100) NULL,
Product_Group [varchar](100) NULL,
Article [varchar](100) NULL,
Article_Name [varchar](100) NULL,
Eaches_Item [varchar](100) NULL,
Eaches_Cost [varchar](100) NULL,
Year_Day [varchar](100) NULL
)
WITH (DATA_SOURCE = [AzureDataLakeStoreyetidpe3600],LOCATION = N'/hive/warehouse/edw_sales.db/ace_sell_through_text',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Ace_Sellthru') is not null begin 
DROP TABLE EDW.Ace_Sellthru end;

CREATE TABLE EDW.Ace_Sellthru WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select 
Site AS Site_Id,
SiteDescription AS Site_Description,
SUBSTRING(Customer_#, PATINDEX('%[^0 ]%', Customer_# + ' '), LEN(Customer_#)) as Member_Id,
Customer_Name,
Address_Line_1,
Address_Line_2,
City,
State,
ZipCode,
Business_Class,
Format,
Manufacturer_# AS Manufacturer_Id,
Manufacturer_Class_Code,
Merchandise_Class,
Product_Group,
Article,
Article_Name,
Cast(Eaches_Item as int) AS Eaches_Item,
CAst(ltrim(rtrim(Eaches_Cost)) as Decimal(10,2)) As Eaches_Cost,
Year_Day
from [EDW_RZ].[Ace_Sellthru]
);
GO
