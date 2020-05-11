
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pDashboardDrilldownDaily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pDashboardDrilldownDaily]
GO

CREATE procedure [dbo].[pDashboardDrilldownDaily]
@Loc varchar(50)
as

----pDashboardDrilldownDaily
----Written By: Tod Dixon
----Application: Sales Management

DECLARE @CurDay DATETIME	--Current DashBoard Date
DECLARE @CurEndDay DATETIME	--Current DashBoard End Date

SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')


--Current Day By Category & Location
IF @Loc = '00'
   BEGIN
	SELECT	CategoryGroup, SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPerLb, MarginPct * 100 AS MarginPct,
		MarginDollars - (BudgetExp + (SalesDollars * .1)) AS Profit, BudgetLbs, BudgetSales, BudgetMargin, 
		CASE BudgetSales
		   WHEN 0 THEN 0
			  ELSE (BudgetMargin / BudgetSales) * 100
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
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, SUM(BudgetLbs) AS BudgetLbs, SUM(BudgetSales) AS BudgetSales,
		SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
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
	 WHERE	(ARPostDt = @CurDay or ARPostDt = @CurEndDay) AND Location = @Loc
	 GROUP BY CategoryGroup) Dashboard
	INNER JOIN
	(SELECT	DISTINCT CategoryGroup AS BudgetCat, Location AS BudgetLoc, SUM(BudgetLbs) AS BudgetLbs,
		SUM(BudgetSales) AS BudgetSales, SUM(BudgetMargin) AS BudgetMargin, SUM(BudgetExp) AS BudgetExp
	 FROM	DashboardCatLocDaily
	 WHERE (ARPostDt = @CurDay or ARPostDt = @CurEndDay) AND Location = @Loc
	 GROUP BY CategoryGroup, Location) Budget
	ON CategoryGroup = BudgetCat
   END
go