USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDWFIN].[SP_INVOICE_COGS_FCT]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDWFIN].[SP_INVOICE_COGS_FCT] AS

if object_id('EDWFIN.INVOICE_COGS_FCT') is not null begin 
DROP TABLE EDWFIN.INVOICE_COGS_FCT end;

CREATE TABLE EDWFIN.INVOICE_COGS_FCT WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
SELECT [InvoiceFact].[InvoiceId] AS [InvoiceID]
	,[InvoiceFact].[InvoiceLineId] AS [InvoiceLineID]
	,[InvoiceFact].[CompanyId] AS [CompanyID]
	,CASE 
		WHEN xref.EPICOR_Code IS NULL THEN  [InvoiceFact].[SalesCatID]
		ELSE xref.SAP_SALES_OFFICE 
	END AS [SalesOffice]
	,CASE 
		WHEN xref.EPICOR_Code IS NULL THEN  [InvoiceFact].[SalesChannelID]
		ELSE xref.SALES_GROUP 
	END AS [SalesGroup]
	,CAST ([InvoiceFact].[CustomerId] as char) AS [CustomerID]
	--,cast ([InvoiceFact].[CustomerId] as char) AS [SoldToParty]
	,CAST ('-1' as char) AS [SoldToParty]
	,CASE WHEN LTRIM(RTRIM(inv.ShipToCustNum))='0' THEN CAST([InvoiceFact].[CustomerId] AS CHAR)
		ELSE CAST(coalesce(LTRIM(RTRIM(inv.ShipToCustNum)),'-1') AS CHAR) 
	END AS ShipToParty
	--,CAST(coalesce(LTRIM(RTRIM(inv.ShipToCustNum)),'-1') AS CHAR) AS ShipToParty
	,CAST([InvoiceFact].[ShipId] AS CHAR) AS [ShipID]
	,CAST(coalesce(inv.shiptonum,'-1') AS CHAR) as ShipToNum
	,CAST('-1' AS CHAR) AS [ShipToPartyAddress]
	,COALESCE(rep_xref.SalesRepid,[InvoiceFact].[SalesRepId]) AS [SalesRepID]
	,SUBSTRING(PRODUCTID, PATINDEX('%[^0 ]%', PRODUCTID + ' '), LEN(PRODUCTID)) as ProductID
	,CAST([InvoiceFact].[OrderId] AS CHAR) AS [OrderID]
	,CAST(inv.[OrderLine] AS CHAR) AS [OrderLineId]
	,[InvoiceFact].[InvoiceDate] AS [InvoiceDate]
	,CAST([InvoiceFact].[InvoiceType] AS CHAR) AS [InvoiceType]
	,CAST('-1' AS CHAR) AS GLAccount
	,CAST('-1' AS CHAR) AS GLAccountDesc
	,CAST('-1' AS CHAR) AS TransType
	,[InvoiceFact].[Quantity] AS [Quantity]
	,[InvoiceFact].[GrossExtPrice] AS [GrossExtPrice]
	,[InvoiceFact].[Discount] AS [Discount]
	,CAST([InvoiceFact].[BTCustNum] AS CHAR) AS BillToParty
	,CAST('-1' AS CHAR) AS BillToPartyAddress
	,CAST(inv.useots AS CHAR) as UseOTS
	,CAST(inv.otsname AS CHAR) as OTSName
	,CAST(inv.otsaddress1 AS CHAR) as OTSAddress1
	,CAST(inv.OTSAddress2 AS CHAR) as OTSAddress2
	,CAST(inv.OTSAddress3 AS CHAR) as OTSAddress3
	,CAST(inv.OTSCity AS CHAR) as OTSCity
	,CAST(inv.OTSContact AS CHAR) as OTSContact
	,CAST(inv.OTSCountryNum AS CHAR) as OTSCountryNum
	,CAST(inv.OTSFaxNum AS CHAR) as OTSFaxNum
	,CAST(inv.OTSPhoneNum AS CHAR) as OTSPhoneNum
	,CAST(inv.OTSResaleID AS CHAR) as OTSResaleID
	,CAST(inv.otsstate AS CHAR) as OTSState
	,CAST(inv.OTSZIP AS CHAR) as OTSZip
	,cast ([InvoiceFact].[ChangedBy] as char) AS [ChangedBy]
	,cast ([InvoiceFact].[ChangeDate] as char) AS [ChangeDate]
	,cast ([InvoiceFact].[ChangeTime] as char) AS [ChangeTime]
	,cast ([InvoiceFact].[SysRevID] as char) AS [SysRevID]
	,inv.dwlastupdated AS dwlastupdated
	,[InvoiceFact].[sourcesystem] AS [SourceSystem]

FROM [yetidm].[InvoiceFact] [InvoiceFact]
left join YETISTG.ERP_INVCDTL_STG inv on [InvoiceFact].invoiceid=inv.invoicenum and [InvoiceFact].invoicelineid=inv.invoiceline
--LEFT JOIN YETISTG.ERP_CUSTOMER_STG cust ON cust.custnum = inv.btcustnum
left join [YETIDMSAP].[SALESCHANNEL_FINAL_XREF] xref on xref.EPICOR_Code=[InvoiceFact].saleschannelid
left join [yetidm].SALESREP_XREF rep_xref on InvoiceFact.salesrepid=rep_xref.[EpicorSalesRepID]

UNION

SELECT SAP.InvoiceID AS InvoiceID
	,SAP.InvoiceLineID AS InvoiceLineID
	,SAP.CompanyID AS CompanyID
	,SAP.SalesOffice AS SalesOffice
	,SAP.SalesGroup AS SalesGroup
	,CAST(SAP.CustomerID AS CHAR) AS CustomerID
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
WHERE SAP.GLAccount IN ('0050100000','0040100000') --AND SAP.OrderLineID <> '000000'

);
GO
