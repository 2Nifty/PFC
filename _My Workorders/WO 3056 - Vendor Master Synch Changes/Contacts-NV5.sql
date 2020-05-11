--3676 total
--3343 distinct



--3122
--secondary



SELECT	DISTINCT
	*
FROM	(SELECT	Addr.[pVendAddrID] AS fVendAddrID,
		[Contact5.0].[Name] AS [Name],
		[Contact5.0].[Job Title] AS JobTitle,
		[Contact5.0].[Phone No_] AS Phone,
		[Contact5.0].[Extension No_] AS PhoneExt,
		[Contact5.0].[Fax No_] AS FaxNo,
		[Contact5.0].[Mobile Phone No_] AS MobilePhone,
		[Contact5.0].[E-Mail] AS EmailAddr,
		CASE [Contact5.0].[Type]
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Department,
		'WO3056_VendorContactLoad' AS EntryID,
		CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) AS EntryDt,
		[Contact5.0].[Last Date Modified] AS ChangeDt,
		CBR.[Contact No_] AS ContactNoNV
	 FROM	[Porteous$Contact] [Contact5.0] INNER JOIN
		[Porteous$Contact Business Relation] CBR
	 ON	[Contact5.0].[No_] = CBR.[Contact No_] INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
	 ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = CBR.[No_]
	 WHERE	CBR.[Business Relation Code] = 'VEND') Secondary
UNION
	(SELECT	Addr.[pVendAddrID] AS fVendAddrID,
		[Contact5.0].[Name] AS [Name],
		[Contact5.0].[Job Title] AS JobTitle,
		[Contact5.0].[Phone No_] AS Phone,
		[Contact5.0].[Extension No_] AS PhoneExt,
		[Contact5.0].[Fax No_] AS FaxNo,
		[Contact5.0].[Mobile Phone No_] AS MobilePhone,
		[Contact5.0].[E-Mail] AS EmailAddr,
		CASE [Contact5.0].[Type]
			WHEN 0 THEN 'Company'
			WHEN 1 THEN 'Person'
			ELSE 'UNDEFINED'
		END as Department,
		'WO3056_VendorContactLoad' AS EntryID,
		CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) AS EntryDt,
		[Contact5.0].[Last Date Modified] AS ChangeDt,
		[Contact5.0].[No_] AS ContactNoNV
	 FROM	[Porteous$Contact] [Contact5.0] INNER JOIN
		[Porteous$Vendor] Vend
	 ON	[Contact5.0].[No_] = Vend.[Primary Contact No_] INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr
	 ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = Vend.[No_])
go

