
-------------------------------------
--  Create DashboardCustSalesGoal  --
-------------------------------------

--This will be a data transformation in the DTS.

	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#DashboardCustSalesGoal')) Drop Table #DashboardCustSalesGoal

	SELECT	CM.CustNo
		,CM.CustName
		,convert(varchar(40),RM.RepNotes) as RepID
		,isnull(RM.RepName,'None Assigned') as InsideRepName
		,isnull(RM2.RepName,'None Assigned') as OutsideRepName
		-- CSR: Combine Carson with SFS for Reporting
		,Case when CM.CustShipLocation = '01' then '15' else CM.CustShipLocation end as CustShipLoc
--		,CASE WHEN CM.CreditInd = 'X' then 'Credit Hold' else 'Credit OK' end as CreditInd
		,CM.CreditInd
--		,CASE WHEN isnull(CM.DeleteDt,'')= '1900-01-01 00:00:00.000' THEN 'Open' ELSE 'Deleted' end as DeleteStatus
		,CM.DeleteDt as CustDeleteDt
		,CM.ChainCd
		,CM.PriceCd
		,CM.SalesTerritory
		,cast(0.0 as decimal(18, 6)) as MTDGoalDol
		,cast(0.0 as decimal(18, 6)) as MTDGoalGMPct
		,cast(0.0 as decimal(18, 6)) as YTDGoalDol
		,cast(0.0 as decimal(18, 6)) as YTDGoalGMPct
		,cast(0.0 as decimal(18, 6)) as YTDSalesDol
		,cast(0.0 as decimal(18, 6)) as PrevMth1SalesDol
		,cast(0.0 as decimal(18, 6)) as PrevMth1GMPct
		,cast(0.0 as decimal(18, 6)) as PrevMth2SalesDol
		,cast(0.0 as decimal(18, 6)) as PrevMth2GMPct
		,cast(0.0 as decimal(18, 6)) as PrevMth3SalesDol
		,cast(0.0 as decimal(18, 6)) as PrevMth3GMPct
		,'WO2593_LoadDashboardCustSalesGoal' as EntryID
		,CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME) as EntryDt
	FROM	CustomerMaster CM (NOLOCK) LEFT OUTER JOIN
		RepMaster RM (NOLOCK)
	ON	RM.RepNo = CM.SupportRepNo LEFT OUTER JOIN
		RepMaster RM2 (NOLOCK)
	ON	RM2.RepNo = CM.SlsRepNo

--select * from #DashboardCustSalesGoal

-----------------------------------------------------------------------------------------------------------------

	DECLARE @CurMth int;
	DECLARE @CurYr int;
	DECLARE	@TotWorkDays int;
	DECLARE	@MTDWorkDays int;

	SELECT	@CurMth = FiscalCalMonth,
			@CurYr = FiscalCalYear
	FROM	FiscalCalendar
	WHERE	CurrentDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)

	SELECT	@TotWorkDays = SUM(WorkDay)
	FROM	FiscalCalendar
	WHERE	FiscalCalMonth = @CurMth and FiscalCalYear = @CurYr

	IF (@TotWorkDays <=0) SET @TotWorkDays = 30

	SELECT	@MTDWorkDays = SUM(WorkDay)
	FROM	FiscalCalendar
	WHERE	FiscalCalMonth = @CurMth and FiscalCalYear = @CurYr and
			CurrentDt <= CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)


select @CurMth as CurrentMonth, @CurYr as CurYr, @MTDWorkDays as MTDWorkDays, @TotWorkDays as TotWorkDays

-----------------------------------------------------------------------------------------------------------------

---------------------
-- Begin Goal Data --
-----------------------------------------------------------------	
--  Get Goal Data from CustomerSalesForecast based on @CurMth  --
-----------------------------------------------------------------

--Build #MTDGoal: CustNo, MTDGoalDol, MTDGoalGMPct & MTDGoalGMDol
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#MTDGoal')) Drop Table #MTDGoal

