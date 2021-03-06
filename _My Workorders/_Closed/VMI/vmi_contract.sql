if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VMI_Contract]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VMI_Contract]
GO

CREATE TABLE [dbo].[VMI_Contract] (
	[ContractNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Chain] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ItemDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SubItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CrossRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EAU_Qty] [int] NULL ,
	[ContractPrice] [float] NULL ,
	[E_Profit_Pct] [float] NULL ,
	[StartDate] [datetime] NULL ,
	[EndDate] [datetime] NULL ,
	[Salesperson] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderMethod] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Vendor] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Contact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonthFactor] [float] NULL ,
	[Closed] [YesNo] NULL 
) ON [PRIMARY]
GO

