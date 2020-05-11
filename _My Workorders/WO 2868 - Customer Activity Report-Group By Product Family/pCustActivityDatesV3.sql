USE [PFCReports]
GO

drop proc [pCustActivityDatesV3]
go

/****** Object:  StoredProcedure [dbo].[pCustActivityCustV3]    Script Date: 08/14/2012 13:37:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pCustActivityDatesV3]
	--INPUT PARAMS
	@Period varchar(6),
	--OUTPUT PARAMS
	@BegCurDt datetime OUTPUT,
	@EndCurDt datetime OUTPUT,
	@BegLastDt datetime OUTPUT,
	@EndLastDt datetime OUTPUT,
	@BegPrevDt datetime OUTPUT,
	@EndPrevDt datetime OUTPUT,
	@BegCurYTD datetime OUTPUT,
	@EndCurYTD datetime OUTPUT,
	@BegCurMTD datetime OUTPUT,
	@EndCurMTD datetime OUTPUT,
	@LastPeriod varchar(6) OUTPUT,
	@LastYTD varchar(4) OUTPUT,
	@BegLastYTD datetime OUTPUT,
	@EndLastYTD datetime OUTPUT,
	@PrevPeriod varchar(6) OUTPUT,
	@PrevYTD varchar(4) OUTPUT,
	@BegPrevYTD datetime OUTPUT,
	@EndPrevYTD datetime OUTPUT,
	@LastFiscalMthBeginDt datetime OUTPUT,
	@LastFiscalMthEndDt datetime OUTPUT,
	@CuvnalYearMo varchar(6) OUTPUT,
	@CuvnalYearMo12 varchar(6) OUTPUT,
	@YTDPer varchar(6) OUTPUT,
	@BegLastYTDPer varchar(6) OUTPUT,
	@EndLastYTDPer varchar(6) OUTPUT,
	@BegPrevYTDPer varchar(6) OUTPUT,
	@EndPrevYTDPer varchar(6) OUTPUT
AS
BEGIN

	/* ======================================================	
	Author:         Tod Dixon
	Create date:    08/23/2012
	Description:    This procedure runs against PFCSQLP.PFCReports to generate
					date ranges for periods used by the Customer Activity Report
	==========================================================
	*/

	SET NOCOUNT ON;

	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurDt = CurFiscalMthBeginDt,
			@EndCurDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
print 'Period: ' + cast(@Period as varchar(20)) + ' - BegCurDt: ' + cast(@BegCurDt as varchar(20)) + ' - EndCurDt: ' + cast(@EndCurDt as varchar(20))

	SELECT	@BegLastDt = CurFiscalMthBeginDt,
			@EndLastDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
print 'LastPeriod: ' + cast(@LastPeriod as varchar(20)) + ' - BegLastDt: ' + cast(@BegLastDt as varchar(20)) + ' - EndLastDt: ' + cast(@EndLastDt as varchar(20))

	SELECT	@BegPrevDt = CurFiscalMthBeginDt,
			@EndPrevDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
print 'PrevPeriod: ' + cast(@PrevPeriod as varchar(20)) + ' - BegPrevDt: ' + cast(@BegPrevDt as varchar(20)) + ' - EndPrevDt: ' + cast(@EndPrevDt as varchar(20))

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurDt,
			@BegCurMTD = @BegCurDt,
			@EndCurMTD = @EndCurDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurDt
print 'MTDPer: ' + cast(@Period as varchar(20)) + ' - BegCurMTD: ' + cast(@BegCurMTD as varchar(20)) + ' - EndCurMTD: ' + cast(@EndCurMTD as varchar(20))

	SELECT	@YTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegCurYTD
print 'YTDPer: ' + cast(@YTDPer as varchar(20)) + ' - BegCurYTD: ' + cast(@BegCurYTD as varchar(20)) + ' - EndCurYTD: ' + cast(@EndCurYTD as varchar(20)) + ' - EndYTDPer: ' + cast(@Period as varchar(20))

	--SET Last Year's Fiscal
	SELECT	@LastYTD = FiscalYear,
			@BegLastYTD = CurFiscalYearBeginDt,
			@EndLastYTD = @EndLastDt,
			@EndLastYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndLastDt

	SELECT	@BegLastYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegLastYTD
print 'LastYTD: ' + cast(@LastYTD as varchar(20)) + ' - BegLastYTDPer: ' + cast(@BegLastYTDPer as varchar(20)) + ' - BegLastYTD: ' + cast(@BegLastYTD as varchar(20)) + ' - EndLastYTD: ' + cast(@EndLastYTD as varchar(20)) + ' - EndLastYTDPer: ' + cast(@EndLastYTDPer as varchar(20))

	--SET 2 Years Previous Fiscal
	SELECT	@PrevYTD = FiscalYear,
			@BegPrevYTD = CurFiscalYearBeginDt,
			@EndPrevYTD = @EndPrevDt,
			@EndPrevYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndPrevDt

	SELECT	@BegPrevYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegPrevYTD
print 'PrevYTD: ' + cast(@PrevYTD as varchar(20)) + ' - BegPrevYTDPer: ' + cast(@BegPrevYTDPer as varchar(20)) + ' - BegPrevYTD: ' + cast(@BegPrevYTD as varchar(20)) + ' - EndPrevYTD: ' + cast(@EndPrevYTD as varchar(20)) + ' - EndPrevYTDPer: ' + cast(@EndPrevYTDPer as varchar(20))

	--SET Cuvnal Dates (@CuvnalYearMo12 & @CuvnalYearMo)
	SELECT @LastFiscalMthBeginDt = LastFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	SELECT @LastFiscalMthEndDt = LastFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

	SELECT	@CuvnalYearMo12 = tmp.CuvnalYearMo12
	FROM	(SELECT	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalYearMo12
			 FROM	FiscalCalendar
			 WHERE	CurFiscalMthBeginDt = @LastFiscalMthBeginDt and CurFiscalMthEndDt = @LastFiscalMthEndDt
			 ORDER BY CurrentDt DESC) tmp

	SELECT	@CuvnalYearMo = tmp.CuvnalYearMo
	FROM	(SELECT	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalYearMo
			 FROM 	FiscalCalendar
			 WHERE	CurFiscalMthEndDt <= CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
			 ORDER BY CurrentDt DESC) tmp
print 'LastFiscalMthBeginDt: ' + cast(@LastFiscalMthBeginDt as varchar(20)) + ' - LastFiscalMthEndDt: ' + cast(@LastFiscalMthEndDt as varchar(20)) + ' - CuvnalYearMo12: ' + cast(@CuvnalYearMo12 as varchar(20)) + ' - CuvnalYearMo: ' + cast(@CuvnalYearMo as varchar(20))

END
GO