SELECT	CSF.CustNo,
		CASE @CurMth
		   WHEN 9 THEN CSF.SepSales
		   WHEN 10 THEN CSF.OctSales
		   WHEN 11 THEN CSF.NovSales
		   WHEN 12 THEN CSF.DecSales
		   WHEN 1 THEN CSF.JanSales
		   WHEN 2 THEN CSF.FebSales
		   WHEN 3 THEN CSF.MarSales
		   WHEN 4 THEN CSF.AprSales
		   WHEN 5 THEN CSF.MaySales
		   WHEN 6 THEN CSF.JunSales
		   WHEN 7 THEN CSF.JulSales
		   WHEN 8 THEN CSF.AugSales
		END as MTDGoalDol,			--Current MTD Goal $
		CASE @CurMth
		   WHEN 9 THEN CSF.SepGMPct
		   WHEN 10 THEN CSF.OctGMPct
		   WHEN 11 THEN CSF.NovGMPct
		   WHEN 12 THEN CSF.DecGMPct
		   WHEN 1 THEN CSF.JanGMPct
		   WHEN 2 THEN CSF.FebGMPct
		   WHEN 3 THEN CSF.MarGMPct
		   WHEN 4 THEN CSF.AprGMPct
		   WHEN 5 THEN CSF.MayGMPct
		   WHEN 6 THEN CSF.JunGMPct
		   WHEN 7 THEN CSF.JulGMPct
		   WHEN 8 THEN CSF.AugGMPct
		END as MTDGoalGMPct,		--Current MTD Goal GM %
		CASE @CurMth
			WHEN 9 THEN CSF.SepSales * CSF.SepGMPct
			WHEN 10 THEN CSF.OctSales * CSF.OctGMPct
			WHEN 11 THEN CSF.NovSales * CSF.NovGMPct
			WHEN 12 THEN CSF.DecSales * CSF.DecGMPct
			WHEN 1 THEN CSF.JanSales * CSF.JanGMPct
			WHEN 2 THEN CSF.FebSales * CSF.FebGMPct
			WHEN 3 THEN CSF.MarSales * CSF.MarGMPct
			WHEN 4 THEN CSF.AprSales * CSF.AprGMPct
			WHEN 5 THEN CSF.MaySales * CSF.MayGMPct
			WHEN 6 THEN CSF.JunSales * CSF.JunGMPct
			WHEN 7 THEN CSF.JulSales * CSF.JulGMPct
			WHEN 8 THEN CSF.AugSales * CSF.AugGMPct
		END as MTDGoalGMDol			--Current MTD Goal GM $
INTO	#MTDGoal
FROM	CustomerSalesForecast CSF (NOLOCK)
WHERE	CSF.RecordType = 'F'

-----------------------------------------------------------------

--Build #CSF: CustNo, ALL Monthly Sales Goals, All Monthly GM Goal Dollars, MTDGoalDol, MTDGoalGMPct & MTDGoalGMDol
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#CSF')) Drop Table #CSF

SELECT	CSF.CustNo,
		CSF.SepSales,
		CSF.OctSales,
		CSF.NovSales,
		CSF.DecSales,
		CSF.JanSales,
		CSF.FebSales,
		CSF.MarSales,
		CSF.AprSales,
		CSF.MaySales,
		CSF.JunSales,
		CSF.JulSales,
		CSF.AugSales,
		CSF.SepSales * CSF.SepGMPct as SepGMDol,
		CSF.OctSales * CSF.OctGMPct as OctGMDol,
		CSF.NovSales * CSF.NovGMPct as NovGMDol,
		CSF.DecSales * CSF.DecGMPct as DecGMDol,
		CSF.JanSales * CSF.JanGMPct as JanGMDol,
		CSF.FebSales * CSF.FebGMPct as FebGMDol,
		CSF.MarSales * CSF.MarGMPct as MarGMDol,
		CSF.AprSales * CSF.AprGMPct as AprGMDol,
		CSF.MaySales * CSF.MayGMPct as MayGMDol,
		CSF.JunSales * CSF.JunGMPct as JunGMDol,
		CSF.JulSales * CSF.JulGMPct as JulGMDol,
		CSF.AugSales * CSF.AugGMPct as AugGMDol,
		(MTD.MTDGoalDol / @TotWorkDays) * @MTDWorkDays as MTDGoalDol,
		MTD.MTDGoalGMPct,
		(MTD.MTDGoalGMDol / @TotWorkDays) * @MTDWorkDays as MTDGoalGMDol
