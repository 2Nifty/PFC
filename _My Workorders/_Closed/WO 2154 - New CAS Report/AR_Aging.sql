if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AR_Aging]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AR_Aging]
GO

CREATE TABLE [dbo].[AR_Aging] (
	[CustNo] [varchar] (20) NULL ,
	[Current] [float] NULL ,
	[Over30] [float] NULL ,
	[Over60] [float] NULL ,
	[Over90] [float] NULL ,
	[BalDue] [float] NULL 
) ON [PRIMARY]
GO



--select * from AR_Aging