use PFCReports
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pRPTITotalBuyGrp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pRPTITotalBuyGrp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- =============================================
-- Author:	Charles Rojas
-- Created:	05-04-09
-- Desc:	Average Cost/Usage Record
-- Mod: 	04/11/2011: [TMD] Added CPR Fields for Avl, Trf, OW, RTS-B & OnOrd
-- =============================================
CREATE PROCEDURE pRPTITotalBuyGrp 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	--w/o CPR = (5486 row(s) affected) - 9 seconds
	--w/o CPR = (5490 row(s) affected) - 10 seconds
				-- reformatted the JOINs
				-- four extra records were missing due to no corresponding CAS_CatBuyGrp data
	--w/  CPR = (5490 row(s) affected) - 13 seconds
	SELECT	CurrentDt,
			Branch,
			Category,
			DonGroupNo,
			DonGroupDesc,
			DonSort,
			BuyGroupNo,
			BuyGroupDesc,
			ITotalGroup,
			SUM(isnull(QtyOnHand,0)) as ExtendedQtyOnHand,
			SUM(isnull(ExtendedAvgCost,0)) as ExtendedAvgCost,
			SUM(isnull(ExtendedNetWeight,0)) as ExtendedNetWeight,
			SUM(isnull(ExtendedGrossWeight,0)) as ExtendedGrossWeight,
			SUM(isnull(MoUse,0)) as ExtendedThirtyDayUsage,
			SUM(isnull(ExtendedThirtyDayUseCost,0)) as ExtendedThirtyDayUseCost,
			SUM(isnull(ExtendedThirtyDayUseWeight,0)) as ExtendedThirtyDayUseWeight,
			0 as Actual12MonthsSalesDollars,
			0 as Actual12MonthsSalesLbs,
			'pRPTItotalBuyGroup' as EntryId,
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as EntryDt,

			--CRP Data
			SUM(isnull(AvailCost,0)) as AvailCost,
			SUM(isnull(AvailWght,0)) as AvailWght,
			SUM(isnull(AvailQty,0)) as AvailQty,
			SUM(isnull(TrfCost,0)) as TrfCost,
			SUM(isnull(TrfWght,0)) as TrfWght,
			SUM(isnull(TrfQty,0)) as TrfQty,
			SUM(isnull(OTWCost,0)) as OTWCost,
			SUM(isnull(OTWWght,0)) as OTWWght,
			SUM(isnull(OTWQty,0)) as OTWQty,
			SUM(isnull(RTSBCost,0)) as RTSBCost,
			SUM(isnull(RTSBWght,0)) as RTSBWght,
			SUM(isnull(RTSBQty,0)) as RTSBQty,
			SUM(isnull(OnOrdCost,0)) as OnOrdCost,
			SUM(isnull(OnOrdWght,0)) as OnOrdWght,
			SUM(isnull(OnOrdQty,0)) as OnOrdQty,
			SUM(isnull([Use30DayQty],0)) as [Use30DayQty]
	FROM	(SELECT	DR.EndDate as CurrentDt,
					CGD.GroupNo as BuyGroupNo,
					CGD.Description as BuyGroupDesc,
					CGD.DonGroup as DonGroupDesc, 
					CGD.DonGroupNo,
					CGD.DonSort,
					CASE WHEN AC.Branch =  'VENDTRANS' THEN '9995'
						 WHEN AC.Branch = 'INTRATRANS' THEN '9992'
						 WHEN AC.Branch =   'CARTRANS' THEN '9991'
						 ELSE AC.Branch
					END as Branch,
					Left(AC.ItemNo,5) as Category,
					CASE WHEN AC.Branch BETWEEN '00' AND '98' THEN 'Branch'	
						 WHEN AC.Branch =         'VENDTRANS' THEN 'On-the-Water'
						 ELSE AC.Branch
					END as ITotalGroup,
					AC.ItemNo, 
					IM.ItemDesc as Descr,
					CASE WHEN substring(AC.ItemNo,12,1) in ('0','1','5') THEN 'Bulk' 
						 WHEN substring(AC.ItemNo,12,1) in ('2')         THEN 'Mill'
						 ELSE 'Package'
					END as ProdClass,
					ISNULL(NVStats.SVC,'') as SVC,
					IM.CatVelocityCd as CVC,
					AC.BegQOH as QtyOnHand,      
					AC.BegAC AS AvgCost,
					AC.BegQOH * AC.BegAC as ExtendedAvgCost,
					IM.Wght as Net, 
					AC.BegQOH * IM.Wght as ExtendedNetWeight,
					IM.GrossWght as Gross, 
					AC.BegQOH * IM.GrossWght as ExtendedGrossWeight,
					ISNULL(MoUse,0) as MoUse,
					isnull(AC.BegAC*MoUse,0) as ExtendedThirtyDayUseCost,
					isnull(IM.Wght*MoUse,0) as ExtendedThirtyDayUseWeight,
					ISNULL(StndCst,0) as StndCst,
					ISNULL(RplCst,0) as RplCst,
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
					CAS_CatGrpDesc CGD (NoLock)
			 ON		left(AC.ItemNo,5) = CGD.Category LEFT OUTER JOIN
					(SELECT	IB.Location AS Loc, .
							IM.ItemNo AS Item, 
							IB.ReplacementCost AS RplCst, 
							IB.StdCost AS StndCst, 
							IB.ReOrderPoint / 3 AS MoUse, 
							IB.SalesVelocityCd AS SVC
					 FROM	ItemMaster IM (NoLock) INNER JOIN
							ItemBranch IB (NoLock)
					 ON		IM.pItemMasterID = IB.fItemMasterID
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
							isnull(CPR.Net_Wgt,0) as RTSBWght,
							isnull(CPR.RTSBQty,0) as RTSBQty,
							isnull(CPR.OO_Cost,0) as OnOrdCost,
							isnull(CPR.OO_Wgt,0) as OnOrdWght,
							isnull(CPR.OO_Qty,0) as OnOrdQty,
							isnull(CPR.Use_30Day_Qty,0) as Use30DayQty
					 FROM	CPR_Daily CPR (NoLock)
					 WHERE	LocationCode BETWEEN '01' AND '90') CPR_Daily
			ON		AC.ItemNo = CPR_Daily.ItemNo AND AC.Branch = CPR_Daily.LocationCode CROSS JOIN
					DashboardRanges DR (NoLock)
			WHERE	AC.BegQOH > 0 and
	--				AC.CurDate BETWEEN @BegDate and @EndDate and
					AC.Branch not in ('00','17','99','Transit') and
					DR.DashboardParameter = 'CurrentDay') Raw1
	Group by CurrentDt, Branch, Category, DonGroupNo, DonGroupDesc, DonSort, BuyGroupNo, BuyGroupDesc, ITotalGroup
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
