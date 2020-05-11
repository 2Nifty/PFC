--DEST AFTER
--48808 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where left(EntryID,6)='WO1185' or left(ChangeID,6)='WO1185'

------------------------------------------------------------------------

drop table #tempOldKey
drop table #tempNewKey

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(left(tibu.ItemNo,11) as varchar(11)) + '50' + cast(right(tibu.ItemNo,1) as varchar(1)) + cast(Location as varchar(2)) as IBUKEY
into	#tempOldKey
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1185' or left(ChangeID,6)='WO1185')

select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKEY
into	#tempNewKey
from	tFix_ItemBranchUsageTestBruce tIBu
where	(left(EntryID,6)='WO1185' or left(ChangeID,6)='WO1185')

select * from #tempOldKey
select * from #tempNewKey

-----------------------------------------------------------------------------

select * from tWO1185RodFactor


--SOURCE BEFORE
-- 28801 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location,
	CurNoofSales, CurSalesQty,

	CASE WHEN CurSalesQty < 0
				THEN ISNULL(NULLIF(ROUND((CurSalesQty * tRod.UseFct),0),0),-1)
				ELSE CASE WHEN CurSalesQty > 0
						THEN ISNULL(NULLIF(ROUND((CurSalesQty * tRod.UseFct),0),0),1)
						ELSE CurSalesQty
					 END
	END as QtyFct,

CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,

	CASE WHEN CurNRSalesQty < 0
				THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * tRod.UseFct),0),0),-1)
				ELSE CASE WHEN CurNRSalesQty > 0
						THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * tRod.UseFct),0),0),1)
						ELSE CurNRSalesQty
					 END
	END as NRQtyFct,

	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu inner join
		tWO1185RodFactor tRod
on		tibu.ItemNo = tRod.Item
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldKey)


--20007 ZERO source records
select 	distinct
	CurPeriodNo, cast(left(tibu.ItemNo,11) as varchar(11)) + '50' + cast(right(tibu.ItemNo,1) as varchar(1)) as Item, Location,
	0 as CurNoofSales, 0 as CurSalesQty,
	0 as QtyFct,
0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,

	0 as NRQtyFct,


	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu

inner join
		tWO1185RodFactor tRod
on		cast(left(tibu.ItemNo,11) as varchar(11)) + '50' + cast(right(tibu.ItemNo,1) as varchar(1)) = tRod.Item

where (left(EntryID,6)='WO1185' or left(ChangeID,6)='WO1185') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(left(tibu.ItemNo,11) as varchar(11)) + '02' + cast(right(tibu.ItemNo,1) as varchar(1)) + cast(Location as varchar(2))
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempOldKey)
)


-------------------------------------------------------------------------------


--DEST BEFORE
-- 22709 rows
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewKey)



--26099 ZERO DEST records
select 	distinct
	CurPeriodNo, tibu.ItemNo, Location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, null as ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
where (left(EntryID,6)='WO1185' or left(ChangeID,6)='WO1185') and
	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(
select 	distinct
	cast(CurPeriodNo as varchar(6)) + cast(left(tibu.ItemNo,11) as varchar(11)) + '02' + cast(right(tibu.ItemNo,1) as varchar(1)) + cast(Location as varchar(2))
from	ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in (select IBUKEY from #tempNewKey)
)


-------------------------------------------------------------------------------

select * from 
tFix_ItemBranchUsageTestBruce
where cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(select cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) from tWO1185RodItems)


------------------------------------------------------------------------------------


