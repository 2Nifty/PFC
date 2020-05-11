
--UPDATE [Porteous$Vendor]
--SET	[Name]=LEFT([Name],40),
--	[Search Name]=LEFT([Search Name],40),
--	[City]=LEFT([City],20),
--	[County]=LEFT([County],2),
--	[Post Code]=LEFT([Post Code],10),
--	[Phone No_]=LEFT([Phone No_],25)

--UPDATE [Porteous$Customer]
--SET	[Name]=LEFT([Name],40),
--	[Search Name]=LEFT([Search Name],40),
--	[City]=LEFT([City],20),
--	[County]=LEFT([County],2),
--	[Post Code]=LEFT([Post Code],10),
--	[Phone No_]=LEFT([Phone No_],25)


--UPDATE [Porteous$Ship-to Address]
--SET	[Name]=LEFT([Name],40),
--	[City]=LEFT([City],20),
--	[County]=LEFT([County],2),
--	[Post Code]=LEFT([Post Code],10),
--	[Phone No_]=LEFT([Phone No_],25)




select	[No_] AS CustNo,
	CASE 
	     WHEN LEN([Name]) > 40
		THEN [Name]
		ELSE ''
	END AS [Name (Max 40)], 
	CASE 
	     WHEN LEN([Name]) > 40
		THEN CAST (LEN([Name]) AS VARCHAR(5))
		ELSE ''
	END AS NameLen,

	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN [Name 2]
		ELSE ''
	END AS [Name 2 (Max 40)], 
	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN CAST (LEN([Name 2]) AS VARCHAR(5))
		ELSE ''
	END AS Name2Len,

	CASE 
	     WHEN LEN([Search Name]) > 40
		THEN [Search Name]
		ELSE ''
	END AS [Search Name (Max 40)], 
	CASE 
	     WHEN LEN([Search Name]) > 40
		THEN CAST (LEN([Search Name]) AS VARCHAR(5))
		ELSE ''
	END AS SearchNameLen,

	CASE 
	     WHEN LEN([Address]) > 40
		THEN [Address]
		ELSE ''
	END AS [Address (Max 40)], 
	CASE 
	     WHEN LEN([Address]) > 40
		THEN CAST (LEN([Address]) AS VARCHAR(5))
		ELSE ''
	END AS AddressLen,

	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN [Address 2]
		ELSE ''
	END AS [Address 2 (Max 40)], 
	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN CAST (LEN([Address 2]) AS VARCHAR(5))
		ELSE ''
	END AS Address2Len,

	CASE 
	     WHEN LEN([Contact]) > 30
		THEN [Contact]
		ELSE ''
	END AS [Contact (Max 30)], 
	CASE 
	     WHEN LEN([Contact]) > 30
		THEN CAST (LEN([Contact]) AS VARCHAR(5))
		ELSE ''
	END AS ContactLen,

	CASE 
	     WHEN LEN([City]) > 20
		THEN [City]
		ELSE ''
	END AS [City (Max 20)], 
	CASE 
	     WHEN LEN([City]) > 20
		THEN CAST (LEN([City]) AS VARCHAR(5))
		ELSE ''
	END AS CityLen,

	CASE 
	     WHEN LEN([County]) > 2
		THEN [County]
		ELSE ''
	END AS [County (State - Max 2)], 
	CASE 
	     WHEN LEN([County]) > 2
		THEN CAST (LEN([County]) AS VARCHAR(5))
		ELSE ''
	END AS CountyLen,

	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN [Post Code]
		ELSE ''
	END AS [Post Code (Max 10)], 
	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN CAST (LEN([Post Code]) AS VARCHAR(5))
		ELSE ''
	END AS PostCodeLen,

	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen

FROM	[Porteous$Customer]
WHERE	LEN([Name]) > 40 or LEN([Name 2]) > 40 or LEN([Search Name]) > 40 or LEN(Address) > 40 or LEN([Address 2]) > 40 or 
	LEN(Contact) > 30 or LEN(City) > 20 or LEN([County]) > 2 or LEN([Post Code]) > 10 or LEN([Phone No_]) > 25 or LEN([Fax No_]) > 25






