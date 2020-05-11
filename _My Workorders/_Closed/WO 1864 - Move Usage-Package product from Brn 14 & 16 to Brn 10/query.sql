--DTS about 1-2 minutes in Test

------------------------------ Process Branch 14 ------------------------------

--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864_MovePkgUsageToBrn10IBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864_MovePkgUsageToBrn10IBU
go

SELECT	DISTINCT ItemNo, Location AS OldLoc, '10' AS NewLoc
INTO	tWO1864_MovePkgUsageToBrn10IBU
FROM	ItemBranchUsage (NoLock)
WHERE	Location = '14' AND 
	SUBSTRING([ItemNo],12,1) NOT IN ('0', '1', '2', '5')
ORDER BY ItemNo, Location
go



--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864ItemBranchUsage
go

SELECT	*
INTO	tWO1864ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.NewLoc)
go




--DELETE existing ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	ItemBranchUsage.ItemNo = NewIBU.ItemNo AND
			ItemBranchUsage.Location = NewIBU.NewLoc)




--UPDATE existing ItemBranchUsage 14 transactions to 10
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1864',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1864_MovePkgUsageToBrn10IBU (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND
	IBU.Location = NewIBU.OldLoc



--UPDATE branch 10 ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1864',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1864ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo




--UPDATE branch 10 ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
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
	CurNRSalesQty, EntryID, EntryDt, 'WO1864' AS ChangeID, GETDATE() AS ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO1864ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU (NoLock)
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)

--------------------------------------------------------------------------------------------------------------------------------------

------------------------------ Process Branch 16 ------------------------------

--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864_MovePkgUsageToBrn10IBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864_MovePkgUsageToBrn10IBU
go

SELECT	DISTINCT ItemNo, Location AS OldLoc, '10' AS NewLoc
INTO	tWO1864_MovePkgUsageToBrn10IBU
FROM	ItemBranchUsage (NoLock)
WHERE	Location = '16' AND 
	SUBSTRING([ItemNo],12,1) NOT IN ('0', '1', '2', '5')
ORDER BY ItemNo, Location
go




--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864ItemBranchUsage
go

SELECT	*
INTO	tWO1864ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.NewLoc)
go




--DELETE existing ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	ItemBranchUsage.ItemNo = NewIBU.ItemNo AND
			ItemBranchUsage.Location = NewIBU.NewLoc)




--UPDATE existing ItemBranchUsage 16 transactions to 10
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1864',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1864_MovePkgUsageToBrn10IBU (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND
	IBU.Location = NewIBU.OldLoc




--UPDATE branch 10 ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1864',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1864ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo




--UPDATE branch 10 ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
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
	CurNRSalesQty, EntryID, EntryDt, 'WO1864' AS ChangeID, GETDATE() AS ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO1864ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU (NoLock)
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)

--------------------------------------------------------------------------------------------------------------------------------------


--Create temp table of Usage to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864_MovePkgUsageToBrn10IBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864_MovePkgUsageToBrn10IBU
go

SELECT	DISTINCT ItemNo, Location AS OldLoc, '10' AS NewLoc
--INTO	tWO1864_MovePkgUsageToBrn10IBU
FROM	ItemBranchUsage (NoLock)
WHERE	SUBSTRING([ItemNo],12,1) NOT IN ('0', '1', '2', '5') AND
	(Location = '14' OR Location = '16')
ORDER BY ItemNo, Location
go




--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1864ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1864ItemBranchUsage
go

SELECT	*
INTO	tWO1864ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.Location = NewIBU.NewLoc)
go





--DELETE existing ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1864_MovePkgUsageToBrn10IBU NewIBU (NoLock)
		 WHERE	ItemBranchUsage.ItemNo = NewIBU.ItemNo AND
			ItemBranchUsage.Location = NewIBU.NewLoc)






--UPDATE existing ItemBranchUsage 14 & 16 transactions to 10
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1864',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1864_MovePkgUsageToBrn10IBU (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND
	IBU.Location = NewIBU.OldLoc



--UPDATE branch 10 ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1864',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1864ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo


--UPDATE branch 10 ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
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
	CurNRSalesQty, EntryID, EntryDt, 'WO1864' AS ChangeID, GETDATE() AS ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	tWO1864ItemBranchUsage TIBU (NoLock)
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU (NoLock)
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)


---------------------------------------------------------------------------------------------

select * from ItemBranchUsage
where Location + '_' + ItemNo + '_' + CAST(CurPeriodNo as VARCHAR(20)) in

(select	'10' + '_' + ItemNo + '_' + CAST(CurPeriodNo as VARCHAR(20)) as Usage
	--Location + '_' + ItemNo + '_' + CAST(CurPeriodNo as VARCHAR(20)) as Usage
FROM	ItemBranchUsage (NoLock)
WHERE	--(ItemNo = '00022-2420-401' or ItemNo='00100-2424-971') AND
	SUBSTRING([ItemNo],12,1) NOT IN ('0', '1', '2', '5') AND left(ItemNo,5)='00050' and
	(Location = '14' OR Location = '16'))



select * from ItemBranchUsage
where 	(ItemNo = '00022-2420-401' or ItemNo='00050-2408-401' or ItemNo='00100-2424-971') and 
	(Location='10' or Location='14' or Location='16')
order by ItemNo, CurPeriodNo, Location


exec sp_columns ItembranchUsage



select count (*) from ItembranchUsage