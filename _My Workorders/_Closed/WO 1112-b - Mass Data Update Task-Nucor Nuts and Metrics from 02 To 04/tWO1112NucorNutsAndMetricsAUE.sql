if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1112NucorNutsAndMetricsAUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1112NucorNutsAndMetricsAUE]
GO

CREATE TABLE [dbo].[tWO1112NucorNutsAndMetricsAUE] (
	[OldItem] [varchar] (20) COLLATE Latin1_General_CS_AS NOT NULL ,
	[Location] [varchar] (10) COLLATE Latin1_General_CS_AS NOT NULL ,
	[NewItem] [varchar] (14) COLLATE Latin1_General_CS_AS NULL 
) ON [Data Filegroup 1]
GO

