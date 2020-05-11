USE [PFCReports]
GO

DECLARE	@CurEndDay	DATETIME,	--Current DashBoard End Date
		@CurPer		INT,		--Current Period Number
		@CurMthBeg	DATETIME,	--Beginning Date for the Current Period
		@CurMthEnd	DATETIME,	--Ending Date for the Current Period
		@PerDays	INT,		--Number of work days in the Current Period
		@DateCount	INT,
		@LoopCount	INT,
		@Date		DATETIME

--SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = '6/16/2012'
SET @CurPer = (SELECT FiscalPeriod FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @PerDays = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE CurrentDt >= @CurMthBeg AND CurrentDt <= @CurMthEnd GROUP BY FiscalPeriod)

IF (@PerDays IS NULL) SET @PerDays = 30
IF (@PerDays = 0) SET @PerDays = 30

select @CurPer as CurPer, @PerDays as PerDays, @CurMthBeg as CurMthBeg, @CurEndDay as CurEndDay , @CurMthEnd as CurMthEnd



SELECT	isNULL(tSales.CategoryGroup, tBudget.BudgetCat) AS CategoryGroup,
		isNULL(tSales.Location, tBudget.BudgetLoc) AS Location,
		tSales.ARPostDt,
		isNULL(tSales.TotSales,0) AS SalesDollars,
		isNULL(tSales.TotWght,0) AS Lbs,
		isNULL(tSales.TotSalesPerLb,0) AS SalesPerLb,
		isNULL(tSales.TotCost,0) AS Cost,
		isNULL(tSales.TotMgn,0) AS MarginDollars,
		isNULL(tSales.TotMgnPct,0) AS MarginPct,
		isNULL(tSales.TotMgnPerLb,0) AS MarginPerLb,
		isNULL(tSales.TotMgn - (BudgetExp / @PerDays),0) AS Profit,
		isNULL(tBudget.BudgetLbs / @PerDays,0) AS BudgetLbs,
		isNULL(tBudget.BudgetSales / @PerDays,0) AS BudgetSales,
		isNULL(tBudget.BudgetMgn / @PerDays,0) AS BudgetMargin, 
		CASE isNULL(tBudget.BudgetSales / @PerDays,0)
				WHEN 0 THEN 0
				ELSE isNULL(tBudget.BudgetMgn / @PerDays,0) / isNULL(tBudget.BudgetSales / @PerDays,0)
		END AS BudgetMarginPct,
		isNULL(tBudget.BudgetExp / @PerDays,0) AS BudgetExp,
		'NVLUNIGHT' AS EntryID,
		GETDATE() AS EntryDt
into #tDashboardCatLocDaily
FROM
(	--tSales
	SELECT	DISTINCT
			LEFT(Dtl.ItemNo, 5) AS CategoryGroup,
			isNULL(CM.CustShipLocation, Hdr.CustShipLoc) AS Location,
			Hdr.ARPostDt,
			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS TotSales,
			SUM(Dtl.GrossWght * Dtl.QtyShipped) AS TotWght,
			CASE SUM(Dtl.GrossWght * Dtl.QtyShipped)
					WHEN 0 THEN 0
					ELSE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) / SUM(Dtl.GrossWght * Dtl.QtyShipped)
			END AS TotSalesPerLb,
			SUM(Dtl.UnitCost * Dtl.QtyShipped) AS TotCost,
			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped) AS TotMgn,
			CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
					WHEN 0 THEN 0
					ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
			END AS TotMgnPct,
			CASE SUM(Dtl.GrossWght * Dtl.QtyShipped)
					WHEN 0 THEN 0
					ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.GrossWght * Dtl.QtyShipped)
			END AS TotMgnPerLb
	FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
	ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			CustomerMaster CM (NoLock)
	ON		Hdr.SellToCustNo = CM.CustNo
	WHERE	Hdr.ARPostDt between @CurMthBeg and @CurEndDay
			And ISNULL(Hdr.DeleteDt,'') = ''
	GROUP BY LEFT(Dtl.ItemNo, 5), isNULL(CM.CustShipLocation, Hdr.CustShipLoc), Hdr.ARPostDt
)	tSales

FULL OUTER JOIN

(	--tBudget
	SELECT	CCBudget.CategoryGroup AS BudgetCat,
			CCBudget.Location AS BudgetLoc,
			SUM(CCBudget.Lbs) AS BudgetLbs,
			SUM(CCBudget.SalesDollars) AS BudgetSales,
			SUM(CCBudget.MarginDollars) AS BudgetMgn,
			SUM(CCBudget.Expense) AS BudgetExp
	FROM	CustomerCatBudget CCBudget (NoLock)
	WHERE	CCBudget.FiscalPeriod = @CurPer
	GROUP BY CCBudget.CategoryGroup, CCBudget.Location
)	tBudget
ON	tSales.CategoryGroup = tBudget.BudgetCat AND tSales.Location = tBudget.BudgetLoc
ORDER BY CategoryGroup, Location

UPDATE	#tDashboardCatLocDaily
SET		BudgetLbs = 0,
		BudgetSales = 0,
		BudgetMargin = 0,
		BudgetExp = 0
FROM	#tDashboardCatLocDaily INNER JOIN
		FiscalCalendar
ON		CurrentDt = ARPostDt
WHERE	WorkDay = 0

select * from #tDashboardCatLocDaily


------------------------------------------------------------------------

DECLARE @CurDay DATETIME	--Current DashBoard Date
DECLARE @CurEndDay DATETIME	--Current DashBoard End Date

SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')

SET @CurDay = '6/15/2012'
SET @CurEndDay = '6/16/2012'


select @CurDay as CurDay, @CurEndDay as CurEndDay


--Current Day By Category & Location

select sum(SalesDollars) as Sales
from
(
	SELECT	CategoryGroup, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct * 100 AS MarginPct,
		--CSR 08/30/10: Removed 10% adder [+ (SalesDollars * .1)]
		MarginDollars - BudgetExp AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE (BudgetMargin / BudgetSales) * 100
		END AS BudgetMarginPct,
		--CSR 08/30/10: Removed 10% adder (SalesDollars * .1)
		BudgetExp AS BudgetExp
	FROM 
	(
SELECT	CategoryGroup, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
		CASE SUM(LBS)
		   WHEN 0 THEN 0
			  ELSE SUM(SalesDollars) / SUM(Lbs)
		END AS SalesPerLb,
		SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
		CASE SUM(LBS)
		   WHEN 0 THEN 0
			  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
		END AS MarginPerLb,
		CASE SUM(SalesDollars)
		   WHEN 0 THEN 0
			  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)
		END AS MarginPct
	 FROM	#tDashboardCatLocDaily
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
	 GROUP BY CategoryGroup
) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	#tDashboardCatLocDaily
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
	 GROUP BY CategoryGroup) Budget
	ON CategoryGroup = BudgetCat
) tmp
