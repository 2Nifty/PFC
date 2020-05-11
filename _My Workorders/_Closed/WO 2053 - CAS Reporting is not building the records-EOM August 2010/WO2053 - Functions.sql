
Declare @FMY1 Int,
@Today Datetime,
@FPToday INT

SET @Today = Getdate()
SET @Today = @Today + 5
SET @Today =  (SELECT CONVERT(datetime,convert(CHAR(10),@Today,101)))
SET @FPToday = (SELECT FiscalPeriod
			FROM CuvnalFiscalCalendar
			WHERE Calendardate = @Today)

SET @FMY1 = (SELECT CAST(DATEPART(yyyy,FiscalYearBeg) as INT)
			FROM CuvnalFiscalCalendar
			WHERE Calendardate = @Today)
select @FPToday as FPToday
IF (@FPToday = 1) 
SET @FMY1 = @FMY1 - 1
select @FMY1





select @Today 
Declare @FM1 Int
SET @FM1 = (SELECT CFC2.CuvnalMonth FROM CuvnalFiscalCalendar CFC2
Where CFC2.CalendarDate = (SELECT CFC1.FiscalYearBeg
			FROM CuvnalFiscalCalendar CFC1
			WHERE Calendardate =@Today))
--			WHERE Calendardate =CAST (FLOOR (CAST (GetDate()-5 AS FLOAT)) AS DATETIME)))

select @FM1





select * from CuvnalFiscalCalendar order by CalendarDate



select * from FiscalCalendar order by CurrentDt