select	[Customer No_] AS CustNo,
	CASE 
	     WHEN LEN([Name]) > 40
		THEN [Name]
		ELSE ''
	END AS [Name (Max 40)], 
	CASE 
	     WHEN LEN([Name]) > 40
		THEN CAST (LEN([Name]) AS VARCHAR(5))
		ELSE ''
	END AS NameLen,

	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN [Name 2]
		ELSE ''
	END AS [Name 2 (Max 40)], 
	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN CAST (LEN([Name 2]) AS VARCHAR(5))
		ELSE ''
	END AS Name2Len,

	CASE 
	     WHEN LEN([Address]) > 40
		THEN [Address]
		ELSE ''
	END AS [Address (Max 40)], 
	CASE 
	     WHEN LEN([Address]) > 40
		THEN CAST (LEN([Address]) AS VARCHAR(5))
		ELSE ''
	END AS AddressLen,

	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN [Address 2]
		ELSE ''
	END AS [Address 2 (Max 40)], 
	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN CAST (LEN([Address 2]) AS VARCHAR(5))
		ELSE ''
	END AS Address2Len,

	CASE 
	     WHEN LEN([Contact]) > 30
		THEN [Contact]
		ELSE ''
	END AS [Contact (Max 30)], 
	CASE 
	     WHEN LEN([Contact]) > 30
		THEN CAST (LEN([Contact]) AS VARCHAR(5))
		ELSE ''
	END AS ContactLen,

	CASE 
	     WHEN LEN([City]) > 20
		THEN [City]
		ELSE ''
	END AS [City (Max 20)], 
	CASE 
	     WHEN LEN([City]) > 20
		THEN CAST (LEN([City]) AS VARCHAR(5))
		ELSE ''
	END AS CityLen,

	CASE 
	     WHEN LEN([County]) > 2
		THEN [County]
		ELSE ''
	END AS [County (State - Max 2)], 
	CASE 
	     WHEN LEN([County]) > 2
		THEN CAST (LEN([County]) AS VARCHAR(5))
		ELSE ''
	END AS CountyLen,

	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN [Post Code]
		ELSE ''
	END AS [Post Code (Max 10)], 
	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN CAST (LEN([Post Code]) AS VARCHAR(5))
		ELSE ''
	END AS PostCodeLen,

	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen

FROM	[Porteous$Ship-to Address]
WHERE	LEN([Name]) > 40 or LEN([Name 2]) > 40 or LEN(Address) > 40 or LEN([Address 2]) > 40 or 
	LEN(Contact) > 30 or LEN(City) > 20 or LEN([County]) > 2 or LEN([Post Code]) > 10 or LEN([Phone No_]) > 25 or LEN([Fax No_]) > 25






select	[No_] AS VendNo,
	CASE 
	     WHEN LEN([Name]) > 40
		THEN [Name]
		ELSE ''
	END AS [Name (Max 40)], 
	CASE 
	     WHEN LEN([Name]) > 40
		THEN CAST (LEN([Name]) AS VARCHAR(5))
		ELSE ''
	END AS NameLen,

	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN [Name 2]
		ELSE ''
	END AS [Name 2 (Max 40)], 
	CASE 
	     WHEN LEN([Name 2]) > 40
		THEN CAST (LEN([Name 2]) AS VARCHAR(5))
		ELSE ''
	END AS Name2Len,

	CASE 
	     WHEN LEN([Search Name]) > 40
		THEN [Search Name]
		ELSE ''
	END AS [Search Name (Max 40)], 
	CASE 
	     WHEN LEN([Search Name]) > 40
		THEN CAST (LEN([Search Name]) AS VARCHAR(5))
		ELSE ''
	END AS SearchNameLen,

	CASE 
	     WHEN LEN([Address]) > 40
		THEN [Address]
		ELSE ''
	END AS [Address (Max 40)], 
	CASE 
	     WHEN LEN([Address]) > 40
		THEN CAST (LEN([Address]) AS VARCHAR(5))
		ELSE ''
	END AS AddressLen,

	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN [Address 2]
		ELSE ''
	END AS [Address 2 (Max 40)], 
	CASE 
	     WHEN LEN([Address 2]) > 40
		THEN CAST (LEN([Address 2]) AS VARCHAR(5))
		ELSE ''
	END AS Address2Len,

	CASE 
	     WHEN LEN([Contact]) > 30
		THEN [Contact]
		ELSE ''
	END AS [Contact (Max 30)], 
	CASE 
	     WHEN LEN([Contact]) > 30
		THEN CAST (LEN([Contact]) AS VARCHAR(5))
		ELSE ''
	END AS ContactLen,

	CASE 
	     WHEN LEN([City]) > 20
		THEN [City]
		ELSE ''
	END AS [City (Max 20)], 
	CASE 
	     WHEN LEN([City]) > 20
		THEN CAST (LEN([City]) AS VARCHAR(5))
		ELSE ''
	END AS CityLen,

	CASE 
	     WHEN LEN([County]) > 2
		THEN [County]
		ELSE ''
	END AS [County (State - Max 2)], 
	CASE 
	     WHEN LEN([County]) > 2
		THEN CAST (LEN([County]) AS VARCHAR(5))
		ELSE ''
	END AS CountyLen,

	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN [Post Code]
		ELSE ''
	END AS [Post Code (Max 10)], 
	CASE 
	     WHEN LEN([Post Code]) > 10
		THEN CAST (LEN([Post Code]) AS VARCHAR(5))
		ELSE ''
	END AS PostCodeLen,

	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen

