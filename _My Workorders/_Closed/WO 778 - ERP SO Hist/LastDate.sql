
Declare	@LastDate DATETIME

SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	PFCReports.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
		     WHERE	ApplicationCd = 'SOE' AND AppOptionType = 'LastDate')

--SELECT	@LastDate
--Select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)), 
--	 CAST(DATEPART(yyyy,Getdate()) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()) AS varchar(2))


--WHERE	[Posting Date] > CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))






----*UPDATE AppPref Record for Invoices
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
--UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue = (SELECT   MAX([Posting Date])
			  FROM     [Porteous$Sales Invoice Header]),
	ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'SOE' AND AppOptionType = 'LastInvoiceDate'


----*UPDATE AppPref Record for Credits
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
--UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue = (SELECT   MAX([Posting Date])
			  FROM     [Porteous$Sales Cr_Memo Header]),
	ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'SOE' AND AppOptionType = 'LastCrDate'







Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-01'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*) as Headers, SUM(TotalOrder) as Price, SUM(TotalCost) as Cost from SOHeaderHist 
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


SELECT     COUNT(*)
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))

