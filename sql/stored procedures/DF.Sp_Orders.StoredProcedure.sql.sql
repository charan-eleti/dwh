USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [DF].[Sp_Orders]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [DF].[Sp_Orders] AS

insert into DF.Monitoring 
SELECT GETDATE() As Timestamp,'EDW.Orders' Table_Name
GO
