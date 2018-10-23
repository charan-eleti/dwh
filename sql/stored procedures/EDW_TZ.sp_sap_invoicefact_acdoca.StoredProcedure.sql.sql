USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[sp_sap_invoicefact_acdoca]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[sp_sap_invoicefact_acdoca] AS

if object_id('EDW_TZ.SAP_INVOICE_ACDOCA_FCT') is not null  begin
Drop table EDW_TZ.SAP_INVOICE_ACDOCA_FCT end;

CREATE TABLE EDW_TZ.SAP_INVOICE_ACDOCA_FCT with
( DISTRIBUTION = HASH
(InvoiceID), CLUSTERED INDEX
(InvoiceID, InvoiceLineID, InvoiceDate))
AS 
(
SELECT inv_line.RLDNR AS Ledger
	,inv_line.BELNR AS DocumentNumber
	,inv_line.DOCLN AS DocumentItem
	,inv_line.AWREF AS InvoiceID
	,inv_line.AWITEM AS InvoiceLineID
	,inv_line.RBUKRS AS CompanyID
	,(CASE When inv_line.VKBUR_PA is Null then 
	(CASE WHEN ord.VKBUR IS NULL then knv.VKBUR ELSE ord.VKBUR END) ELSE inv_line.VKBUR_PA END) AS SalesOffice
	,(CASE When inv_line.KMVKGR_PA is Null then 
	(CASE WHEN ord.VKGRP IS NULL then knv.VKGRP ELSE ord.VKGRP END) ELSE inv_line.KMVKGR_PA END) AS SalesGroup
	,inv_line.KUNNR AS CustomerID
	,inv_line.KUNNR AS SoldToParty
	,inv_line.KUNWE AS ShipToParty
	,(CASE WHEN inv_line.KDPOS=inv_shp.POSNR THEN inv_shp.ADRNR
		ELSE coalesce(inv_shp_default.ADRNR,'-1')
	END) AS ShipToPartyAddress
	,inv_line.KUNRE AS BillToParty --ACDOCA billtoparty
--	,coalesce(inv_BP.KUNNR,'-1') AS BillTo 
	,(case when inv_line.KUNRE = inv_BP1.KUNNR THEN INV_BP1.ADRNR  
	when inv_line.KUNRE = inv_BP.KUNNR THEN INV_BP.ADRNR 
	ELSE INV_BP1.ADRNR 
	END) AS BillToPartyAddress
--	,coalesce(inv_BP.ADRNR,'-1') AS BillToPartyAddress
	,inv_line.WWY01_PA AS SalesRepID
	,inv_line.MATNR AS ProductID
	,ord.BSTNK AS PONumber
	,inv_line.KDAUF AS OrderID
	,inv_line.KDPOS AS OrderLineID
	,inv_line.BUDAT AS InvoiceDate
	,inv_line.BLDAT AS DocumentDate
	,inv_line.BLART AS InvoiceType
	,inv_line.RACCT AS GLAccount
	,GLA.acc_desc AS GLAccountDesc
	,inv_line.AWTYP AS TransType
		-- MEASURES --
	,(inv_line.MSL)*-1 AS Quantity
	,(inv_line.HSL)*-1 AS GrossExtPrice
		--END MEASURES--
	,'-1' AS  Discount
	,inv_line.TIMESTAMP AS ChangeDateTime
	,inv_line.dwlastupdated AS DWLastUpdated
	
FROM EDW_SZ.sap_acdoca_stg inv_line
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) inv_shp ON inv_line.KDAUF=inv_shp.VBELN and inv_line.KDPOS=inv_shp.POSNR
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) inv_shp_default ON inv_line.KDAUF=inv_shp_default.VBELN and inv_shp_default.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) inv_BP ON inv_line.KDAUF=inv_BP.VBELN and inv_BP.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) inv_BP1 ON inv_line.AWREF=inv_BP1.VBELN and inv_BP1.POSNR = '000000'
LEFT JOIN EDW_SZ.sap_vbak_stg ord on inv_line.KDAUF = ord.VBELN 
LEFT JOIN EDW_RZ.sap_knvv_stg knv on inv_line.KUNNR = knv.KUNNR
LEFT JOIN EDW_RZ.glaccounts_ke24 GLA ON inv_line.RACCT=GLA.account
WHERE inv_line.RLDNR='0L'
--AND inv_line.RACCT=GLA.account
);
GO
