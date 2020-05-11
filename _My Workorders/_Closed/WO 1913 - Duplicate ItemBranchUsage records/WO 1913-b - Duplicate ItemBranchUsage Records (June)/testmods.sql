
-- 	SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @curPeriod INT,
		@endPeriod INT,
		@msg VARCHAR(100),
		@FM INT,
		@FY INT,
		@RefDate DATETIME

	DECLARE @begInvDt DATETIME
	DECLARE @endInvDT DATETIME
	DECLARE @userName VARCHAR(50)

--	SET @userName = 'HistBuild'
	SET @userName = 'WO1122_BuildItemCustomerHistoryv1'

	DECLARE @today DATETIME
	SELECT	@today = GETDATE()

	/*Uncomment the following statement to post a specific period
	--SET @today = CAST('11/01/2009' AS DATETIME) -- A date following the period you want to post
	end uncomment*/

	--Get FiscalMonth date range for prior month
	EXEC	[dbo].[pUTRetPeriod] 
		-- Add the parameters for the stored procedure here
		@date = @today, 
		@periodType = 'LF',
    		@period = @curPeriod OUTPUT,
		@periodBegin = @begInvDt OUTPUT,
		@periodEnd = @endInvDT OUTPUT

	SET	@endPeriod = @curPeriod

	--Summarize SODetail History
	SELECT	ISNULL(SODH.UsageLoc, SODH.IMLoc) AS IMLoc,
		SODH.ItemNo,
		@CurPeriod AS Period,
		Count(*) AS SlsCnt,
		SUM(SODH.QtyShipped) AS SlsQty,
		SUM(SODH.NetUnitPrice * SODH.QtyShipped) AS SlsDol,
		SUM(SODH.UnitCost * SODH.QtyShipped) AS SlsCost,
		SUM(IM.Wght * SODH.QtyShipped) AS SlsWght,
		@userName AS EntID,
		GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SODetailHist SODH (NoLock), SOHeaderHist SOHH (NoLock), ItemMaster IM (NoLock) 
	WHERE 	SODH.fSOHeaderHistID = SOHH.pSOHeaderHistID AND
		SODH.ItemNo = IM.ItemNo AND 
		SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SODH.UsageLoc, SODH.IMLoc), SODH.ItemNo

	--Build tempItemBranchUsageDUP for Items not Currently in table for which there are Sales
	INSERT INTO	tempItemBranchUsageDUP
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
	SELECT		SDS.IMLoc, SDS.ItemNo, SDS.Period,
--			SI.Qty, SI.ExtAvgCost, (SI.Qty * SI.NetUnitWght) As BegOHWght,
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
--			SI.Qty AS EndQty, SI.ExtAvgCost AS EndCost, (SI.Qty * SI.NetUnitWght) As EndOHWght, 0 AS NoOrd,
			0 AS EndQty, 0 AS EndCost, 0 AS EndWght, 0 AS NoOrd,
			0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
			@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
	FROM		#SODetailSum SDS (NoLock) --LEFT OUTER JOIN
--			SumItem SI (NoLock)
--	ON		SDS.IMLoc = SI.Location AND SDS.ItemNo = SI.ItemNo,
--			ItemMaster IMM (NoLock)
	WHERE		SDS.Period = @CurPeriod --AND
--			SI.SourceCd ='OH' AND
--			SDS.ItemNo = IMM.ItemNo

	--Set Non-Recorded (NR) usage
	SELECT	(DATEPART(yy,SOHH.InvoiceDT) * 100) + DatePart(mm,SOHH.InvoiceDT) AS Period,
		ISNULL(SODH.UsageLoc, SODH.IMLoc) AS IMLoc,
		SODH.ItemNo,
		SUM(SODH.QtyShipped) AS NRQty,
		Count(*) AS NRNoSls,
		SUM(SODH.ExtendedPrice) AS NRSlsDol,
		SUM(SODH.ExtendedNetWght) AS NRSlsWght,
		SUM(SODH.ExtendedCost) AS NRSlsCost
	INTO	#NR
	FROM	SODetailHist SODH (NoLock) INNER JOIN
		SOHeaderHist SOHH (NoLock)
	ON	SODH.fSOHeaderHistID = SOHH.pSOHeaderHistID
	WHERE	SOHH.InvoiceDt BETWEEN '20100501' and '20100601' AND --@begInvDt and @endInvDt AND
		SODH.ExcludedFromUsageFlag = 1
	GROUP BY (DATEPART(yy,SOHH.InvoiceDT) * 100) + DatePart(mm,SOHH.InvoiceDT), ISNULL(SODH.UsageLoc, SODH.IMLoc), SODH.ItemNo

	UPDATE	tempItemBranchUsageDUP
	SET	CurNRSalesQty = NRQty,
		CurNRNoSales = NRNoSls,
		CurNRSalesDol = NRSlsDol,
		CurNRSalesWght = NRSlsWght,
		CurNRCostDol = NRSlsCost,
		ChangeID = @userName,
		ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tempItemBranchUsageDUP.Location = NR.IMLoc AND
		tempItemBranchUsageDUP.ItemNo = NR.ItemNo AND
		tempItemBranchUsageDUP.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	DROP TABLE #NR



--------------------------------------------------------------------------------------------------------------------------


select * from tempItemBranchUsageDUP 
truncate table tempItemBranchUsageDUP



select IBU.* from tempItemBranchUsageDUP IBU inner join
(
select * from
(select Count(*) as reccount, Location, ItemNo, CurPeriodNo from tempItemBranchUsageDUP
group by Location, ItemNo, CurPeriodNo) tmp
where reccount > 1
) dups
on IBU.Location = dups.Location and IBU.ItemNo = dups.ItemNo and IBU.CurPeriodNo = dups.CurPeriodNo
order by IBU.Location, IBU.ItemNo, IBU.CurPeriodNo