select fPayToNo,AlphaSearch, * from VendorMaster  where  VendNo in 
(
'0009130',
'0009131',
'0009132',
'0913000',
'0913010',
'0913100',
'0913110',
'0913200',
'1001012',
'1001168',
'1002175',
'1002519',
'1002642'
  )


select * from VendorAddress where fVendMstrID in
(
906,
907,
908,
1351,
1352,
1353,
1354,
1355,
2311,
2436,
3336,
3581,
3699
)


select * into tVendorMaster from VendorMaster

select * into tVendorAddress from VendorAddress

--select * from VendorMaster


delete from vendoraddress
where pvendaddrid in (3774,3597)


UPDAte VendorAddress
set fVendMstrID=3978
where pvendaddrid=3598



SELECT	pVendMstrID, VendNo, isnull([Pay-to Vendor No_],'') as PayToNo
FROM	VendorMaster ERP INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] NV
ON	ERP.VendNo = NV.[No_] COLLATE Latin1_General_CS_AS



UPDATE	VendorMaster
SET	fPayToNo = pVendAddrID
FROM	VendorAddress
WHERE	





UPDATE	VendorMaster
SET	fPayToNo = UPD.pVendMstrID
FROM	(SELECT	pVendMstrID, VendNo
	 FROM	VendorMaster (NoLock)) UPD
WHERE	fPayToNo = UPD.VendNo





select * from VendorMaster

select * from VendorAddress