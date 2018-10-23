USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_sap_salesrep]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_sap_salesrep] AS

if object_id('EDW_TZ.SAP_SALESREP_DIM') is not null  begin
Drop table EDW_TZ.SAP_SALESREP_DIM end;

create table EDW_TZ.SAP_SALESREP_DIM WITH (DISTRIBUTION = HASH (CustomerID), CLUSTERED INDEX (CustomerID, SalesRepId, Name))
AS (

SELECT kvp.KUNN2 AS SalesRepID
	  , kvp.KUNNR as CustomerID
	  , rep.ADRNR AS ADDRESSNUMBER
	  , kvp.parvw as Partner_Role
	  , coalesce(case when ltrim(rtrim(UPPER(rep.NAME1))) = '' then NULL else ltrim(rtrim(UPPER(rep.NAME1))) end,'Unknown') AS name
	  , coalesce(case when ltrim(rtrim(UPPER(kna.NAME1))) = '' then NULL else ltrim(rtrim(UPPER(kna.NAME1))) end,'Unknown') AS customer
	  , COALESCE(reg.region,'Other') as Zregion
      , rep.STRAS AS Address1
      , NULL AS Address2
      , NULL AS Address3
      , rep.ORT01 AS City
      , rep.REGIO AS State
      , rep.PSTLZ AS Zip
      , NULL AS Country
	  , rep.TELF1 AS HomePhoneNum
      , rep.TELFX AS FaxPhoneNum
	  , kvp.dwlastupdated as dwlastupdated
from (select * from EDW_RZ.sap_knvp_stg where PARVW='Z0') kvp 
LEFT JOIN EDW_RZ.sap_kna1_stg kna ON kna.KUNNR=kvp.KUNNR
LEFT JOIN EDW_RZ.sap_kna1_stg rep ON rep.KUNNR=kvp.KUNN2
LEFT JOIN EDW_RZ.salesrep_region reg ON ltrim(rtrim(UPPER(rep.NAME1)))=ltrim(rtrim(UPPER(reg.TSM)))
WHERE len( SUBSTRING(kvp.kunnr, PATINDEX('%[^0 ]%', kvp.kunnr + ' '), LEN(kvp.kunnr))) = 6
and SUBSTRING(kvp.kunnr, PATINDEX('%[^0 ]%',kvp.kunnr + ' '), LEN(kvp.kunnr)) like '1%'
);
GO