INTO	#CSF
FROM	#MTDGoal MTD (NOLOCK) INNER JOIN
		CustomerSalesForecast CSF (NOLOCK)
ON		MTD.CustNo = CSF.CustNo
WHERE	CSF.RecordType = 'F'

-----------------------------------------------------------------

--Build #Goals: CustNo, MTDGoalDol, MTDGoalGMPct, YTDGoalDol & YTDGoalGMDol
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#Goals')) Drop Table #Goals

SELECT	CSF.CustNo,
		CSF.MTDGoalDol,
		CSF.MTDGoalGMPct,
		CASE @CurMth
		   WHEN 9 THEN CSF.MTDGoalDol
		   WHEN 10 THEN CSF.SepSales + CSF.MTDGoalDol
		   WHEN 11 THEN CSF.SepSales + CSF.OctSales + CSF.MTDGoalDol
		   WHEN 12 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.MTDGoalDol
		   WHEN 1 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.MTDGoalDol
		   WHEN 2 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.MTDGoalDol
		   WHEN 3 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MTDGoalDol
		   WHEN 4 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.MTDGoalDol
		   WHEN 5 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MTDGoalDol
		   WHEN 6 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.MTDGoalDol
		   WHEN 7 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.MTDGoalDol
		   WHEN 8 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales + CSF.MTDGoalDol
		END as YTDGoalDol,				--Current YTD Goal $
		CASE @CurMth
		   WHEN 9 THEN CSF.MTDGoalDol
		   WHEN 10 THEN CSF.SepGMDol + CSF.MTDGoalGMDol
		   WHEN 11 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.MTDGoalGMDol
		   WHEN 12 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.MTDGoalGMDol
		   WHEN 1 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.MTDGoalGMDol
		   WHEN 2 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.MTDGoalGMDol
		   WHEN 3 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MTDGoalGMDol
		   WHEN 4 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.MTDGoalGMDol
		   WHEN 5 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MTDGoalGMDol
		   WHEN 6 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.MTDGoalGMDol
		   WHEN 7 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.JunGMDol + CSF.MTDGoalGMDol
		   WHEN 8 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.JunGMDol + CSF.JulGMDol + CSF.MTDGoalGMDol
		END as YTDGoalGMDol				--Current YTD Goal GM $
INTO	#Goals
FROM	#CSF CSF (NOLOCK)

-----------------------------------------------------------------

--UPDATE Goal Data in #DashboardCustSalesGoal
UPDATE	#DashboardCustSalesGoal
SET		MTDGoalDol = #Goals.MTDGoalDol,
		MTDGoalGMPct = #Goals.MTDGoalGMPct,
		YTDGoalDol = #Goals.YTDGoalDol,
		YTDGoalGMPct =	CASE WHEN #Goals.YTDGoalDol = 0
								THEN 0
								ELSE #Goals.YTDGoalGMDol / #Goals.YTDGoalDol
						END
FROM	#Goals
WHERE	#DashboardCustSalesGoal.CustNo = #Goals.CustNo

--DROP temp tables
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#MTDGoal')) Drop Table #MTDGoal
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#CSF')) Drop Table #CSF
IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#Goals')) Drop Table #Goals

-------------------
-- End Goal Data --
-------------------

