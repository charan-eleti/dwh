USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_RZ].[SP_Newsletter]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_RZ].[SP_Newsletter] AS

if object_id('EDW_RZ.Newsletter') is not null begin 
Drop table EDW_RZ.Newsletter end;

CREATE EXTERNAL TABLE [EDW_RZ].[Newsletter]
(
EmailAddress [varchar](150) NULL,
Status [varchar](150) NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/newsletter_data',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 1)


if object_id('EDW_SZ.Newsletter') is not null begin
Drop TABLE EDW_SZ.Newsletter end;

Create Table EDW_SZ.Newsletter WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select * from EDW_RZ.Newsletter
)
GO
