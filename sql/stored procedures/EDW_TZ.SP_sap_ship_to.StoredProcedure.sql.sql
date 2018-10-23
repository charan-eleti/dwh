USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_sap_ship_to]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_sap_ship_to] AS

if object_id('EDW_TZ.SAP_SHIPTO_DIM') is not null begin 
Drop table EDW_TZ.SAP_SHIPTO_DIM end;

create table EDW_TZ.SAP_SHIPTO_DIM 
WITH 
(DISTRIBUTION = HASH (ShiptoID), 
CLUSTERED INDEX (ShiptoID, ADDRESSNUMBER)
) AS 
(
SELECT DISTINCT K.* FROM  
(select 
shp.ADRNR AS ADDRESSNUMBER,
coalesce(case when ltrim(rtrim(shp.KUNNR)) = '' then NULL else shp.KUNNR end,'-1') AS ShipToID,
coalesce(case when ltrim(rtrim(adr.MC_NAME1)) = '' then NULL else ltrim(rtrim(adr.MC_NAME1)) end,'Unknown') AS Name,
coalesce(case when ltrim(rtrim(sp.KUNNR)) = '' then NULL else sp.KUNNR end,'-1') AS CustomerID,
coalesce(case when ltrim(rtrim(kna.NAME1)) = '' then NULL else kna.NAME1 end,'Unknown') AS Customer,
knv.VKORG AS SalesOrganization,
knv.VTWEG AS DistributionChannel,
knv.SPART AS Division,
coalesce(case when ltrim(rtrim(knv.VKGRP)) = '' then NULL else knv.VKGRP end,'Other') AS SalesGroup,
coalesce(case when ltrim(rtrim(knv.VKBUR)) = '' then NULL else knv.VKBUR end,'Other') AS SalesOffice,
coalesce(case when ltrim(rtrim(tv.VKGRP)) = '' then NULL else tv.BEZEI end,'Other') AS SalesGroupDescription,
coalesce(case when ltrim(rtrim(tk.VKBUR)) = '' then NULL else tk.BEZEI end,'Other') AS SalesOfficeDescription,
bt.bu_sort2 AS EpicorRefCustID,
cu.customerid AS EpicorCustomerID,
bt.partner AS Partner,
shp.PARVW AS PARTNER_ROLE,
adr.MC_STREET AS STREET,
adr.MC_CITY1 AS CITY,
adr.REGION AS STATE,
adr.POST_CODE1 AS ZIPCODE,
adr.COUNTRY AS COUNTRY,
adr.TEL_NUMBER AS TELEPHONE,
adr.FAX_NUMBER AS FAX
from (select MANDT,VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE','RE')) shp
LEFT JOIN (select MANDT,VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('AG')) sp ON shp.VBELN=sp.VBELN
left join EDW_RZ.SAP_ADRC_STG adr ON shp.ADRNR=adr.ADDRNUMBER
left join EDW_RZ.sap_kna1_stg kna ON sp.KUNNR=kna.KUNNR AND sp.MANDT=kna.MANDT
left join EDW_RZ.sap_knvv_stg knv on kna.KUNNR = knv.KUNNR  and kna.MANDT=knv.MANDT
left join EDW_RZ.sap_tvgrt_stg tv  on tv.VKGRP = knv.VKGRP  and tv.mandt=knv.mandt
left join EDW_RZ.sap_but000_stg bt on bt.PARTNER=kna.KUNNR AND kna.MANDT=bt.CLIENT
LEFT JOIN yetidm.customer cu on bt.bu_sort2=cu.refcustid
left join EDW_RZ.sap_tvkbt_stg tk  on tk.VKBUR = knv.VKBUR
)K 
)
GO
