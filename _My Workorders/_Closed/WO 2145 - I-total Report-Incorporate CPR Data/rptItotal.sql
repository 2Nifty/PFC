if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rptITotal]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[rptITotal]
GO

CREATE TABLE [dbo].[rptITotal] (
	[prptITotalID] [int] IDENTITY (1, 1) NOT NULL ,
	[CurrentDt] [datetime] NULL ,
	[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Category] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITotGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProdClass] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SalesVelocity] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CategoryVelocity] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QtyOnHand] [int] NULL ,
	[AvgCost] [decimal](18, 6) NULL ,
	[NetWght] [decimal](18, 6) NULL ,
	[GrossWght] [decimal](18, 6) NULL ,
	[ThirtyDayUsageQty] [int] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[changeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StandardCost] [decimal](18, 6) NULL ,
	[ReplacementCost] [decimal](18, 6) NULL ,

	[AvailCost] [decimal](18, 2) NULL ,
	[AvailWght] [decimal](18, 2) NULL ,
	[AvailQty] [decimal](18, 6) NULL ,

	[TrfCost] [decimal](18, 2) NULL ,
	[TrfWght] [decimal](18, 2) NULL ,
	[TrfQty] [decimal](18, 6) NULL ,

	[OTWCost] [decimal](18, 2) NULL ,
	[OTWWght] [decimal](18, 2) NULL ,
	[OTWQty] [decimal](18, 6) NULL ,

	[RTSBCost] [decimal](18, 2) NULL ,
	[RTSBWght] [decimal](18, 2) NULL ,
	[RTSBQty] [decimal](18, 6) NULL ,

	[OnOrdCost] [decimal](18, 2) NULL ,
	[OnOrdWght] [decimal](18, 2) NULL ,
	[OnOrdQty] [decimal](18, 6) NULL ,

	[Use30DayQty] [decimal](38, 17) NULL
) ON [PRIMARY]
GO

