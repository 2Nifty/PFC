if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SOComments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SOComments]
GO

CREATE TABLE [dbo].[SOComments] (
	[pSOCommID] [numeric](9, 0) IDENTITY (1, 1) NOT NULL ,
	[fSOHeaderID] [int] NULL ,
	[Type] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FormsCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CommLineNo] [int] NULL ,
	[CommLineSeqNo] [int] NULL ,
	[CommText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteDt] [datetime] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

