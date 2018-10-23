USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_SF_Ownership]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_SF_Ownership] AS

if object_id('EDW_RZ.SF_Ownership') is not null begin
Drop EXTERNAL TABLE EDW_RZ.SF_Ownership end;
CREATE EXTERNAL TABLE EDW_RZ.SF_Ownership
(
SAP_Customer_Number [varchar](225) NULL,
Epicor_Customer_ID [varchar](225) NULL,
Account_Name [varchar](225) NULL,
Account_Owner [varchar](225) NULL,
Outside_Sales_Rep [varchar](225) NULL,
Inside_Sales_Rep [varchar](225) NULL,
Location_Status [varchar](225) NULL,
Created_By [varchar](225) NULL,
Created_Date [varchar](225) NULL,
Buying_Group [varchar](225) NULL,
Central_Biller [varchar](225) NULL,
Hardware_Affiliation [varchar](225) NULL,
Tier [varchar](225) NULL,
Industry_Category [varchar](225) NULL,
Industry_Sub_Category [varchar](225) NULL,
Account_ID [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_SF_Ownership.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.SF_Ownership') is not null begin 
DROP TABLE EDW.SF_Ownership end;
Create Table EDW.SF_Ownership
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.SF_Ownership
);
GO
