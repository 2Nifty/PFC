------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--verification


select distinct ItemNo from 
OpenDataSource('SQLOLEDB','Data Source=pfcsqlp;User ID=pfcnormal;Password=pfcnormal').pfcreports.dbo.ItemBranchUsage
where ItemNo in
(

select distinct OldItem from [tIBU_ItemToItem]
where NewItem in
(

select DISTINCT ItemNo
	--EntryID, ChangeId, *
from ItemBranchUsage
where	
--(left(EntryID,8) = 'WO2469.3' or left(ChangeID,8)='WO2469.3') and
left(EntryID,8) = 'WO2469.3' and
--left(ChangeID,8)='WO2469.3' and

ItemNo in
(
select distinct NewItem from
(
select NewItem,Count(*) as newcnt from [tIBU_ItemToItem] 
group by newitem
) tmp
where newcnt =1
--order by NewItem
)

)

)





select * from ItemBranchUsage
where	ItemNo='00460-2410-021' --and CurPeriodNo > '201105'
order by Location, ItemNo, CurPeriodNo






select * from ItemBranchUsage where
--left(itemNo,3)='110'

itemno in
(
'00020-4020-020'
--'00020-4020-100',
--'00020-4020-110',
--'00020-4020-120'
)

order by Location, ItemNo, CurPeriodNo







------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------



--truncate table itembranchusage

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--Step01 - CREATE tWO2469_HTI_Items
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tIBU_ItemToItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tIBU_ItemToItem]
GO


--Step02 - Load tWO2469_HTI_Items
--Less than 1 minute on SQLT
--(10377 row(s) affected)
SELECT	DISTINCT
	AliasItemNo as OldItem,
	ItemNo as NewItem
into	tIBU_ItemToItem
from	OpenDataSource('SQLOLEDB','Data Source=pfcerpdb;User ID=pfcnormal;Password=pfcnormal').perp.dbo.ItemAlias
WHERE	AliasWhseNo = 'HTI2' AND 
	AliasType = 'C' AND
	isnull(DeleteDt,'') = '' AND 
	ItemNo <> AliasItemNo


------------------------------------------------------------------------------------------------------------------------------------------

select * from tIBU_ItemToItem



select count(*) from ItemBranchUsage
where left(EntryID,8) = 'WO2469.3'
or left(ChangeID,8)='WO2469.3'

--

--exec [pWO2469.3_Ongoing_HTI_Usage_Cnv]

--exec pIBU_ItemToItem 'WO2469.3_Ongoing_HTI_Usage_Conversion', 'WO2469.3_Ongoing_HTI_Usage_Conversion'



select	sum(CurNoofSales), sum(CurSalesQty), sum(CurSalesDol), sum(CurSalesWght), sum(CurCostDol),
	sum(CurNRNoSales), sum(CurNRSalesQty), sum(CurNRSalesDol), sum(CurNRSalesWght), sum(CurNRCostDol)--, max(entryDt), max(changedt)
--select *
from	ItemBranchUsage
--from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranchUsage





------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--Step03 - CREATE tWO2469_Old_HTI_Items
--Less than 1 minute on SQLT
--(24714 row(s) affected)
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2469_Old_HTI_Items') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2469_Old_HTI_Items
go

SELECT	*
INTO	tWO2469_Old_HTI_Items
FROM	ItemBranchUsage (NoLock)
WHERE	ItemNo in (SELECT OldItem FROM tWO2469_HTI_Items)
go


------------------------------------------------------------------------------------------------------------------------------------------


--24714
select * from tWO2469_Old_HTI_Items



select distinct Location, ItemNo, CurPeriodNo
from tWO2469_Old_HTI_Items

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


