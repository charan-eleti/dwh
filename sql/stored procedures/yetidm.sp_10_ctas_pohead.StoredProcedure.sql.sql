USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_pohead]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_pohead] AS

if object_id('yetidm.pohead') is not null begin 
Drop table yetidm.pohead end;
create table yetidm.pohead WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT Company
      ,OpenOrder
      ,VoidOrder
      ,PONum as Poid
      ,EntryPerson
      ,OrderDate
      ,FOB
      ,ShipViaCode
      ,TermsCode
      ,ShipName
      ,ShipAddress1
      ,ShipAddress2
      ,ShipAddress3
      ,ShipCity
      ,ShipState
      ,ShipZIP
      ,ShipCountry
      ,BuyerID
      ,FreightPP
      ,OrderHeld
      ,CurrencyCode
      ,ExchangeRate
      ,LockRate
      ,ShipCountryNum
      ,ApprovedDate
      ,ApprovedBy
      ,Approve
      ,ApprovalStatus
      ,ApprovedAmount
      ,PostToWeb
      ,PostDate
      ,VendorRefNum
      ,ConfirmReq
      ,Confirmed
      ,ConfirmVia
      ,OrderNum
      ,LegalNumber
      ,Linked
      ,ExtCompany
      ,XRefPONum
      ,ConsolidatedPO
      ,GlbCompany
      ,ContractOrder
      ,ContractStartDate
      ,ContractEndDate
      ,PrintHeaderAddress
      ,RateGrpCode
      ,POType
      ,APLOCID
      ,TranDocTypeID
      ,ICPOLocked
      ,SysRevID
      ,SysRowID
  FROM yetistg.Erp_POHeader_stg;

GO
