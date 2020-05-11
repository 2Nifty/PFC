UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Vendor]
SET	[Name]=Upd.[Name]
--select NV5.[Name], NV3.[Name], NV3.* 
FROM	(SELECT NV5.* FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Vendor] NV3 INNER JOIN
	[Porteous$Vendor] NV5
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS) Upd

WHERE	
	NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS

NV3.[No_]=	0005435 or
NV3.[No_]=	0005500 or
NV3.[No_]=	0013201 or
NV3.[No_]=	1000064 or
NV3.[No_]=	1000077 or
NV3.[No_]=	1000328 or
NV3.[No_]=	1001764 or
NV3.[No_]=	1002586 or 
NV3.[No_]=	1002587



--*********************
UPDATE	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor]
SET	[Name]=VendName
FROM 	(SELECT [No_] AS VendNo, [Name] AS VendName FROM [Porteous$Vendor]) NV5
WHERE	VendNo = [No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	VendName< >[Name] COLLATE SQL_Latin1_General_CP1_CI_AS
--*********************


UPDATE	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor]
SET	
	[Name]=[NV5_Name]
FROM	(SELECT [No_] AS [NV5_No_], [Name] AS [NV5_Name] FROM [Porteous$Vendor]) NV5
WHERE	[No_]=[NV5_No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND [Name]< >[NV5_Name] COLLATE SQL_Latin1_General_CP1_CI_AS



select NV5.[Name], NV3.[Name], NV3.* 
FROM	[Porteous$Vendor] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	
	NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS


NV3.[No_]=	0005435 or
NV3.[No_]=	0005500 or
NV3.[No_]=	0013201 or
NV3.[No_]=	1000064 or
NV3.[No_]=	1000077 or
NV3.[No_]=	1000328 or
NV3.[No_]=	1001764 or
NV3.[No_]=	1002586 or 
NV3.[No_]=	1002587



UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Vendor]
SET	[Name]=''
where 
[No_]=	0005435 or
[No_]=	0005500 or
[No_]=	0013201 or
[No_]=	1000064 or
[No_]=	1000077 or
[No_]=	1000328 or
[No_]=	1001764 or
[No_]=	1002586 or 
[No_]=	1002587



-------------------------------------------------------------------------------------------------




select NV5.[Company Name], NV3.[Company Name], NV3.* 
FROM	[Porteous$Contact] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_]=NV5.[No_]
WHERE	
	NV5.[Company Name]< >NV3.[Company Name] COLLATE SQL_Latin1_General_CP1_CI_AS and
	CBR.[Business Relation Code]='VEND'



UPDATE	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact]
SET	
	[Company Name]=[NV5_Company Name]
FROM	(SELECT [Business Relation Code], Cont.[No_] AS [NV5_No_], [Company Name] AS [NV5_Company Name] FROM [Porteous$Contact] Cont INNER JOIN [Porteous$Contact Business Relation] CBR ON CBR.[Contact No_]=Cont.[No_]) NV5
WHERE	[No_]=[NV5_No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND [Company Name]< >[NV5_Company Name] COLLATE SQL_Latin1_General_CP1_CI_AS AND NV5.[Business Relation Code]='VEND'
