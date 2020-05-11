--Create empty ItemBranchUsage records that don't already exist
--Less than 1 minute in DEV (4372 rows affected)
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
SELECT		UsageLoc, TempUse.ToItem, CurPeriod,
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
			'WO2268' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO2268_SalesUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT	*
						FROM	ItemBranchUsage IBU (NoLock)
						WHERE	IBU.ItemNo = TempUse.ToItem AND IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.Location = TempUse.UsageLoc)
GO

--Create empty ItemBranchUsage records that don't already exist (NR)
--(0 rows affected)
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
SELECT		UsageLoc, TempUse.ToItem, CurPeriod,
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
			'WO2268' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO2268_NRUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT	*
						FROM	ItemBranchUsage IBU (NoLock)
						WHERE	IBU.ItemNo = TempUse.ToItem AND IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.Location = TempUse.UsageLoc)
GO


----------------------------------------------------------------


select * from ItemBranchUsage where EntryID = 'WO2268' or ChangeID = 'WO2268'