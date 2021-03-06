if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[InventoryRptExcess]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[InventoryRptExcess]
GO

CREATE TABLE [dbo].[InventoryRptExcess] (
	[RecordType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemSize] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UOM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AvailableQty] [decimal](18, 6) NULL ,
	[SuperEquivQty] [decimal](18, 6) NULL ,
	[ReOrderPoint] [decimal](18, 6) NULL ,
	[ExcessQty] [decimal](18, 6) NULL ,
	[ExcessWght] [decimal](18, 6) NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

