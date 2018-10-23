USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_TZ].[SP_sap_orderfact]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_TZ].[SP_sap_orderfact] AS

if object_id('EDW_TZ.SAP_ORDER_FCT') is not null  begin

Drop table EDW_TZ.SAP_ORDER_FCT end;
CREATE TABLE EDW_TZ.SAP_ORDER_FCT
with
( DISTRIBUTION = HASH
(orderID), CLUSTERED INDEX
(OrderID, OrderLineID, NeedbyDateKey))
AS
(
SELECT
    ord.MANDT as Client,
    (case when ord.vbeln = 0 then NULL else ord.vbeln end) as OrderID,
    (case when ord_line.posnr = 0 then NULL else ord_line.posnr end) as OrderLineID,
    (case when ltrim(rtrim(ord_line.MATNR)) = '' then NULL else ord_line.MATNR end) as ProductID,
    ord.KUNNR as CustomerID,
    (CASE WHEN ord.VKGRP IS NULL then knv.VKGRP ELSE ord.VKGRP END) as SalesGroup,
    (CASE WHEN ord.VKBUR IS NULL then knv.VKBUR ELSE ord.VKBUR END) as SalesOffice,
    ord.VKORG as SalesOrganization,
    ord.VTWEG AS DistributionChannel,
    CAST(ord.VDATU AS DATE) as NeedbyDate,
    (ord.ERDAT) AS OrderCreatedOnDate,
    ord_line.ERDAT AS OrderLineCreatedOnDate,
    ord.ERZET as OrderEntryTime,
    ord.ERNAM as CreatedBy,
    ord.VBTYP as OrderCategory,
    ord.VDATU as NeedbyDateKey,
    ord.VDATU as RequestDateKey,
    ord_sp.KUNNR as SoldToParty,
	(CASE WHEN ord_line.POSNR=ord_shp.POSNR THEN ord_shp.KUNNR
		ELSE coalesce(ord_shp_default.KUNNR,'-1')
	END) AS ShipToParty,
	(CASE WHEN ord_line.POSNR=ord_shp.POSNR THEN ord_shp.ADRNR
		ELSE coalesce(ord_shp_default.ADRNR,'-1')
	END) AS ShipToPartyAddress,
	ord_bp.KUNNR as BillToParty,
	coalesce(ord_bp.ADRNR,'-1') AS BillToPartyAddress,
    case when ord_line.ABSTA='C' then ord_line.NETWR else 0  end as CancelledPrice,
    case when ORD_line.NETPR is null then 0 else ord_line.NETPR end as UnitPrice,
    case when ORD_line.NETWR is null then 0 else ord_line.NETwR end as GrossPrice,
    ord.AUART AS OrderType,
    ship.LFART as DeliveryType,
    CAST(ord.AUDAT AS DATE) AS OrderDate,
    ord.GBSTK as OverallStatus,
    ord.BNAME AS EpicorOrderID,
    ord.AUDAT as OrderDateKey,
    ord_line.KWMENG as OrderQuantity,
    ord.LIFSK as DeliveryBlock,
    ord_line.ABSTA as CancelledFlag,
    COALESCE(case when ord_line.ABSTA='C' THEN CAN.UDATE ELSE '19000101' END,'19000101') AS CancelledDate,
    ord.FAKSK as BillingBlock,
    ord.BSTNK AS PurchaseOrderNumber,
    ship.WBSTK as GoodsMovementStatus,
    ord_line.LFSTA as DeliveryStatus,--LFGSA
    ord_line.BESTA as OrderStatus,
    ord_line.GBSTA as OverallOrderStatus,
    ord.ctlpc as CreditHold,
    ord_line.ABGRU as ReasonForRejectionID,
	REJ.BEZEI as ReasonForRejectionDesc,
    ord.CMGST as OverallCreditStatus,
    ord.FSSTK as OverallBillingBlockStatus,
    ord_line.LFGSA as OverallDeliveyStatus,
    ord.LSSTK as OverallDeliveryBlockStatus,
    sch.Schedule_line_number ScheduleLineNumber,
    sch.Delivery_datekey DeliveryDateKey,
    sch.Requested_delivery_Datekey RequestedDeliveryDateKey,
    sch.schedule_order_quantity ScheduleOrderQuantity,
    sch.schedule_Confirmed_quantity ScheduleConfirmedQuantity,
    sch.Material_Available_Datekey MaterialAvailableDatekey,
    sch.Goods_issue_Datekey GoodsIssueDatekey,
    sch.Schedule_Unconfirmed_quantity ScheduleUnconfirmedQuantity,
    ord_line.FAKSP BillingBlockItem,
    ship.VSTEL as ShippingPoint,
    ship.Delivered_Quantity DeliveredQuantity,
    ord_line.dwlastupdated DWLastUpdated

FROM EDW_SZ.sap_vbap_stg ord_line
    right JOIN EDW_SZ.sap_vbak_stg ord ON ord.VBELN=ord_line.VBELN
    left join (SELECT SHIP_HEAD.WBSTK , ship_dtl.VGPOS, ship_dtl.VGBEL, ship_head.kunnr, ship_head.VSTEL, ship_head.LFART, sum(ship_dtl.LFIMG) Delivered_Quantity
    FROM EDW_RZ.sap_lips_stg ship_dtl , EDW_RZ.sap_likp_stg ship_head
    WHERE ship_head.VBELN=ship_dtl.VBELN
    GROUP BY SHIP_HEAD.WBSTK ,ship_dtl.VGPOS,ship_dtl.VGBEL,ship_head.kunnr,ship_head.VSTEL ,ship_head.LFART) ship 
	ON ship.VGBEL=ord_line.VBELN AND ship.VGPOS=ord_line.POSNR
    left join (
		select vbeln OrderId, posnr OrderlineId, max(etenr) Schedule_line_number, max(EDATU) AS Delivery_Datekey, max(REQ_DLVDATE) AS Requested_delivery_Datekey,
        sum(WMENG) schedule_order_quantity, sum(BMENG) as schedule_Confirmed_quantity, max(MBDAT) as Material_Available_Datekey, max(WADAT) as Goods_issue_Datekey,
        (sum(wmeng)-sum(bmeng)) as Schedule_Unconfirmed_quantity
          from EDW_RZ.sap_vbep_stg
    group by vbeln,posnr 
	         ) sch on sch.OrderId=ord_line.vbeln and sch.OrderlineId=ord_line.posnr

    LEFT JOIN ( select TABKEY, MAX(UDATETIME) UDATETIME, MAX(UDATE) UDATE
    from [EDW_RZ].[sap_changelog_abgru]
    GROUP BY TABKEY ) CAN ON CAN.TABKEY=CONCAT(ord_line.MANDT,ord_line.VBELN,ord_line.POSNR)
	LEFT JOIN [EDW_RZ].[sap_tvagt_stg] REJ ON REJ.ABGRU=ord_line.ABGRU AND ORD_LINE.MANDT=REJ.MANDT
	LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) ord_shp ON ord_line.VBELN=ord_shp.VBELN and ord_line.POSNR=ord_shp.POSNR
	LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('WE')) ord_shp_default ON ord_line.VBELN=ord_shp_default.VBELN and ord_shp_default.POSNR = '000000'
	LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('AG')) ord_sp ON ord_line.VBELN=ord_sp.VBELN and ord_sp.POSNR = '000000'
	LEFT JOIN (select VBELN,POSNR,PARVW,KUNNR,ADRNR FROM EDW_SZ.sap_vbpa_stg WHERE PARVW IN ('RE')) ord_bp ON ord_line.VBELN=ord_bp.VBELN and ord_bp.POSNR = '000000'
	LEFT JOIN EDW_RZ.sap_knvv_stg knv ON ord.KUNNR = knv.KUNNR
where  ord.TRVOG =0 AND ord_line.POSNR IS NOT NULL

);
GO
