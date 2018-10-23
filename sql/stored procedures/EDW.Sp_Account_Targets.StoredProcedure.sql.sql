USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Account_Targets]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Account_Targets] AS

if object_id('EDW_RZ.Account_Targets') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Account_Targets end;
CREATE EXTERNAL TABLE EDW_RZ.Account_Targets
(
Account [varchar](225) NULL,
Name [varchar](225) NULL,
Month [varchar](225) NULL,
Quarter [varchar](225) NULL,
Target [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/Account_Targets.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Account_Targets') is not null begin 
DROP TABLE EDW.Account_Targets end;
Create Table EDW.Account_Targets
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select 
Account,
Name,
Month,
Quarter,
Cast(Replace(Replace(Target, ',', ''), '$', '') AS Int) As Target
 from EDW_RZ.Account_Targets
);
GO
