USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_NST_Product_Dim]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_NST_Product_Dim] AS

if object_id('EDW_TZ.NST_Product_Dim ') is not null begin
Drop TABLE EDW_TZ.NST_Product_Dim end;

Create Table EDW_TZ.NST_Product_Dim WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(select name AS Name,
full_name AS Full_Name,
Cast(CAST(Item_id As Decimal(10,1)) AS Int) Item_Id,
type_name,
RO_MAGSLIDER_LID,
RO_product_color_id,
RO_item_product_categories_id,
Case when RO_IS_PREMADE_EMBELLISHMENT = '\N' then Null else RO_IS_PREMADE_EMBELLISHMENT end As RO_IS_PREMADE_EMBELLISHMENT,
Case when RO_ITEM_IS_PREMIUM = '\N' then Null else RO_ITEM_IS_PREMIUM end As RO_ITEM_IS_PREMIUM,
Case 
	When name Like '%Boomer 8%' Then 'Gear & Apparel'
	When name Like '%Colster%' Then 'Drinkware'
	When name Like '%Wine%' Then 'Drinkware'
	When name Like '%Lowball%' Then 'Drinkware'
	When name Like '%12oz%' Then 'Drinkware'
	When name Like '%Mug%' Then 'Drinkware'
	When name Like '%pint%' then 'Drinkware'
	When name Like '%18oz%' Then 'Drinkware'
	When name Like '%128oz%' Then 'Drinkware'
	When name Like '%20oz%' Then 'Drinkware'
	When name Like '%26oz%' Then 'Drinkware'
	When name Like '%30oz%' Then 'Drinkware'
	When name Like '%36oz%' Then 'Drinkware'
	When name Like '%64oz%' Then 'Drinkware'
Else 'Not Found' End AS ProductCategory,
Case
	When name Like '%Boomer 8%' Then 'Other'
	When name Like '%Colster%' Then 'Drinkware'
	When name Like '%Wine%' Then 'Drinkware'
	When name Like '%Lowball%' Then 'Drinkware'
	When name Like '%12oz%' Then 'Drinkware'
	When name Like '%Mug%' Then 'Drinkware'
	When name Like '%pint%' then 'Drinkware'
	When name Like '%18oz%' Then 'Drinkware'
	When name Like '%128oz%' Then 'Drinkware'
	When name Like '%20oz%' Then 'Drinkware'
	When name Like '%26oz%' Then 'Drinkware'
	When name Like '%30oz%' Then 'Drinkware'
	When name Like '%36oz%' Then 'Drinkware'
	When name Like '%64oz%' Then 'Drinkware'
Else 'Not Found' End AS ProductFamily,
CASE 
	When name Like '%Boomer 8%' Then 'Pets'
	When name Like '%Colster%' Then 'Drinkware Core'
	When name Like '%Wine%' Then 'Drinkware Core'
	When name Like '%Lowball%' Then 'Drinkware Core'
	When name Like '%12oz%' Then 'DW Core - Bottles'
	When name Like '%Mug%' Then 'Drinkware Core'
	When name Like '%pint%' then 'Drinkware Core'
	When name Like '%18oz%' Then 'DW Core - Bottles'
	When name Like '%128oz%' Then 'DW Core - Jugs'
	When name Like '%20oz%' Then 'Drinkware Core'
	When name Like '%26oz%' Then 'DW Core - Bottles'
	When name Like '%30oz%' Then 'Drinkware Core'
	When name Like '%36oz%' Then 'DW Core - Bottles'
	When name Like '%64oz%' Then 'DW Core - Bottles'
	Else 'Not Found' End as CategoryType,
Case
	When name Like '%12oz%' Then '12oz Bottle'
	When name Like '%18oz%' Then '18oz Bottle'
	When name Like '%26oz%' Then '26oz Bottle'
	When name Like '%36oz%' Then '36oz Bottle'
	When name Like '%64oz%' Then '64oz Bottle'
	When name Like '%128oz%' Then '128oz Bottle'
	When name Like '%20oz%' Then '20oz Tumbler'
	When name Like '%30oz%' Then '30oz Tumbler'
	When name Like '%Colster%' Then 'Colster'
	When name Like '%Lowball%' Then 'Lowball'
	When name Like '%Mug%' Then 'Mug'
	When name Like '%Wine%' Then 'Wine'
	when name like '%Boomer 8%' Then 'Dog Bowl'
Else 'Not Found' End as SKU,
Case
	When name Like '%12oz%' Then 'R12 Bottle'
	When name Like '%18oz%' Then 'R18 Bottle'
	When name Like '%26oz%' Then 'R26 Bottle'
	When name Like '%36oz%' Then 'R36 Bottle'
	When name Like '%64oz%' Then 'R64 Bottle'
	When name Like '%128oz%' Then 'R1G Jug'
	When name Like '%20oz%' Then 'R20 Tumbler'
	When name Like '%30oz%' Then 'R30 Tumbler'
	When name Like '%Colster%' Then 'R Colsters'
	When name Like '%Lowball%' Then 'R10 Lowball'
	When name Like '%Mug%' Then 'R14 Mug'
	When name Like '%Wine%' Then 'R Wine'
	when name like '%Boomer 8%' Then 'Boomer 8 Dog Bowl'
	when name like '%pint%' then 'R16 Pint'
Else 'Not Found' End as MasterSKU,
Case
	when RO_product_color_id = '1.0' Then 'StainlessSteel'
	when RO_product_color_id = '2.0' Then 'Black'
	when RO_product_color_id = '3.0' Then 'Tahoe Blue'
	when RO_product_color_id = '4.0' Then 'Seafoam'
	when RO_product_color_id = '5.0' Then 'Olive Green'
	when RO_product_color_id = '6.0' Then 'Pink'
	when RO_product_color_id = '7.0' Then 'Brick Red'
	when RO_product_color_id = '12.0' Then 'Navy'
	when RO_product_color_id = '9.0' Then 'White'
	when RO_product_color_id = '10.0' Then 'Coral'
	when RO_product_color_id = '8.0' Then 'Sky Blue'
	when RO_product_color_id = '11.0' Then 'Charcoal'
	when RO_product_color_id = '13.0' Then 'Harbor Pink'
Else 'StainlessSteel' End as Color,
Case
	When name Like '%Boomer 8%' Then 'Bowls'
	When name Like '%Colster%' Then 'Colster'
	When name Like '%Wine%' Then 'Cups'
	When name Like '%Lowball%' Then 'Cups'
	When name Like '%12oz%' Then 'Bottles'
	When name Like '%Mug%' Then 'Cups'
	When name Like '%pint%' then 'Cups'
	When name Like '%18oz%' Then 'Bottles'
	When name Like '%128oz%' Then 'Jugs'
	When name Like '%20oz%' Then 'Cups'
	When name Like '%26oz%' Then 'Bottles'
	When name Like '%30oz%' Then 'Cups'
	When name Like '%36oz%' Then 'Bottles'
	When name Like '%64oz%' Then 'Bottles'
Else 'Not Found' End as ProductType
from EDW_RZ.NST_Items