USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[sp_sap_ZVA05]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[sp_sap_ZVA05] AS

if object_id('EDW.sap_ZVA05_fct') is not null begin 
DROP TABLE EDW.sap_zva05_fct end;
CREATE TABLE EDW.sap_zva05_fct
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
select 
vbak.BSTNK AS PONumber,
vbak.VBELN AS Sales_document,
vbap.POSNR AS SD_Item,
--vbak.KUNNR AS Customer,
vbpa_sp.kunnr AS Sold_to_Party,
adrc.name1 AS Sold_to_Party_Name,
(CASE WHEN vbap.POSNR=vbpa_shp.POSNR THEN vbpa_shp.KUNNR
	ELSE coalesce(vbpa_shp_default.KUNNR,'-1')
	END) AS ShipToParty,
(CASE WHEN vbap.POSNR=vbpa_shp.POSNR THEN vbpa_shp.ADRNR
	ELSE coalesce(vbpa_shp_default.ADRNR,'-1')
	END) AS ShipToPartyAddress,
vbpa_bp.KUNNR as BillToParty,
coalesce(vbpa_bp.ADRNR,'-1') AS BillToPartyAddress,
(CASE WHEN vbak.VKGRP IS NULL then knvv.VKGRP ELSE vbak.VKGRP END) AS SalesGroup,
(CASE WHEN vbak.VKBUR IS NULL then knvv.VKBUR ELSE vbak.VKBUR END) AS SalesOffice,
vbak.VKORG AS Sales_Org,
(CASE WHEN vbak.AUART = tauum.AUART then tauum.AUART_SPR else vbak.AUART END) AS Order_Type,
vbap.PRODH AS Product_Hierarchy,
vbap.MATNR AS Material,
vbap.ARKTX AS Material_Description,
vbap.NETPR AS Unit_Price,
vbap.KWMENG AS Order_Qty,
vbap.NETWR AS Net_Value_item_level,
vbap.KBMENG AS Confirmd_Qty_Item,
vbep.BMENG AS Confirmed_Qty_Schl_Line,
--lips.VBELN AS Delivery_Number,
CAST(vbak.AUDAT AS DATE) AS Document_Date,
CAST((case when ltrim(rtrim(vbak.VDATU)) = '00000000' then NULL else vbak.VDATU END) AS DATE) AS Req_Delivery_Date,
CAST((case when ltrim(rtrim(vbep.WADAT)) = '00000000' then NULL else vbep.WADAT END) AS DATE) AS Goods_Issue_Date,
CAST((case when ltrim(rtrim(vbep.EDATU)) = '00000000' then NULL else vbep.EDATU END) AS DATE) AS Delivery_Date,
vbep.ZZEDATU_1ST AS Original_Promise_Date,
vbep.ZZBMENG_1ST AS Original_Promised_Qty,
vbak.CMGST AS Overall_Credit_Status,
vbak.LIFSK AS Delivery_Block,-- TVLST For Description
vbak.FAKSK AS Billing_Block,-- TVFST For Description
vbep.ETENR AS Schl_Line_Number,
vbap.ABGRU AS Reason_for_Rejection,-- TVAGT For Description
tvagt.BEZEI as ReasonForRejectionDesc,
changelog.udatetime AS Rejected_Date,
--vbak.LFSTK AS Delivery_Status,
--vbap.LFSTA AS Delivery_Status_Item,
vbak.LFGSK AS Overall_Delivery_status_Header,
vbap.LFGSA AS Overall_Delivery_status_Item,
vbak.GBSTK AS Overall_Order_Status_Header,
vbap.GBSTA AS Overall_Order_Status_Item,
CAST(vbak.ERDAT AS DATE) AS OrdHedCreatedDate,
vbak.ERNAM AS OrdHedCreatedBy,
CAST(vbap.ERDAT AS DATE) AS OrdLineCreatedDate,
vbap.ERNAM AS OrdLineCreatedBy,
--lips.WBSTA AS Overall_Goods_Movement_Status_Item,
--vbak.NETWR AS Net_Value,
--vbap.NETPR AS Unit_Price,
(Case when (vbak.GBSTK in ('A','B') or vbak.LFGSK in ('A','B')) and (vbap.GBSTA in ('A','B') or vbap.LFGSA in ('A','B')) Then 'Open' Else '' end) as Order_status,
(case WHEN vbak.LIFSK not in('','Z8') or vbak.FAKSK IS NOT NULL OR vbak.CMGST = 'B' THEN  'Block Issue' ELSE NULL end) AS Block_flag,
--Concat(vbep.VBELN,'_',vbep.POSNR,'_',vbep.ETENR) AS SL_Concat,
CAST((case when RIGHT(vbep.ETENR,1) = '1' THEN vbep.EDATU ELSE vbep1.EDATU END) AS DATE) AS Line_Req_Deliv_Date,
--(case when vbap.KBMENG <> '0.000' THEN 'TRUE' ELSE 'FALSE' END) AS Confirmed_line,
--(case when vbep.BMENG <> '0.000' THEN 'TRUE' ELSE 'FALSE' END) AS Confirmed_SL,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN 'Confirmed' ELSE 'Unconfirmed' END) AS ConfirmationStatus,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbap.KBMENG ELSE '0' END) AS Confirmed_Line_Quantity,
(CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbap.NETWR ELSE '0' END)Confirmed_Line_Value,
CAST((CASE WHEN vbap.KBMENG <> '0.000' AND vbep.BMENG <> '0.000' THEN vbep.WADAT END) AS DATE) AS Confirmed_GI_Date,
--Concat(vbap.VBELN,'_',vbap.POSNR) AS Order_Line_Concat,
--count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR) AS SL_count,
(CASE WHEN count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR) = CAST(VBEP.ETENR AS INT) THEN (CASE WHEN vbap.KBMENG <> '0' AND vbep.BMENG <> '0' THEN vbap.NETWR ELSE '0' END) ELSE vbap.NETWR END) AS Net_Value,
(CASE WHEN vbap.KBMENG = '0.000' AND vbep.BMENG = '0.000' THEN 
(CASE WHEN vbap.KBMENG = '0.000' AND vbep.BMENG = '0.000' AND (case WHEN vbak.LIFSK not in('','Z8') or vbak.FAKSK IS NOT NULL OR vbak.CMGST = 'B' THEN  'Block Issue' ELSE NULL end) = 'Block Issue' 
Then 'Unconfirmed-Block' ELSE 'Unconfirmed-No Block' END ) ELSE 'Confirmed' END) AS Unconfirmed_Reason,
(CASE When vbak.CMGST = 'B' Then 'Credit Hold' ELSE 'No Credit Issue' END) AS Overall_Credit_Status_Desc,
(CASE WHEN (count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = '1' THEN vbap.NETWR ELSE 
(CASE WHEN (count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(VBEP.ETENR AS INT) THEN vbap.NETWR ELSE '0' END) END) AS Net_Value_Actual,
(case WHEN Datediff(day, (case when RIGHT(vbep.ETENR,1) = '1' 
THEN CAST((case when ltrim(rtrim(vbep.EDATU)) = '00000000' then NULL else vbep.EDATU END) AS DATE)  
ELSE CAST((case when ltrim(rtrim(vbep1.EDATU)) = '00000000' then NULL else vbep1.EDATU END) AS DATE) END),CONVERT (date, GETDATE())) > '60' Then 'FALSE' ELSE 'TRUE' END) AS days_stale,
(CASE WHEN (count(vbep.ETENR) OVER(Partition By vbep.VBELN,vbep.POSNR)) = CAST(VBEP.ETENR AS INT) THEN 'Active SL' ELSE 'Inactive' END) AS SL_Status,
vbap.[DWLASTUPDATED]
from EDW_SZ.sap_vbap_stg vbap
Left Join EDW_SZ.sap_vbak_stg vbak ON vbap.VBELN =vbak.vbeln
--Left Join EDW_SZ.sap_vbpa_stg vbpa ON vbap.VBELN = vbpa.VBELN and vbpa.PARVW = 'AG'
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('AG')) vbpa_sp ON vbap.VBELN=vbpa_sp.VBELN and vbpa_sp.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) vbpa_bp ON vbap.VBELN=vbpa_bp.VBELN and vbpa_bp.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp ON vbap.VBELN=vbpa_shp.VBELN and vbap.POSNR=vbpa_shp.POSNR
LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) vbpa_shp_default ON vbap.VBELN=vbpa_shp_default.VBELN and vbpa_shp_default.POSNR = '000000'
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
