USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_US_State_LU]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_US_State_LU] AS

if object_id('EDW_RZ.US_State_LU') is not null begin
Drop EXTERNAL TABLE EDW_RZ.US_State_LU end;
CREATE EXTERNAL TABLE [EDW_RZ].[US_State_LU]
(
	[State] [varchar](225) NULL,
	[Abbreviation] [varchar](225) NULL,
	[Census_Region] [varchar](225) NULL,
	[Division] [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/US_State_LU.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.US_State_LU') is not null begin 
DROP TABLE EDW.US_State_LU end;
Create Table EDW.US_State_LU
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.US_State_LU
);
GO
