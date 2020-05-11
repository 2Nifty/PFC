if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert

SELECT	*
INTO	tERPVendInsert
FROM	[Porteous$Vendor] [Vend5.0]




--Add VendType, LeadTime & TransitTime columns to temp tables
IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='tERPVendInsert' AND COLUMN_NAME = 'VendType')
ALTER TABLE	tERPVendInsert
DROP COLUMN	VendType, LeadTime, TransitTime
GO

ALTER TABLE	tERPVendInsert
ADD		VendType char(5) NULL, LeadTime INT NULL, TransitTime INT NULL
GO

--SET 'PT' Vendors
UPDATE	tERPVendInsert
SET	VendType = 'PT'
WHERE	[Pay-to Vendor No_] IS NULL OR
	[Pay-to Vendor No_] = '' OR
	[Pay-to Vendor No_] = [No_]

--SET 'BF' Vendors
UPDATE	tERPVendInsert
SET	VendType = 'PT'
WHERE	[Pay-to Vendor No_] IS NOT NULL AND
	[Pay-to Vendor No_] <> '' AND
	[Pay-to Vendor No_] <> [No_]

--SET 'PTBF' Vendors
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress

SELECT	Addr.*
INTO	tVendorAddress
--FROM	PERP.dbo.VendorAddress Addr INNER JOIN
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress Addr INNER JOIN
(SELECT	*
-- FROM	PERP.dbo.VendorMaster Vend
 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
 WHERE	NOT EXISTS (SELECT *
		    FROM   [Porteous$Vendor] Vend2
		    WHERE  Vend.[VendNo] COLLATE Latin1_General_CS_AS = Vend2.[Pay-to Vendor No_])) VendMstr
ON	Addr.fVendMstrID = VendMstr.pVendMstrID

UPDATE	tERPVendInsert
SET	VendType = 'PTBF'
FROM	tERPVendInsert Addr INNER JOIN
	tVendorAddress tAddr
ON	Addr.[No_] = tAddr.VendorNoNV COLLATE Latin1_General_CS_AS

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress


--Update LeadTimeCalc & TransitTimeCalc from NV3.7
UPDATE	tERPVendInsert
SET	LeadTime = CASE WHEN CHARINDEX('D', NV.[Lead Time Calculation]) > 0
				THEN Replace(NV.[Lead Time Calculation], 'D','')*1
				ELSE Replace(NV.[Lead Time Calculation], '','')*1
			    END,
	TransitTime = CASE WHEN CHARINDEX('D', NV.[Transit Time Calculation]) > 0
				THEN Replace(NV.[Transit Time Calculation], 'D','')*1
				ELSE Replace(NV.[Transit Time Calculation], '','')*1
			    END
--FROM	PERP.dbo.VendorAddress INNER JOIN
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV
ON	VendorNoNV = NV.[No_]









IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='tERPVendUpdate' AND COLUMN_NAME = 'VendType')
ALTER TABLE	tERPVendUpdate
DROP COLUMN	VendType, LeadTime, TransitTime
GO

ALTER TABLE	tERPVendUpdate
ADD		VendType char(5) NULL, LeadTime INT NULL, TransitTime INT NULL
GO

--exec sp_columns tERPVendUpdate






select * from [Porteous$Contact Business Relation]