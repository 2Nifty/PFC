--totals
select 
		sum(CurNoofSales) as CurNoofSales,
		sum(CurSalesQty) as CurSalesQty,
		sum(CurSalesDol) as CurSalesDol,
		sum(CurSalesWght) as CurSalesWght,
		sum(CurCostDol) as CurCostDol,
		sum(CurNRNoSales) as CurNRNoSales,
		sum(CurNRSalesQty) as CurNRSalesQty,
		sum(CurNRSalesDol) as CurNRSalesDol,
		sum(CurNRSalesWght) as CurNRSalesWght,
		sum(CurNRCostDol) as CurNRCostDol
from ItemBranchUsage IM
WHERE	--RIGHT(IM.ItemNo,3) = '020' AND 
		RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))


---------------------------------------------------------------------------------

select	distinct *
--		Location, ItemNo, CurPeriodNo
from	ItemBranchUsage IM
WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
		--RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999')) AND
	cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040 ' + cast(CurPeriodNo as char(6)) in 

(select	distinct
--		Location, ItemNo, CurPeriodNo,
		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
--		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040 ' + cast(CurPeriodNo as char(6)) as NewIBUKey
from	ItemBranchUsage IM
WHERE	--RIGHT(IM.ItemNo,3) = '020' AND 
		RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999')))

---------------------------------------------------------------------------------

select	distinct --*
--		Location, ItemNo, CurPeriodNo,
		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
--		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040 ' + cast(CurPeriodNo as char(6)) as NewIBUKey
from	ItemBranchUsage IM
WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
		--RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))


select * from ItemBranchUsage where Location='07' and ItemNo='00900-2716-020'




-----------------------------------------------------------------------------------

select	--distinct *
		pitembranchusageID,Location,ItemNo,CurPeriodNo,CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,CurNoOfOrders,CurNRSalesQty,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
--		Location, ItemNo, CurPeriodNo,
--		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
--		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040 ' + cast(CurPeriodNo as char(6)) as NewIBUKey
from	ItemBranchUsage IM
WHERE	--RIGHT(IM.ItemNo,3) = '020' AND 
		RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999')) and

		((left(curperiodno,4) = '2010' or left(curperiodno,4) = '2011') and
		(right(curperiodno,2) = '02' or
		right(curperiodno,2) = '04' or
		right(curperiodno,2) = '06' or
		right(curperiodno,2) = '08' or
		right(curperiodno,2) = '10' or
		right(curperiodno,2) = '12' or 
		curperiodno='200809' or curperiodno='201010'))

and Location <> '06' and location <> '11' and Location < '19' and location <> '12' and location <> '13' and location <> '14'
order by CurPeriodNo, ItemNo, Location


update ItemBranchUsage
set		CurPeriodNo=201010
where pitembranchusageid=60921




select * from ItemBranchUsage where ItemNo='00900-2716-020' and Location='07'
order by CurPeriodNo

--------------------------------------------------------------------------------

select 
cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) as Key1
into #tSKU
 from ItemMaster inner join itembranch on pitemmasterid=fitemmasterid

--1107 SKUs not converted
select	distinct 
--		Location, ItemNo, CurPeriodNo,
		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) as SKUKey,
		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040' as NewSKUKey
--		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
--		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040 ' + cast(CurPeriodNo as char(6)) as NewIBUKey
from	ItemBranchUsage IM
WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
		--RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999')) and

cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '040' in
(select * from #tSKU)

and

cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) in
(select * from #tSKU)


------------------------------------------------------------------------------------------------------



select 
pitembranchusageID,Location,ItemNo,CurPeriodNo,CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,CurNoOfOrders,CurNRSalesQty,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
 from ItemBranchUsage where pitembranchusageid in (219616,60921)





delete from itembranchusage
--select * 
from itembranchusage
WHERE	(RIGHT(ItemNo,3) = '020' or RIGHT(ItemNo,3) = '040') AND 
		((LEFT(ItemNo,5) >= '00900' AND LEFT(ItemNo,5) <= '00999') OR
		 (LEFT(ItemNo,5) >= '20900' AND LEFT(ItemNo,5) <= '20999'))
