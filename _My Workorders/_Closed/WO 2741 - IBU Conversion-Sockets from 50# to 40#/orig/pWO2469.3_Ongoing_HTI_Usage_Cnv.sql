if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pWO2469.3_Ongoing_HTI_Usage_Cnv]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pWO2469.3_Ongoing_HTI_Usage_Cnv]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [dbo].[pWO2469.3_Ongoing_HTI_Usage_Cnv]
AS

	-- ==========================================================================================
	-- Author:	Tod Dixon
	-- Created:	08/25/2011
	-- Desc:	UPDATE ItemBranchUsage using the HTI2 ItemAlias records
	-- 		Step01: Create [tIBU_ItemToItem] table from PERP.ItemAlias (Uses OpenDataSource)
	--		Step02: Execute [pIBU_ItemToItem] procedure to move the ItemBranchUsage data
	-- ==========================================================================================

	SET NOCOUNT ON;

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tIBU_ItemToItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tIBU_ItemToItem]

	--Step01: Create [tIBU_ItemToItem] table from PERP.ItemAlias (Uses OpenDataSource)
	SELECT	DISTINCT
		AliasItemNo as OldItem,
		ItemNo as NewItem
	INTO	tIBU_ItemToItem
--	FROM 	ItemAlias (NoLock)
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemAlias
	WHERE	AliasWhseNo = 'HTI2' AND 
		AliasType = 'C' AND
		isnull(DeleteDt,'') = '' AND 
		ItemNo <> AliasItemNo
--select * from tIBU_ItemToItem

	--Step02: Execute [pIBU_ItemToItem] procedure to move the ItemBranchUsage data
	EXEC	[pIBU_ItemToItem] 'WO2469.3_Ongoing_HTI_Usage_Conversion', 'WO2469.3_Ongoing_HTI_Usage_Conversion'

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tIBU_ItemToItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tIBU_ItemToItem]


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

