USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_product]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_product] AS

if object_id('yetidm.product') is not null  begin
Drop table yetidm.product end;
create table yetidm.product WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT p.PartNum as ProductId
      ,p.Company as CompanyId
      ,p.SearchWord
      ,p.PartDescription as ProductDescription
      ,p.ProdCode as ProductGroupCode
      ,pg.Description as ProductGroupDesc
	,case when upper(ltrim(rtrim(m.mastersku_to))) = '' or m.mastersku_to is null then 
		case when upper(ltrim(rtrim(ps.shortchar04))) = '' or ps.shortchar04 is null then 
			case when upper(ltrim(rtrim(pu.shortchar04))) = '' or pu.shortchar04 is null then 'UNKNOWN' else upper(ltrim(rtrim(pu.shortchar04))) end
		else upper(ltrim(rtrim(ps.shortchar04))) end
	else upper(ltrim(rtrim(m.mastersku_to))) 
	end  as mastersku      
	,case when ltrim(rtrim(ps.productfamily)) = '' or ps.productfamily is null then 
         case when lower(pu.shortchar02) like 'drink%' then 'Drinkware' 
		when lower(pu.shortchar02) like 'soft%' then 'Outdoor Equipment'
		when lower(pu.shortchar02) like 'hard%' then 'Outdoor Equipment'
         else
	 	'Other'
         end
	 else ps.productfamily end as productfamily
      ,case when ltrim(rtrim(ps.productcategory)) = '' or ps.productcategory is null then 
        case when lower(pu.shortchar04) like 'yr%' or 
		  (lower(pu.shortchar04) like 'yt%' or lower(pu.shortchar04) like '%tundra%') or 
		  (lower(pu.shortchar04) like 'tun%' or lower(pu.shortchar04) like 'tundra%') or
		  ((lower(pu.shortchar04) like '%tank%' and lower(pu.shortchar04) not like '%tank top%') or (lower(pu.shortchar04) like 'yt%' ))
		  Then 'Hard Cooler'
		when lower(pu.shortchar04) like '%hopper%' then 'Soft Cooler'
		when lower(pu.shortchar04) like '%hop%' then 'Soft Cooler'
		when lower(pu.shortchar04) like 'rambler%' or lower(pu.shortchar04) like 'tumbler%' or lower(pu.shortchar04) like '%ram%'
		or lower(pu.shortchar04) like '%colster%' or (lower(pu.shortchar04) like '%bottle%' and lower(pu.shortchar04) not like '%bottle key%') or lower(pu.shortchar04) like '%jug%' then 'Drinkware'
		when lower(pu.shortchar04) like '%ice%' then 'Ice'
		when lower(pu.shortchar04) like '%gear%' or lower(pu.shortchar04) like '%shirts%' or lower(pu.shortchar04) like 'slides%' 
		or lower(pu.shortchar04) like '%access%' or lower(pu.shortchar04) like '%bait%'	or lower(pu.shortchar04) like 'baskets%' 
		or lower(pu.shortchar04) like 'cushion%' or lower(pu.shortchar04) like '%lock%' or lower(pu.shortchar04) like 'brack%' 
		or lower(pu.shortchar04) like 'seadek%' or lower(pu.shortchar04) like 'dividers%' or lower(pu.shortchar04) like 'handles%'
		or lower(pu.shortchar04) like 'stickers%' or lower(pu.shortchar04) like 'drink acc%' or lower(pu.shortchar04) like 'botop%'
		or lower(pu.shortchar04) like 'belt%' then 'Gear Apparel Accessories'

		else
		'Other'
        end
         else ps.productcategory end as productcategory
     ,case when lower(ps.mastersku) like 'yr%' or 
		  (lower(ps.mastersku) like 'yt%' or lower(ps.mastersku) like '%tundra%') or 
		  (lower(ps.mastersku) like 'tun%' or lower(ps.mastersku) like 'tundra%') or
		  ((lower(ps.mastersku) like '%tank%' and lower(ps.mastersku) not like '%tank top%') or (lower(ps.mastersku) like 'yt%' ))
		  Then 'Hard Coolers'
		when lower(ps.mastersku) like '%hopper%' then 'Soft Cooler'
		when lower(ps.mastersku) like '%hop%' then 'Soft Cooler'
		when lower(ps.mastersku) like 'rambler%' or lower(ps.mastersku) like 'tumbler%' or lower(pu.shortchar04) like '%ram%'
		or lower(ps.mastersku) like '%colster%' or (lower(ps.mastersku) like '%bottle%' and lower(ps.mastersku) not like '%bottle key%') or lower(ps.mastersku) like '%jug%' then 'Drinkware'
		when lower(ps.mastersku) like '%ice%' then 'Ice'
		when lower(ps.mastersku) like '%gear%' or lower(ps.mastersku) like '%shirts%' or lower(ps.mastersku) like 'slides%' 
		or lower(ps.mastersku) like '%access%' or lower(ps.mastersku) like '%bait%'	or lower(ps.mastersku) like 'baskets%' 
		or lower(ps.mastersku) like 'cushion%' or lower(ps.mastersku) like '%lock%' or lower(ps.mastersku) like 'brack%' 
		or lower(ps.mastersku) like 'seadek%' or lower(ps.mastersku) like 'dividers%' or lower(ps.mastersku) like 'handles%'
		or lower(ps.mastersku) like 'stickers%' or lower(ps.mastersku) like 'drink acc%' or lower(ps.mastersku) like 'botop%'
		or lower(ps.mastersku) like 'belt%' then 'Gear Apparel Accessories'

		else
		'Other'
	end as productcategoryGENERATED
      ,case when ltrim(rtrim(ps.producttype)) = '' or ps.producttype is null then 'UNKNOWN' else ps.producttype end as productype
      ,case when lower(p.prodcode) like 'YR%' then 'Roadie - Core'
		when (lower(p.prodcode) like 'yt%' and lower(pg.Description) like 'tundra%') or (lower(p.prodcode) like 'tun%' and lower(pg.Description) like 'tundra%') then 'Tundra - Core'
		when lower(p.prodcode) like 'tank%' or (lower(p.prodcode) like 'yt%' and lower(pg.Description) like 'tank%') then 'Tank - Core'
		when lower(p.prodcode) like 'hopper%' then 'Hopper - Core'
		when lower(p.prodcode) like 'headgear%' then 'Headgear'
		when lower(p.prodcode) like 'shirts%' then 'Shirts'
		when lower(p.prodcode) like 'rambler%' then 'Cups' 
		when lower(p.prodcode) like 'tumbler%' then 'Cups'
		when lower(p.prodcode) like 'colster%' then 'Colster'
		when lower(p.prodcode) like 'bottles%' then 'Bottles'
		when lower(p.prodcode) like 'ice%' then 'Ice Packs'
		when lower(p.prodcode) = 'CMO' then 'Mold-On Graphics'
		when lower(p.prodcode) in ('cups','jug','koozies') then 'Other Drinkware'
		when lower(p.prodcode) like 'slides%' or lower(p.prodcode) like 'access%' or lower(p.prodcode) like 'bait%'
		or lower(p.prodcode) like 'baskets%' or lower(p.prodcode) like 'cushion%' or lower(p.prodcode) like 'lock%'
		or lower(p.prodcode) like 'brack%' or lower(p.prodcode) like 'seadek%' or lower(p.prodcode) like 'dividers%'
		or lower(p.prodcode) like 'handles%' then 'Hard Cooler - Accessories' 
		when lower(p.prodcode) like 'hopperacc%' then 'Soft Cooler - Accessories' 
		when lower(p.prodcode) like 'hopperrp%' then 'Soft Cooler - Replacement Parts' 
		else 'Other'
		End   as ProductTypeGENERATED
	,case when upper(ltrim(rtrim(replace(pu.shortchar05, '"','')))) = '' or pu.shortchar05 is null then 'UNKNOWN' else upper(ltrim(rtrim(replace(pu.shortchar05, '"','')))) end  as sku      
	,case when upper(ltrim(rtrim(ps.sku))) = '' or ps.sku is null then 'UNKNOWN' else upper(ltrim(rtrim(replace(ps.sku, '"','')))) end as financesku
	,case when upper(ltrim(rtrim(replace(pu.shortchar06, '"','')))) = '' or pu.shortchar06 is null then 'UNKNOWN' else upper(ltrim(rtrim(replace(pu.shortchar06, '"','')))) end  as color
      ,pu.shortchar07 as Size
      ,pu.shortchar08 as ApparelSleeve
      ,p.ClassID
      ,pc.Description as ClassDescription
      ,p.inactive
      ,p.TypeCode
      ,pu.shortchar09 as Gender
      ,ps.revacct as RevAcct
      ,ps.cogsacct as COGSAcct
      ,pcs.avgmaterialcost
      ,pcs.avglaborcost
      ,pcs.avgburdencost
      ,pcs.avgmtlburcost
      ,p.runout
      ,p.TaxCatID
      ,p.CommodityCode
      ,p.WarrantyCode
      ,NetWeight
      ,PartsPerContainer
      ,PartLength
      ,PartWidth
      ,PartHeight
      ,OnHold
      ,OnHoldDate
      ,OnHoldReasonCode
      ,EDICode
      ,WebInStock
      ,p.SysRevID
      ,p.SysRowID
  FROM yetistg.erp_Part_stg p
  inner join yetistg.erp_PartClass_stg pc on lower(p.ClassID) = lower(pc.ClassID)
    inner join yetistg.erp_ProdGrup_stg pg on lower(pg.ProdCode) = lower(p.ProdCode)
    inner join yetistg.erp_part_ud_stg pu on lower(pu.ForeignSysRowID) = lower(p.sysrowid)
    left join yetistg.erp_productmapping_stg ps on ps.partnum = p.partnum
    left join yetistg.erp_partcost_stg pcs on pcs.partnum = p.partnum
    left join yetistg.erp_masterskumapping_stg m on lower(ltrim(rtrim(m.mastersku_from))) = lower(ltrim(rtrim(ps.shortchar04)))
UNION 
Select
'YT653LM'
,'YETI'
,'YT653LM'
,'YETI Tundra 65 Tan: w 3LMonogram - 13065010000'
,'YT0653LM'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,NULL
UNION 
Select
'-1'
,'YETI'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,NULL
UNION 
SELECT
'-2'
,'YETI'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'FREIGHT'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'UNKNOWN'
,'UNKNOWN'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,'0'
,'0'
,'0'
,'0'
,NULL
,NULL
,NULL
,'0'
,'0'
,NULL
;

GO
