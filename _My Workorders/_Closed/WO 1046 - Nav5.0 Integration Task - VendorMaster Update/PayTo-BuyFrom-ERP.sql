select * from VendorMaster where VendNo=0001855
select LeadTimeCalc, * from VendorAddress where fVendMstrID=204
select * from VendorContact where fVendAddrID=204




----SET VendorAddress.fVendContactID
--UPDATE	VendorAddress
--SET	fVendContactID = pVendContactID
--FROM	VendorAddress Addr INNER JOIN
--	VendorContact Cont
--ON	Cont.fVendAddrID = Addr.pVendAddrID
--WHERE	fVendContactID IS NULL



select * from VendorMaster
select * from VendorAddress
select * from VendorContact
select * FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Vendor]




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress

SELECT	Addr.*
INTO	tVendorAddress
FROM	VendorAddress Addr INNER JOIN
(SELECT	*
 FROM	VendorMaster Vend
 WHERE	NOT EXISTS (SELECT *
--		    FROM   PFCFINANCE.VendorAddress Addr
		    FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Vendor] Vend2
		    WHERE  Vend.[VendNo] = Vend2.[Pay-to Vendor No_])) VendMstr
ON	Addr.fVendMstrID = VendMstr.pVendMstrID

--SELECT * FROM tVendorAddress
--SELECT * FROM VendorAddress

UPDATE	VendorAddress
SET	Type = 'PTBF'
FROM	VendorAddress Addr INNER JOIN
	tVendorAddress tAddr
ON	Addr.pVendAddrID = tAddr.pVendAddrID

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tVendorAddress') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tVendorAddress



select * from VendorMaster where VendNo=9200
select [Pay-to Vendor No_] AS PayTo, *  FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Vendor]
where [No_]=9200 or [Pay-to Vendor No_] = 9200
select VendorNoNV AS VendorNo, * from VendorAddress where VendorNoNV=9200





select * from VendorMaster where VendNo='0009130'
select * from VendorAddress where fVendMstrID=896 order by AlphaSearch