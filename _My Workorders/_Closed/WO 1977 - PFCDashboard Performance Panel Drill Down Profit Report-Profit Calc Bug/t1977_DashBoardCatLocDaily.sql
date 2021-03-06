if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t1977_DashboardCatLocDaily]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t1977_DashboardCatLocDaily]
GO

CREATE TABLE [dbo].[t1977_DashboardCatLocDaily] (
	[CategoryGroup] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ARPostDt] [datetime] NULL ,
	[SalesDollars] [decimal](18, 6) NULL ,
	[Lbs] [decimal](18, 6) NULL ,
	[SalesPerLb] [decimal](18, 6) NULL ,
	[Cost] [decimal](18, 6) NULL ,
	[MarginDollars] [decimal](18, 6) NULL ,
	[MarginPct] [decimal](18, 6) NULL ,
	[MarginPerLb] [decimal](18, 6) NULL ,
	[Profit] [decimal](18, 6) NULL ,
	[BudgetLbs] [decimal](18, 6) NULL ,
	[BudgetSales] [decimal](18, 6) NULL ,
	[BudgetMargin] [decimal](18, 6) NULL ,
	[BudgetMarginPct] [decimal](18, 6) NULL ,
	[BudgetExp] [decimal](18, 6) NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

