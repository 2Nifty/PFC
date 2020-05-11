
-- =============================================
-- Author:		Craig Parks
-- Create date: 12/20/2006
-- Description:	Return the Cuvnal month using the fiscal table
-- =============================================
CREATE FUNCTION fGetCuvnalMonth 
(
	@Today datetime
	 
)
RETURNS int

BEGIN
SET @Today = @today +5
SET @Today = (SELECT CONVERT(datetime,convert(CHAR(10),@Today,101)))
	-- Declare the return variable here
	DECLARE @CuvnalMonth int

	-- Add the T-SQL statements to compute the return value here
	SET @CuvnalMonth =  (SELECT DISTINCT(ISNULL(NULLIF(CuvnalMonth -1,0),12))
			FROM CuvnalFiscalCalendar
			WHERE Calendardate = @Today)
	
	-- Return the result of the function
	RETURN @CuvnalMonth

END




















