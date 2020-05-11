--exec sp_columns [Porteous$Contact]
--exec sp_columns [Porteous$Contact Business Relation]


SELECT	*
		     FROM	PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt'




UPDATE	PERP.dbo.AppPref
SET	EntryDt=GetDate(),ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt'

select getdate()-10

--Build Temp ERP Table for Vendor Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendUpdate


select * into tERPVendUpdate from OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Vendor [Vend3.7]


select * from tERPVendInsert
select * from tERPVendDelete
select * from tERPVendUpdate


select [Landed Cost Code] AS CODE, * from [Porteous$Vendor]
order by [Landed Cost Code] DESC


UPDATE	[Porteous$Vendor]
SET	[Landed Cost Code]=VendUpd.[Landed Cost Code]
FROM	[Porteous$Vendor] INNER JOIN
	[tERPVendUpdate] VendUpd ON
	VendUpd.[No_] = [Porteous$Vendor].[No_] COLLATE Latin1_General_CS_AS


select * from [Porteous$Landed Cost]

SELECT	*
--INTO	tERPVendInsert
FROM	[Porteous$Vendor] [Vend5.0]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Vendor [Vend3.7]
			 WHERE	[Vend3.7].[No_] COLLATE Latin1_General_CS_AS = [Vend5.0].[No_]))

SELECT	*
--INTO	tERPVendDelete
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Vendor [Vend3.7]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous$Vendor] [Vend5.0]
			 WHERE	[Vend3.7].[No_] COLLATE Latin1_General_CS_AS = [Vend5.0].[No_]))





select * from [Porteous$Contact]
select * from [Porteous$Contact Business Relation]


SELECT		[CBR5.0].[Business Relation Code], [CBR5.0].[Contact No_],
		[Contact5.0].*
--INTO		tERPVendInsert
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] [CBR5.0]
ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
WHERE		[CBR5.0].[Business Relation Code] = 'VEND'




SELECT		--[Contact5.0].[No_],
		[CBR5.0].*
--INTO		tERPVendInsert
FROM		[Porteous$Contact Business Relation] [CBR5.0]
INNER JOIN	[Porteous$Contact] [Contact5.0]
ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
WHERE		[CBR5.0].[Business Relation Code] = 'VEND' 



--[Porteous$Contact Business Relation]
--Find records that are in NV3.7 but not in NV5.0
SELECT		--[Contact3.7].[No_],
		[CBR3.7].*
--INTO		tERPVendDelete
FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] [CBR3.7]
--INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] [Contact3.7]
--ON		[Contact3.7].[No_] = [CBR3.7].[Contact No_]
WHERE		[CBR3.7].[Business Relation Code] = 'VEND' AND
		(NOT EXISTS	(SELECT		[CBR5.0].*
				 FROM		[Porteous$Contact Business Relation] [CBR5.0]
--				 INNER JOIN	[Porteous$Contact] [Contact5.0]
--				 ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
				 WHERE		[CBR5.0].[Business Relation Code] = 'VEND' AND [CBR3.7].[Contact No_] COLLATE Latin1_General_CS_AS = [CBR5.0].[Contact No_]))
