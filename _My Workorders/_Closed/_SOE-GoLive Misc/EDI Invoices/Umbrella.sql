if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341_Umbrella]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1341_Umbrella]
GO

CREATE TABLE [dbo].[tWO1341_Umbrella] (
	[UserName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CompanyID] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

