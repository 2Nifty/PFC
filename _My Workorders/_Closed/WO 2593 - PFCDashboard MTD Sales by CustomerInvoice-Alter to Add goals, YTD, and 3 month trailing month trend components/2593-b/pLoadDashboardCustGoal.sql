drop proc [pLoadDashboardCustGoal]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================
-- Author:	Tod Dixon
-- Created:	2011-Oct-14
-- Desc:	- Runs against PERP
--			- Load DashboardCustSalesGoal with Goal Data
--			  from CustomerSalesForecast based on @CurMth
-- ======================================================
CREATE PROCEDURE [dbo].[pLoadDashboardCustGoal]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@CurDay datetime;
	DECLARE @CurMth int;
	DECLARE @CurYr int;
	DECLARE	@TotWorkDays int;
	DECLARE	@MTDWorkDays int;

	-------------------------------------
	--  Establish Current Date Params  --
	-------------------------------------

	SELECT	@CurDay = isnull(isnull(EndDate,BegDate),CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME))
	FROM	DashBoardRanges (NOLOCK)
	WHERE	DashBoardParameter = 'CurrentDay'

	--@CurMth & @CurYr
	SELECT	@CurMth = FiscalCalMonth,
			@CurYr = FiscalCalYear
	FROM	FiscalCalendar (NOLOCK)
	WHERE	CurrentDt = @CurDay

	--@TotWorkDays
	SELECT	@TotWorkDays = SUM(WorkDay)
	FROM	FiscalCalendar (NOLOCK)
	WHERE	FiscalCalMonth = @CurMth and FiscalCalYear = @CurYr

	IF (@TotWorkDays <=0) SET @TotWorkDays = 30

	--@MTDWorkDays
	SELECT	@MTDWorkDays = SUM(WorkDay)
	FROM	FiscalCalendar (NOLOCK)
	WHERE	FiscalCalMonth = @CurMth and FiscalCalYear = @CurYr AND CurrentDt <= @CurDay

--select @CurDay as CurDay, @CurMth as CurrentMonth, @CurYr as CurYr, @MTDWorkDays as MTDWorkDays, @TotWorkDays as TotWorkDays


	-----------------------------------------------------------------
	--  Get Goal Data from CustomerSalesForecast based on @CurMth  --
	-----------------------------------------------------------------

	--Build #MTDGoal: CustNo, MTDGoalDol, MTDGoalGMPct & MTDGoalGMDol
	SELECT	CSF.CustNo,
			CASE @CurMth
				WHEN  9 THEN CSF.SepSales
				WHEN 10 THEN CSF.OctSales
				WHEN 11 THEN CSF.NovSales
				WHEN 12 THEN CSF.DecSales
				WHEN  1 THEN CSF.JanSales
				WHEN  2 THEN CSF.FebSales
				WHEN  3 THEN CSF.MarSales
				WHEN  4 THEN CSF.AprSales
				WHEN  5 THEN CSF.MaySales
				WHEN  6 THEN CSF.JunSales
				WHEN  7 THEN CSF.JulSales
				WHEN  8 THEN CSF.AugSales
			END as MTDGoalDol,			--Current MTD Goal $
			CASE @CurMth
				WHEN  9 THEN CSF.SepGMPct
				WHEN 10 THEN CSF.OctGMPct
				WHEN 11 THEN CSF.NovGMPct
				WHEN 12 THEN CSF.DecGMPct
				WHEN  1 THEN CSF.JanGMPct
				WHEN  2 THEN CSF.FebGMPct
				WHEN  3 THEN CSF.MarGMPct
				WHEN  4 THEN CSF.AprGMPct
				WHEN  5 THEN CSF.MayGMPct
				WHEN  6 THEN CSF.JunGMPct
				WHEN  7 THEN CSF.JulGMPct
				WHEN  8 THEN CSF.AugGMPct
			END as MTDGoalGMPct,		--Current MTD Goal GM %
			CASE @CurMth
				WHEN  9 THEN CSF.SepSales * CSF.SepGMPct
				WHEN 10 THEN CSF.OctSales * CSF.OctGMPct
				WHEN 11 THEN CSF.NovSales * CSF.NovGMPct
				WHEN 12 THEN CSF.DecSales * CSF.DecGMPct
				WHEN  1 THEN CSF.JanSales * CSF.JanGMPct
				WHEN  2 THEN CSF.FebSales * CSF.FebGMPct
				WHEN  3 THEN CSF.MarSales * CSF.MarGMPct
				WHEN  4 THEN CSF.AprSales * CSF.AprGMPct
				WHEN  5 THEN CSF.MaySales * CSF.MayGMPct
				WHEN  6 THEN CSF.JunSales * CSF.JunGMPct
				WHEN  7 THEN CSF.JulSales * CSF.JulGMPct
				WHEN  8 THEN CSF.AugSales * CSF.AugGMPct
			END as MTDGoalGMDol			--Current MTD Goal GM $
	INTO	#MTDGoal
	FROM	CustomerSalesForecast CSF (NOLOCK)
	WHERE	CSF.RecordType = 'F'

