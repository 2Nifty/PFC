use PFCReports
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pRPTITotal]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pRPTITotal]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- =============================================
-- Author:	Charles Rojas
-- Created:	10/08/2008
-- Desc:	Average Cost/Usage Record
-- Mod: 	07/23/2009: [???] Moved code to use ERP tables 
--			04/11/2011: [TMD] Added CPR Fields for Avl, Trf, OW, RTS-B & OnOrd
-- =============================================

CREATE PROCEDURE pRPTITotal 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	--w/o CPR = (150943 row(s) affected) - 9 seconds
	--w/  CPR = (150943 row(s) affected) - 13 seconds
	SELECT	AC.CurDate,
			CASE WHEN AC.Branch =  'VENDTRANS' THEN '9995'
				 WHEN AC.Branch = 'INTRATRANS' THEN '9992'
				 WHEN AC.Branch =   'CARTRANS' THEN '9991'
				 ELSE AC.Branch
			END as Branch,
			Left(AC.ItemNo,5) as Category,
			CASE WHEN AC.Branch BETWEEN '00' AND '98' THEN 'Branch'	
				 WHEN AC.Branch =         'VENDTRANS' THEN 'On-the-Water'
				 ELSE AC.Branch
			END as ITotGroup,
			AC.ItemNo, 
			IM.ItemDesc as Descr,
			CASE WHEN substring(AC.ItemNo,12,1) in ('0','1','5') THEN 'Bulk' 
				 WHEN substring(AC.ItemNo,12,1) in ('2')         THEN 'Mill'
				 ELSE 'Package'
			END as ProdClass,
			NVStats.SVC,
			IM.CatVelocityCd as CVC,
			AC.BegQOH as QtyOnHand,      
			AC.BegAC as AvgCost,
			IM.Wght as Net,
			IM.GrossWght as Gross,
			ISNULL(NVStats.MoUse,0) as MoUse,
			'pRPTItotal' as EntryId,
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as EntryDt,
			ISNULL(NVStats.StndCst,0) as StndCst,
			ISNULL(NVStats.RplCst,0) as RplCst,
			--CRP Data
			isnull(CPR_DAILY.AvailCost,0) as AvailCost,
			isnull(CPR_DAILY.AvailWght,0) as AvailWght,
			isnull(CPR_DAILY.AvailQty,0) as AvailQty,
			isnull(CPR_DAILY.TrfCost,0) as TrfCost,
			isnull(CPR_DAILY.TrfWght,0) as TrfWght,
			isnull(CPR_DAILY.TrfQty,0) as TrfQty,
			isnull(CPR_DAILY.OTWCost,0) as OTWCost,
			isnull(CPR_DAILY.OTWWght,0) as OTWWght,
			isnull(CPR_DAILY.OTWQty,0) as OTWQty,
			isnull(CPR_DAILY.RTSBCost,0) as RTSBCost,
			isnull(CPR_DAILY.RTSBWght,0) as RTSBWght,
			isnull(CPR_DAILY.RTSBQty,0) as RTSBQty,
			isnull(CPR_DAILY.OnOrdCost,0) as OnOrdCost,
			isnull(CPR_DAILY.OnOrdWght,0) as OnOrdWght,
			isnull(CPR_DAILY.OnOrdQty,0) as OnOrdQty,
			isnull(CPR_DAILY.Use30DayQty,0) as Use30DayQty
	FROM	PFCAC.dbo.AvgCst_Daily AC (NoLock) INNER JOIN
			ItemMaster IM (NoLock)
	ON		AC.ItemNo = IM.ItemNo LEFT OUTER JOIN
			(SELECT	IB.Location as Loc, 
					IM.ItemNo as Item, 
					IB.ReplacementCost as RplCst, 
					IB.StdCost as StndCst,
					IB.ReOrderPoint / 3 as MOUse, 
					IB.SalesVelocityCd as SVC,
					IM.CatVelocityCd as CVC,
					IM.Wght as Net,
					IM.GrossWght as Gross,
					IM.ItemDesc as Descr
			 FROM	ItemBranch IB (NoLock) INNER JOIN
					ItemMaster IM (NoLock)
			 ON		IB.fItemMasterID = IM.pItemMasterID
			 WHERE	IB.Location BETWEEN '01' AND '90') NVStats
	ON		AC.ItemNo = NVStats.Item AND AC.Branch = NVStats.Loc LEFT OUTER JOIN
			--CRP Data
			(SELECT	CPR.ItemNo,
					CPR.LocationCode,
					isnull(CPR.Avail_Cost,0) as AvailCost,
					isnull(CPR.Avail_Wgt,0) as AvailWght,
					isnull(CPR.Avail_Qty,0) as AvailQty,
					isnull(CPR.Trf_Cost,0) as TrfCost,
					isnull(CPR.Trf_Wgt,0) as TrfWght,
					isnull(CPR.Trf_Qty,0) as TrfQty,
					isnull(CPR.OW_Cost,0) as OTWCost,
					isnull(CPR.OW_Wgt,0) as OTWWght,
					isnull(CPR.OW_Qty,0) as OTWQty,
					0 as RTSBCost,
					isnull(CPR.RTSBQty,0) * isnull(CPR.Net_Wgt,0) as RTSBWght,
					isnull(CPR.RTSBQty,0) as RTSBQty,
					isnull(CPR.OO_Cost,0) as OnOrdCost,
					isnull(CPR.OO_Wgt,0) as OnOrdWght,
					isnull(CPR.OO_Qty,0) as OnOrdQty,
					isnull(CPR.Use_30Day_Qty,0) as Use30DayQty
			 FROM	CPR_Daily CPR (NoLock)
			 WHERE	LocationCode BETWEEN '01' AND '90') CPR_Daily
	ON		AC.ItemNo = CPR_Daily.ItemNo AND AC.Branch = CPR_Daily.LocationCode
	WHERE   AC.BegQOH > 0 AND AC.Branch not in ('00','17','99','Transit') -- AND AC.CurDate BETWEEN @BegDate AND @EndDate
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