FROM	[Porteous$Vendor]
WHERE	LEN([Name]) > 40 or LEN([Name 2]) > 40 or LEN([Search Name]) > 40 or LEN(Address) > 40 or LEN([Address 2]) > 40 or 
	LEN(Contact) > 30 or LEN(City) > 20 or LEN([County]) > 2 or LEN([Post Code]) > 10 or LEN([Phone No_]) > 25 or LEN([Fax No_]) > 25






select	CBR.[No_] as VendNo, CBR.[Contact No_] as VendorContactNo,
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN [Extension No_]
		ELSE ''
	END AS [Extension No_ (Max 7)], 
	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN CAST (LEN([Extension No_]) AS VARCHAR(5))
		ELSE ''
	END AS ExtensionLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen,

	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN [Mobile Phone No_]
		ELSE ''
	END AS [Mobile Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN CAST (LEN([Mobile Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS MobilePhoneNoLen,

	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN [E-Mail]
		ELSE ''
	END AS [E-Mail (Max 25)], 
	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN CAST (LEN([E-Mail]) AS VARCHAR(5))
		ELSE ''
	END AS [E-MailLen]

from	[Porteous$Contact] CONT INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_]=CONT.[No_]
WHERE	CBR.[Business Relation Code] = 'VEND' AND
	(LEN([Phone No_]) > 25 or LEN([Extension No_]) > 7 or LEN([Fax No_]) > 25 or LEN([Mobile Phone No_]) > 25 or LEN([E-Mail]) > 50)







select	CBR.[No_] as CustNo, CBR.[Contact No_] as CustContactNo,
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN [Extension No_]
		ELSE ''
	END AS [Extension No_ (Max 7)], 
	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN CAST (LEN([Extension No_]) AS VARCHAR(5))
		ELSE ''
	END AS ExtensionLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen,

	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN [Mobile Phone No_]
		ELSE ''
	END AS [Mobile Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN CAST (LEN([Mobile Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS MobilePhoneNoLen,

	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN [E-Mail]
		ELSE ''
	END AS [E-Mail (Max 25)], 
	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN CAST (LEN([E-Mail]) AS VARCHAR(5))
		ELSE ''
	END AS [E-MailLen]

from	[Porteous$Contact] CONT INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_]=CONT.[No_]
WHERE	CBR.[Business Relation Code] = 'CUST' AND
	(LEN([Phone No_]) > 25 or LEN([Extension No_]) > 7 or LEN([Fax No_]) > 25 or LEN([Mobile Phone No_]) > 25 or LEN([E-Mail]) > 50)




select	CBR.[No_] as VendNo, CBR.[Contact No_] as VendorContactNo,
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN [Phone No_]
		ELSE ''
	END AS [Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Phone No_]) > 25
		THEN CAST (LEN([Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS PhoneNoLen,

	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN [Extension No_]
		ELSE ''
	END AS [Extension No_ (Max 7)], 
	CASE 
	     WHEN LEN([Extension No_]) > 7
		THEN CAST (LEN([Extension No_]) AS VARCHAR(5))
		ELSE ''
	END AS ExtensionLen,

	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN [Fax No_]
		ELSE ''
	END AS [Fax No_ (Max 25)], 
	CASE 
	     WHEN LEN([Fax No_]) > 25
		THEN CAST (LEN([Fax No_]) AS VARCHAR(5))
		ELSE ''
	END AS FaxNoLen,

	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN [Mobile Phone No_]
		ELSE ''
	END AS [Mobile Phone No_ (Max 25)], 
	CASE 
	     WHEN LEN([Mobile Phone No_]) > 25
		THEN CAST (LEN([Mobile Phone No_]) AS VARCHAR(5))
		ELSE ''
	END AS MobilePhoneNoLen,

	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN [E-Mail]
		ELSE ''
	END AS [E-Mail (Max 25)], 
	CASE 
	     WHEN LEN([E-Mail]) > 50
		THEN CAST (LEN([E-Mail]) AS VARCHAR(5))
		ELSE ''
	END AS [E-MailLen]

from	[Porteous$Contact] CONT INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_]=CONT.[No_]
WHERE	CBR.[Business Relation Code] <> 'VEND' AND CBR.[Business Relation Code] <> 'CUST' AND
	(LEN([Phone No_]) > 25 or LEN([Extension No_]) > 7 or LEN([Fax No_]) > 25 or LEN([Mobile Phone No_]) > 25 or LEN([E-Mail]) > 50)
