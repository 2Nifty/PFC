if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1836_UsageList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1836_UsageList]
GO



--Build tWO1836_UsageList from SOHistory
--About 2-3 minutes in DEV (175,429 rows affected)
--About 2-3 minutes in QA (172,080 rows affected)
SELECT	Hdr.SellToCustNo,
	Hdr.ARPostDt,
	RIGHT(('0000' + Cast(Per.FiscalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalPeriod AS VARCHAR(2))),2) AS CurPeriod,
	Dtl.ItemNo,
	Dtl.LineNumber,
	Dtl.QtyShipped,
	Dtl.NetUnitPrice,
	Dtl.ExtendedPrice,
	Dtl.NetWght,
	Dtl.ExtendedNetWght,
	Dtl.UnitCost,
	Dtl.ExtendedCost,
	ISNULL(Dtl.ExcludedFromUsageFlag,0) AS ExcludedFromUsageFlag,
	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) AS UsageLoc,
	CustList.OldUsageLoc,
	CustList.NewUsageLoc
INTO	tWO1836_UsageList
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID INNER JOIN
	tWO1836_CustList CustList (NoLock)
ON	Hdr.SellToCustNo = CustList.CustNo LEFT OUTER JOIN
	FiscalCalendar Per (NoLock)
ON	Hdr.ARPostDt = Per.CurrentDt
WHERE	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = CustList.OldUsageLoc AND Hdr.SubType <= 50 AND
	Dtl.ItemNo <> '00000-0000-000' AND --ISNULL(Dtl.ExcludedFromUsageFlag,0) <> 1 AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')


select 
ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
 ARPostDt, CurPeriod,
* from tWO1836_UsageList where CurPeriod is null

inner
156778

left outer
189072

exec sp_columns ItemBranchUsage

----------------------------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1836_SalesUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1836_SalesUsage]
GO

--Build tWO1836_SalesUsage from tWO1836_UsageList
--Less than 1 minute in DEV (96,579 rows affected)
--Less than 1 minute in QA (94,707 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(NetUnitPrice * QtyShipped) AS TotDol,
	SUM(NetWght * QtyShipped) AS TotWght,
	SUM(UnitCost * QtyShipped) AS TotCostDol,
	OldUsageLoc,
	NewUsageLoc
INTO	tWO1836_SalesUsage
FROM	tWO1836_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag <> 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo, OldUsageLoc, NewUsageLoc




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1836_NRUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1836_NRUsage]
GO

