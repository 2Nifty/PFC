
--188412
select * from tWO2469_HTI_IBU

select top 10 * from ItemBranchUsage






--13003 to update
select	IBU.*
FROM	tWO2469_HTI_IBU HTIIBU (NoLock) INNER JOIN
	ItemBranchUsage IBU (NoLock)
ON	HTIIBU.Location = IBU.Location AND
	HTIIBU.ItemNo = IBU.ItemNo AND
	HTIIBU.Period = IBU.CurPeriodNo


--175409 to insert
select	NewIBU.*
FROM	tWO2469_HTI_IBU NewIBU (NoLock)
WHERE	NOT EXISTS (SELECT  *
		    FROM    ItemBranchUsage IBU (NoLock)
		    WHERE   IBU.ItemNo = NewIBU.ItemNo AND
			    IBU.Location = NewIBU.Location AND
			    IBU.CurPeriodNo = NewIBU.Period)



select * from tWO2469_HTIUsage

select * from tWO2469_HTI_IBU


----------------------------------------------------------------------------------------------------------------------


--Create empty ItemBranchUsage records that don't already exist
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
		TempUse.Location, TempUse.ItemNo, TempUse.Period,
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
		'WO2469_LoadHTIUsage' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO2469_HTI_IBU TempUse (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = TempUse.Location AND IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.Period)
GO



--Add USAGE to existing ItemBranchUsage transactions
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO2306_Step06_MoveMcMasterCarrIBU_8'
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	Period,
		ItemNo,
		Location,
		SUM(NoOfSales) as TotCount,
		SUM(SalesQty) as TotQty,
		SUM(SalesDol) as TotDol,
		SUM(SalesWght) as TotWght,
		SUM(CostDol) as TotCostDol
	 FROM	tWO2469_HTI_IBU (NoLock)
	 GROUP BY Period, ItemNo, Location) TempUse
ON	IBU.CurPeriodNo = TempUse.Period AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.Location
GO




----------------------------------------------------------------------------------------------------------------------

--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2469ItemBranchUsageHTI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO2469ItemBranchUsageHTI
go

SELECT	*
--INTO	tWO2469ItemBranchUsageHTI
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO2469_HTI_IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.Location AND
			IBU.CurPeriodNo = NewIBU.Period)
go







--UPDATE ItemBranchUsage : Combine saved & updated items
UPDATE	ItemBranchUsage
SET	ItemBranchUsage.CurNoofSales = ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
	ItemBranchUsage.CurSalesQty = ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
	ItemBranchUsage.CurSalesDol = ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
	ItemBranchUsage.CurSalesWght = ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
	ItemBranchUsage.CurCostDol = ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
	ItemBranchUsage.CurNRSalesQty = ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
	ItemBranchUsage.CurNRNoSales = ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
	ItemBranchUsage.CurNRSalesDol = ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
	ItemBranchUsage.CurNRSalesWght = ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
	ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
	ItemBranchUsage.ChangeID = 'WO1856',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO2469ItemBranchUsageHTI TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo
go

