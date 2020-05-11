
SELECT	[No_] AS VendNo,
	[Name] AS Name,
	[1099 Code] AS 1099Cd,
	[Payment Terms Code] AS TermsCd,
	[Vendor Posting Group] AS VendorPostingGrp,
	[Federal ID No_] AS FedTaxID,
	[Currency Code] AS CurrencyCd,
	[Priority] AS Priority,
	[Payment Method Code] AS PayMethodCd,
	[Last Date Modified] AS ChangeID
FROM	tERPVendInsert






--ADDRESS
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
FROM	tERPVendInsert VendUpd INNER JOIN
--	PERP.dbo.VendorMaster Vend
--ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	VendUpd.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]





--Set VendorMaster.DeleteDt for Vendor Deletes
UPDATE	[VendorMaster]
SET	DeleteDt = GetDate()
FROM	[VendorMaster]
WHERE	(EXISTS	(SELECT	*
--		 FROM	PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 WHERE	VendDel.[No_] = [VendorMaster].[VendNo] COLLATE Latin1_General_CS_AS))




--Set VendorAddress.DeleteDt for Vendor Deletes
UPDATE	[VendorAddress]
SET	DeleteDt = GetDate()
FROM	[VendorAddress] INNER JOIN
	[VendorMaster]
ON	pVendMstrID = fVendMstrID
WHERE	(EXISTS	(SELECT	*
--		 FROM	PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 WHERE	VendDel.[No_] = [VendorMaster].[VendNo] COLLATE Latin1_General_CS_AS))
		 
		 
		 
		 

--Process Vendor Updates in ERP [VendorMaster]
UPDATE	VendorMaster
SET	VendNo = [No_],
	[Name] = VendUpd.[Name],
	[1099Cd] = [1099 Code],
	TermsCd = [Payment Terms Code],
	VendorPostingGrp = [Vendor Posting Group],
	FedTaxID = [Federal ID No_],
	CurrencyCd = [Currency Code],
	Priority = VendUpd.[Priority],
	PayMethodCd = [Payment Method Code],
	ChangeID = [Last Date Modified]
FROM	VendorMaster INNER JOIN
--	PFCFINANCE.dbo.[tERPCustUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
ON	VendUpd.[No_] = VendorMaster.VendNo COLLATE Latin1_General_CS_AS




--Process Vendor Updates in ERP [VendorAddress]
UPDATE	VendorAddress
SET	AlphaSearch = VendUpd.[Search Name],
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
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
ON	VendUpd.[No_] = VendorMaster.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
--	PFCFINANCE.dbo.[Porteous$Location] Loc
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code]


















