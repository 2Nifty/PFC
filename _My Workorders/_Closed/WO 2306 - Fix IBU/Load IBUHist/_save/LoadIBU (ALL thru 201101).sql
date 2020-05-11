--truncate table tFix_ItemBranchUsage1

--Clear Posting Period
DECLARE @begInvDt DATETIME
DECLARE @endInvDT DATETIME
DECLARE @curPeriod INT

DECLARE @userName VARCHAR(50)
SET @userName = 'WO2306_FixIBU_InitialLoad'

--------------------------------------------------------------------------------------------------------

set @curPeriod = '200709'
set @begInvDt = cast('8/26/2007' as datetime)
set @endInvDt = cast('9/22/2007' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go

select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200710'
set @begInvDt = cast('9/23/2007' as datetime)
set @endInvDt = cast('10/27/2007' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200711'
set @begInvDt = cast('10/28/2007' as datetime)
set @endInvDt = cast('11/24/2007' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200712'
set @begInvDt = cast('11/25/2007' as datetime)
set @endInvDt = cast('12/22/2007' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200801'
set @begInvDt = cast('12/23/2007' as datetime)
set @endInvDt = cast('1/26/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200802'
set @begInvDt = cast('1/27/2008' as datetime)
set @endInvDt = cast('3/1/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200803'
set @begInvDt = cast('3/2/2008' as datetime)
set @endInvDt = cast('3/29/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200804'
set @begInvDt = cast('3/30/2008' as datetime)
set @endInvDt = cast('5/3/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200805'
set @begInvDt = cast('5/4/2008' as datetime)
set @endInvDt = cast('5/31/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200806'
set @begInvDt = cast('6/1/2008' as datetime)
set @endInvDt = cast('6/28/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200807'
set @begInvDt = cast('6/29/2008' as datetime)
set @endInvDt = cast('8/2/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200808'
set @begInvDt = cast('8/3/2008' as datetime)
set @endInvDt = cast('8/30/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200809'
set @begInvDt = cast('8/31/2008' as datetime)
set @endInvDt = cast('9/27/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200810'
set @begInvDt = cast('9/28/2008' as datetime)
set @endInvDt = cast('11/1/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200811'
set @begInvDt = cast('11/2/2008' as datetime)
set @endInvDt = cast('11/29/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200812'
set @begInvDt = cast('11/30/2008' as datetime)
set @endInvDt = cast('12/27/2008' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200901'
set @begInvDt = cast('12/28/2008' as datetime)
set @endInvDt = cast('1/31/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200902'
set @begInvDt = cast('2/1/2009' as datetime)
set @endInvDt = cast('2/28/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200903'
set @begInvDt = cast('3/1/2009' as datetime)
set @endInvDt = cast('3/28/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200904'
set @begInvDt = cast('3/29/2009' as datetime)
set @endInvDt = cast('5/2/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200905'
set @begInvDt = cast('5/3/2009' as datetime)
set @endInvDt = cast('5/30/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200906'
set @begInvDt = cast('5/31/2009' as datetime)
set @endInvDt = cast('6/27/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200907'
set @begInvDt = cast('6/28/2009' as datetime)
set @endInvDt = cast('8/1/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200908'
set @begInvDt = cast('8/2/2009' as datetime)
set @endInvDt = cast('8/29/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200909'
set @begInvDt = cast('8/30/2009' as datetime)
set @endInvDt = cast('9/26/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200910'
set @begInvDt = cast('9/27/2009' as datetime)
set @endInvDt = cast('10/31/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200911'
set @begInvDt = cast('11/1/2009' as datetime)
set @endInvDt = cast('11/28/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '200912'
set @begInvDt = cast('11/29/2009' as datetime)
set @endInvDt = cast('12/26/2009' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201001'
set @begInvDt = cast('12/27/2009' as datetime)
set @endInvDt = cast('1/30/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201002'
set @begInvDt = cast('1/31/2010' as datetime)
set @endInvDt = cast('2/27/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201003'
set @begInvDt = cast('2/28/2010' as datetime)
set @endInvDt = cast('3/27/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201004'
set @begInvDt = cast('3/28/2010' as datetime)
set @endInvDt = cast('5/1/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201005'
set @begInvDt = cast('5/2/2010' as datetime)
set @endInvDt = cast('5/29/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201006'
set @begInvDt = cast('5/30/2010' as datetime)
set @endInvDt = cast('6/26/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201007'
set @begInvDt = cast('6/27/2010' as datetime)
set @endInvDt = cast('7/31/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201008'
set @begInvDt = cast('8/1/2010' as datetime)
set @endInvDt = cast('8/28/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201009'
set @begInvDt = cast('8/29/2010' as datetime)
set @endInvDt = cast('9/25/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201010'
set @begInvDt = cast('9/26/2010' as datetime)
set @endInvDt = cast('10/30/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201011'
set @begInvDt = cast('10/31/2010' as datetime)
set @endInvDt = cast('11/27/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201012'
set @begInvDt = cast('11/28/2010' as datetime)
set @endInvDt = cast('12/25/2010' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo


--------------------------------------------------------------------------------------------------------

set @curPeriod = '201101'
set @begInvDt = cast('12/26/2010' as datetime)
set @endInvDt = cast('1/29/2011' as datetime)

select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod


---------------------------------------------------------------------------------------------------------

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
			GetDate() AS EntDt
	INTO	#SODetailSum
	FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
			SODetailHist SODH (NoLock)
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
	ON		SODH.ItemNo = IM.ItemNo
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
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
	ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID
	WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
			SODH.ItemNo <> '00000-0000-000' AND
			SODH.ExcludedFromUsageFlag = 1 AND
			SOHH.InvoiceDt Between @begInvDt AND @endInvDt
	GROUP BY ISNULL(SOHH.UsageLoc, SODH.IMLoc), SODH.ItemNo


	--Build tFix_ItemBranchUsage1 for Items not Currently in table for which there are Sales
	INSERT INTO	tFix_ItemBranchUsage1
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
						0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
						@userName AS EntID, GetDate() AS EntDt, NULL AS ChgID, NULL AS ChgDt, Null as StsCd 
				FROM	#SODetailSum SDS (NoLock) 
				WHERE	SDS.Period = @CurPeriod 



	UPDATE	tFix_ItemBranchUsage1
	SET		CurNRNoSales = NRCnt,
			CurNRSalesQty = NRQty,
			CurNRSalesDol = NRDol,
			CurNRSalesWght = NRWght,
			CurNRCostDol = NRCost,
			ChangeID = @userName,
			ChangeDt = GETDATE()
	FROM	#NR NR
	WHERE	tFix_ItemBranchUsage1.Location = NR.IMLoc 
			AND	tFix_ItemBranchUsage1.ItemNo = NR.ItemNo 
			AND	tFix_ItemBranchUsage1.CurPeriodNo = NR.Period

	DROP TABLE #SODetailSum
	go
	DROP TABLE #NR
	go


select count(*) from tFix_ItemBranchUsage1
where CurPeriodNo=@curPeriod

select distinct CurPeriodNo from tFix_ItemBranchUsage1
order by CurPeriodNo

select count(*) as GrandTotal from tFix_ItemBranchUsage1

