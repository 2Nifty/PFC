

CREATE procedure [dbo].[pLoadDashboardCustInvDaily]
as

----pLoadDashboardCustInvDaily
----Written By: Tod Dixon
----Application: Sales Management

truncate table DashboardCustInvDaily

DECLARE	@CurEndDay	DATETIME,	--Current DashBoard End Date
	@CurMthBeg	DATETIME,	--Beginning Date for the Current Period
	@CurMthEnd	DATETIME,	--Ending Date for the Current Period
	@DateCount	INT,
	@LoopCount	INT,
	@Date		DATETIME

SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)
SET @CurMthEnd = (SELECT CurFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)


DECLARE	@tDashboardCustInvDates TABLE (id INT identity(1,1) , CurDate DATETIME) 

INSERT	@tDashboardCustInvDates(CurDate)
SELECT	CurrentDt
FROM	FiscalCalendar
WHERE	CurrentDt> = @CurMthBeg and CurrentDt <= @CurEndDay
ORDER BY CurrentDt


SET @LoopCount=1
SET @DateCount = (SELECT COUNT(*) FROM @tDashboardCustInvDates)

WHILE (@LoopCount <= @DateCount)
   BEGIN
	SET @Date = (SELECT [CurDate] FROM @tDashboardCustInvDates WHERE id=@LoopCount)

	--Daily records by Customer & Invoice (DashboardCustInvDaily)
	INSERT	DashboardCustInvDaily(InvoiceNo, RefSONo, CustNo, CustName, Location, ARPostDt, ItemNo, LineNumber,
		SalesDollars, Lbs, SalesPerLb, Cost, MarginDollars, MarginPct, MarginPerLb, EntryID, EntryDt)
	SELECT	InvoiceNo, OrderNo, CustNo, CustName, Location, isNULL(ARPostDt,@Date) AS ARPostDate, ItemNo, LineNumber,
		isNULL(LineSales,0) AS SalesDollars, isNULL(LineWght,0) AS Lbs, isNULL(LineSalesPerLb,0) AS SalesPerLb,
		isNULL(LineCost,0) AS Cost, isNULL(LineMgn,0) AS MarginDollars, isNULL(LineMgnPct,0) AS MarginPct,
		isNULL(LineMgnPerLb,0) AS MarginPerLb, 'NVLUNIGHT' AS EntryID, GETDATE() AS EntryDt
	FROM
	(SELECT	DISTINCT InvoiceNo, RefSONo AS OrderNo, SellToCustNo AS CustNo, SellToCustName AS CustName, CustShipLoc AS Location, ARPostDt,
			 ItemNo, LineNumber, NetUnitPrice * QtyShipped AS LineSales, GrossWght * QtyShipped AS LineWght,
			 CASE (GrossWght * QtyShipped)
			   WHEN 0 THEN 0
				  ELSE (NetUnitPrice * QtyShipped) / (GrossWght * QtyShipped)
			 END AS LineSalesPerLb,
			 UnitCost * QtyShipped AS LineCost,
			 (NetUnitPrice * QtyShipped) - (UnitCost * QtyShipped) AS LineMgn,
			 CASE (NetUnitPrice * QtyShipped)
			   WHEN 0 THEN 0
				  ELSE ((NetUnitPrice * QtyShipped) - (UnitCost * QtyShipped)) / (NetUnitPrice * QtyShipped)
			 END AS LineMgnPct,
			 CASE (GrossWght * QtyShipped)
			   WHEN 0 THEN 0
				  ELSE ((NetUnitPrice * QtyShipped) - (UnitCost * QtyShipped)) / (GrossWght * QtyShipped)
			 END AS LineMgnPerLb
	 FROM	SOHeaderHist FULL OUTER JOIN  --INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID 
	 WHERE	ARPostDt = @Date) Sales
	ORDER BY CustNo, InvoiceNo, LineNumber

	SET @LoopCount = @LoopCount + 1
   END


GO
