USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Sap_Ownership]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Sap_Ownership] AS

if object_id('EDW_RZ.Sap_Ownership') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Sap_Ownership end;
CREATE EXTERNAL TABLE EDW_RZ.Sap_Ownership
(
Customer [varchar](225) NULL,
Sold_To_Party_Name [varchar](225) NULL,
TSM [varchar](225) NULL,
SAP_Partner_TSM [varchar](225) NULL,
Inside_Rep [varchar](225) NULL,
SAP_Partner_Inside_Rep [varchar](225) NULL,
Region varchar(225) NULL,
GBB varchar(225) NULL,
SO_Sales_Office varchar(225) NULL

)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_Z0lu.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Sap_Ownership') is not null begin 
DROP TABLE EDW.Sap_Ownership end;
Create Table EDW.Sap_Ownership
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select Customer,
Sold_To_Party_Name,
reps.TSM,
SAP_Partner_TSM,
TSM_Email,
Inside_Rep,
SAP_Partner_Inside_Rep,
Region,
GBB,
SO_Sales_Office
from EDW_RZ.Sap_Ownership Reps
left join EDW_RZ.TSM_emailids email On SAP_Partner_TSM = sap_Partner
);
GO
