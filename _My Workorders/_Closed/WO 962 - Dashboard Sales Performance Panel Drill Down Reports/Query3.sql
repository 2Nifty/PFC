
DECLARE @@CurDay DATETIME,	--Current DashBoard Date
	@@CurPer Int,		--Current Period Number
	@@CurMthBeg DATETIME,	--Beginning Date for the Current Period
	@@CurMthEnd DATETIME,	--Ending Date for the Current Period
	@@PerDays Int		--Number of work days in the Current Period

SET @@Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @@CurPer = (SELECT FiscalPeriod FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@PerDays = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE CurrentDt >= @@CurMthBeg AND CurrentDt <= @@CurMthEnd GROUP BY FiscalPeriod)

IF (@@PerDays IS NULL) SET @@PerDays = 30
IF (@@PerDays = 0) SET @@PerDays = 30




SELECT	DISTINCT LEFT(ItemNo, 5) AS CategoryGroup, CustShipLoc AS Location, ARPostDt,
	SUM(NetUnitPrice * QtyShipped) AS TotSales,
	SUM(GrossWght * QtyShipped) AS TotWght,
	CASE SUM(GrossWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE SUM(NetUnitPrice * QtyShipped) / SUM(GrossWght * QtyShipped)
	END AS TotSalesPerLb,
	SUM(UnitCost * QtyShipped) AS TotCost,
	SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
	CASE SUM(NetUnitPrice * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
	END AS TotMgnPct,
	CASE SUM(GrossWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(GrossWght * QtyShipped)
	END AS TotMgnPerLb
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
where ARPostDt='2008-09-28' or ARPostDt='2008-10-04' or ARPostDt='2008-10-05' or 
ARPostDt='2008-10-11' or ARPostDt='2008-10-12'
GROUP BY LEFT(ItemNo, 5), CustShipLoc, ARPostDt





--Daily records by Category & Location (DashboardCatLocDaily)
SELECT	isNULL(CategoryGroup,BudgetCat) AS CategoryGroup, isNULL(Location,BudgetLoc) AS Location,
	isNULL(ARPostDt,@@CurDay) AS ARPostDate,
	isNULL(TotSales,0) AS SalesDollars, isNULL(TotWght,0) AS Lbs, isNULL(TotSalesPerLb,0) AS SalesPerLb,
	isNULL(TotCost,0) AS Cost, isNULL(TotMgn,0) AS MarginDollars, isNULL(TotMgnPct,0) AS MarginPct,
	isNULL(TotMgnPerLb,0) AS MarginPerLb, isNULL(TotMgn - (BudgetExp / @@PerDays),0) AS Profit,
	isNULL(BudgetLbs / @@PerDays,0) AS BudgetLbs,
	isNULL(BudgetSales / @@PerDays,0) AS BudgetSales,
	isNULL(BudgetMgn / @@PerDays,0) AS BudgetMargin, 
	CASE isNULL(BudgetSales / @@PerDays,0)
	   WHEN 0 THEN 0
		  ELSE isNULL(BudgetMgn / @@PerDays,0) / isNULL(BudgetSales / @@PerDays,0)
	END AS BudgetMarginPct,
	isNULL(BudgetExp / @@PerDays,0) AS BudgetExp, 'NVLUNIGHT' AS EntryID, GETDATE() AS EntryDt
FROM
(SELECT	DISTINCT LEFT(ItemNo, 5) AS CategoryGroup, CustShipLoc AS Location, ARPostDt,
	SUM(NetUnitPrice * QtyShipped) AS TotSales,
	SUM(GrossWght * QtyShipped) AS TotWght,
	CASE SUM(GrossWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE SUM(NetUnitPrice * QtyShipped) / SUM(GrossWght * QtyShipped)
	END AS TotSalesPerLb,
	SUM(UnitCost * QtyShipped) AS TotCost,
	SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
	CASE SUM(NetUnitPrice * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
	END AS TotMgnPct,
	CASE SUM(GrossWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(GrossWght * QtyShipped)
	END AS TotMgnPerLb
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	ARPostDt = @@CurDay
--WHERE	ARPostDt >= @@CurMthBeg
GROUP BY LEFT(ItemNo, 5), CustShipLoc, ARPostDt) Sales
FULL OUTER JOIN
(SELECT	CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(Lbs) AS BudgetLbs,
	SUM(SalesDollars) AS BudgetSales, SUM(MarginDollars) AS BudgetMgn, SUM(Expense) AS BudgetExp
 FROM	CustomerCatBudget
 WHERE FiscalPeriod = @@CurPer
 GROUP BY CategoryGroup, Location) Budget
ON	CategoryGroup = BudgetCat AND Location = BudgetLoc
ORDER BY CategoryGroup, Location



SELECT	SUM(Lbs) AS BudgetLbs,
	SUM(SalesDollars) AS BudgetSales, SUM(MarginDollars) AS BudgetMgn, SUM(Expense) AS BudgetExp
 FROM	CustomerCatBudget
 WHERE FiscalPeriod = 2
