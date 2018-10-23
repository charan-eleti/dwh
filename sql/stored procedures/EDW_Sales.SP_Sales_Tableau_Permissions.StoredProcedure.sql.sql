USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_Sales].[SP_Sales_Tableau_Permissions]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_Sales].[SP_Sales_Tableau_Permissions] AS

/* =============================================
   ObjectName/type: Table
   Description: Used to control the permissions of the Tableau report users.
               
   Parameters: 
   Author: Charan Eleti
   Create date: 10/08/2018
   
   =============================================
   Change History
   ============================================= 
  
	Date 	Author	Description
	10/8/2018	Charan Eleti	Created the table as per the requirement from Billy Minor
			
			

   ============================================= */

if object_id('EDW_RZ.Sales_Tableau_Permissions') is not null begin
Drop EXTERNAL TABLE EDW_RZ.Sales_Tableau_Permissions end;

CREATE EXTERNAL TABLE EDW_RZ.Sales_Tableau_Permissions
(
Name [varchar](225) NULL,
Email [varchar](225) NULL,
Access [varchar](225) NULL,
SO_Sales_Office [varchar](225) NULL,
[Group] [varchar](225) NULL,
Region [varchar](225) NULL
)
WITH (DATA_SOURCE = [yetiadls],LOCATION = N'/clusters/data/01_raw/custom_data_uploads/sales/EDW_Tableau_Permissions.txt',FILE_FORMAT = [TabTextFileFormatskip1],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW_Sales.Sales_Tableau_Permissions') is not null begin 
DROP TABLE EDW_Sales.Sales_Tableau_Permissions end;

Create Table EDW_Sales.Sales_Tableau_Permissions
WITH( DISTRIBUTION = ROUND_ROBIN )
AS (
Select * from EDW_RZ.Sales_Tableau_Permissions
);

GO
