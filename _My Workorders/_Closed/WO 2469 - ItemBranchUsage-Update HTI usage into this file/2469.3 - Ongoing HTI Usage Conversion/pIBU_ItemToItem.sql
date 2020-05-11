drop proc pIBU_ItemToItem
go

CREATE PROCEDURE [dbo].[pIBU_ItemToItem]
	@EntryId varchar(50),
	@ChangeId varchar(50)
AS

	-- =============================================================================
	-- Author:	Tod Dixon
	-- Created:	08/25/2011
	-- Desc:	UPDATE ItemBranchUsage using the tIBU_ItemToItem table
	-- 		Step01a: Save Old ItemBranchUage transactions
	-- 		Step01b: UPDATE NewItemNo
	-- 		Step02:  Delete Old ItemBranchUage transactions that were saved
	-- 		Step03:  Create empty ItemBranchUsage records that don't already exist
	-- 		Step04:  UPDATE usage for all existing ItemBranchUsage records
	-- =============================================================================

	SET NOCOUNT ON;

--select * from tIBU_ItemToItem

	--Step01a: Save Old ItemBranchUage transactions
	SELECT	cast(' ' as varchar(20)) as NewItemNo, *
	INTO	#tOldUsage
	FROM	ItemBranchUsage (NoLock)
	WHERE	ItemNo in (SELECT OldItem FROM tIBU_ItemToItem)
	
	--Step01b: UPDATE NewItemNo
	UPDATE	#tOldUsage
	SET	NewItemNo = tIBU.NewItem
	FROM	tIBU_ItemToItem tIBU
	WHERE	#tOldUsage.ItemNo = tIBU.OldItem
--select * from #tOldUsage


	--Step02: Delete Old ItemBranchUage transactions that were saved
	DELETE
	FROM	ItemBranchUsage
	WHERE	EXISTS	(SELECT	*
			 FROM	#tOldUsage TempIBU (NoLock)
			 WHERE	ItemBranchUsage.CurPeriodNo = TempIBU.CurPeriodNo AND
				ItemBranchUsage.ItemNo = TempIBU.ItemNo AND
				ItemBranchUsage.Location = TempIBU.Location)


	--Step03: Create empty ItemBranchUsage records that don't already exist
	INSERT INTO	ItemBranchUsage
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
	SELECT		DISTINCT
			TempIBU.Location, TempIBU.NewItemNo, TempIBU.CurPeriodNo,
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
			@EntryId AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
	FROM		#tOldUsage TempIBU
	WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
				    WHERE  IBU.Location = TempIBU.Location AND IBU.ItemNo = TempIBU.NewItemNo AND IBU.CurPeriodNo = TempIBU.CurPeriodNo)


	--Step04: UPDATE usage for all existing ItemBranchUsage records
	UPDATE	ItemBranchUsage
	SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempIBU.TotCount,
		CurSalesQty = ISNULL(CurSalesQty,0) + TempIBU.TotQty,
		CurSalesDol = ISNULL(CurSalesDol,0) + TempIBU.TotDol,
		CurSalesWght = ISNULL(CurSalesWght,0) + TempIBU.TotWght,
		CurCostDol = ISNULL(CurCostDol,0) + TempIBU.TotCostDol,
		CurNRNoSales = ISNULL(CurNRNoSales,0) + TempIBU.TotNRCount,
		CurNRSalesQty = ISNULL(CurNRSalesQty,0) + TempIBU.TotNRQty,
		CurNRSalesDol = ISNULL(CurNRSalesDol,0) + TempIBU.TotNRDol,
		CurNRSalesWght = ISNULL(CurNRSalesWght,0) + TempIBU.TotNRWght,
		CurNRCostDol = ISNULL(CurNRCostDol,0) + TempIBU.TotNRCostDol,
		ChangeDt = GetDate(),
		ChangeID = @ChangeId
	FROM	ItemBranchUsage IBU INNER JOIN
		(SELECT	CurPeriodNo,
			NewItemNo,
			Location,
			SUM(CurNoofSales) as TotCount,
			SUM(CurSalesQty) as TotQty,
			SUM(CurSalesDol) as TotDol,
			SUM(CurSalesWght) as TotWght,
			SUM(CurCostDol) as TotCostDol,
			SUM(CurNRNoSales) as TotNRCount,
			SUM(CurNRSalesQty) as TotNRQty,
			SUM(CurNRSalesDol) as TotNRDol,
			SUM(CurNRSalesWght) as TotNRWght,
			SUM(CurNRCostDol) as TotNRCostDol
		 FROM	#tOldUsage (NoLock)
		 GROUP BY CurPeriodNo, NewItemNo, Location) TempIBU
	ON	IBU.CurPeriodNo = TempIBU.CurPeriodNo AND IBU.ItemNo = TempIBU.NewItemNo AND IBU.Location = TempIBU.Location

go