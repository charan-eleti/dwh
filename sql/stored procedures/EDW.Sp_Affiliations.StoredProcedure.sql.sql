USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Affiliations]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Affiliations] AS

if object_id('EDW_RZ.Affiliations') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Affiliations end;
CREATE EXTERNAL TABLE EDW_RZ.Affiliations
(
CustomerID [varchar](225) NULL,
Bill_To_Party [varchar](225) NULL,
Bill_To_Party_Name [varchar](225) NULL,
Hardware_Affiliation [varchar](225) NULL,
Buying_Group [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_Affiliation_2018.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Affiliations') is not null begin 
DROP TABLE EDW.Affiliations end;
Create Table EDW.Affiliations
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.Affiliations
);
GO
