--UPDATE the 12 records where the current Beg & End values are not equal to the min Beg & End values from the dups
--Updating PFCSQLP only.  Updates will get copied to PERP at next month end.
--This was tested against [tempItemBranchUsageTOD]
UPDATE	ItemBranchUsage
SET	CurBegOnHandQty = IBUupd.valCurBegOnHandQty,
	CurBegOnHandDol = IBUupd.valCurBegOnHandDol,
	CurBegOnHandWght = IBUupd.valCurBegOnHandWght,
	CurEndOHQty = IBUupd.valCurEndOHQty,
	CurEndOHDol = IBUupd.valCurEndOHDol,
	CurEndOHWght = IBUupd.valCurEndOHWght,
	ChangeID = 'WO1913DupRec',
	ChangeDt = GETDATE()
FROM
--12 records exist where the current Beg & End values are not equal to the min Beg & End values from the dups
(select IBUval.*, mainIBU.* from ItemBranchUsage mainIBU inner join
(select	tmpIBU.IBULoc as valLoc,
	tmpIBU.IBUItem as valItem,
	tmpIBU.IBUPer as valPer,
	min(tmpIBU.CurBegOnHandQty) as valCurBegOnHandQty,
	min(tmpIBU.CurBegOnHandDol) as valCurBegOnHandDol,
	min(tmpIBU.CurBegOnHandWght) as valCurBegOnHandWght,
	min(tmpIBU.CurEndOHQty) as valCurEndOHQty,
	min(tmpIBU.CurEndOHDol) as valCurEndOHDol,
	min(tmpIBU.CurEndOHWght) as valCurEndOHWght
FROM
(select DISTINCT 
IBU.Location as IBULoc,
IBU.ItemNo as IBUItem,
IBU.CurPeriodNo as IBUPer,
IBU.CurBegOnHandQty,
IBU.CurBegOnHandDol,
IBU.CurBegOnHandWght,
IBU.CurNoofReceipts,
IBU.CurReceivedQty,
IBU.CurReceivedDol,
IBU.CurReceivedWght,
IBU.CurNoofReturns,
IBU.CurReturnQty,
IBU.CurReturnDol,
IBU.CurReturnWght,
IBU.CurNoofBackOrders,
IBU.CurBackOrderQty,
IBU.CurBackOrderDol,
IBU.CurBackOrderWght,
IBU.CurNoofSales,
IBU.CurSalesQty,
IBU.CurSalesDol,
IBU.CurSalesWght,
IBU.CurCostDol,
IBU.CurNoofTransfers,
IBU.CurTransferQty,
IBU.CurTransferDol,
IBU.CurTransferWght,
IBU.CurNoofIssues,
IBU.CurIssuesQty,
IBU.CurIssuesDol,
IBU.CurIssuesWght,
IBU.CurNoofAdjust,
IBU.CurAdjustQty,
IBU.CurAdjustDol,
IBU.CurAdjustWght,
IBU.CurNoofChanges,
IBU.CurChangeQty,
IBU.CurChangeDol,
IBU.CurChangeWght,
IBU.CurNoofPO,
IBU.CurPOQty,
IBU.CurPODol,
IBU.CurPOWght,
IBU.CurNoofGER,
IBU.CurGERQty,
IBU.CurGERDol,
IBU.CurGERWght,
IBU.CurNoOfWorkOrders,
IBU.CurWorkOrderQty,
IBU.CurWorkOrderDol,
IBU.CurWorkOrderWght,
IBU.CurLostSlsQty,
IBU.CurDailySlsQty,
IBU.CurDailyRetQty,
IBU.CurEndOHQty,
IBU.CurEndOHDol,
IBU.CurEndOHWght,
IBU.CurNoOfOrders,
IBU.CurNRSalesQty,
IBU.EntryID,
IBU.EntryDt,
IBU.ChangeID,
IBU.ChangeDt,
IBU.StatusCd,
IBU.CurNRNoSales,
IBU.CurNRSalesDol,
IBU.CurNRSalesWght,
IBU.CurNRCostDol
from bkpItemBranchUsage IBU inner join
(
select * from
(select Count(*) as reccount, Location as bkpLoc, ItemNo as bkpItem, CurPeriodNo as bkpPer from bkpItemBranchUsage
group by Location, ItemNo, CurPeriodNo) tmp
where reccount > 1
) dups
on IBU.Location = dups.bkpLoc and IBU.ItemNo = dups.bkpItem and IBU.CurPeriodNo = dups.bkpPer
--order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo, IBU.CurBegOnHandQty
) tmpIBU
group by tmpIBU.IBULoc,
	tmpIBU.IBUItem,
	tmpIBU.IBUPer
--order by tmpIBU.valLoc, tmpIBU.valItem, tmpIBU.valPer, tmpIBU.CurBegOnHandQty
) IBUval

on	IBUval.valLoc = mainIBU.Location and
	IBUval.valItem = mainIBU.ItemNo and
	IBUval.valPer = mainIBU.CurPeriodNo
where	(IBUval.valCurBegOnHandQty <> mainIBU.CurBegOnHandQty or
	IBUval.valCurBegOnHandDol <> mainIBU.CurBegOnHandDol or
	IBUval.valCurBegOnHandWght <> mainIBU.CurBegOnHandWght or
	IBUval.valCurEndOHQty <> mainIBU.CurEndOHQty or
	IBUval.valCurEndOHDol <> mainIBU.CurEndOHDol or
	IBUval.valCurEndOHWght <> mainIBU.CurEndOHWght)
--order by mainIBU.Location, mainIBU.ItemNo, mainIBU.CurPeriodNo
)IBUupd
WHERE	ItemBranchUsage.pItemBranchUsageID = IBUupd.pItemBranchUsageID



select 
Location, ItemNo, CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght, CurEndOHQty, CurEndOHDol, CurEndOHWght, *
from ItemBranchUsage where ChangeDt > getdate()-1
order by pItemBranchUsageID


--exec sp_columns bkpItemBranchUsage