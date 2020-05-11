

--select * from Cuvnalranges

--truncate table Cuvnalranges


--select * from CuvnalTempAccountingPeriod



--------------------------------------------------------------------------------------------------------

/*

declare @monthdate datetime
select @monthdate=dateadd(d,10,getdate())
select @monthDate
EXEC [PFCReports].[dbo].[CuvnalSetMonth] @monthdate

*/


----------------------------------------------------------------



declare @MonthDate datetime
DECLARE @FiscalStart datetime
DECLARE @FiscalYearBeg datetime
DECLARE @FiscalYearEnd datetime
DECLARE @FiscalMonthBeg datetime
DECLARE @FiscalMonthEnd datetime
DECLARE @CalendarDate datetime
DECLARE @NewFiscal int
DECLARE @CurFiscalYear int
DECLARE @CuvnalMonth int
DECLARE @CuvnalYear int
DECLARE @FiscalPeriod int
DECLARE @MonthName varchar(20)
DECLARE @MonthFetch int


---------------------------------------------------

select @monthdate=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)  --+210
--select @monthDate as MonthDate


SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate)

--select @FiscalMonthBeg as FiscalMonthBeg2


--------------------------------------------------


SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg




SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


------------------------

select	'Current Period' as [Desc],
	@monthDate as MonthDate,
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd


---------------------------------------------------------------------------------------


--Go back one year
SET	@CuvnalYear = @CuvnalYear - 1

SELECT	@FiscalYearBeg = min(FiscalYearBeg)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear

SELECT	@FiscalMonthEnd = min(FiscalPeriodEnd)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear

SELECT	@FiscalMonthBeg = min(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear



select	'Previous Year' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd




-----------------------------------
-- Process Previous Closed Month --
-----------------------------------


/*
--Go back two months from today. This is the previous closed month
SELECT	@FiscalMonthBeg = max([Starting Date])
FROM	CuvnalTempAccountingPeriod
WHERE	[Starting Date] < (SELECT max([Starting Date]) as PrevBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date] < (SELECT max([Starting Date]) as CurBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date]<@MonthDate))

select	@FiscalMonthBeg as FiscalMonthBeg1


SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


select	'Previous Month' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--Go back two months from today. This is the previous closed month
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate))

--select @FiscalMonthBeg as FiscalMonthBeg2



SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


select	'Previous Month' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd








SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < dateadd(m,-6,@MonthDate))



SELECT	@CuvnalMonth = CuvnalMonth 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


SELECT	@CuvnalYear = CuvnalYear 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


SELECT	@FiscalMonthEnd = FiscalPeriodEnd 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


select	'HalfYear' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalMonthEnd as FiscalMonthEnd






/*

SELECT	@FiscalMonthBeg = max([Starting Date])
FROM	CuvnalTempAccountingPeriod
WHERE	[Starting Date] < (SELECT max([Starting Date]) as PrevBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date] < dateadd(m,-6,@MonthDate))


SELECT	@CuvnalMonth = CuvnalMonth 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


SELECT	@CuvnalYear = CuvnalYear 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


SELECT	@FiscalMonthEnd = FiscalPeriodEnd 
FROM CuvnalFiscalCalendar 
WHERE CalendarDate = @FiscalMonthBeg


select	'HalfYear' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalMonthEnd as FiscalMonthEnd

*/




--------------------------------------
--  Process Previous Closed Month2  --
--------------------------------------

--Set the beginning date for the PREVIOUS closed Fiscal Month2 (2 MONTHS BACK)
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as Prev2Beg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate)))

--Set the month number for the PREVIOUS closed Fiscal Month2 (2 MONTHS BACK)
SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the year value for the PREVIOUS closed Fiscal Month2 (2 MONTHS BACK)
SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the Fiscal Year beginning date for the PREVIOUS closed Fiscal Month2 (2 MONTHS BACK)
SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the ending date for the PREVIOUS closed Fiscal Month2 (2 MONTHS BACK)
SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


select	'Previous Month2' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd





--------------------------------------
--  Process Previous Closed Month3  --
--------------------------------------

--Set the beginning date for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < 
(SELECT max(FiscalPeriodBeg) as Prev3Beg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as Prev2Beg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate))))

--Set the month number for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the year value for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the Fiscal Year beginning date for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the ending date for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg


select	'Previous Month3' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd