USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_SAP_ZINDELBOL]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_SAP_ZINDELBOL] AS

if object_id('EDW_TZ.SAP_ZINDELBOL') is not null begin 
DROP TABLE EDW_TZ.SAP_ZINDELBOL end;

CREATE TABLE EDW_TZ.SAP_ZINDELBOL WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select D.VBELN AS Delivery,
    D.POSNR AS Item,
    D.MATNR AS Material,
    D.ARKTX AS Description,
    D.LFIMG AS Delivery_quantity,
    D.GBSTA AS Overall_status,
    D.WERKS AS PLANT,
    D.LGORT AS Storage_Location,
    H.VSTEL AS Shipping_Point_Receiving_Pt,
    H.BOLNR AS Bill_of_lading,
    H.LFDAT AS Deliv_date,
    H.LIFNR AS Vendor,
    H.ERNAM AS Created_by,
    H.ERDAT AS Created_on,
    H.WADAT_IST AS Gds_Mvmnt_Date,
    V.NAME_ORG1 AS Name,
    L.EBELN AS Purchasing_document,
    L.EBELP AS PO_ITEM,
    L.ETENR AS Schedule_Line_Number,
    L.SLFDT AS Stat_Rel_Del_Date
  from EDW_SZ.sap_LIPS_stg as D
  inner join EDW_SZ.sap_LIKP_stg as H on H.VBELN = D.VBELN
  inner join EDW_RZ.sap_BUT000_stg as V on V.PARTNER = H.LIFNR
  inner join EDW_RZ.sap_EKES_stg as S on S.VBELN = D.VBELN and S.VBELP = D.POSNR
  inner join EDW_RZ.sap_EKET_stg as L on L.EBELN = S.EBELN and L.EBELP = S.EBELP
  );
GO
