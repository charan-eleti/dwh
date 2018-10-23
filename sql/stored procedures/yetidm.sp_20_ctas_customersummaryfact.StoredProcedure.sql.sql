USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_20_ctas_customersummaryfact]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_20_ctas_customersummaryfact] AS

if object_id('yetidm.customersummaryfact') is not null begin 
Drop table yetidm.customersummaryfact end;
create table yetidm.customersummaryfact WITH (DISTRIBUTION = ROUND_ROBIN ) as
 select state,city, zip,groupcode, count(distinct c.custnum) custcount, count(o.ordernum) custordercount 
from yetistg.erp_customer_stg c 
 left outer join yetistg.erp_orderhed_stg o on o.custnum = c.custnum
 group by state,city,zip, groupcode;
GO
