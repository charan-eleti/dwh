USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_SZ].[SP_sap_acdoca_stg]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_SZ].[SP_sap_acdoca_stg] AS

SET ANSI_NULLS ON

if object_id('EDW_SZ.sap_acdoca_stg') is not null begin 
Drop table EDW_SZ.sap_acdoca_stg end;
CREATE TABLE EDW_SZ.sap_acdoca_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select RLDNR
,BELNR
,DOCLN
,AWREF
,AWITEM
,RBUKRS
,VKBUR_PA
,KMVKGR_PA
,KUNNR
,KUNWE
,KUNRE
,WWY01_PA
,WWY02_PA
,MATNR
,KDAUF
,KDPOS
,BUDAT
,BLDAT
,BLART
,RACCT
,AWTYP
,MSL
,HSL
,[TIMESTAMP]
,dwlastupdated
FROM [EDW_RZ].[sap_acdoca_stg] );

GO
