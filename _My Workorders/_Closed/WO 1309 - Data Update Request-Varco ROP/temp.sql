if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1309_VarcoROPUpdates]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1309_VarcoROPUpdates]
GO

CREATE TABLE [dbo].[tWO1309_VarcoROPUpdates] (
	[Item No#] [nvarchar] (255) COLLATE Latin1_General_CS_AS NULL ,
	[Size No# Description] [nvarchar] (255) COLLATE Latin1_General_CS_AS NULL ,
	[Item Description] [nvarchar] (255) COLLATE Latin1_General_CS_AS NULL ,
	[Plating] [nvarchar] (255) COLLATE Latin1_General_CS_AS NULL ,
	[*Inventory] [float] NULL ,
	[Reorder Point] [float] NULL ,
	[Base ROP] [float] NULL 
) ON [Data Filegroup 1]
GO

