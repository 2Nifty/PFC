--[Porteous$Contact]
SELECT		--CBR.[Business Relation Code], CBR.[Contact No_],
		Contact.*
FROM		[Porteous$Contact] Contact
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		Contact.[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'VEND'


--[Porteous$Contact Business Relation]
SELECT		--Contact.[No_],
		CBR.*
FROM		[Porteous$Contact] Contact
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		Contact.[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'VEND'
order by Contact.[No_]




--Build Temp ERP Table for Vendor Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert


--[Porteous$Contact Business Relation]
--Find records that are in NV5.0 but not in NV3.7
SELECT		--[Contact5.0].[No_],
		[CBR5.0].*
INTO		tERPVendInsert
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] [CBR5.0]
ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
WHERE		[CBR5.0].[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT		[CBR3.7].*
				 FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Contact [Contact3.7]
				 INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] [CBR3.7]
				 ON		[Contact3.7].[No_] = [CBR3.7].[Contact No_]
				 WHERE		[CBR3.7].[Business Relation Code] = 'VEND' AND [CBR3.7].[Contact No_] COLLATE Latin1_General_CS_AS = [CBR5.0].[Contact No_]))




--Build Temp ERP Table for Vendor Deletes
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendDelete

--[Porteous$Contact Business Relation]
--Find records that are in NV3.7 but not in NV5.0
SELECT		--[Contact3.7].[No_],
		[CBR3.7].*
INTO		tERPVendDelete
FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] [Contact3.7]
INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] [CBR3.7]
ON		[Contact3.7].[No_] = [CBR3.7].[Contact No_]
WHERE		[CBR3.7].[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT		[CBR5.0].*
				 FROM		[Porteous$Contact] [Contact5.0]
				 INNER JOIN	[Porteous$Contact Business Relation] [CBR5.0]
				 ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
				 WHERE		[CBR5.0].[Business Relation Code] = 'VEND' AND [CBR3.7].[Contact No_] COLLATE Latin1_General_CS_AS = [CBR5.0].[Contact No_]))





--Build Temp ERP Table for Vendor Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendUpdate

--[Porteous$Contact Business Relation]
--Find modified records in NV5.0
SELECT		--[Contact5.0].[No_],
		[CBR5.0].*
INTO		[tERPVendUpdate]
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] [CBR5.0]
ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
WHERE		[CBR5.0].[Business Relation Code] = 'VEND' AND
		(EXISTS	(SELECT		[CBR3.7].*
			 FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Contact [Contact3.7]
			 INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] [CBR3.7]
			 ON		[Contact3.7].[No_] = [CBR3.7].[Contact No_]
			 WHERE		[CBR3.7].[Business Relation Code] = 'VEND' AND [CBR3.7].[Contact No_] COLLATE Latin1_General_CS_AS = [CBR5.0].[Contact No_] AND
					([CBR3.7].[Link to Table] <> [CBR5.0].[Link to Table] OR
					 [CBR3.7].[No_] COLLATE Latin1_General_CS_AS <> [CBR5.0].[No_])))






--select * from [Porteous$Contact Business Relation]



--Build Temp ERP Table for Vendor Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert

--Find records that are in NV5.0 but not in NV3.7
SELECT	*
INTO	tERPVendInsert
FROM	[Porteous$Vendor] [Vend5.0]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Vendor [Vend3.7]
			 WHERE	[Vend3.7].[No_] COLLATE Latin1_General_CS_AS = [Vend5.0].[No_]))



--[Porteous$Contact]
SELECT		--CBR.[Business Relation Code], CBR.[Contact No_],
		Contact.*
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		Contact.[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT	*
				 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Vendor [Vend3.7]
				 WHERE	[Vend3.7].[No_] COLLATE Latin1_General_CS_AS = [Vend5.0].[No_]))