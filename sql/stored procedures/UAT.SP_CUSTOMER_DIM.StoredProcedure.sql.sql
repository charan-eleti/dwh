USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [UAT].[SP_CUSTOMER_DIM]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [UAT].[SP_CUSTOMER_DIM] AS

if object_id('UAT.CUSTOMER_DIM') is not null begin 
DROP TABLE UAT.CUSTOMER_DIM end;

CREATE TABLE UAT.CUSTOMER_DIM WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
SELECT SUBSTRING(customerid, PATINDEX('%[^0 ]%', customerid + ' '), LEN(customerid)) AS CustomerID
      ,[Customer]
	  ,SalesOrganization AS SalesOrg
      ,[SalesGroup]
      ,[SalesOffice]
	  ,SalesGroupDescription
	  ,SalesOfficeDescription
	  ,Case when BlockedCustomer = 'X' then 'Blocked' Else Null End as CustomerStatus
	  ,[Address1]
      ,[City]
      ,[State]
      ,[Zipcode]
      ,[Country]
      ,[Telephone]
      ,[Fax]
      ,[District],
	  'SAP' AS SourceSystem

  FROM EDW_TZ.SAP_CUSTOMER_DIM


  union


select 
SUBSTRING(customerid, PATINDEX('%[^0 ]%', customerid + ' '), LEN(customerid)) AS CustomerID,
Customer,
CompanyId As SalesOrg,
SalesGroup,
SalesOffice,
SalesGroupDescription,
SalesOfficeDescription,
'InActive' as CustomerStatus,
Address1,
City,
State,
Zip,
Country,
PhoneNum,
FaxNum,
TerritoryID,
SourceSystem

from EDW_TZ.EPI_CUSTOMER
);
GO
