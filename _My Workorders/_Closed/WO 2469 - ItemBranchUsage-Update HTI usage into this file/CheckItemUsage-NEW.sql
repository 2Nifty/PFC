

select CurSalesQty, CurNRSalesQty, entryid, entrydt, changeid, changedt
--*
from ItembranchUsage
where
CurSalesQty > 0 and CurSalesQty < 1 
--CurNRSalesQty > 0 and CurNRSalesQty < 1 



--select count(*) from ItemBranchUsage
select count(*) from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranchUsage
select	sum(CurNoofSales), sum(CurSalesQty), sum(CurSalesDol), sum(CurSalesWght), sum(CurCostDol),
	sum(CurNRNoSales), sum(CurNRSalesQty), sum(CurNRSalesDol), sum(CurNRSalesWght), sum(CurNRCostDol), max(entryDt), max(changedt)
--select *
--from	ItemBranchUsage
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranchUsage





select max(EntryDt), max(ChangeDt) from ItemBranchUsage
select max(EntryDt), max(ChangeDt) from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranchUsage



-----  HTI_Usage  -----

--------------------
-- Overall totals --
--------------------

select * from tWO2469_HTIUsage

select * from tWO2469_HTIUsageSumm


----------------------------------------------------------------------------

--HTIUsage raw
--select * from tWO2469_HTIUsageSumm
select count(*) as HTIUsage from
(select	distinct Location, ItemNo from tWO2469_HTIUsageSumm) tmp

select	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICostDol,0)) as CostDol,
	sum(isnull(HTICartonQty,0)) as CartonQty
from	tWO2469_HTIUsageSumm

----------------------------------------------------------------------------

--HTIUsage 60%
select count(*) as HTIUsage from
(select	distinct Location, ItemNo from tWO2469_HTIUsageSumm) tmp

select	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as CartonQty
from	tWO2469_HTIUsageSumm



----------------------------------------------------------------------------

--HTIUsageLg
select count(*) as HTIUsageLg from
(select	distinct Location, ItemNo from tWO2469_HTIUsageLg) tmp

select	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as CartonQty
from	tWO2469_HTIUsageLg

----------------------------------------------------------------------------

--HTIUsageSm
select count(*) as HTIUsageSm from
(select	distinct Location, ItemNo from tWO2469_HTIUsageSm) tmp

select	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as CartonQty
from	tWO2469_HTIUsageSm

----------------------------------------------------------------------------


---------------------
-- Location totals --
---------------------

----------------------------------------------------------------------------

--60%
select Usage.Location, SKU.SKUCnt, SalesDol, CostDol, SalesQty
from
(select Location,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as SalesQty
from	tWO2469_HTIUsageSumm
group by Location) Usage
left outer join
(select Location, count(*) as SKUCnt
from
(select	distinct Location, ItemNo from tWO2469_HTIUsageSumm) tmp
group by location) SKU
on Usage.location = sku.location
order by Usage.location



--Large
select Usage.Location, SKU.SKUCnt, SalesDol, CostDol, SalesQty
from
(select Location,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as SalesQty
from	tWO2469_HTIUsageLg
group by Location) Usage
left outer join
(select Location, count(*) as SKUCnt
from
(select	distinct Location, ItemNo from tWO2469_HTIUsageLg) tmp
group by location) SKU
on Usage.location = sku.location
order by Usage.location


--Small
select Usage.Location, SKU.SKUCnt, SalesDol, CostDol, SalesQty
from
(select Location,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(CartonQty,0)) as SalesQty
from	tWO2469_HTIUsageSm
group by Location) Usage
left outer join
(select Location, count(*) as SKUCnt
from
(select	distinct Location, ItemNo from tWO2469_HTIUsageSm) tmp
group by location) SKU
on Usage.location = sku.location
order by Usage.location




----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------


-----  HTI_IBU  -----


--------------------
-- Overall totals --
--------------------

----------------------------------------------------------------------------

--HTI_IBU
select count(*) as HTIUsage from
(select	distinct Location, ItemNo from tWO2469_HTI_IBU) tmp

select	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(SalesQty,0)) as SalesQty
from	tWO2469_HTI_IBU

----------------------------------------------------------------------------


---------------------
-- Location totals --
---------------------

----------------------------------------------------------------------------


select Usage.Location, SKU.SKUCnt, SalesDol, CostDol, SalesQty
from
(select location,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol,
	sum(isnull(SalesQty,0)) as SalesQty
from	tWO2469_HTI_IBU
group by Location) Usage

left outer join

(select Location, count(*) as SKUCnt
from
(select	distinct Location, ItemNo from tWO2469_HTI_IBU) tmp
group by location) SKU

on Usage.location = sku.location

order by Usage.location


----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------



UPDATE	tWO2469_HTIUsageSumm
SET	SalesDol = SalesDol * 0.60,
	CartonQty = CartonQty * 0.60,
	CostDol = CostDol * 0.60

select * from tWO2469_HTIUsageSumm
WHERE	left(ItemNo,5) <> '00086' and left(ItemNo,5) <> '00087' and 
	left(ItemNo,5) <> '00153' and left(ItemNo,5)<> '00690' and
	(left(ItemNo,5) not between '00900' and '00972') and
	(left(ItemNo,5) not between '20056' and '20972')