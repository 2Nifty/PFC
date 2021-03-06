USE [PERP]
GO
/****** Object:  Table [dbo].[tIMLabelCNV]    Script Date: 04/05/2012 14:34:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tIMLabelCNV](
	[ItemNo] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Size No_ Description] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cat_ No_ Description] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Plating Type] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BaseQty] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Base Unit of Measure] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Whse] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitCost] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Unit List Price] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPC Code] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INVALF] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BOXCODE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gross] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CWgt] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QTYPERUOM] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CorpClass] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Basis] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INCOMP] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INCMPD] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS3] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKSZ1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKSZ2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF