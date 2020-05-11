
--8939791 records
select count(*) from [Porteous$Actual Usage Entry]


--207785 records
select count(*) from PFCReports.dbo.ItemBranchUsage

--29,467 records
select distinct ItemNo from PFCReports.dbo.ItemBranchUsage
order by ItemNo

select distinct left(ItemNo,5) from ItemBranchUsage
order by left(ItemNo,5)



select * from PFCReports.dbo.ItemBranchUsage
select max(CurPeriodNo) from PFCReports.dbo.ItemBranchUsage


select * from [Porteous$Actual Usage Entry]
exec sp_columns [Porteous$Actual Usage Entry]



select * from ItemBranchUsage
select * from tItemBranchUsage




-------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1112NucorNutsAndMetricsAUE') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1112NucorNutsAndMetricsAUE

SELECT	*
INTO	tWO1112NucorNutsAndMetricsAUE
FROM
(
SELECT	DISTINCT [Item No_] AS OldItem, [Usage Location] AS Location,
	CASE LEFT([Item No_],5)
		WHEN '00056' THEN CASE SUBSTRING([Item No_],12,2)
					WHEN '02' THEN LEFT([Item No_],11) + '04' + RIGHT([Item No_],1)
				  END
		WHEN '00057' THEN CASE SUBSTRING([Item No_],12,2)
					WHEN '02' THEN LEFT([Item No_],11) + '04' + RIGHT([Item No_],1)
				  END
		WHEN '00080' THEN CASE SUBSTRING([Item No_],12,2)
					WHEN '02' THEN LEFT([Item No_],11) + '04' + RIGHT([Item No_],1)
				  END
		WHEN '00081' THEN CASE SUBSTRING([Item No_],12,2)
					WHEN '02' THEN LEFT([Item No_],11) + '04' + RIGHT([Item No_],1)
				  END
		WHEN '00208' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '00209' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '00242' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
		WHEN '00243' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
		WHEN '20056' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
					WHEN '080' THEN LEFT([Item No_],11) + '090'
					WHEN '081' THEN LEFT([Item No_],11) + '091'
				  END
		WHEN '20057' THEN CASE RIGHT([Item No_],3)
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '20058' THEN CASE RIGHT([Item No_],3)
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '20080' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
	END AS NewItem
FROM	[Porteous$Actual Usage Entry] AUE
WHERE	((LEFT([Item No_],5)='00056' and SUBSTRING([Item No_],12,2)='02') OR
	 (LEFT([Item No_],5)='00057' and SUBSTRING([Item No_],12,2)='02') OR
	 (LEFT([Item No_],5)='00080' and SUBSTRING([Item No_],12,2)='02') OR
	 (LEFT([Item No_],5)='00081' and SUBSTRING([Item No_],12,2)='02') OR
	 (LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='022') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='022') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='080') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='081') OR 
	 (LEFT([Item No_],5)='20057' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20058' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='022')) AND
	[Usage Location] <> ''
) AUE
WHERE EXISTS (SELECT * FROM [Porteous$Stockkeeping Unit] WHERE [Location Code]=Location AND [Item No_]=NewItem)
ORDER BY OldItem, Location



select * from tWO1112NucorNutsAndMetricsAUE

delete  from tWO1112NucorNutsAndMetricsAUE



-------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tItemBranchUsage

SELECT	*
INTO	tItemBranchUsage
FROM	ItemBranchUsage IBU
WHERE EXISTS
(SELECT	1
FROM PFCTnT.dbo.tWO1112NucorNutsAndMetricsAUE TNI
 WHERE	ItemNo = NewItem COLLATE SQL_Latin1_General_CP1_CI_AS AND
	IBU.Location = TNI.Location COLLATE SQL_Latin1_General_CP1_CI_AS)



select * from tItemBranchUsage



--Delete existing ItemBranchUsage that was saved
DELETE FROM	PFCReports.dbo.ItemBranchUsage
WHERE EXISTS	(SELECT	1
		 FROM	tWO1112NucorNutsAndMetricsAUE Nucor
		 WHERE	NewItem = ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
			Nucor.Location = Location COLLATE SQL_Latin1_General_CP1_CI_AS)



DECLARE	@factor	DECIMAL(18,5)
SET	@factor = 1.25

--Update ItemBranchUsage ItemNo, CurSales, CurNRSalesQty
UPDATE	PFCReports.dbo.ItemBranchUsage
SET	ItemNo = NewItem,
	CurSalesQty = ROUND((IBU.CurSalesQty * @factor),0),
	CurNRSalesQty = ROUND((IBU.CurNRSalesQty * @factor),0)
FROM	PFCReports.dbo.ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1112NucorNutsAndMetricsAUE) [40Lb]
ON	[40Lb].OldItem = IBU.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
	[40Lb].Location = IBU.Location COLLATE SQL_Latin1_General_CP1_CI_AS



--UPDATE ItemBranchUsage: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1112_ConvertNucorNutsAndMetricsAUE'
FROM	tItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo









--UPDATE ItemBranchUsage: Insert new items that did not have old sales
INSERT INTO	ItemBranchUsage
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
SELECT		Location, ItemNo,
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
FROM		tItemBranchUsage TIBU
WHERE NOT EXISTS
(SELECT	1
 FROM	ItemBranchUsage IBU
 WHERE	TIBU.Location = IBU.Location AND
	TIBU.ItemNo = IBU.ItemNo AND
	TIBU.CurPeriodNo = IBU.CurPeriodNo)








