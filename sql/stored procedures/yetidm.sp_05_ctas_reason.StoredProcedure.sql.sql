USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [yetidm].[sp_05_ctas_reason]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [yetidm].[sp_05_ctas_reason] AS

if object_id('yetidm.reason') is not null begin 
Drop table yetidm.reason end;
create table yetidm.reason WITH (DISTRIBUTION = ROUND_ROBIN ) as
SELECT Company
      ,ReasonType
      ,ReasonCode
      ,Description
      ,DMRRejOpr
      ,DMRRejMtl
      ,DMRRejSub
      ,DMRRejInv
      ,DMRAcceptOpr
      ,DMRAcceptMtl
      ,DMRAcceptSub
      ,DMRAcceptInv
      ,InspFailOpr
      ,InspFailMtl
      ,InspFailSub
      ,InspFailInv
      ,Scrap
      ,NonConfOpr
      ,NonConfMtl
      ,NonConfSub
      ,NonConfOther
      ,QACause
      ,QACorrectiveAct
      ,InvAdjCountDiscrepancy
      ,Passed
      ,GlobalReason
      ,GlobalLock
      ,JDFWorkType
      ,SysRevID
      ,SysRowID
      ,NonConfInv
  FROM yetistg.Erp_Reason_stg;

GO
