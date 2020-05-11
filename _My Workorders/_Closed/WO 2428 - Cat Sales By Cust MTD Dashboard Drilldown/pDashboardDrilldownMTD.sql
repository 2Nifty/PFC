

CREATE  procedure [dbo].[pDashboardDrilldownMTD]
@Loc varchar(50)
as

----pDashboardDrilldownDaily
----Written By: Tod Dixon
----Application: Sales Management
----08/30/10 CSR: Removed 10% adder per New Budget Method from Bob

DECLARE @CurEndDay DATETIME,	--Current DashBoard End Date
	@CurMthBeg DATETIME	--Beginning Date for the Current Period

SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)


--MTD By Category & Location
IF @Loc = '00'
   BEGIN
	SELECT	CategoryGroup, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct * 100 AS MarginPct,
		--CSR 08/30/10: Removed 10% adder [+ (SalesDollars * .1)]
		MarginDollars - BudgetExp  AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE (BudgetMargin / BudgetSales) * 100
		END AS BudgetMarginPct,
		--CSR 08/30/10: Removed 10% adder 
		BudgetExp AS BudgetExp
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
		--CSR 08/30/10: Removed 10% adder [+ (SalesDollars * .1)]
		MarginDollars - BudgetExp  AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE BudgetMargin / BudgetSales
		END AS BudgetMarginPct,
		--CSR 08/30/10: Removed 10% adder
		BudgetExp  AS BudgetExp
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
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay AND Location = @Loc
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(BudgetLbs) AS BudgetLbs,
		SUM(BudgetSales) AS BudgetSales, SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt >= @CurMthBeg AND ARPostDt <= @CurEndDay AND Location = @Loc
	 GROUP BY CategoryGroup, Location) Budget
	ON CategoryGroup = BudgetCat
   END


GO
