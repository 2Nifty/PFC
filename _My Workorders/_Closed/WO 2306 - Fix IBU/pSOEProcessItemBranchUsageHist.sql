
USE [PFCReports]
GO
/****** Object:  StoredProcedure [dbo].[pSOEProcessItemBranchUsage]    Script Date: 03/07/2011 11:46:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[pSOEProcessItemBranchUsage] 
AS
BEGIN
-- 	==========================================================================================
-- 	Author: Craig Parks - Created: 12/22/2008
-- 	Descr:	Build ItemBranchUsage from History
-- 	Mods:	12/29/2008 Craig Parks Correct Where clause for ItemMaster
-- 			12/31/2008 Craig Parks Use SOIDetailHist UsageLoc if not NULL
-- 			01/02/2009 Craig Parks Use tSOHeaderHistUsage, tSODetailHistUsage
-- 			01/26/2009 Craig Parks Column Name Updates
-- 			03/27/2009 Craig Parks set Begin End InvDt with procedure based on current date
-- 			09/01/2009 Craig Parks Use Fiscal period date range
-- 			11/13/2009 Craig Parks Pick up both Navision and ERP Sales
--			12/06/2010 CSR WO2195 - Fix UsageLoc to pull from SOHeaderHist and not Detail
--			03/07/2011 TMD WO2306 - Fix bugs & general code cleanup
--									(Bugs: NRSales Period; SubTypes & DeleteDt; ARPostDt)
--									Also added a 2nd pass to load ItemBranchUsageHist table
--
-- 	==========================================================================================

 	SET NOCOUNT ON;	--added to prevent extra result sets from interfering with SELECT statements.

	DECLARE @curPeriod INT,
			@userName VARCHAR(50),
			@begInvDt DATETIME,
			@endInvDT DATETIME

--	SET @userName = 'HistBuild'
	SET @userName = 'WO1122_BuildItemCustomerHistoryv1'

	SELECT	@curPeriod = RIGHT(('0000' + Cast(Yearvalue AS VARCHAR(4))),4) + RIGHT(('00' + CAST(MonthValue AS VARCHAR(2))),2),
			@begInvDt = BegDate,
			@EndInvDt = EndDate
	FROM	CuvnalRanges (NoLock)
	WHERE	CuvnalParameter = 'CurrentMonth'

	--TO POST A SPECIFIC PERIOD: Set the Period and Begin & End Dates here
	--set @curPeriod = '201102'
	--set @begInvDt = cast('01/30/2011' as datetime)
	--set @endInvDt = cast('02/26/2011' as datetime)
	--select @curPeriod as Period, @begInvDt as BegDt, @EndInvDt as EndDt	

	--Summarize SODetail History (Sales & NR)
	SELECT	ISNULL(SOHH.UsageLoc, SODH.IMLoc) AS IMLoc,
			SODH.ItemNo,
			@CurPeriod AS Period,
			Count(*) AS SlsCnt,
			SUM(SODH.QtyShipped) AS SlsQty,
			SUM(SODH.NetUnitPrice * SODH.QtyShipped) AS SlsDol,
			SUM(SODH.UnitCost * SODH.QtyShipped) AS SlsCost,
			SUM(IM.Wght * SODH.QtyShipped) AS SlsWght,
			@userName AS EntID,
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= '50' OR SOHH.SubType = '53' OR SOHH.SubType = '54') AND
			ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
			SODH.ItemNo <> '00000-0000-000' AND
			CAST (FLOOR (CAST (SOHH.ARPostDt AS FLOAT)) AS DATETIME) Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo

	--Summarize SODetail History (SalesNR Only)
	SELECT	ISNULL(SOHH.UsageLoc, SODH.IMLoc) AS IMLoc,
			SODH.ItemNo,
			@CurPeriod AS Period,
			Count(*) AS NRCnt,
			SUM(SODH.QtyShipped) AS NRQty,
			SUM(SODH.ExtendedPrice) AS NRDol,
			SUM(SODH.ExtendedNetWght) AS NRWght,
			SUM(SODH.ExtendedCost) AS NRCost
	INTO	#NR
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= '50' OR SOHH.SubType = '53' OR SOHH.SubType = '54') AND
			ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			CAST (FLOOR (CAST (SOHH.ARPostDt AS FLOAT)) AS DATETIME) Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo

	---------------------------
	-- ItemBranchUsage Table --
	---------------------------
	--Build ItemBranchUsage for Items not Currently in table for which there are Sales
	INSERT INTO	ItemBranchUsage
				([Location], [ItemNo], [CurPeriodNo],
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
				 [CurEndOHQty], [CurEndOHDol], [CurEndOHWght], [CurNoofOrders],
				 [CurNRSalesQty], [CurNRNoSales], [CurNRSalesDol], [CurNRSalesWght], [CurNRCostDol],
				 [EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd])
		SELECT	SDS.IMLoc, SDS.ItemNo, SDS.Period,
				0 AS BegQty, 0 AS BegCost, 0 AS BegWght,
				0 AS NoRecs, 0 AS RecQty, 0 AS RecDol, 0 AS RecWght,
				0 AS NoRet, 0 AS RetQty, 0 AS RetDol, 0 AS RetWght,
				0 AS NoBO, 0 AS BOQty, 0 AS BODol, 0 AS BOWght,
				SDS.SlsCnt, SDS.SlsQty, SDS.SlsDol, SDS.SlsWght, SDS.SlsCost,
				0 AS NoXFR, 0 AS XFRQty, 0 As XFRDol, 0 AS XFRWght,
				0 AS NoIss, 0 AS IssQty, 0 AS IssDol, 0 AS IssWght,
				0 AS NoAdj, 0 AS AdjQty, 0 AS AdjDol, 0 AS AdjWght,
				0 AS NoChg, 0 AS ChgQty, 0 AS ChgDol, 0 AS ChgWght,
				0 AS NoPO, 0 AS POQty, 0 AS PODol, 0 AS POWght,
				0 AS NoGer, 0 AS GERQty, 0 AS GERDol, 0 AS GERWght,
				0 AS NoWO, 0 AS WOQty, 0 AS WODol, 0 AS WOWght,
				0 AS LSQty, 0 AS DlySlsQty, 0 AS DlyRetQty,
				0 AS EndQty, 0 AS EndCost, 0 AS EndWght, 0 AS NoOrd,
				0 AS NRUse, 0 AS NRNoSls, 0 AS NRDol, 0 AS NRWght, 0 AS NRCost,
				@userName AS EntID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) AS EntDt,
				NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
		FROM	#SODetailSum SDS (NoLock) 
		WHERE	SDS.Period = @CurPeriod 

	--UPDATE NR Sales
	UPDATE	ItemBranchUsage
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	FROM	#NR NR
	WHERE	ItemBranchUsage.Location = NR.IMLoc 
			AND	ItemBranchUsage.ItemNo = NR.ItemNo 
			AND	ItemBranchUsage.CurPeriodNo = NR.Period

	-------------------------------
	-- ItemBranchUsageHist Table --
	-------------------------------
	--Build ItemBranchUsageHist for Items not Currently in table for which there are Sales
	INSERT INTO	ItemBranchUsageHist
				([Location], [ItemNo], [CurPeriodNo],
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
				 [CurEndOHQty], [CurEndOHDol], [CurEndOHWght], [CurNoofOrders],
				 [CurNRSalesQty], [CurNRNoSales], [CurNRSalesDol], [CurNRSalesWght], [CurNRCostDol],
				 [EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd])
		SELECT	SDS.IMLoc, SDS.ItemNo, SDS.Period,
				0 AS BegQty, 0 AS BegCost, 0 AS BegWght,
				0 AS NoRecs, 0 AS RecQty, 0 AS RecDol, 0 AS RecWght,
				0 AS NoRet, 0 AS RetQty, 0 AS RetDol, 0 AS RetWght,
				0 AS NoBO, 0 AS BOQty, 0 AS BODol, 0 AS BOWght,
				SDS.SlsCnt, SDS.SlsQty, SDS.SlsDol, SDS.SlsWght, SDS.SlsCost,
				0 AS NoXFR, 0 AS XFRQty, 0 As XFRDol, 0 AS XFRWght,
				0 AS NoIss, 0 AS IssQty, 0 AS IssDol, 0 AS IssWght,
				0 AS NoAdj, 0 AS AdjQty, 0 AS AdjDol, 0 AS AdjWght,
				0 AS NoChg, 0 AS ChgQty, 0 AS ChgDol, 0 AS ChgWght,
				0 AS NoPO, 0 AS POQty, 0 AS PODol, 0 AS POWght,
				0 AS NoGer, 0 AS GERQty, 0 AS GERDol, 0 AS GERWght,
				0 AS NoWO, 0 AS WOQty, 0 AS WODol, 0 AS WOWght,
				0 AS LSQty, 0 AS DlySlsQty, 0 AS DlyRetQty,
				0 AS EndQty, 0 AS EndCost, 0 AS EndWght, 0 AS NoOrd,
				0 AS NRUse, 0 AS NRNoSls, 0 AS NRDol, 0 AS NRWght, 0 AS NRCost,
				@userName AS EntID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) AS EntDt,
				NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
		FROM	#SODetailSum SDS (NoLock) 
		WHERE	SDS.Period = @CurPeriod 

	--UPDATE NR Sales
	UPDATE	ItemBranchUsageHist
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	FROM	#NR NR
	WHERE	ItemBranchUsageHist.Location = NR.IMLoc 
			AND	ItemBranchUsageHist.ItemNo = NR.ItemNo 
			AND	ItemBranchUsageHist.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	DROP TABLE #NR

	RETURN (0)
END


