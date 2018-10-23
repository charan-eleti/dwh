USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_AmazonSellThrough]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_AmazonSellThrough] AS

if object_id('EDW.AmazonSellThrough') is not null begin 
DROP TABLE EDW.AmazonSellThrough end;

CREATE TABLE EDW.AmazonSellThrough WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select
amazon_order_id as amazon_order_id,
merchant_order_id as merchant_order_id,
shipment_id as shipment_id,
shipment_item_id as shipment_item_id,
amazon_order_item_id as amazon_order_item_id,
merchant_order_item_id as merchant_order_item_id,
convert(datetime2,purchase_date) as purchase_date,
convert(datetime2,payments_date) as payments_date,
convert(datetime2,shipment_date) as shipment_date,
convert(datetime2,reporting_date) as reporting_date,
buyer_email as buyer_email,
buyer_name as buyer_name,
buyer_phone_number as buyer_phone_number,
sku as sku,
product_name as product_name,
convert(decimal(20,10),quantity_shipped) as quantity_shipped,
currency,
convert(decimal(20,10),item_price) as item_price,
convert(decimal(20,10),item_tax) as item_tax,
convert(decimal(20,10),shipping_price) as shipping_price,
convert(decimal(20,10),shipping_tax) as shipping_tax,
convert(decimal(20,10),gift_wrap_price) as gift_wrap_price,
convert(decimal(20,10),gift_wrap_tax) as gift_wrap_tax,
ship_service_level as ship_service_level,
recipient_name as recipient_name,
ship_address_1 as ship_address_1,
ship_address_2 as ship_address_2,
ship_address_3 as ship_address_3,
ship_city as ship_city,
ship_state as ship_state,
ship_postal_code as ship_postal_code,
ship_country as ship_country,
ship_phone_number as ship_phone_number,
bill_address_1 as bill_address_1,
bill_address_2 as bill_address_2,
bill_address_3 as bill_address_3,
bill_city as bill_city,
bill_state as bill_state,
bill_postal_code as bill_postal_code,
bill_country as bill_country,
convert(decimal(20,10),item_promotion_discount) as item_promotion_discount,
convert(decimal(20,10),ship_promotion_discount) as ship_promotion_discount,
carrier as carrier,
tracking_number as tracking_number,
convert(datetime2,estimated_arrival_date) as estimated_arrival_date,
fulfillment_center_id as fulfillment_center_id,
fulfillment_channel as fulfillment_channel,
sales_channel as sales_channel
from [EDW_RZ].Amazon_FBA
)
GO
