exec pDashboardDrilldownDaily '02'
exec pDashboardDrilldownMTD '02'

--select * from DashboardCatLocDaily order by ARPostDt
--truncate table DashboardCatLocDaily


----------------------------------------------------------------------------------------------

DECLARE --@CurDay DATETIME,	--Current DashBoard Date
	@CurEndDay DATETIME,	--Current DashBoard Date
--	@CurPer Int,		--Current Period Number
	@CurMthBeg DATETIME	--Beginning Date for the Current Period
--	@CurMthEnd DATETIME,	--Ending Date for the Current Period
--	@PerDays Int,		--Number of work days in the Current Period
--	@DaysMTD Int		--Number of work days to date in the Current Period


--SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
--SET @CurPer = (SELECT FiscalPeriod FROM FiscalCalendar WHERE CurrentDt = @CurDay)
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
--SET @CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
--SET @PerDays = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE CurrentDt >= @CurMthBeg AND CurrentDt <= @CurMthEnd GROUP BY FiscalPeriod)
--SET @DaysMTD = (SELECT SUM(WorkDay) FROM FiscalCalendar WHERE FiscalPeriod=@CurPer AND CurrentDt >= @CurMthBeg AND CurrentDt <= @CurDay GROUP BY FiscalPeriod)

--IF (@PerDays IS NULL) SET @PerDays = 30
--IF (@PerDays = 0) SET @PerDays = 30

--IF (@DaysMTD IS NULL) SET @DaysMTD = 1
--IF (@DaysMTD = 0) SET @DaysMTD = 1
--select @DaysMTD


--SELECT	DISTINCT ARPostDt, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
--		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
--	 FROM	DashboardCatLocDaily
--	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurDay
--	group by ARPostDt


--delete from DashboardCatLocDaily where ARPostDt='2008-09-28' or ARPostDt='2008-10-04' or ARPostDt='2008-10-05' or 
--ARPostDt='2008-10-11' or ARPostDt='2008-10-12'

--Select @Curday AS CurDay, @CurPer AS CurPer, @CurMthBeg AS MthBeg, @CurMthEnd AS MthEnd, @PerDays AS PerDays, @DaysMTD AS DaysMTD



	SELECT	CategoryGroup, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct,
		MarginDollars - (BudgetExp + (SalesDollars * .1)) AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE BudgetMargin / BudgetSales
		END AS BudgetMarginPct,
		BudgetExp + (SalesDollars * .1) AS BudgetExp
	FROM 
	(SELECT	CategoryGroup, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay
	 GROUP BY CategoryGroup) Budget
	ON CategoryGroup = BudgetCat



--MTD By Category & Location
IF @Loc = '00'
   BEGIN
	SELECT	CategoryGroup, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct,
		MarginDollars - (BudgetExp + (SalesDollars * .1)) AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE BudgetMargin / BudgetSales
		END AS BudgetMarginPct,
		BudgetExp + (SalesDollars * .1) AS BudgetExp
	FROM 
	(SELECT	CategoryGroup, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay
	 GROUP BY CategoryGroup) Budget
	ON CategoryGroup = BudgetCat
   END
ELSE
   BEGIN
	SELECT	CategoryGroup, BudgetLoc, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct,
		MarginDollars - (BudgetExp + (SalesDollars * .1)) AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE BudgetMargin / BudgetSales
		END AS BudgetMarginPct,
		BudgetExp + (SalesDollars * .1) AS BudgetExp
	FROM 
	(SELECT	CategoryGroup, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay AND Location = '02'  --@Loc
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(BudgetLbs) AS BudgetLbs,
		SUM(BudgetSales) AS BudgetSales, SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay AND Location = '02'  --@Loc
	 GROUP BY CategoryGroup, Location) Budget
	ON CategoryGroup = BudgetCat
   END