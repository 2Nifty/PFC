USE [PFCReports]
GO

DROP TABLE [dbo].[tCustItemSalesSummary]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCustItemSalesSummary](
	[pCustItemSalesSummaryID] [numeric](9, 0) IDENTITY(1,1) NOT NULL,
	[CustNo] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ItemNo] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodNo] [int] NULL,
	[SalesDollars] [decimal](18, 6) NULL,
	[SalesCost] [decimal](18, 6) NULL,
	[TotalWeight] [decimal](18, 6) NULL,
	[AvgCostDollars] [decimal](18, 6) NULL,
	[PriceCostDollars] [decimal](18, 6) NULL,
	[EntryID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntryDt] [datetime] NULL,
	[ChangeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChangeDt] [datetime] NULL,
	[StatusCd] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF