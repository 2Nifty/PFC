
drop table #tOldSKUList
drop table #tNewSKUList

--(66947 row(s) affected)
--#tOldSKUList - All valid 020 SKUs
SELECT	DISTINCT
		IB.Location,
		IM.ItemNo as OldItem,
		IB.Location + ItemNo as OldSKU,
		IM.SellStkUMQty as OldSellStkQty,
		IM.SellStkUM as OldSellStkUM
INTO	#tOldSKUList
FROM	ItemMaster IM (NoLock) INNER JOIN
		ItemBranch IB (NoLock)
ON		IM.pItemMasterID = IB.fItemMasterID
WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))

--(41596 row(s) affected)
--#tNewSKUList - All valid 040 SKUs
SELECT	DISTINCT
		IB.Location,
		IM.ItemNo as NewItem,
		IB.Location + ItemNo as NewSKU,
		IM.SellStkUMQty as NewSellStkQty,
		IM.SellStkUM as NewSellStkUM
INTO	#tNewSKUList
FROM	ItemMaster IM (NoLock) INNER JOIN
		ItemBranch IB (NoLock)
ON		IM.pItemMasterID = IB.fItemMasterID
WHERE	RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))

--select * from #tOldSKUList
--select * from #tNewSKUList


drop table #tIBUSKUList

--(40524 row(s) affected)
--#tIBUSKUList - INNER JOIN Old & New
SELECT	New.Location,
		Old.OldItem,
		Old.OldSellStkQty,
		Old.OldSellStkUM,
		Old.OldSKU,
		New.NewItem,
		New.NewSellStkQty,
		New.NewSellStkUM,
		New.NewSKU
INTO	#tIBUSKUList
FROM	#tNewSKUList New (NoLock) INNER JOIN
		#tOldSKUList Old (NoLock)
ON		New.Location = Old.Location AND LEFT(New.NewItem,11) = LEFT(Old.OldItem,11)

UPDATE	#tIBUSKUList
SET		OldSellStkQty = 1,
		OldSellStkUM = '',
		NewSellStkQty = 1,
		NewSellStkUM = ''
--select * from #tIBUSKUList
WHERE	OldSellStkQty <= 0 or NewSellStkQty <= 0

--select * from #tIBUSKUList



select distinct OldItem, OldSellStkQty, NewItem, NewSellStkQty from #tIBUSKUList
where 
OldSellStkQty <> NewSellStkQty and 
NewItem in 

('00900-2512-040',
'00900-2618-040',
'00900-2618-040',
'00900-2818-040',
'00930-2418-040',
'00930-2516-040',
'00930-2516-040',
'00930-2620-040',
'00940-2618-040',
'00940-2620-040',
'00940-2624-040',
'00940-2624-040',
'00940-2624-040',
'00940-2625-040',
'00950-2808-040',
'00950-2820-040',
'00950-2820-040',
'00950-2820-040',
'00950-3212-040')


select * from 
OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemBranchUsage
where 
cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6))
in
(select * from #t040NR)



select	distinct 
--		Location, ItemNo, CurPeriodNo,
--		CurNRSalesQty
--		pitembranchusageID,Location,ItemNo,CurPeriodNo,CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,CurNoOfOrders,CurNRSalesQty,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
--		cast(Location as char(2)) + ' ' + cast(ItemNo as char(14)) + ' ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
		cast(Location as char(2)) + ' ' + cast(left(ItemNo,11) as char(11)) + '020 ' + cast(CurPeriodNo as char(6)) as OrigIBUKey
into #t040NR
from	ItemBranchUsage IM
WHERE	--RIGHT(IM.ItemNo,3) = '020' AND 
		RIGHT(IM.ItemNo,3) = '040' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))
and
CurNRSalesQty > 0