USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_BILLTO_DIM]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_BILLTO_DIM] AS

if object_id('EDW.BILLTO_DIM') is not null begin 
DROP TABLE EDW.BILLTO_DIM end;

CREATE TABLE EDW.BILLTO_DIM WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
SELECT 
CAST('-1' AS CHAR) as AddressNumber,
CAST('1100' AS CHAR) as CompanyID,
cast([CustomerId] as char)  AS BillToID,
cast('-1' as char)  AS CustomerId,
[Name],
[Address1]  AS Address1,
[Address2]  AS Address2,
[Address3]  AS Address3,
[City] AS  City,
[State]  AS State,
[Zip]  AS ZIPCODE,
[Country]  AS Country,
[PhoneNum] AS TELEPHONE,
[FaxNum] AS FAX,
'Epicor' AS SourceSystem

FROM yetidm.customer

UNION

SELECT
ADDRESSNUMBER as AddressNumber,
CAST('1100' AS CHAR) as CompanyID,
ShiptoID as BillToID,
[CustomerID] as CustomerID,
Name,
STREET AS Address1,
Null as Address2,
Null as Address3,
CITY,
STATE,
ZIPCODE,
COUNTRY,
TELEPHONE,
FAX AS FAX,
'SAP' as SourceSystem

from EDW_TZ.SAP_SHIPTO_DIM
where PARTNER_ROLE='RE'
);
GO
