CREATE FUNCTION [dbo].[fGetCuvnalMo1FY] (@Today Datetime)  
--Returns the month (mm) for the 1st month of the fiscal year
RETURNS INT
AS  
BEGIN 
   Declare @FM1 Int

   SET @Today = @Today + 5
   SET @Today = (SELECT CONVERT(DATETIME,CONVERT(CHAR(10),@Today,101)))
   SET @FM1   = (SELECT CFC2.CuvnalMonth
		 FROM   CuvnalFiscalCalendar CFC2
		 WHERE  CFC2.CalendarDate = (SELECT CFC1.FiscalYearBeg
					     FROM   CuvnalFiscalCalendar CFC1
					     WHERE  Calendardate =@Today))

   Return @FM1
END