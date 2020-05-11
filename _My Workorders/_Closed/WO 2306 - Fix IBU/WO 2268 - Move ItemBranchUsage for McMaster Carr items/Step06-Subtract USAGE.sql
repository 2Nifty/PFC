--Subtract USAGE from existing ItemBranchUsage transactions
--Less than 1 minute in DEV (879 rows affected)
UPDATE	ItemBranchUsage
SET		CurNoofSales = ISNULL(CurNoofSales,0) - TempUse.TotCount,
		CurSalesQty = ISNULL(CurSalesQty,0) - TempUse.TotQty,
		CurSalesDol = ISNULL(CurSalesDol,0) - TempUse.TotDol,
		CurSalesWght = ISNULL(CurSalesWght,0) - TempUse.TotWght,
		CurCostDol = ISNULL(CurCostDol,0) - TempUse.TotCostDol,
		ChangeDt = GetDate(),
		ChangeID = 'WO2268'
FROM	ItemBranchUsage IBU INNER JOIN
		tWO2268_SalesUsage TempUse
ON		IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.FromItem AND IBU.Location = TempUse.UsageLoc
GO

--Subtract USAGE from existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (1 row affected)
UPDATE	ItemBranchUsage
SET		CurNoofSales = ISNULL(CurNoofSales,0) - TempUse.TotCount,
		CurSalesQty = ISNULL(CurSalesQty,0) - TempUse.TotQty,
		CurSalesDol = ISNULL(CurSalesDol,0) - TempUse.TotDol,
		CurSalesWght = ISNULL(CurSalesWght,0) - TempUse.TotWght,
		CurCostDol = ISNULL(CurCostDol,0) - TempUse.TotCostDol,
		CurNRNoSales = ISNULL(CurNRNoSales,0) - TempUse.TotCount,
		CurNRSalesQty = ISNULL(CurNRSalesQty,0) - TempUse.TotQty,
		CurNRSalesDol = ISNULL(CurNRSalesDol,0) - TempUse.TotDol,
		CurNRSalesWght = ISNULL(CurNRSalesWght,0) - TempUse.TotWght,
		CurNRCostDol = ISNULL(CurNRCostDol,0) - TempUse.TotCostDol,
		ChangeDt = GetDate(),
		ChangeID = 'WO2268'
FROM	ItemBranchUsage IBU INNER JOIN
		tWO2268_NRUsage TempUse
ON		IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.FromItem AND IBU.Location = TempUse.UsageLoc
GO


----------------------------------------------------------------

select * from ItemBranchUsage where EntryID = 'WO2268' or ChangeID = 'WO2268'