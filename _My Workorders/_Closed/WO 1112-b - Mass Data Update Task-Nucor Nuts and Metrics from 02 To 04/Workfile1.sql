if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tItemBranchUsage

SELECT	*
INTO	tItemBranchUsage
FROM	ItemBranchUsage IBU
WHERE EXISTS
(SELECT	1
 FROM	tWO1112NucorNutsAndMetricsAUE TNI
 WHERE	ItemNo = NewItem COLLATE SQL_Latin1_General_CP1_CI_AS AND
	IBU.Location = TNI.Location COLLATE SQL_Latin1_General_CP1_CI_AS)
	
	
	
---------------------------------------------------------------------



DECLARE @factor DECIMAL(18,5)
SET @factor = 1.25
-- Delete Existing 40LB Items
DELETE FROM ItemBranchUsage WHERE EXISTS (SELECT 1
FROM tWO1112NucorNutsAndMetricsAUE  tip WHERE NewItem = ItemNo
COLLATE SQL_Latin1_General_CP1_CI_AS
AND tip.Location = Location COLLATE SQL_Latin1_General_CP1_CI_AS)

--Update ItemBranch Usage ItemNo, CurSales, CurNRSalesQty
UPDATE	[ItemBranchUsage]
SET	[ItemNo] = NewItem,
	[CurSalesQty] = ROUND(([CurSalesQty] * @factor),0),
	[CurNRSalesQty] = ROUND(([CurNRSalesQty] * @factor),0)
FROM	[ItemBranchUsage] IBU
INNER JOIN
(SELECT	*
FROM	tWO1112NucorNutsAndMetricsAUE) [40Lb]
ON	IBU.[ItemNo]=[40Lb].[OldItem] COLLATE SQL_Latin1_General_CP1_CI_AS
AND IBU.[Location]=[40Lb].[Location] COLLATE SQL_Latin1_General_CP1_CI_AS





--Delete existing ItemBranchUsage that was saved
DELETE FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemBranchUsage
WHERE EXISTS	(SELECT	1
		 FROM	tWO1112NucorNutsAndMetricsAUE Nucor
		 WHERE	NewItem = ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
			Nucor.Location = Location COLLATE SQL_Latin1_General_CP1_CI_AS)



DECLARE	@factor	DECIMAL(18,5)
SET	@factor = 1.25

--Update ItemBranchUsage ItemNo, CurSales, CurNRSalesQty
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemBranchUsage
SET	ItemNo = NewItem,
	CurSalesQty = ROUND((IBU.CurSalesQty * @factor),0),
	CurNRSalesQty = ROUND((IBU.CurNRSalesQty * @factor),0)
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemBranchUsage IBU INNER JOIN
	(SELECT	*
	 FROM	tWO1112NucorNutsAndMetricsAUE) [40Lb]
ON	[40Lb].OldItem = IBU.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
	[40Lb].Location = IBU.Location COLLATE SQL_Latin1_General_CP1_CI_AS






OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1112NucorNutsAndMetricsAUE




---------------------------------------------------------------------



-- Update ItemBranch Usage

UPDATE ItemBranchUsage SET
ItemBranchUsage.CurNoofSales= ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
ItemBranchUsage.CurSalesQty= ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
ItemBranchUsage.CurSalesDol= ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
ItemBranchUsage.CurSalesWght= ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
ItemBranchUsage.CurCostDol= ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
ItemBranchUsage.CurNRSalesQty= ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
ItemBranchUsage.CurNRNoSales= ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
ItemBranchUsage.CurNRSalesDol= ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
ItemBranchUsage.CurNRSalesWght= ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
ItemBranchUsage.ChangeID='UpdatefromItemChg'
FROM tItemBranchUsage TIBU
WHERE ItemBranchUsage.ItemNo = TIBU.ItemNo
AND ItemBranchUsage.Location = TIBU.Location
AND ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo

INSERT INTO ItemBranchUsage (Location,ItemNo,
CurPeriodNo,CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
CurNoofPO,CurPOQty,CurPODol,CurPOWght,
CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
CurNRSalesQty, EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,
CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol)
SELECT Location,ItemNo,
CurPeriodNo,CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
CurNoofPO,CurPOQty,CurPODol,CurPOWght,
CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
CurNRSalesQty, EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,
CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
FROM tItemBranchUsage TIBU WHERE NOT EXISTS
(SELECT 1 FROM ItemBranchUsage IBU WHERE
TIBU.Location = IBU.Location
AND TIBU.ItemNo = IBU.ItemNo
AND TIBU.CurPeriodNo = IBU.CurPeriodNo)








--UPDATE ItemBranchUsage: Combine saved & updated items
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
	ItemBranchUsage.ChangeID = 'WO1112_ConvertNucorNutsAndMetricsAUE'
FROM	tItemBranchUsage TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo


--UPDATE ItemBranchUsage: Insert new items that didn't have old sales
INSERT INTO	ItemBranchUsage
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
SELECT		Location, ItemNo,
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
		CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM		tItemBranchUsage TIBU
WHERE NOT EXISTS
(SELECT	1
 FROM	ItemBranchUsage IBU
 WHERE	TIBU.Location = IBU.Location AND
	TIBU.ItemNo = IBU.ItemNo AND
	TIBU.CurPeriodNo = IBU.CurPeriodNo)
