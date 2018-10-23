USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_RMA]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_RMA] AS

if object_id('EDW_RZ.RMA') is not null begin
Drop EXTERNAL TABLE EDW_RZ.RMA end;
CREATE EXTERNAL TABLE EDW_RZ.RMA
(
Date_Received [varchar](225) NULL,
LPID [varchar](225) NULL,
Returns_Type [varchar](225) NULL,
UPC [varchar](225) NULL,
Order_Qty [varchar](225) NULL,
Qty_Return [varchar](225) NULL,
Customer_Dealer_Name [varchar](225) NULL,
Tracking_No [varchar](225) NULL,
SKU [varchar](225) NULL,
SKU_Desc [varchar](225) NULL,
RMA_No [varchar](225) NULL,
PO_No [varchar](225) NULL,
Inventory_Status [varchar](225) NULL,
Return_Reason [varchar](225) NULL,
Return_Desc [varchar](225) NULL,
Hard_Manufacturer_Code [varchar](225) NULL,
Serial_Number [varchar](225) NULL,
Lid_Number [varchar](225) NULL,
Base_Number [varchar](225) NULL,
Hard_Year [varchar](225) NULL,
Hard_Month [varchar](225) NULL,
Stainless_Lot_Year [varchar](225) NULL,
Stainless_Lot_Week [varchar](225) NULL,
Stainless_Manufacturer_Code [varchar](225) NULL,
Stainless_Sub_Manufacturer_Code [varchar](225) NULL,
Potential_Counterfeit [varchar](225) NULL,
Soft_Lot_Year [varchar](225) NULL,
Soft_Lot_Week [varchar](225) NULL,
Soft_Manufacturer [varchar](225) NULL,
Soft_Zipper_Manufacturer [varchar](225) NULL,
Soft_Zipper_Lot_Number [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/Supply_Chain/YTD_RMA_Extract_Q3.xlsx',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;
GO
