
declare @TempDate VARCHAR(20)
SET @TempDate= CAST(DATEPART(yyyy, GetDate()-1) AS VARCHAR(4)) + '-' + 
	CAST(DATEPART(mm, GetDate()-1) AS VARCHAR(2)) + '-' +
	CAST(DATEPART(dd, GetDate()-1) AS VARCHAR(2))

select CAST(@TempDate AS DATETIME)


update PFCReports.dbo.AppPref
SET AppOptionvalue=CAST(@TempDate AS DATETIME)
where ApplicationCd='SOE' and AppOptionType='ARPostDt'


select * from PFCReports.dbo.AppPref
where ApplicationCd='SOE' and AppOptionType='ARPostDt'


------------------------------------------------------------------------------------------------------------

DECLARE	@LastDt VARCHAR(20),
	@NewDt VARCHAR(20),
	@ARPostDt VARCHAR(20)

--Get Last Posting Date from AppPref
SELECT	@LastDt = AppOptionValue FROM PFCReports.dbo.AppPref WHERE ApplicationCd='SOE' and AppOptionType='ARPostDt'

--Determine Next Posting Date from FiscalCalendar where WorkDay=1
SELECT	@NewDt = MIN(CurrentDt) FROM PFCReports.dbo.FiscalCalendar WHERE CurrentDt > @LastDt AND WorkDay=1

SELECT	@LastDt AS LastDt
SELECT	@NewDt AS NewDt

--If the Current Date is less than the Next Posting Date
--   then use the Last Posting Date
--   else use the Next Posting Date
IF (GETDATE() < @NewDt)
   SET @ARPostDt = @LastDt
   ELSE SET @ARPostDt = @NewDt

SELECT @ARPostDt AS ARPostDt

select ARPostDt, * from SOHeaderHist where [ARPostDt]=@LastDt


--Update AppPref with the Posting Date that was used
UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue=CAST(@ARPostDt AS DATETIME), ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='ARPostDt'



------------------------------------------------------------------------------------------------------------




SELECT @WorkDay = WorkDay from FiscalCalendar Where CurrentDt = 


select MIN(CurrentDt) AS CurrentDt from FiscalCalendar
where CurrentDt > @ARPostDt


select * from SOHeaerHist where [ARPostDt]=