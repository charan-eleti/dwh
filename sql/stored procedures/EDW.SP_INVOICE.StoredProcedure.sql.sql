USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_INVOICE]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_INVOICE] AS

if object_id('EDW.INVOICE') is not null begin 
DROP TABLE EDW.INVOICE end;

CREATE TABLE EDW.INVOICE WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
SELECT [InvoiceID]
	,[InvoiceLineID]
	,[CompanyID]
	,[SalesOffice]
	,[SalesGroup]
	,[SalesGroup] AS [NewSalesGroup]
	,SUBSTRING(customerid, PATINDEX('%[^0 ]%', customerid + ' '), LEN(customerid)) AS CustomerID
	,[SoldToParty]
	,ShipToParty
	,[ShipID]
	,ShipToNum
	,[ShipToPartyAddress]
	,[SalesRepID]
	,ProductID
	,[OrderID]
	,[OrderLineId]
	,[InvoiceDate]
	,[InvoiceType]
	,GLAccount
	,GLAccountDesc
	,TransType
	,[Quantity]
	,[GrossExtPrice]
	,[Discount]
	,BillToParty
	,BillToPartyAddress
	,UseOTS
	,OTSName
	,OTSAddress1
	,OTSAddress2
	,OTSAddress3
	,OTSCity
	,OTSContact
	,OTSCountryNum
	,OTSFaxNum
	,OTSPhoneNum
	,OTSResaleID
	,OTSState
	,OTSZip
	,[ChangedBy]
	,[ChangeDate]
	,[ChangeTime]
	,[SysRevID]
	,ChangeDateTime
	,dwlastupdated
	,[SourceSystem]

FROM EDW_TZ.EPI_INVOICE

UNION

SELECT SAP.InvoiceID AS InvoiceID
	,SAP.InvoiceLineID AS InvoiceLineID
	,SAP.CompanyID AS CompanyID
	,CASE
		WHEN SAP.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'YRD'
		ELSE SAP.SalesOffice
	END AS SalesOffice
	,CASE
		WHEN SAP.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'FLD'
		ELSE SAP.SalesGroup
	END AS SalesGroup
	,CASE
		WHEN SAP.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'FLD'
		ELSE Case when SAP.SalesGroup <> C.Sales_group then C.Sales_group else SAP.Salesgroup end
	END AS NewSalesGroup
	,CAST(SUBSTRING(customerid, PATINDEX('%[^0 ]%', customerid + ' '), LEN(customerid)) AS CHAR) AS CustomerID
	,CAST(SAP.SoldToParty AS CHAR) AS SoldToParty
	,CAST(SAP.ShipToParty AS CHAR) AS ShipToParty
	,CAST('-1' AS CHAR) AS [ShipID]
	,CAST('-1' AS CHAR) AS ShipToNum
	,CAST(SAP.ShipToPartyAddress AS CHAR) AS ShipToPartyAddress
	,CAST(SAP.SalesRepID AS CHAR) AS SalesRepID
	,SUBSTRING(SAP.PRODUCTID, PATINDEX('%[^0 ]%', SAP.PRODUCTID + ' '), LEN(SAP.PRODUCTID)) AS ProductID
	,CAST(SAP.OrderID AS CHAR) AS OrderID
	,CAST(SAP.OrderLineID AS CHAR) AS OrderLineID
	,SAP.InvoiceDate AS InvoiceDate
	,CAST(SAP.InvoiceType AS CHAR) AS InvoiceType
	,CAST(SAP.GLAccount AS CHAR) AS GLAccount
	,CAST(SAP.GLAccountDesc AS CHAR) AS GLAccountDesc
	,CAST(SAP.TransType AS CHAR) AS TransType
	,SAP.Quantity AS Quantity
	,SAP.GrossExtPrice AS GrossExtPrice
	,SAP.Discount AS Discount
	,SAP.BillToParty AS BillToParty
	,SAP.BillToPartyAddress AS BillToPartyAddress
	,CAST('0' AS CHAR) as UseOTS
	,CAST('-1' AS CHAR) as OTSName
	,CAST('-1' AS CHAR) as OTSAddress1
	,CAST('-1' AS CHAR) as OTSAddress2
	,CAST('-1' AS CHAR) as OTSAddress3
	,CAST('-1' AS CHAR) as OTSCity
	,CAST('-1' AS CHAR) as OTSContact
	,CAST('-1' AS CHAR) as OTSCountryNum
	,CAST('-1' AS CHAR) as OTSFaxNum
	,CAST('-1' AS CHAR) as OTSPhoneNum
	,CAST('-1' AS CHAR) as OTSResaleID
	,CAST('-1' AS CHAR) as OTSState
	,CAST('-1' AS CHAR) as OTSZip
	,CAST('-1' AS CHAR) AS ChangedBy
	,CAST('-1' AS CHAR) AS ChangeDate
	,CAST('-1' AS CHAR) AS ChangeTime
	,CAST('-1' AS CHAR) AS SysRevID
	,SAP.ChangeDateTime
	,SAP.dwlastupdated AS dwlastupdated
	,'SAP' AS SourceSystem 

