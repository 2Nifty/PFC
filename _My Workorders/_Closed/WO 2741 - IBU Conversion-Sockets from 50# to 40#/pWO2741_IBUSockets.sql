SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Tod Dixon
-- Created:	20-Jan-2012
-- Desc:	WO2741 - ItemBranchUsage Socket Conversion 50# to 40#
--			 01) Create #tOldSKUList - All valid 020 SKUs
--			 02) Create #tNewSKUList - All valid 040 SKUs
--			 03) Create #tIBUSKUList - INNER JOIN Old & New
--			 04) UPDATE zero SellStkQty
--			 05) Create #tIBUList - All qualifying 020 usage to be moved
--			 06) Create #tOldUsage - Save Old ItemBranchUage transactions
--			 07) Delete Old ItemBranchUage transactions that were saved
--			 08) Create empty ItemBranchUsage records that don't already exist
--			 09) UPDATE usage for all existing ItemBranchUsage records
-- =============================================

CREATE PROCEDURE pWO2741_IBUSockets 
AS
BEGIN

	SET NOCOUNT ON;

	--01) #tOldSKUList - All valid 020 SKUs
	SELECT	DISTINCT
			IB.Location,
			IM.ItemNo as OldItem,
			IB.Location + ItemNo as OldSKU,
			IM.SellStkUMQty as OldSellStkQty,
			IM.SellStkUM as OldSellStkUM
	INTO	#tOldSKUList
	FROM	ItemMaster IM (NoLock) INNER JOIN
			ItemBranch IB (NoLock)
	ON		IM.pItemMasterID = IB.fItemMasterID
	WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
			((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
			 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))

	--02) #tNewSKUList - All valid 040 SKUs
	SELECT	DISTINCT
			IB.Location,
			IM.ItemNo as NewItem,
			IB.Location + ItemNo as NewSKU,
			IM.SellStkUMQty as NewSellStkQty,
			IM.SellStkUM as NewSellStkUM
	INTO	#tNewSKUList
	FROM	ItemMaster IM (NoLock) INNER JOIN
			ItemBranch IB (NoLock)
	ON		IM.pItemMasterID = IB.fItemMasterID
	WHERE	RIGHT(IM.ItemNo,3) = '040' AND 
			((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
			 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))
--select * from #tOldSKUList
--select * from #tNewSKUList

	--03) #tIBUSKUList - INNER JOIN Old & New
	SELECT	New.Location,
			Old.OldItem,
			Old.OldSellStkQty,
			Old.OldSellStkUM,
			Old.OldSKU,
			New.NewItem,
			New.NewSellStkQty,
			New.NewSellStkUM,
			New.NewSKU
	INTO	#tIBUSKUList
	FROM	#tNewSKUList New (NoLock) INNER JOIN
			#tOldSKUList Old (NoLock)
	ON		New.Location = Old.Location AND LEFT(New.NewItem,11) = LEFT(Old.OldItem,11)

	--04) UPDATE zero SellStkQty
	UPDATE	#tIBUSKUList
	SET		OldSellStkQty = 1,
			OldSellStkUM = '',
			NewSellStkQty = 1,
			NewSellStkUM = ''
	WHERE	OldSellStkQty <= 0 or NewSellStkQty <= 0
--select * from #tIBUSKUList

	--05) #tIBUList - All qualifying 020 usage to be moved
	SELECT	tSKU.*
	INTO	#tIBUList
	FROM	#tIBUSKUList tSKU (NoLock)
	WHERE	tSKU.OldSKU in (SELECT DISTINCT IBU.Location + IBU.ItemNo as IBUSKU FROM ItemBranchUsage IBU (NoLock))
--select * from #tIBUList

	--06) #tOldUsage - Save Old ItemBranchUage transactions
	SELECT	DISTINCT
			List.Location as ListLoc,
			List.OldItem,
			List.OldSellStkQty,
			List.OldSellStkUM,
			List.OldSKU,
			List.NewItem,
			List.NewSellStkQty,
			List.NewSellStkUM,
			List.NewSKU,
			IBU.*
	INTO	#tOldUsage
	FROM	ItemBranchUsage IBU (NoLock) INNER JOIN
			#tIBUList List (NoLock)
	ON		IBU.Location = List.Location and IBU.ItemNo = List.OldItem
