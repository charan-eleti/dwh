USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_company]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_company] AS

if object_id('yetidm.company') is not null begin 
Drop table yetidm.company end;
create table yetidm.Company WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT Company as CompanyId
      ,Name
      ,Address1
      ,Address2
      ,Address3
      ,City
      ,State
      ,Zip
      ,Country
      ,PhoneNum
      ,FaxNum
      ,FEIN
      ,StateTaxID
      ,EDICode
      ,TaxRegionCode
      ,CountryNum
      ,Number
      ,ExternalID
      ,CalendarID
      ,AuxMailAddr
      ,FiscalCalendarID
      ,LegalName
      ,SysRevID
      ,SysRowID
  FROM yetistg.erp_company_stg;

GO
