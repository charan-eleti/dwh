USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[Sp_Sales_Targets]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[Sp_Sales_Targets] AS

if object_id('EDW_RZ.Sales_Targets') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Sales_Targets end;
CREATE EXTERNAL TABLE EDW_RZ.Sales_Targets
(
TSM [varchar](225) NULL,
Rep_Id [varchar] (225) NULL,
Region  [varchar](225) NULL,	
Month [varchar](225) NULL,
Quarter [varchar](225) NULL,
First_date [varchar](225) NULL,
Target [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/Sales_Rep_Targets.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW.Sales_Targets') is not null begin 
DROP TABLE EDW.Sales_Targets end;
Create Table EDW.Sales_Targets
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select 
st.TSM,
Rep_Id,
Region,
Month,
Quarter,
Cast(First_date AS Date) AS First_Date,
Cast(Replace(Replace(Target, ',', ''), '$', '') AS Decimal(20,4)) As Target,
te.TSM_Email
from EDW_RZ.Sales_Targets st left join [EDW_RZ].[TSM_Emailids] te
 on st.Rep_Id = te.sap_Partner

);
GO
