--select * from UCOR_UserSetup

--UPDATE OrderLoc  (PFCQuote.Umbrella)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
SET	OrderLoc = [CompanyID]
FROM	(SELECT	DISTINCT UserName, CompanyID
	 FROM	UCOR_UserSetup INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
	 ON	UserName = EntryID) Loc
WHERE	Loc.UserName = EntryID





select * from UCOR_UserSetup


----------------------------------------------------------------------------------




select EntryID, OrderLoc, RefSONo AS SO, * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader order by RefSONo
--select EntryID, OrderLoc, RefSONo,* from SOHeader order by RefSONo

update OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader set OrderLoc=''
--update SOHeader set OrderLoc=''