
select * from tERPVendInsert

select * from tERPVendDelete


select * from tERPVendUpdate




select * from tERPVendContInsert

select * from tERPVendContDelete


select * from tERPVendContUpdate






--INSERTS: Find Secondary Contact records that are in NV5 but not in PERP
SELECT	CBR.[Business Relation Code],
	CBR.[Contact No_],
	CBR.[No_] AS VendNo,
	Contact.*
--INTO	tERPVendContInsert
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	Contact.[No_] = CBR.[Contact No_]
WHERE	CBR.[Business Relation Code] = 'VEND' AND
	(NOT EXISTS	(SELECT	PERP.ContactNoNV
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))



--DELETES: Find Secondary Contact records that are in PERP but not in NV5
SELECT	'VEND' as [Business Relation Code],
	PERP.ContactNoNV as [Contact No_],
	PERP.*
--INTO	tERPVendContDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	(NOT EXISTS	(SELECT	Contact.[No_]
			 FROM	[Porteous$Contact] Contact
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))


--Find modified Secondary Contact records in NV5.0 based on [Last Modified Date] vs @LastDate from AppPref Table

Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt')

--[Porteous$Contact]
SELECT	CBR.[Business Relation Code], CBR.[Contact No_],
	Contact.*
--INTO	tERPVendContUpdate
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	Contact.[No_] = CBR.[Contact No_]
WHERE	CBR.[Business Relation Code] = 'VEND' AND
	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))




----------------------------------------------------------------------------------------------



--Find Contact records that are in NV5 but not in PERP

SELECT DISTINCT *
FROM	(SELECT	CBR.[Contact No_],
		CBR.[No_] AS VendNo,
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Contact Business Relation] CBR
	 ON	Contact.[No_] = CBR.[Contact No_]
	 WHERE	CBR.[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT	PERP.ContactNoNV
--				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))) Secondary
UNION
	(SELECT	Vend.[Primary Contact No_] as [Contact No_],
		Vend.[No_] AS VendNo,
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Vendor] Vend
	 ON	Contact.[No_] = Vend.[Primary Contact No_]
	 WHERE	(NOT EXISTS	(SELECT	PERP.ContactNoNV
--				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Vend.[Primary Contact No_])))
go





Contact.[Name],
Contact.[Job Title],
Contact.[Phone No_],
Contact.[Extension No_],
Contact.[Fax No_],
Contact.[Mobile Phone No_],
Contact.[E-Mail],
Contact.[Type],
Contact.[Last Date Modified]




-------------------------------------------------------------------------

tERPVendContDelete




--Find Secondary Contact records that are in PERP but not in NV5
SELECT	PERP.ContactNoNV as [Contact No_],
	PERP.*
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	(NOT EXISTS	(SELECT	Contact.[No_]
			 FROM	[Porteous$Contact] Contact
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))





--Build Temp ERP Table for Vendor Contact Deletes
--Find Contact records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContDelete
go

--Find Contact records that are in PERP but not in NV5
SELECT	PERP.ContactNoNV as [Contact No_],
	PERP.*
INTO	tERPVendContDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS NOT IN
	(SELECT	DISTINCT *
	 FROM	(SELECT	DISTINCT Contact.[No_] as [Contact No_]
		 FROM	[Porteous$Contact] Contact) Secondary UNION
		(SELECT	DISTINCT Vend.[Primary Contact No_] as [Contact No_]
		 FROM	[Porteous$Contact] Contact INNER JOIN
			[Porteous$Vendor] Vend
		 ON	Contact.[No_] = Vend.[Primary Contact No_]))
go



--------------------------------------------------------------------------------------------------

--Build Temp ERP Table for Vendor Contact Updates
--Find modified Contact records in NV5.0 based on [Last Modified Date] vs @LastDate from AppPref Table
--Uses OpenDataSource for AppPref table connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContUpdate
go

Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt')

