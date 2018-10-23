USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_OrderReportState]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_OrderReportState] AS

if object_id('yetidm.OrderReportState') is not null begin 
Drop table yetidm.OrderReportState end;
create table yetidm.OrderReportState WITH (DISTRIBUTION = ROUND_ROBIN ) as
select distinct o.ordernum, o.ShipToStateSelect ShiptoStateSelectOriginal, coalesce(case when cs.mastercode = '' then NULL else cs.mastercode end, 'UNKNOWN') as ShipToStateSelectFinal,
coalesce(case when cs.mastercode = '' then NULL else o.ShipToZipSelect end, 'UNKNOWN') as ShipToZipSelectFinal,
coalesce(case when cs.mastercode = '' then NULL else o.ShipToNameSelect end, 'UNKNOWN') as ShipToNameSelectFinal
from yetistg.orderoriginalreportstatestg o
left join yetistg.erp_countrystatetables_stg cs on lower(o.ShipToStateSelect) = replace(ltrim(rtrim(lower(cs.name))),'"','');

GO
