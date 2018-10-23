USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_receiveplan]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_receiveplan] AS

if object_id('yetidm.receiveplan') is not null begin 
Drop table yetidm.receiveplan end; 
create table yetidm.Receiveplan WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT 
  coalesce(case when ltrim(rtrim(p.PartNum)) = '' then NULL else p.PartNum end,'-1') as ProductId
  ,rcptmonth
  ,rcptyear
  ,rcptweek
  ,max(c.datekey) enddatekey
  ,min(c.datekey) startdatekey
  ,case when charindex(' ',rcptsku) > 0 then substring(replace(rcptsku,' ',''), 0,charindex(' ',rcptsku)) else rcptsku end rcptsku
  ,max(arrivalplan) arrivalplan
  FROM yetistg.Erp_receiptsplan_stg rp
left join yetistg.erp_calendardim_stg c on c.month = rp.rcptmonth
and c.year = rp.rcptyear 
and c.isoweekofyear = rp.rcptweek 
left join (select max(p.partnum) partnum, p.searchword from yetistg.erp_part_stg p group by p.searchword) p on upper(ltrim(rtrim(p.searchword))) = case when charindex(' ',rcptsku) > 0 then substring(replace(rcptsku,' ',''), 0,CHARINDEX(' ',rcptsku)) else rcptsku end
group by p.partnum, c.month, c.year, c.isoweekofyear, rp.rcptmonth, rp.rcptyear, rp.rcptweek, rcptsku;

GO
