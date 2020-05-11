DECLARE	@LastFiscalMthBeginDt datetime,
		@LastFiscalMthEndDt datetime,
		@CuvnalYearMo varchar(6),
		@CuvnalYearMo12 varchar(6),
		@CuvnalSum decimal(13,4)


	--SET Cuvnal Dates (@CuvnalYearMo12 & @CuvnalYearMo)
	SELECT @LastFiscalMthBeginDt = LastFiscalMthBeginDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	SELECT @LastFiscalMthEndDt = LastFiscalMthEndDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

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
	select	@LastFiscalMthBeginDt as LastFiscalMthBeginDt, @LastFiscalMthEndDt as LastFiscalMthEndDt,
			@CuvnalYearMo12 as CuvnalYearMo12, @CuvnalYearMo as CuvnalYearMo


SELECT	@CuvnalSum = SUM(ISNULL(CMSales,0)) 
FROM	CuvnalSum (NoLock)
WHERE	((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND CuvnalSum.CustNo = '001117'  --@CustNo





	--Table[1] - Customer A/R Aging Data
	SELECT	Aging.CustNo,
			Aging.CurrentAmt,
			Aging.CurrentPct,
			Aging.Over30Amt,
			Aging.Over30Pct,
			Aging.Over60Amt,
			Aging.Over60Pct,
			Aging.Over90Amt,
			Aging.Over90Pct,
			Aging.BalanceDue,
365 * ([BalanceDue] / @CuvnalSum) as DSO, 
round((365 * ([BalanceDue] / @CuvnalSum)),0) as DSORounded 
	FROM	ARAging Aging (NoLock)
	WHERE	Aging.CustNo = '001117'	--@CustNo




------------------------------------------------------------------------------------------------------------


DECLARE	@LastFiscalMthBeginDt datetime,
		@LastFiscalMthEndDt datetime,
		@CuvnalYearMo varchar(6),
		@CuvnalYearMo12 varchar(6)



	--SET Cuvnal Dates (@CuvnalYearMo12 & @CuvnalYearMo)
	SELECT @LastFiscalMthBeginDt = LastFiscalMthBeginDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	SELECT @LastFiscalMthEndDt = LastFiscalMthEndDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

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
	select	@LastFiscalMthBeginDt as LastFiscalMthBeginDt, @LastFiscalMthEndDt as LastFiscalMthEndDt,
			@CuvnalYearMo12 as CuvnalYearMo12, @CuvnalYearMo as CuvnalYearMo






select
CustNo,
			365 * 
			(dbo.fdivide(([BalanceDue]), 
			(SELECT SUM(ISNULL(CMSales,0)) 
			 FROM CuvnalSum
			 WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND ARAging.CustNo =CuvnalSum.CustNo),2)) as DSO,

round(			365 * 
			(dbo.fdivide(([BalanceDue]), 
			(SELECT SUM(ISNULL(CMSales,0)) 
			 FROM CuvnalSum
			 WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND ARAging.CustNo =CuvnalSum.CustNo),2)),0) as DSOrounded

--select *
from ARAging
where 
			365 * 
			(dbo.fdivide(([BalanceDue]), 
			(SELECT SUM(ISNULL(CMSales,0)) 
			 FROM CuvnalSum
			 WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND ARAging.CustNo =CuvnalSum.CustNo),2))
<> 0

