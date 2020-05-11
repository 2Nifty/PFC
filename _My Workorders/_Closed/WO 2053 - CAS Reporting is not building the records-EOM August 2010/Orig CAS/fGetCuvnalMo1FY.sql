
CREATE FUNCTION [dbo].[fGetCuvnalMo1FY] (@Today Datetime)  
RETURNS INT
AS  
BEGIN 
Declare @FM1 Int
SET @Today = @Today + 5
SET @Today =  (SELECT CONVERT(datetime,convert(CHAR(10),@Today,101)))
SET @FM1 = (SELECT CFC2.CuvnalMonth FROM CuvnalFiscalCalendar CFC2
Where CFC2.CalendarDate = (SELECT CFC1.FiscalYearBeg
			FROM CuvnalFiscalCalendar CFC1
			WHERE Calendardate =@Today))

Return @FM1

END






