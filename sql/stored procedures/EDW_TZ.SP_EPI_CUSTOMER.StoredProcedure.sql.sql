USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_EPI_CUSTOMER]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_EPI_CUSTOMER] AS

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
10/15/2018	Charan Eleti	Added Terms Code As per Billy Minor's Request.
		

   ============================================= */

if object_id('EDW_TZ.EPI_CUSTOMER') is not null begin 
DROP TABLE EDW_TZ.EPI_CUSTOMER end;

CREATE TABLE EDW_TZ.EPI_CUSTOMER WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
select 
cast(Coalesce(Partner,CustomerId) as char)  AS CustomerID,
[Name] Customer,
CompanyId,
coalesce(xref.sales_group,saleschannelid)  AS SalesGroup,
coalesce(xref.sap_sales_office,saleschannelid)  AS SalesOffice,
coalesce(xref.salesgroupdescription,saleschannelid)  AS SalesGroupDescription,
coalesce(xref.salesofficedescription,saleschannelid)  AS SalesOfficeDescription,
EstDate,
TermsCode,
[Address1]  AS Address1,
[City] AS  City,
[State]  AS State,
[Zip]  AS Zip,
[Country]  AS Country,
[PhoneNum] AS  PhoneNum,
[FaxNum]  AS FaxNum,
[TerritoryID] AS  TerritoryID,
'Epicor' AS SourceSystem

from yetidm.customer yc
left join [YETIDMSAP].[SALESCHANNEL_FINAL_XREF] xref on xref.EPICOR_Code=yc.saleschannelid
left join yetistgsap.sap_but000_stg b on b.bu_sort2 = yc.RefCustId and BPKIND = 'SP' and BU_GROUP = 'SP'
where bu_sort2 is null
)
GO
