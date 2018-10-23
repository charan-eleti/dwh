USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_vendor]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_vendor] AS

if object_id('yetidm.vendor') is not null begin 
Drop table yetidm.vendor end;
create table yetidm.vendor WITH (DISTRIBUTION = ROUND_ROBIN ) as
select
      Company 
    , VendorID 
    , Name 
    , VendorNum 
    , Address1 
    , Address2 
    , Address3 
    , City 
    , State 
    , ZIP 
    , Country 
    , PurPoint 
    , Inactive 
    , TermsCode 
    , GroupCode 
    , FaxNum 
    , PhoneNum 
    , Comment 
    , PayHold 
    , PrimPCon 
    , AccountRef 
    , DefaultFOB 
    , CurrencyCode 
    , TaxRegionCode 
    , CountryNum 
    , LangNameID 
    , Approved 
    , EMailAddress 
    , WebVendor 
    , VendURL 
    , OnTimeRating 
    , QualityRating 
    , PriceRating 
    , ServiceRating 
    , ExternalId 
    , VendPILimit 
    , GlobalVendor 
    , MinOrderValue 
    , CalendarID 
    , EDICode 
    , ConsolidatedPurchasing 
    , LocalPurchasing 
    , SysRevID 
    , SysRowID 
from yetistg.erp_vendor_stg;
GO
