USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_SHIPTO_DIM]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_SHIPTO_DIM] AS

if object_id('EDW.SHIPTO_DIM') is not null begin 
DROP TABLE EDW.SHIPTO_DIM end;

CREATE TABLE EDW.SHIPTO_DIM WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
select
'-1' as AddressNumber,
CAST(coalesce(Shiptonum,'-1') AS CHAR) Shiptonum, 
CAST(coalesce(LTRIM(RTRIM(CustomerId)),'-1') AS CHAR) ShiptoID, 
CompanyID, 
--CAST(coalesce(LTRIM(RTRIM(CustomerId)),'-1') AS CHAR) CustomerID,
CAST('-1' AS CHAR) as CustomerID,
Name,Address1,Address2, Address3, City, State,Zip AS ZIPCODE, Country, SalesRepID,  PhoneNum AS TELEPHONE,FaxNum AS FAX,EDIShipNum, CountryNum,
'Epicor' as SourceSystem
from yetidm.shipto

UNION

select
'-1' as AddressNumber,
CASE
	WHEN Customerid='5661' THEN CAST('3855' AS CHAR)
	ELSE CAST(coalesce(Shiptonum,'-1') AS CHAR)
END AS Shiptonum,
CAST(coalesce(LTRIM(RTRIM(CustomerId)),'-1') AS CHAR) ShiptoID, 
CompanyID, 
CAST('-1' AS CHAR) as CustomerID,
Name,Address1,Address2, Address3, City, State,Zip AS ZIPCODE, Country, SalesRepID, PhoneNum AS TELEPHONE,FaxNum AS FAX,EDIShipNum, CountryNum,
'Epicor' as SourceSystem
from yetidm.shipto WHERE Shiptonum is NULL AND Customerid IN ('5661')

UNION

SELECT
ADDRESSNUMBER as AddressNumber,
'-1' as ShiptoNum,
ShiptoID as ShiptoID,
CAST('1100' AS CHAR) as CompanyID,
SUBSTRING(CustomerID, PATINDEX('%[^0 ]%', CustomerID + ' '), LEN(CustomerID)) as CustomerID,
Name,
STREET AS Address1,
Null as Address2,
Null as Address3,
CITY,
STATE,
ZIPCODE,
COUNTRY,
Null as SalesRepID,
TELEPHONE,
FAX AS FAX,
Null as EDIShipNum,
Null as CountryNum,
'SAP' as SourceSystem
from EDW_TZ.SAP_SHIPTO_DIM
where PARTNER_ROLE='WE'
);
GO
