--select VendorNoNv, AlphaSearch, EntryDt, ChangeDt from VendorAddress where VendorNoNv='0009131' or VendorNoNv='1002834' or VendorNoNv='0009130'




--Process Vendor Updates in ERP [VendorAddress]
UPDATE	VendorAddress
SET	Type = VendUpd.[VendType],
	AlphaSearch = LEFT(VendUpd.[Search Name],30),
	LocationCd = VendUpd.[Location Code],
	LocationName = Loc.[Name 2],
	Name2 = VendUpd.[Name 2],
	Line1 = VendUpd.[Address],
	Line2 = VendUpd.[Address 2],
	City = VendUpd.[City],
	State = VendUpd.[County],
	PostCd = VendUpd.[Post Code],
	Country = VendUpd.[Country_Region Code],
	PhoneNo = VendUpd.[Phone No_],
	UPSZone = VendUpd.[UPS Zone],
	FAXPhoneNo = VendUpd.[Fax No_],
	Email = VendUpd.[E-Mail],
	WebPageAddr = VendUpd.[Home Page],
	TaxAreaCd = VendUpd.[Tax Area Code],
	TaxLiableInd = VendUpd.[Tax Liable],
	--CountryCd = VendUpd.[Country_Region Code],
	LeadTimeCalc = CASE WHEN CHARINDEX('D', VendUpd.[Lead Time Calculation]) > 0
				THEN Replace(VendUpd.[Lead Time Calculation], 'D','')*1
				ELSE Replace(VendUpd.[Lead Time Calculation], '','')*1
			    END,
--	BaseCalendarCd = LEFT(VendUpd.[Base Calendar Code],4),
	BaseCalendarCd = VendUpd.[Base Calendar Code],
	PriceIncludesVATind = VendUpd.[Prices Including VAT],
	VATRegNo = VendUpd.[VAT Registration No_],
	VATBusPostingGrp = VendUpd.[VAT Bus_ Posting Group],
--	ShipVia = LEFT(VendUpd.[Shipping Agent Code],5),
	ShipVia = VendUpd.[Shipping Agent Code],
	ShipMeth = LEFT(VendUpd.[Shipment Method Code],4),
	BuyerCd = LEFT(VendUpd.[Purchaser Code],4),
	TransitTimeCalc = CASE WHEN CHARINDEX('D', VendUpd.[Transit Time Calculation]) > 0
				THEN Replace(VendUpd.[Transit Time Calculation], 'D','')*1
				ELSE Replace(VendUpd.[Transit Time Calculation], '','')*1
			    END,
	ChangeDt = VendUpd.[Last Date Modified],
	Name1 = VendUpd.[Name]
FROM	VendorAddress INNER JOIN
--	VendorMaster
--ON	pVendMstrID = fVendMstrID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
--ON	VendUpd.[No_] = VendorMaster.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
ON	VendUpd.[No_] = VendorAddress.VendorNoNV COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code] COLLATE Latin1_General_CS_AS





select * from VendorMaster where VendNo='0009131'




select VendorNoNv, Type, AlphaSearch, fVendMstrId, VendorMaster.*
from VendorAddress (nolock) inner join VendorMaster (nolock) on pVendMstrID = fVendMstrID
--where isnull(AlphaSearch,'') = ''
where VendorNoNv in 
('0009130',
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
'1002642')


select VendorNoNv as nv, * from VendorAddress
where fVendMstrId=896
order by VendorNoNv



select Distinct VendorNoNv
from VendorAddress (nolock) inner join VendorMaster (nolock) on pVendMstrID = fVendMstrID
where isnull(AlphaSearch,'') = '' and VendorNoNv not in
(select VendNo from VendorMaster)



select Distinct VendNo from VendorMaster where VendNo in
(
select DISTINCT VendorNoNv
from VendorAddress (nolock) inner join VendorMaster (nolock) on pVendMstrID = fVendMstrID
where isnull(AlphaSearch,'') = ''
)