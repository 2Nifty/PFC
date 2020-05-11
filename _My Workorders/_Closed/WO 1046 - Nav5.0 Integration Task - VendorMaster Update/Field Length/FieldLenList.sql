
select	CBR.[No_] as VendNo, CBR.[Contact No_] as VendorContactNo,
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
	END AS PostCodeLen


from	[Porteous$Contact] CONT INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_]=CONT.[No_]
WHERE	CBR.[Business Relation Code] = 'VEND' and
(LEN(CONT.Name) > 40 or
LEN(CONT.[Name 2]) > 40 or
LEN(CONT.Address) > 40 or
LEN(CONT.[Address 2]) > 40 or
LEN(CONT.City) > 20 or
LEN(CONT.County) > 2 or
LEN(CONT.[Post Code]) > 10
)