SELECT	DISTINCT *
INTO	tERPVendContUpdate
FROM	(SELECT	CBR.[Contact No_],
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Contact Business Relation] CBR
	 ON	Contact.[No_] = CBR.[Contact No_]
	 WHERE	CBR.[Business Relation Code] = 'VEND' AND
		[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))) Secondary
UNION
	(SELECT	Vend.[Primary Contact No_] AS [Contact No_],
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Vendor] Vend
	 ON	Contact.[No_] = Vend.[Primary Contact No_]
	 WHERE	Contact.[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)))
go




-------------------------------------------------


select * from [Porteous$Vendor] where No_='1002584'


--------------------------------------------------------

Step12: Add Secondary Contact Inserts to PERP.VendorContact

--Add Contact Inserts to PERP.VendorContact
--Uses OpenDataSource for PERP.VendorAddress

SELECT	Addr.[pVendAddrID] AS fVendAddrID,
	VendIns.[Name] AS [Name],
	VendIns.[Job Title] AS JobTitle,
	VendIns.[Phone No_] AS Phone,
	VendIns.[Extension No_] AS PhoneExt,
	VendIns.[Fax No_] AS FaxNo,
	VendIns.[Mobile Phone No_] AS MobilePhone,
	VendIns.[E-Mail] AS EmailAddr,
	VendIns.[Type] AS Department,
	--[] AS DeleteDt,
	'WO1046_VendorContactINS' AS EntryID,
	GETDATE() AS EntryDt,
	--[] AS ChangeID,
	VendIns.[Last Date Modified] AS ChangeDt,
	--[] AS StatusCd,
	VendIns.[Contact No_] AS ContactNoNV
FROM	[tERPVendContInsert] VendIns INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = VendIns.[Contact No_]





select * from tERPVendContInsert







--SET VendorAddress.fVendContactID
UPDATE	VendorAddress
SET	fVendContactID = pVendContactID
FROM	VendorAddress Addr INNER JOIN
	VendorContact Cont
ON	Cont.fVendAddrID = Addr.pVendAddrID
WHERE	fVendContactID IS NULL

----SET VendorAddress.fVendContactID (Primary Contacts)
--UPDATE	VendorAddress
--SET	fVendContactID = pVendContactID
--FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] Vend INNER JOIN
--	VendorContact Cont
--ON	Cont.ContactNoNV = Vend.[Primary Contact No_]
--WHERE	pVendAddrID=fVendAddrID






--Build Temp ERP Table for Vendor Inserts
--Find Vendor records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert
go

SELECT	*
INTO	tERPVendInsert
FROM	[Porteous$Vendor] NV5 (NoLock)
WHERE	(NOT EXISTS	(SELECT	PERP.VendNo
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
			 WHERE	NV5.[No_] COLLATE Latin1_General_CS_AS = PERP.VendNo AND isnull(PERP.DeleteDt,'') = ''))
go






--Build Temp ERP Table for Vendor Contact Inserts
--Find Contact records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContInsert
go

SELECT	DISTINCT *
INTO	tERPVendContInsert
FROM	(SELECT	CBR.[Contact No_],
		CBR.[No_] AS VendNo,
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Contact Business Relation] CBR
	 ON	Contact.[No_] = CBR.[Contact No_]
	 WHERE	CBR.[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT	PERP.ContactNoNV
--				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))) Secondary
UNION
	(SELECT	Vend.[Primary Contact No_] as [Contact No_],
		Vend.[No_] AS VendNo,
		Contact.[Name],
		Contact.[Job Title],
		Contact.[Phone No_],
		Contact.[Extension No_],
		Contact.[Fax No_],
		Contact.[Mobile Phone No_],
		Contact.[E-Mail],
		CASE Contact.Type
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Type,
		Contact.[Last Date Modified]
	 FROM	[Porteous$Contact] Contact INNER JOIN
		[Porteous$Vendor] Vend
	 ON	Contact.[No_] = Vend.[Primary Contact No_]
	 WHERE	(NOT EXISTS	(SELECT	PERP.ContactNoNV
--				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
				 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Vend.[Primary Contact No_])))
