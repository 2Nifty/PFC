if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblInvItems]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblInvItems]
GO

CREATE TABLE [dbo].[tblInvItems] (
	[PRODNO] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PLATEDIDG] [float] NULL ,
	[PRODDSH] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITEMDESC] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC1] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CATDESC] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PLATEDESC] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PLATDESC] [nvarchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PLATE2] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SELLUNIT] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UOMSELL] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CARRIED] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QTYDESIG] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UPCCODE] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LOTUPC] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MIDUPC] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CHECK] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC2] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC3] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC4] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC5] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ITMDESC6] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PCXNAME] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HEAD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SPCXNAME] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SHEAD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LCPGNAME] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LCPGHEAD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HEADSTYL] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CODEDATE] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MASTERLOC] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MASTLOC] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CONTWGHT] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SUPERMULT] [float] NULL ,
	[CASEQTY] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SLVQTY] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ALPHCODE] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PO] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COUNTRY] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HEADDESC] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QTRDESC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COLOR] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LBLTYPE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UNITPRICE] [float] NULL ,
	[WGT100] [float] NULL ,
	[NEWCAT1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NEWCAT2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NEWCAT3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NEWSIZE] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RODDISPLAY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RODPCS] [decimal](18, 0) NULL 
) ON [PRIMARY]
GO

