USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pIMLabelCNV]    Script Date: 04/17/2012 15:57:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMLabelCNV] AS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tIMLabelCNV]') AND type in (N'U')) DROP TABLE [dbo].[tIMLabelCNV]

CREATE TABLE [dbo].[tIMLabelCNV](
	[ItemNo] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Size No_ Description] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cat_ No_ Description] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Plating Type] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BaseQty] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[QTYPERUOM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CorpClass] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Basis] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INCOMP] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INCMPD] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKDS3] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKSZ1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INPKSZ2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


INSERT
INTO	[tIMLabelCNV]
SELECT	DISTINCT
		(replace(Item.ItemNo,'-','')) as ItemNo,
		LEFT(isnull(Item.ItemSize,' '),20) as [Size No_ Description],
		LEFT(isnull(Item.CatDesc,' '),25) as [Cat_ No_ Description],
		isnull(Item.Finish,' ') as [Plating Type],
		RIGHT('      ' + CAST(CAST(isnull(Item.SellStkUMQty,0) as INT) as varchar(6)),6) as BaseQty,
		rtrim(isnull(Item.SellStkUM,' ')) as [Base Unit of Measure],
		'      ' as Whse,
		'       ' as UnitCost,
		REPLICATE(' ',7-len(cast (cast (round(isnull(Item.ListPrice,0), 2) as decimal(7,2)) as char(7)))) + (cast (cast (round(isnull(Item.ListPrice,0), 2) as decimal(7,2)) as char(7))) as [Unit Price],
		isnull(Item.UPCCd,' ') as [UPC Code],
		'        ' as INVALF,
		'  ' as BOXCODE,
		REPLICATE(' ',6-len(cast (cast (isnull(Item.GrossWght,0) as decimal(7,2)) as char(7)))) + (cast (cast (isnull(Item.GrossWght,0) as decimal(7,2)) as char(7))) as Gross,
		REPLICATE(' ',7-len(cast (cast (isnull(Item.HundredWght,0) as decimal(7,2)) as char(7)))) + (cast (cast (isnull(Item.HundredWght,0) as decimal(7,2)) as char(7))) as CWgt,
		'  ' as COUNTRY,
--		CAST(round(isnull(Item.SuperUMQty,0), 0, 1) as INT) as QTYPERUOM,
		RIGHT('      ' + CAST(CAST(round(isnull(Item.SuperUMQty,0), 0, 1) as INT) as varchar(6)),6) as QTYPERUOM,
		' ' as CorpClass,
		CASE Item.PCLBFTInd
				WHEN 'PC' THEN 'P'
				WHEN 'LB' THEN '#'
				WHEN 'FT' THEN 'F'
				ELSE ' '
		END as [Code],
		' ' as Basis,
		'       ' as INCOMP,
		'  ' as INCMPD,
		LEFT(isnull(Item.CategoryDescAlt1,' '), 30) as INPKDS1,
		LEFT(isnull(Item.CategoryDescAlt2,' '), 30) as INPKDS2,
		LEFT(isnull(Item.CategoryDescAlt3,' '), 30) as INPKDS3,
		LEFT(isnull(Item.SizeDescAlt1,' '),30) as INPKSZ1,
		'                              ' as INPKSZ2
--into [tIMLabelCNV]
FROM    ItemMaster Item (NoLock) INNER JOIN
		ItemUM UM (NoLock)
ON		Item.pItemMasterID = UM.fItemMasterID
WHERE	isnull(Item.DeleteDt,0) = 0 AND
		Item.ItemStat = 'S' AND
		Item.ItemNo >= '00000-0000-000' AND
		Item.ItemNo <= '99999-9999-999' AND
		Item.ListPrice < 10000  AND
		Item.GrossWght < 10000 AND
		Item.HundredWght < 10000
ORDER BY	(replace(Item.ItemNo,'-',''))

--Return the data
SELECT	*
FROM	[tIMLabelCNV]

go