USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_EPI_INVOICE]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_EPI_INVOICE] AS

if object_id('EDW_TZ.EPI_INVOICE') is not null begin 
DROP TABLE EDW_TZ.EPI_INVOICE end;

CREATE TABLE EDW_TZ.EPI_INVOICE WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
SELECT InvoiceFact.InvoiceId AS InvoiceID
	,InvoiceFact.InvoiceLineId AS InvoiceLineID
	,InvoiceFact.CompanyId AS CompanyID
	,CASE 
		WHEN xref.EPICOR_Code IS NULL THEN  InvoiceFact.SalesCatID
		ELSE xref.SAP_SALES_OFFICE 
	END AS SalesOffice
	,CASE 
		WHEN xref.EPICOR_Code IS NULL THEN  InvoiceFact.SalesChannelID
		ELSE xref.SALES_GROUP 
	END AS SalesGroup
	,CAST (Coalesce(but000.Partner,InvoiceFact.CustomerId) as char) AS CustomerID
	--,cast (InvoiceFact.CustomerId as char) AS SoldToParty
	,CAST ('-1' as char) AS SoldToParty
	,CASE WHEN LTRIM(RTRIM(inv.ShipToCustNum))='0' THEN CAST(InvoiceFact.CustomerId AS CHAR)
		ELSE CAST(coalesce(LTRIM(RTRIM(inv.ShipToCustNum)),'-1') AS CHAR) 
	END AS ShipToParty
	--,CAST(coalesce(LTRIM(RTRIM(inv.ShipToCustNum)),'-1') AS CHAR) AS ShipToParty
	,CAST(InvoiceFact.ShipId AS CHAR) AS ShipID
	,CAST(coalesce(inv.shiptonum,'-1') AS CHAR) as ShipToNum
	,CAST('-1' AS CHAR) AS ShipToPartyAddress
	,COALESCE(rep_xref.SalesRepid,InvoiceFact.SalesRepId) AS SalesRepID
	,SUBSTRING(PRODUCTID, PATINDEX('%[^0 ]%', PRODUCTID + ' '), LEN(PRODUCTID)) as ProductID
	,CAST(InvoiceFact.OrderId AS CHAR) AS OrderID
	,CAST(inv.OrderLine AS CHAR) AS OrderLineId
	,InvoiceFact.InvoiceDate AS InvoiceDate
	,CAST(InvoiceFact.InvoiceType AS CHAR) AS InvoiceType
	,CAST('-1' AS CHAR) AS GLAccount
	,CAST('-1' AS CHAR) AS GLAccountDesc
	,CAST('-1' AS CHAR) AS TransType
	,InvoiceFact.Quantity AS Quantity
	,InvoiceFact.GrossExtPrice AS GrossExtPrice
	,InvoiceFact.Discount AS Discount
	,CAST(InvoiceFact.BTCustNum AS CHAR) AS BillToParty
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
	,cast (InvoiceFact.ChangedBy as char) AS ChangedBy
	,cast (InvoiceFact.ChangeDate as char) AS ChangeDate
	,cast (InvoiceFact.ChangeTime as char) AS ChangeTime
	,cast (InvoiceFact.SysRevID as char) AS SysRevID
	,inv.ChangeDateTime
	,inv.dwlastupdated AS dwlastupdated
	,InvoiceFact.sourcesystem AS SourceSystem

FROM yetidm.InvoiceFact InvoiceFact
left join YETISTG.ERP_INVCDTL_STG inv on InvoiceFact.invoiceid=inv.invoicenum and InvoiceFact.invoicelineid=inv.invoiceline
--LEFT JOIN YETISTG.ERP_CUSTOMER_STG cust ON cust.custnum = inv.btcustnum
left join YETIDMSAP.SALESCHANNEL_FINAL_XREF xref on xref.EPICOR_Code=InvoiceFact.saleschannelid
left join yetidm.SALESREP_XREF rep_xref on InvoiceFact.salesrepid=rep_xref.EpicorSalesRepID
left join yetidm.customer customer ON InvoiceFact.CustomerId = customer.CustomerId
left join yetistgsap.sap_but000_stg but000 on but000.bu_sort2 = customer.RefCustId and BPKIND = 'SP' and BU_GROUP = 'SP'
)
GO
