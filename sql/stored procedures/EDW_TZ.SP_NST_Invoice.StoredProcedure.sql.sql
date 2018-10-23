USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_NST_Invoice]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_NST_Invoice] AS

if object_id('EDW_TZ.NST_Invoice') is not null begin
Drop TABLE EDW_TZ.NST_Invoice end;

Create Table EDW_TZ.NST_Invoice WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
select
transactions.TRANDATE as Posting_Date,
Cast(customers.Customer_Id AS Varchar(100)) AS Customer_Id,
null as 'Sales_Office',
null as GLAccount,
--transactions.RO_SALES_ORDER_PRODUCT_QUANTI AS Quantity,
--transactions.RO_SALES_ORDER_PRODUCT_LINES_,
transaction_lines.ITEM_COUNT AS Quantity,
transaction_lines.RO_SALES_ORDER_RAMBLER_TOTAL AS Total,
Cast(Items.Item_id  AS Varchar(100)) AS Product_Id,
transactions.tranid  as Invoice_Id,
null as Order_Id,
null as Company_Id,
'Drinkware' As Product_Category,
null as Product_Type,
null as Variation,
CASE WHEN transactions.transaction_source = 'Web (YETI Custom Shop)' THEN 'WEB' ELSE 'CSG' END AS Sales_Channel,
items.masterSKU as Master_SKU,
items.Color as Color,
CASE WHEN CATEGORY_0 in ('asi','wholesale') THEN 'WHOLESALE/ASI' ELSE 'Direct' END As Direct,
Case when RO_IS_TOLLING_ORDER='T' then 'Tolling' Else 'Customer' End as Tolling, 
items1.FULL_NAME as Front_Embellishment,
'NetSuite' AS Source_System
FROM [EDW_SZ].[NST_Transaction_Lines] AS transaction_lines
left join [EDW_SZ].[NST_Transactions] AS transactions on transaction_lines.transaction_id = transactions.transaction_id
left join [EDW_SZ].[NST_Customers] AS customers on transactions.Entity_id = customers.customer_id
left join EDW_TZ.NST_Product_Dim AS items on items.item_ID = transaction_lines.Item_ID
left join EDW_TZ.NST_Product_Dim AS items1 on TRANSACTION_LINES.RO_SALES_ORDER_FRONT_ITEM_ID = items1.ITEM_ID
--where transactions.TRANSACTION_TYPE = 'Invoice' and items.type_name = 'Assembly/Bill of Materials'


Union All

Select  top 100 
i.invoicedate as pstg_date,
i.Customerid as customer,
i.SalesOffice, 
i.GLAccount,
i.quantity,
i.grossextprice,
i.productid as product_id,
Cast(i.Invoiceid AS Varchar(100)) AS Invoice_id,
i.OrderId,
i.CompanyID,
p.productCategory,
p.producttype,
p.variation,
CASE when GLAccount='0041003100' then 'F&O' 
    when i.salesOffice IN ('BDV','CLD','CTL','PRD') THEN 'Business Development'
    when i.salesOffice IN ('VSUP') THEN 'DELETE'
    WHEN i.salesOffice IN ('AMB','BORD','BREW','CORP','ECM','EMPL','FAF','FIRS','FISH','FUND','GOVT','HUNT','INDU','INTD','MILT','OUTD','PRO','RETL','SELE','YETI','YRD','YTS') THEN 'E-Commerce' 
    WHEN i.salesOffice in ('BBQ','MM13') then 'E-Commerce other'
    WHEN i.salesOffice in ('DSD','HYB','INTL','OEM','PREM','STD') THEN  'Standard Dealers'
    WHEN i.salesOffice in ('ONLI') then 'E-Commerce Retail' 
    WHEN i.salesOffice in ('FLG') then 'Retail'
    WHEN i.salesOffice in ('PGW','PGWY') then 'Promo'
    WHEN i.salesOffice in ('PRG') then 'YETI Authorized'
    WHEN i.salesOffice in ('MARK') then 'Other'
    WHEN i.salesOffice in ('NTL') then 'National Accounts'
    WHEN i.salesOffice in ('Other') then 'JE'
    WHEN i.salesOffice in ('EBY') then 'eBAY' END as 'CHANNEL',
p.masterSKU,
p.color, 
'' as Direct,
'' as Tolling,
'' as 'Front_Embellishment',
'SAP' AS Source_System
from EDW.Invoice as i
left join EDW.product_dim p on i.productid = p.productid
where GLAccount IN ('0040100000')                  
AND CompanyID='1100'
--AND i.invoicedate =''
);
GO
