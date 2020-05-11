drop table #tempOldLoc
select 	distinct
--	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
--	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
--	CurCostDol,CurNRNoSales, CurNRSalesQty,
--	CurNRSalesDol, CurNRSalesWght,
--	CurNRCostDol, EntryID, ChangeId
 cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(OldLoc as varchar(2)) as IBUKEY
into #tempOldLoc
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766'


select * from #tempNewLoc



select 	count(*)
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766'











drop table #tempOldItems
select 
	CurPeriodNo, tibu.ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
--into #tempOldItems

from ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(select IBUKEY from #tempOldLoc)


select * from #tempOldItems

select 
	CurPeriodNo, tOld.ItemNo, OldLoc, NewLoc, 
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from #tempOldItems tOld inner join tWO1766MoveUsage01to15IBU tList
on tOld.ItemNo=tList.ItemNo and tOld.Location = tList.OldLoc



select cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKEY
into #tOldKeys
from #tempOldItems



select 	distinct
--	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
--	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
--	CurCostDol,CurNRNoSales, CurNRSalesQty,
--	CurNRSalesDol, CurNRSalesWght,
--	CurNRCostDol, EntryID, ChangeId
 cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(NewLoc as varchar(2)) as IBUKEY
into #tempNewLoc
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766'

select * from #tempNewLoc



select distinct
	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
into #tSourceBef1
from IteMBranchUsageHist tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(NewLoc as varchar(2)) in 
(
select IBUKEY from #tempNewLoc
)




select IBUKEY from #tempOldLoc




select distinct
cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(NewLoc as varchar(2)) as IBUKEY
into #tempDestKey
from IteMBranchUsageHist tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(NewLoc as varchar(2)) in 
(
select IBUKEY from #tempNewLoc
)

select IBUKEY from #tempDestKey




select 	distinct
	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
(left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766') and 
cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(NewLoc as varchar(2)) not in 
(
select IBUKEY from #tempDestKey
)



select *
from tFix_ItemBranchUsageTestBruce
where cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select cast(ItemNo as varchar(14)) + cast(OldLoc as varchar(2)) as OldKey from tWO1766MoveUsage01to15IBU
)




select * from ItemBranchUsageHist where CurPeriodNo='200709' and ItemNo='00020-2520-021' and Location='01'












--128134 updates
select 	cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(OldLoc as varchar(2)) IBUKEY
	--CurPeriodNo, tibu.ItemNo, OldLoc, newLoc
into #tSourceKey
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
(left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766')

select * from #tSourceKey



--43885 existing source items
select count(*)
from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select IBUKEY from #tSourceKey
)


select cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKEY
into #tNewKey
from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select IBUKEY from #tSourceKey
)

select * from #tNewKey


select 	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId
--into #SourceBef2
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where  
(left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766')
and cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(OldLoc as varchar(2)) not in
(
select IBUKEy from #tNewKey
)


select * from #tSourceBef1
select * from #SourceBef2



drop table #tSourceBef1



select 
	CurPeriodNo, tibu.ItemNo, '15' as NewLoc, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
into #tSourceBef1

from ItemBranchUsageHist tibu
where cast(CurPeriodNo as varchar(6)) + cast(tibu.ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(select IBUKEY from #tempOldLoc)