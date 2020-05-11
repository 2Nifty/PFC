--DEST AFTER
--2322 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location, '30' as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where left(EntryID,6)='WO1856' or left(ChangeID,6)='WO1856'

------------------------------------------------------------------------

drop table #tempOldLoc
drop table #tempNewLoc

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '30' as IBUKEY
into	#tempOldLoc
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1856' or left(ChangeID,6)='WO1856')

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10' as IBUKEY
into	#tempNewLoc
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1856' or left(ChangeID,6)='WO1856')

select * from #tempOldLoc
select * from #tempNewLoc

-----------------------------------------------------------------------------

--SOURCE BEFORE
--217 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, '10' as newLoc, Location as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc)

--2105 ZERO source records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, '30' as OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1856' or left(ChangeID,6)='WO1856') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10'
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc)
)


-------------------------------------------------------------------------------

--DEST BEFORE
-- 2167 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, '30' as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewLoc)



--155 ZERO DEST records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, '30' as OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1856' or left(ChangeID,6)='WO1856') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10'
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewLoc)
)


-------------------------------------------------------------------------------

select * from tFix_ItemBranchUsageTestBruce where Location='30'