--select * from #tOldUsage

	--07) Delete Old ItemBranchUage transactions that were saved
	DELETE
	FROM	ItemBranchUsage
	WHERE	EXISTS	(SELECT	*
					 FROM	#tOldUsage tIBU (NoLock)
					 WHERE	ItemBranchUsage.CurPeriodNo = tIBU.CurPeriodNo AND
							ItemBranchUsage.ItemNo = tIBU.ItemNo AND
							ItemBranchUsage.Location = tIBU.Location)

	--08) Create empty ItemBranchUsage records that don't already exist
	INSERT	INTO	ItemBranchUsage
					([Location], ItemNo,  [CurPeriodNo],
					 [CurBegOnHandQty], [CurBegOnHandDol], [CurBegOnHandWght],
					 [CurNoofReceipts], [CurReceivedQty], [CurReceivedDol], [CurReceivedWght],
					 [CurNoofReturns], [CurReturnQty], [CurReturnDol], [CurReturnWght],
					 [CurNoofBackOrders], [CurBackOrderQty], [CurBackOrderDol], [CurBackOrderWght],
					 [CurNoofSales], [CurSalesQty], [CurSalesDol], [CurSalesWght], [CurCostDol],
					 [CurNoofTransfers], [CurTransferQty], [CurTransferDol], [CurTransferWght],
					 [CurNoofIssues], [CurIssuesQty], [CurIssuesDol], [CurIssuesWght],
					 [CurNoofAdjust], [CurAdjustQty], [CurAdjustDol], [CurAdjustWght],
					 [CurNoofChanges], [CurChangeQty], [CurChangeDol], [CurChangeWght],
					 [CurNoofPO], [CurPOQty], [CurPODol], [CurPOWght],
					 [CurNoofGER], [CurGERQty], [CurGERDol], [CurGERWght],
					 [CurNoofWorkOrders], [CurWorkOrderQty], [CurWorkOrderDol], [CurWorkOrderWght],
					 [CurLostSlsQty], [CurDailySlsQty], [CurDailyRetQty],
					 [CurEndOHQty], [CurEndOHDol], [CurEndOHWght],
					 [CurNoofOrders], [CurNRSalesQty], [CurNRNoSales], [CurNRSalesDol], [CurNRSalesWght], [CurNRCostDol],
					 [EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd])
	SELECT	DISTINCT tIBU.Location, tIBU.NewItem, tIBU.CurPeriodNo,
					 0 AS BegOHQty, 0 AS BegOHDol, 0 AS BegOHWght,
					 0 AS NoRecs, 0 AS RecQty, 0 AS RecDol, 0 AS RecWght,
					 0 AS NoRet, 0 AS RetQty, 0 AS RetDol, 0 AS RetWght,
					 0 AS NoBO, 0 AS BOQty, 0 AS BODol, 0 AS BOWght,
					 0 AS SlsCnt, 0 AS SlsQty, 0 AS SlsDol, 0 AS SlsWght, 0 AS SlsCost,
					 0 AS NoXFR, 0 AS XFRQty, 0 As XFRDol, 0 AS XFRWght,
					 0 AS NoIss, 0 AS IssQty, 0 AS IssDol, 0 AS IssWght,
					 0 AS NoAdj, 0 AS AdjQty, 0 AS AdjDol, 0 AS AdjWght,
					 0 AS NoChg, 0 AS ChgQty, 0 AS ChgDol, 0 AS ChgWght,
					 0 AS NoPO, 0 AS POQty, 0 AS PODol, 0 AS POWght,
					 0 AS NoGer, 0 AS GERQty, 0 AS GERDol, 0 AS GERWght,
					 0 AS NoWO, 0 AS WOQty, 0 AS WODol, 0 AS WOWght,
					 0 AS LSQty, 0 AS DlySlsQty, 0 AS DlyRetQty,
					 0 AS EndOH, 0 AS EndVal, 0 As EndOHWght,
					 0 AS NoOrd, 0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
					 'WO2741' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
	FROM			 #tOldUsage tIBU
	WHERE NOT EXISTS(SELECT	*
					 FROM	ItemBranchUsage IBU (NoLock)
					 WHERE  IBU.Location = tIBU.Location AND
							IBU.ItemNo = tIBU.NewItem AND
							IBU.CurPeriodNo = tIBU.CurPeriodNo)

	--09) UPDATE usage for all existing ItemBranchUsage records
	UPDATE	ItemBranchUsage
	SET		CurNoofSales = ISNULL(CurNoofSales,0) + tIBU.TotCount,
			CurSalesQty = ISNULL(CurSalesQty,0) + tIBU.TotQty,
			CurSalesDol = ISNULL(CurSalesDol,0) + tIBU.TotDol,
			CurSalesWght = ISNULL(CurSalesWght,0) + tIBU.TotWght,
			CurCostDol = ISNULL(CurCostDol,0) + tIBU.TotCostDol,
			CurNRNoSales = ISNULL(CurNRNoSales,0) + tIBU.TotNRCount,
			CurNRSalesQty = ISNULL(CurNRSalesQty,0) + tIBU.TotNRQty,
			CurNRSalesDol = ISNULL(CurNRSalesDol,0) + tIBU.TotNRDol,
			CurNRSalesWght = ISNULL(CurNRSalesWght,0) + tIBU.TotNRWght,
			CurNRCostDol = ISNULL(CurNRCostDol,0) + tIBU.TotNRCostDol,
			ChangeDt = GetDate(),
			ChangeID = 'WO2741'
	FROM	ItemBranchUsage IBU INNER JOIN
			(SELECT	CurPeriodNo,
					NewItem,
					Location,
					SUM(CurNoofSales) as TotCount,
					CASE WHEN SUM(CurSalesQty) <= 0
								THEN 0
								ELSE CASE WHEN ROUND(SUM((CurSalesQty / OldSellStkQty) * NewSellStkQty),0) < 1
												THEN 1
												ELSE ROUND(SUM((CurSalesQty / OldSellStkQty) * NewSellStkQty),0)
									 END
					END as TotQty,
					SUM(CurSalesDol) as TotDol,
					SUM(CurSalesWght) as TotWght,
					SUM(CurCostDol) as TotCostDol,
					SUM(CurNRNoSales) as TotNRCount,
					CASE WHEN SUM(CurNRSalesQty) <= 0
								THEN 0
								ELSE CASE WHEN ROUND(SUM((CurNRSalesQty / OldSellStkQty) * NewSellStkQty),0) < 1
												THEN 1
												ELSE ROUND(SUM((CurNRSalesQty / OldSellStkQty) * NewSellStkQty),0)
									 END
					END as TotNRQty,
					SUM(CurNRSalesDol) as TotNRDol,
					SUM(CurNRSalesWght) as TotNRWght,
					SUM(CurNRCostDol) as TotNRCostDol
			 FROM	#tOldUsage (NoLock)
			 GROUP BY CurPeriodNo, NewItem, Location) tIBU
	ON	IBU.CurPeriodNo = tIBU.CurPeriodNo AND IBU.ItemNo = tIBU.NewItem AND IBU.Location = tIBU.Location

END
GO
