CREATE FUNCTION [dbo].[fGetCuvnalYear] (@Today datetime)
-- ====================================================================================
-- Author:	Craig Parks
-- Create Date:	12/20/2006
-- Description:	Returns the year (yyyy) for the last closed month of the fiscal year
-- ====================================================================================
RETURNS INT
AS
BEGIN
   SET @Today = @Today + 5
   SET @Today = (SELECT CONVERT(DATETIME,CONVERT(CHAR(10),@Today,101))) 

   --Declare the return variable here
   DECLARE @CuvnalYear INT

   --Ccompute the return value here
   SET @CuvnalYear = (SELECT CuvnalYear
		      FROM   CuvnalFiscalCalendar
		      WHERE (SELECT DISTINCT(CuvnalMonth - 1)
			     FROM   CuvnalFiscalCalendar
			     WHERE  CalendarDate = @Today) <> 0 AND
			    CalendarDate = @Today
		     UNION
		      SELECT CuvnalYear - 1
		      FROM   CuvnalFiscalCalendar 
		      WHERE (SELECT DISTINCT(CuvnalMonth - 1)
			     FROM   CuvnalFiscalCalendar
			     WHERE  CalendarDate = @Today) = 0 AND
			    CalendarDate = @Today)

   --Return the result
   RETURN @CuvnalYear
END