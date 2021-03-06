if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustomerPrice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustomerPrice]
GO

CREATE TABLE [dbo].[CustomerPrice] (
	[pCustomerPriceID] [numeric](9, 0) IDENTITY (1, 1) NOT NULL ,
	[CustNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustItemNo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FutCustItemNo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PriceMethod] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FutPriceMetod] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EffDt] [datetime] NULL ,
	[FutEffDt] [datetime] NULL ,
	[EffEndDt] [datetime] NULL ,
	[FutEffEndDt] [datetime] NULL ,
	[STKSellPrice] [money] NULL ,
	[FutSTKSellPrice] [money] NULL ,
	[AltSellPrice] [money] NULL ,
	[FutAltSellPrice] [money] NULL ,
	[ListPrice] [money] NULL ,
	[ContractPrice] [money] NULL ,
	[FutContractPrice] [money] NULL ,
	[ItemCost] [money] NULL ,
	[MarkUpPct] [float] NULL ,
	[FutMarkupPct] [float] NULL ,
	[DiscPct] [float] NULL ,
	[FutDiscPct] [float] NULL ,
	[CustGroupInd] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CatGroupInd] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContractQty] [numeric](15, 6) NULL ,
	[FutContractQty] [numeric](15, 6) NULL ,
	[SeqNo] [int] NULL ,
	[FutSeqNo] [int] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AllowInvoiceDisc] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AllowLineDisc] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

