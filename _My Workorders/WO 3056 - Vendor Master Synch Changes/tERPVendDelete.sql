USE [PFCFinance]
GO
/****** Object:  Table [dbo].[tERPVendDelete]    Script Date: 09/12/2012 12:34:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tERPVendDelete](
	[pVendMstrID] [int] NOT NULL,
	[VendNo] [varchar](10) NULL,
	[Name] [varchar](40) NULL,
	[Code] [varchar](10) NULL,
	[Bank] [varchar](10) NULL,
	[PayFrequency] [varchar](2) NULL,
	[GLDist] [int] NULL,
	[1099Cd] [varchar](10) NULL,
	[TermsCd] [varchar](5) NULL,
	[VendorPostingGrp] [varchar](10) NULL,
	[FedTaxID] [varchar](30) NULL,
	[CurrencyCd] [varchar](10) NULL,
	[Priority] [int] NULL,
	[PayMethodCd] [varchar](10) NULL,
	[PayDays] [smallint] NULL,
	[DeleteDt] [datetime] NULL,
	[CheckStatus] [char](2) NULL,
	[GLNonCheckAcct] [int] NULL,
	[DiscPct] [numeric](18, 6) NULL,
	[EntryID] [varchar](50) NULL,
	[EntryDt] [datetime] NULL,
	[ChangeID] [varchar](50) NULL,
	[ChangeDt] [datetime] NULL,
	[StatusCd] [char](2) NULL,
	[VendorType] [varchar](20) NULL,
	[CPRVendNo] [varchar](10) NULL,
	[CPRShortCode] [varchar](40) NULL,
	[AlphaSearch] [varchar](30) NULL,
	[fPayToNo] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF