USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_Orderhistfact]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_Orderhistfact] AS

if object_id('yetidm.Orderhistfact') is not null begin 
Drop table yetidm.OrderHistFact end; 
create table yetidm.OrderhistFact WITH (DISTRIBUTION = ROUND_ROBIN ) as
select od.ordernum as orderid, od.orderline as orderlineid, od.ordernum, od.orderline, case when isnumeric(od.partnum) = 1 then cast(od.partnum as decimal(38,0)) else cast('-1' as bigint) end partnum
,case when isdate(od.needbydate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.needbydate)) as date), 126) as date) else NULL end needbydate
,case when isdate(od.changedate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(od.changedate)) as date), 126) as date) else NULL end changedate
,case when isdate(od.requestdate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(od.requestdate)) as date), 126) as date) else NULL end requestdate
,cast(convert(char(10), cast(ltrim(rtrim(nu.needbydate)) as date), 126) as date) priorneedbydate
,cast(convert(char(10), cast(ltrim(rtrim(nu.requestdate)) as date), 126) as date)  priorrequestdate
,od.orderqty, od.unitprice, nu.sellingqty priorqty
,case when cast(convert(char(10), cast(ltrim(rtrim(nu.needbydate)) as date), 126) as date) < case when isdate(od.needbydate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.needbydate)) as date), 126) as date) else NULL end then 1 else 0 end needbydelayed
,case when cast(convert(char(10), cast(ltrim(rtrim(nu.needbydate)) as date), 126) as date) > case when isdate(od.needbydate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.needbydate)) as date), 126) as date) else NULL end then 1 else 0 end needbyearlier
,case when cast(convert(char(10), cast(ltrim(rtrim(nu.requestdate)) as date), 126) as date) < case when isdate(od.requestdate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.requestdate)) as date), 126) as date) else NULL end then 1 else 0 end requestdelayed
,case when cast(convert(char(10), cast(ltrim(rtrim(nu.requestdate)) as date), 126) as date) > case when isdate(od.requestdate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.requestdate)) as date), 126) as date) else NULL end then 1 else 0 end requestearlier
,case when nu.sellingqty < od.orderqty then 1 else 0 end qtyincrease
,case when nu.sellingqty > od.orderqty then 1 else 0 end qtydecrease
from yetistg.erp_orderdtl_stg od 
inner join (select nu.*, 
cast('1999-01-01' as date) changedate
from yetistg.erp_nuorder_stg nu) nu on nu.ordernum = od.ordernum and nu.orderline = od.orderline and nu.partnum = case when isnumeric(od.partnum) = 1 then cast(od.partnum as decimal(38,0)) else cast('-1' as bigint) end
where (cast(nu.sellingqty as int) <> od.orderqty or 
cast(convert(char(10), cast(ltrim(rtrim(nu.needbydate)) as date), 126) as date) <> case when isdate(od.needbydate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.needbydate)) as date), 126) as date) else NULL end or 
cast(convert(char(10), cast(ltrim(rtrim(nu.requestdate)) as date), 126) as date) <> case when isdate(od.requestdate) = 1 then cast(convert(char(10), cast(ltrim(rtrim(od.requestdate)) as date), 126) as date) else NULL end)
and nu.ordernum not in (select distinct ordernum from yetistg.vw_orderhist_stg)
UNION ALL
select * from yetistg.vw_orderhist_stg;
GO
