USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_SZ].[SP_CTAS_stg]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_SZ].[SP_CTAS_stg] AS

if object_id('EDW_SZ.sap_but000_stg') is not null begin 
Drop table EDW_SZ.sap_but000_stg end;
CREATE TABLE EDW_SZ.sap_but000_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select *
FROM EDW_RZ.sap_but000_stg );

if object_id('EDW_SZ.sap_knvp_stg') is not null begin 
Drop table EDW_SZ.sap_knvp_stg end;
CREATE TABLE EDW_SZ.sap_knvp_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select *
FROM EDW_RZ.sap_knvp_stg );

if object_id('EDW_SZ.sap_adrc_stg') is not null begin 
Drop table EDW_SZ.sap_adrc_stg end;
CREATE TABLE EDW_SZ.sap_adrc_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select *
FROM EDW_RZ.sap_adrc_stg );

GO
