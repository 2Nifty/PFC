--select right(ItemNo, 9), * from ItemBranchUsage



--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2869_MoveUsageCatToCatIBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO2869_MoveUsageCatToCatIBU
go

SELECT	DISTINCT
		ItemNo as OrigItem, Location, CurPeriodNo,
		--left(ItemNo,5) as OrigCat, 
		CASE left(ItemNo,5)
				WHEN '00720' THEN '02720' + right(ItemNo, 9)
				WHEN '00271' THEN '02721' + right(ItemNo, 9)		--TMD: Is this one (00271) correct?
				WHEN '00726' THEN '02726' + right(ItemNo, 9)
				WHEN '00728' THEN '02728' + right(ItemNo, 9)
				WHEN '00729' THEN '02729' + right(ItemNo, 9)
				WHEN '00740' THEN '02740' + right(ItemNo, 9)
				WHEN '00744' THEN '02744' + right(ItemNo, 9)
				WHEN '00785' THEN '02785' + right(ItemNo, 9)
				WHEN '00786' THEN '02786' + right(ItemNo, 9)
				WHEN '00790' THEN '02790' + right(ItemNo, 9)
				WHEN '00791' THEN '02791' + right(ItemNo, 9)
		END AS NewItem
INTO	tWO2869_MoveUsageCatToCatIBU
FROM	ItemBranchUsage (NoLock)
WHERE	left(ItemNo,5) IN ('00720','00271','00726','00728','00729','00740','00744','00785','00786','00790','00791')
ORDER BY ItemNo, Location, CurPeriodNo
go


--Create temp table of existing ItemBranchUsage NewItem transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2869ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO2869ItemBranchUsage
go

SELECT	*
INTO	tWO2869ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
				 FROM	tWO2869_MoveUsageCatToCatIBU NewIBU (NoLock)
				 WHERE	IBU.ItemNo = NewIBU.NewItem AND
						IBU.Location = NewIBU.Location AND
						IBU.CurPeriodNo = NewIBU.CurPeriodNo)
go

--DELETE existing ItemBranchUsage NewItem transactions that were saved
DELETE
select *
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
				 FROM	tWO2869_MoveUsageCatToCatIBU NewIBU (NoLock)
				 WHERE	ItemBranchUsage.ItemNo = NewIBU.NewItem AND
						ItemBranchUsage.Location = NewIBU.Location AND
						ItemBranchUsage.CurPeriodNo = NewIBU.CurPeriodNo)
go

--UPDATE existing ItemBranchUsage OrigItem transactions to NewItem
UPDATE	ItemBranchUsage
SET		ItemNo = NewIBU.NewItem,
		ChangeID = 'WO2869a',
		ChangeDt = GETDATE()
select NewIBU.NewItem, IBU.*
FROM	ItemBranchUsage IBU INNER JOIN
		(SELECT	* FROM tWO2869_MoveUsageCatToCatIBU (NoLock)) NewIBU
ON		IBU.ItemNo = NewIBU.OrigItem AND IBU.Location = NewIBU.Location AND IBU.CurPeriodNo = NewIBU.CurPeriodNo
go

--UPDATE ItemBranchUsage NewItem transactions: Combine saved & updated items
UPDATE	ItemBranchUsage
SET		ItemBranchUsage.CurNoofSales = ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
		ItemBranchUsage.CurSalesQty = ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
		ItemBranchUsage.CurSalesDol = ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
		ItemBranchUsage.CurSalesWght = ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
		ItemBranchUsage.CurCostDol = ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
		ItemBranchUsage.CurNRSalesQty = ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
		ItemBranchUsage.CurNRNoSales = ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
		ItemBranchUsage.CurNRSalesDol = ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
		ItemBranchUsage.CurNRSalesWght = ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
		ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
		ItemBranchUsage.ChangeID = 'WO2869b',
		ItemBranchUsage.ChangeDt = GETDATE()
select * 
FROM	tWO2869ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
		ItemBranchUsage.Location = TIBU.Location AND
		ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo
go

--UPDATE ItemBranchUsage NewItem transactions: Re-Insert saved items that did not have old usage
INSERT
INTO	ItemBranchUsage
		(Location, ItemNo,
		 CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
		 CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
		 CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
		 CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
		 CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
		 CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
		 CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
		 CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
		 CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
		 CurNoofPO, CurPOQty, CurPODol, CurPOWght,
		 CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
		 CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
		 CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
		 CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
		 CurNRSalesQty, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd,
		 CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol)
SELECT	Location, ItemNo,
		CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
		CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
		CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
		CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
		CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
		CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
		CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
		CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
		CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
		CurNoofPO, CurPOQty, CurPODol, CurPOWght,
		CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
		CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
		CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
		CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
		CurNRSalesQty, 'WO2869' AS EntryID, GETDATE() AS EntryDt, ChangeID, ChangeDt, StatusCd,
		CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO2869ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
				    FROM	ItemBranchUsage IBU (NoLock)
				    WHERE	TIBU.Location = IBU.Location AND
							TIBU.ItemNo = IBU.ItemNo AND
							TIBU.CurPeriodNo = IBU.CurPeriodNo)
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2869_MoveUsageCatToCatIBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO2869_MoveUsageCatToCatIBU
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2869ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO2869ItemBranchUsage
go
