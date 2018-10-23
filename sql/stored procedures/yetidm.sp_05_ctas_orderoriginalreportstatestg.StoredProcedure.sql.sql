USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_05_ctas_orderoriginalreportstatestg]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_05_ctas_orderoriginalreportstatestg] AS

if object_id('yetistg.orderoriginalreportstatestg') is not null begin 
Drop table yetistg.orderoriginalreportstatestg end;
create table yetistg.orderoriginalreportstatestg WITH (DISTRIBUTION = ROUND_ROBIN ) as
select distinct coalesce(case when o.OrderNum = 0 then NULL else o.OrderNum end,-1) as OrderNum,
o.shiptocustnum, o.custnum, o.otsstate, o.otszip, o.otsname, st.state ststate, st.zip stzip, st.name stname, c.btstate, c.btzip, c.btname, c.state custstate, c.zip custzip, c.name custname,
coalesce(case when len(ltrim(rtrim(o.otsstate))) < 2 then NULL else o.otsstate end, case when len(ltrim(rtrim(st.state))) < 2 then NULL else st.state end, coalesce(case when len(ltrim(rtrim(c.btstate))) < 2 then NULL else c.btstate end, case when len(ltrim(rtrim(c.state))) < 2 then NULL else c.state end, 'UNKNOWN')) as ShipToStateSelect,
coalesce(case when len(ltrim(rtrim(o.otsstate))) < 2 then NULL else o.otszip end, case when len(ltrim(rtrim(st.state))) < 2 then NULL else st.zip end, coalesce(case when len(ltrim(rtrim(c.btstate))) < 2 then NULL else c.btzip end, case when len(ltrim(rtrim(c.state))) < 2 then NULL else c.zip end, 'UNKNOWN')) as ShipToZipSelect,
coalesce(case when len(ltrim(rtrim(o.otsstate))) < 2 then NULL else o.otsname end, case when len(ltrim(rtrim(st.state))) < 2 then NULL else st.name end, coalesce(case when len(ltrim(rtrim(c.btstate))) < 2 then NULL else c.btname end, case when len(ltrim(rtrim(c.state))) < 2 then NULL else c.name end, 'UNKNOWN')) as ShipToNameSelect
from yetistg.erp_orderhed_stg o 
left join yetistg.erp_customer_stg c on c.custnum = case when (o.shiptocustnum = 0 or o.shiptocustnum is null) then o.custnum else o.shiptocustnum end
left join yetistg.erp_shipto_stg st on st.ShipToNum = o.ShipToNum and st.custnum = c.custnum;
GO
