if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SOExpenseHist]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SOExpenseHist]
GO

CREATE TABLE [dbo].[SOExpenseHist] (
	[pSOExpenseHistID] [bigint] IDENTITY (1, 1) NOT NULL ,
	[fSOHeaderHistID] [numeric](10, 0) NULL ,
	[LineNumber] [int] NULL ,
	[ExpenseNo] [int] NULL ,
	[ExpenseCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Amount] [float] NULL ,
	[Cost] [float] NULL ,
	[ExpenseInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeliveryCharge] [float] NULL ,
	[HandlingCharge] [float] NULL ,
	[PackagingCharge] [float] NULL ,
	[MiscCharge] [float] NULL ,
	[PhoneCharge] [float] NULL ,
	[DocumentLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteDt] [datetime] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

