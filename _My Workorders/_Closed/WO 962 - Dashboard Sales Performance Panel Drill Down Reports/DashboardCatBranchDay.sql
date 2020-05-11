
DECLARE @@CurDay DATETIME,	--Current DashBoard Date
	@@CurPer Int,		--Current Period Number
	@@CurMthBeg DATETIME,	--Beginning Date for the Current Period
	@@CurMthEnd DATETIME,	--Ending Date for the Current Period
	@@PerDays Int,		--Number of work days in the Current Period
	@@DaysMTD Int		--Number of work days to date in the Current Period


SET @@Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @@CurPer = (SELECT FiscalPeriod FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @@CurDay)
SET @@PerDays = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE CurrentDt >= @@CurMthBeg AND CurrentDt <= @@CurMthEnd GROUP BY FiscalPeriod)
SET @@DaysMTD = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE FiscalPeriod=@@CurPer AND CurrentDt >= @@CurMthBeg AND CurrentDt <= @@CurDay GROUP BY FiscalPeriod)

IF (@@PerDays IS NULL) SET @@PerDays = 30
IF (@@PerDays = 0) SET @@PerDays = 30

IF (@@DaysMTD IS NULL) SET @@DaysMTD = 1
IF (@@DaysMTD = 0) SET @@DaysMTD = 1


--Select @@Curday, @@CurPer, @@CurMthBeg, @@CurMthEnd, @@PerDays, @@DaysMTD




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


--Daily records by Category & Location (DashboardCatLocDaily)
SELECT	CategoryGroup, Location, ARPostDt,
	TotSales AS SalesDollars, TotWght AS Lbs, TotSalesPerLb AS SalesPerLb, TotCost AS Cost,
	TotMgn AS MarginDollars, TotMgnPct AS MarginPct, TotMgnPerLb AS MarginPerLb, TotMgn - (BudgetExp / @@PerDays) AS Profit,
	isNULL(BudgetLbs / @@PerDays,0) AS BudgetLbs,
	isNULL(BudgetSales / @@PerDays,0) AS BudgetSales,
	isNULL(BudgetMgn / @@PerDays,0) AS BudgetMgn, 
	CASE isNULL(BudgetSales / @@PerDays,0)
	   WHEN 0 THEN 0
		  ELSE isNULL(BudgetMgn / @@PerDays,0) / isNULL(BudgetSales / @@PerDays,0)
	END AS BudgetMgnPct,
	isNULL(BudgetExp / @@PerDays,0) AS BudgetExp, 'NVLUNIGHT' AS EntryID, GETDATE() AS EntryDt
--INTO DashboardCatLocDaily
FROM
(SELECT	DISTINCT LEFT(ItemNo, 5) AS CategoryGroup, CustShipLoc AS Location, ARPostDt,
	SUM(NetUnitPrice * QtyShipped) AS TotSales,
	SUM(NetWght * QtyShipped) AS TotWght,
	CASE SUM(NetWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE SUM(NetUnitPrice * QtyShipped) / SUM(NetWght * QtyShipped)
	END AS TotSalesPerLb,
	SUM(UnitCost * QtyShipped) AS TotCost,
	SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
	CASE SUM(NetUnitPrice * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
	END AS TotMgnPct,
	CASE SUM(NetWght * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetWght * QtyShipped)
	END AS TotMgnPerLb
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	ItemNo <> '00000-0000-000' AND ARPostDt = @@CurDay
GROUP BY LEFT(ItemNo, 5), CustShipLoc, ARPostDt) Sales
LEFT OUTER JOIN
(SELECT	CategoryGroup AS BudgetCat, SUM(Lbs) AS BudgetLbs, SUM(SalesDollars) AS BudgetSales,
	SUM(MarginDollars) AS BudgetMgn, SUM(Expense) AS BudgetExp
 FROM	CustomerCatBudget
 WHERE FiscalPeriod = @@CurPer
 GROUP BY CategoryGroup) Budget
ON	CategoryGroup = BudgetCat
ORDER BY CategoryGroup, Location






--select * from CustomerCatBudget WHERE 	Period = 200809 order by CategoryGroup, Location, Period


