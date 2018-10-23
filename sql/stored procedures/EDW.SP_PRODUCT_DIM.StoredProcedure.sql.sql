USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_PRODUCT_DIM]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_PRODUCT_DIM] AS

/* =============================================
   ObjectName/type: Table
   Description: Central table for the Product information across the different databases in YETI
               
   Parameters: 
   Author: 
   Create date: 02/05/2017
   
   =============================================
   Change History
   ============================================= 
  
Date 	Author	Description
10/15/2018	Charan Eleti	Appended CategoryType and Productfamily as per request from Billy Minor.
		

   ============================================= */

if object_id('EDW.PRODUCT_DIM') is not null begin 
DROP TABLE EDW.PRODUCT_DIM end;

CREATE TABLE EDW.PRODUCT_DIM WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
Select SUBSTRING(K.PRODUCTID, PATINDEX('%[^0 ]%', K.PRODUCTID + ' '), LEN(K.PRODUCTID)) ProductID, 
K.PRODUCTID AS ProductIDOLD,
K.ProductDescription,
k.ProductFamily,
K.ProductCategory,
k.CategoryType,
case when R.[Needs_Master_SKU_fix]='TRUE' then R.[Master_SKU_fixed] else K.[MasterSKU] end AS MasterSKU,
case when R.[Needs_Color_fix]='TRUE' then R.[Color_fixed] else K.[Color] end AS Color,
case when R.[Needs_Product_Type_fix]='TRUE' then R.[Product_Type_fixed] else K.[ProductType] end AS ProductType,
K.CurrentFlag,
case when R.[Needs_iscore_fix]='TRUE' then R.[is_Core_Fixed] else COALESCE(K.[ISCore],'FALSE') end AS ISCore,
K.Variation,
K.NetWeight,
K.CommonSchool,
K.UPC,
K.Dimensions,
K.ProductHierarchyID,
K.SourceSystem 
FROM 
(
select [ProductID],
[ProductDescription],
case when [ProductID]='000000026010000014' then 'Outdoor Equipment'
	 when [ProductID]='000000026010000015' then 'Outdoor Equipment'
	 else COALESCE(ProductFamily,'-1')
end AS ProductFamily,
case when [ProductID]='000000026010000014' then 'Hard Cooler'
	 when [ProductID]='000000026010000015' then 'Hard Cooler'
	 else COALESCE([ProductCategory],'-1')
end AS [ProductCategory],
case when [ProductID]='000000026010000014' then 'Hard Cooler Core'
	 when [ProductID]='000000026010000015' then 'Hard Cooler Core'
	 else COALESCE(CategoryType,'-1')
end AS CategoryType,
case when [ProductID]='000000026010000014' then 'Tundra 45' 
	 when [ProductID]='000000026010000015' then 'Tundra 105'
	 else COALESCE([MasterSKU],'-1') 
end AS [MasterSKU],
case when [ProductID]='000000026010000014' then 'High Country' 
	 when [ProductID]='000000026010000015' then 'High Country'
	 else COALESCE([Color],'-1')
end AS [Color],
case when [ProductID]='000000026010000014' then 'Tundra' 
	 when [ProductID]='000000026010000015' then 'Tundra'
	 else COALESCE([ProductType],'-1')
end AS [ProductType],
CASE WHEN PRODUCTCATEGORY IS NULL AND PRODUCTID IN ( SELECT '0000000'+PD.PRODUCTID FROM YETIDM.PRODUCT PD WHERE '0000000'+PD.PRODUCTID=SAP.PRODUCTID ) THEN 'N' ELSE 'Y' END AS CurrentFlag,
[ISCORE] AS ISCore,
Variation,
NETWEIGHT as NetWeight,
CommonSchool,
UPC,
Dimensions,
COALESCE(ProductHierarchyID,'-1') AS ProductHierarchyID,
'SAP' as SourceSystem

From EDW_TZ.SAP_PRODUCT_DIM SAP
where sap.DistributionChannel='10'
and sap.SalesOrganization='1100'

union

select 
[ProductId],
[ProductDescription],
productfamily,
CASE WHEN upper(productdescription) like '% ICE %' AND PRODUCTCATEGORY='Gear Apparel ICE' THEN 'ICE'
WHEN PRODUCTCATEGORY='Gear Apparel Ice' THEN 'Gear & Apparel'
ELSE [productcategory] END AS productcategory,
null AS CategoryType,
[mastersku],
CASE WHEN color='BLACK' THEN 'Black'
     WHEN COLOR='BLK' THEN  'Black'
     WHEN COLOR='BLU' THEN 'Blue'
     WHEN COLOR='CAMO' THEN 'Camo'
     WHEN COLOR='FIELD TAN' THEN 'Field Tan'
     WHEN COLOR='FOG GRAY' THEN 'Fog Gray'
     WHEN COLOR='GRY' THEN 'Grey'
     WHEN COLOR='SEAFOAM' THEN 'Sea Foam' 
     WHEN COLOR='TAN' THEN 'Tan'
     WHEN COLOR='WHT' THEN 'White' 
ELSE color END AS Color,
[productype],
CASE WHEN PRODUCTCATEGORY IS NULL OR PRODUCTCATEGORY IN ( SELECT ProductCategory FROM YETIDMSAP.SAP_PRODUCT_DIM SAP WHERE SAP.ProductID='0000000'+EPI.PRODUCTID AND SAP.ProductCategory IS NOT NULL) THEN 'N' ELSE 'Y' END AS CurrentFlag,
NULL AS VARIATION,
'N/A' AS ISCORE,
Netweight as NetWeight,
NULL AS COMMONSCHOOL,
NULL AS UPC,
NULL AS DIMENSIONS,
'-1' AS ProductHierarchyID,
'Epicor' as Sourcesystem
from yetidm.product EPI
where '0000000'+productid NOT IN ( SELECT ProductID FROM yetidmsap.sap_product_DIM where ProductCategory is not null)
)K left Join (SELECT * FROM [yetistg].[Restated_product_dim] where SourceSystem_PRODUCT_DIM = 'Epicor') R ON K.PRODUCTID = R.ProductID_PRODUCT_DIM
WHERE K.CurrentFlag='Y'
);
GO