FROM EDW_TZ.SAP_INVOICE_ACDOCA_FCT SAP
left join (select distinct Order_Number, sku, Sales_group
from [DemandWare].[CRM_stg] ) C 
on SUBSTRING(SAP.PONumber, PATINDEX('%[^0 ]%', SAP.PONumber + ' '), LEN(SAP.PONumber)) = C.Order_Number 
and SUBSTRING(SAP.Productid, PATINDEX('%[^0 ]%', SAP.Productid + ' '), LEN(SAP.Productid)) = C.sku
WHERE SAP.GLAccount IN ('0040100000','0040100050','0041003100','0041003999','0041008100','0041008150','0041009000','0041009050','0079000200')

UNION

select COGS.InvoiceID AS InvoiceID
	,COGS.InvoiceLineID AS InvoiceLineID
	,COGS.CompanyID AS CompanyID
	,CASE
		WHEN COGS.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'YRD'
		ELSE COGS.SalesOffice
	END AS SalesOffice
	,CASE
		WHEN COGS.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'FLD'
		ELSE COGS.SalesGroup
	END AS SalesGroup
	,CASE
		WHEN COGS.PRODUCTID IN  (
		'000000014900000001',
		'000000014900000002',
		'000000014900000003',
		'000000014900000004') THEN 'FLD'
		ELSE Case when COGS.SalesGroup <> C.Sales_group then C.Sales_group else COGS.Salesgroup end
	END AS NewSalesGroup
	,CAST(SUBSTRING(COGS.CustomerID, PATINDEX('%[^0 ]%', COGS.CustomerID + ' '), LEN(COGS.CustomerID)) AS CHAR) AS CustomerID
	,CAST(COGS.SoldToParty AS CHAR) AS SoldToParty
	,CAST(COGS.ShipToParty AS CHAR) AS ShipToParty
	,CAST('-1' AS CHAR) AS [ShipID]
	,CAST('-1' AS CHAR) AS ShipToNum
	,CAST(COGS.ShipToPartyAddress AS CHAR) AS ShipToPartyAddress
	,CAST(COGS.SalesRepID AS CHAR) AS SalesRepID
	,SUBSTRING(COGS.PRODUCTID, PATINDEX('%[^0 ]%', COGS.PRODUCTID + ' '), LEN(COGS.PRODUCTID)) AS ProductID
	,CAST(COGS.OrderID AS CHAR) AS OrderID
	,CAST(COGS.OrderLineID AS CHAR) AS OrderLineID
	,COGS.InvoiceDate AS InvoiceDate
	,CAST(COGS.InvoiceType AS CHAR) AS InvoiceType
	,CAST(COGS.GLAccount AS CHAR) AS GLAccount
	,CAST(COGS.GLAccountDesc AS CHAR) AS GLAccountDesc
	,CAST(COGS.TransType AS CHAR) AS TransType
	,COGS.Quantity AS Quantity
	,'0.00' AS GrossExtPrice
	,COGS.Discount AS Discount
	,COGS.BillToParty AS BillToParty
	,COGS.BillToPartyAddress AS BillToPartyAddress
	,CAST('0' AS CHAR) as UseOTS
	,CAST('-1' AS CHAR) as OTSName
	,CAST('-1' AS CHAR) as OTSAddress1
	,CAST('-1' AS CHAR) as OTSAddress2
	,CAST('-1' AS CHAR) as OTSAddress3
	,CAST('-1' AS CHAR) as OTSCity
	,CAST('-1' AS CHAR) as OTSContact
	,CAST('-1' AS CHAR) as OTSCountryNum
	,CAST('-1' AS CHAR) as OTSFaxNum
	,CAST('-1' AS CHAR) as OTSPhoneNum
	,CAST('-1' AS CHAR) as OTSResaleID
	,CAST('-1' AS CHAR) as OTSState
	,CAST('-1' AS CHAR) as OTSZip
	,CAST('-1' AS CHAR) AS ChangedBy
	,CAST('-1' AS CHAR) AS ChangeDate
	,CAST('-1' AS CHAR) AS ChangeTime
	,CAST('-1' AS CHAR) AS SysRevID
	,COGS.ChangeDateTime
	,COGS.dwlastupdated AS dwlastupdated
	,'SAP' AS SourceSystem 
	 from 
(SELECT * FROM [EDW_TZ].[SAP_INVOICE_ACDOCA_FCT] where [GLAccount] in ('0050100000')) COGS 
Left Outer join (SELECT *  FROM [EDW_TZ].[SAP_INVOICE_ACDOCA_FCT] where [GLAccount] in ('0040100000')) REVENUE
ON COGS.Orderid = REVENUE.OrderId and COGS.OrderLineId = REVENUE.OrderLineID
left join (select distinct Order_Number, sku, Sales_group
from [DemandWare].[CRM_stg] ) C 
on SUBSTRING(COGS.PONumber, PATINDEX('%[^0 ]%', COGS.PONumber + ' '), LEN(COGS.PONumber)) = C.Order_Number 
and SUBSTRING(COGS.Productid, PATINDEX('%[^0 ]%', COGS.Productid + ' '), LEN(COGS.Productid)) = C.sku
Where REVENUE.OrderId is null
and COGS.SalesOffice in ('ECM','YRD')
);
GO
