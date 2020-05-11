drop table #tCheckUsage

select ItemNo, Location, CurPeriodNo, CurNoOfSales, CurSalesQty, CurNRNoSales, CurNRSalesQty, EntryId, EntryDt, ChangeID, ChangeDt
into #tCheckUsage
from ItemBranchUsage
where ItemNo='00110-2650-021' and (left(EntryID,8)='WO2469.3' or left(ChangeID,8)='WO2469.3')
order by ItemNo, Location, CurPeriodNo

select * from #tCheckUsage




select ItemNo, Location, CurPeriodNo, CurNoOfSales, CurSalesQty, CurNRNoSales, CurNRSalesQty, EntryId, EntryDt, ChangeID, ChangeDt
from ItemBranchUsageHist
where 
ItemNo+Location+cast(CurPeriodNo as varchar(30)) in
(
select ItemNo+Location+cast(CurPeriodNo as varchar(30)) as Key1
from #tCheckUsage
)
or
ItemNo+Location+cast(CurPeriodNo as varchar(30)) in
(
select '00110-2650-101'+Location+cast(CurPeriodNo as varchar(30)) as Key1
from #tCheckUsage
)
order by ItemNo, Location, CurPeriodNo


select ItemNo, Location, CurPeriodNo, CurNoOfSales, CurSalesQty, CurNRNoSales, CurNRSalesQty, EntryId, EntryDt, ChangeID, ChangeDt
from ItemBranchUsageHist
where ItemNo+Location+cast(CurPeriodNo as varchar(30)) in
(
select ItemNo+'01'+cast(CurPeriodNo as varchar(30)) as Key1
from #tCheckUsage
)
or
ItemNo+Location+cast(CurPeriodNo as varchar(30)) in
(
select '00370-2600-151'+'01'+cast(CurPeriodNo as varchar(30)) as Key1
from #tCheckUsage
)
order by ItemNo, Location, CurPeriodNo






select ItemNo, Location, Period, NoOfSales, SalesQty, LoadID, LoadDt
from HTI_IBU
where ItemNo in ('00370-2600-021','00370-2600-151')


--select * from ItemBranchUsageHist where ItemNo='00024-3024-101' and CurPeriodNo='201108' and Location='04'




--select * from ItemBranchUsageHist where ItemNo='00024-3024-101'


