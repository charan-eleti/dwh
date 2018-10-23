USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [DemandWare].[sp_crm]    Script Date: 10/18/2018 11:07:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [DemandWare].[sp_crm] AS

if object_id('DemandWare.crm') is not null begin 
DROP TABLE DemandWare.crm end;
CREATE TABLE DemandWare.crm
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
SELECT 
Email
,Order_Number
,Order_Status
,Sku
,Qty
,Unit_Total
,Discount_Amount
,CAST(CASE when Order_Date = '0' or Order_Date = '\N' then Null else Order_Date end as Date) as Order_Date
--,CAST(Order_Date as Date) Order_Date
,Customer_Id
,Address_Line_1
,Address_Line_2
,City
,State
,Zip_Code
,Country
,Convert(Int,CASE when Order_Date = '\N' then Null else Qty end) NewQty
,CAST(CASE when LTRIM(RTRIM(Unit_Total)) = '\N' then Null else Unit_Total end AS DECIMAL(8,2)) NewUnitTotal
--,LTRIM(RTRIM((case when LEFT(LTRIM(RTRIM(Unit_Total)), 1) = '$' then REPLACE(REPLACE(LTRIM(RTRIM(Unit_Total)),'$',''),',','') ELSE REPLACE(LTRIM(RTRIM(Unit_Total)),',','') END))) As test
,Convert(Decimal(10,3), REPLACE(REPLACE(LTRIM(RTRIM(Discount_Amount)),'$',''),',','')) NewDiscountAmount
,Convert(datetime2, CASE when Order_Date = '0' or Order_Date = '\N' then Null else Order_Date end) NewOrderDate
--,Case When Convert(Int,Qty) is null and Qty is not null Then 'Error' Else Null End QtyError
--,Case When Convert( Decimal(10,3), Unit_Total) is null and Unit_Total is not null  Then 'Error' Else Null End UnitTotalError
--,Case When Convert(Decimal(10,3), Discount_Amount) is null and Discount_Amount is not null  Then 'Error' Else Null End DiscountAmountError
--,Case When Convert(datetime2, Order_Date) is null and Order_Date is not null  Then 'Error' Else Null End OrderDateError

FROM demandware.CRM_stg
)
GO
