USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_INVOICE_ACDOCA_FCT]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_INVOICE_ACDOCA_FCT] AS

if object_id('EDW.INVOICE_ACDOCA_FCT') is not null begin 
DROP TABLE EDW.INVOICE_ACDOCA_FCT end;

CREATE TABLE EDW.INVOICE_ACDOCA_FCT WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
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
	,CAST(SUBSTRING(SAP.CustomerID, PATINDEX('%[^0 ]%', SAP.CustomerID + ' '), LEN(SAP.CustomerID)) AS CHAR) AS CustomerID
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
	,SAP.dwlastupdated AS dwlastupdated
	,'SAP' AS SourceSystem 

FROM EDW_TZ.SAP_INVOICE_ACDOCA_FCT SAP
left join (select distinct Order_Number, sku, Sales_group
from [DemandWare].[CRM_stg] ) C 
on SUBSTRING(SAP.PONumber, PATINDEX('%[^0 ]%', SAP.PONumber + ' '), LEN(SAP.PONumber)) = C.Order_Number 
and SUBSTRING(SAP.Productid, PATINDEX('%[^0 ]%', SAP.Productid + ' '), LEN(SAP.Productid)) = C.sku

WHERE SAP.GLAccount IN ('0041003999','0040100050','0040100000','0041003100')
);
GO
