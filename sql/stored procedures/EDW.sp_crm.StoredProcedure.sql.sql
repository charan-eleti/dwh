USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[sp_crm]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[sp_crm] AS

if object_id('EDW.CRM') is not null begin 
DROP TABLE EDW.CRM end;
CREATE TABLE EDW.CRM
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select 
email,
order_number,
order_status,
sku,
Cast(case when qty = '' then Null else qty end AS Decimal(10,2)) AS qty,
Cast(case when unit_total = '' then Null else unit_total end AS Decimal(10,2)) AS unittotal,
Cast(case when discount_amount = '' then Null else discount_amount end AS Decimal(10,2)) AS discountamount,
Cast(order_date AS datetime2) As orderate,
customer_id,
address_line_1,
address_line_2,
city,
state,
zip_code,
country,
sales_group,
shipping_method
 from demandware.CRM_stg
)
GO
