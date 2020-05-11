select count(*) from ItemBranchUsage --2025728
--select * from ItemBranchUsage


--606 records
select IBU.* from ItemBranchUsage IBU inner join
(
select * from
(select Count(*) as reccount, Location, ItemNo, CurPeriodNo from ItemBranchUsage ---2025375
group by Location, ItemNo, CurPeriodNo) tmp
where reccount > 1
) dups
on IBU.Location = dups.Location and IBU.ItemNo = dups.ItemNo and IBU.CurPeriodNo = dups.CurPeriodNo
order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo




--27 duplicates
select * from ItemBranchUsage
where Location='10' and ItemNo='00200-2400-021' and CurPeriodNo='200902'



--572
--these are the ones that are 100% identical
select IBU.* from ItemBranchUsage IBU inner join
(
select * from
(select Count(*) as reccount,
Location,
ItemNo,
CurPeriodNo
from ItemBranchUsage
group by 
Location,ItemNo,
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
CurNoOfWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNoOfOrders,
CurNRSalesQty,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol) tmp
where reccount > 1
) dups
on IBU.Location = dups.Location and IBU.ItemNo = dups.ItemNo and IBU.CurPeriodNo = dups.CurPeriodNo
order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo

--------------------------------------------------------------------------------------------------

SELECT	DISTINCT
	Location,ItemNo,
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
	CurNoOfWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNoOfOrders,
	CurNRSalesQty,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
FROM	ItemBranchUsage (NoLock)




--------------------------------------------------------------------------------------------------



select IBU.* from tempItemBranchUsage IBU inner join
(
select * from
(select Count(*) as reccount, Location, ItemNo, CurPeriodNo from tempItemBranchUsage
group by Location, ItemNo, CurPeriodNo) tmp
where reccount > 1
) dups
on IBU.Location = dups.Location and IBU.ItemNo = dups.ItemNo and IBU.CurPeriodNo = dups.CurPeriodNo
order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo










SELECT	DISTINCT
	Location,ItemNo,CurPeriodNo,
	--CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
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
	CurNoOfWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	--CurEndOHQty,CurEndOHDol,CurEndOHWght,
	CurNoOfOrders,CurNRSalesQty,
	EntryID, CAST (FLOOR (CAST (EntryDt AS FLOAT)) AS DATETIME) as EntryDt,
	'FixDups' AS ChangeID, CAST (FLOOR (CAST (GETDATE() AS FLOAT)) AS DATETIME) AS ChangeDt,
	CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
FROM	ItemBranchUsage (NoLock)


UPDATE	tempItemBranchUsage
SET	CurBegOnHandQty = IBU.CurBegOnHandQty,
	CurBegOnHandDol = IBU.CurBegOnHandDol,
	CurBegOnHandWght = IBU.CurBegOnHandWght,
	CurEndOHQty = IBU.CurEndOHQty,
	CurEndOHDol = IBU.CurEndOHDol,
	CurEndOHWght = IBU.CurEndOHWght,
	ChangeID = 'FixDups',
	ChangeDt = CAST (FLOOR (CAST (GETDATE() AS FLOAT)) AS DATETIME)
FROM	ItemBranchUsage IBU
WHERE	tempItemBranchUsage.Location = IBU.Location AND
	tempItemBranchUsage.ItemNo = IBU.ItemNo AND
	tempItemBranchUsage.CurPeriodNo = IBU.CurPeriodNo


select * from tempItemBranchUsage


select CAST (FLOOR (CAST (GETDATE() AS FLOAT)) AS DATETIME) from ItemBranchUsage