--select * from #MTDGoal


	--Build #CSF: CustNo, ALL Monthly Sales Goals, All Monthly GM Goal Dollars, MTDGoalDol, MTDGoalGMPct & MTDGoalGMDol
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

--select * from #CSF


	--Build #Goals: CustNo, MTDGoalDol, MTDGoalGMPct, YTDGoalDol & YTDGoalGMDol
	SELECT	CSF.CustNo,
			CSF.MTDGoalDol,
			CSF.MTDGoalGMPct,
			CASE @CurMth
				WHEN  9 THEN CSF.MTDGoalDol
				WHEN 10 THEN CSF.SepSales + CSF.MTDGoalDol
				WHEN 11 THEN CSF.SepSales + CSF.OctSales + CSF.MTDGoalDol
				WHEN 12 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.MTDGoalDol
				WHEN  1 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.MTDGoalDol
				WHEN  2 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.MTDGoalDol
				WHEN  3 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MTDGoalDol
				WHEN  4 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.MTDGoalDol
				WHEN  5 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MTDGoalDol
				WHEN  6 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.MTDGoalDol
				WHEN  7 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.MTDGoalDol
				WHEN  8 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales + CSF.MTDGoalDol
			END as YTDGoalDol,				--Current YTD Goal $
			CASE @CurMth
				WHEN  9 THEN CSF.MTDGoalDol
				WHEN 10 THEN CSF.SepGMDol + CSF.MTDGoalGMDol
				WHEN 11 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.MTDGoalGMDol
				WHEN 12 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.MTDGoalGMDol
				WHEN  1 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.MTDGoalGMDol
				WHEN  2 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.MTDGoalGMDol
				WHEN  3 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MTDGoalGMDol
				WHEN  4 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.MTDGoalGMDol
				WHEN  5 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MTDGoalGMDol
				WHEN  6 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.MTDGoalGMDol
				WHEN  7 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.JunGMDol + CSF.MTDGoalGMDol
				WHEN  8 THEN CSF.SepGMDol + CSF.OctGMDol + CSF.NovGMDol + CSF.DecGMDol + CSF.JanGMDol + CSF.FebGMDol + CSF.MarGMDol + CSF.AprGMDol + CSF.MayGMDol + CSF.JunGMDol + CSF.JulGMDol + CSF.MTDGoalGMDol
			END as YTDGoalGMDol				--Current YTD Goal GM $
	INTO	#Goals
	FROM	#CSF CSF (NOLOCK)

--select * from #Goals


	--UPDATE Goal Data in #DashboardCustSalesGoal
	UPDATE	DashboardCustSalesGoal
	SET		MTDGoalDol = #Goals.MTDGoalDol,
			MTDGoalGMPct = #Goals.MTDGoalGMPct,
			YTDGoalDol = #Goals.YTDGoalDol,
			YTDGoalGMPct =	CASE WHEN #Goals.YTDGoalDol = 0
									THEN 0
									ELSE #Goals.YTDGoalGMDol / #Goals.YTDGoalDol
							END,
			ChangeID = 'pLoadDashboardCustGoal',
			ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME)
	FROM	#Goals
	WHERE	DashboardCustSalesGoal.CustNo = #Goals.CustNo

--select * from #DashboardCustSalesGoal


	--DROP temp tables
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#MTDGoal')) Drop Table #MTDGoal
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#CSF')) Drop Table #CSF
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#Goals')) Drop Table #Goals

END
GO
