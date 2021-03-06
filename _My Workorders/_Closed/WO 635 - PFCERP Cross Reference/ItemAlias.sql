if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ItemAlias]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ItemAlias]
GO

CREATE TABLE [dbo].[ItemAlias] (
	[pItemAliasID] [numeric](9, 0) IDENTITY (1, 1) NOT NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrganizationNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AliasItemNo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AliasDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AliasType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AliasWhseNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UOM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustBinLoc] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustClassCd] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteDt] [datetime] NULL ,
	[CustomerUPC] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

