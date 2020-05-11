select * from [Porteous$Vendor] where [No_]='1002636' or [No_]='1002637' or [No_]='1002640' or [No_]='1002580'
select * from [Porteous$Contact] where [No_]='CT035329' or [No_]='CT035330' or [No_]='CT035331' or [No_]='CT035332' or [No_]='CT035335' or [No_]='CT035042' or [No_]='CT035043'
select * from [Porteous$Contact Business Relation] where [No_]='1002636' or [No_]='1002637' or [No_]='1002640' or [No_]='1002580'
--select * from [Porteous$Contact Business Relation] where [Contact No_]='CT035043' or [Contact No_]='CT035335'



select * from VendorMaster where  VendNo='1002580'
select fVendContactID, * from VendorAddress where fVendMstrID=3403
select * from VendorContact where fVendAddrID=3403

--select * from VendorContact where ContactNoNV='CT035042' or ContactNoNV='CT035043'






delete from [Porteous$Contact Business Relation] where [Contact No_]='CT035332'
CT035329
CT035330
CT035331
CT035332



select * from VendorMaster where VendNo='1002636' or VendNo='1002637' or VendNo='1002580'
select * from VendorAddress where fVendMstrID=3460
select * from VendorContact where fVendAddrID=3694 or fVendAddrID=3695

--select * from tPrimaryCont

delete from VendorContact where  fVendAddrID=3693



--SET VendorAddress.fVendContactID
UPDATE	VendorAddress
SET	fVendContactID = pVendContactID
FROM	VendorAddress Addr INNER JOIN
	VendorContact Cont
ON	Cont.fVendAddrID = Addr.pVendAddrID
WHERE	fVendContactID IS NULL



--SET VendorAddress.fVendContactID (Primary Contacts)
UPDATE	VendorAddress
SET	fVendContactID = pVendContactID
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] Vend INNER JOIN
	VendorContact Cont
ON	Cont.ContactNoNV = Vend.[Primary Contact No_]
WHERE	pVendAddrID=fVendAddrID



--517 records
select [No_], [Primary Contact No_]
into tPrimaryCont
from 
OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor]
where [Primary Contact No_] IS NOT NULL AND [Primary Contact No_] <> ''

select * from tPrimaryCont
drop table tPrimaryCont








UPDATE	VendorContact
SET	[Name] = VendUpd.[Name],
	JobTitle = VendUpd.[Job Title],
	Phone = VendUpd.[Phone No_],
	PhoneExt = VendUpd.[Extension No_],
	FaxNo = VendUpd.[Fax No_],
	MobilePhone = VendUpd.[Mobile Phone No_],
	EmailAddr = VendUpd.[E-Mail],
	Department = VendUpd.[Type],
	--DeleteDt = [],
	--EntryID = [],
	--EntryDt = [],
	--ChangeID = [],
	ChangeDt = [Last Date Modified] --,
	--StatusCd = [],
	--ContactNoNV = VendUpd.[Contact No_]
FROM	--PFCFINANCE.dbo.[tERPVendContUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendContUpdate] VendUpd
WHERE	VendUpd.[Contact No_] = ContactNoNV COLLATE Latin1_General_CS_AS
