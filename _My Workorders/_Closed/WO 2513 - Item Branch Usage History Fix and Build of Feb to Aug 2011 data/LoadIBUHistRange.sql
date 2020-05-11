------------------------
--LoadIBUHistRange.sql--
------------------------

--truncate table ItemBranchUsageHist

DECLARE @begInvDt DATETIME
DECLARE @endInvDT DATETIME
DECLARE @curPeriod INT

DECLARE @userName VARCHAR(50)
SET @userName = 'WO2513_IBUHist_Fix' --'WO2306_InitialLoad'
				

--build CURSOR of valid periods to be built
declare c1 cursor read_only for
SELECT	DISTINCT
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) AS curPeriod,
		CurFiscalMthBeginDt as begInvDT,
		CurFiscalMthEndDt as endInvDT
FROM	FiscalCalendar Per
--Set the Begin & End Periods to be posted
WHERE	RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) >= '201102' AND
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) <= '201108'
ORDER BY RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2)

--open the cursor
open c1
fetch next from c1
into @curPeriod, @begInvDt, @endInvDt

WHILE @@FETCH_STATUS = 0

BEGIN

	--select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt

	--Clear Posting Period
	DELETE FROM ItemBranchUsageHist WHERE CurPeriodNo = @curPeriod

	---------------------------------------------------------------------------------------------------------

		--Summarize SODetail History (Sales & NR)
		SELECT	ISNULL(SOHH.UsageLoc, SODH.IMLoc) AS IMLoc,
				SODH.ItemNo,
				@CurPeriod AS Period,
				Count(*) AS SlsCnt,
				SUM(SODH.QtyShipped) AS SlsQty,
				SUM(round(SODH.NetUnitPrice,2) * round(SODH.QtyShipped,2)) AS SlsDol,
				SUM(round(SODH.UnitCost,2) * round(SODH.QtyShipped,2)) AS SlsCost,
				SUM(round(IM.Wght,4) * round(SODH.QtyShipped,4)) AS SlsWght,
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
				SUM(round(SODH.NetUnitPrice,2) * round(SODH.QtyShipped,2)) AS NRDol,
				SUM(round(SODH.UnitCost,2) * round(SODH.QtyShipped,2)) AS NRCost,
				SUM(round(IM.Wght,4) * round(SODH.QtyShipped,4)) AS NRWght
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
							0 AS NRUse, 0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
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

---------------------------------------------------------------------------------------------------------

--SUMMARY ANALYSIS

select	tPer.*,
		tIBU.PerRecCount,
		
		tIBU.CurNoofSales as IBU_NoOfSales,
		tSales.NoofSales as Hist_NoOfSales,

		tIBU.CurSalesQty as IBU_SalesQty,
		tSales.SalesQty as Hist_SalesQty,

		tIBU.CurSalesDol as IBU_SalesDol,
		tSales.SalesDol as Hist_SalesDol,

		tIBU.CurSalesWght as IBU_SalesWght,
		tSales.SalesWght as Hist_SalesWght,

		tIBU.CurCostDol as IBU_CostDol,
		tSales.CostDol as Hist_CostDol,

		tIBU.CurNRNoSales as IBU_NRNoSales,
		tNR.NRNoSales as Hist_NRNoSales,

		tIBU.CurNRSalesQty as IBU_NRSalesQty,
		tNR.NRSalesQty as Hist_NRSalesQty,

		tIBU.CurNRSalesDol as IBU_NRSalesDol,
		tNR.NRSalesDol as Hist_NRSalesDol,

		tIBU.CurNRSalesWght as IBU_NRSalesWght,
		tNR.NRSalesWght as Hist_NRSalesWght,

		tIBU.CurNRCostDol as IBU_NRCostDol,
		tNR.NRCostDol as Hist_NRCostDol

from

(select @curPeriod as CurPeriod, @begInvDt as BegDt, @endInvDt as EndDt) tPer,

--IBU Summary for the period
(select	Count(*) as PerRecCount, SUM(CurNoofSales) as CurNoofSales, round(sum(CurSalesQty),2) as CurSalesQty,
		sum(CurSalesDol) as CurSalesDol, sum(CurSalesWght) as CurSalesWght,
		sum(CurCostDol) as CurCostDol,
		SUM(CurNRNoSales) as CurNRNoSales, sum(CurNRSalesQty) as CurNRSalesQty,
		round(sum(CurNRSalesDol),2) as CurNRSalesDol, round(sum(CurNRSalesWght),4) as CurNRSalesWght,
		round(sum(CurNRCostDol),2) as CurNRCostDol
from	ItemBranchUsageHist
where	CurPeriodNo=@curPeriod) tIBU,


--SOHist Summary for the period
		(SELECT		Count(*) AS NoofSales,
				SUM(SODH.QtyShipped) AS SalesQty,
				round((SUM(round(SODH.NetUnitPrice,2) * round(SODH.QtyShipped,2))),2) AS SalesDol,
				round((SUM(round(IM.Wght,4) * round(SODH.QtyShipped,4))),4) AS SalesWght,
				round((SUM(round(SODH.UnitCost,2) * round(SODH.QtyShipped,2))),2) AS CostDol
		FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
				SODetailHist SODH (NoLock)
		ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
				ItemMaster IM (NoLock)
		ON		SODH.ItemNo = IM.ItemNo
		WHERE 	(SOHH.SubType <= '50' OR SOHH.SubType = '53' OR SOHH.SubType = '54') AND
				ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
				SODH.ItemNo <> '00000-0000-000' AND
				CAST (FLOOR (CAST (SOHH.ARPostDt AS FLOAT)) AS DATETIME) Between @begInvDt AND @endInvDt) tsales,


		(SELECT		Count(*) AS NRNoSales,
				SUM(SODH.QtyShipped) AS NRSalesQty,
				round((SUM(round(SODH.NetUnitPrice,2) * round(SODH.QtyShipped,2))),2) AS NRSalesDol,
				round((SUM(round(IM.Wght,4) * round(SODH.QtyShipped,4))),4) AS NRSalesWght,
				round((SUM(round(SODH.UnitCost,2) * round(SODH.QtyShipped,2))),2) AS NRCostDol
		FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
				SODetailHist SODH (NoLock)
		ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
				ItemMaster IM (NoLock)
		ON		SODH.ItemNo = IM.ItemNo
		WHERE 	(SOHH.SubType <= '50' OR SOHH.SubType = '53' OR SOHH.SubType = '54') AND
				ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
				SODH.ItemNo <> '00000-0000-000' AND
				SODH.ExcludedFromUsageFlag = 1 AND
				CAST (FLOOR (CAST (SOHH.ARPostDt AS FLOAT)) AS DATETIME) Between @begInvDt AND @endInvDt) tNR

---------------------------------------------------------------------------------------------------------

fetch next from c1
into @curPeriod, @begInvDt, @endInvDt
END;
CLOSE c1;
DEALLOCATE c1;

	select CurPeriodNo, count(*) as RecCount from ItemBranchUsageHist
	group by CurPeriodNo
	order by CurPeriodNo

	select count(*) as GrandTot from ItemBranchUsageHist