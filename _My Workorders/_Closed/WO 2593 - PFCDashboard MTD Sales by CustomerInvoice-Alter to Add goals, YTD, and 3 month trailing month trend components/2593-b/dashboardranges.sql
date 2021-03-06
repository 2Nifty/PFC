if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardRanges]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardRanges]
GO

CREATE TABLE [dbo].[DashboardRanges] (
	[DashboardParameter] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[MonthValue] [int] NULL ,
	[YearValue] [int] NULL ,
	[BegDate] [datetime] NULL ,
	[EndDate] [datetime] NULL ,
	[DayOfMonth] [int] NULL 
) ON [PRIMARY]
GO

