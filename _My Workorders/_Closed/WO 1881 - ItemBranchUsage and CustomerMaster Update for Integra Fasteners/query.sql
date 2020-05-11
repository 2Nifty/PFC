if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_UsageList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_UsageList]
GO

--Step01: Build tWO1881_UsageList from SOHistory
--Less than 1 minute in DEV (1,542 rows affected)
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
	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) AS UsageLoc
INTO	tWO1881_UsageList
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID LEFT OUTER JOIN
	FiscalCalendar Per (NoLock)
ON	Hdr.ARPostDt = Per.CurrentDt
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO


---------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_SalesUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_SalesUsage]
GO

--Step02: Build tWO1881_SalesUsage from tWO1881_UsageList
--Less than 1 minute in DEV (1,254 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(NetUnitPrice * QtyShipped) AS TotDol,
	SUM(NetWght * QtyShipped) AS TotWght,
	SUM(UnitCost * QtyShipped) AS TotCostDol,
	'10' as OldUsageLoc,
	'09' as NewUsageLoc
INTO	tWO1881_SalesUsage
FROM	tWO1881_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag <> 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo
GO

----------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_NRUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_NRUsage]
GO

--Step03: Build tWO1881_NRUsage from tWO1881_UsageList
--Less than 1 minute in DEV (94 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(ExtendedPrice) AS TotDol,
	SUM(ExtendedNetWght) AS TotWght,
	SUM(ExtendedCost) AS TotCostDol,
	'10' as OldUsageLoc,
	'09' as NewUsageLoc
INTO	tWO1881_NRUsage
FROM	tWO1881_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag = 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo
GO

-------------------------------------------------------------------------------------------

--Subtract USAGE from existing ItemBranchUsage transactions
--Less than 1 minute in DEV (682 rows affected)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) - TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) - TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) - TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) - TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) - TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1881_SalesUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.OldUsageLoc
GO

--Subtract USAGE from existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (70 row affected)
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
	ChangeID = 'WO1881'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1881_NRUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.OldUsageLoc
GO


-------------------------------------------------------------------------------------------


--Create empty ItemBranchUsage records that don't already exist
--Less than 1 minute in DEV (579 rows affected)
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
		'WO1881' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1881_SalesUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = TempUse.NewUsageLoc AND IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod)
GO

--Create empty ItemBranchUsage records that don't already exist (NR)
--Less than 1 minute in DEV (19 rows affected)
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
		'WO1881' AS EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
FROM		tWO1881_NRUsage TempUse (NoLock)
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU (NoLock)
			    WHERE  IBU.Location = TempUse.NewUsageLoc AND IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPeriod)
GO


----------------------------------------------------------------------------------

--Add USAGE to existing ItemBranchUsage transactions
--Less than 1 minute in DEV (1,258 rows affected)
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + TempUse.TotCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + TempUse.TotQty,
	CurSalesDol = ISNULL(CurSalesDol,0) + TempUse.TotDol,
	CurSalesWght = ISNULL(CurSalesWght,0) + TempUse.TotWght,
	CurCostDol = ISNULL(CurCostDol,0) + TempUse.TotCostDol,
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1881_SalesUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.NewUsageLoc
GO

--Add USAGE to existing ItemBranchUsage transactions (NR)
--Less than 1 minute in DEV (77 rows affected)
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
	ChangeID = 'WO1881'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1881_NRUsage TempUse
ON	IBU.CurPeriodNo = TempUse.CurPeriod AND IBU.ItemNo = TempUse.ItemNo AND IBU.Location = TempUse.NewUsageLoc
GO


------------------------------------------------------------------------------------


--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_UsageList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[tWO1881_UsageList]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_SalesUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_SalesUsage]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_NRUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_NRUsage]
GO


------------------------------------------------------------------------------------

--Step09: UPDATE Customer Usage Loc [ERP]
--ERP CustomerMaster - Less than 1 minute in DEV (1 row affected)
UPDATE	CustomerMaster
SET	UsageLocation = '09',
	ChangeID = 'WO1881',
	ChangeDt = GETDATE()
WHERE	CustNo = '076121'
GO


------------------------------------------------------------------------------------

--Step10: UPDATE SOHeaderRel open order records with new UsageLoc [ERP]
--0 rows to update in DEV
UPDATE	SOHeaderRel
SET	UsageLoc = '09',
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	SOHeaderRel Hdr (NoLock) INNER JOIN
	SODetailRel Dtl (NoLock)
ON	Hdr.pSOHeaderRelID = Dtl.fSOheaderRelID
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.InvoiceDt IS NULL OR Hdr.InvoiceDt = '') AND (Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND
	--(Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO


------------------------------------------------------------------------------------

--Step11: UPDATE SOHeaderHist invoiced records with new UsageLoc [ERP]
--Less than 1 minute in DEV (677 rows affected)
UPDATE	SOHeaderHist
SET	UsageLoc = '09',
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO


------------------------------------------------------------------------------------


--Step12: UPDATE SOHeaderRel open order records with new UsageLoc [PFCReports]
--UPDATE SOHeaderRel open order records with new UsageLoc
--0 rows to update in DEV
UPDATE	SOHeaderRel
SET	UsageLoc = '09',
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	SOHeaderRel Hdr (NoLock) INNER JOIN
	SODetailRel Dtl (NoLock)
ON	Hdr.pSOHeaderRelID = Dtl.fSOheaderRelID
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.InvoiceDt IS NULL OR Hdr.InvoiceDt = '') AND (Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND
	--(Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO


------------------------------------------------------------------------------------

--Step13: UPDATE SOHeaderHist invoiced records with new UsageLoc [PFCReports]
--Less than 1 minute in DEV (677 rows affected)
UPDATE	SOHeaderHist
SET	UsageLoc = '09',
	ChangeDt = GetDate(),
	ChangeID = 'WO1881'
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') --AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO
