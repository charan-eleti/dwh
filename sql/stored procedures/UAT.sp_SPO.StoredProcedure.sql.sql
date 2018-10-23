USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [UAT].[sp_SPO]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [UAT].[sp_SPO] AS

/* =============================================
   ObjectName/type: Table
   Description: 
               
   Parameters: 
   Author: Charan Eleti
   Create date: 10/01/2018
   
   =============================================
   Change History
   ============================================= 
  
Date 	Author	Description
10/8/2018	Charan Eleti	Modified Year_day to +14 Days As per Billy's requirement to be syncing to the Fiscal calendar.
10/12/2018	Charan Eleti	Added Requested_Period column calculation and removed filters for open orders.
		

   ============================================= */

if object_id('UAT.SPO') is not null begin
Drop TABLE UAT.SPO end;

CREATE TABLE UAT.SPO WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(

select 
Document,
Item,
C.CustomerID AS 'Sold_To_Party',
Sold_To_Party_Name,
Material,
Units,
Dollars,
Header_Requested_Date,
Line_Requested_Date,
ATP_Influenced_Delivery_Date,
PO_Number,
Header_Created_On,
Header_Created_By,
Blocked,
Billing_Block,
Delivery_Block,
Credit_Status,
Unconfirmed_Reason,
Days_Stale,
Item_Created_On,
Item_Delivery_Status,
Line_Status,
Storage_Location,
Order_Type,
Transactional_Sales_Office,
PGI_Date,
Cast(Invoice_Date as Date) As Invoice_Date,
Cast(Blended_Date as Date) As Blended_Date,
GL_Account,
Ship_Status,
fc2.fiscalquarter AS Blended_FQuarter,
fc2.FiscalMonth AS Blended_FMonth,
fc2.fiscalyear AS Blended_Fyear,

case
when fc.fiscalyear < fisc.fiscalyear then 'Last Year'
when fc.fiscalquarter < fisc.fiscalquarter then 'Previous Quarters'
when fc.fiscalquarter = fisc.fiscalquarter then 'Current Quarter'
else 'Future Quarters'
end as 'Requested_Period'

 from EDW.Customer_Dim C left join 
(	select 
	order_id 'Document',
	order_line_id 'Item',
	SUBSTRING(Customer_Id , PATINDEX('%[^0 ]%', Customer_Id + ' '), LEN(Customer_Id)) AS 'Sold_To_Party',
	zva.customer 'Sold_To_Party_Name',
	product_id 'Material',
	quantity 'Units',
	net_value 'Dollars',
	requested_date 'Header_Requested_Date',
	req_delivery_date 'Line_Requested_Date',
	delivery_date 'ATP_Influenced_Delivery_Date',
	po_number 'PO_Number',
	Sales_Org, 
	Order_Created_Date 'Header_Created_On',
	Order_Created_By 'Header_Created_By',
	Blocked,
	Billing_Block, 
	Delivery_Block,
	Credit_Status,
	Unconfirmed_Reason,
	Days_Stale,
	Order_Line_Created_Date 'Item_Created_On',
	Delivery_Line_Status 'Item_Delivery_Status',
	order_line_status 'Line_Status',
	storage_location 'Storage_Location',
	order_type 'Order_Type',
		zva.sales_office 'Transactional_Sales_Office',
	--zva.sales_org 'Sales_Org',
	null 'PGI_Date',
	null 'Invoice_Date',
	req_delivery_date 'Blended_Date',
	null 'GL_Account',
	case when Order_Line_Status in('A','B') then 'Open'	else 'Shipped' end as 'Ship_Status'

	from edw.orders zva
	where zva.sales_office in ('STD','HYB','NTL','BDV','CTL','YRD')
	and Active_SL = 'TRUE'
	and Order_Line_Created_Date >= '2017-01-01'
	and Order_Line_Created_Date < convert(date, getdate())
	and Rejection_Reason is null
	and order_type in ('OR','ZB2C','ZPRH','ZCLC','ZCLG','ZARF','CBFD','ZFGP','ZCFD')
	and sales_org in ('1100','1500')
	--and Order_Line_Status in ('A','B')

	union all  
	--PENDING

	select 
	Sales_Document	'Document',
	Sales_Document_Item	'Item',
	SUBSTRING(Sold_To_Party , PATINDEX('%[^0 ]%', Sold_To_Party + ' '), LEN(Sold_To_Party)) AS 'Sold_To_Party',
	Sold_To_NAME 'Sold_To_Party_Name',
	zsp.material_number	'Material',
	Actual_quantity_delivered_in_sales_units	'Units',
	Net_value_item	'Dollars',
	o.requested_date 'Header_Requested_Date',
	o.req_delivery_date 'Line_Requested_Date',
	o.delivery_date 'ATP_Influenced_Delivery_Date',
	o.po_number 'PO_Number',
	o.Sales_Org,
	o.Order_Created_Date 'Header_Created_On',
	o.Order_Created_By 'Header_Created_By',
	o.Blocked,
	o.Billing_Block, 
	o.Delivery_Block,
	o.Credit_Status,
	o.Unconfirmed_Reason,
	o.Days_Stale,
	o.Order_Line_Created_Date 'Item_Created_On',
	o.Delivery_Line_Status 'Item_Delivery_Status',
	o.order_line_status 'Line_Status',
	zsp.storage_location 'Storage_Location',
	o.order_type 'Order_Type',
	zsp.sales_office 'Transactional_Sales_Office',
	planned_goods_movement_date 'PGI_Date',
	null 'Invoice_Date',
	planned_goods_movement_date 'Blended_Date',
	null 'GL_Account',
	case when Overall_Goods_Movement_Status in ('A','B') then 'Pending' else 'rut row' end as 'Ship_Status'

	from edw.sap_zshippending zsp
	left outer join (select * from EDW.orders where active_sl = 'TRUE') o 
	on zsp.sales_document = o.order_id and zsp.sales_document_item = o.order_line_id

	where zsp.sales_office in ('STD','HYB','NTL','BDV','CTL','YRD')
	and overall_goods_movement_status != 'C'
	and delivery_type = 'LF'

	union all  
	--INVOICED

	select 
	InvoiceID 'Document',
	InvoiceLineID 'Item', 
	SUBSTRING(iaf.customerid , PATINDEX('%[^0 ]%', iaf.customerid + ' '), LEN(iaf.customerid)) AS 'Sold_To_Party',
	o.customer 'Sold_To_Party_Name',
	iaf.productID 'Material',
	iaf.Quantity 'Units',
	GrossExtPrice 'Dollars',
	o.requested_date 'Header_Requested_Date',
	o.req_delivery_date 'Line_Requested_Date',
	o.delivery_date 'ATP_Influenced_Delivery_Date',
	o.po_number 'PO_Number',
	o.Sales_Org,
	o.Order_Created_Date 'Header_Created_On',
	o.Order_Created_By 'Header_Created_By',
	o.Blocked,
	o.Billing_Block, 
	o.Delivery_Block,
	o.Credit_Status,
	o.Unconfirmed_Reason,
	o.Days_Stale,
	o.Order_Line_Created_Date 'Item_Created_On',
	o.Delivery_Line_Status 'Item_Delivery_Status',
	o.order_line_status 'Line_Status',
	o.storage_location 'Storage_Location',
	o.order_type 'Order_Type',
	iaf.salesoffice 'Transactional_Sales_Office',
	null 'PGI_Date',
	invoicedate 'Invoice_Date',
	invoicedate 'Blended_Date',
	iaf.glaccount 'GL_Account',
	case 
	when invoicetype is null then 'Bananas'
	else 'Invoiced - Direct'
	end as 'Ship_Status'

	from [EDW].[INVOICE] iaf
	left outer join 
	(select * from EDW.orders where active_sl = 'TRUE') o 
	on iaf.orderid = o.order_id and iaf.orderlineid = o.order_line_id

	where 
	iaf.salesoffice in ('STD', 'HYB', 'NTL', 'BDV', 'CTL', 'YRD')
	and [GLAccount] in ('0040100000','0040100050','0041009000','0041009050','0041008100','0041008150', '-1')
	and iaf.companyid in ('1100', 'YETI', '1500')
	and invoicedate > = '2017-01-01'


union all  
--ACE

select
-1 'Document',
-1 'Item',
SUBSTRING(al.CustomerID , PATINDEX('%[^0 ]%', al.CustomerID + ' '), LEN(al.CustomerID )) AS 'Sold_To_Party',
al.Customer 'Sold_To_Party_Name',
Manufacturer_id 'Material',
Eaches_Item 'Units',
case ph.pc
when 'hc' then eaches_cost/1.04
else eaches_cost/1.1 end 'Dollars',
null 'Header_Requested_Date',
null 'Line_Requested_Date',
null 'ATP_Influenced_Delivery_Date',
null 'PO_Number',
null 'Sales_Org',
null 'Header_Created_On',
null 'Header_Created_By',
null 'Blocked',
null 'Billing_Block',
null 'Delivery_Block',
null 'Credit_Status',
null 'Unconfirmed_Reason',
null 'Days_Stale',
null 'Item_Created_On',
null 'Item_Delivery_Status',
null 'Line_Status',
null 'Storage_Location',
null 'Order_Type',
'Indirect' as 'Transactional_Sales_Office',
null 'PGI_Date',
dateadd(day, 14, Year_Day) 'Invoice_Date',
dateadd(day, 14, Year_Day) 'Blended_Date',
null 'GL_Account',
'Invoiced - ACE' as 'Ship_Status'

from EDW.ace_sellthru ast
left outer join 
(select * from edw.ace_list al left outer join EDW.customer_dim cd on al.SAP_customer = cd.customerID) al
on ast.member_id = al.ace_member
left outer join edw.prodh ph
on manufacturer_id = material_code
where year_day >= '2017-01-01'

) S
On C.CustomerID = S.Sold_To_Party
left outer join edw.fiscalcalendar fc
on S.Line_Requested_Date = fc.date
left join edw.fiscalcalendar fisc
on fisc.[date] = convert(date, getdate())
left join edw.fiscalcalendar fc2
on fc2.[date] = s.Blended_Date
where SalesOffice in ('STD','HYB','NTL','BDV','CTL','YRD')
)
GO
