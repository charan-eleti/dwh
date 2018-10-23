USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[sp_sap_Orders]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[sp_sap_Orders] AS

if object_id('EDW_TZ.sap_orders') is not null begin 
DROP TABLE EDW_TZ.sap_orders end;
CREATE TABLE EDW_TZ.sap_orders
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select 
vbak.BSTNK AS PO_Number,
vbak.VBELN AS Order_Id,
vbap.POSNR AS Order_Line_Id,
vbep.ETENR AS Schl_Line_Number,
--vbak.KUNNR AS Customer,
vbpa_sp.kunnr AS Customer_Id,
adrc.name1 AS Customer,
--(CASE WHEN vbap.POSNR=vbpa_shp.POSNR THEN vbpa_shp.KUNNR
--	ELSE coalesce(vbpa_shp_default.KUNNR,'-1')
--	END) AS Ship_To_Id,
--(CASE WHEN vbap.POSNR=vbpa_shp.POSNR THEN vbpa_shp.ADRNR
--	ELSE coalesce(vbpa_shp_default.ADRNR,'-1')
--	END) AS Ship_To_Address,
--vbpa_bp.KUNNR as Bill_To_Id,
--coalesce(vbpa_bp.ADRNR,'-1') AS Bill_To_Address,
(CASE WHEN vbak.VKGRP IS NULL then knvv.VKGRP ELSE vbak.VKGRP END) AS Sales_Group,
(CASE WHEN vbak.VKBUR IS NULL then knvv.VKBUR ELSE vbak.VKBUR END) AS Sales_Office,
vbak.VKORG AS Sales_Org,
vbap.LGORT AS Storage_Location,
(CASE WHEN vbak.AUART = tauum.AUART then tauum.AUART_SPR else vbak.AUART END) AS Order_Type,
vbap.PRODH AS Product_Hierarchy,
vbap.MATNR AS Product_Id,
vbap.ARKTX AS Product,
vbap.NETPR AS Net_Price,
vbap.KWMENG AS Quantity,
vbap.NETWR AS Net_Value,
vbap.KBMENG AS Confirmd_Qty,
vbep.BMENG AS Schl_Line_Qty,
--lips.VBELN AS Delivery_Number,
CAST(vbak.AUDAT AS DATE) AS Order_Date,
CAST((case when ltrim(rtrim(vbak.VDATU)) = '00000000' then NULL else vbak.VDATU END) AS DATE) AS Requested_Date,
CAST((case when ltrim(rtrim(vbep.WADAT)) = '00000000' then NULL else vbep.WADAT END) AS DATE) AS Goods_Issue_Date,
CAST((case when ltrim(rtrim(vbep.EDATU)) = '00000000' then NULL else vbep.EDATU END) AS DATE) AS Delivery_Date,
vbep.ZZEDATU_1ST AS Original_Promise_Date,
vbep.ZZBMENG_1ST AS Original_Promised_Qty,
vbak.CMGST AS Credit_Status,
vbak.LIFSK AS Delivery_Block,-- TVLST For Description
vbak.FAKSK AS Billing_Block,-- TVFST For Description
vbap.ABGRU AS Rejection_Reason,-- TVAGT For Description
tvagt.BEZEI as Rejection_Desc,
changelog.udatetime AS Rejected_Date,
--vbak.LFSTK AS Delivery_Status,
--vbap.LFSTA AS Delivery_Status_Item,
vbak.LFGSK AS Delivery_status,
vbap.LFGSA AS Delivery_Line_Status,
vbak.GBSTK AS Order_Status,
vbap.GBSTA AS Order_Line_Status,
CAST(vbak.ERDAT AS DATE) AS Order_Created_Date,
vbak.ERNAM AS Order_Created_By,
CAST(vbap.ERDAT AS DATE) AS Order_Line_Created_Date,
vbap.ERNAM AS Order_Line_Created_By,
--lips.WBSTA AS Overall_Goods_Movement_Status_Item,
--vbak.NETWR AS Net_Value,
--vbap.NETPR AS Unit_Price,
(Case when (vbak.GBSTK in ('A','B') or vbak.LFGSK in ('A','B')) and (vbap.GBSTA in ('A','B') or vbap.LFGSA in ('A','B')) Then 'True' Else 'False' end) as Open_Order,
(case WHEN vbak.LIFSK not in('','Z8') or vbak.FAKSK IS NOT NULL OR vbak.CMGST = 'B' THEN  'True' ELSE 'False' end) AS Blocked,
CAST((case when RIGHT(vbep.ETENR,1) = '1' THEN vbep.EDATU ELSE vbep1.EDATU END) AS DATE) AS Req_Delivery_Date,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN 'True' ELSE 'False' END) AS Confirmed_Order,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbap.KBMENG ELSE '0' END) AS Confirmed_Line_Quantity,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbap.NETWR ELSE '0' END) AS Confirmed_Line_Value,
CAST((CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbep.WADAT END) AS DATE) AS Confirmed_GI_Date,
(CASE WHEN vbap.KBMENG = '0.000' AND vbep.BMENG = '0.000' THEN 
(CASE WHEN vbap.KBMENG = '0.000' AND vbep.BMENG = '0.000' AND (case WHEN vbak.LIFSK not in('','Z8') or vbak.FAKSK IS NOT NULL OR vbak.CMGST = 'B' THEN  'Block Issue' ELSE NULL end) = 'Block Issue' 
Then 'Unconfirmed-Block' ELSE 'Unconfirmed-No Block' END ) ELSE 'Confirmed' END) AS Unconfirmed_Reason,
(CASE When vbak.CMGST = 'B' Then 'Credit Hold' ELSE 'No Credit Issue' END) AS Credit_Status_Desc,
--(CASE WHEN (count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(VBEP.ETENR AS INT) THEN vbap.NETWR ELSE '0' END) AS Net_Value_Actual,
(CASE WHEN (MAX(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(vbep.ETENR AS INT) THEN vbap.NETWR ELSE (case when vbep.ETENR is null then vbap.NETWR Else '0' END) END) AS Net_Value_Actual,
(case WHEN Datediff(day, (case when RIGHT(vbep.ETENR,1) = '1' 
THEN CAST((case when ltrim(rtrim(vbep.EDATU)) = '00000000' then NULL else vbep.EDATU END) AS DATE)  
ELSE CAST((case when ltrim(rtrim(vbep1.EDATU)) = '00000000' then NULL else vbep1.EDATU END) AS DATE) END),CONVERT (date, GETDATE())) > '60' Then 'FALSE' ELSE 'TRUE' END) AS days_stale,
(CASE WHEN (MAX(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(vbep.ETENR AS INT) THEN 'True' ELSE (case when vbep.ETENR is null then 'True' Else 'False' END) END) AS Active_SL,
--(CASE WHEN (count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(VBEP.ETENR AS INT) THEN 'True' ELSE 'False' END) AS Active_SL,
vbap.DWLASTUPDATED AS Last_Updated_Date
from EDW_SZ.sap_vbap_stg vbap
Left Join EDW_SZ.sap_vbak_stg vbak ON vbap.VBELN =vbak.vbeln
--Left Join EDW_SZ.sap_vbpa_stg vbpa ON vbap.VBELN = vbpa.VBELN and vbpa.PARVW = 'AG'
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('AG')) vbpa_sp ON vbap.VBELN=vbpa_sp.VBELN and vbpa_sp.POSNR = '000000'
--LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) vbpa_bp ON vbap.VBELN=vbpa_bp.VBELN and vbpa_bp.POSNR = '000000'
--LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp ON vbap.VBELN=vbpa_shp.VBELN and vbap.POSNR=vbpa_shp.POSNR
--LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp_default ON vbap.VBELN=vbpa_shp_default.VBELN and vbpa_shp_default.POSNR = '000000'
Left join EDW_RZ.sap_adrc_stg adrc ON vbpa_sp.ADRNR = adrc.ADDRNUMBER
Left Join EDW_RZ.sap_vbep_stg vbep ON vbap.VBELN =vbep.vbeln and vbap.POSNR = vbep.POSNR
Left Join EDW_RZ.sap_vbep_stg vbep1 ON vbep.VBELN =vbep1.vbeln and vbep.POSNR = vbep1.POSNR and vbep1.ETENR = '0001'
Left join EDW_RZ.sap_tauum_stg tauum ON vbak.AUART = tauum.AUART and tauum.SPRAS = 'E'
LEFT JOIN EDW_RZ.sap_tvagt_stg tvagt ON tvagt.ABGRU=vbap.ABGRU
LEFT JOIN EDW_RZ.sap_knvv_stg knvv ON vbak.KUNNR = knvv.KUNNR
--LEFT JOIN EDW_SZ.sap_LIPS_stg lips ON vbap.VBELN = lips.VGBEL and vbap.POSNR = lips.VGPOS
left join (select *,ROW_NUMBER() OVER (partition BY TABKEY,fname ORDER BY UDATE desc,UTIME DESC) RANK from EDW_RZ.sap_changelog_stg where fname = 'ABGRU') changelog
on vbap.TABKEY = changelog.TABKEY and changelog.RANK = '1'
);
GO
