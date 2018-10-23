USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_warehousebin]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_warehousebin] AS

if object_id('yetidm.warehousebin') is not null begin 
Drop table yetidm.warehousebin end;
create table yetidm.warehousebin WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT 
      coalesce(case when ltrim(rtrim(wb.Company)) = '' then NULL else wb.Company end,'-1') as CompanyId
      ,coalesce(case when ltrim(rtrim(wb.BinNum)) = '' then NULL else wb.binNum end,'-1') as BinId
      ,coalesce(case when ltrim(rtrim(wb.WarehouseCode)) = '' then NULL else wb.WarehouseCode end,'-1') as WarehouseId
      ,w.name
      ,w.warehousecode
      ,wb.BinNum BinCode
      ,wb.Description
      ,wb.NonNettable
      ,wb.SizeID
      ,wb.ZoneID
      ,wb.BinSeq
      ,wb.BinType
      ,wb.CustNum
      ,wb.VendorNum
      ,wb.Aisle
      ,wb.Face
      ,wb.Elevation
      ,wb.MaxFill
      ,wb.PctFillable
      ,wb.InActive
      ,wb.Portable
      ,wb.Replenishable
      ,wb.SysRevID
      ,wb.SysRowID
FROM yetistg.erp_whsebin_stg wb
inner join yetistg.erp_warehse_stg w on w.warehousecode = wb.warehousecode;
GO
