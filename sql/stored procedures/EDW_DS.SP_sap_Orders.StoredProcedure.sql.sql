USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_DS].[SP_sap_Orders]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_DS].[SP_sap_Orders] AS

SET ANSI_NULLS ON

if object_id('EDW_DS.sap_Orders') is not null begin 
Drop table EDW_DS.sap_Orders end;
CREATE TABLE EDW_DS.sap_Orders WITH (DISTRIBUTION = ROUND_ROBIN ) as 
SELECT Orders.*, PRODUCT.*, CUSTOMER.*
FROM EDW.Orders Orders
INNER JOIN (SELECT CustomerID, City, State, Zipcode, Country, District FROM [EDW].[CUSTOMER_DIM]) CUSTOMER 
			ON Orders.Customer_ID = CUSTOMER.CustomerID
INNER JOIN (SELECT ProductID, ProductIDOLD, ProductCategory, MasterSKU, Color, CurrentFlag FROM [EDW].[PRODUCT_DIM] WHERE ISCore = 'TRUE') AS PRODUCT
			ON Orders.Product_ID = PRODUCT.ProductIDOLD
WHERE Active_SL = 'True' 
AND Rejection_Reason IS NULL
AND Sales_Office in ('STD','HYB')
AND Order_Type NOT IN ('ZARF', 'ZARM', 'ZEG2', 'ZERF', 'ZERM', 'ZRE')
AND Customer_Id NOT IN ('6610', '91860', '0000107894', '0000114883', '0000108654')
AND Req_Delivery_Date <= '2018-06-25'
--ORDER BY Order_Date ASC;

GO