go






--Add Contact Inserts to PERP.VendorContact
--Uses OpenDataSource for PERP.VendorAddress

SELECT	Addr.[pVendAddrID] AS fVendAddrID,
	VendIns.[Name] AS [Name],
	VendIns.[Job Title] AS JobTitle,
	VendIns.[Phone No_] AS Phone,
	VendIns.[Extension No_] AS PhoneExt,
	VendIns.[Fax No_] AS FaxNo,
	VendIns.[Mobile Phone No_] AS MobilePhone,
	VendIns.[E-Mail] AS EmailAddr,
	VendIns.[Type] AS Department,
	--[] AS DeleteDt,
	'WO1046_VendorContactINS' AS EntryID,
	GETDATE() AS EntryDt,
	--[] AS ChangeID,
	VendIns.[Last Date Modified] AS ChangeDt,
	--[] AS StatusCd,
	VendIns.[Contact No_] AS ContactNoNV
FROM	[tERPVendContInsert] VendIns INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = VendIns.[VendNo]
WHERE	isnull(Addr.DeleteDt,'') = ''



select * from tERPVendContInsert



--select *
delete
from
[Porteous$Vendor] where No_='0001645'


--select *
delete 
from [Porteous$Contact] where No_='CT023704'



--Build Temp ERP Table for Vendor Contact Deletes
--Find Contact records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContDelete
go

--Find Contact records that are in PERP but not in NV5
SELECT	PERP.ContactNoNV as [Contact No_],
	PERP.*
INTO	tERPVendContDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS NOT IN
	(SELECT	DISTINCT *
	 FROM	(SELECT	DISTINCT Contact.[No_] as [Contact No_]
		 FROM	[Porteous$Contact] Contact) Secondary UNION
		(SELECT	DISTINCT Vend.[Primary Contact No_] as [Contact No_]
		 FROM	[Porteous$Contact] Contact INNER JOIN
			[Porteous$Vendor] Vend
		 ON	Contact.[No_] = Vend.[Primary Contact No_]))
go




--Set VendorMaster & VendorAddress DeleteDt for Vendor Deletes
--Uses OpenDataSource for NV5 connection

UPDATE	VendorMaster
SET	DeleteDt = GetDate(),
	ChangeID = 'WO1046_VendorMasterDEL',
	ChangeDt = GETDATE()
WHERE	isnull(VendorAddress.DeleteDt,'') = '' AND
	(EXISTS	(SELECT	*
--		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendDelete VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendDelete VendDel
		 WHERE	VendDel.VendNo = [VendorMaster].VendNo COLLATE Latin1_General_CS_AS))
go

UPDATE	VendorAddress
SET	DeleteDt = GetDate(),
	ChangeID = 'WO1046_VendorAddressDEL',
	ChangeDt = GETDATE()
FROM	VendorAddress INNER JOIN
	VendorMaster
ON	pVendMstrID = fVendMstrID
WHERE	isnull(VendorAddress.DeleteDt,'') = '' AND
	(EXISTS	(SELECT	*
--		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendDelete VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendDelete VendDel
		 WHERE	VendDel.VendNo = [VendorMaster].VendNo COLLATE Latin1_General_CS_AS))
go






--Set VendorContact.DeleteDt for Secondary Contact Deletes
--Uses OpenDataSource for NV5 connection

UPDATE	VendorContact
SET	DeleteDt = GetDate(),
	ChangeID = 'WO1046_VendorContactDEL',
	ChangeDt = GETDATE()
WHERE	isnull(VendorContact.DeleteDt,'') = '' AND
	(EXISTS	(SELECT	*
		 --FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendContDelete VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendContDelete VendDel
		 WHERE	VendDel.[Contact No_] = VendorContact.ContactNoNV COLLATE Latin1_General_CS_AS))
go
