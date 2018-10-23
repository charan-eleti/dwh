USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Zip]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Zip] AS

if object_id('EDW_RZ.Zip') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Zip end;
CREATE EXTERNAL TABLE EDW_RZ.Zip
(
ZIP [varchar](225) NULL,
[5_Digit] [varchar](225) NULL,
TSM [varchar](225) NULL,
SAP_Partner [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_ZIPlu.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Zip') is not null begin 
DROP TABLE EDW.Zip end;
Create Table EDW.Zip
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.Zip
);
GO
