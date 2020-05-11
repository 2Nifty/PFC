
select * from tItemBranchUsage05Aug2009



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
FROM	tItemBranchUsage05Aug2009
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




--Save existing tItemBranchUsage05Aug2009
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1112ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1112ItemBranchUsage

SELECT	*
INTO	tWO1112ItemBranchUsage
FROM	tItemBranchUsage05Aug2009 IBU
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND
			IBU.Location = Nucor.Location)




--Delete existing tItemBranchUsage05Aug2009 that was saved
DELETE
FROM	tItemBranchUsage05Aug2009
WHERE EXISTS	(SELECT	*
		 FROM	tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	tItemBranchUsage05Aug2009.ItemNo = Nucor.NewItem AND
			tItemBranchUsage05Aug2009.Location = Nucor.Location)






DECLARE	@factor	DECIMAL(18,5)
SET	@factor = 1.25

--Update tItemBranchUsage05Aug2009: ItemNo, CurSales, CurNRSalesQty
UPDATE	tItemBranchUsage05Aug2009
SET	ItemNo = NewItem,
	CurSalesQty = ROUND((IBU.CurSalesQty * @factor),0),
	CurNRSalesQty = ROUND((IBU.CurNRSalesQty * @factor),0),
	ChangeID = 'WO1112_ConvertNucorNutsAndMetricsIBU',
	ChangeDt = GETDATE()
FROM	tItemBranchUsage05Aug2009 IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1112NucorNutsAndMetricsIBU) Nucor
ON	IBU.ItemNo = Nucor.OldItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
	IBU.Location = Nucor.Location --COLLATE SQL_Latin1_General_CP1_CI_AS





--UPDATE tItemBranchUsage05Aug2009: Combine saved & updated items
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
	tItemBranchUsage05Aug2009.ChangeID = 'WO1112_ConvertNucorNutsAndMetricsIBU',
	tItemBranchUsage05Aug2009.ChangeDt = GETDATE()
FROM	tWO1112ItemBranchUsage TIBU
WHERE	tItemBranchUsage05Aug2009.ItemNo = TIBU.ItemNo AND
	tItemBranchUsage05Aug2009.Location = TIBU.Location AND
	tItemBranchUsage05Aug2009.CurPeriodNo = TIBU.CurPeriodNo





--UPDATE tItemBranchUsage05Aug2009: Re-Insert saved items that did not have old sales
INSERT
INTO	tItemBranchUsage05Aug2009
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
		    FROM	tItemBranchUsage05Aug2009 IBU
		    WHERE	TIBU.Location = IBU.Location AND
				TIBU.ItemNo = IBU.ItemNo AND
				TIBU.CurPeriodNo = IBU.CurPeriodNo)
