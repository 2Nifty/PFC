select * from ItembranchUsage
where EntryID='WO1187Br20toBr01Ins'



--Create empty Br01 USAGE Records that don't already exist
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
SELECT		'01', ItemNo, CurPerNo,
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
		'WO1187Br20toBr01Ins' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1187Br20CustUsage TempUse
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU
			    WHERE  IBU.Location = '01' AND TempUse.ItemNo = IBU.ItemNo AND TempUse.CurPerNo = IBU.CurPeriodNo)

--Create empty Br01 USAGE Records that don't already exist (NR)
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
SELECT		'01', ItemNo, CurPerNo,
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
		'WO1187Br20toBr01Ins' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1187Br20NRCustUsage TempUse
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU
			    WHERE  IBU.Location = '01' AND TempUse.ItemNo = IBU.ItemNo AND TempUse.CurPerNo = IBU.CurPeriodNo)





--Subtract USAGE from existing ItemBranchUsage Br20 transactions
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) - LineCount,
	CurSalesQty = ISNULL(CurSalesQty,0) - QtyOrdered,
	CurSalesDol = ISNULL(CurSalesDol,0) - ExtendedPrice,
	CurSalesWght = ISNULL(CurSalesWght,0) - ExtendedNetWght,
	CurCostDol = ISNULL(CurCostDol,0) - ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Del'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20CustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '20'


--Subtract USAGE from existing ItemBranchUsage Br20 transactions (NR)
UPDATE	ItemBranchUsage
SET	CurNRNoSales = ISNULL(CurNRNoSales,0) - LineCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) - QtyOrdered,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) - ExtendedPrice,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) - ExtendedNetWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) - ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Del'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20NRCustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '20'




--Add USAGE to ItemBranchUsage Br01 records
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + LineCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + QtyOrdered,
	CurSalesDol = ISNULL(CurSalesDol,0) + ExtendedPrice,
	CurSalesWght = ISNULL(CurSalesWght,0) + ExtendedNetWght,
	CurCostDol = ISNULL(CurCostDol,0) + ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Upd'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20CustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '01'



--Add USAGE to ItemBranchUsage Br01 records (NR)
UPDATE	ItemBranchUsage
SET	CurNRNoSales = ISNULL(CurNRNoSales,0) + LineCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) + QtyOrdered,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) + ExtendedPrice,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) + ExtendedNetWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) + ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Upd'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20NRCustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '01'
