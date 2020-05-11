select * from [Porteous$Contact]

select DISTINCT [No_]
from [Porteous$Contact Business Relation]
where [Business Relation Code]='VEND'


select * from VendorMaster
select fVendContactID , * from VendorAddress
select * from VendorContact


select * from CustomerAddress
select * from CustomerContact





--239 buy from records on file
select [Pay-to Vendor No_]  from [Porteous$Vendor]

WHERE	[Pay-to Vendor No_] IS NOT NULL AND [Pay-to Vendor No_]<>'' AND [Pay-to Vendor No_]<>[No_]
order by [Pay-to Vendor No_]


--232 buy from records converted
SELECT	'BF' AS Type,
	Vend.pVendMstrID AS fVendMstrID,
	VendUpd.[Search Name] AS AlphaSearch,
	VendUpd.[Location Code] AS LocationCd,
	Loc.[Name 2] AS LocationName,
	VendUpd.[Name 2] AS Name2,
	VendUpd.[Address] AS Line1,
	VendUpd.[Address 2] AS Line2,
	VendUpd.[City] AS City,
	VendUpd.[County] AS State,
	VendUpd.[Post Code] AS PostCd,
	VendUpd.[Country_Region Code] AS Country,
	VendUpd.[Phone No_] AS PhoneNo,
	VendUpd.[UPS Zone] AS UPSZone,
	VendUpd.[Fax No_] AS FAXPhoneNo,
	VendUpd.[E-Mail] AS Email,
	VendUpd.[Home Page] AS WebPageAddr,
	VendUpd.[Tax Area Code] AS TaxAreaCd,
	VendUpd.[Tax Liable] AS TaxLiableInd,
	--VendUpd.[Country_Region Code] AS CountryCd,
	VendUpd.[Lead Time Calculation] AS LeadTimeCalc,
	VendUpd.[Base Calendar Code] AS BaseCalendarCd,
	VendUpd.[Prices Including VAT] AS PriceIncludesVATind,
	VendUpd.[VAT Registration No_] AS VATRegNo,
	VendUpd.[VAT Bus_ Posting Group] AS VATBusPostingGrp,
	VendUpd.[Shipping Agent Code] AS ShipVia,
	VendUpd.[Shipment Method Code] AS ShipMeth,
	VendUpd.[Purchaser Code] AS BuyerCd,
	VendUpd.[Last Date Modified] AS ChangeDt,
	VendUpd.[Name] AS Name1
FROM	[Porteous$Vendor] VendUpd INNER JOIN
--	PERP.dbo.VendorMaster Vend
--ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	VendUpd.[Pay-to Vendor No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]
WHERE	[Pay-to Vendor No_] IS NOT NULL AND
	[Pay-to Vendor No_] <> '' AND
	[Pay-to Vendor No_] <> [No_]


--7 buy from records with no corresponding pay to vendor (not converted)
select [Pay-to Vendor No_], *
from [Porteous$Vendor] Vend
WHERE NOT EXISTS (SELECT * FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend2
			where Vend.[Pay-to Vendor No_]=Vend2.[VendNo] COLLATE Latin1_General_CS_AS)
	AND Vend.[Pay-to Vendor No_] IS NOT NULL and Vend.[Pay-to Vendor No_]<>'' AND
	[Pay-to Vendor No_] <> [No_]


select [Pay-to Vendor No_], * from [Porteous$Vendor] where
[No_]=0005404 or
[No_]=0004890 or
[No_]=0002188 or
[No_]=0003345 or
[No_]=0003345 or
[No_]=0004843 or
[No_]=0003553


--luyon
select [Pay-to Vendor No_], * from [Porteous$Vendor]
where
--left([Name],5)='Luyon'
[No_]='0009130' or
[No_]='0009131' or
[No_]='0009132' or
[No_]='0913000' or
[No_]='0913010' or
[No_]='0913100' or
[No_]='0913110' or
[No_]='0913200' or
[No_]='1001012' or
[No_]='1001168' or
[No_]='1002175' or
[No_]='1002519'
order by [Search Name]








