
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
	VendIns.[Type] AS Department --,
	--[] AS DeleteDt,
	--[] AS EntryID,
	--[] AS EntryDt,
	--[] AS ChangeID,
	--[] AS ChangeDt,
	--[] AS StatusCd
FROM	[tERPVendInsert] VendIns INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	CBR.[Contact No_] = VendIns.[No_] INNER JOIN
--	PERP.VendorMaster Vend
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	Vend.VendNo COLLATE Latin1_General_CS_AS = CBR.[No_] INNER JOIN
--	PERP.VendorAddress Addr
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress Addr
ON	Addr.fVendMstrID = Vend.pVendMstrID


SELECT	Addr.pVendAddrID, Cont.fVendAddrID, Vend.pVendMstrID, Addr.fVendMstrID,
	*
FROM	VendorContact Cont INNER JOIN
	VendorAddress Addr
ON	Addr.pVendAddrID = Cont.fVendAddrID INNER JOIN
	VendorMaster Vend
ON	Vend.pVendMstrID = Addr.fVendMstrID INNER JOIN
--	PFCFINANCE.dbo.[Porteous$Contact Business Relation] CBR
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Contact Business Relation] CBR
ON	CBR.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS



--	PFCFINANCE.dbo.[tERPCustUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd




select * from VendorMaster where VendNo='1002597' or VendNo='1002598'

select * from tERPVendInsert
select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorContact
select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress
select * from [Porteous$Contact]
select * from [Porteous$Contact Business Relation]

Select * from-- VendorAddress
OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorAddress --where VendNo='1002597' or VendNo='1002598'




exec sp_columns OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorContact

SELECT	Vend.pVendMstrID AS fVendMstrID,
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
	VendUpd.[Country_Region Code] AS CountryCd,
	VendUpd.[Lead Time Calculation] AS LeadTimeCalc,
	VendUpd.[Prices Including VAT] AS PriceIncludesVATind,
	VendUpd.[VAT Registration No_] AS VATRegNo,
	VendUpd.[VAT Bus_ Posting Group] AS VATBusPostingGrp,
	VendUpd.[Shipment Method Code] AS ShipMeth,
	VendUpd.[Lead Time Calculation] AS TransitTimeCalc,
	VendUpd.[Last Date Modified] AS ChangeDt	
FROM	[Porteous$Vendor] VendUpd INNER JOIN
--	PERP.dbo.VendorMaster Vend
--ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]




--Process Vendor Updates in ERP [VendorAddress]
UPDATE	VendorAddress
SET
select
	fVendMstrID = VendorMaster.pVendMstrID,
	AlphaSearch = VendUpd.[Search Name],
	LocationCd = VendUpd.[Location Code],
	LocationName = Loc.[Name 2],
	Name2 = VendUpd.[Name 2],
	Line1 = VendUpd.[Address],
	Line2 = VendUpd.[Address 2],
	City = VendUpd.[City],
	State = VendUpd.[County],
	PostCd = VendUpd.[Post Code],
	Country = VendUpd.[Country_Region Code],
	PhoneNo = VendUpd.[Phone no_],
	UPSZone = VendUpd.[UPS Zone],
	FAXPhoneNo = VendUpd.[Fax No_],
	Email = VendUpd.[E-Mail],
	WebPageAddr = VendUpd.[Home Page],
	TaxAreaCd = VendUpd.[Tax Area Code],
	TaxLiableInd = VendUpd.[Tax Liable],
	CountryCd = VendUpd.[Country_Region Code],
	LeadTimeCalc = VendUpd.[Lead Time Calculation],
	PriceIncludesVATind = VendUpd.[Prices Including VAT],
	VATRegNo = VendUpd.[VAT Registration No_],
	VATBusPostingGrp = VendUpd.[VAT Bus_ Posting Group],
	ShipMeth = VendUpd.[Shipment Method Code],
	TransitTimeCalc = VendUpd.[Lead Time Calculation],
	ChangeDt = VendUpd.[Last Date Modified]
FROM	VendorAddress INNER JOIN
	VendorMaster
ON	pVendMstrID = fVendMstrID INNER JOIN
--	PFCFINANCE.dbo.[tERPCustUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Vendor] VendUpd
ON	VendUpd.[No_] = VendorMaster.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
--	PFCFINANCE.dbo.[Porteous$Location] Loc
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]


FROM	[Porteous$Vendor] VendUpd INNER JOIN
--	PERP.dbo.VendorMaster Vend
--ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]






select DISTINCT County from [Porteous$Customer] 
where LEN(County) > 2
order by County

select DISTINCT [Country_Region Code] from [Porteous$Customer]
where LEN([Country_Region Code]) > 4


exec sp_columns [VendorAddress]

select * from CustomerMaster where CustNo=100091

select * from CustomerAddress where fCustomerMasterID=8449



UPDATE    PERP.dbo.AppPref
SET              AppOptionValue = GETDATE() - 2, ChangeID = SYSTEM_USER, ChangeDt = GetDate()
WHERE     ApplicationCd = 'AP' AND AppOptionType = 'LastVendNV5.0CnvDt'



                         UPDATE    PERP.dbo.AppPref
                           SET              AppOptionValue = GETDATE() - 2, ChangeID = SYSTEM_USER, ChangeDt = GetDate()
                           WHERE     ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt'

SELECT     ApplicationCd, AppOptionType, AppOptionValue, AppOptionNumber, AppOptionTypeDesc, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, 
                      pAppPrefID
FROM         AppPref
WHERE     (ApplicationCd = 'AP') AND (AppOptionType = 'LstVendConNV5.0CnvDt' OR
                      AppOptionType = 'LastVendNV5.0CnvDt')

