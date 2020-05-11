select * from [Porteous$Sales Invoice Header] where [ERP Upload Flag]=0 
order by No_


select * from [Porteous$Sales Cr_Memo Header] where [ERP Upload Flag]=0 



update [Porteous$Sales Invoice Header]
set [ERP Upload Flag]=1
where [ERP Upload Flag]=0

update [Porteous$Sales Cr_Memo Header]
set [ERP Upload Flag]=1
where [ERP Upload Flag]=0



update [Porteous$Sales Invoice Header]
set [ERP Upload Flag]=0
where No_='IP2896247'
or No_='IP2896248'
or No_='IP2896249'
or No_='IP2896250'


IP2896247
IP2896248
IP2896249
IP2896250




select ARpostDt, * from PFCReports.dbo.tWO778_SOHeaderHist

select * from PFCReports.dbo.tWO778_SODetailHist

select * from PFCReports.dbo.tWO778_SOExpenseHist




DECLARE	@LastDt VARCHAR(20),
	@NewDt VARCHAR(20),
	@ARPostDt VARCHAR(20)

--Get Last Posting Date from AppPref
SELECT	@LastDt = AppOptionValue FROM PFCReports.dbo.AppPref WHERE ApplicationCd='SOE' and AppOptionType='ARPostDt'

--Determine Next Posting Date from FiscalCalendar where WorkDay=1
SELECT	@NewDt = MIN(CurrentDt) FROM PFCReports.dbo.FiscalCalendar WHERE CurrentDt > @LastDt AND WorkDay=1

--If the Current Date is less than the Next Posting Date
--   then use the Last Posting Date
--   else use the Next Posting Date
IF (GETDATE() < @NewDt)
   SET @ARPostDt = @LastDt
   ELSE SET @ARPostDt = @NewDt

Select @LastDt as LastDt, @NewDt as NewDt, @ArPostDt as ARPostDt






SELECT	AppOptionValue, * FROM PFCReports.dbo.AppPref WHERE ApplicationCd='SOE' and AppOptionType='ARPostDt'



--Update AppPref with the Posting Date that was used
UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue=CAST(FLOOR( CAST( GetDate()-1 AS FLOAT ) )AS DATETIME), ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='ARPostDt'



--Update AppPref with the Posting Date that was used
UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue=CAST(FLOOR( CAST( GetDate()-2 AS FLOAT ) )AS DATETIME), ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='ARPostDt'







select InvoiceNo, ARPostDt, * from PFCReports.dbo.SOHeaderHist
where InvoiceNo > 'IP2896237' and left(InvoiceNo,2)='IP'
order by InvoiceNo