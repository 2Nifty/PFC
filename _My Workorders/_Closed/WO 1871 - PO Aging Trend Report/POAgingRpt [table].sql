if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[POAgingRpt]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[POAgingRpt]
GO

CREATE TABLE [dbo].[POAgingRpt] (
	[BuyGroupNo] [varchar] (10) NULL ,
	[BuyGroupDesc] [nvarchar] (80) NULL ,
	[SubTotGroup] [varchar] (10) NULL ,
	[SubTotGroupDesc] [varchar] (30) NULL ,
	[AvgUseLbs] [decimal](38, 20) NOT NULL ,
	[AvlLbs] [decimal](38, 20) NOT NULL ,
	[AvlMos] [decimal](38, 20) NOT NULL ,
	[TrfLbs] [decimal](38, 20) NOT NULL ,
	[TrfMos] [decimal](38, 20) NOT NULL ,
	[OTWLbs] [decimal](38, 20) NOT NULL ,
	[OTWMos] [decimal](38, 20) NOT NULL ,
	[RTSLbs] [decimal](38, 20) NOT NULL ,
	[RTSMos] [decimal](38, 20) NOT NULL ,
	[OOLbs] [decimal](38, 20) NOT NULL ,
	[OOMos] [decimal](38, 20) NOT NULL ,
	[TotalLbs] [decimal](38, 20) NULL ,
	[TotalMos] [decimal](38, 20) NOT NULL ,
	[CPRValue] [decimal](38, 6) NOT NULL ,
	[CPRLbs] [decimal](38, 20) NOT NULL ,
	[CRPMos] [decimal](38, 20) NOT NULL ,
	[GrdTotMos] [decimal](38, 20) NOT NULL ,
	[ForecastLbs] [decimal](38, 20) NOT NULL ,
	[Month1RcptLbs] [decimal](38, 20) NOT NULL ,
	[Month1AvlLbs] [decimal](38, 20) NOT NULL ,
	[Month1Mos] [decimal](38, 20) NOT NULL ,
	[Month2RcptLbs] [decimal](38, 20) NOT NULL ,
	[Month2AvlLbs] [decimal](38, 20) NOT NULL ,
	[Month2Mos] [decimal](38, 20) NOT NULL ,
	[Month3RcptLbs] [decimal](38, 20) NOT NULL ,
	[Month3AvlLbs] [decimal](38, 20) NOT NULL ,
	[Month3Mos] [decimal](38, 20) NOT NULL
) ON [PRIMARY]
GO

CREATE INDEX idxBuyGroupNo on [dbo].[POAgingRpt] ([BuyGroupNo])
GO

CREATE INDEX idxSubTotGroup on [dbo].[POAgingRpt] ([SubTotGroup])
GO
