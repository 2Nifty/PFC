--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1856MoveUsage30to10IBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1856MoveUsage30to10IBU
go

SELECT	DISTINCT ItemNo, Location AS OldLoc, '10' AS NewLoc
INTO	tWO1856MoveUsage30to10IBU
FROM	ItemBranchUsage (NoLock)
WHERE	Location = '30'
ORDER BY ItemNo, Location
go

--------------------------------------------------------------------------------------------------------------------------

--Create temp table of existing ItemBranchUsage 10 transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1856ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1856ItemBranchUsage
go

SELECT	*
INTO	tWO1856ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1856MoveUsage30to10IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.NewLoc)
go

--------------------------------------------------------------------------------------------------------------------------

--DELETE existing ItemBranchUsage 10 transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1856MoveUsage30to10IBU NewIBU (NoLock)
		 WHERE	ItemBranchUsage.ItemNo = NewIBU.ItemNo AND
			ItemBranchUsage.Location = NewIBU.NewLoc)
go

--------------------------------------------------------------------------------------------------------------------------

--UPDATE existing ItemBranchUsage 30 transactions to 10
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1856',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1856MoveUsage30to10IBU (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND IBU.Location = NewIBU.OldLoc
go

--------------------------------------------------------------------------------------------------------------------------

--UPDATE ItemBranchUsage 10 transactions: Combine saved & updated items
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
FROM	tWO1856ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo
go

--------------------------------------------------------------------------------------------------------------------------

--UPDATE ItemBranchUsage 10 transactions: Re-Insert saved items that did not have old usage
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
	CurNRSalesQty, EntryID, EntryDt, 'WO1856' AS ChangeID, GETDATE() AS ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO1856ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU (NoLock)
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)
go



--------------------------------------------------------------------------------------------------------

--only 1 record in QA
select UsageLocation, * from CustomerMaster 
WHERE	UsageLocation = '30'


UPDATE	CustomerMaster
SET	UsageLocation = '10',
	ChangeID = 'WO1856',
	ChangeDt = GETDATE()
WHERE	UsageLocation = '30'




--0 records in NV5 QA
select * from [Porteous$Customer] where [Usage Location]='30'


UPDATE	[Porteous$Customer]
SET	[Usage Location] = '10'
WHERE	[Usage Location] = '30'




--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--QA

exec sp_columns ItembranchUsage

select * from ItemBranchUsage where Location='30'
order by ItemNo, CurPeriodNo


select * from ItemBranchUsage
where	Location='30' and
	ItemNo+cast(CurPeriodNo as varchar(20)) not in (select ItemNo+cast(CurPeriodNo as varchar(20)) from ItemBranchUsage where Location='10')


where
(Location='10' or Location='30') and
((ItemNo='00080-2516-040' and CurPeriodNo='200902') or
(ItemNo='00080-2627-042' and CurPeriodNo='200812') or
(ItemNo='00080-2726-042' and CurPeriodNo='200812') or
(ItemNo='00080-2820-042' and CurPeriodNo='200812') or
(ItemNo='00080-3022-042' and CurPeriodNo='200812') or
(ItemNo='00080-3025-042' and CurPeriodNo='200812') or
(ItemNo='00080-3026-042' and CurPeriodNo='200812') or
(ItemNo='00080-3224-040' and CurPeriodNo='200812') or
(ItemNo='00080-4252-040' and CurPeriodNo='200811') or
(ItemNo='00081-3030-042' and CurPeriodNo='200812') or
(ItemNo='00081-3032-042' and CurPeriodNo='200812') or
(ItemNo='00200-2400-020' and CurPeriodNo='200810') or
(ItemNo='00200-2400-020' and CurPeriodNo='200811'))

