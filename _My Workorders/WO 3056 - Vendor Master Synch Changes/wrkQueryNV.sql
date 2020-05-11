select [Pay-to Vendor No_], * from [Porteous$Vendor] where left([Name],5)='Luyon'
order by [No_]

--[Search Name]


-- where left([Name],2)='Lu'



select [Pay-to Vendor No_], *  from [Porteous$Vendor]
where isnull([Pay-to Vendor No_],'') = '' or [Pay-to Vendor No_] = [No_]



SELECT	CASE WHEN isnull([Pay-to Vendor No_],'') = '' or [Pay-to Vendor No_] = [No_]
		THEN 'PT'
		ELSE 'BF'
	END AS Type,
--	VendNV.[VendType] AS Type,
	Vend.pVendMstrID AS fVendMstrID,
	LEFT(VendNV.[Search Name],30) AS AlphaSearch,
	VendNV.[Location Code] AS LocationCd,
	Loc.[Name 2] AS LocationName,
	VendNV.[Name 2] AS Name2,
	VendNV.[Address] AS Line1,
	VendNV.[Address 2] AS Line2,
	VendNV.[City] AS City,
	VendNV.[County] AS State,
	VendNV.[Post Code] AS PostCd,
	VendNV.[Country_Region Code] AS Country,
	VendNV.[Phone No_] AS PhoneNo,
	VendNV.[UPS Zone] AS UPSZone,
	VendNV.[Fax No_] AS FAXPhoneNo,
	VendNV.[E-Mail] AS Email,
	VendNV.[Home Page] AS WebPageAddr,
	VendNV.[Tax Area Code] AS TaxAreaCd,
	VendNV.[Tax Liable] AS TaxLiableInd,
	--VendNV.[Country_Region Code] AS CountryCd,
	CASE WHEN CHARINDEX('D', VendNV.[Lead Time Calculation]) > 0
		THEN Replace(VendNV.[Lead Time Calculation], 'D','')*1
		ELSE Replace(VendNV.[Lead Time Calculation], '','')*1
	     END AS LeadTimeCalc,
--	LEFT(VendNV.[Base Calendar Code],4) AS BaseCalendarCd,
	VendNV.[Base Calendar Code] AS BaseCalendarCd,
	VendNV.[Prices Including VAT] AS PriceIncludesVATind,
	VendNV.[VAT Registration No_] AS VATRegNo,
	VendNV.[VAT Bus_ Posting Group] AS VATBusPostingGrp,
--	LEFT(VendNV.[Shipping Agent Code],5) AS ShipVia,
	VendNV.[Shipping Agent Code] AS ShipVia,
	LEFT(VendNV.[Shipment Method Code],4) AS ShipMeth,
	LEFT(VendNV.[Purchaser Code],4) AS BuyerCd,
	CASE WHEN CHARINDEX('D', VendNV.[Transit Time Calculation]) > 0
		THEN Replace(VendNV.[Transit Time Calculation], 'D','')*1
		ELSE Replace(VendNV.[Transit Time Calculation], '','')*1
	     END AS TransitTimeCalc,
	'WO1046_UpdateVendorMaster' AS EntryID,
	GETDATE() AS EntryDt,
	VendNV.[Last Date Modified] AS ChangeDt,
	VendNV.[Name] AS Name1,
	VendNV.[No_] AS VendorNoNV
FROM	[Porteous$Vendor] VendNV INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster Vend
--	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.VendorMaster Vend
ON	VendNV.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] Loc
ON	VendNV.[Location Code] = Loc.[Code]



where LEFT(VendNV.[Search Name],2)='LU'

