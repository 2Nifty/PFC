

UPDATE	VendorContact
SET	[Name] = Cont.Contact
FROM	(SELECT	Addr.pVendAddrID, Vend.Contact, Addr.VendorNoNV
	 FROM	VendorAddress Addr INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] Vend
	 ON	Vend.[No_] = Addr.VendorNoNV COLLATE Latin1_General_CS_AS) Cont INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendUpdate VendUpd
ON	Cont.VendorNoNV = VendUpd.[No_]
WHERE	VendorContact.fVendAddrID = Cont.pVendAddrID AND Cont.Contact IS NOT NULL AND Cont.Contact <> ''





select * from VendorAddress




SELECT	Addr.pVendAddrID, Vend.Contact, Addr.VendorNoNV
	 FROM	VendorAddress Addr INNER JOIN
		VendorContact
	 ON	pVendAddrID=fVendAddrID inner join
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] Vend
	 ON	Vend.[No_] = Addr.VendorNoNV COLLATE Latin1_General_CS_AS

--select * From VendorContact
where
ContactNoNV='CT035121' or 
ContactNoNV='CT035122' or 
ContactNoNV='CT035131' or 
ContactNoNV='CT035136' or 
ContactNoNV='CT035145' or 
ContactNoNV='CT035146' or 
ContactNoNV='CT035147' or 
ContactNoNV='CT035148' or 
ContactNoNV='CT035149' or 
ContactNoNV='CT035150' or 
ContactNoNV='CT035151' or 
ContactNoNV='CT035152' or 
ContactNoNV='CT035153' or 
ContactNoNV='CT035158' or 
ContactNoNV='CT035173' or 
ContactNoNV='CT035174' or 
ContactNoNV='CT035178' or 
ContactNoNV='CT035190' or 
ContactNoNV='CT035193' or 
ContactNoNV='CT035194' or 
ContactNoNV='CT035195' or 
ContactNoNV='CT035196' or 
ContactNoNV='CT035197' or 
ContactNoNV='CT035212' or 
ContactNoNV='CT035222' or 
ContactNoNV='CT035223' or 
ContactNoNV='CT035229' or 
ContactNoNV='CT035230' or 
ContactNoNV='CT035237' or 
ContactNoNV='CT035242' or 
ContactNoNV='CT035248' or 
ContactNoNV='CT035267' or 
ContactNoNV='CT035270' or 
ContactNoNV='CT035271' or 
ContactNoNV='CT035280' or 
ContactNoNV='CT035281' or 
ContactNoNV='CT035288' or 
ContactNoNV='CT035311' or 
ContactNoNV='CT035324'
order by fVendAddrID




delete from VendorContact
where
ContactNoNV='CT035121' or 
ContactNoNV='CT035122' or 
ContactNoNV='CT035131' or 
ContactNoNV='CT035136' or 
ContactNoNV='CT035145' or 
ContactNoNV='CT035146' or 
ContactNoNV='CT035147' or 
ContactNoNV='CT035148' or 
ContactNoNV='CT035149' or 
ContactNoNV='CT035150' or 
ContactNoNV='CT035151' or 
ContactNoNV='CT035152' or 
ContactNoNV='CT035153' or 
ContactNoNV='CT035158' or 
ContactNoNV='CT035173' or 
ContactNoNV='CT035174' or 
ContactNoNV='CT035178' or 
ContactNoNV='CT035190' or 
ContactNoNV='CT035193' or 
ContactNoNV='CT035194' or 
ContactNoNV='CT035195' or 
ContactNoNV='CT035196' or 
ContactNoNV='CT035197' or 
ContactNoNV='CT035212' or 
ContactNoNV='CT035222' or 
ContactNoNV='CT035223' or 
ContactNoNV='CT035229' or 
ContactNoNV='CT035230' or 
ContactNoNV='CT035237' or 
ContactNoNV='CT035242' or 
ContactNoNV='CT035248' or 
ContactNoNV='CT035267' or 
ContactNoNV='CT035270' or 
ContactNoNV='CT035271' or 
ContactNoNV='CT035280' or 
ContactNoNV='CT035281' or 
ContactNoNV='CT035288' or 
ContactNoNV='CT035311' or 
ContactNoNV='CT035324'