USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_SAP_ZINDELBOL]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_SAP_ZINDELBOL] AS

if object_id('EDW.SAP_ZINDELBOL') is not null begin 
DROP TABLE EDW.SAP_ZINDELBOL end;

CREATE TABLE EDW.SAP_ZINDELBOL WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
select D.VBELN AS Delivery,
    D.POSNR AS Item,
    D.MATNR AS Productid,
    D.ARKTX AS Description,
    D.LFIMG AS Delivery_quantity,
    D.GBSTA AS Overall_status,
    D.WERKS AS PLANT,
    D.LGORT AS Storage_Location,
    H.VSTEL AS Shipping_Point_Receiving_Pt,
    H.BOLNR AS Bill_of_lading,
    Cast(CASE when H.LFDAT = '00000000' then Null else H.LFDAT end AS DATE) AS Deliv_date,
    H.LIFNR AS Vendor,
    H.ERNAM AS Created_by,
    Cast(CASE when H.ERDAT = '00000000' then Null else H.ERDAT end AS DATE) AS Created_on,
    Cast(CASE when H.WADAT_IST = '00000000' then Null else H.WADAT_IST end AS DATE) AS Gds_Mvmnt_Date,
    V.NAME_ORG1 AS Name,
    L.EBELN AS Purchasing_document,
    L.EBELP AS PO_ITEM,
    L.ETENR AS Schedule_Line_Number,
    Cast(CASE when L.SLFDT = '00000000' then Null else L.SLFDT end AS DATE) AS Stat_Rel_Del_Date
  from EDW_SZ.sap_LIPS_stg as D
  inner join EDW_SZ.sap_LIKP_stg as H on H.VBELN = D.VBELN
  inner join EDW_RZ.sap_BUT000_stg as V on V.PARTNER = H.LIFNR
  inner join EDW_RZ.sap_EKES_stg as S on S.VBELN = D.VBELN and S.VBELP = D.POSNR
  inner join EDW_RZ.sap_EKET_stg as L on L.EBELN = S.EBELN and L.EBELP = S.EBELP
  );
GO
