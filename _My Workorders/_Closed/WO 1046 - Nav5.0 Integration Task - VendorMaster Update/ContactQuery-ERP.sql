SELECT	Addr.pVendAddrID, Cont.fVendAddrID, Vend.pVendMstrID, Addr.fVendMstrID,
	Cont.*
FROM	VendorContact Cont INNER JOIN
	VendorAddress Addr
ON	Addr.pVendAddrID = Cont.fVendAddrID INNER JOIN
	VendorMaster Vend
ON	Vend.pVendMstrID = Addr.fVendMstrID INNER JOIN
--	PFCFINANCE.dbo.[Porteous$Contact Business Relation] CBR
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Contact Business Relation] CBR
ON	CBR.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS INNER JOIN
--	PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
ON	VendUpd.[No_] = CBR.[COntact No_]





--select * from VendorMaster where VendNo='1002597' or VendNo='1002598'