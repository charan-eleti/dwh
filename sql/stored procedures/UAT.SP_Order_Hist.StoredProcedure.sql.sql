USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [UAT].[SP_Order_Hist]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [UAT].[SP_Order_Hist] AS

if (select count(*) from uat.Order_hist where Asof_Date = convert(date, getdate())) > 1 begin 
Delete from UAT.Order_hist where Asof_Date = convert(date, getdate()) end;

Insert into UAT.Order_hist

select  
order_id 'Sales_Document',
order_line_id  'Sales_Document_Item',
zva.Customer_Id 'Sold_To_Party',
zva.customer 'Sold_To_Party_Name',
cd.customerstatus 'Central_Block',
zva.sales_office 'Sales_Office_Orders', 
cd.salesoffice 'Sales_Office_Customer',
zva.product_id 'Product_Id',
Productdescription 'Product_Description',
quantity 'Order_Quantity_Line',
net_value 'Net_Value_Line',
requested_date 'Header_Requested_Date',
req_delivery_date 'Requested_delivery_date',
delivery_date 'ATP_Influenced_Delivery_Date',
po_number 'Purchase_Order_Number',
Order_Created_Date 'Header_Created_On',
Order_Created_By 'Created_By',
Rejection_Reason 'Reason_for_Rejection',
Rejection_Description,
Rejected_Date,
Blocked,
Billing_Block, 
Delivery_Block,
Credit_Status,
Unconfirmed_Reason,
Days_Stale,
Order_Line_Created_Date 'Item_Created_On',
Delivery_Line_Status 'Delivery_Status_Item',
order_line_status,
ProductCategory 'Product_Category', 
mastersku 'MSKU',
concat(mastersku, '_', color) as 'MSKU_C',
producthierarchyid 'ProdHier',
case when zva.Customer_Id in ('0000101213','0000100121','0000101354','0000100434','0000101583','0000114504','0000100189','0000100812',
								'0000100873','0000101399','0000101813','0000104863','0000106889','0000107397','0000107466','0000107675') then 'NTL'
	when zva.Customer_Id in ('0000100635','0000100710','0000101083','0000101663','0000101886','0000101937','0000102433','0000103648','0000106469') then 'RKA'
	when zva.Customer_Id in ('0000100315','0000100395','0000100463','0000101026','0000101539','0000101711','0000102853','0000103430','0000103655','0000106838') then 'RKA'
	when zva.Customer_Id in ('0000104863','0000100684','0000106193','0000108382','0000108654','0000107894','0000114883','0000106163','0000107330','0000103667','0000112983') then 'Non RSD'
	when zva.sales_office = 'HYB' then 'INDP'
	when zva.sales_office = 'STD' then 'INDP'
	else zva.sales_office end as 'SO_Sales_Office',

case when Delivery_Line_Status in ('A','B') then 'Open' else 'Shipped'end as 'Ship_Status',

fc.fiscalyear 'Req_Fiscal_Year',
fc.fiscalmonth 'Req_Fiscal_Month',
fc.fiscalquarter 'Req_Fiscal_Quarter',
fc.fiscalweek 'Req_Fiscal_Week',
fc2.fiscalyear 'Created_Fiscal_Year',
fc2.fiscalquarter 'Created_Fiscal_Quarter',
fc2.fiscalmonth 'Created_Fiscal_Month',
fc2.fiscalweek 'Created_Fiscal_Week',
fc2.weekdaynum 'Weekday_Number',
case 
when fc2.fiscalmonth = fc.fiscalmonth then 'Current Month'
when fc2.fiscalquarter = fc.fiscalquarter then 'Current Quarter'
else 'Future Quarters'
end as 'Requested_Period',
convert(date, getdate()) AS Asof_Date

from EDW.orders zva
left outer join EDW.PRODUCT_DIM pd
on zva.product_id = pd.productid
left outer join EDW.fiscalcalendar fc
on zva.delivery_date = fc.date
left outer join EDW.fiscalcalendar fc2
on zva.order_line_created_date = fc2.date
left outer join EDW.customer_dim cd
on zva.customer_id = cd.customerID


where zva.sales_office in ('STD', 'HYB', 'NTL')
and Active_SL = 'TRUE'
and Order_Line_Created_Date >= '2017-01-01'
and Order_Line_Created_Date < convert(date, getdate())
and Rejection_Reason is null
and order_type in (
'OR',
'ZB2C',
'ZPRH',
'ZCLC',
'ZCLG',
'ZARF',
'CBFD',
'ZFGP',
'ZCFD')
and zva.Customer_Id not in (
'0000114883',
'0000107894',
'0000107719')
and zva.sales_org = '1100'
;

if (select count(*) from uat.Order_hist where concat(year(Asof_Date),month(Asof_Date)) = concat(Year(Dateadd(Month,-24,convert(date, getdate()))),Month(Dateadd(Month,-24,convert(date, getdate()))))) > 1 begin 
Delete from UAT.Order_Hist where Asof_Date = Dateadd(Month,-24,convert(date, getdate())) end
;
GO
