USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW].[SP_fiscalcalendar]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW].[SP_fiscalcalendar] AS

SET ANSI_NULLS ON

if object_id('EDW.fiscalcalendar') is not null begin 
Drop table EDW.fiscalcalendar end;
CREATE TABLE EDW.fiscalcalendar WITH (DISTRIBUTION = ROUND_ROBIN ) as 
(
SELECT 
CAST(DATE AS DATE) as DATE,
DateKey,
CalYear,
CalMonth,
CalDay,
CalMonthName,
WeekdayNum,
[DayOfWeek],
CalYearMonth,
[CalYear-Month],
WeekNum,
SeqWeekNum,
FiscalYear,
FiscalMonth,
FiscalMonthName,
FiscalYearMonth,
CAST([FiscalYear-Month] AS NVARCHAR(10)) AS [FiscalYear-Month],
FiscalWeek,
FiscalYearWeek,
[FiscalYear-Week],
FiscalQuarter,
FiscalMonthWeek,
[FiscalYear-Quarter],
FiscalFirstDayMonth,
FiscalLastDayMonth,
FiscalDayofYear,
FiscalDayofMonth,
CAST(FirstDayofCurrentMonth AS DATE) AS FirstDayofCurrentMonth,
CAST(FirstDayofNextMonth AS DATE) AS FirstDayofNextMonth,
CAST(FirstDayofPreviousMonth AS DATE) AS FirstDayofPreviousMonth,
CAST(FirstDayofCurrentMonthLastYear AS DATE) AS FirstDayofCurrentMonthLastYear,
CAST(FirstDayFiscalYear AS DATE) AS FirstDayFiscalYear,
CAST(FirstDayLastFiscalYear AS DATE) AS FirstDayLastFiscalYear,
CAST(FirstDayNextFiscalYear AS DATE) AS FirstDayNextFiscalYear,
CAST(FirstDayFiscalQuarter AS DATE) AS FirstDayFiscalQuarter,
CAST(FirstDayLastFiscalQuarter AS DATE) AS FirstDayLastFiscalQuarter,
CAST(FirstDayNextFiscalQuarter AS DATE) AS FirstDayNextFiscalQuarter,
CAST(FirstDayFiscalQuarterLastYear AS DATE) AS FirstDayFiscalQuarterLastYear,
CAST(FirstDayFiscalQuarterNextYear AS DATE) AS FirstDayFiscalQuarterNextYear,
CAST(FirstDayPrior4Weeks AS DATE) AS FirstDayPrior4Weeks,
CAST(FirstDayPrior13Weeks AS DATE) AS FirstDayPrior13Weeks,
CAST(FirstDayPrior4WeeksLastYear AS DATE) AS FirstDayPrior4WeeksLastYear,
CAST(FirstDayPrior13WeeksLastYear AS DATE) AS FirstDayPrior13WeeksLastYear,
ConvertedFiscalDayofYear,
ConvertedFiscalYear,
ConvertedFiscalMonth,
ConvertedFiscalMonthName,
ConvertedFiscalYearMonth,
[ConvertedFiscalYear-Month],
ConvertedFiscalWeek,
ConvertedFiscalQuarter,
ConvertedFiscalMonthWeek,
[ConvertedFiscalYear-Quarter],
[FiscalQuarterDay]

FROM  [EDW_RZ].[fiscalcalendar] 
);
GO
