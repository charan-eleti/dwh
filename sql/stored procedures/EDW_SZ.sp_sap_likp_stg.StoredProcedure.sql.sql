USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_SZ].[sp_sap_likp_stg]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_SZ].[sp_sap_likp_stg] AS

if object_id('EDW_SZ.sap_likp_stg') is not null begin 
Drop table EDW_SZ.sap_likp_stg end;
CREATE TABLE EDW_SZ.sap_likp_stg WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(select *
FROM [EDW_RZ].[sap_likp_stg] 
WHERE MANDT='300'
);
GO
