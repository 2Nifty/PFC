

declare @BegDt DATETIME
declare @EndDt DATETIME
declare @CurMthBeg DATETIME

set @BegDt = '6/15/2012'
set @EndDt = '6/16/2012'
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @EndDt)

select @CurMthBeg as BegMthDt, @BegDt as BegDayDt, @EndDt as EndDayDt

--
--	SELECT	DISTINCT
--			LEFT(Dtl.ItemNo, 5) AS CategoryGroup,
--			isNULL(CM.CustShipLocation, Hdr.CustShipLoc) AS Location,
--			Hdr.ARPostDt,
--			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS TotSales,
--			SUM(Dtl.GrossWght * Dtl.QtyShipped) AS TotWght,
--			CASE SUM(Dtl.GrossWght * Dtl.QtyShipped)
--					WHEN 0 THEN 0
--					ELSE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) / SUM(Dtl.GrossWght * Dtl.QtyShipped)
--			END AS TotSalesPerLb,
--			SUM(Dtl.UnitCost * Dtl.QtyShipped) AS TotCost,
--			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped) AS TotMgn,
--			CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
--					WHEN 0 THEN 0
--					ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
--			END AS TotMgnPct,
--			CASE SUM(Dtl.GrossWght * Dtl.QtyShipped)
--					WHEN 0 THEN 0
--					ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.GrossWght * Dtl.QtyShipped)
--			END AS TotMgnPerLb
--into #tDashboardCatLocDaily
--	FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
--			SODetailHist Dtl (NoLock)
--	ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
--			CustomerMaster CM (NoLock)
--	ON		Hdr.SellToCustNo = CM.CustNo
--	WHERE	Hdr.ARPostDt between @CurMthBeg and @EndDt
--			And ISNULL(Hdr.DeleteDt,'') = ''
--	GROUP BY LEFT(Dtl.ItemNo, 5), isNULL(CM.CustShipLocation, Hdr.CustShipLoc), Hdr.ARPostDt
--
--select * from #tDashboardCatLocDaily

select sum(SalesDollars) 
from
(
SELECT	CategoryGroup, SUM(TotSales) AS SalesDollars, SUM(TotWght) AS Lbs,
		CASE SUM(TotWght)
		   WHEN 0 THEN 0
			  ELSE SUM(TotSales) / SUM(TotWght)
		END AS SalesPerLb,
		SUM(TotSales) - SUM(TotCost) AS MarginDollars,
		CASE SUM(TotWght)
		   WHEN 0 THEN 0
			  ELSE (SUM(TotSales) - SUM(TotCost)) / SUM(TotWght)
		END AS MarginPerLb,
		CASE SUM(TotSales)
		   WHEN 0 THEN 0
			  ELSE (SUM(TotSales) - SUM(TotCost)) / SUM(TotSales)
		END AS MarginPct
	 FROM	#tDashboardCatLocDaily
	 WHERE	ARPostDt = @BegDt or ARPostDt = @EndDt
	 GROUP BY CategoryGroup
) tmp



--SELECT	DISTINCT CategoryGroup AS BudgetCat, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
--		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
--	 FROM	#tDashboardCatLocDaily
--	 WHERE	ARPostDt = @BegDt or ARPostDt = @EndDt
--	 GROUP BY CategoryGroup