USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_sap_product]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_sap_product] AS

if object_id('EDW_TZ.SAP_PRODUCT_DIM') is not null begin 
Drop table EDW_TZ.SAP_PRODUCT_DIM  end;

CREATE TABLE EDW_TZ.SAP_PRODUCT_DIM  WITH (DISTRIBUTION = HASH (ProductID))

AS 

SELECT 
MARA.MATNR as ProductID,
MSAL.VKORG AS SalesOrganization,
MSAL.VTWEG AS DistributionChannel,
Mkt.MAKTX AS ProductDescription,
T0.BEZEK AS ProductFamily,
T1.BEZEK AS ProductCategory,
T2.BEZEK AS CategoryType,
T3.BEZEK AS ProductType,
T4.BEZEK AS MasterSKU,
T5.BEZEK AS Color,
T6.BEZEK AS Variation,
CASE WHEN UPPER(T2.BEZEK) like '%CORE%' then 'TRUE' ELSE 'FALSE' END AS ISCore,
xref.common_school AS CommonSchool,
mara.EAN11 AS UPC,
mara.BISMT AS OldMaterialNumber,
mara.GROES AS Dimensions,
mara.ERSDA AS CreateDate,
mara.LAEDA AS ChangeDate,
mara.LVORM AS FlagForDeletion,
mara.BRGEW AS GrossWeight,
mara.NTGEW AS NetWeight,
mara.GEWEI AS UnitOfWeight,
MSAL.DWERK AS DeliveryPlantID,
plnt.NAME1 AS PlantName,
SUBSTRING(PRDHA,1,2) AS  ProdFamilyID, 
SUBSTRING(PRDHA,3,2) AS  ProdCatID, 
SUBSTRING(PRDHA,5,2) AS  ProdCatTypeID, 
SUBSTRING(PRDHA,7,3) AS  ProdTypeID,
SUBSTRING(PRDHA,10,3) AS ProdMasSKUID, 
SUBSTRING(PRDHA,13,2) AS ProdColorID, 
SUBSTRING(PRDHA,15,2) AS ProdVariationID,
PRDHA as ProductHierarchyID,
MARA.DWLASTUPDATED

FROM  EDW_RZ.sap_mara_stg mara 
LEFT  JOIN EDW_RZ.sap_T25A0_stg T0 ON SUBSTRING(PRDHA,1,2)=WWPH1 AND T0.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A1_stg T1 ON SUBSTRING(PRDHA,3,2)=WWPH2 AND T1.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A2_stg T2 ON SUBSTRING(PRDHA,5,2)=WWPH3 AND T2.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A3_stg T3 ON SUBSTRING(PRDHA,7,3)=WWPH4 AND T3.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A4_stg T4 ON SUBSTRING(PRDHA,10,3)=WWPH5 AND T4.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A5_stg T5 ON SUBSTRING(PRDHA,13,2)=WWPH6 AND T5.MANDT=MARA.MANDT
LEFT  JOIN EDW_RZ.sap_T25A6_stg T6 ON SUBSTRING(PRDHA,15,2)=WWPH7 AND T6.MANDT=MARA.MANDT 
LEFT JOIN  EDW_RZ.sap_makt_stg mkt ON MARA.MATNR=mkt.MATNR AND mkt.MANDT=MARA.MANDT AND mkt.SPRAS='E'
left join EDW_RZ.collegiate_part_num_xref xref on '0000000'+xref.part_no=MARA.MATNR
left join EDW_RZ.sap_MVKE_stg MSAL on mara.matnr=msal.matnr and msal.mandt=mara.mandt --and msal.VKORG='1100' and msal.VTWEG='10'
left join EDW_RZ.sap_t001w_stg plnt on plnt.werks=MSAL.DWERK and plnt.mandt=MARA.mandt
WHERE MARA.MANDT='300';
GO
