-- Date Modified 8/28/2007 Correct Fiscal Tear Returned when first period of nex year

CREATE FUNCTION [dbo].[fGetCuvnalMo1FYYear] (@Today Datetime)  
RETURNS INT
AS  
BEGIN 
Declare @FMY1 Int,
@FPToday INT
SET @Today = @Today + 5
SET @Today =  (SELECT CONVERT(datetime,convert(CHAR(10),@Today,101)))
SET @FPToday = (SELECT FiscalPeriod
			FROM CuvnalFiscalCalendar
			WHERE Calendardate = @Today)

SET @FMY1 = (SELECT CAST(DATEPART(yyyy,FiscalYearBeg) as INT)
			FROM CuvnalFiscalCalendar
			WHERE Calendardate = @Today)
IF (@FPToday = 1) 
SET @FMY1 = @FMY1 - 1

Return @FMY1

END






