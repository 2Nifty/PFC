
--[Porteous$Contact]
--Find records that are in NV5.0 but not in NV3.7
SELECT		--CBR.[Business Relation Code], CBR.[Contact No_],
		[Contact5.0].*
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		[Contact5.0].[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT	*
				 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Contact [Contact3.7]
				 WHERE	[Contact3.7].[No_] COLLATE Latin1_General_CS_AS = [Contact5.0].[No_]))


select * from 
OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation]
--[Porteous$Contact Business Relation]
WHERE		[Business Relation Code] = 'VEND'




--[Porteous$Contact]
--Find records that are in NV3.7 but not in NV5.0
SELECT		--CBR.[Business Relation Code], CBR.[Contact No_],
		[Contact3.7].*
--INTO		tERPVendDelete
FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] [Contact3.7]
INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] CBR
ON		[Contact3.7].[No_] = CBR.[Contact No_]
WHERE	--	CBR.[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT	*
				 FROM	[Porteous$Contact] [Contact5.0]
				 WHERE	[Contact3.7].[No_] COLLATE Latin1_General_CS_AS = [Contact5.0].[No_]))




--------------------------------------------
--Get Vendor Contact Updates--
--------------------------------------------

--SET @LastDate from AppPref Table
Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
		     FROM	PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastVendContactNV5.0CnvDt')
--SELECT @LastDate


--Build Temp ERP Table for Vendor Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendUpdate

--[Porteous$Contact]
--Find modified records in NV5.0 based on [Last Modified Date]
SELECT		--CBR.[Business Relation Code], CBR.[Contact No_],
		[Contact5.0].*
INTO		[tERPVendUpdate]
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		[Contact5.0].[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'VEND' AND
		[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)) --AND
--		DATEPART(yyyy,[Last Update])+DATEPART(mm,[Last Update])+DATEPART(dd,[Last Update])+DATEPART(hh,[Last Update])+DATEPART(mi,[Last Update]) <> DATEPART(yyyy,@LastDate)+DATEPART(mm,@LastDate)+DATEPART(dd,@LastDate)+DATEPART(hh,@LastDate)+DATEPART(mi,@LastDate)
--SELECT * FROM tERPVendUpdate


--Set [Last Update] and UPDATE AppPref Table
Declare	@LastUpdate DATETIME
SET	@LastUpdate = (SELECT GETDATE())
--SELECT @LastUpdate

UPDATE	PERP.dbo.AppPref
SET	AppOptionValue = @LastUpdate
WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastVendContactNV5.0CnvDt'

--SELECT * 
--FROM	[Porteous$Contact]
--WHERE	(EXISTS	(SELECT	*
--		 FROM	[tERPVendUpdate]
--		 WHERE	[tERPVendUpdate].[No_] = [Porteous$Contact].[No_]))

--UPDATE	[Porteous$Contact]
--SET	[Last Update] = @LastUpdate
--WHERE	(EXISTS	(SELECT	*
--		 FROM	[tERPVendUpdate]
--		 WHERE	[tERPVendUpdate].[No_] = [Porteous$Contact].[No_]))




--Remove Contact Deletes from NV3.7 [Porteous$Contact]
DELETE
FROM	[Porteous$Contact]
WHERE	(EXISTS	(SELECT	*
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 WHERE	VendDel.[No_] = [Porteous$Contact].[No_] COLLATE Latin1_General_CS_AS))






--Process Contact Updates in NV3.7 [Porteous$Contact]
UPDATE	[Porteous$Contact]
SET	--[timestamp] = VendUpd.[timestamp],
	--[No_] = VendUpd.[No_],
	[Name] = VendUpd.[Name],
	[Search Name] = VendUpd.[Search Name],
	[Name 2] = VendUpd.[Name 2],
	[Address] = LEFT(VendUpd.[Address], 30),
	[Address 2] = LEFT(VendUpd.[Address 2], 30),
	[City] = VendUpd.[City],
	[Phone No_] = VendUpd.[Phone No_],
	[Telex No_] = VendUpd.[Telex No_],
	[Territory Code] = VendUpd.[Territory Code],
	[Currency Code] = VendUpd.[Currency Code],
	[Language Code] = VendUpd.[Language Code],
	[Salesperson Code] = VendUpd.[Salesperson Code],
	[Country Code] = VendUpd.[Country_Region Code],
	[Last Date Modified] = VendUpd.[Last Date Modified],
	[Fax No_] = VendUpd.[Fax No_],
	[Telex Answer Back] = VendUpd.[Telex Answer Back],
	[VAT Registration No_] = VendUpd.[VAT Registration No_],
	[Picture] = VendUpd.[Picture],
	[Post Code] = VendUpd.[Post Code],
	[County] = VendUpd.[County],
	[E-Mail] = VendUpd.[E-Mail],
	[Home Page] = VendUpd.[Home Page],
	[No_ Series] = VendUpd.[No_ Series],
	[Type] = VendUpd.[Type],
	[Company No_] = VendUpd.[Company No_],
	[Company Name] = VendUpd.[Company Name],
	[Lookup Contact No_] = VendUpd.[Lookup Contact No_],
	[First Name] = VendUpd.[First Name],
	[Middle Name] = VendUpd.[Middle Name],
	[Surname] = VendUpd.[Surname],
	[Job Title] = VendUpd.[Job Title],
	[Initials] = VendUpd.[Initials],
	[Extension No_] = VendUpd.[Extension No_],
	[Mobile Phone No_] = VendUpd.[Mobile Phone No_],
	[Pager] = VendUpd.[Pager],
	[Organizational Level Code] = VendUpd.[Organizational Level Code],
	[Exclude from Segment] = VendUpd.[Exclude from Segment],
	[External ID] = VendUpd.[External ID],
	[Correspondence Type] = VendUpd.[Correspondence Type],
	[Salutation Code] = VendUpd.[Salutation Code],
	[Search E-Mail] = VendUpd.[Search E-Mail],
	--[Version No_] = VendUpd.[],
	[Last Time Modified] = VendUpd.[Last Time Modified] --,
	--[] = VendUpd.[E-Mail 2],
	--[Password] = VendUpd.[],
	--[Password Padding] = VendUpd.[],
	--[Login ID] = VendUpd.[],
	--[Notification Process Code] = VendUpd.[],
	--[Enablement Date] = VendUpd.[],
	--[Queue Priority] = VendUpd.[],
	--[Online User Type] = VendUpd.[],
	--[On Behalf Of] = VendUpd.[],
	--[Catalog Set] = VendUpd.[],
	--[eConnect User] = VendUpd.[],
	--[eConnect Password] = VendUpd.[],
	--[eConnect Default Whse] = VendUpd.[],
	--[eConnect Order Limit] = VendUpd.[],
	--[eConnect Preference 1] = VendUpd.[],
	--[eConnect Preference 2] = VendUpd.[],
	--[eConnect Preference 3] = VendUpd.[],
	--[eConnect Preference 4] = VendUpd.[],
	--[eConnect Preference 5] = VendUpd.[],
	--[eConnect Preference 6] = VendUpd.[],
	--[eConnect Preference 7] = VendUpd.[],
	--[eConnect Preference 8] = VendUpd.[],
	--[eConnect Preference 9] = VendUpd.[],
	--[eConnect User Type] = VendUpd.[],
	--[eConnect On Behalf Of] = VendUpd.[],
	--[eConnect Roles] = VendUpd.[],
	--[Drop Ship] = VendUpd.[]
FROM	[Porteous$Contact] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd ON
	VendUpd.[No_] = [Porteous$Contact].[No_] COLLATE Latin1_General_CS_AS





