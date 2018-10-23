USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_20_ctas_customer]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_20_ctas_customer] AS

if object_id('yetidm.customer') is not null begin 
Drop table yetidm.customer end;
create table yetidm.Customer WITH (DISTRIBUTION = ROUND_ROBIN ) as 
SELECT CustNum as CustomerId
      ,coalesce(case when ltrim(rtrim(c.GroupCode)) = '' then NULL else case when c.GroupCode = 'OEM' and c.custnum = 26575 then 'RAMBLERON' else c.GroupCode end end,'-1') as SalesChannelId
      ,coalesce(case when ltrim(rtrim(cg.GroupDesc)) = '' then NULL 
	else cg.GroupDesc end,'Other') as SalesCategory
      ,coalesce(case when ltrim(rtrim(cg.GroupCode)) = '' then NULL 
	else cm.Channel end,'Other') as SalesChannel
      ,c.Company as CompanyId
      ,CustID as RefCustId
      ,c.Name
      ,Address1
      ,Address2
      ,Address3
      ,City
      ,State
      ,Zip
      ,Country
      ,cs.yetiregion
      ,ResaleID
      ,SalesRepCode as SalesRepId
      ,TerritoryID
      ,ShipToNum as ShipToId
      ,TermsCode
      ,ShipViaCode
      ,FinCharges
      ,CreditHold
      ,c.GroupCode
      ,DiscountPercent
      ,EstDate
      ,FaxNum
      ,PhoneNum
      ,TaxExempt
      ,CreditHoldDate
      ,CreditHoldSource
      ,CreditClearDate
      ,CreditClearTime
      ,EDICode
      ,CurrencyCode
      ,CountryNum
      ,LangNameID
      ,ParentCustNum
      ,TaxRegionCode
      ,ICCust
      ,ContBillDay
      ,EMailAddress
      ,WebCustomer
      ,CustomerType
      ,NoContact
      ,TerritoryLock
      ,CustURL
      ,PendingTerritoryID
      ,ExtID
      ,ConsolidateSO
      ,BillFrequency
      ,TaxAuthorityCode
      ,ExternalID
      ,CreditLimit
      ,CustPILimit
      ,NotifyFlag
      ,NotifyEMail
      ,CreditCardOrder
      ,ChangedBy
      ,ChangeDate
      ,ChangeTime
      ,ChargeCode
      ,CommercialInvoice
      ,TaxRoundRule
      ,TaxMethod
      ,CustPartOpts
      ,HasBank
      ,PMUID
      ,LegalName
      ,PriceTolerance
      ,PeriodicBilling
      ,DeferredRev
      ,CSR
      ,c.SysRevID
      ,c.SysRowID
FROM yetistg.erp_customer_stg c
left join yetistg.erp_custgrup_stg cg on cg.groupcode = c.groupcode
left join yetistg.erp_channelmapping_stg cm on lower(cm.groupcode) = coalesce(case when ltrim(rtrim(c.GroupCode)) = '' then NULL else case when c.GroupCode = 'OEM' and c.custnum = 26575 then 'RAMBLERON' else c.GroupCode end end,'-1')
left join yetistg.erp_countrystateregion_stg cs on cs.is03 = c.state
UNION ALL
Select
-1
,'-1'
,'UNKNOWN'
,'UNKNOWN'
,'YETI'
,'-1'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'UNKNOWN'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-2
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'YETI'
,'-2'
,'FREIGHT'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'FREIGHT'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-3
,'FLAGSHIP'
,'FLAGSHIP'
,'FLAGSHIP'
,'YETI'
,'-3'
,'FLAGSHIP'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'FLAGSHIP'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-4
,'STD'
,'STD'
,'STD'
,'YETI'
,'-4'
,'STD'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'STD'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-5
,'BBD'
,'BBD'
,'BBD'
,'YETI'
,'-5'
,'BBD'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'BBD'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-6
,'STD'
,'STD'
,'STD'
,'YETI'
,'-6'
,'STD'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'STD'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-7
,'GENE'
,'GENE'
,'GENE'
,'YETI'
,'-7'
,'GENE'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'GENE'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-8
,'PGWY'
,'PGWY'
,'PGWY'
,'YETI'
,'-8'
,'PGWY'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'PGWY'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-9
,'CLR'
,'CLR'
,'CLR'
,'YETI'
,'-9'
,'CLR'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'CLR'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
UNION ALL
Select
-10
,'CLD'
,'CLD'
,'CLD'
,'YETI'
,'-10'
,'CLD'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,''
,''
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,0
,0
,'CLD'
,0.00
,NULL
,' '
,' '
,' '
,NULL
,' '
,NULL
,' '
,' '
,' '
,0
,' '
,0
,' '
,0
,0
,' '
,0
,' '
,0
,0
,' '
,' '
,' '
,0
,' '
,' '
,' '
,0.00
,0.00
,0
,' '
,0
,' '
,NULL
,0
,' '
,0
,0
,' '
,' '
,0
,0
,' '
,0.000
,0
,0
,' '
,0
,' '
;



if object_id('yetidm.sp_10_ctas_aopbudgetmonthly') is not null  
drop procedure yetidm.sp_10_ctas_aopbudgetmonthly;
GO
