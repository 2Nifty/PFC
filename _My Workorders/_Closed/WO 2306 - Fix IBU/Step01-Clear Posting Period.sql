DECLARE @begInvDt DATETIME
DECLARE @endInvDT DATETIME
DECLARE @curPeriod INT,
	@endPeriod INT
DECLARE @today DATETIME
SELECT	@today = GETDATE()

/*Uncomment the following  statement
SET @today = CAST('06/01/2009' AS DATETIME) -- A date following the period you want to post
The above example posts 2009 05
*/

EXEC [dbo].[pUTRetPeriod] 
	-- Add the parameters for the stored procedure here
	@date  = @today, 
	@periodType  = 'LF',
    	@period  = @curPeriod   OUTPUT,
	@periodBegin  = @begInvDt OUTPUT,
	@periodEnd = @endInvDT OUTPUT

DELETE FROM tFix_ItemBranchUsage1 WHERE CurPeriodNo = @curPeriod
