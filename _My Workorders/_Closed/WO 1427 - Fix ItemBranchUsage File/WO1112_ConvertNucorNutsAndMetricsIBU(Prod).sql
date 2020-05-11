
--Create temp table of SKU's to be updated
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1112NucorNutsAndMetricsIBU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1112NucorNutsAndMetricsIBU

SELECT	*
INTO	tWO1112NucorNutsAndMetricsIBU
FROM
(
SELECT	DISTINCT ItemNo AS OldItem, Location,  --CurPeriodNo,
	CASE LEFT(ItemNo,5)
		WHEN '00056' THEN CASE SUBSTRING(ItemNo,12,2)
					WHEN '02' THEN LEFT(ItemNo,11) + '04' + RIGHT(ItemNo,1)
				  END
		WHEN '00057' THEN CASE SUBSTRING(ItemNo,12,2)
					WHEN '02' THEN LEFT(ItemNo,11) + '04' + RIGHT(ItemNo,1)
				  END
		WHEN '00080' THEN CASE SUBSTRING(ItemNo,12,2)
					WHEN '02' THEN LEFT(ItemNo,11) + '04' + RIGHT(ItemNo,1)
				  END
		WHEN '00081' THEN CASE SUBSTRING(ItemNo,12,2)
					WHEN '02' THEN LEFT(ItemNo,11) + '04' + RIGHT(ItemNo,1)
				  END
		WHEN '00208' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '021' THEN LEFT(ItemNo,11) + '041'
				  END
		WHEN '00209' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '021' THEN LEFT(ItemNo,11) + '041'
				  END
		WHEN '00242' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '022' THEN LEFT(ItemNo,11) + '042'
				  END
		WHEN '00243' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '022' THEN LEFT(ItemNo,11) + '042'
				  END
		WHEN '20056' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '021' THEN LEFT(ItemNo,11) + '041'
					WHEN '080' THEN LEFT(ItemNo,11) + '090'
					WHEN '081' THEN LEFT(ItemNo,11) + '091'
				  END
		WHEN '20057' THEN CASE RIGHT(ItemNo,3)
					WHEN '021' THEN LEFT(ItemNo,11) + '041'
				  END
		WHEN '20058' THEN CASE RIGHT(ItemNo,3)
					WHEN '021' THEN LEFT(ItemNo,11) + '041'
				  END
		WHEN '20080' THEN CASE RIGHT(ItemNo,3)
					WHEN '020' THEN LEFT(ItemNo,11) + '040'
					WHEN '022' THEN LEFT(ItemNo,11) + '042'
				  END
	END AS NewItem
FROM	ItemBranchUsage
WHERE	Location <> '' AND
	((LEFT(ItemNo,5)='00056' and SUBSTRING(ItemNo,12,2)='02') OR
	 (LEFT(ItemNo,5)='00057' and SUBSTRING(ItemNo,12,2)='02') OR
	 (LEFT(ItemNo,5)='00080' and SUBSTRING(ItemNo,12,2)='02') OR
	 (LEFT(ItemNo,5)='00081' and SUBSTRING(ItemNo,12,2)='02') OR
	 (LEFT(ItemNo,5)='00208' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='00208' and RIGHT(ItemNo,3)='021') OR 
	 (LEFT(ItemNo,5)='00209' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='00209' and RIGHT(ItemNo,3)='021') OR 
	 (LEFT(ItemNo,5)='00242' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='00242' and RIGHT(ItemNo,3)='022') OR 
	 (LEFT(ItemNo,5)='00243' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='00243' and RIGHT(ItemNo,3)='022') OR 
	 (LEFT(ItemNo,5)='20056' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='20056' and RIGHT(ItemNo,3)='021') OR 
	 (LEFT(ItemNo,5)='20056' and RIGHT(ItemNo,3)='080') OR 
	 (LEFT(ItemNo,5)='20056' and RIGHT(ItemNo,3)='081') OR 
	 (LEFT(ItemNo,5)='20057' and RIGHT(ItemNo,3)='021') OR 
	 (LEFT(ItemNo,5)='20058' and RIGHT(ItemNo,3)='021') OR 
	 (LEFT(ItemNo,5)='20080' and RIGHT(ItemNo,3)='020') OR 
	 (LEFT(ItemNo,5)='20080' and RIGHT(ItemNo,3)='022'))
) IBU
WHERE	EXISTS (SELECT	*
		FROM	ItemBranch INNER JOIN
			ItemMaster
		ON	pItemMasterID = fItemMasterID
		WHERE	IBU.Location = ItemBranch.Location AND IBU.NewItem = ItemMaster.ItemNo)
ORDER BY OldItem, Location




--Create temp table of existing 04? ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1112ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1112ItemBranchUsage

SELECT	*
INTO	tWO1112ItemBranchUsage
FROM	ItemBranchUsage IBU
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND
			IBU.Location = Nucor.Location)




--DELETE existing 04? ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage
WHERE EXISTS	(SELECT	*
		 FROM	tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	ItemBranchUsage.ItemNo = Nucor.NewItem AND
			ItemBranchUsage.Location = Nucor.Location)





--UPDATE 02? ItemBranchUsage transactions: ItemNo, CurSales, CurNRSalesQty
DECLARE	@factor	DECIMAL(18,5)
SET	@factor = 1.25

UPDATE	ItemBranchUsage
SET	ItemNo = NewItem,
	CurSalesQty = ROUND((IBU.CurSalesQty * @factor),0),
	CurNRSalesQty = ROUND((IBU.CurNRSalesQty * @factor),0),
	ChangeID = 'WO1112_ConvertNucorNutsAndMetricsIBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1112NucorNutsAndMetricsIBU) Nucor
ON	IBU.ItemNo = Nucor.OldItem AND
	IBU.Location = Nucor.Location





--UPDATE 04? ItemBranchUsage transactions: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1112_ConvertNucorNutsAndMetricsIBU',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO1112ItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo





--UPDATE 04? ItemBranchUsage transactions: Re-Insert saved items that did not have old sales
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
FROM	tWO1112ItemBranchUsage TIBU
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)
