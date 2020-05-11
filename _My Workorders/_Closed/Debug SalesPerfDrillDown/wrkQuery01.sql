--here is the core SO select for my CatLocDaily table (MTD)

DECLARE	@CurEndDay	DATETIME,	--Current DashBoard End Date
	@CurMthBeg	DATETIME	--Beginning Date for the Current Period


SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)

select @CurMthBeg as begdt, @CurEndDay as EndDt


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


------------------------------------------------------------------------------------------------------

--ranges filter applied in DashBoardDrillDownDaily

DECLARE @CurDay DATETIME	--Current DashBoard Date
DECLARE @CurEndDay DATETIME	--Current DashBoard End Date

SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')


select @CurDay as begdt, @CurEndDay as EndDt


select * from DashBoardRanges



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--used to build #DashBoardOrders

		
		select
			(select BegDate from DashboardRanges (NOLOCK) WHERE (DashboardParameter = 'LastMonth')) as FirstDate,
			(select EndDate from DashboardRanges (NOLOCK) WHERE (DashboardParameter = 'CurrentMonth')) as LastDate



--here is the core select for DASHBOARD_BRANCH

select 
			Orders.ADUserID,
			Orders.CustShipLoc AS Loc_No,
			CurMonth, 
			CurYear, 
			DayOfMonth, 

			(select sum(Lines.QtyShipped*Lines.NetUnitPrice) 
			from	SODetailHist Lines (NOLOCK) 
			where	Orders.pSOHeaderHistID = Lines.fSOHeaderHistID AND Isnull(DeleteDt,'') = '') as LineAmts,

			(select sum(Lines.QtyShipped*Lines.UnitCost)
			from	SODetailHist Lines (NOLOCK) 
			where	Orders.pSOHeaderHistID = Lines.fSOHeaderHistID AND Isnull(DeleteDt,'') = '') as CostAmts ,

			(select count(*) 
			from	SODetailHist Lines (NOLOCK) 
			where	Orders.pSOHeaderHistID = Lines.fSOHeaderHistID AND Isnull(DeleteDt,'') = '') as LineCounts,

			(select sum(Lines.QtyShipped * Lines.GrossWght) 
			from	SODetailHist Lines (NOLOCK) 
			where	Orders.pSOHeaderHistID = Lines.fSOHeaderHistID AND Isnull(DeleteDt,'') = '') as LineWeights

FROM 
			(select Dates.MonthValue AS CurMonth, 
				Dates.YearValue AS CurYear, *
			 FROM	#DashBoardOrders (NOLOCK) INNER JOIN
				DashboardRanges Dates (NOLOCK) ON ARPostDt >= Dates.BegDate AND ARPostDt <= Dates.EndDate
			 WHERE	(Dates.DashboardParameter = 'CurrentDay')) Orders 
			