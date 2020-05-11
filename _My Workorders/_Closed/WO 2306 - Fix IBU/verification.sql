--select * from tWO2306_Grade8ItemList where newitem='02303-1020-400'
--newitem='02306-0468-400'

select distinct EntryId from ItemBranchUsageHist
select distinct ChangeId from ItemBranchUsageHist

drop table tFix_ItemBranchUsageTestBruce
select * into tFix_ItemBranchUsageTestBruce from ItemBranchUsageHist 

select distinct EntryId from tFix_ItemBranchUsageTestBruce
select distinct ChangeId from tFix_ItemBranchUsageTestBruce


delete 
--select * 
from tFix_ItemBranchUsageTestBruce
where CurPeriodNo > '201102'

select distinct CurPeriodNo from ItemBranchUsage order by CurPeriodNo

select count(*) from ItemBranchUsageHist
select count(*) from
(select distinct CurPeriodNo, ItemNo, Location
from ItemBranchUsageHist) tmp


select count(*) from tFix_ItemBranchUsageTestBruce
select count(*) from
(select distinct CurPeriodNo, ItemNo, Location
from tFix_ItemBranchUsageTestBruce) tmp


select count(*) from ItemBranchUsage
select count(*) from
(select distinct CurPeriodNo, ItemNo, Location
from ItemBranchUsage) tmp


--zeros
select 	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
--from ItemBranchUsageHist
--from tFix_ItemBranchUsageTestBruce
from ItemBranchUsage
where CurNoofSales = 0 --and CurSalesQty = 0

delete from tFix_ItemBranchUsageTestBruce
where CurNoofSales = 0 and CurSalesQty = 0


select	SUM(CurNoofSales) as CurNoofSales, sum(CurSalesQty) as CurSalesQty,
	sum(CurSalesDol) as CurSalesDol, sum(CurSalesWght) as CurSalesWght,
	sum(CurCostDol) as CurCostDol,
SUM(CurNRNoSales) as CurNRNoSales, sum(CurNRSalesQty) as CurNRSalesQty,
	sum(CurNRSalesDol) as CurNRSalesDol, sum(CurNRSalesWght) as CurNRSalesWght,
	sum(CurNRCostDol) as CurNRCostDol, 'Before'
from ItemBranchUsageHist


select	SUM(CurNoofSales) as CurNoofSales, sum(CurSalesQty) as CurSalesQty,
	sum(CurSalesDol) as CurSalesDol, sum(CurSalesWght) as CurSalesWght,
	sum(CurCostDol) as CurCostDol,
SUM(CurNRNoSales) as CurNRNoSales, sum(CurNRSalesQty) as CurNRSalesQty,
	sum(CurNRSalesDol) as CurNRSalesDol, sum(CurNRSalesWght) as CurNRSalesWght,
	sum(CurNRCostDol) as CurNRCostDol, 'After'
from ItemBranchUsage


select	SUM(CurNoofSales) as CurNoofSales, sum(CurSalesQty) as CurSalesQty,
	sum(CurSalesDol) as CurSalesDol, sum(CurSalesWght) as CurSalesWght,
	sum(CurCostDol) as CurCostDol,
SUM(CurNRNoSales) as CurNRNoSales, sum(CurNRSalesQty) as CurNRSalesQty,
	sum(CurNRSalesDol) as CurNRSalesDol, sum(CurNRSalesWght) as CurNRSalesWght,
	sum(CurNRCostDol) as CurNRCostDol, 'After'
from tFix_ItemBranchUsageTestBruce



---------------------------------------------------------------------------------------


select * from
(select OldItem, Count(*) as RecCnt from 
(select distinct OldItem, NewItem from tWO1112NucorNutsAndMetricsIBU) tList
group by OldItem) tCount
where RecCnt > 1



--usage to move - 15251
select 	distinct
	CurPeriodNo, ItemNo, NewItem, tIBU.Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from ItemBranchUsageHist tIBU inner join
	tWO1112NucorNutsAndMetricsIBU tItems
on 	ItemNo=OldItem and tIBU.Location = tItems.Location
	



select distinct cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2))
from ItemBranchUsageHist tIBU inner join
	tWO1112NucorNutsAndMetricsIBU tItems
on 	ItemNo=OldItem and tIBU.Location = tItems.Location




select
	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
into #temp
from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select distinct cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(tIBU.Location as varchar(2))
from ItemBranchUsageHist tIBU inner join
	tWO1112NucorNutsAndMetricsIBU tItems
on 	ItemNo=OldItem and tIBU.Location = tItems.Location
)