--Step04 - DELETE existing OldItem transactions that were saved
--Less than 1 minute on SQLT
--(24714 row(s) affected)
DELETE
FROM	ItemBranchUsage
WHERE EXISTS	(SELECT	*
		 FROM	tWO2469_Old_HTI_Items HTI (NoLock)
		 WHERE	ItemBranchUsage.CurPeriodNo = HTI.CurPeriodNo AND
			ItemBranchUsage.ItemNo = HTI.ItemNo AND
			ItemBranchUsage.Location = HTI.Location)


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--step 5 summarize
SELECT	OldItem.Location, OldItem.CurPeriodNo, ItemList.NewItem,
	sum(CurBegOnHandQty) as CurBegOnHandQty,
	sum(CurBegOnHandDol) as CurBegOnHandDol,
	sum(CurBegOnHandWght) as CurBegOnHandWght,
	sum(CurNoofReceipts) as CurNoofReceipts,
	sum(CurReceivedQty) as CurReceivedQty,
	sum(CurReceivedDol) as CurReceivedDol,
	sum(CurReceivedWght) as CurReceivedWght,
	sum(CurNoofReturns) as CurNoofReturns,
	sum(CurReturnQty) as CurReturnQty,
	sum(CurReturnDol) as CurReturnDol,
	sum(CurReturnWght) as CurReturnWght,
	sum(CurNoofBackOrders) as CurNoofBackOrders,
	sum(CurBackOrderQty) as CurBackOrderQty,
	sum(CurBackOrderDol) as CurBackOrderDol,
	sum(CurBackOrderWght) as CurBackOrderWght,
	sum(CurNoofSales) as CurNoofSales,
	sum(CurSalesQty) as CurSalesQty,
	sum(CurSalesDol) as CurSalesDol,
	sum(CurSalesWght) as CurSalesWght,
	sum(CurCostDol) as CurCostDol,
	sum(CurNoofTransfers) as CurNoofTransfers,
	sum(CurTransferQty) as CurTransferQty,
	sum(CurTransferDol) as CurTransferDol,
	sum(CurTransferWght) as CurTransferWght,
	sum(CurNoofIssues) as CurNoofIssues,
	sum(CurIssuesQty) as CurIssuesQty,
	sum(CurIssuesDol) as CurIssuesDol,
	sum(CurIssuesWght) as CurIssuesWght,
	sum(CurNoofAdjust) as CurNoofAdjust,
	sum(CurAdjustQty) as CurAdjustQty,
	sum(CurAdjustDol) as CurAdjustDol,
	sum(CurAdjustWght) as CurAdjustWght,
	sum(CurNoofChanges) as CurNoofChanges,
	sum(CurChangeQty) as CurChangeQty,
	sum(CurChangeDol) as CurChangeDol,
	sum(CurChangeWght) as CurChangeWght,
	sum(CurNoofPO) as CurNoofPO,
	sum(CurPOQty) as CurPOQty,
	sum(CurPODol) as CurPODol,
	sum(CurPOWght) as CurPOWght,
	sum(CurNoofGER) as CurNoofGER,
	sum(CurGERQty) as CurGERQty,
	sum(CurGERDol) as CurGERDol,
	sum(CurGERWght) as CurGERWght,
	sum(CurNoOfWorkOrders) as CurNoOfWorkOrders,
	sum(CurWorkOrderQty) as CurWorkOrderQty,
	sum(CurWorkOrderDol) as CurWorkOrderDol,
	sum(CurWorkOrderWght) as CurWorkOrderWght,
	sum(CurLostSlsQty) as CurLostSlsQty,
	sum(CurDailySlsQty) as CurDailySlsQty,
	sum(CurDailyRetQty) as CurDailyRetQty,
	sum(CurEndOHQty) as CurEndOHQty,
	sum(CurEndOHDol) as CurEndOHDol,
	sum(CurEndOHWght) as CurEndOHWght,
	sum(CurNoOfOrders) as CurNoOfOrders,
	sum(CurNRSalesQty) as CurNRSalesQty,
	sum(CurNRNoSales) as CurNRNoSales,
	sum(CurNRSalesDol) as CurNRSalesDol,
	sum(CurNRSalesWght) as CurNRSalesWght,
	sum(CurNRCostDol) as CurNRCostDol
into	tWO2469_New_HTI_Usage
FROM	tWO2469_Old_HTI_Items OldItem (NoLock) INNER JOIN
	tWO2469_HTI_Items ItemList (NoLock)
ON	OldItem.ItemNo = ItemList.OldItem
group by OldItem.Location, OldItem.CurPeriodNo, ItemList.NewItem


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


--UPDATE existing NewItem transactions
--Less than 1 minute on SQLT
--(4011 row(s) affected)
UPDATE	ItemBranchUsage
SET	ItemBranchUsage.CurNoofSales = ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
	ItemBranchUsage.CurSalesQty = ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
	ItemBranchUsage.CurSalesDol = ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
	ItemBranchUsage.CurSalesWght = ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
	ItemBranchUsage.CurCostDol = ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
	ItemBranchUsage.CurNRSalesQty = ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
	ItemBranchUsage.CurNRNoSales = ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
	ItemBranchUsage.CurNRSalesDol = ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
	ItemBranchUsage.CurNRSalesWght = ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
	ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
	ItemBranchUsage.ChangeID = 'WO2469.3_Ongoing_HTI_Usage_Conversion',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	(SELECT	* FROM tWO2469_New_HTI_Usage) TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.NewItem AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


delete from ItemBranchUsage where EntryID='WO2469.3_Ongoing_HTI_Usage_Conversion'





SELECT	--ItemList.NewItem,OldItem.Location, OldItem.ItemNo, OldItem.CurPeriodNo,
	ItemList.NewItem+OldItem.Location+cast(OldItem.CurPeriodNo as varchar(20)) as [key]
into	#tIBUKey


select
distinct Newitem, location, curperiodno
-- ItemList.NewItem,OldItem.*
	 FROM	tWO2469_Old_HTI_Items OldItem (NoLock) INNER JOIN
		tWO2469_HTI_Items ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem


select * from #tIBUKey
where [key] in
(select ItemNo+Location+cast(CurPeriodNo as varchar(20))  from ItemBranchUsage)


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


--INSERT NewItem transactions saved items that did not have old usage
--Less than 1 minute on SQLT
--(20692 row(s) affected)
INSERT
INTO	ItemBranchUsage
	(Location, ItemNo,
	 CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
	 CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
	 CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
	 CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
	 CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
	 CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
	 CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
	 CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
	 CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
	 CurNoofPO, CurPOQty, CurPODol, CurPOWght,
	 CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
	 CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
	 CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
	 CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
	 CurNRSalesQty, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd,
	 CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol)
SELECT	Location, NewItem,
	CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
	CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
	CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
	CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
	CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
	CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
	CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
	CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
	CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
	CurNoofPO, CurPOQty, CurPODol, CurPOWght,
	CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
	CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
	CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
	CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
	CurNRSalesQty, 'WO2469.3_Ongoing_HTI_Usage_Conversion' as EntryID, GETDATE() as EntryDt, null, null, null,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	(SELECT	* FROM tWO2469_New_HTI_Usage) TIBU
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU
		    WHERE	IBU.Location = TIBU.Location AND
				IBU.ItemNo = TIBU.NewItem AND
				IBU.CurPeriodNo = TIBU.CurPeriodNo)




------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------






select	sum(CurNoofSales), sum(CurSalesQty), sum(CurSalesDol), sum(CurSalesWght), sum(CurCostDol),
	sum(CurNRNoSales), sum(CurNRSalesQty), sum(CurNRSalesDol), sum(CurNRSalesWght), sum(CurNRCostDol)--, max(entryDt), max(changedt)
--select *
from	ItemBranchUsage
--from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranchUsage

