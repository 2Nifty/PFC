--EnterpriseSQL
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1376_Daily_SO_EDI_To_ERP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1376_Daily_SO_EDI_To_ERP]
GO

CREATE TABLE [dbo].[tWO1376_Daily_SO_EDI_To_ERP] (
	[RefSONo] [varchar] (20) COLLATE Latin1_General_CS_AS NOT NULL,
	[SellToCustNo] [varchar] (20) COLLATE Latin1_General_CS_AS NOT NULL 
) ON [Data Filegroup 1]
GO

CREATE INDEX idxWO1376RefSONo on [dbo].[tWO1376_Daily_SO_EDI_To_ERP] ([RefSONo])
GO

CREATE INDEX idxWO1376SellToCustNo on [dbo].[tWO1376_Daily_SO_EDI_To_ERP] ([SellToCustNo])
GO

-------------------------------------------------------------------------------------------------


--PFCERPDB
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tWO1376_Daily_SO_EDI_To_ERP]') AND type in (N'U'))
DROP TABLE [dbo].[tWO1376_Daily_SO_EDI_To_ERP]
GO

CREATE TABLE [dbo].[tWO1376_Daily_SO_EDI_To_ERP] (
	[RefSONo] [varchar] (20) NOT NULL,
	[SellToCustNo] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

CREATE INDEX idxWO1376RefSONo on [dbo].[tWO1376_Daily_SO_EDI_To_ERP] ([RefSONo])
GO

CREATE INDEX idxWO1376SellToCustNo on [dbo].[tWO1376_Daily_SO_EDI_To_ERP] ([SellToCustNo])
GO