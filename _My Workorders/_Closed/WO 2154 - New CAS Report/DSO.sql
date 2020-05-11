--select * from AR_Aging


DECLARE @CuvnalYear INT,
@CuvnalMonth INT,
@CuvnalMonthYear BIGINT,
@CuvnalMo12 INT,
@CuvnalYearMo12 INT,
@CuvnalMonthYear12 INT
--@CuvnalFYBegin BIGINT 
-- Establish FY Range
SELECT @CuvnalYear = PFCReports.dbo.fGetCuvnalYear(GETDATE())
SELECT @CuvnalMonth = PFCReports.dbo.fGetCuvnalMonth(GETDATE())
SET @CuvnalMonthYear = (@CuvnalYear * 100) + @CuvnalMonth
SELECT @CuvnalMo12 = dbo.fGetCuvnalMo12( dbo.fGetCuvnalMonth(GETDATE()))
SELECT @CuvnalYearMo12 = PFCReports.dbo.fGetCuvnalYear12(dbo.fGetCuvnalMonth(Getdate()),@CuvnalMo12,dbo.fGetCuvnalYear(Getdate()))
--SET @CuvnalFYBegin = (@CuvnalYearMo1FY * 100) + @CuvnalMo1FY
SET @CuvnalMonthYear12 = (@CuvnalYearMo12 * 100) + @CuvnalMo12



select @CuvnalMonthYear12 as CuvnalMonthYear12, @CuvnalMonthYear as CuvnalMonthYear



--------------------------------------------------------------------

DECLARE @LastFiscalMthBeginDt datetime,
	@LastFiscalMthEndDt datetime

SELECT @LastFiscalMthBeginDt = LastFiscalMthBeginDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
SELECT @LastFiscalMthEndDt = LastFiscalMthEndDt from FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

select @CuvnalMonthYear12 = tmp.CuvnalMonthYear12
from	(select	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalMonthYear12
	 from	FiscalCalendar
	 WHERE	CurFiscalMthBeginDt = @LastFiscalMthBeginDt and 
		CurFiscalMthEndDt = @LastFiscalMthEndDt
	 ORDER BY CurrentDt DESC) tmp


	SELECT	@CuvnalMonthYear = tmp.CuvnalMonthYear
	FROM	(SELECT	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalMonthYear
		 FROM 	FiscalCalendar
		 WHERE	CurFiscalMthEndDt <= CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
		 ORDER BY CurrentDt DESC) tmp

select @CuvnalMonthYear12 as MyCuvnalMonthYear12, @CuvnalMonthYear as MyCuvnalMonthYear



--------------------------------------------------------------------





select

			365 * 
			(dbo.fdivide(([BalanceDue]), 
			(SELECT SUM(ISNULL(CMSales,0)) 
			 FROM CuvnalSum
			 WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalMonthYear12 AND @CuvnalMonthYear AND ARAging.CustNo =CuvnalSum.CustNo),2)) as DSO
--select *
from ARAging
where 
			365 * 
			(dbo.fdivide(([BalanceDue]), 
			(SELECT SUM(ISNULL(CMSales,0)) 
			 FROM CuvnalSum
			 WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalMonthYear12 AND @CuvnalMonthYear AND ARAging.CustNo =CuvnalSum.CustNo),2))
<> 0

