USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[sp_sap_invoicefact]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[sp_sap_invoicefact] AS

if object_id('EDW_TZ.SAP_INVOICE_FCT') is not null  begin
Drop table EDW_TZ.SAP_INVOICE_FCT end;

CREATE TABLE EDW_TZ.SAP_INVOICE_FCT with
( DISTRIBUTION = HASH
(InvoiceID), CLUSTERED INDEX
(InvoiceID, InvoiceLineID, InvoiceDateKey))
AS 
(
SELECT inv.VBELN AS InvoiceID,
inv_line.POSNR AS InvoiceLineID,
inv.VKORG AS CompanyID,
inv_line.MATNR AS ProductID,
inv.KNKLI AS SalesRepID,
CAST(inv_line.VKBUR AS CHAR) AS SalesOffice,
CAST(inv_line.VKGRP AS CHAR) AS SalesGroup,
NULL AS TerritoryID,
inv.KUNRG AS CustomerID,
NULL AS WarehouseID,
NULL AS ShipID,
coalesce(case when ltrim(rtrim(inv_line.AUBEL)) = '0' then NULL else ltrim(rtrim(inv_line.AUBEL)) end,'-1') AS OrderID,
inv_sp.KUNNR AS SoldToParty,
(CASE WHEN inv_line.POSPA=inv_shp.POSNR THEN inv_shp.KUNNR
	ELSE coalesce(inv_shp_default.KUNNR,'-1')
END) AS ShipToParty,
(CASE WHEN inv_line.POSPA=inv_shp.POSNR THEN inv_shp.ADRNR
	ELSE coalesce(inv_shp_default.ADRNR,'-1')
END) AS ShipToPartyAddress,
CAST(CASE WHEN inv.FKDAT='00000000' THEN inv_line.PRSDT ELSE inv.FKDAT END AS DATE) as InvoiceDateKey,
NULL AS ApplyDateKey,
NULL AS ContractCode,
NULL AS OrderRelNum,
inv.REGIO AS InvoiceShipToState,
NULL AS InvoiceShipToZip,
NULL AS TaxCatID,
inv.WAERK AS currencycode,
CAST(CASE WHEN inv.FKDAT='00000000' THEN inv_line.PRSDT ELSE inv.FKDAT END AS DATE) as InvoiceDate,
inv.FKART AS InvoiceType,
NULL AS InvoiceHeld,
inv.FKART AS InvoiceSuffix,
NULL AS  InvoiceLineType,
NULL AS RefContractNum,
NULL AS  RefPackNum,
NULL AS  RefPackLine,
NULL AS  RefOrderLine,
NULL AS  RefOrderNum,
NULL AS  RefProdCode,
coalesce(ship.sold_to_party,'-1') AS  RefShipToNum,
coalesce(inv.KUNRG,'-1') AS RefCustNum,
NULL AS  InvoiceComment,
inv_line.SHKZG AS  RMANum,
NULL AS  RMALine,
NULL AS JournalCode,
NULL AS  JournalNum,
NULL AS RevChargeMethod,
NULL AS OverrideReverseCharge,
NULL AS RevChargeApplied,
NULL AS  TaxRegionCode,
NULL AS  Plant,
NULL AS  InvoiceLineRef,
NULL AS  InvoiceRef,
NULL AS POLine,
NULL AS  TaxExempt,
NULL AS  DeferredRev,
NULL AS DefRevStart,
NULL AS ChargeDefRev,
NULL AS BTCustNum,
NULL AS Commissionable,
NULL AS FinChargeCode,
NULL AS CorrectionDtl,
--  MEASURES
inv.NETWR AS  HeaderInvoiceAmt,
NULL AS  UnitPrice,
CASE WHEN inv.FKART='G2' THEN 0 ELSE inv_line.BONBA END AS ExtPrice,
CASE WHEN inv.FKART='G2' THEN (inv_line.KZWI3+inv_line.KZWI4)*-1 
WHEN inv.FKART='S1' THEN (inv_line.KZWI1+inv_line.KZWI4)*-1
WHEN inv.FKART='L2' THEN inv_line.NETWR
ELSE 
(inv_line.KZWI1+inv_line.KZWI4) END AS GrossExtPrice,
inv_line.NETWR,
inv_line.KZWI1,
inv_line.KZWI2,
inv_line.KZWI3,
inv_line.KZWI4,
inv_line.KZWI5,
inv_line.KZWI6,
CASE WHEN FKART='F2' THEN inv_line.FKIMG
WHEN FKART='ZB2C' THEN inv_line.FKIMG
else 0 END AS Quantity,

CASE WHEN FKART='G2'AND SHKZG ='X' THEN inv_line.NETWR
     WHEN FKART='S1' THEN inv_line.NETWR
	 ELSE 0 END AS ReturnGrossSales,
CASE WHEN FKART='G2'AND SHKZG ='X' then (inv_line.NETWR )*-1 
	WHEN FKART='S1' then (inv_line.NETWR )*-1
	else inv_line.NETWR END AS GrossSaleAmt,
COALESCE(inv_line.NETWR,0) AS NetSaleAmt,
COALESCE(inv_line.WAVWR,0) AS COGS,
COALESCE(inv_line.kzwi2,0) AS  Discount,
COALESCE(inv_line.KZWI4,0) AS TotalMiscChrg,
COALESCE(inv.MWSBK ,0) AS TaxAmt,
NULL AS  DiscountPercent,
NULL AS PricePerCode,
inv_line.FKIMG AS SellingOrderQty,
NULL AS AdvanceBillCredit,
NULL AS OrdBasedPrice,
NULL AS ListPrice,
NULL AS OurShipQTY,
NULL AS OurOrderQTY,
inv_line.WAVWR AS MtlUnitCost,
NULL AS LbrUnitCost,
NULL AS BurUnitCost,
NULL AS SubUnitCost,
NULL AS MtlBurUnitCost,
--END MEASURES
NULL AS  ChangedBy,
NULL AS  ChangeDate,
NULL AS  ChangeTime,
NULL AS  SysRevID,
NULL AS  SysRowID,
inv_line.dwlastupdated AS DWLastUpdated,
'SAP' AS SourceSystem

FROM  EDW_RZ.sap_vbrp_stg inv_line
RIGHT join EDW_RZ.sap_vbrk_stg inv on inv.VBELN=inv_line.VBELN
LEFT JOIN EDW_RZ.sap_mara_stg prod on prod.MATNR=inv_line.MATNR
LEFT JOIN (select vbeln ,kunag sold_to_party from EDW_RZ.sap_likp_stg group by vbeln,kunag) ship on ship.vbeln=inv_line.vgbel
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) inv_shp ON inv_line.VBELN=inv_shp.VBELN and inv_line.POSPA=inv_shp.POSNR
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) inv_shp_default ON inv_line.VBELN=inv_shp_default.VBELN and inv_shp_default.POSNR = '000000'
LEFT JOIN (select VBELN,POSNR,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('AG')) inv_sp ON inv_line.VBELN=inv_sp.VBELN and inv_sp.POSNR = '000000'
);
GO
