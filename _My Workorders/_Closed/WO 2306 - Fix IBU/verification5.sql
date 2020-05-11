--DEST AFTER
--2322 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location, 'xx' as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864'

------------------------------------------------------------------------

drop table #tempOldLoc14
drop table #tempOldLoc16
drop table #tempNewLoc

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '14' as IBUKEY
into	#tempOldLoc14
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864')

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '16' as IBUKEY
into	#tempOldLoc16
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864')


select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10' as IBUKEY
into	#tempNewLoc
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864')

select * from #tempOldLoc14
select * from #tempOldLoc16
select * from #tempNewLoc

-----------------------------------------------------------------------------

--SOURCE14 BEFORE
--19437 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, '10' as newLoc, Location as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc14)

--51835 ZERO source records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, '14' as OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10'
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc14)
)


-------------------------------------------------------------------------------


--SOURCE16 BEFORE
--23721 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, '10' as newLoc, Location as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc16)

--51835 ZERO source records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, '16' as OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10'
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldLoc16)
)


-------------------------------------------------------------------------------


--DEST BEFORE
-- 47786 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, 'xx' as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewLoc)



--155 ZERO DEST records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location as NewLoc, 'xx' as OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1864' or left(ChangeID,6)='WO1864') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + '10'
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewLoc)
)


-------------------------------------------------------------------------------

select
	CurPeriodNo, ItemNo, Location as NewLoc, 'xx' as OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from tFix_ItemBranchUsageTestBruce where (Location='14' or Location='16') and
	SUBSTRING([ItemNo],12,1) NOT IN ('0', '1', '2', '5')


--and
--CurNoofSales = 0 AND CurSalesQty = 0 AND CurNRNoSales = 0 AND CurNRSalesQty = 0 AND
--	CurSalesDol = 0 AND CurSalesWght = 0 AND CurCostDol = 0 AND
--	CurNRSalesDol = 0 AND CurNRSalesWght = 0 AND CurNRCostDol = 0
--	LEFT(ChangeID,13) = 'WO1864' AND (Location = '14' OR Location = '16')
