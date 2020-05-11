--select [Transit Time Calculation], * from [Porteous$Vendor]


UPDATE	[Porteous$Vendor]
SET	[Transit Time Calculation] = NV3.[Transit Time Calculation]
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3
WHERE	NV3.[No_] = [Porteous$Vendor].[No_] COLLATE SQL_Latin1_General_CP1_CI_AS



--select [Transit Time Calculation], [No_] FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3
--order by [No_]