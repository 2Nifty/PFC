--Add USAGE to existing ItemBranchUsage transactions
--Less than 1 minute in DEV (5,565 rows affected)
UPDATE	ItemBranchUsage
SET		CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
		CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
		CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
		CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
		CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
		ChangeDt = GetDate(),
		ChangeID = 'WO2268'
FROM	ItemBranchUsage IBU INNER JOIN
		tWO2268_SalesUsage TempUse
ON		IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ToItem AND IBU.Location = TempUse.UsageLoc
GO

--Add USAGE to existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (1 rows affected)
UPDATE	ItemBranchUsage
SET		CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
		CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
		CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
		CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
		CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
		CurNRNoSales = ISNULL(CurNRNoSales,0) + TempUse.TotCount,
		CurNRSalesQty = ISNULL(CurNRSalesQty,0) + TempUse.TotQty,
		CurNRSalesDol = ISNULL(CurNRSalesDol,0) + TempUse.TotDol,
		CurNRSalesWght = ISNULL(CurNRSalesWght,0) + TempUse.TotWght,
		CurNRCostDol = ISNULL(CurNRCostDol,0) + TempUse.TotCostDol,
		ChangeDt = GetDate(),
		ChangeID = 'WO2268'
FROM	ItemBranchUsage IBU INNER JOIN
		tWO2268_NRUsage TempUse
ON		IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ToItem AND IBU.Location = TempUse.UsageLoc
GO



----------------------------------------------------------------



select distinct
usage.Location,
usage.ItemNo,
CurPeriodNo,
--CurBegOnHandQty,
--CurBegOnHandDol,
--CurBegOnHandWght,
--CurNoofReceipts,
--CurReceivedQty,
--CurReceivedDol,
--CurReceivedWght,
--CurNoofReturns,
--CurReturnQty,
--CurReturnDol,
--CurReturnWght,
--CurNoofBackOrders,
--CurBackOrderQty,
--CurBackOrderDol,
--CurBackOrderWght,
CurNoofSales,
CurSalesQty,
CurSalesDol,
CurSalesWght,
CurCostDol,
--CurNoofTransfers,
--CurTransferQty,
--CurTransferDol,
--CurTransferWght,
--CurNoofIssues,
--CurIssuesQty,
--CurIssuesDol,
--CurIssuesWght,
--CurNoofAdjust,
--CurAdjustQty,
--CurAdjustDol,
--CurAdjustWght,
--CurNoofChanges,
--CurChangeQty,
--CurChangeDol,
--CurChangeWght,
--CurNoofPO,
--CurPOQty,
--CurPODol,
--CurPOWght,
--CurNoofGER,
--CurGERQty,
--CurGERDol,
--CurGERWght,
--CurNoOfWorkOrders,
--CurWorkOrderQty,
--CurWorkOrderDol,
--CurWorkOrderWght,
--CurLostSlsQty,
--CurDailySlsQty,
--CurDailyRetQty,
--CurEndOHQty,
--CurEndOHDol,
--CurEndOHWght,
--CurNoOfOrders,
CurNRSalesQty,
CurNRNoSales,
CurNRSalesDol,
CurNRSalesWght,
CurNRCostDol,
EntryID,
ChangeID
from	tWO2268_McMasterCarrItems items inner join
		ItemBranchUsage usage
on		items.fromitem = usage.ItemNo
where EntryID = 'WO2268' or ChangeID = 'WO2268'





