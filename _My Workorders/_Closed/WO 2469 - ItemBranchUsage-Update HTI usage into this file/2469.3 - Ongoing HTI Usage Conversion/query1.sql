


SELECT	DISTINCT
	AliasItemNo as OldItem,
	ItemNo as NewItem
FROM 	ItemAlias (NoLock)
WHERE	AliasWhseNo = 'HTI2' AND 
	AliasType = 'C' AND
	isnull(DeleteDt,'') = '' AND 
	ItemNo <> AliasItemNo



SELECT	DISTINCT
	AliasItemNo as OldItem,
	ItemNo as NewItem
FROM 	tWO2469_HTIAlias
WHERE	AliasWhseNo = 'HTI2' AND
	AliasType = 'C'





SELECT	*
FROM	tWO2469_HTI_Items










select --distinct curperiodno
	ItemNo, Location, CurPeriodNo, 
	sum(CurNoofSales), sum(CurSalesQty), sum(CurSalesDol), sum(CurSalesWght), sum(CurCostDol),
	sum(CurNRNoSales), sum(CurNRSalesQty), sum(CurNRSalesDol), sum(CurNRSalesWght), sum(CurNRCostDol)
from tWO2469_Old_HTI_Items
group by ItemNo, Location, CurPeriodNo



SELECT	DISTINCT
	AliasItemNo as FromItem,
	ItemNo as ToItem
FROM 	tWO2469_HTIAlias
WHERE	AliasWhseNo = 'HTI2' AND
	AliasType = 'C'




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO2469_HTI_Items]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO2469_HTI_Items]
GO

CREATE TABLE [dbo].[tWO2469_HTI_Items] (
	[OldItem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NewItem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO








--Create tWO2469_Old_HTI_Items
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2469_Old_HTI_Items') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2469_Old_HTI_Items
go

SELECT	*
INTO	tWO2469_Old_HTI_Items
FROM	ItemBranchUsage (NoLock)
WHERE	ItemNo in (SELECT OldItem FROM tWO2469_HTI_Items)
go



select * from tWO2469_Old_HTI_Items





--DELETE existing OldItem transactions that were saved
DELETE
FROM	ItemBranchUsage
WHERE EXISTS	(SELECT	*
		 FROM	tWO2469_Old_HTI_Items HTI (NoLock)
		 WHERE	ItemBranchUsage.CurPeriodNo = HTI.CurPeriodNo AND
			ItemBranchUsage.ItemNo = HTI.ItemNo AND
			ItemBranchUsage.Location = HTI.Location)




--UPDATE existing NewItem transactions
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
FROM	(SELECT	ItemList.NewItem, OldItem.*
	 FROM	tWO2469_Old_HTI_Items OldItem (NoLock) INNER JOIN
		tWO2469_HTI_Items ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem) TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.NewItem AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo




--INSERT NewItem transactions saved items that did not have old usage
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
	CurNRSalesQty, 'WO2469.3_Ongoing_HTI_Usage_Conversion' as EntryID, GETDATE() as EntryDt, ChangeID, ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	(SELECT	ItemList.NewItem, OldItem.*
	 FROM	tWO2469_Old_HTI_Items OldItem (NoLock) INNER JOIN
		tWO2469_HTI_Items ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem) TIBU
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU
		    WHERE	IBU.Location = TIBU.Location AND
				IBU.ItemNo = TIBU.NewItem AND
				IBU.CurPeriodNo = TIBU.CurPeriodNo)


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2469_HTI_Items') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2469_HTI_Items
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2469_Old_HTI_Items') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2469_Old_HTI_Items
go

