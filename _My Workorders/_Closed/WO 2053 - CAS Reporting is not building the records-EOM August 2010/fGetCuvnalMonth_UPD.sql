CREATE FUNCTION [dbo].[fGetCuvnalMonth] (@Today datetime)
-- =================================================================================
-- Author:	Craig Parks
-- Create date:	12/20/2006
-- Description:	Returns the month (mm) for the last closed month of the fiscal year
-- =================================================================================
RETURNS INT
AS
BEGIN
   SET @Today = @Today + 5
   SET @Today = (SELECT CONVERT(DATETIME,CONVERT(CHAR(10),@Today,101)))

   --Declare the return variable here
   DECLARE @CuvnalMonth INT

   --Compute the return value here
   SET @CuvnalMonth = (SELECT DISTINCT(ISNULL(NULLIF(CuvnalMonth -1,0),12))
		       FROM   CuvnalFiscalCalendar
		       WHERE  Calendardate = @Today)
	
   --Return the result
   RETURN @CuvnalMonth
END