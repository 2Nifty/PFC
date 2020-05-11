--select TD_GMPerLb,TD_GrossmarginDollar, TDBrnExpBud, TD_GrossmarginDollar - TDBrnExpBud as profit,* from Dashboard_Branch
--where Loc_No='15'


--exec pDashboardDrilldownDaily '15'





DECLARE @Loc varchar(50)

DECLARE @CurDay DATETIME	--Current DashBoard Date
DECLARE @CurEndDay DATETIME	--Current DashBoard End Date


SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')

SET @Loc = '15'
select @CurDay, @CurEndDay, @Loc

	SELECT	BudgetExp, CategoryGroup, BudgetLoc, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct,
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
	 WHERE	(ARPostDt = @CurDay or ARPostDt = @CurEndDay) AND Location = @Loc
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(BudgetLbs) AS BudgetLbs,
		SUM(BudgetSales) AS BudgetSales, SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE (ARPostDt = @CurDay or ARPostDt = @CurEndDay) AND Location = @Loc
	 GROUP BY CategoryGroup, Location) Budget
	ON CategoryGroup = BudgetCat




SELECT	DISTINCT CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(BudgetLbs) AS BudgetLbs,
		SUM(BudgetSales) AS BudgetSales, SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE (ARPostDt = @CurDay or ARPostDt = @CurEndDay) AND Location = @Loc
	 GROUP BY CategoryGroup, Location


