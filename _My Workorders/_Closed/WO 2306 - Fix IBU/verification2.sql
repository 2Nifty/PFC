select * from tWO1766MoveUsage01to15IBU
select * from tWO1766ItemBranchUsage


select 	distinct
	CurPeriodNo, tibu.ItemNo, NewLoc, OldLoc,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
--distinct cast(CurPeriodNo as varchar(6)) + cast(OldItem as varchar(14)) + cast(tIBU.Location as varchar(2))
from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1766MoveUsage01to15IBU tItems
on tIBU.ItemNo = tItems.ItemNo and tIBu.Location = tItems.NewLoc
where 
left(EntryID,6)='WO1766' 
or left(ChangeID,6)='WO1766'



-----------------------------------------------------------------------------------------

select 	distinct
	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
--into #temp
from
ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in
(
--list of old items - 23,387
select 	distinct cast(CurPeriodNo as varchar(6)) + cast(OldItem as varchar(14)) + cast(tIBU.Location as varchar(2))
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'
)


select 	distinct
	CurPeriodNo, ItemNo, NewItem, tmp.Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from #temp tmp
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tmp.ItemNo = tItems.OldItem and tmp.Location = tItems.location


drop table #temp
drop table #tempIBU

select 	distinct cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2)) as IBUKEY
into #tempIBU
 from ItembranchUsageHist tIBu inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location


select * from #tempIBu




--list of old items - 23,387
select 	distinct
	--cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2))

	CurPeriodNo, NewItem, OldItem, tIBU.Location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId


 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'
and cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2)) not in 
(select IBUKEY from #tempIBU)








select 	distinct
	CurPeriodNo, ItemNo, OldItem, tIBU.Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
 from ItembranchUsageHist tIBu inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location




select 	distinct
	CurPeriodNo, ItemNo, tIBU.Location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId
 from tFix_ItemBranchUsageTestBruce tIBu

where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in
(
--list of old items - 23,387
select 	distinct cast(CurPeriodNo as varchar(6)) + cast(OldItem as varchar(14)) + cast(tIBU.Location as varchar(2))
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'
)



select 	distinct
	CurPeriodNo, ItemNo, Location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId
 from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) not in
(

--list of old items - 23,387
select 	distinct cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2))
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'
)






---------------------------------------------------------------

--dest after = 23,387
select 	distinct
	CurPeriodNo, ItemNo, OldItem, tIBU.Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'



-----------------------------------------------------------

select 	distinct
cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2)) as IBUKEY
into #tKeys
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112'


--23,387 new item keys
select * from #tKeys



--8493 existing records found
select 	distinct
cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKEY
into #tKeys2
FROM	ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(select IBUKEY from #tKeys)


--8492 existing NEW ITEM record keys
select *from #tKeys2




select 	distinct
	CurPeriodNo, NewItem, OldItem, tIBU.Location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, EntryID, ChangeId
 from tFix_ItemBranchUsageTestBruce tIBu
inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.NewItem and tIBu.Location = tItems.location
where 
(left(EntryID,6)='WO1112' 
or left(ChangeID,6)='WO1112')
and cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2)) not in
(select IBUKEY from #tKeys2)




select * from tFix_ItemBranchUsageTestBruce tIBU 
where cast(ItemNo as varchar(14)) + cast(tIBU.Location as varchar(2)) in 
(
select cast(OldItem as varchar(14)) + cast(Location as varchar(2))
from tWO1112NucorNutsAndMetricsIBU

)

inner join tWO1112NucorNutsAndMetricsIBU tItems
on tIBU.ItemNo = tItems.OldItem and tIBu.Location = tItems.location