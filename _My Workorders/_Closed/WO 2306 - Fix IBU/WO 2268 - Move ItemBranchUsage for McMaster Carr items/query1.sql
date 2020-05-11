select	IBU.*
--into tSaveIBU_ToItem
from	tWO2268_McMasterCarrItems inner join
		ItemBranchUsage IBU
on		ToItem = ItemNo

select top 5 * from itembranchusage


delete
from	ItemBranchUsage
where pItemBranchUsageID in 
(select	IBU.pItemBranchUsageID as DelID
from	tWO2268_McMasterCarrItems inner join
		ItemBranchUsage IBU
on		ToItem = ItemNo)




select	IBU.*
from	tWO2268_McMasterCarrItems inner join
		ItemBranchUsage IBU
on		ToItem = ItemNo


select	IBU.*
from	tWO2268_McMasterCarrItems inner join
		ItemBranchUsage IBU
on		FromItem = ItemNo




select	IBU.*
from	tWO2268_UsageList TempUse inner join
		ItemBranchUsage IBU
on		TOItem = IBU.ItemNo-- or ToItem = ItemNo
WHERE	IBU.CurPeriodNo = TempUse.CurPeriod
order by IBU.ItemNo, IBU.Location



exec sp_columns ItemBranchUsage


select * from tWO2268_McMasterCarrItems





select * from tWO2268_UsageList
select * from tWO2268_SalesUsage
select * from tWO2268_NRUsage





delete
from	ItemBranchUsage
where pItemBranchUsageID in 
(select	IBU.pItemBranchUsageID as DelID
from	tWO2268_UsageList TempUse inner join
		ItemBranchUsage IBU
on		FromItem = IBU.ItemNo
where IBU.CurPeriodNo = TempUse.CurPeriod)




delete
from	ItemBranchUsage
where pItemBranchUsageID in 
(select	IBU.pItemBranchUsageID as DelID
from	tWO2268_UsageList TempUse inner join
		ItemBranchUsage IBU
on		ToItem = IBU.ItemNo
where IBU.CurPeriodNo = TempUse.CurPeriod)







select	DISTINCT IBU.*
from	tWO2268_UsageList TempUse inner join
		ItemBranchUsage IBU
on		FromItem = IBU.ItemNo
where IBU.CurPeriodNo = TempUse.CurPeriod
order by IBU.ItemNo, IBU.Location




select	DISTINCT IBU.*
from	tWO2268_UsageList TempUse inner join
		ItemBranchUsage IBU
on		ToItem = IBU.ItemNo
where IBU.CurPeriodNo = TempUse.CurPeriod
order by IBU.ItemNo, IBU.Location



select * from tWO2268_UsageList



select count(*) from ItemBranchUsage


select distinct
CurPeriodNo,
IBU.ItemNo,
IBU.Location,
--CurBegOnHandQty,
--CurBegOnHandDol,
--CurBegOnHandWght,
--CurNoofReceipts,
--CurReceivedQty,
--CurReceivedDol,
--CurReceivedWght,
--CurNoofReturns,
--CurReturnQty,
--CurReturnDol,
--CurReturnWght,
--CurNoofBackOrders,
--CurBackOrderQty,
--CurBackOrderDol,
--CurBackOrderWght,
CurNoofSales,
CurSalesQty,
CurSalesDol,
CurSalesWght,
CurCostDol,
--CurNoofTransfers,
--CurTransferQty,
--CurTransferDol,
--CurTransferWght,
--CurNoofIssues,
--CurIssuesQty,
--CurIssuesDol,
--CurIssuesWght,
--CurNoofAdjust,
--CurAdjustQty,
--CurAdjustDol,
--CurAdjustWght,
--CurNoofChanges,
--CurChangeQty,
--CurChangeDol,
--CurChangeWght,
--CurNoofPO,
--CurPOQty,
--CurPODol,
--CurPOWght,
--CurNoofGER,
--CurGERQty,
--CurGERDol,
--CurGERWght,
--CurNoOfWorkOrders,
--CurWorkOrderQty,
--CurWorkOrderDol,
--CurWorkOrderWght,
--CurLostSlsQty,
--CurDailySlsQty,
--CurDailyRetQty,
--CurEndOHQty,
--CurEndOHDol,
--CurEndOHWght,
--CurNoOfOrders,
CurNRSalesQty,
CurNRNoSales,
CurNRSalesDol,
CurNRSalesWght,
CurNRCostDol
--into tTodUseDistinct
--from ItemBranchUsage
from	tWO2268_UsageList TempUse inner join
		tWO2268_ItemBranchUsage IBU
on		ToItem = IBU.ItemNo
where IBU.CurPeriodNo = TempUse.CurPeriod and IBU.Location = TempUse.UsageLoc
order by IBU.ItemNo, IBU.Location


select * 
into tSaveIBU
from ItemBranchUsage

select * from   tSaveIBU


truncate table ItemBranchUsage


select count (*) from tTodUseDistinct



select * from tWO2268_UsageList

select	CurPeriod, FromItem, ToItem, UsageLoc,
		count(*) as [Count],
		sum(qtyshipped) as QtyShipped,
		sum(netunitprice) as NetUnitPrice,
		sum(ExtendedPrice) as ExtendedPrice,
		sum(NetWght) as NetWght,
		sum(ExtendedNetWght) as ExtendedNetWght,
		sum(UnitCost) as UnitCost,
		sum(ExtendedCost) as ExtendedCost
from tWO2268_UsageList
where ExcludedFromUsageFlag = 0
group by CurPeriod, FromItem, ToItem, UsageLoc
order by CurPeriod, FromItem, UsageLoc
		






