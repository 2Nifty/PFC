--truncate table tRodFactor
--truncate table tRodItems
--truncate table tItemPointer
--truncate table tItemBranchUsage

--drop table tCheckRodItems
--drop table tItemBranchUsageBackup


truncate table tWO1185RodFactor	--truncate
truncate table tWO1185RodItems	--DROP
--truncate table tWO1185ItemPointer	--n/a
truncate table tWO1185ItemBranchUsage	--drop






select * from tWO1185RodFactor
order by Item



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185RodItems') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185RodItems

--SELECT Items for update
SELECT	OldSKU.ItemNo, OldSKU.Location
--INTO	tWO1185RodItems
FROM	ItemBranch NewSKU INNER JOIN
	ItemMaster NewItem
ON	pItemMasterID = fItemMasterID INNER JOIN
	(SELECT	LEFT(ItemNo,11) + RIGHT(ItemNo,1) AS CheckItem50, ItemMaster.ItemNo, ItemBranch.*
	 FROM	ItemBranch INNER JOIN
		ItemMaster
	 ON	pItemMasterID = fItemMasterID
	 WHERE	(LEFT(ItemNo,5) = '00170' or LEFT(ItemNo,5) = '00171' or LEFT(ItemNo,5) = '04170' or LEFT(ItemNo,5) = '04171' or
		 LEFT(ItemNo,5) = '04172') and SUBSTRING(ItemNo,12,2) = '50') OldSKU
ON	LEFT(NewItem.ItemNo,11) + RIGHT(NewItem.ItemNo,1) = CheckItem50 and NewSKU.Location = OldSKU.Location INNER JOIN
	tWO1185RodFactor RodFactor
ON	OldSKU.ItemNo = RodFactor.Item
WHERE	(LEFT(NewItem.ItemNo,5) = '00170' or LEFT(NewItem.ItemNo,5) = '00171' or LEFT(NewItem.ItemNo,5) = '04170' or
	 LEFT(NewItem.ItemNo,5) = '04171' or LEFT(NewItem.ItemNo,5) = '04172') and SUBSTRING(NewItem.ItemNo,12,2) = '02'

order by OldSKU.ItemNo, OldSKU.Location





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185ItemBranchUsageBackup') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185ItemBranchUsageBackup

SELECT	IBU.*
INTO	tWO1185ItemBranchUsageBackup
FROM	[ItemBranchUsage] IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo and IBU.Location = Rods.Location




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tCheckRodItems') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tCheckRodItems

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185CheckRodItems') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185CheckRodItems

--SELECT Items for update
SELECT	--DISTINCT 
OldSKU.[Item No_], OldSKU.[Location Code]
--INTO	tWO1185CheckRodItems
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON	Item.[No_]=NewSKU.[Item No_]
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'
order by OldSKU.[Item No_]





--Find Rod items with no conversion factor
SELECT	DISTINCT ItemNo
FROM	tWO1185RodItems
WHERE	NOT EXISTS (SELECT * FROM tWO1185RodFactor WHERE ItemNo = Item)




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185ItemBranchUsage

SELECT	IBU.*
INTO	tWO1185ItemBranchUsage
FROM	ItemBranchUsage IBU, tWO1185RodItems Rod
WHERE	IBU.ItemNo = SUBSTRING(Rod.ItemNo,1,11) + '02' + SUBSTRING(Rod.ItemNo,14,1) AND IBU.Location = Rod.Location


select * from tWO1185ItemBranchUsage




DELETE
FROM	ItemBranchUsage
WHERE EXISTS (SELECT	*
	      FROM	tWO1185RodItems Rod
	      WHERE	ItemBranchUsage.ItemNo = SUBSTRING(Rod.ItemNo,1,11) + '02' + SUBSTRING(Rod.ItemNo,14,1) AND
			ItemBranchUsage.Location = Rod.Location)




----Update ItemBranchUsage CurSalesQty and CurNRSalesQty

--Negative quantity
UPDATE	ItemBranchUsage
SET	CurSalesQty =	CASE WHEN CurSalesQty < 0
			     THEN ISNULL(NULLIF(ROUND((CurSalesQty * RodFactor.UseFct),0),0),-1)
			     ELSE CurSalesQty
			END,
	CurNRSalesQty =	CASE WHEN CurNRSalesQty < 0
			     THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * RodFactor.UseFct),0),0),-1)
			     ELSE CurNRSalesQty
			END,
	ChangeID = 'WO1185_ConvertRodUsageIBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location INNER JOIN
	tWO1185RodFactor RodFactor
ON	Rods.ItemNo = RodFactor.Item
WHERE	IBU.CurNRSalesQty < 0 OR IBU.CurSalesQty < 0

--Positive quantity
UPDATE	ItemBranchUsage
SET	CurSalesQty =	CASE WHEN CurSalesQty > 0
			     THEN ISNULL(NULLIF(ROUND((CurSalesQty * RodFactor.UseFct),0),0),1)
			     ELSE CurSalesQty
			END,
	CurNRSalesQty =	CASE WHEN CurNRSalesQty > 0
			     THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * RodFactor.UseFct),0),0),1)
			     ELSE CurNRSalesQty
			END,
	ChangeID = 'WO1185_ConvertRodUsageIBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location INNER JOIN
	tWO1185RodFactor RodFactor
ON	Rods.ItemNo = RodFactor.Item
--WHERE	IBU.CurSalesQty > 0





--Update ItemBranchUsage.ItemNo
UPDATE	ItemBranchUsage
SET	ItemNo = SUBSTRING(IBU.ItemNo,1,11) + '02' + SUBSTRING(IBU.ItemNo,14,1),
	ChangeID = 'WO1185_ConvertRodUsageIBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location






--UPDATE 02? ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1185_ConvertRodUsageIBU',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1185ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND ItemBranchUsage.Location = TIBU.Location AND ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo




--UPDATE 02? ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
INSERT
INTO	ItemBranchUsage
	(Location,ItemNo,CurPeriodNo,
	 CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
	 CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
	 CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
	 CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
	 CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
	 CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
	 CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
	 CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
	 CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
	 CurNoofPO,CurPOQty,CurPODol,CurPOWght,
	 CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
	 CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	 CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	 CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
	 CurNRSalesQty, EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,
	 CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol)
SELECT	Location,ItemNo,
	CurPeriodNo,CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
	CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
	CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
	CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
	CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
	CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
	CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
	CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
	CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
	CurNoofPO,CurPOQty,CurPODol,CurPOWght,
	CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
	CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
	CurNRSalesQty, EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,
	CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
FROM	tWO1185ItemBranchUsage TIBU
WHERE	NOT EXISTS (SELECT *
		    FROM   ItemBranchUsage IBU
		    WHERE  TIBU.Location = IBU.Location AND
			   TIBU.ItemNo = IBU.ItemNo AND
			   TIBU.CurPeriodNo = IBU.CurPeriodNo)







select * from ItemBranchUsage
