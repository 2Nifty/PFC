SELECT	--Addr.pVendAddrID, Vend.pVendMstrID, Vend.VendNo, 
	--CBR.[Contact No_], CBR.[No_], CBR.[Business Relation Code],
	Addr.[pVendAddrID] AS fVendAddrID,
	VendIns.[Name] AS [Name],
	VendIns.[Job Title] AS JobTitle,
	VendIns.[Phone No_] AS Phone,
	VendIns.[Extension No_] AS PhoneExt,
	VendIns.[Fax No_] AS FaxNo,
	VendIns.[Mobile Phone No_] AS MobilePhone,
	VendIns.[E-Mail] AS EmailAddr,
	VendIns.[Type] AS Department,
	--[] AS DeleteDt,
	'WO1046_UpdateVendorMaster' AS EntryID,
	GETDATE() AS EntryDt,
	--[] AS ChangeID,
	VendIns.[Last Date Modified] AS ChangeDt,
	--[] AS StatusCd,
	CBR.[Contact No_] AS ContactNoNV
FROM	[tERPVendContInsert] VendIns INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_] = VendIns.[No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = CBR.[No_]




--Build Temp ERP Table for Vendor Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContInsert

--[Porteous$Contact]
--Find records that are in NV5.0 but not in NV3.7
SELECT		[CBR].[Business Relation Code], [CBR].[Contact No_], CBR.[No_] AS VendNo,
		[Contact5.0].*
--INTO		tERPVendContInsert



SELECT	Addr.pVendAddrID, 
	CBR.[Contact No_], CBR.[No_], CBR.[Business Relation Code],
	Addr.[pVendAddrID] AS fVendAddrID,
	[Contact5.0].[Name] AS [Name],
	[Contact5.0].[Job Title] AS JobTitle,
	[Contact5.0].[Phone No_] AS Phone,
	[Contact5.0].[Extension No_] AS PhoneExt,
	[Contact5.0].[Fax No_] AS FaxNo,
	[Contact5.0].[Mobile Phone No_] AS MobilePhone,
	[Contact5.0].[E-Mail] AS EmailAddr,
	[Contact5.0].[Type] AS Department,
	'WO1046_UpdateVendorMaster' AS EntryID,
	GETDATE() AS EntryDt,
	[Contact5.0].[Last Date Modified] AS ChangeDt,
	CBR.[Contact No_] AS ContactNoNV
FROM	[Porteous$Contact] [Contact5.0] INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	[Contact5.0].[No_] = CBR.[Contact No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = CBR.[No_]
WHERE	CBR.[Business Relation Code] = 'VEND' 




AND
		(NOT EXISTS	(SELECT	*
				 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Contact [Contact3.7]
				 WHERE	[Contact3.7].[No_] COLLATE Latin1_General_CS_AS = [Contact5.0].[No_]))









--Build Temp ERP Table for Vendor Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendContInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendContInsert

--[Porteous$Contact]
--Find records that are in NV5.0 but not in NV3.7


SELECT	Addr.[pVendAddrID] AS fVendAddrID,
	[Contact5.0].[Name] AS [Name],
	[Contact5.0].[Job Title] AS JobTitle,
	[Contact5.0].[Phone No_] AS Phone,
	[Contact5.0].[Extension No_] AS PhoneExt,
	[Contact5.0].[Fax No_] AS FaxNo,
	[Contact5.0].[Mobile Phone No_] AS MobilePhone,
	[Contact5.0].[E-Mail] AS EmailAddr,
	[Contact5.0].[Type] AS Department,
	'WO1046_UpdateVendorMaster' AS EntryID,
	GETDATE() AS EntryDt,
	[Contact5.0].[Last Date Modified] AS ChangeDt,
	[Contact5.0].[No_] AS ContactNoNV
FROM	[Porteous$Contact] [Contact5.0] INNER JOIN
	[Porteous$Vendor] Vend
ON	[Contact5.0].[No_] = Vend.[Primary Contact No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = Vend.[No_]




FROM		[Porteous$Contact] [Contact5.0] INNER JOIN
		[Porteous$Vendor] Vend
ON		[Contact5.0].[No_] = Vend.[Primary Contact No_]




WHERE		(NOT EXISTS	(SELECT	*
				 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Contact [Contact3.7]
				 WHERE	[Contact3.7].[No_] COLLATE Latin1_General_CS_AS = [Contact5.0].[No_]))
