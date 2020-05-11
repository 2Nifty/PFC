Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	PFCReports.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustCnvDt')
--select @LastDate


--Build Temp ERP Table for Customer Inserts

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustInsert

SELECT	*
INTO	[tERPCustInsert]
FROM	Porteous$Customer
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,Getdate()) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()) AS varchar(2)) and
	(NOT EXISTS (SELECT	*
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster] CustomerMaster
		     WHERE	CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))






-----------------------------------------------------------------------


Declare	@LastDate DATETIME

SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	PFCReports.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustCnvDt')

select @LastDate

--Build Temp ERP Table for Customer Inserts

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustInsert

SELECT	*
--INTO	[tERPCustInsert]
FROM	Porteous$Customer
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)) AND
	(NOT EXISTS (SELECT	*
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster] CustomerMaster
		     WHERE	CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))







--Build Temp ERP Table for Customer Inserts

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustInsert

SELECT	*
INTO	[tERPCustInsert]
FROM	Porteous$Customer
WHERE	[Last Date Modified] = CAST(DATEPART(yyyy,Getdate()) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()) AS varchar(2)) and
	(NOT EXISTS (SELECT	*
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster] CustomerMaster
		     WHERE	CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))









Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	PFCReports.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustCnvDt')
--select @LastDate


--Build Temp ERP Table for Customer Updates

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustUpdate

SELECT	*
INTO	[tERPCustUpdate]
FROM	Porteous$Customer
WHERE	(([Last Date Modified] > CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))) OR
	([Last Date Modified] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)) AND
	 CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2)) <= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)))) AND
		(EXISTS (SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster] CustomerMaster
			 WHERE	CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))






----*UPDATE AppPref Record
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.AppPref
--UPDATE	PFCReports.dbo.AppPref
SET	AppOptionValue = (SELECT  MAX([Last Date Modified])
			  FROM    Porteous$Customer),
	ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustCnvDt'
