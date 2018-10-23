USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_EDIFICEFACT]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_EDIFICEFACT] AS

if object_id('EDW.EDIFICEFACT') is not null begin 
Drop table EDW.EDIFICEFACT end;
create table EDW.EDIFICEFACT
WITH (DISTRIBUTION = HASH (customerid), CLUSTERED INDEX (weekending, customerid, productid)) 
AS
select coalesce(case when e.CustNum = '0' or e.custnum = '\N'  then NULL else e.CustNum end, '-1') as CustomerId,
coalesce(case when ltrim(rtrim(p.PART_NUMBER)) = '' then NULL else p.PART_NUMBER end,'-1') as ProductId,
(case when lm.Door_type is null and e.retailer = 'BASS PRO SHOP' Then 'Bad' Else Null end) as retailerid,
weekending, 
retailer, 
storenumber, 
e.upc, 
qs AS Units, 
xr AS extprice, 
qa AS endingonhand, 
qr AS receipts, 
qu AS [returns], 
flag, 
lm.[Buying_Group],
lm.[Account],
lm.[Store_Number],
lm.[Store_Name],
lm.[Address1],
lm.[Address2],
lm.[City],
lm.[State],
lm.[ZipCode],
lm.[OpenDate],
lm.[CloseDate],
lm.[Mall],
lm.[LocationReporting],
lm.[Door_Type],
lm.[Store_Type],
lm.[Channel],
lm.[Door_Region],
lm.[Customer_Type]
from EDW_SZ.edifice e
LEFT JOIN EDW_RZ.sps_part_stg p on e.upc=p.upc
left join EDW_RZ.locationmaster lm on e.storenumber=lm.store_number and UPPER(e.retailer)=UPPER(lm.buying_group)
GO
