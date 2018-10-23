USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_ProdH]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_ProdH] AS

if object_id('EDW_RZ.ProdH') is not null begin
Drop EXTERNAL TABLE EDW_RZ.ProdH end;
CREATE EXTERNAL TABLE [EDW_RZ].[ProdH]
(
	[UPC] [varchar](225) NULL,
	[Material_Code] [varchar](225) NULL,
	[DESCRIPTION] [varchar](225) NULL,
	[WHS] [varchar](225) NULL,
	[MAP] [varchar](225) NULL,
	[PRODUCT_CATEGORY] [varchar](225) NULL,
	[PRODUCT_TYPE] [varchar](225) NULL,
	[MASTER_SKU] [varchar](225) NULL,
	[SKU] [varchar](225) NULL,
	[COLOR] [varchar](225) NULL,
	[CUSTOMIZATION] [varchar](225) NULL,
	[SIZE_NON_COOLER] [varchar](225) NULL,
	[SLEEVE_APPAREL] [varchar](225) NULL,
	[GENDER_APPAREL] [varchar](225) NULL,
	[MSKU_C] [varchar](225) NULL,
	[PC] [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_ProdH.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.ProdH') is not null begin 
DROP TABLE EDW.ProdH end;
Create Table EDW.ProdH
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.ProdH
);
GO
