USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_SZ].[SP_sap_vbpa_stg]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_SZ].[SP_sap_vbpa_stg] AS

if object_id('EDW_SZ.sap_vbpa_stg') is not null begin 
Drop table EDW_SZ.sap_vbpa_stg end;
CREATE TABLE EDW_SZ.sap_vbpa_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select *
FROM [EDW_RZ].[sap_vbpa_stg] );
GO
