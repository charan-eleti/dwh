USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_Sales].[Sp_DIB_Sell_Thru]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_Sales].[Sp_DIB_Sell_Thru] AS

if object_id('EDW_RZ.DIB_Sell_Thru') is not null begin
Drop EXTERNAL TABLE EDW_RZ.DIB_Sell_Thru end;
CREATE EXTERNAL TABLE EDW_RZ.DIB_Sell_Thru
(
Row_Labels [varchar](225) NULL,
Month [varchar](225) NULL,
Year [varchar](225) NULL,
Date [varchar](225) NULL,
DIB_Value [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/DIB_Sell_Thru.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW_Sales.DIB_Sell_Thru') is not null begin 
DROP TABLE EDW_Sales.DIB_Sell_Thru end;
Create Table EDW_Sales.DIB_Sell_Thru
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select 
Ltrim(Rtrim(Row_Labels)) as Row_Labels,
Month,
Year,
Cast(Date AS Date) AS Date,
Cast(Replace(Replace(DIB_Value, ',', ''), '$', '') AS Int) As DIB_Value,
TSM_Email
 from EDW_RZ.DIB_Sell_Thru dst
 left join [EDW_RZ].[TSM_Emailids] te
 on dst.row_labels = te.tsm
);
GO
