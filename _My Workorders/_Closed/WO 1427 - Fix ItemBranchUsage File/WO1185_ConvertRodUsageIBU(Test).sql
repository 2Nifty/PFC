tItemBranchUsage05Aug2009


--Create temp table of existing 02? ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185ItemBranchUsage

SELECT	IBU.*
INTO	tWO1185ItemBranchUsage
FROM	tItemBranchUsage05Aug2009 IBU, tWO1185RodItems Rod
WHERE	IBU.ItemNo = SUBSTRING(Rod.ItemNo,1,11) + '02' + SUBSTRING(Rod.ItemNo,14,1) AND IBU.Location = Rod.Location




--DELETE existing 02? ItemBranchUsage transactions that were saved
DELETE
FROM	tItemBranchUsage05Aug2009
WHERE EXISTS (SELECT	*
	      FROM	tWO1185RodItems Rod
	      WHERE	tItemBranchUsage05Aug2009.ItemNo = SUBSTRING(Rod.ItemNo,1,11) + '02' + SUBSTRING(Rod.ItemNo,14,1) AND
			tItemBranchUsage05Aug2009.Location = Rod.Location)





--UPDATE 50? ItemBranchUsage transactions: CurSales, CurNRSalesQty

--Negative quantity
UPDATE	tItemBranchUsage05Aug2009
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
FROM	tItemBranchUsage05Aug2009 IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location INNER JOIN
	tWO1185RodFactor RodFactor
ON	Rods.ItemNo = RodFactor.Item
WHERE	IBU.CurNRSalesQty < 0 OR IBU.CurSalesQty < 0

--Positive quantity
UPDATE	tItemBranchUsage05Aug2009
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
FROM	tItemBranchUsage05Aug2009 IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location INNER JOIN
	tWO1185RodFactor RodFactor
ON	Rods.ItemNo = RodFactor.Item
--WHERE	IBU.CurSalesQty > 0




--UPDATE 50? ItemBranchUsage transactions: ItemNo
UPDATE	tItemBranchUsage05Aug2009
SET	ItemNo = SUBSTRING(IBU.ItemNo,1,11) + '02' + SUBSTRING(IBU.ItemNo,14,1),
	ChangeID = 'WO1185_ConvertRodUsageIBU',
	ChangeDt = GETDATE()
FROM	tItemBranchUsage05Aug2009 IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1185RodItems) Rods
ON	IBU.ItemNo = Rods.ItemNo AND IBU.Location = Rods.Location






--UPDATE 02? ItemBranchUsage transactions: Combine saved & updated items
UPDATE	tItemBranchUsage05Aug2009
SET	tItemBranchUsage05Aug2009.CurNoofSales = tItemBranchUsage05Aug2009.CurNoofSales + TIBU.CurNoofSales,
	tItemBranchUsage05Aug2009.CurSalesQty = tItemBranchUsage05Aug2009.CurSalesQty + TIBU.CurSalesQty,
	tItemBranchUsage05Aug2009.CurSalesDol = tItemBranchUsage05Aug2009.CurSalesDol + TIBU.CurSalesDol,
	tItemBranchUsage05Aug2009.CurSalesWght = tItemBranchUsage05Aug2009.CurSalesWght + TIBU.CurSalesWght,
	tItemBranchUsage05Aug2009.CurCostDol = tItemBranchUsage05Aug2009.CurCostDol + TIBU.CurCostDol,
	tItemBranchUsage05Aug2009.CurNRSalesQty = tItemBranchUsage05Aug2009.CurNRSalesQty + TIBU.CurNRSalesQty,
	tItemBranchUsage05Aug2009.CurNRNoSales = tItemBranchUsage05Aug2009.CurNRNoSales + TIBU.CurNRNoSales,
	tItemBranchUsage05Aug2009.CurNRSalesDol = tItemBranchUsage05Aug2009.CurNRSalesDol + TIBU.CurNRSalesDol,
	tItemBranchUsage05Aug2009.CurNRSalesWght = tItemBranchUsage05Aug2009.CurNRSalesWght + TIBU.CurNRSalesWght,
	tItemBranchUsage05Aug2009.CurNRCostDol = tItemBranchUsage05Aug2009.CurNRCostDol + TIBU.CurNRCostDol,
	tItemBranchUsage05Aug2009.ChangeID = 'WO1185_ConvertRodUsageIBU',
	tItemBranchUsage05Aug2009.ChangeDt = GETDATE()
FROM	tWO1185ItemBranchUsage TIBU
WHERE	tItemBranchUsage05Aug2009.ItemNo = TIBU.ItemNo AND tItemBranchUsage05Aug2009.Location = TIBU.Location AND tItemBranchUsage05Aug2009.CurPeriodNo = TIBU.CurPeriodNo






--UPDATE 02? ItemBranchUsage transactions: Re-Insert saved items that did not have old usage
INSERT
INTO	tItemBranchUsage05Aug2009
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
		    FROM   tItemBranchUsage05Aug2009 IBU
		    WHERE  TIBU.Location = IBU.Location AND
			   TIBU.ItemNo = IBU.ItemNo AND
			   TIBU.CurPeriodNo = IBU.CurPeriodNo)


