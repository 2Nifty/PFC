
-- =============================================
-- Author:		Craig Parks
-- Create date: 12/20/2006
-- Description:	Return the Cuvnal year using the fiscal table
-- =============================================
CREATE FUNCTION fGetCuvnalYear 
(
	@Today datetime
	 
)
RETURNS int

BEGIN
set @Today = @Today + 5
SET @Today = (SELECT CONVERT(datetime,convert(CHAR(10),@Today,101))) 
	-- Declare the return variable here
	DECLARE @CuvnalYear int

	-- Add the T-SQL statements to compute the return value here
	SET @CuvnalYear =   (SELECT CuvnalYear FROM CuvnalFiscalCalendar 
WHERE (SELECT DISTINCT(CuvnalMonth - 1)
FROM CuvnalFiscalCalendar
WHERE Calendardate = @Today)
<> 0
AND
Calendardate =  @Today 

UNION
SELECT CuvnalYear -1 FROM CuvnalFiscalCalendar 
WHERE (SELECT DISTINCT(CuvnalMonth - 1)
FROM CuvnalFiscalCalendar
WHERE Calendardate = @Today) 
 = 0
AND 
Calendardate = @Today)


	-- Return the result of the function
	RETURN @CuvnalYear

END



















