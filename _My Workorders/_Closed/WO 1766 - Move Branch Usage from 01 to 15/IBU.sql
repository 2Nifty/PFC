
select * from tWO1766MoveUsage01to15IBU
select * from tWO1766ItemBranchUsage


select * FROM	ItemBranchUsage IBU (NoLock)
WHERE	Location = '01' AND
	(SUBSTRING([ItemNo],12,1) = '0' OR 
	 SUBSTRING([ItemNo],12,1) = '1' OR 
	 SUBSTRING([ItemNo],12,1) = '5') 
and EXISTS	(SELECT	*
		 FROM	ItemBranchUsage NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.CurPeriodNo = NewIBU.CurPeriodNo and NewIBU.Location='01')



exec sp_columns ItembranchUsage



select Location,ItemNo,CurPeriodNo,CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNoOfOrders,CurNRSalesQty,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
from ItemBranchUsage
where	ItemNo='00020-2408-021' or
	ItemNo='00110-3062-021' or
	ItemNo='00299-0120-500' or
	ItemNo='00212-4100-104'
order by Location, CurPeriodNo




--------------------------------------------------------------------------------------------------------

--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1766MoveUsage01to15IBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1766MoveUsage01to15IBU
go

--DEVPERP - 9830 records - less than 1 minute
SELECT	DISTINCT ItemNo, Location AS OldLoc, '15' AS NewLoc
INTO	tWO1766MoveUsage01to15IBU
FROM	ItemBranchUsage (NoLock)
WHERE	Location = '01' AND
	(SUBSTRING([ItemNo],12,1) = '0' OR 
	 SUBSTRING([ItemNo],12,1) = '1' OR 
	 SUBSTRING([ItemNo],12,1) = '5')
ORDER BY ItemNo, Location
go


--------------------------------------------------------------------------------------------------------


--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1766ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1766ItemBranchUsage
go

--DEVPERP - 76723 records - less than 1 minute
SELECT	*
INTO	tWO1766ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1766MoveUsage01to15IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.NewLoc)
go


--------------------------------------------------------------------------------------------------------

----DEVPERP - 76723 records - less than 1 minute
--DELETE existing ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1766MoveUsage01to15IBU NewIBU (NoLock)
		 WHERE	ItemBranchUsage.ItemNo = NewIBU.ItemNo AND
			ItemBranchUsage.Location = NewIBU.NewLoc)


--------------------------------------------------------------------------------------------------------


----DEVPERP - 75471 records - about 3 minutes
--UPDATE existing ItemBranchUsage 01 transactions to 15
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1766',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1766MoveUsage01to15IBU (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND
	IBU.Location = NewIBU.OldLoc


--------------------------------------------------------------------------------------------------------


----DEVPERP - 28982 records - less than 1 minute
--UPDATE branch 15 ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1766',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1766ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo



--------------------------------------------------------------------------------------------------------


----DEVPERP - 47728 records - about 2 minutes
--UPDATE branch 15 ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
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
	CurNRSalesQty, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO1766ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU (NoLock)
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)
