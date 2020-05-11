if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1481_LocMaster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1481_LocMaster]
GO

CREATE TABLE [dbo].[tWO1481_LocMaster] (
	[LocID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MaintainIMQtyInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RegionLocID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
)
GO



SELECT	LocID,
	MaintainIMQtyInd,
	RegionLocID
FROM	LocMaster



select * from tWO1481_LocMaster