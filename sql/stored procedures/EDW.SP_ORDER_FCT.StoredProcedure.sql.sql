USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_ORDER_FCT]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_ORDER_FCT] AS

if object_id('EDW.ORDER_FCT') is not null begin
DROP TABLE EDW.ORDER_FCT end;

CREATE TABLE EDW.ORDER_FCT WITH (DISTRIBUTION = HASH (orderid), CLUSTERED INDEX (orderid, orderlineid, OrderDate)) AS 
(
SELECT
		CAST(epi.OrderId AS CHAR) OrderID
	   ,CAST(epi.OrderLineId AS CHAR) OrderlineID
	   ,CAST(epi.OrderDateKey AS CHAR) OrderDateKey
	   ,CAST(CONVERT(VARCHAR(10), LTRIM(RTRIM(epi.OrderDateKey)), 126) AS DATE) AS OrderDate
	   ,CAST(CONVERT(VARCHAR(10), (case when ltrim(rtrim(epi.RequestDateKey)) = '-1' then NULL else epi.RequestDateKey END), 126) AS DATE) AS Requested_Date
	   ,SUBSTRING(epi.PRODUCTID, PATINDEX('%[^0 ]%', epi.PRODUCTID + ' '), LEN(epi.PRODUCTID)) AS ProductID
	   ,CAST(epi.CUSTOMERID AS CHAR) AS CustomerID
	   ,epi.ExtPriceDtl AS GrossPrice
	   ,COALESCE(CASE
			WHEN xref.EPICOR_Code IS NULL THEN SalesCatID
			ELSE xref.SAP_SALES_OFFICE
		END, '-1') AS SalesOffice
	   ,COALESCE(CASE
			WHEN xref.EPICOR_Code IS NULL THEN SalesChannelId
			ELSE xref.SALES_GROUP
		END, '-1') AS SalesGroup
		,COALESCE(CASE
			WHEN xref.EPICOR_Code IS NULL THEN SalesChannelId
			ELSE xref.SALES_GROUP
		END, '-1') AS NewSalesGroup
	   ,'EPI' as OrderType
	   ,CustomerId AS SoldToParty
	   ,CAST(epi.SHIPID AS CHAR) AS ShipID
	   ,CAST(epi.ShipToCustNum AS CHAR) AS ShipToParty
	   ,epi.shiptonum as ShipToNum
	   ,epi.BtCustNum AS BillToParty
	   ,CAST('-1' AS CHAR) as BillToPartyAddress
	   ,epi.ReasonforReturn as RejectionReason
	   ,epi.useots as UseOTS
	   ,epi.otsname as OTSName
	   ,epi.otsaddress1 as OTSAddress1
	   ,epi.OTSAddress2 as OTSAddress2
	   ,epi.OTSAddress3 as OTSAddress3
	   ,epi.OTSCity as OTSCity
	   ,epi.OTSContact as OTSContact
	   ,epi.OTSCountryNum as OTSCountryNum
	   ,epi.OTSFaxNum as OTSFaxNum
	   ,epi.OTSPhoneNum as OTSPhoneNum
	   ,epi.OTSResaleID as OTSResaleID
	   ,epi.otsstate as OTSState
	   ,epi.OTSZIP as OTSZip
	   ,'-1' as ShipToPartyAddress
	   ,CAST(epi.OrderQty AS INT) OrderQTY
	   ,CAST(epi.[UnitPrice] AS DECIMAL(10, 2)) UnitPrice
	   ,REPLACE(COALESCE(epi.PONum, '-1'), '\N', '-1') POnumber
	   ,CASE
			WHEN epi.CancelledFlag = '1' THEN 'Y'
			ELSE 'N'
		END AS isCancelled
	   ,'Epicor' AS SourceSystem
	FROM EDW_TZ.EPI_Orderfact epi
	LEFT JOIN [YETIDMSAP].[SALESCHANNEL_FINAL_XREF] xref
		ON xref.EPICOR_Code = epi.saleschannelid
	WHERE CAST(epi.OrderId AS CHAR) NOT IN (SELECT (CASE WHEN EpicorOrderID IS NULL THEN '-1' ELSE EpicorOrderID END) FROM EDW_TZ.SAP_ORDER_FCT)

	UNION

	SELECT
		[OrderId] AS OrderID
	   ,[OrderLineId] AS OrderLineID
	   ,OrderDateKey AS OrderDateKey
	   ,CAST(CONVERT(VARCHAR(10), LTRIM(RTRIM(OrderDateKey)), 126) AS DATE) AS OrderDate
	   ,CAST((case when ltrim(rtrim(RequestDateKey)) = '00000000' then NULL else RequestDateKey END) AS DATE) AS Requested_Date
	   ,SUBSTRING(PRODUCTID, PATINDEX('%[^0 ]%', PRODUCTID + ' '), LEN(PRODUCTID)) AS ProductID
	   ,SUBSTRING(CUSTOMERID, PATINDEX('%[^0 ]%', CUSTOMERID + ' '), LEN(CUSTOMERID)) CustomerID
	   ,GrossPrice AS GrossPrice
	   ,CASE
			WHEN ProductID IN (
				'000000014900000001',
				'000000014900000004',
				'000000014900000003',
				'000000014900000002') THEN 'YRD'
			WHEN OrderID IN (SELECT
						OrderID
					FROM EDW_TZ.SAP_ORDER_FCT
					WHERE ProductID IN
					(
					'000000014900000001',
					'000000014900000004',
					'000000014900000003',
					'000000014900000002')) THEN 'YRD'

			ELSE COALESCE(Salesoffice, '-1')
		END AS SalesOffice
		,CASE
			WHEN ProductID IN (
				'000000014900000001',
				'000000014900000004',
				'000000014900000003',
				'000000014900000002') THEN 'FLD'
			WHEN OrderID IN (SELECT
						OrderID
					FROM EDW_TZ.SAP_ORDER_FCT
					WHERE ProductID IN
					(
					'000000014900000001',
					'000000014900000004',
					'000000014900000003',
					'000000014900000002')) THEN 'FLD'

			ELSE COALESCE(salesgroup, '-1')
		END AS SalesGroup
		,Case when (CASE when OrderID IN (SELECT OrderID FROM EDW_TZ.SAP_ORDER_FCT
					WHERE ProductID IN
					('000000014900000001',
					 '000000014900000004',
					 '000000014900000003',
					 '000000014900000002')) THEN 'FLD'
			ELSE COALESCE(S.salesgroup, '-1')
		END) <> C.Sales_group then C.Sales_group else (CASE when OrderID IN (SELECT OrderID FROM EDW_TZ.SAP_ORDER_FCT
					WHERE ProductID IN
					('000000014900000001',
					 '000000014900000004',
					 '000000014900000003',
					 '000000014900000002')) THEN 'FLD'
			ELSE COALESCE(S.salesgroup, '-1')
		END) end as NewSalesgroup
		,OrderType
		,SUBSTRING(SoldToParty, PATINDEX('%[^0 ]%', SoldToParty + ' '), LEN(SoldToParty)) AS SoldToParty
		,'-1' AS ShipID
	    ,ShipToParty AS ShipToParty
	    ,'-1' as ShipToNum
	    ,BillToParty
	    ,BillToPartyAddress	   	
		,ReasonForRejectionID as RejectionReason
	    ,'0' as UseOTS
		,'-1' as OTSName
		,'-1' as OTSAddress1
		,'-1' as OTSAddress2
		,'-1' as OTSAddress3
		,'-1' as OTSCity
		,'-1' as OTSContact
		,'-1' as OTSCountryNum
		,'-1' as OTSFaxNum
		,'-1' as OTSPhoneNum
		,'-1' as OTSResaleID
		,'-1' as OTSState
		,'-1' as OTSZip
	    ,ShipToPartyAddress AS ShipToPartyAddress
	    ,CAST([OrderQuantity] AS INT) OrderQTY
	    ,CAST([UnitPrice] AS DECIMAL(10, 2)) UnitPrice
	    ,COALESCE(PurchaseOrdernumber, '-1') POnumber
	    ,CASE
			WHEN CancelledFlag = 'C' THEN 'Y'
			ELSE 'N'
		END isCancelled
	    ,'SAP' AS SourceSystem

	FROM EDW_TZ.SAP_ORDER_FCT s
	left join (select distinct Order_Number, sku, Sales_group
	from [DemandWare].[CRM_stg] ) C 
	on SUBSTRING(S.PurchaseOrdernumber, PATINDEX('%[^0 ]%', S.PurchaseOrdernumber + ' '), LEN(S.PurchaseOrdernumber)) = C.Order_Number and 
	SUBSTRING(S.Productid, PATINDEX('%[^0 ]%', S.Productid + ' '), LEN(S.Productid)) = C.sku
	
);
GO
