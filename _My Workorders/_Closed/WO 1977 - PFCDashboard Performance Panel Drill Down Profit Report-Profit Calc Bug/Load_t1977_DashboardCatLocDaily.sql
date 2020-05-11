
truncate table t1977_DashboardCatLocDaily

DECLARE	@CurEndDay	DATETIME,	--Current DashBoard End Date
	@CurPer		INT,		--Current Period Number
	@CurMthBeg	DATETIME,	--Beginning Date for the Current Period
	@CurMthEnd	DATETIME,	--Ending Date for the Current Period
	@PerDays	INT,		--Number of work days in the Current Period
	@DateCount	INT,
	@LoopCount	INT,
	@Date		DATETIME

SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurPer = (SELECT FiscalPeriod FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @PerDays = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE CurrentDt >= @CurMthBeg AND CurrentDt <= @CurMthEnd GROUP BY FiscalPeriod)

IF (@PerDays IS NULL) SET @PerDays = 30
IF (@PerDays = 0) SET @PerDays = 30
select @PerDays


--DECLARE	@tDashboardCatLocDates TABLE (id INT identity(1,1) , CurDate DATETIME) 

--INSERT	@tDashboardCatLocDates(CurDate)
--SELECT	CurrentDt
--FROM	FiscalCalendar
--WHERE	CurrentDt> = @CurMthBeg and CurrentDt <= @CurEndDay
--ORDER BY CurrentDt


--SET @LoopCount=1
--SET @DateCount = (SELECT COUNT(*) FROM @tDashboardCatLocDates)

--WHILE (@LoopCount <= @DateCount)
 --  BEGIN
--	SET @Date = (SELECT [CurDate] FROM @tDashboardCatLocDates WHERE id=@LoopCount)
	SET @Date = @CurEndDay

	--Daily records by Category & Location (t1977_DashboardCatLocDaily)
	INSERT	t1977_DashboardCatLocDaily(CategoryGroup, Location, ARPostDt, SalesDollars, Lbs, SalesPerLb, Cost, MarginDollars, MarginPct, MarginPerLb,
					Profit, BudgetLbs, BudgetSales, BudgetMargin, BudgetMarginPct, BudgetExp, EntryID, EntryDt)
	SELECT	isNULL(CategoryGroup,BudgetCat) AS CategoryGroup, isNULL(Location,BudgetLoc) AS Location,
		isNULL(ARPostDt,@Date) AS ARPostDate,
		isNULL(TotSales,0) AS SalesDollars, isNULL(TotWght,0) AS Lbs, isNULL(TotSalesPerLb,0) AS SalesPerLb,
		isNULL(TotCost,0) AS Cost, isNULL(TotMgn,0) AS MarginDollars, isNULL(TotMgnPct,0) AS MarginPct,
		isNULL(TotMgnPerLb,0) AS MarginPerLb, isNULL(TotMgn - (BudgetExp / @PerDays),0) AS Profit,
		isNULL(BudgetLbs / @PerDays,0) AS BudgetLbs,
		isNULL(BudgetSales / @PerDays,0) AS BudgetSales,
		isNULL(BudgetMgn / @PerDays,0) AS BudgetMargin, 
		CASE isNULL(BudgetSales / @PerDays,0)
		   WHEN 0 THEN 0
			  ELSE isNULL(BudgetMgn / @PerDays,0) / isNULL(BudgetSales / @PerDays,0)
		END AS BudgetMarginPct,
		isNULL(BudgetExp / @PerDays,0) AS BudgetExp, 'NVLUNIGHT' AS EntryID, GETDATE() AS EntryDt
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
	WHERE	ARPostDt = @Date
	GROUP BY LEFT(ItemNo, 5), CustShipLoc, ARPostDt) Sales
	FULL OUTER JOIN
	(SELECT	CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(Lbs) AS BudgetLbs,
		SUM(SalesDollars) AS BudgetSales, SUM(MarginDollars) AS BudgetMgn, SUM(Expense) AS BudgetExp
	 FROM	CustomerCatBudget
	 WHERE FiscalPeriod = @CurPer
	 GROUP BY CategoryGroup, Location) Budget
	ON	CategoryGroup = BudgetCat AND Location = BudgetLoc
	ORDER BY CategoryGroup, Location

--	SET @LoopCount = @LoopCount + 1
-- END

UPDATE	t1977_DashboardCatLocDaily
SET	BudgetLbs = 0, BudgetSales = 0, BudgetMargin = 0, BudgetExp = 0
FROM	t1977_DashboardCatLocDaily
INNER JOIN FiscalCalendar
ON	CurrentDt=ARPostDt
WHERE	WorkDay=0




select * from t1977_DashboardCatLocDaily where Location='15'