if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CatStkDetail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CatStkDetail]
GO

CREATE TABLE [dbo].[CatStkDetail] (
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LocationCode] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LocationName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Category] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TotUse30] [int] NULL ,
	[AvailQty] [int] NULL ,
	[ExtSoldWght] [decimal](38, 6) NULL ,
	[AvailQtyWght] [decimal](38, 6) NULL ,
	[MonthsOH] [decimal](18, 2) NULL ,
	[Rop_Calc] [decimal](38, 6) NULL ,
	[CorpFixedVelCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SalesVelCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CatVelCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Net_Wgt] [decimal](38, 20) NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PlatingNo] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

