---------------------------------------------------
-----     P r o c e s s     I n s e r t s     -----
---------------------------------------------------

--CREATE tERPVendInsert Table for Vendor Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert

--Find records that are in NV5 but not in ERP
SELECT	*
INTO	tERPVendInsert
FROM	[Porteous$Vendor] NV5
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster ERP
			 WHERE	ERP.VendNo COLLATE Latin1_General_CS_AS = NV5.[No_]))

--Add VendType column to tERPVendInsert
IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='tERPVendInsert' AND COLUMN_NAME = 'VendType')
ALTER TABLE	tERPVendInsert
DROP COLUMN	VendType

ALTER TABLE	tERPVendInsert
ADD		VendType char(5) NULL

--SET VendType='PT' for Pay To Vendors
UPDATE	tERPVendInsert
SET	VendType = 'PT'
WHERE	isnull([Pay-to Vendor No_],'') = '' OR [Pay-to Vendor No_] = [No_]

--SET VendType='BF' for Buy From Vendors
UPDATE	tERPVendInsert
SET	VendType = 'BF'
WHERE	isnull([Pay-to Vendor No_],'') <> '' AND [Pay-to Vendor No_] <> [No_]

--SET VendType='PTBF' for Pay To/Buy From Vendors
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress

SELECT	Addr.*
INTO	tVendorAddress
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr INNER JOIN
(SELECT	*
 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster Vend
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



--select * from tERPVendInsert




--INSERTS





---------------------------------------------------------------------------------------------------------------------------------
--Build Temp ERP Table for Vendor Deletes
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendDelete

--Find records that are in ERP but not in NV5
SELECT	*
INTO	tERPVendDelete
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster ERP
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous$Vendor] NV5
			 WHERE	NV5.[No_] COLLATE Latin1_General_CS_AS = ERP.VendNo))
--select * from tERPVendDelete


--DELETES




---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------
--Get Vendor Updates--
-------------------------------------

--SET @LastDate from AppPref Table
Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LastVendNV5.0CnvDt')
--SELECT @LastDate

--Build Temp ERP Table for Vendor Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendUpdate

--Find modified records in NV5 based on [Last Modified Date]
SELECT	*
INTO	tERPVendUpdate
FROM	[Porteous$Vendor] NV5
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--select * from tERPVendUpdate




--UPDATES








--Do this after updates are successful
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
SET	AppOptionValue = @LastUpdate, ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LastVendNV5.0CnvDt'


