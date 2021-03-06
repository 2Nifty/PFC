if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VMI_ContracDetail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VMI_ContracDetail]
GO

CREATE TABLE [dbo].[VMI_ContracDetail] (
	[ContractNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Chain] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Pct_Brn_EAU] [float] NULL ,
	[Mo_Factor] [float] NULL ,
	[AnnualQty] [float] NULL ,
	[Qty30Day] [float] NULL 
) ON [PRIMARY]
GO