select 
	CurPeriodNo, ItemNo, OldItem, tmp.Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
into #temp2
from #temp tmp inner join tWO1112NucorNutsAndMetricsIBU tList on tmp.ItemNo=tList.NewItem and tmp.Location=tList.Location





select 	distinct
	CurPeriodNo, NewItem, ItemNo, tIBU.Location,
	0 as CurNoofSales, 0 as CurSalesQty, 0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol, 0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol, 0 as EntryID, 0 as ChangeId
from ItemBranchUsageHist tIBU inner join
	tWO1112NucorNutsAndMetricsIBU tItems
on 	ItemNo=OldItem and tIBU.Location = tItems.Location
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(tIBU.Location as varchar(2))  in
(select distinct cast(CurPeriodNo as varchar(6)) + cast(OldItem as varchar(14)) + cast(Location as varchar(2))
from #temp2)










drop table #temp
drop table #temp2


select 
	TempUse.CurPeriod, TempUse.ItemNo, TempUse.NewUsageLoc as location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol

 from tWO2306_Step04_SalesUsage TempUse

WHERE		NOT EXISTS (SELECT *
			    FROM   ItemBranchUsageHist IBU (NoLock)
			    WHERE  IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.Location = TempUse.NewUsageLoc)







---------------------------------------------------------------------------------------


select 
	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
 from tFix_ItemBranchUsageTestBruce
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select cast(CurPeriod as varchar(6)) + cast(ItemNo as varchar(14)) + '01'
 from tWO2306_SalesUsageBr20
)




select 
	TempUse.CurPeriod, TempUse.ItemNo, '01' as location,
	0 as CurNoofSales, 0 as CurSalesQty,0 as CurSalesDol, 0 as CurSalesWght,
	0 as CurCostDol,0 as CurNRNoSales, 0 as CurNRSalesQty,
	0 as CurNRSalesDol, 0 as CurNRSalesWght,
	0 as CurNRCostDol

 from tWO2306_SalesUsageBr20 TempUse

WHERE		NOT EXISTS (SELECT *
			    FROM   ItemBranchUsageHist IBU (NoLock)
			    WHERE  IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.Location = '01')
GO


select *
 from tWO2306_SalesUsageBr20


---------------------------------------------------------------------------------------


select
	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId
from	ItemBranchUsageHist
where	cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(
select
--	cast(CurPeriodNo as varchar(6)) + cast(NewItem as varchar(14)) + cast(Location as varchar(2)) as OldIBUKey
	IBUFUB.CurPeriodNo, IBUFUB.ItemNo, IBUFUB.Location,
	IBUFUB.CurNoofSales, IBUFUB.CurSalesQty, IBUFUB.CurSalesDol, IBUFUB.CurSalesWght,
	IBUFUB.CurCostDol, IBUFUB.CurNRNoSales, IBUFUB.CurNRSalesQty,
	IBUFUB.CurNRSalesDol, IBUFUB.CurNRSalesWght,
	IBUFUB.CurNRCostDol, IBUFUB.EntryID, IBUFUB.ChangeId, olditem,

isnull(IBU1.CurNoofSales,0) as OrigNoofSales,
isnull(IBU1.CurSalesQty,0) as OrigSalesQty,
isnull(IBU1.CurSalesDol,0) as OrigSalesDol,
isnull(IBU1.CurSalesWght,0) as OrigSalesWght,
isnull(IBU1.CurCostDol,0) as OrigCostDol,

isnull(IBU1.CurNRNoSales,0) as OrigNRNoSales,
isnull(IBU1.CurNRSalesQty,0) as OrigNRSalesQty,
isnull(IBU1.CurNRSalesDol,0) as OrigNrSalesDol,
isnull(IBU1.CurNRSalesWght,0) as OrigNRSalesWght,
isnull(IBU1.CurNRCostDol,0) as OrigNRCostDol



from	tFix_ItemBranchUsageTestBruce IBUFUB inner join tWO2306_40PoundSKU SKU
on 	IBUFUB.ItemNo = SKU.NewItem and IBUFUB.Location = SKU.SKULoc

left join ItemBranchUsageHist IBU1 on IBU1.CurPeriodNo = IBUFUB.CurPeriodNo and IBU1.ItemNo = IBUFUB.ItemNo and IBU1.Location = IBUFUB.Location


where
-- 	EntryID='WO2306_Step02_ConvertGrade5IBU' 
	IBUFUB.ChangeID='WO2306_Step02_ConvertGrade5IBU'
)


select * from tWO2306_40PoundSKU




