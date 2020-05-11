

select * from VendorMaster
select * from VendorAddress
select * from VendorContact


--UPDATE VendorContact.Name = [Porteous$Vendor].Contact
UPDATE	VendorContact
SET	[Name] = Cont.Contact
FROM	(SELECT	Addr.pVendAddrID, Vend.Contact
	 FROM	VendorAddress Addr INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] Vend
	 ON	Vend.[No_] = Addr.VendorNoNV COLLATE Latin1_General_CS_AS) Cont
WHERE	VendorContact.fVendAddrID = Cont.pVendAddrID AND Cont.Contact IS NOT NULL AND Cont.Contact <> ''




------------------------------------------------------------------------------

select VendorNoNV, * from VendorAddress where pVendAddrID=3457

select * from VendorMaster where pVendMstrID=3457

select * from VendorContact where fVendAddrID=3457

select Contact, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] Vend 
where [No_]='85828565'

------------------------------------------------------------------------------

select VendorNoNV, * from VendorAddress where pVendAddrID=3691 or fVendMstrID=3038

select * from VendorMaster where pVendMstrID=3038 or VendNo='0000020'

select * from VendorContact where fVendAddrID=3038 or fVendAddrID=3691

select Contact, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] Vend 
where [No_]='0000020' or [No_]='1002111'


