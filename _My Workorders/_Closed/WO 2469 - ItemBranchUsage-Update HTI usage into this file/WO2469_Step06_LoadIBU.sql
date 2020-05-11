
---------------------------------
-- *************************** --
-- ***  TEST AGAINST SQLT  *** --
-- *************************** --
---------------------------------

select count(*) from ItemBranchUsage

select	sum(CurNoofSales),
	sum(CurSalesQty),
	sum(CurSalesDol),
	sum(CurSalesWght),
	sum(CurCostDol)
FROM	ItemBranchUsage IBU 



select distinct (CurPeriodNo) from ItemBranchUsage
where EntryID='WO2469_Step06_LoadIBU'
order by CurPeriodNo



SELECT	*
FROM	tWO2469_HTI_IBU HTI_IBU
WHERE	NOT EXISTS
	(SELECT	*
	 FROM	ItemBranchUsage IBU
	 WHERE	HTI_IBU.Location = IBU.Location AND
		HTI_IBU.ItemNo = IBU.ItemNo AND
		HTI_IBU.Period = IBU.CurPeriodNo)


--no zeros
select * from ItemBranchUsage
where
(CurNoofSales <= 0 and 
CurSalesQty <= 0 and 
CurSalesDol <= 0 and
CurSalesWght <= 0 and 
CurCostDol <= 0)
and 
(EntryID='WO2469_Step06_LoadIBU' or ChangeID='WO2469_Step06_LoadIBU')


--no dups
select IBU.* from ItemBranchUsage IBU inner join
(
select * from
(select Count(*) as reccount, Location, ItemNo, CurPeriodNo from ItemBranchUsage
group by Location, ItemNo, CurPeriodNo) tmp
where reccount > 1
) dups
on IBU.Location = dups.Location and IBU.ItemNo = dups.ItemNo and IBU.CurPeriodNo = dups.CurPeriodNo
order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo




------------------------------------------------------------------------------------------------------

--Create empty ItemBranchUsage records that don't already exist
--198,964 records - less than 1 minute on SQLT
INSERT INTO	ItemBranchUsage
		([Location], ItemNo,  [CurPeriodNo],
		 [CurBegOnHandQty], [CurBegOnHandDol], [CurBegOnHandWght],
		 [CurNoofReceipts], [CurReceivedQty], [CurReceivedDol], [CurReceivedWght],
		 [CurNoofReturns], [CurReturnQty], [CurReturnDol], [CurReturnWght],
		 [CurNoofBackOrders], [CurBackOrderQty], [CurBackOrderDol], [CurBackOrderWght],
		 [CurNoofSales], [CurSalesQty], [CurSalesDol], [CurSalesWght], [CurCostDol],
		 [CurNoofTransfers], [CurTransferQty], [CurTransferDol], [CurTransferWght],
		 [CurNoofIssues], [CurIssuesQty], [CurIssuesDol], [CurIssuesWght],
		 [CurNoofAdjust], [CurAdjustQty], [CurAdjustDol], [CurAdjustWght],
		 [CurNoofChanges], [CurChangeQty], [CurChangeDol], [CurChangeWght],
		 [CurNoofPO], [CurPOQty], [CurPODol], [CurPOWght],
		 [CurNoofGER], [CurGERQty], [CurGERDol], [CurGERWght],
		 [CurNoofWorkOrders], [CurWorkOrderQty], [CurWorkOrderDol], [CurWorkOrderWght],
		 [CurLostSlsQty], [CurDailySlsQty], [CurDailyRetQty],
		 [CurEndOHQty], [CurEndOHDol], [CurEndOHWght],
		 [CurNoofOrders], [CurNRSalesQty], [CurNRNoSales], [CurNRSalesDol], [CurNRSalesWght], [CurNRCostDol],
		 [EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd])
SELECT		DISTINCT
		HTI_IBU.Location, HTI_IBU.ItemNo, HTI_IBU.Period,
		0 AS BegOHQty, 0 AS BegOHDol, 0 AS BegOHWght,
		0 AS NoRecs, 0 AS RecQty, 0 AS RecDol, 0 AS RecWght,
		0 AS NoRet, 0 AS RetQty, 0 AS RetDol, 0 AS RetWght,
		0 AS NoBO, 0 AS BOQty, 0 AS BODol, 0 AS BOWght,
		0 AS SlsCnt, 0 AS SlsQty, 0 AS SlsDol, 0 AS SlsWght, 0 AS SlsCost,
		0 AS NoXFR, 0 AS XFRQty, 0 As XFRDol, 0 AS XFRWght,
		0 AS NoIss, 0 AS IssQty, 0 AS IssDol, 0 AS IssWght,
		0 AS NoAdj, 0 AS AdjQty, 0 AS AdjDol, 0 AS AdjWght,
		0 AS NoChg, 0 AS ChgQty, 0 AS ChgDol, 0 AS ChgWght,
		0 AS NoPO, 0 AS POQty, 0 AS PODol, 0 AS POWght,
		0 AS NoGer, 0 AS GERQty, 0 AS GERDol, 0 AS GERWght,
		0 AS NoWO, 0 AS WOQty, 0 AS WODol, 0 AS WOWght,
		0 AS LSQty, 0 AS DlySlsQty, 0 AS DlyRetQty,
		0 AS EndOH, 0 AS EndVal, 0 As EndOHWght,
		0 AS NoOrd, 0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
		'WO2469_Step06_LoadIBU' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO2469_HTI_IBU HTI_IBU (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = HTI_IBU.Location AND IBU.ItemNo = HTI_IBU.ItemNo AND IBU.CurPeriodNo = HTI_IBU.Period)
GO

------------------------------------------------------------------------------------------------------

--Add USAGE to existing ItemBranchUsage transactions
--255,904 records - less than 1 minute on SQLT
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO2469_Step06_LoadIBU'
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	Period,
		ItemNo,
		Location,
		SUM(NoOfSales) as TotCount,
		SUM(SalesQty) as TotQty,
		SUM(SalesDol) as TotDol,
		SUM(SalesWght) as TotWght,
		SUM(CostDol) as TotCostDol
	 FROM	tWO2469_HTI_IBU (NoLock)
	 GROUP BY Period, ItemNo, Location) TempUse
ON	IBU.CurPeriodNo = TempUse.Period AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.Location
GO





