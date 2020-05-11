if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rptITotalHist]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[rptITotalHist]
GO

CREATE TABLE [dbo].[rptITotalHist] (
	[prptITotalHistID] [int] IDENTITY (1, 1) NOT NULL ,
	[CurrentDt] [datetime] NULL ,
	[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITotalGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExtendedQtyOnHand] [int] NULL ,
	[ExtendedAvgCost] [decimal](18, 6) NULL ,
	[ExtendedNetWght] [decimal](18, 6) NULL ,
	[ExtendedGrossWght] [decimal](18, 6) NULL ,
	[ExtendedThirtyDayUsage] [int] NULL ,
	[ExtendedThirtyDayUseCost] [decimal](18, 5) NULL ,
	[ExtendedThirtyDayUseWgt] [decimal](18, 6) NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

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

