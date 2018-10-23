USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_EPI_Orderfact]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_EPI_Orderfact] AS

if object_id('EDW_TZ.EPI_Orderfact') is not null begin 
Drop table EDW_TZ.EPI_Orderfact end;
create table EDW_TZ.EPI_Orderfact WITH (DISTRIBUTION = HASH (orderid), CLUSTERED INDEX (orderid, orderlineid, needbydatekey)) as
SELECT 
      coalesce(case when od.OrderNum = 0 then NULL else od.OrderNum end,-1) as OrderId
      ,coalesce(case when od.OrderLine = 0 then NULL else od.OrderLine end,-1) as OrderLineId
      ,coalesce(case when sd.orderrelnum = 0 then NULL else sd.orderrelnum end,-1) as OrderRelId
      ,coalesce(case when ltrim(rtrim(od.Company)) = '' then NULL else od.Company end,'-1') as CompanyId
      ,coalesce(case when ltrim(rtrim(od.PartNum)) = '' then NULL else od.PartNum end,'-1') as ProductId
      ,coalesce(case when ltrim(rtrim(c.SalesRepCode)) = '' then NULL else c.SalesRepCode end,'-1') as SalesRepId
      ,coalesce(case when ltrim(rtrim(od.salescatid)) = '' then NULL else od.salescatid end,'-1') as SalesCatId
      ,coalesce(case when ltrim(rtrim(c.GroupCode)) = '' then NULL else case when c.GroupCode = 'OEM' and c.custnum = 26575 then 'RAMBLERON' else c.GroupCode end end,'-1') as SalesChannelId
      ,coalesce(case when ltrim(rtrim(c.TerritoryId)) = '' then NULL else c.TerritoryId end,'-1') as TerritoryId
      ,CAST(Coalesce(but000.Partner,od.CustNum) as char) as CustomerId
	  ,CAST(oh.BtCustNum AS CHAR) AS BtCustNum
      ,coalesce(case when dt.DateKey = 0 then NULL else dt.DateKey end,-1) as OrderDateKey
      ,coalesce(case when dt2.DateKey = 0 then NULL else dt2.DateKey end,-1) as NeedByDateKey
      ,coalesce(case when dt3.DateKey = 0 then NULL else dt3.DateKey end,-1) as ShipDateKey
      ,coalesce(case when dt4.DateKey = 0 then NULL else dt4.DateKey end,-1) as RequestDateKey
      ,CAST(coalesce(case when sd.PackNum = 0 then NULL else sd.PackNum end,-1) as CHAR) as ShipId
      ,sd.OrderRelNum
      ,od.OrderQty
	  ,od.UnitPrice
      ,od.ExtPriceDtl
	  ,oh.PONum
	  ,CAST(coalesce(LTRIM(RTRIM(oh.ShipToCustNum)),'-1') AS CHAR) AS ShipToCustNum
	  ,CAST(coalesce(oh.shiptonum,'-1') AS CHAR) as ShipToNum
      ,oh.OrderStatus
      ,case when od.OpenLine = 0 and (sh.ShipStatus is null or upper(sh.ShipStatus) in ('OPEN','VOID')) then 1 else 0 end as CancelledFlag
	  ,rma.ReturnReasonCode as ReasonforReturn
	  ,case when rma.rmanum is not null and rma.rmanum > 0 then 1 else 0 end as ReturnCount
      ,case when rma.rmanum is not null and rma.rmanum > 0 then extpricedtl else 0 end as ReturnPrice
      ,case when rma.rmanum is not null and rma.rmanum > 0 then rma.returnqty else 0 end as ReturnQty
	  ,oh.useots as UseOTS
	  ,oh.otsname as OTSName
      ,oh.otsaddress1 as OTSAddress1
      ,oh.OTSAddress2 as OTSAddress2
      ,oh.OTSAddress3 as OTSAddress3
      ,oh.OTSCity as OTSCity
      ,oh.OTSContact as OTSContact
      ,oh.OTSCountryNum as OTSCountryNum
      ,oh.OTSFaxNum as OTSFaxNum
      ,oh.OTSPhoneNum as OTSPhoneNum
      ,oh.OTSResaleID as OTSResaleID
      ,oh.otsstate as OTSState
      ,oh.OTSZIP as OTSZip
      ,od.ChangedBy as ChangedBy
      ,case when isdate(od.ChangeDate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(od.ChangeDate)) as date), 126) as date) else NULL end as ChangeDate
      ,od.ChangeTime as ChangeTime
      ,od.SysRevID as SysRevID
      ,od.SysRowID as SysRowID
      ,'Epicor' as SourceSystem
FROM yetistg.erp_orderdtl_stg od 
right join yetistg.erp_orderhed_stg oh on oh.ordernum = od.ordernum 
inner join yetistg.erp_calendardim_stg dt on dt.caldate = case when isdate(oh.OrderDate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(oh.OrderDate)) as date), 126) as date) else NULL end
left join yetistg.erp_calendardim_stg dt2 on dt2.caldate = case when isdate(od.NeedByDate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(od.NeedByDate)) as date), 126) as date) else NULL end
left join yetistg.erp_calendardim_stg dt4 on dt4.caldate = case when isdate(od.requestdate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(od.requestdate)) as date), 126) as date) else NULL end
inner join yetistg.erp_customer_stg c on c.custnum = od.custnum
left join yetistgsap.sap_but000_stg but000 on but000.bu_sort2 = c.CustID and BPKIND = 'SP' and BU_GROUP = 'SP'
left join (
select orel.ordernum, orel.orderline, max(orel.orderrelnum) orderrelnum, max(sd.packnum) packnum from yetistg.erp_orderrel_stg orel 
left join yetistg.erp_shipdtl_stg sd on sd.OrderNum = orel.OrderNum And sd.OrderLine = orel.OrderLine and sd.orderrelnum = orel.orderrelnum
group by orel.ordernum, orel.orderline) sd on sd.ordernum = od.ordernum and sd.orderline = od.orderline
left outer join yetistg.erp_ShipHead_stg sh on sd.PackNum = sh.PackNum
left join yetistg.erp_calendardim_stg dt3 on dt3.caldate = case when isdate(sh.shipdate) = 1  then cast(convert(char(10), cast(ltrim(rtrim(sh.shipdate)) as date), 126) as date) else NULL end
left outer join (select * from (select *, row_number() over (partition by r4.ordernum, r4.orderline order by r4.changedate desc) rn from yetistg.erp_rmadtl_stg r4) r3 where r3.rn = 1) rma 
on rma.ordernum = od.ordernum and rma.orderline = od.orderline
;
GO
