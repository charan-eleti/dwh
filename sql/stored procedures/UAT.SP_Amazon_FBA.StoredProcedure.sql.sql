USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [UAT].[SP_Amazon_FBA]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [UAT].[SP_Amazon_FBA] AS

if object_id('EDW_RZ.Amazon_FBA') is not null begin 
DROP EXTERNAL TABLE [EDW_RZ].[Amazon_FBA] end;

CREATE EXTERNAL TABLE [EDW_RZ].[Amazon_FBA]
(
	[amazon_order_id] [nvarchar](255) NULL,
	[merchant_order_id] [nvarchar](255) NULL,
	[shipment_id] [nvarchar](255) NULL,
	[shipment_item_id] [nvarchar](255) NULL,
	[amazon_order_item_id] [nvarchar](255) NULL,
	[merchant_order_item_id] [nvarchar](255) NULL,
	[purchase_date] [nvarchar](255) NULL,
	[payments_date] [nvarchar](255) NULL,
	[shipment_date] [nvarchar](255) NULL,
	[reporting_date] [nvarchar](255) NULL,
	[buyer_email] [nvarchar](255) NULL,
	[buyer_name] [nvarchar](255) NULL,
	[buyer_phone_number] [nvarchar](255) NULL,
	[sku] [nvarchar](255) NULL,
	[product_name] [nvarchar](255) NULL,
	[quantity_shipped] [nvarchar](255) NULL,
	[currency] [nvarchar](255) NULL,
	[item_price] [nvarchar](255) NULL,
	[item_tax] [nvarchar](255) NULL,
	[shipping_price] [nvarchar](255) NULL,
	[shipping_tax] [nvarchar](255) NULL,
	[gift_wrap_price] [nvarchar](255) NULL,
	[gift_wrap_tax] [nvarchar](255) NULL,
	[ship_service_level] [nvarchar](255) NULL,
	[recipient_name] [nvarchar](255) NULL,
	[ship_address_1] [nvarchar](255) NULL,
	[ship_address_2] [nvarchar](255) NULL,
	[ship_address_3] [nvarchar](255) NULL,
	[ship_city] [nvarchar](255) NULL,
	[ship_state] [nvarchar](255) NULL,
	[ship_postal_code] [nvarchar](255) NULL,
	[ship_country] [nvarchar](255) NULL,
	[ship_phone_number] [nvarchar](255) NULL,
	[bill_address_1] [nvarchar](255) NULL,
	[bill_address_2] [nvarchar](255) NULL,
	[bill_address_3] [nvarchar](255) NULL,
	[bill_city] [nvarchar](255) NULL,
	[bill_state] [nvarchar](255) NULL,
	[bill_postal_code] [nvarchar](255) NULL,
	[bill_country] [nvarchar](255) NULL,
	[item_promotion_discount] [nvarchar](255) NULL,
	[ship_promotion_discount] [nvarchar](255) NULL,
	[carrier] [nvarchar](255) NULL,
	[tracking_number] [nvarchar](255) NULL,
	[estimated_arrival_date] [nvarchar](255) NULL,
	[fulfillment_center_id] [nvarchar](255) NULL,
	[fulfillment_channel] [nvarchar](255) NULL,
	[sales_channel] [nvarchar](255) NULL
)
WITH (DATA_SOURCE = [AzureDataLakeStoreyetidpe3600],LOCATION = N'/hive/warehouse/edw.db/amazon_sellthru',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;

if object_id('UAT.Amazon_FBA') is not null begin 
DROP TABLE UAT.Amazon_FBA end;

CREATE TABLE UAT.Amazon_FBA WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
select * from [EDW_RZ].[Amazon_FBA]
);

GO
