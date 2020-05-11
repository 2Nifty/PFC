--UPDATE PTBF Vendors for Vendor INSERTs & UPDATEs

--Vendor INSERTs
UPDATE	VendorAddress
SET	Type = 'PTBF'
FROM	VendorAddress VA INNER JOIN
	VendorMaster VM
ON	VA.fVendMstrID = VM.pVendMstrID
WHERE	VM.VendNo in	(SELECT	[No_]
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.tERPVendInsert)
AND	fVendMstrID in	(SELECT	pVendMstrID
			 FROM	VendorMaster (NoLock)
			 WHERE	isnull(fPayToNo,'') = '' and
				pVendMstrID not in (SELECT fPayToNo FROM VendorMaster (NoLock) WHERE isnull(fPayToNo,'') <> ''))
go

--Vendor UPDATEs
UPDATE	VendorAddress
SET	Type = 'PTBF'
FROM	VendorAddress VA INNER JOIN
	VendorMaster VM
ON	VA.fVendMstrID = VM.pVendMstrID
WHERE	VM.VendNo in	(SELECT	[No_]
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.tERPVendUpdate)
AND	fVendMstrID in	(SELECT	pVendMstrID
			 FROM	VendorMaster (NoLock)
			 WHERE	isnull(fPayToNo,'') = '' and
				pVendMstrID not in (SELECT fPayToNo FROM VendorMaster (NoLock) WHERE isnull(fPayToNo,'') <> ''))
go








--select * 
delete
from VendorMaster where Vendno='0001645'

--select * 
delete
from VendorAddress where fVendMstrID=172

--select * 
delete
from VendorContact where fVendAddrID=172



select * from VendorMaster

select * 
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Vendor]


select * 
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.tERPVendInsert




--SET VendType='PT' for Pay To Vendors
UPDATE	tERPVendInsert
SET	VendType = 'PT'
WHERE	[Pay-to Vendor No_] IS NULL OR
	[Pay-to Vendor No_] = '' OR
	[Pay-to Vendor No_] = [No_]

--SET VendType='BF' for Buy From Vendors
UPDATE	tERPVendInsert
SET	VendType = 'BF'
WHERE	[Pay-to Vendor No_] IS NOT NULL AND
	[Pay-to Vendor No_] <> '' AND
	[Pay-to Vendor No_] <> [No_]

--SET VendType='PTBF' for Pay To/Buy From Vendors
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress

SELECT	Addr.*
INTO	tVendorAddress
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress Addr INNER JOIN
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress Addr INNER JOIN
(SELECT	*
 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster Vend
-- FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
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