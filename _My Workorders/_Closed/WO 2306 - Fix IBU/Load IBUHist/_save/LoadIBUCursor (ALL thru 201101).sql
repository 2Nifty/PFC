
--truncate table tFix_ItemBranchUsage1

DECLARE @begInvDt DATETIME
DECLARE @endInvDT DATETIME
DECLARE @curPeriod INT

declare c1 cursor read_only for
SELECT	DISTINCT
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) AS curPeriod,
		CurFiscalMthBeginDt as begInvDT,
		CurFiscalMthEndDt as endInvDT
FROM	FiscalCalendar Per
WHERE	RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) >= '200709' AND
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) <= '201101'
ORDER BY RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2)


open c1
fetch next from c1
into @curPeriod, @begInvDt, @endInvDt

WHILE @@FETCH_STATUS = 0

BEGIN

	DECLARE @userName VARCHAR(50)
	SET @userName = 'WO2306_FixIBU_InitialLoad'

	--set @curPeriod = '201101'
	--set @begInvDt = cast('12/26/2010' as datetime)
	--set @endInvDt = cast('01/29/2011' as datetime)

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
				ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
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
				ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
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
		DROP TABLE #NR


	select count(*) from tFix_ItemBranchUsage1
	where CurPeriodNo=@curPeriod

fetch next from c1
into @curPeriod, @begInvDt, @endInvDt
END;
CLOSE c1;
DEALLOCATE c1;

	select CurPeriodNo, count(*) as RecCount from tFix_ItemBranchUsage1
	group by CurPeriodNo
	order by CurPeriodNo

	select count(*) as GrandTot from tFix_ItemBranchUsage1