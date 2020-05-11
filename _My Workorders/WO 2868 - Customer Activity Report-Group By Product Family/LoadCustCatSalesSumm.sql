select count(*) from CustCatSalesSummary
select distinct entrydt from CustCatSalesSummary order by EntryDt
select distinct FiscalPeriodNo from CustCatSalesSummary order by FiscalPeriodNo

select distinct entrydt from tCustItemSalesSummary order by EntryDt
select distinct FiscalPeriodNo from tCustItemSalesSummary  order by FiscalPeriodNo

------------------------------------------------------------------------------------


DECLARE	@BegPer varchar(6),
	@EndPer varchar(6),
	@cPeriod varchar(6),
	@cBegPerDt datetime,
	@cEndPerDt datetime

set @BegPer = '200809'
set @EndPer = '201208'

DECLARE PerCursor CURSOR FOR
	SELECT	DISTINCT
		CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as Period,
		CurFiscalMthBeginDt as FiscalMthBeginDt,
		CurFiscalMthEndDt as FiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) >= @BegPer AND
		CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) <= @EndPer
	ORDER BY CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)


OPEN PerCursor
FETCH NEXT FROM PerCursor INTO @cPeriod, @cBegPerDt, @cEndPerDt
WHILE @@FETCH_STATUS = 0
   BEGIN
		exec tProcessCustCatSlsSumm @cPeriod, @cBegPerDt, @cEndPerDt
	FETCH NEXT FROM  PerCursor INTO @cPeriod, @cBegPerDt, @cEndPerDt
   END
CLOSE PerCursor
DEALLOCATE PerCursor

