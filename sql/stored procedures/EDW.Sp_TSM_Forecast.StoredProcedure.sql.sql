USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_TSM_Forecast]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_TSM_Forecast] AS

if object_id('EDW_RZ.TSM_Forecast') is not null begin
Drop EXTERNAL TABLE EDW_RZ.TSM_Forecast end;
CREATE EXTERNAL TABLE EDW_RZ.TSM_Forecast
(
Rep [varchar](225) NULL,
Rank [varchar](225) NULL,
Cust_ID [varchar](225) NULL,
Name [varchar](225) NULL,
[1H_17] [varchar](225) NULL,
[1H_18] [varchar](225) NULL,
[1H_change_percentage] [varchar](225) NULL,
[2H_17] [varchar](225) NULL,
[Percentage_Change_2H] [varchar](225) NULL,
[Forecasted_2H_18] [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/TSM_forecast.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.TSM_Forecast') is not null begin 
DROP TABLE EDW.TSM_Forecast end;
Create Table EDW.TSM_Forecast
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.TSM_Forecast
);
GO