--Build tWO1836_NRUsage from tWO1836_UsageList
--Less than 1 minute in DEV (94 rows affected)
--Less than 1 minute in QA (94 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(ExtendedPrice) AS TotDol,
	SUM(ExtendedNetWght) AS TotWght,
	SUM(ExtendedCost) AS TotCostDol,
	OldUsageLoc,
	NewUsageLoc
INTO	tWO1836_NRUsage
FROM	tWO1836_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag = 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo, OldUsageLoc, NewUsageLoc





select * from tWO1836_SalesUsage 
where ItemNo in ('00022-2416-021', '00110-2668-401', '00120-2726-951',  '02360-0868-242', '02360-2075-502')
order by ItemNo, CurPeriod


select * from tWO1836_NRUsage
where ItemNo in ('00022-2416-021', '00110-2668-401', '00120-2726-951',  '02360-0868-242', '02360-2075-502')
order by ItemNo, CurPeriod


select * from tWO1836_NRUsage where ItemNo not in (select ItemNo from tWO1836_SalesUsage) and CurPeriod+ItemNo in (select CurPeriod+ItemNo from tWO1836_SalesUsage)
order by ItemNo, CurPeriod

select * from ItemBranchUsage
where 
((CurPeriodNo='200706' and ItemNo='00022-2416-021') or
(CurPeriodNo='200707' and ItemNo='00022-2416-021') or
(CurPeriodNo='200709' and ItemNo='00022-2416-021') or
(CurPeriodNo='200711' and ItemNo='00022-2416-021') or
(CurPeriodNo='200712' and ItemNo='00022-2416-021') or
(CurPeriodNo='200801' and ItemNo='00022-2416-021') or
(CurPeriodNo='200802' and ItemNo='00022-2416-021') or
(CurPeriodNo='200803' and ItemNo='00022-2416-021') or
(CurPeriodNo='200804' and ItemNo='00022-2416-021') or
(CurPeriodNo='200811' and ItemNo='00022-2416-021') or
(CurPeriodNo='200901' and ItemNo='00022-2416-021') or
(CurPeriodNo='200902' and ItemNo='00022-2416-021') or
(CurPeriodNo='200903' and ItemNo='00022-2416-021') or
(CurPeriodNo='200703' and ItemNo='00110-2668-401') or
(CurPeriodNo='200704' and ItemNo='00110-2668-401') or
(CurPeriodNo='200705' and ItemNo='00110-2668-401') or
(CurPeriodNo='200706' and ItemNo='00110-2668-401') or
(CurPeriodNo='200711' and ItemNo='00110-2668-401') or
(CurPeriodNo='200712' and ItemNo='00110-2668-401') or
(CurPeriodNo='200803' and ItemNo='00110-2668-401') or
(CurPeriodNo='200804' and ItemNo='00110-2668-401') or
(CurPeriodNo='200703' and ItemNo='00022-2416-021') or
(CurPeriodNo='200706' and ItemNo='00022-2416-021') or
(CurPeriodNo='200709' and ItemNo='00022-2416-021'))
AND Location='01'
order by Location, ItemNo, CurPeriodNo

select * from ItemBranchUsage
where 
((CurPeriodNo='200706' and ItemNo='00022-2416-021') or
(CurPeriodNo='200707' and ItemNo='00022-2416-021') or
(CurPeriodNo='200709' and ItemNo='00022-2416-021') or
(CurPeriodNo='200711' and ItemNo='00022-2416-021') or
(CurPeriodNo='200712' and ItemNo='00022-2416-021') or
(CurPeriodNo='200801' and ItemNo='00022-2416-021') or
(CurPeriodNo='200802' and ItemNo='00022-2416-021') or
(CurPeriodNo='200803' and ItemNo='00022-2416-021') or
(CurPeriodNo='200804' and ItemNo='00022-2416-021') or
(CurPeriodNo='200811' and ItemNo='00022-2416-021') or
(CurPeriodNo='200901' and ItemNo='00022-2416-021') or
(CurPeriodNo='200902' and ItemNo='00022-2416-021') or
(CurPeriodNo='200903' and ItemNo='00022-2416-021') or
(CurPeriodNo='200703' and ItemNo='00110-2668-401') or
(CurPeriodNo='200704' and ItemNo='00110-2668-401') or
(CurPeriodNo='200705' and ItemNo='00110-2668-401') or
(CurPeriodNo='200706' and ItemNo='00110-2668-401') or
(CurPeriodNo='200711' and ItemNo='00110-2668-401') or
(CurPeriodNo='200712' and ItemNo='00110-2668-401') or
(CurPeriodNo='200803' and ItemNo='00110-2668-401') or
(CurPeriodNo='200804' and ItemNo='00110-2668-401') or
(CurPeriodNo='200703' and ItemNo='00022-2416-021') or
(CurPeriodNo='200706' and ItemNo='00022-2416-021') or
(CurPeriodNo='200709' and ItemNo='00022-2416-021'))
AND Location='15'
order by Location, ItemNo, CurPeriodNo

----------------------------------------------------------------------------------------------------------------

--Subtract USAGE from existing ItemBranchUsage transactions
--Less than 1 minute in DEV (33,558 rows affected)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) - TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) - TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) - TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) - TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) - TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1836'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1836_SalesUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.OldUsageLoc
GO

--Subtract USAGE from existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (1 row affected)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) - TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) - TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) - TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) - TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) - TempUse.TotCostDol,
	CurNRNoSales = ISNULL(CurNRNoSales,0) - TempUse.TotCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) - TempUse.TotQty,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) - TempUse.TotDol,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) - TempUse.TotWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) - TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1836'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1836_NRUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.OldUsageLoc
GO



----------------------------------------------------------------------------------------------------------------

--Create empty ItemBranchUsage records that don't already exist
--Less than 1 minute in DEV (62,926 rows affected)
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
SELECT		TempUse.NewUsageLoc, ItemNo, CurPeriod,
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
		'WO1836' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1836_SalesUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = TempUse.NewUsageLoc AND IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod)
GO

--Create empty ItemBranchUsage records that don't already exist (NR)
--Less than 1 minute in DEV (50 rows affected)
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
SELECT		TempUse.NewUsageLoc, ItemNo, CurPeriod,
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
		'WO1836' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1836_NRUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = TempUse.NewUsageLoc AND IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod)
GO


----------------------------------------------------------------------------------------------------------------

--Add USAGE to existing ItemBranchUsage transactions
--Less than 1 minute in DEV (96,586 rows affected)
--?? How can there be more updates than records in tWO1836_SalesUsage (96,579)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1836'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1836_SalesUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.NewUsageLoc
GO

--Add USAGE to existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (94 rows affected)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
	CurNRNoSales = ISNULL(CurNRNoSales,0) + TempUse.TotCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) + TempUse.TotQty,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) + TempUse.TotDol,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) + TempUse.TotWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) + TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1836'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1836_NRUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.NewUsageLoc
