if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CuvnalFiscalCalendar]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CuvnalFiscalCalendar]
GO

CREATE TABLE [dbo].[CuvnalFiscalCalendar] (
	[CalendarDate] [datetime] NOT NULL ,
	[CuvnalMonth] [int] NULL ,
	[CuvnalYear] [int] NULL ,
	[FiscalPeriod] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FiscalPeriodBeg] [datetime] NULL ,
	[FiscalPeriodEnd] [datetime] NULL ,
	[FiscalYearBeg] [datetime] NULL ,
	[FiscalYearEnd] [datetime] NULL ,
	[WorkDay] [int] NULL 
) ON [PRIMARY]
GO

