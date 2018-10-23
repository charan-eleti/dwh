USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Ace_list]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Ace_list] AS

if object_id('EDW_RZ.Ace_list') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Ace_list end;
CREATE EXTERNAL TABLE EDW_RZ.Ace_list
(
ACE_Member [varchar](225) NULL,
SAP_Customer [varchar](225) NULL,
Unauthorized_Member_Stores [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/Ace_list.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Ace_list') is not null begin 
DROP TABLE EDW.Ace_list end;
Create Table EDW.Ace_list
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.Ace_list
);
GO
