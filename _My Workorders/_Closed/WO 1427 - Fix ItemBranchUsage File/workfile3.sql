
select  * from tWO1112NucorNutsAndMetricsIBU
select * from tWO1112ItemBranchUsage


--select * from tItemBranchUsage05Aug2009 IBU
select * from ItemBranchUsage IBU
where exists (select * from tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
			IBU.Location = Nucor.Location and  --COLLATE SQL_Latin1_General_CP1_CI_AS) 
			IBU.CurPeriodNo=Nucor.CurPeriodNo) and  ItemNo='00056-2616-041'


and  not exists (select * from tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
			IBU.Location = Nucor.Location) --COLLATE SQL_Latin1_General_CP1_CI_AS) 


--select * from tItemBranchUsage05Aug2009 IBU
select * from ItemBranchUsage IBU
where exists (select * from tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
			IBU.Location = Nucor.Location) and  ItemNo='00056-2616-041'




select IBU.*
from tItemBranchUsage05Aug2009 IBU inner join tWO1112ItemBranchUsage TIBU
on IBU.ItemNo = TIBU.ItemNo AND
	IBU.Location = TIBU.Location AND
	IBU.CurPeriodNo = TIBU.CurPeriodNo
where exists 
 (select * from tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.NewItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
			IBU.Location = Nucor.Location) --COLLATE SQL_Latin1_General_CP1_CI_AS) 
and  exists (select * from tWO1112NucorNutsAndMetricsIBU Nucor
		 WHERE	IBU.ItemNo = Nucor.OldItem AND --COLLATE SQL_Latin1_General_CP1_CI_AS AND
			IBU.Location = Nucor.Location) --COLLATE SQL_Latin1_General_CP1_CI_AS) 





select	ItemNo, Location, CurPeriodNo, CurSalesQty, CurNRSalesQty,
	CurNoofSales, CurSalesDol, CurSalesWght, CurCostDol,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol,
	EntryID, EntryDt, ChangeID, ChangeDt
--from	tItemBranchUsage05Aug2009 where ItemNo='00056-2616-021'
from	ItemBranchUsage where ItemNo='00056-2616-021'

select	ItemNo, Location, CurPeriodNo, CurSalesQty, CurNRSalesQty,
	CurNoofSales, CurSalesDol, CurSalesWght, CurCostDol,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol,
	EntryID, EntryDt, ChangeID, ChangeDt
--from	tItemBranchUsage05Aug2009 where ItemNo='00056-2616-041'
from	ItemBranchUsage where ItemNo='00056-2616-041'

exec sp_Columns tItemBranchUsage05Aug2009



select * from tWO1112NucorNutsAndMetricsIBU
select * from tWO1112ItemBranchUsage