----contacts


--2570 contact records
SELECT	--Addr.pVendAddrID, Vend.pVendMstrID, Vend.VendNo, 
	CBR.[Contact No_], CBR.[No_], CBR.[Business Relation Code],
	--Addr.[pVendAddrID] AS fVendAddrID,
	VendIns.[Name] AS [Name],
	VendIns.[Job Title] AS JobTitle,
	VendIns.[Phone No_] AS Phone,
	VendIns.[Extension No_] AS PhoneExt,
	VendIns.[Fax No_] AS FaxNo,
	VendIns.[Mobile Phone No_] AS MobilePhone,
	VendIns.[E-Mail] AS EmailAddr,
	VendIns.[Type] AS Department
FROM	[Porteous$Contact] VendIns INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_] = VendIns.[No_]
WHERE	CBR.[Business Relation Code] = 'VEND' 
order by CBR.[No_]


--2569 CONTACTS TO CONVERT
SELECT	--Addr.pVendAddrID, Vend.pVendMstrID, Vend.VendNo, 
	--CBR.[Contact No_], CBR.[No_], CBR.[Business Relation Code],
	Addr.[pVendAddrID] AS fVendAddrID,
	VendIns.[Name] AS [Name],
	VendIns.[Job Title] AS JobTitle,
	VendIns.[Phone No_] AS Phone,
	VendIns.[Extension No_] AS PhoneExt,
	VendIns.[Fax No_] AS FaxNo,
	VendIns.[Mobile Phone No_] AS MobilePhone,
	VendIns.[E-Mail] AS EmailAddr,
	VendIns.[Type] AS Department,
	--[] AS DeleteDt,
	--[] AS EntryID,
	--[] AS EntryDt,
	--[] AS ChangeID,
	VendIns.[Last Date Modified] AS ChangeDt --,
	--[] AS StatusCd
FROM	[Porteous$Contact] VendIns INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_] = VendIns.[No_] INNER JOIN
--	PERP.VendorAddress Addr
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress Addr
ON	Addr.VendorNoNV COLLATE Latin1_General_CS_AS = CBR.[No_]
WHERE	CBR.[Business Relation Code] = 'VEND'

order by CBR.[No_]


--1 Vendor Contact with no corresponding Vendor record
--CT035058 for vendor 1002584
SELECT	CBR.*, VendIns.*
FROM	[Porteous$Contact] VendIns INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_] = VendIns.[No_]
WHERE	NOT EXISTS (SELECT * FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress Addr
			WHERE Addr.VendorNoNV COLLATE Latin1_General_CS_AS = CBR.[No_])
AND CBR.[Business Relation Code] = 'VEND'


--luyon
(CBR.[No_]='0009130' or
CBR.[No_]='0009131' or
CBR.[No_]='0009132' or
CBR.[No_]='0913000' or
CBR.[No_]='0913010' or
CBR.[No_]='0913100' or
CBR.[No_]='0913110' or
CBR.[No_]='0913200' or
CBR.[No_]='1001012' or
CBR.[No_]='1001168' or
CBR.[No_]='1002175' or
CBR.[No_]='1002519')



--11 buy from vendors that have a contact
select [No_] from [Porteous$Contact Business Relation] CBR
where 
EXISTS
(select * from [Porteous$Vendor]
WHERE	[No_]=CBR.[No_] and
	[Pay-to Vendor No_] IS NOT NULL AND [Pay-to Vendor No_]<>'' AND [Pay-to Vendor No_]<>[No_])
and

CBR.[Business Relation Code] = 'VEND'

--these 11
select [Pay-to Vendor No_],*  from [Porteous$Vendor] where 
[No_]='0000020' or
[No_]='0002148' or
[No_]='0306702' or
[No_]='0907400' or
[No_]='1000056' or
[No_]='1000057' or
[No_]='1001012' or
[No_]='1001066' or
[No_]='1001168' or
[No_]='1002175' or
[No_]='1002519'



