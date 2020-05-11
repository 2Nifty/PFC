--select MIN(Code) from

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
	ShipTo.[UPS Zone] AS UPSZone,
	ShipTo.[Fax No_] AS FaxPhoneNo,
	ShipTo.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	ShipTo.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	ShipTo.[Name] AS Name1
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
	ShipTo.[UPS Zone] AS UPSZone,
	ShipTo.[Fax No_] AS FaxPhoneNo,
	ShipTo.[E-Mail] AS Email,
	Cust.[Last Modified By] AS EntryID,
	Cust.[Account Opened] AS EntryDt,
	Cust.[Last Modified By] AS ChangeID,
	ShipTo.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	ShipTo.[Name] AS Name1
FROM	[Porteous$Ship-to Address] ShipTo INNER JOIN
	(SELECT	[Customer No_] AS PrimaryCust, MIN(Code) AS PrimaryCode from [Porteous$Ship-to Address]
	 GROUP BY [Customer No_]) PrimaryAddr ON [Customer No_] = PrimaryCust AND [Code] <> PrimaryCode INNER JOIN
	Porteous$Customer Cust ON [Customer No_] = Cust.[No_] LEFT OUTER JOIN
	Porteous$Location Loc ON Cust.[Shipping Location] = Loc.[Code] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust ON [Customer No_] = ERPCust.CustNo Collate SQL_Latin1_General_CP1_CI_AS

--------------------------------------------------------------------------


select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] 



SELECT	ShipTo.*
FROM	[Porteous$Ship-to Address] ShipTo INNER JOIN
	(SELECT	[Customer No_] AS AltCust, MIN(Code) AS AltCode from [Porteous$Ship-to Address]
	 GROUP BY [Customer No_]) AltAddr ON [Customer No_] = AltCust AND [Code] <> AltCode




order by [Customer No_]



select * from  [Porteous$Ship-to Address]