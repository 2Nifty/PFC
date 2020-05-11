--Build Temp ERP Table for Vendor Secondary Contact Inserts
--Find records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContInsert
go

--[Porteous$Contact]
SELECT	CBR.[Business Relation Code],
	CBR.[Contact No_],
	CBR.[No_] AS VendNo,
	Contact.*
INTO	tERPVendContInsert
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	Contact.[No_] = CBR.[Contact No_]
WHERE	CBR.[Business Relation Code] = 'VEND' AND
	(NOT EXISTS	(SELECT	*
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))
go


---------------------------------------------------------


--Build Temp ERP Table for Vendor Primary Contact Inserts
--Find records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContInsert
go

--[Porteous$Contact]
SELECT	Vend.[Primary Contact No_],
	Vend.[No_] AS VendNo,
	Contact.*
INTO	tERPVendContInsert
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Vendor] Vend
ON	Contact.[No_] = Vend.[Primary Contact No_]
WHERE	(NOT EXISTS	(SELECT	*
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Vend.[Primary Contact No_]))
go


--============================================================


--Build Temp ERP Table for Vendor Secondary Contact Deletes
--Find records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContDelete
go

--[Porteous$Contact]
SELECT	'VEND' as [Business Relation Code],
	PERP.ContactNoNV as [Contact No_],
	PERP.*
INTO	tERPVendContDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous$Contact] Contact
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Contact.[No_]))
go


---------------------------------------------------------------

--Build Temp ERP Table for Vendor Primary Contact Deletes
--Find records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContDelete

--[Porteous$Contact]
SELECT	PERP.ContactNoNV as [Contact No_],
	PERP.*
INTO	tERPVendContDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorContact PERP
WHERE	(NOT EXISTS	(SELECT	Vend.[Primary Contact No_]
			 FROM	[Porteous$Contact] Contact INNER JOIN
				[Porteous$Vendor] Vend
			 ON	Contact.[No_] = Vend.[Primary Contact No_]
			 WHERE	PERP.ContactNoNV COLLATE Latin1_General_CS_AS = Vend.[Primary Contact No_]))
go



--============================================================


--Build Temp ERP Table for Vendor Primary Contact Updates
--Find modified Primary Contact records in NV5.0 based on [Last Modified Date] vs @LastDate from AppPref Table
--Uses OpenDataSource for AppPref table connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContUpdate
go

Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt')

--[Porteous$Contact]
SELECT	Vend.[Primary Contact No_] AS [Contact No_],
	Vend.[No_] AS VendNo,
	Contact.*
INTO	tERPVendContUpdate
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Vendor] Vend
ON	Contact.[No_] = Vend.[Primary Contact No_]
WHERE	Contact.[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
go








SELECT	Vend.[Primary Contact No_],
	Vend.[No_] AS VendNo,
	Contact.*
INTO	tERPVendContUpdate
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Vendor] Vend
ON	Contact.[No_] = Vend.[Primary Contact No_]


SELECT		[Vend].[Primary Contact No_] AS [Contact No_],
		[Contact5.0].*


---------------------------------------------------------------------










--============================================================

SELECT	Vend.[Primary Contact No_],
	Vend.[No_] AS VendNo,
	Contact.*
--INTO	tERPVendContInsert
FROM	[Porteous$Contact] Contact INNER JOIN
	[Porteous$Vendor] Vend
ON	Contact.[No_] = Vend.[Primary Contact No_]