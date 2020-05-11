drop proc CuvnalSetMonth
go


CREATE procedure [dbo].[CuvnalSetMonth]
	@MonthDate datetime as


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


---------------------------------------------------------------------------------------------------------------------


--TRUNCATE existing CuvnalRanges table data
TRUNCATE table CuvnalRanges


-----------------------------------------------
--  Process Last Closed Month & Current YTD  --
-----------------------------------------------

--=================================================================================================================--
--  [TMD] 2011-Oct-11:	This was using CuvnalTempAccountingPeriod which was/is copied from NV5			   --
--			I've modified it to use CuvnalFiscalCalendar in order to eliminate NV from this procedure  --
---------------------------------------------------------------------------------------------------------------------
/*
--Set the beginning date for the last closed fiscal month
SELECT	@FiscalMonthBeg = max([Starting Date])
FROM	CuvnalTempAccountingPeriod
WHERE	[Starting Date] < (SELECT max([Starting Date]) as CurBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date]<@MonthDate)
*/
--=================================================================================================================--

--Set the beginning date for the LAST closed Fiscal Month
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate)

--Set the month number for the LAST closed Fiscal Month
SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the year value for the LAST closed Fiscal Month
SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the Fiscal Year beginning date for the CURRENT closed Fiscal Month
SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the ending date for the LAST closed Fiscal Month
SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

/*
Print '@MonthDate = ' + convert(varchar,@MonthDate);
Print '@FiscalMonthBeg = ' + convert(varchar,@FiscalMonthBeg);

select	'Current Period' as [Desc],
	@monthDate as MonthDate,
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT CurrentMonth & CurrentYear
--(CurrentMonth is the last complete Fiscal month from today)
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('CurrentMonth', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

--(CurrentYear is the dates from fiscal 01 thru the end of CurrentMonth)
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('CurrentYear', @CuvnalMonth, @CuvnalYear, @FiscalYearBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

-----------------------------
--  Process Previous Year  --
-----------------------------

--Set the CuvnalYear value back one year
SET	@CuvnalYear = @CuvnalYear - 1

--Set the Fiscal Year beginning date for the LAST closed Fiscal Month (LAST YEAR)
SELECT	@FiscalYearBeg = min(FiscalYearBeg)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear

--Set the ending date for the LAST closed Fiscal Month (LAST YEAR)
SELECT	@FiscalMonthEnd = min(FiscalPeriodEnd)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear

--Set the beginning date for the LAST closed Fiscal Month (LAST YEAR)
SELECT	@FiscalMonthBeg = min(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	CuvnalMonth = @CuvnalMonth and CuvnalYear = @CuvnalYear

/*
select	'Previous Year' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT LastYear & LastMonth
--(LastYear is the same fiscal dates as CurrentYear only in the previous year)
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('LastYear', @CuvnalMonth, @CuvnalYear, @FiscalYearBeg, @FiscalMonthEnd)

--(LastMonth is one year back from the Current Month)
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('LastMonth', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

-------------------------------------
--  Process Previous Closed Month  --
-------------------------------------

--=================================================================================================================--
--  [TMD] 2011-Oct-11:	This was using CuvnalTempAccountingPeriod which was/is copied from NV5			   --
--			I've modified it to use CuvnalFiscalCalendar in order to eliminate NV from this procedure  --
---------------------------------------------------------------------------------------------------------------------
/*
--Go back two months from today. This is the previous closed month
SELECT	@FiscalMonthBeg = max([Starting Date])
FROM	CuvnalTempAccountingPeriod
WHERE	[Starting Date] < (SELECT max([Starting Date]) as PrevBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date] < (SELECT max([Starting Date]) as CurBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date]<@MonthDate))
*/
--=================================================================================================================--

--Set the beginning date for the PREVIOUS closed Fiscal Month
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate))

--Set the month number for the PREVIOUS closed Fiscal Month
SELECT	@CuvnalMonth = CuvnalMonth
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the year value for the PREVIOUS closed Fiscal Month
SELECT	@CuvnalYear = CuvnalYear
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the Fiscal Year beginning date for the PREVIOUS closed Fiscal Month
SELECT	@FiscalYearBeg = FiscalYearBeg
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

--Set the ending date for the PREVIOUS closed Fiscal Month
SELECT	@FiscalMonthEnd = FiscalPeriodEnd
FROM	CuvnalFiscalCalendar
WHERE	CalendarDate = @FiscalMonthBeg

/*
select	'Previous Month' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT PreviousMonth
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('PreviousMonth', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

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

/*
select	'Previous Month2' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT PreviousMonth2
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('PreviousMonth2', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

--------------------------------------
--  Process Previous Closed Month3  --
--------------------------------------

--Set the beginning date for the PREVIOUS closed Fiscal Month3 (3 MONTHS BACK)
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as Prev3Beg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as Prev2Beg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as CurBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < @MonthDate))))

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

/*
select	'Previous Month3' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalYearBeg as FiscalYearBeg,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT PreviousMonth3
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('PreviousMonth3', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------
--  Process Half Year (6 months from the Cuvnal Month)  --
----------------------------------------------------------

--=================================================================================================================--
--  [TMD] 2011-Oct-11:	This was using CuvnalTempAccountingPeriod which was/is copied from NV5			   --
--			I've modified it to use CuvnalFiscalCalendar in order to eliminate NV from this procedure  --
---------------------------------------------------------------------------------------------------------------------
/*
SELECT	@FiscalMonthBeg = max([Starting Date])
FROM	CuvnalTempAccountingPeriod
WHERE	[Starting Date] < (SELECT max([Starting Date]) as PrevBeg FROM CuvnalTempAccountingPeriod WHERE [Starting Date] < dateadd(m,-6,@MonthDate))
*/
--=================================================================================================================--

--Set the beginning date for the LAST closed Fiscal Month (6 months ago)
SELECT	@FiscalMonthBeg = max(FiscalPeriodBeg)
FROM	CuvnalFiscalCalendar
WHERE	FiscalPeriodBeg < (SELECT max(FiscalPeriodBeg) as PrevBeg FROM CuvnalFiscalCalendar WHERE CalendarDate < dateadd(m,-6,@MonthDate))

--Set the month number for the LAST closed Fiscal Month (6 months ago)
SELECT	@CuvnalMonth = CuvnalMonth 
FROM	CuvnalFiscalCalendar 
WHERE	CalendarDate = @FiscalMonthBeg

--Set the year value for the LAST closed Fiscal Month (6 months ago)
SELECT	@CuvnalYear = CuvnalYear 
FROM	CuvnalFiscalCalendar 
WHERE	CalendarDate = @FiscalMonthBeg

--Set the ending date for the LAST closed Fiscal Month (6 months ago)
SELECT	@FiscalMonthEnd = FiscalPeriodEnd 
FROM	CuvnalFiscalCalendar 
WHERE	CalendarDate = @FiscalMonthBeg

/*
select	'HalfYear' as [Desc],
	@FiscalMonthBeg as FiscalMonthBeg,
	@CuvnalMonth as CuvnalMonth,
	@CuvnalYear as CuvnalYear,
	@FiscalMonthEnd as FiscalMonthEnd
*/


--INSERT HalfYear
INSERT
INTO	CuvnalRanges
	(CuvnalParameter, MonthValue, YearValue, BegDate, EndDate)
VALUES	('HalfYear', @CuvnalMonth, @CuvnalYear, @FiscalMonthBeg, @FiscalMonthEnd)

---------------------------------------------------------------------------------------------------------------------

GO
