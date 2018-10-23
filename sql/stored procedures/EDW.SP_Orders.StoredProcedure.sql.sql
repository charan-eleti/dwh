USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_Orders]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_Orders] AS

if object_id('EDW.Orders') is not null begin 
DROP TABLE EDW.Orders end;

CREATE TABLE EDW.Orders WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
Select 
orders.PO_Number,
orders.Order_Id,
orders.Order_Line_Id,
orders.Schl_Line_Number,
SUBSTRING(orders.Customer_Id, PATINDEX('%[^0 ]%', orders.Customer_Id + ' '), LEN(orders.Customer_Id)) AS Customer_Id,
orders.Customer,
(CASE WHEN orders.Order_Line_Id=vbpa_shp.POSNR THEN vbpa_shp.KUNNR
	ELSE coalesce(vbpa_shp_default.KUNNR,'-1')
	END) AS Ship_To_Id,
(CASE WHEN orders.Order_Line_Id=vbpa_shp.POSNR THEN vbpa_shp.ADRNR
	ELSE coalesce(vbpa_shp_default.ADRNR,'-1')
	END) AS Ship_To_Address,
vbpa_bp.KUNNR as Bill_To_Id,
coalesce(vbpa_bp.ADRNR,'-1') AS Bill_To_Address,
orders.Sales_Group,
TVGRT.BEZEI As Sales_Group_Description,
orders.Sales_Office,
TVKBT.BEZEI AS Sales_Office_Description,
orders.Sales_Org,
TVKOT.VTEXT AS Sales_Org_Description,
orders.Storage_Location,
orders.Order_Type,
XREFORDERTYPE.BEZEI AS Order_Type_Description,
ORDERGROUP.AUART_GROUP as OrderGroup,
orders.Product_Hierarchy,
SUBSTRING(orders.Product_Id, PATINDEX('%[^0 ]%', orders.Product_Id + ' '), LEN(orders.Product_Id)) as Product_Id,
orders.Product,
orders.Net_Price,
orders.Quantity,
orders.Net_Value,
orders.Confirmd_Qty,
orders.Schl_Line_Qty,
orders.Order_Date,
orders.Requested_Date,
orders.Goods_Issue_Date,
orders.Delivery_Date,
Original_Promise_Date,
Original_Promised_Qty,
orders.Credit_Status,
orders.Delivery_Block,
Coalesce(XREFDELIVERYBLOCK.VTEXT,'No Block') AS Delivery_Block_Description,
orders.Billing_Block,
Coalesce(XREFBILLINGBLOCK.VTEXT,'No Block') AS Billing_Block_Description,
orders.Rejection_Reason,
Coalesce(orders.Rejection_Desc,'Not Rejected') AS Rejection_Description,
CAST(orders.Rejected_Date as DATE) AS Rejected_Date,
orders.Delivery_status,
orders.Delivery_Line_Status,
orders.open_Order,
orders.Order_Status,
orders.Order_Line_Status,
orders.Order_Created_Date,
orders.Order_Created_By,
orders.Order_Line_Created_Date,
orders.Order_Line_Created_By,
orders.Blocked,
orders.Req_Delivery_Date,
orders.Confirmed_Order,
orders.Confirmed_Line_Quantity,
orders.Confirmed_Line_Value,
orders.Confirmed_GI_Date,
orders.Unconfirmed_Reason,
orders.Credit_Status_Desc,
orders.Net_Value_Actual,
orders.days_stale,
orders.Active_SL,
CAST(orders.Last_Updated_Date as DATETIME) AS Last_Updated_Date
from 
EDW_TZ.sap_orders orders
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) vbpa_bp ON orders.Order_Id=vbpa_bp.VBELN and vbpa_bp.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp ON orders.Order_Id=vbpa_shp.VBELN and orders.Order_Line_Id=vbpa_shp.POSNR
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp_default ON orders.Order_Id=vbpa_shp_default.VBELN and vbpa_shp_default.POSNR = '000000'
Left JOIN EDW_RZ.sap_tvkbt_stg TVKBT ON orders.Sales_Office = TVKBT.VKBUR and TVKBT.SPRAS = 'E'
Left JOIN EDW_RZ.sap_tvgrt_stg TVGRT ON orders.Sales_Group = TVGRT.VKGRP and TVGRT.SPRAS = 'E'
Left JOIN EDW_RZ.sap_tvkot_stg TVKOT ON orders.Sales_Org = TVKOT.VKORG and TVKOT.SPRAS = 'E'
Left JOIN EDW_RZ.sap_xref_Order_DocType XREFORDERTYPE ON orders.Order_Type = XREFORDERTYPE.AUART and XREFORDERTYPE.SPRAS = 'E'
Left JOIN EDW_RZ.sap_xref_Delivery_Blocks XREFDELIVERYBLOCK ON orders.Delivery_Block = XREFDELIVERYBLOCK.LIFSP and XREFDELIVERYBLOCK.SPRAS = 'E'
Left JOIN EDW_RZ.sap_xref_Billing_Blocks XREFBILLINGBLOCK ON orders.Billing_Block = XREFBILLINGBLOCK.FAKSP and XREFBILLINGBLOCK.SPRAS = 'E'
LEFT JOIN EDW_RZ.sap_order_group ORDERGROUP ON orders.Order_Type = ORDERGROUP.AUART 
);
GO
