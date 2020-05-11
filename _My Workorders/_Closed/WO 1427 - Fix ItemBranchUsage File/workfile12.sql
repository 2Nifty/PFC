select * from tWO1185RodItems



select	ItemNo, Location, CurPeriodNo, CurSalesQty, CurNRSalesQty,
	CurNoofSales, CurSalesDol, CurSalesWght, CurCostDol,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol,
	EntryID, EntryDt, ChangeID, ChangeDt
from ItemBranchUsage
where ItemNo='00170-2406-501'
order by Location, CurPeriodNo

select	ItemNo, Location, CurPeriodNo, CurSalesQty, CurNRSalesQty,
	CurNoofSales, CurSalesDol, CurSalesWght, CurCostDol,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol,
	EntryID, EntryDt, ChangeID, ChangeDt
from ItemBranchUsage
where ItemNo='00170-2406-021'
order by Location, CurPeriodNo




select distinct ItemNo from ItemBranchUsage
select distinct CurPeriodNo from ItemBranchUsage order by CurPeriodNo




select * from ItemBranchUsage where ChangeID='WO1185_ConvertRodUsageIBU'