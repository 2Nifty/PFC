	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurDt = CurFiscalMthBeginDt,
			@EndCurDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
--	select @Period as Period, @BegCurDt as BegCurDt, @EndCurDt as EndCurDt

	SELECT	@BegLastDt = CurFiscalMthBeginDt,
			@EndLastDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
--	select @LastPeriod as LastPeriod, @BegLastDt as BegLastDt, @EndLastDt as EndLastDt

	SELECT	@BegPrevDt = CurFiscalMthBeginDt,
			@EndPrevDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
--	select @PrevPeriod as PrevPeriod, @BegPrevDt as BegPrevDt, @EndPrevDt as EndPrevDt

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurDt,
			@BegCurMTD = @BegCurDt,
			@EndCurMTD = @EndCurDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurDt
--	select @Period as MTDPer, @BegCurMTD as BegCurMTD, @EndCurMTD as EndCurMTD

	SELECT	@YTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegCurYTD
--	select @YTDPer as BegYTDPer, @BegCurYTD as BegCurYTD, @EndCurYTD as EndCurYTD, @Period as EndYTDPer

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
--	select @LastYTD as LastYTD, @BegLastYTDPer as BegLastYTDPer, @BegLastYTD as BegLastYTD, @EndLastYTD as EndLastYTD, @EndLastYTDPer as EndLastYTDPer

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
--	select @PrevYTD as PrevYTD, @BegPrevYTDPer as BegPrevYTDPer, @BegPrevYTD as BegPrevYTD, @EndPrevYTD as EndPrevYTD, @EndPrevYTDPer as EndPrevYTDPer

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
--	select @LastFiscalMthBeginDt as LastFiscalMthBeginDt, @LastFiscalMthEndDt as LastFiscalMthEndDt, @CuvnalYearMo12 as CuvnalYearMo12, @CuvnalYearMo as CuvnalYearMo