--UPDATE existing OldItem ItemBranchUsage transactions: CurSales, CurNRSalesQty



select 	CurPeriodNo, ItemNo, Location,
	CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
	CurCostDol,CurNRNoSales, CurNRSalesQty,
	CurNRSalesDol, CurNRSalesWght,
	CurNRCostDol, EntryID, ChangeId, newitem
FROM	ItemBranchUsageHist IBU (NoLock) INNER JOIN
	tWO2306_40PoundSKU t40Lb (NoLock) 
ON	IBU.ItemNo = t40Lb.OldItem AND IBU.Location = t40Lb.SKULoc







--------------------------------------------------------------------------------------------




select count(*) from ItemBranchUsageHist where ItemNo in (select OldItem from tWO2306_Grade8ItemList)
select count(*) from tFix_ItemBranchUsageTestBruce where ItemNo in (select OldItem from tWO2306_Grade8ItemList)


select * from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 

(
select cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKey
from tFix_ItemBranchUsageTestBruce where ItemNo in (select NewItem from tWO2306_Grade8ItemList) and EntryID='WO2306_Step01_ConvertGrade8IBU'
)


select temp.*, NewItem from
(
select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, EntryID, ChangeId
 from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 

(
select --cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKey, ItemNo,
--CurPeriodNo, ItemNo, Location,
--	NewItem,
--	OldItem,
	cast(CurPeriodNo as varchar(6)) + cast(OldItem as varchar(14)) + cast(Location as varchar(2)) as OldIBUKey

--CurPeriodNo, ItemNo, Location,
--CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
--CurCostDol,CurNRNoSales, CurNRSalesQty,
--CurNRSalesDol, CurNRSalesWght,
--CurNRCostDol
--,OldItem

from tFix_ItemBranchUsageTestBruce inner join
	tWO2306_Grade8ItemList on ItemNo=NewItem
where ItemNo in (select NewItem from tWO2306_Grade8ItemList) and ChangeID='WO2306_Step01_ConvertGrade8IBU'
)
) temp inner join
tWO2306_Grade8ItemList on OldItem = ItemNo



select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol
from ItemBranchUsageHist
where CurPeriodNo='200803' and ItemNo='00340-0600-400' and Location='09'


select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol from ItemBranchUsageHist where ItemNo in 
(

select OldItem from tWO2306_Grade8ItemList
where NewItem in

('02305-0612-400',
'02306-0468-400',
'02306-0468-400',
'02306-0468-400',
'02306-0468-400',
'02306-0468-400',
'02306-0468-400')
)
order by ItemNo, CurPeriodNo, Location




select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, entryId, changeid from ItemBranchUsageHist
where CurPeriodNo='200910' and ItemNo='00340-0612-400' and Location='10'


select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, entryId, changeid
from tFix_ItemBranchUsageTestBruce
where CurPeriodNo='200910' and ItemNo='02305-0612-400' and Location='10'



select * from  tWO2306_Grade8ItemList where OldItem='00340-0612-400'





select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, entryId, changeid
from tFix_ItemBranchUsageTestBruce
where ChangeID='WO2306_Step01_ConvertGrade8IBU'




select CurPeriodNo, ItemNo, Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, entryId, changeid
from ItemBranchUsageHist
where cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) in 
(

select cast(CurPeriodNo as varchar(6)) + cast(ItemNo as varchar(14)) + cast(Location as varchar(2)) as IBUKey
from tFix_ItemBranchUsageTestBruce
where ChangeID='WO2306_Step01_ConvertGrade8IBU'
)






select ItemBranchUsage.CurPeriodNo, ItemBranchUsage.ItemNo, ItemBranchUsage.Location,
CurNoofSales, CurSalesQty,CurSalesDol, CurSalesWght,
CurCostDol,CurNRNoSales, CurNRSalesQty,
CurNRSalesDol, CurNRSalesWght,
CurNRCostDol, entryId, changeid

FROM
ItemBranchUsageHist ItemBranchUsage inner join
	(SELECT	ItemList.NewItem, OldItem.Location, OldItem.CurPeriodNo
	 FROM	tWO2306_Grade8OldItem OldItem (NoLock) INNER JOIN
		tWO2306_Grade8ItemList ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem) TIBU

on	ItemBranchUsage.ItemNo = TIBU.NewItem AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo








old 00080-4150-022 00325-3200-401
new 00080-4150-042 02325-3200-401



select * from tWO2306_Grade8ItemList
where OldItem='00080-4150-022' or OldItem='00325-3200-401'







