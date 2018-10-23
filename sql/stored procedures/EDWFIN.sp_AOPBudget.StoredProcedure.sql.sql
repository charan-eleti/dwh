USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDWFIN].[sp_AOPBudget]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDWFIN].[sp_AOPBudget] AS

if object_id('EDWFIN.AOPBudget') is not null begin 
DROP TABLE EDWFIN.AOPBudget end;
Create Table EDWFIN.AOPBudget 
WITH (DISTRIBUTION = ROUND_ROBIN)
AS 
(Select 
[ProductCategory],
[SalesChannelLvl0],
[SalesChannelLvl1],
[SalesChannelLvl2],
[Month],
[YEAR],
CAST((CASE When REPLACE(LTRIM(RTRIM([aopsales])),',','') = '-' Then NULL Else REPLACE(LTRIM(RTRIM([aopsales])),',','') END) AS DECIMAL(13,2)) AS AOPSales,
Cast ([Date] AS Date) AS [Date],
MonthNum
From [yetistgsap].[AOPBudget2018]
)
GO
