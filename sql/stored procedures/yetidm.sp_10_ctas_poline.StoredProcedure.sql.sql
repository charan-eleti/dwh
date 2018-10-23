USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_10_ctas_poline]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_10_ctas_poline] AS

if object_id('yetidm.poline') is not null begin 
Drop table yetidm.poline end;
create table yetidm.poline WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT distinct Company
      ,OpenLine
      ,VoidLine
      ,PONUM as poid
      ,POLine as polineid
      ,LineDesc
      ,ClassID
      ,VendorNum
      ,Confirmed
      ,DateChgReq
      ,QtyChgReq
      ,ConfirmDate
      ,ConfirmVia
      ,PrcChgReq
      ,PurchCode
      ,OrderNum
      ,OrderLine
      ,Linked
      ,ExtCompany
      ,GlbCompany
      ,BaseQty
      ,BaseUOM
      ,SysRevID
      ,SysRowID
FROM yetistg.Erp_PODetail_stg;


GO
