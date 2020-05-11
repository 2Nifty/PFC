drop proc [pLoadDashboardCustSalesGoal]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================
-- Author:	Tod Dixon
-- Created:	2011-Oct-17
-- Desc:	- Runs against PFCReports
--		- UPDATE DashboardCustSalesGoal with
--		  Sales Data from SOHist based on @CurMth
-- ========================================================
CREATE PROCEDURE [dbo].[pLoadDashboardCustSalesGoal]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@CurEndDay   DATETIME	--Current DashBoard End Date
	DECLARE	@CurYearBeg  DATETIME	--Beginning Date for the Current FiscalYear

	DECLARE	@PrevMth1Beg DATETIME	--The last closed month
	DECLARE	@PrevMth1End DATETIME

	DECLARE	@PrevMth2Beg DATETIME	--One month prio to the last closed month
	DECLARE	@PrevMth2End DATETIME

	DECLARE	@PrevMth3Beg DATETIME	--Two months prior to the last closed month
	DECLARE	@PrevMth3End DATETIME

	-------------------------------------
	--  Establish Current Date Params  --
	-------------------------------------

	--@CurEndDay: Current DashBoard End Date
	SELECT	@CurEndDay = EndDate
	FROM	DashBoardRanges (NOLOCK)
	WHERE	DashBoardParameter = 'CurrentDay'

	--@CurYearBeg: Beginning Date for the Current FiscalYear
	SELECT	@CurYearBeg = BegDate
	FROM	CuvnalRanges (NOLOCK)
	WHERE	CuvnalParameter = 'CurrentYear'

	--@PrevMth1Beg & @PrevMth1Beg: The last closed month
	SELECT	@PrevMth1Beg = BegDate,
		@PrevMth1End = EndDate
	FROM	CuvnalRanges (NOLOCK)
	WHERE	CuvnalParameter = 'CurrentMonth'

	--@PrevMth2Beg & @PrevMth2Beg: One month prio to the last closed month
	SELECT	@PrevMth2Beg = BegDate,
		@PrevMth2End = EndDate
	FROM	CuvnalRanges (NOLOCK)
	WHERE	CuvnalParameter = 'PreviousMonth'

	--@PrevMth3Beg & @PrevMth3Beg: Two months prior to the last closed month
	SELECT	@PrevMth3Beg = BegDate,
		@PrevMth3End = EndDate
	FROM	CuvnalRanges (NOLOCK)
	WHERE	CuvnalParameter = 'PreviousMonth2'


--select @CurYearBeg as CurYearBeg, @CurEndDay as CurEndDay, @PrevMth1Beg as PrevMth1Beg, @PrevMth1End as PrevMth1End, @PrevMth2Beg as PrevMth2Beg, @PrevMth2End as PrevMth2End, @PrevMth3Beg as PrevMth3Beg, @PrevMth3End as PrevMth3End


-----------------------------------------------------------------
--  UPDATE DashboardCustSalesGoal with Sales Data from SOHist  --
-----------------------------------------------------------------

---YTD Sales
UPDATE	DashboardCustSalesGoal
SET	YTDSalesDol = isnull(tSales.LineSales,0),
	ChangeID = 'pLoadDashboardCustSalesGoal',
	ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
		SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales
	 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
		SODetailHist Dtl (NoLock) 
	 ON	Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
	 WHERE	(Hdr.ARPostDt between @CurYearBeg and @CurEndDay) AND ISNULL(Hdr.DeleteDt,'') = ''
	 GROUP BY Hdr.SellToCustNo) tSales
WHERE	DashboardCustSalesGoal.CustNo = tSales.CustNo

---PrevMth1 Sales
UPDATE	DashboardCustSalesGoal
SET	PrevMth1SalesDol = isnull(tSales.LineSales,0),
	PrevMth1GMPct = isnull(tSales.LineMgnPct,0),
	ChangeID = 'pLoadDashboardCustSalesGoal',
	ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
		SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
		CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		WHEN 0 THEN 0
		       ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		END AS LineMgnPct
	 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
		SODetailHist Dtl (NoLock) 
	 ON	Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
	 WHERE	(Hdr.ARPostDt between @PrevMth1Beg and @PrevMth1End) AND ISNULL(Hdr.DeleteDt,'') = ''
	 GROUP BY Hdr.SellToCustNo) tSales
WHERE	DashboardCustSalesGoal.CustNo = tSales.CustNo

---PrevMth2 Sales
UPDATE	DashboardCustSalesGoal
SET	PrevMth2SalesDol = isnull(tSales.LineSales,0),
	PrevMth2GMPct = isnull(tSales.LineMgnPct,0),
	ChangeID = 'pLoadDashboardCustSalesGoal',
	ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
		SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
		CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		WHEN 0 THEN 0
		       ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		END AS LineMgnPct
	 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
		SODetailHist Dtl (NoLock) 
	 ON	Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
	 WHERE	(Hdr.ARPostDt between @PrevMth2Beg and @PrevMth2End) AND ISNULL(Hdr.DeleteDt,'') = ''
	 GROUP BY Hdr.SellToCustNo) tSales
WHERE	DashboardCustSalesGoal.CustNo = tSales.CustNo

---PrevMth3 Sales
UPDATE	DashboardCustSalesGoal
SET	PrevMth3SalesDol = isnull(tSales.LineSales,0),
	PrevMth3GMPct = isnull(tSales.LineMgnPct,0),
	ChangeID = 'pLoadDashboardCustSalesGoal',
	ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
		SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
		CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		WHEN 0 THEN 0
		       ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		END AS LineMgnPct
	 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
		SODetailHist Dtl (NoLock) 
	 ON	Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
	 WHERE	(Hdr.ARPostDt between @PrevMth3Beg and @PrevMth3End) AND ISNULL(Hdr.DeleteDt,'') = ''
	 GROUP BY Hdr.SellToCustNo) tSales
WHERE	DashboardCustSalesGoal.CustNo = tSales.CustNo

END
GO