GO

----------------------------------------------------------------------------------------------------------------

---- Must update to SORel & Hist tables in both PFCReports & ERPDB ----
-----------------------------------------------------------------------


--UPDATE SOHeaderRel open order records with new UsageLoc
--Less than 1 minute in DEV (141 rows affected)
UPDATE	SOHeaderRel
SET	UsageLoc = CustList.NewUsageLoc
FROM	SOHeaderRel Hdr (NoLock) INNER JOIN
	SODetailRel Dtl (NoLock)
ON	Hdr.pSOHeaderRelID = Dtl.fSOheaderRelID INNER JOIN
	tWO1836_CustList CustList (NoLock)
ON	Hdr.SellToCustNo = CustList.CustNo
WHERE	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = CustList.OldUsageLoc AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.InvoiceDt IS NULL OR Hdr.InvoiceDt = '') AND (Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
order by Hdr.SellToCustNo


--UPDATE SOHeaderHist invoiced records with new UsageLoc
--About 2-3 minutes in DEV (20,473 rows affected)
UPDATE	SOHeaderHist
SET	UsageLoc = CustList.NewUsageLoc
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID INNER JOIN
	tWO1836_CustList CustList (NoLock)
ON	Hdr.SellToCustNo = CustList.CustNo
WHERE	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = CustList.OldUsageLoc AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
order by Hdr.SellToCustNo

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

--172,080
select * from tWO1836_UsageList
order by ItemNo, CurPeriod

SELECT	CurPeriod,
	ItemNo,
	SUM(QtyOrdered) AS TotOrdered,
	SUM(QtyShipped) AS TotShipped,
	Round(SUM(ExtendedPrice),2) AS TotPrice,
	Round(SUM(ExtendedNetWght),4) AS TotNetWght,
	Round(SUM(ExtendedCost),2) AS TotCost,
	COUNT(LineNumber) AS LineCount,
	OldUsageLoc,
	NewUsageLoc
from	tWO1836_UsageList
group by CurPeriod, ItemNo, OldUsageLoc, NewUsageLoc
order by ItemNo, CurPeriod


--select * from FiscalCalendar

--select * from ItemBranchUsage

exec sp_columns tWO1836_CustList


--1172 customers
select distinct(CustNo) from tWO1836_CustList

------------------------------------------------------------------------------------

--select * from CustomerMaster
--where CustomerMaster.CustNo='15'

--update CustomerMaster
--set CustNo = QA.CustNo
--from perp.dbo.CustomerMaster QA
--where CustomerMaster.CustNo='15' and CustomerMaster.CustSearchKey=QA.CustSearchKey

SELECT	Cust.CustNo, 
	--CustList.CustNo,
	Cust.UsageLocation --, *
FROM	CustomerMaster Cust INNER JOIN
	tWO1836_CustList CustList
ON	Cust.CustNo = CustList.CustNo



--ERP CustomerMaster - Less than 1 minute in QA (1,172 rows affected)
UPDATE	CustomerMaster
SET	--UsageLocation='99'
	UsageLocation = CustList.OldUsageLoc
FROM	tWO1836_CustList CustList INNER JOIN
	CustomerMaster Cust
ON	Cust.CustNo = CustList.CustNo


select * from tWO1836_CustList


exec sp_columns CustomerMaster


-------------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1187Br20CustUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1187Br20CustUsage

--SELECT ERP Transactions for Update from SOHist WHERE ExcludedFromUsageFlag <> 1
SELECT	--InvoiceNo, SellToCustNo,  ARPostDt, Dtl.UsageLoc
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo,
	ItemNo,
	SUM(QtyOrdered) AS QtyOrdered,
	Round(SUM(ExtendedPrice),2) AS ExtendedPrice,
	Round(SUM(ExtendedNetWght),4) AS ExtendedNetWght,
	Round(SUM(ExtendedCost),2) AS ExtendedCost,
	COUNT(LineNumber) AS LineCount --, ExcludedFromUsageFlag
INTO	tWO1187Br20CustUsage
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
WHERE	Dtl.UsageLoc = '20' AND ISNULL(ExcludedFromUsageFlag,0) <> 1 AND
	(SellToCustNo = '038917' OR 
	 SellToCustNo = '038928' OR 
	 SellToCustNo = '042071' OR 
	 SellToCustNo = '046431' OR 
	 SellToCustNo = '054021' OR 
	 SellToCustNo = '054023' OR 
	 SellToCustNo = '057461' OR 
	 SellToCustNo = '057471' OR 
	 SellToCustNo = '059227')
GROUP BY CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2), ItemNo
ORDER BY ItemNo, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)
