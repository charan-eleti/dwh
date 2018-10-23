USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_sap_customer]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_sap_customer] AS

/* =============================================
   ObjectName/type: Table
   Description: 
               
   Parameters: 
   Author: Charan Eleti
   Create date: 07/01/2018
   
   =============================================
   Change History
   ============================================= 
  
Date 	Author	Description
10/15/2018	Charan Eleti	Added Payment Terms columns to the Table.
		

   ============================================= */

if object_id('EDW_TZ.SAP_CUSTOMER_DIM') is not null begin 
Drop table EDW_TZ.SAP_CUSTOMER_DIM end;

create table EDW_TZ.SAP_CUSTOMER_DIM WITH (DISTRIBUTION = ROUND_ROBIN ) AS (

SELECT DISTINCT
coalesce(case when ltrim(rtrim(KNA.KUNNR)) = '' then NULL else KNA.KUNNR end,'-1') AS CustomerID,
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
knv.ZTERM As PaymentTerms,
bt.XBLCK as BlockedCustomer,
bt.CRDAT AS CreationDate,
kna.STRAS AS Address1,
kna.ORT01 AS City,
kna.REGIO AS State,
kna.PSTLZ AS Zipcode,
kna.LAND1 AS Country,
kna.TELF1 AS Telephone,
kna.TELFX AS Fax,
bt.partner AS Partner,
--kp.PARVW AS Partner_type,
knv.bzirk AS District,
lkp.z_region Zregion
FROM  EDW_RZ.sap_kna1_stg kna
left join EDW_RZ.sap_knvv_stg knv on  kna.KUNNR = knv.KUNNR  and kna.MANDT=knv.MANDT
left join EDW_RZ.sap_tvgrt_stg tv  on tv.VKGRP = knv.VKGRP  and tv.mandt=knv.mandt
left join EDW_RZ.sap_but000_stg bt on bt.PARTNER=kna.KUNNR AND kna.MANDT=bt.CLIENT
LEFT JOIN yetidm.customer cu on bt.bu_sort2=cu.refcustid
--JOIN EDW_RZ.sap_knvp_stg kp on kp.kunnr=kna.kunnr
left join EDW_RZ.sap_tvkbt_stg tk  on tk.VKBUR = knv.VKBUR
left join  EDW_RZ.knvv_lookup_stg lkp ON knv.bzirk=lkp.district
where kna.MANDT='300'

)
GO