-----------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------

	DECLARE	@CurEndDay   DATETIME	--Current DashBoard End Date
	DECLARE	@CurYearBeg  DATETIME	--Beginning Date for the Current FiscalYear

	DECLARE	@PrevMth1Beg DATETIME	--The last closed month
	DECLARE	@PrevMth1End DATETIME

	DECLARE	@PrevMth2Beg DATETIME	--One month prio to the last closed month
	DECLARE	@PrevMth2End DATETIME

	DECLARE	@PrevMth3Beg DATETIME	--Two months prior to the last closed month
	DECLARE	@PrevMth3End DATETIME


	--OpenDataSource to DashBoardParameter
	SELECT	@CurEndDay = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardRanges
	WHERE	DashBoardParameter = 'CurrentDay'

	--OpenDataSource to CuvnalRanges on PFCReports
	SELECT	@CurYearBeg = BegDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
	WHERE	CuvnalParameter = 'CurrentYear'

	--OpenDataSource to CuvnalRanges on PFCReports
	SELECT	@PrevMth1Beg = BegDate,
			@PrevMth1End = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
	WHERE	CuvnalParameter = 'CurrentMonth'

	--OpenDataSource to CuvnalRanges on PFCReports
	SELECT	@PrevMth2Beg = BegDate,
			@PrevMth2End = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
	WHERE	CuvnalParameter = 'PreviousMonth'

	--OpenDataSource to CuvnalRanges on PFCReports
	SELECT	@PrevMth3Beg = BegDate,
			@PrevMth3End = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
	WHERE	CuvnalParameter = 'PreviousMonth2'



select @CurYearBeg as CurYearBeg, @CurEndDay as CurEndDay, @PrevMth1Beg as PrevMth1Beg, @PrevMth1End as PrevMth1End, @PrevMth2Beg as PrevMth2Beg, @PrevMth2End as PrevMth2End, @PrevMth3Beg as PrevMth3Beg, @PrevMth3End as PrevMth3End


-----------------------------------------------------------------



----------------------
-- Begin Sales Data --
-------------------------------------	
--  Get YTD SalesData from SOHist  --
-------------------------------------


---YTD Sales
UPDATE	#DashboardCustSalesGoal
SET		YTDSalesDol = isnull(tSales.LineSales,0)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
				SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
		 WHERE	(Hdr.ARPostDt between @CurYearBeg and @CurEndDay) AND ISNULL(Hdr.DeleteDt,'') = ''
		 GROUP BY Hdr.SellToCustNo) tSales
WHERE	#DashboardCustSalesGoal.CustNo = tSales.CustNo


---PrevMth1 Sales
UPDATE	#DashboardCustSalesGoal
SET		PrevMth1SalesDol = isnull(tSales.LineSales,0),
		PrevMth1GMPct = isnull(tSales.LineMgnPct,0)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
				SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
				CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				WHEN 0 THEN 0
					   ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				END AS LineMgnPct
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
		 WHERE	(Hdr.ARPostDt between @PrevMth1Beg and @PrevMth1End) AND ISNULL(Hdr.DeleteDt,'') = ''
		 GROUP BY Hdr.SellToCustNo) tSales
WHERE	#DashboardCustSalesGoal.CustNo = tSales.CustNo



---PrevMth2 Sales
UPDATE	#DashboardCustSalesGoal
SET		PrevMth2SalesDol = isnull(tSales.LineSales,0),
		PrevMth2GMPct = isnull(tSales.LineMgnPct,0)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
				SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
				CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				WHEN 0 THEN 0
					   ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				END AS LineMgnPct
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
		 WHERE	(Hdr.ARPostDt between @PrevMth2Beg and @PrevMth2End) AND ISNULL(Hdr.DeleteDt,'') = ''
		 GROUP BY Hdr.SellToCustNo) tSales
WHERE	#DashboardCustSalesGoal.CustNo = tSales.CustNo


---PrevMth3 Sales
UPDATE	#DashboardCustSalesGoal
SET		PrevMth3SalesDol = isnull(tSales.LineSales,0),
		PrevMth3GMPct = isnull(tSales.LineMgnPct,0)
FROM	(SELECT	Hdr.SellToCustNo AS CustNo,
				SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS LineSales,
				CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				WHEN 0 THEN 0
					   ELSE (SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
				END AS LineMgnPct
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
		 WHERE	(Hdr.ARPostDt between @PrevMth3Beg and @PrevMth3End) AND ISNULL(Hdr.DeleteDt,'') = ''
		 GROUP BY Hdr.SellToCustNo) tSales
WHERE	#DashboardCustSalesGoal.CustNo = tSales.CustNo





--------------------
-- End Sales Data --
--------------------



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


select * from #DashboardCustSalesGoal where CustNo='013722'

select * from CustomerSalesForecast
where CustNo='013722' and RecordType = 'F'


