if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Porteous$Standard Text Line Comment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Porteous$Standard Text Line Comment]
GO

CREATE TABLE [dbo].[Porteous$Standard Text Line Comment] (
	[timestamp] [timestamp] NOT NULL ,
	[No_] [varchar] (10) COLLATE Latin1_General_CS_AS NOT NULL ,
	[Line No_] [int] NOT NULL ,
	[Date] [datetime] NOT NULL ,
	[Comment] [varchar] (50) COLLATE Latin1_General_CS_AS NOT NULL 
) ON [Data Filegroup 1]
GO

