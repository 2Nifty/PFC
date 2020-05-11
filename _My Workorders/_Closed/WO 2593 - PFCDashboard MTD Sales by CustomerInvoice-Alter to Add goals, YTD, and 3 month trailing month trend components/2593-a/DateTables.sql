
--SQLP v ERP

use PFCReports
go



--****CuvnalRanges
--Only appears to be updated on SQLP
--Should the one on PERP be deleted?
select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CuvnalRanges]



--****CuvnalFiscalCalendar
--Only exists on SQLP
select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalFiscalCalendar
--select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CuvnalFiscalCalendar]




--****FiscalCalendar
--2919 records in both
--2012-08-25 max date in both
select count(*) as RecCnt, max(CurrentDt) as MaxDt from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.FiscalCalendar
select count(*) as RecCnt, max(CurrentDt) as MaxDt from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[FiscalCalendar]



--Additionally, Charles and I discovered that the CustomerSalesForecast table exists on both SQLP and PERP but not only does it contain completely different data, the table structure is completely different.  Charles told me to use the one on PERP.  Is the table on SQLP valid?  Should it be deleted?
select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CustomerSalesForecast
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerSalesForecast

