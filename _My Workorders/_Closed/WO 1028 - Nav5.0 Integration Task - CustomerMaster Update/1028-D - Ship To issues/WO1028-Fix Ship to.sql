
select * from [Porteous$Customer]
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster]


select * 
FROM	Porteous$Customer Cust  INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON Cust.[No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS



--Primary Ship-To Addresses
SELECT	'DSHP' AS Type,
	ERPCust.pCustMstrID AS fCustomerMasterID,
	Cust.[Name 2] AS Name2,
	Cust.[Address] AS AddrLine1,
	Cust.[Address 2] AS AddrLine2,
	Cust.[City] AS City,
	Cust.[County] AS State,
	Cust.[Post Code] AS PostCd,
	Cust.[Country Code] AS Country,
	Cust.[Phone No_] AS PhoneNo,
	Cust.[Contact] AS CustContacts,
	CAST(Cust.[UPS Zone] AS Int) AS UPSZone,
	Cust.[Fax No_] AS FaxPhoneNo,
	Cust.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	Cust.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	CASE Cust.[Name]
	   WHEN '' THEN Cust.[Name 2]
		   ELSE Cust.[Name]
	END AS Name1
FROM	Porteous$Customer Cust LEFT OUTER JOIN
	Porteous$Location Loc ON Cust.[Shipping Location] = Loc.[Code] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON Cust.[No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS



--Primary Ship-To Addresses
SELECT	'SHP' AS Type,
	ERPCust.pCustMstrID AS fCustomerMasterID,
	ShipTo.[Name 2] AS Name2,
	ShipTo.[Address] AS AddrLine1,
	ShipTo.[Address 2] AS AddrLine2,
	ShipTo.[City] AS City,
	ShipTo.[County] AS State,
	ShipTo.[Post Code] AS PostCd,
	ShipTo.[Country Code] AS Country,
	ShipTo.[Phone No_] AS PhoneNo,
	ShipTo.[Contact] AS CustContacts,
	CAST(ShipTo.[UPS Zone] AS Int) AS UPSZone,
	ShipTo.[Fax No_] AS FaxPhoneNo,
	ShipTo.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	ShipTo.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	CASE ShipTo.[Name]
	   WHEN '' THEN ShipTo.[Name 2]
		   ELSE ShipTo.[Name]
	END AS Name1
FROM	[Porteous$Ship-to Address] ShipTo INNER JOIN
	Porteous$Customer Cust ON [Customer No_] = Cust.[No_] LEFT OUTER JOIN
	Porteous$Location Loc ON Cust.[Shipping Location] = Loc.[Code] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON [Customer No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS


select * from [Porteous$Ship-to Address]
select * from [Porteous$Customer]





--Primary Ship-To Addresses
SELECT	'DSHP' AS Type,
	ERPCust.pCustMstrID AS fCustomerMasterID,
	ShipTo.[Name 2] AS Name2,
	ShipTo.[Address] AS AddrLine1,
	ShipTo.[Address 2] AS AddrLine2,
	ShipTo.[City] AS City,
	ShipTo.[County] AS State,
	ShipTo.[Post Code] AS PostCd,
	ShipTo.[Country Code] AS Country,
	ShipTo.[Phone No_] AS PhoneNo,
	ShipTo.[Contact] AS CustContacts,
	CAST(ShipTo.[UPS Zone] AS Int) AS UPSZone,
	ShipTo.[Fax No_] AS FaxPhoneNo,
	ShipTo.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	ShipTo.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	CASE ShipTo.[Name]
	   WHEN '' THEN ShipTo.[Name 2]
		   ELSE ShipTo.[Name]
	END AS Name1
FROM	[Porteous$Ship-to Address] ShipTo INNER JOIN
	(SELECT	[Customer No_] AS PrimaryCust, MIN(Code) AS PrimaryCode from [Porteous$Ship-to Address]
	 GROUP BY [Customer No_]) PrimaryAddr ON [Customer No_] = PrimaryCust AND [Code] = PrimaryCode INNER JOIN
	Porteous$Customer Cust ON [Customer No_] = Cust.[No_] LEFT OUTER JOIN
	Porteous$Location Loc ON Cust.[Shipping Location] = Loc.[Code] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON [Customer No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS




--Alternate Ship-To Addresses
SELECT	'SHP' AS Type,
	ERPCust.pCustMstrID AS fCustomerMasterID,
	ShipTo.[Name 2] AS Name2,
	ShipTo.[Address] AS AddrLine1,
	ShipTo.[Address 2] AS AddrLine2,
	ShipTo.[City] AS City,
	ShipTo.[County] AS State,
	ShipTo.[Post Code] AS PostCd,
	ShipTo.[Country Code] AS Country,
	ShipTo.[Phone No_] AS PhoneNo,
	ShipTo.[Contact] AS CustContacts,
	CAST(ShipTo.[UPS Zone] AS Int) AS UPSZone,
	ShipTo.[Fax No_] AS FaxPhoneNo,
	ShipTo.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	ShipTo.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	CASE ShipTo.[Name]
	   WHEN '' THEN ShipTo.[Name 2]
		   ELSE ShipTo.[Name]
	END AS Name1
FROM	[Porteous$Ship-to Address] ShipTo INNER JOIN
	(SELECT	[Customer No_] AS PrimaryCust, MIN(Code) AS PrimaryCode from [Porteous$Ship-to Address]
	 GROUP BY [Customer No_]) PrimaryAddr ON [Customer No_] = PrimaryCust AND [Code] <> PrimaryCode INNER JOIN
	Porteous$Customer Cust ON [Customer No_] = Cust.[No_] LEFT OUTER JOIN
	Porteous$Location Loc ON Cust.[Shipping Location] = Loc.[Code] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON [Customer No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS
