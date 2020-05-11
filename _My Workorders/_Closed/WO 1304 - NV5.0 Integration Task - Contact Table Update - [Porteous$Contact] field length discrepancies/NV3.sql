
select	--CBR.[No_] as AcctNo, CBR.[Contact No_] as ContactNo, CBR.[Business Relation Code] as AcctType,[Last Date Modified],
CONT.[No_],
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


from	[Porteous$Contact] CONT --INNER JOIN
--	[Porteous$Contact Business Relation] CBR
--ON	CBR.[Contact No_]=CONT.[No_]
WHERE	--CBR.[Business Relation Code] = 'VEND' and
(LEN(CONT.Name) > 40 or
LEN(CONT.[Name 2]) > 40 or
LEN(CONT.Address) > 40 or
LEN(CONT.[Address 2]) > 40 or
LEN(CONT.City) > 20 or
LEN(CONT.County) > 2 or
LEN(CONT.[Post Code]) > 10
)
--order by [Last Date Modified]

--select * from [Porteous$Contact Business Relation]








select * from [Porteous$Contact]
where
[No_]='CT023947' or 
[No_]='CT023948' or 
[No_]='CT024000' or 
[No_]='CT024570' or 
[No_]='CT024726' or 
[No_]='CT024990' or 
[No_]='CT025631' or 
[No_]='CT025632' or 
[No_]='CT025969' or 
[No_]='CT025970' or 
[No_]='CT026062' or 
[No_]='CT026869' or 
[No_]='CT026889' or 
[No_]='CT027533' or 
[No_]='CT027534' or 
[No_]='CT027648' or 
[No_]='CT027805' or 
[No_]='CT028552' or 
[No_]='CT028757' or 
[No_]='CT028779' or 
[No_]='CT029489' or 
[No_]='CT029825' or 
[No_]='CT030219' or 
[No_]='CT030432' or 
[No_]='CT030808' or 
[No_]='CT030899' or 
[No_]='CT030959' or 
[No_]='CT031395' or 
[No_]='CT031663' or 
[No_]='CT031985' or 
[No_]='CT032028' or 
[No_]='CT032091' or 
[No_]='CT032396' or 
[No_]='CT032397' or 
[No_]='CT033181' or 
[No_]='CT033196' or 
[No_]='CT033248' or 
[No_]='CT033402' or 
[No_]='CT034308' or 
[No_]='CT034411' or 
[No_]='CT034412' or 
[No_]='CT034538' or 
[No_]='CT035051'



select * from [Porteous$Contact Business Relation]
where 
[Contact No_]='CT023947' or 
[Contact No_]='CT023948' or 
[Contact No_]='CT024000' or 
[Contact No_]='CT024570' or 
[Contact No_]='CT024726' or 
[Contact No_]='CT024990' or 
[Contact No_]='CT025631' or 
[Contact No_]='CT025632' or 
[Contact No_]='CT025969' or 
[Contact No_]='CT025970' or 
[Contact No_]='CT026062' or 
[Contact No_]='CT026869' or 
[Contact No_]='CT026889' or 
[Contact No_]='CT027533' or 
[Contact No_]='CT027534' or 
[Contact No_]='CT027648' or 
[Contact No_]='CT027805' or 
[Contact No_]='CT028552' or 
[Contact No_]='CT028757' or 
[Contact No_]='CT028779' or 
[Contact No_]='CT029489' or 
[Contact No_]='CT029825' or 
[Contact No_]='CT030219' or 
[Contact No_]='CT030432' or 
[Contact No_]='CT030808' or 
[Contact No_]='CT030899' or 
[Contact No_]='CT030959' or 
[Contact No_]='CT031395' or 
[Contact No_]='CT031663' or 
[Contact No_]='CT031985' or 
[Contact No_]='CT032028' or 
[Contact No_]='CT032091' or 
[Contact No_]='CT032396' or 
[Contact No_]='CT032397' or 
[Contact No_]='CT033181' or 
[Contact No_]='CT033196' or 
[Contact No_]='CT033248' or 
[Contact No_]='CT033402' or 
[Contact No_]='CT034308' or 
[Contact No_]='CT034411' or 
[Contact No_]='CT034412' or 
[Contact No_]='CT034538' or 
[Contact No_]='CT035051'




select * from [Porteous$Contact] CONT
where not exists (select * from [Porteous$Contact Business Relation] CBR
		  WHERE CONT.[No_]=CBR.[Contact No_])