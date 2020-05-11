CREATE FUNCTION [dbo].[fGetCuvnalMo1FYYear] (@Today Datetime)  
--Returns the year (yyyy) for the 1st month of the fiscal year
RETURNS INT
AS  
BEGIN 
   DECLARE @FMY1 INT,
	   @FPToday INT

   SET @Today   = @Today + 5
   SET @Today   = (SELECT CONVERT(DATETIME,CONVERT(CHAR(10),@Today,101)))
   SET @FPToday = (SELECT FiscalPeriod
		   FROM   CuvnalFiscalCalendar
		   WHERE  CalendarDate = @Today)

   SET @FMY1    = (SELECT CAST(DATEPART(yyyy,FiscalYearBeg) as INT)
		   FROM   CuvnalFiscalCalendar
		   WHERE  Calendardate = @Today)

   IF (@FPToday = 1) SET @FMY1 = @FMY1 - 1

   Return @FMY1
END