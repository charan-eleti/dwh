USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_RZ].[SP_demandware_tables]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_RZ].[SP_demandware_tables] AS

Drop EXTERNAL TABLE edw_rz.dw_Order_stg;
CREATE EXTERNAL TABLE edw_rz.dw_Order_stg
(
	[Email] [varchar](225) NULL,
	[Order_Number] [varchar](225) NULL,
	[Order_Status] [varchar](225) NULL,
	[Sku] [varchar](225) NULL,
	[Qty] [varchar](225) NULL,
	[Unit_Total] [varchar](225) NULL,
	[Discount_Amount] [varchar](225) NULL,
	[Order_Date] [varchar](225) NULL,
	[Customer_Id] [varchar](225) NULL,
	[Address_Line_1] [varchar](225) NULL,
	[Address_Line_2] [varchar](225) NULL,
	[City] [varchar](225) NULL,
	[State] [varchar](225) NULL,
	[Zip_Code] [varchar](225) NULL,
	[Country] [varchar](225) NULL,
	[Sales_group] [varchar](225) NULL,
	[Shipping_Method] [varchar](225) NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/dw_order_stg',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)


Drop EXTERNAL TABLE edw_rz.dw_customer_stg;
CREATE EXTERNAL TABLE edw_rz.dw_customer_stg
(
CustomerNo [varchar](225) NULL,
Email [varchar](225) NULL,
FirstName [varchar](225) NULL,
LastName [varchar](225) NULL,
CustomerGroup [varchar](225) NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/dw_customer_stg',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)

Drop EXTERNAL TABLE edw_rz.dw_coupons_stg;
CREATE EXTERNAL TABLE edw_rz.dw_coupons_stg
(
OrderID [varchar](225)NULL,
CouponCode [varchar](225)NULL,
ProgramDescription [varchar](225)NULL,
SKU [varchar](225)NULL,
Quantity [varchar](225)NULL,
GrossRevenue [varchar](225)NULL,
Discount [varchar](225)NULL,
NetRevenue [varchar](225)NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/dw_coupon_stg',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)


Drop EXTERNAL TABLE edw_rz.dw_instock_stg;
CREATE EXTERNAL TABLE edw_rz.dw_instock_stg
(
ProductName [varchar](225) NULL,
ProductSKU [varchar](225) NULL,
Email [varchar](225) NULL,
SignupDate [varchar](225) NULL,
CountofEmailsSent [varchar](225) NULL,
MostRecentInStockEmailSentDate [varchar](225) NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/dw_instock_stg',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)

Drop EXTERNAL TABLE edw_rz.dw_product_stg;
CREATE EXTERNAL TABLE edw_rz.dw_product_stg
(
Name [varchar](225) NULL,
ProductCategory [varchar](225) NULL,
SKU [varchar](225) NULL,
Price [varchar](225) NULL,
Inventory [varchar](225) NULL
)
WITH (DATA_SOURCE = [AzureStoragedl01-devhiveblob],LOCATION = N'/hive/warehouse/edw_sz.db/dw_product_stg',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)


GO
