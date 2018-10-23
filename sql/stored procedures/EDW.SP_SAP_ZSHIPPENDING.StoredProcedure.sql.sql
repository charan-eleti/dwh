USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_SAP_ZSHIPPENDING]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_SAP_ZSHIPPENDING] AS

if object_id('EDW.sap_ZSHIPPENDING') is not null begin 
DROP TABLE EDW.sap_ZSHIPPENDING end;

CREATE TABLE EDW.sap_ZSHIPPENDING WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select LIKP.VBELN AS Delivery
,      LIPS.POSNR AS Delivery_Item
,      CAST(LIKP.ERDAT AS Date) AS CreatedDate
,      LIKP.ERZET AS CreatedTime
,      LIKP.LFART AS Delivery_Type
,      SUBSTRING(LIKP.KUNAG, PATINDEX('%[^0 ]%', LIKP.KUNAG + ' '), LEN(LIKP.KUNAG)) AS Sold_To_Party
,	   (CASE WHEN LIKP.KUNAG = VBPA.KUNNR THEN ADRC.NAME1 END) AS Sold_To_NAME
,      LIKP.KUNNR AS Ship_To_Party
,	   VBPA1.ADRNR As Ship_To_Party_Address
,	   (CASE WHEN LIKP.KUNNR = VBPA1.KUNNR THEN ADRC1.NAME1 END) AS SHIP_To_NAME
,      cast(CASE when LIKP.WADAT = '00000000' then Null else LIKP.WADAT end as Date) AS Planned_goods_movement_date
,      cast(CASE when LIKP.WADAT_IST = '00000000' then Null else LIKP.WADAT_IST end as Date) AS Actual_Goods_Movement_Date
,      LIKP.WBSTK AS Overall_Goods_Movement_Status
,	   LIPS.WBSTA AS Overall_Goods_Movement_Status_Item
,      SUBSTRING(LIPS.MATNR, PATINDEX('%[^0 ]%', LIPS.MATNR + ' '), LEN(LIPS.MATNR)) AS Material_Number
,      MAKT.MAKTX AS Material_Description
,      LIPS.PRODH AS Product_Hierarchy
,      LIPS.LFIMG AS Actual_quantity_delivered_in_sales_units
,      LIPS.MEINS AS Base_Unit_of_Measure
,      LIPS.WERKS AS Plant
,      LIPS.LGORT AS Storage_Location
,      LIPS.VKBUR AS Sales_Office
,      TVKBT.BEZEI AS Sales_Office_Description
,      LIPS.VKGRP AS Sales_Group
,      TVGRT.BEZEI AS Sales_Group_Description
,	   VBAK.VKORG AS Sales_Org
,      LIPS.VTWEG AS Distribution_Channel
,      LIPS.VGTYP AS Document_category_of_preceding_SD_document
,      LIPS.VGBEL AS Document_Number_of_the_Reference_Document
,      LIPS.VGPOS AS Item_Number_of_the_Reference_Item
,      VBPA.VBELN AS SD_Document_Number
,      VBPA.ADRNR AS Address
,      STXH.TDNAME AS NAME
,      VBAP.VBELN AS Sales_Document
,      VBAP.POSNR AS Sales_Document_Item
,      VBAP.NETWR AS Net_value_item
,      VBAP.WAERK AS SD_Document_Currency
,      CAST(VBAK.ERDAT AS Date) AS Created_Date
,      CAST(VBAK.VDATU AS Date) AS Req_delivery_date
,      VBAK.BSTNK AS Customer_PO_Num
,	   cast(CASE when VBAK.ZZDNSB = '00000000' then Null else VBAK.ZZDNSB end as Date) AS Do_not_ship_before
,	   cast(CASE when VBAK.ZZDNSA = '00000000' then Null else VBAK.ZZDNSA end as Date) AS Do_not_ship_after
,      VBAK.ZZCNBY AS Cancel_by
       from EDW_SZ.sap_LIKP_stg LIKP 
	   inner join EDW_SZ.sap_LIPS_stg LIPS on LIKP.VBELN = LIPS.VBELN
       LEFT JOIN EDW_SZ.sap_VBPA_stg VBPA ON VBPA.VBELN = LIKP.VBELN and VBPA.POSNR = '000000' and VBPA.PARVW = 'AG'
	   LEFT JOIN EDW_SZ.sap_VBPA_stg VBPA1 ON VBPA1.VBELN = LIKP.VBELN and VBPA1.POSNR = '000000' and VBPA1.PARVW ='WE'
	   LEFT JOIN EDW_RZ.sap_ADRC_stg ADRC on VBPA.ADRNR = ADRC.ADDRNUMBER
	   LEFT JOIN EDW_RZ.sap_ADRC_stg ADRC1 on VBPA1.ADRNR = ADRC1.ADDRNUMBER
       LEFT JOIN EDW_RZ.sap_MAKT_stg MAKT ON MAKT.MATNR = LIPS.MATNR AND MAKT.SPRAS = 'E' AND MAKT.MANDT = '300'
       LEFT JOIN EDW_RZ.sap_TVKBT_stg TVKBT ON TVKBT.VKBUR = LIPS.VKBUR AND TVKBT.SPRAS = 'E' AND TVKBT.MANDT = '300'
       LEFT JOIN EDW_RZ.sap_TVGRT_stg TVGRT ON TVGRT.VKGRP = LIPS.VKGRP AND TVGRT.SPRAS = 'E' AND TVGRT.MANDT = '300'
       LEFT JOIN EDW_RZ.sap_STXH_stg STXH ON LIKP.VBELN = STXH.TDNAME and TDOBJECT = 'VBBK' AND TDID = 'Z001' AND TDSPRAS = 'E' AND STXH.MANDT = '300'
       LEFT JOIN EDW_SZ.sap_VBAP_stg VBAP ON VBAP.VBELN = LIPS.VGBEL and VBAP.POSNR = LIPS.VGPOS
       LEFT JOIN EDW_SZ.sap_VBAK_stg VBAK ON VBAK.VBELN = VBAP.VBELN
)       
GO
