--Build Temp ERP Table for Vendor Inserts
--Find records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendInsert
go

SELECT	*
INTO	tERPVendInsert
FROM	[Porteous$Vendor] NV5 (NoLock)
WHERE	(NOT EXISTS	(SELECT	*
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
			 WHERE	NV5.[No_] COLLATE Latin1_General_CS_AS = PERP.VendNo))
go


---------------------------------------------------------


--Build Temp ERP Table for Vendor Deletes
--Find records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendDelete
go

SELECT	*
INTO	tERPVendDelete
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster PERP
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous$Vendor] NV5
			 WHERE	PERP.VendNo COLLATE Latin1_General_CS_AS = NV5.[No_]))
go


---------------------------------------------------------


-------------------------------------
--Get Vendor Updates--
-------------------------------------




--Build Temp ERP Table for Vendor Updates
--Find modified records in NV5.0 based on [Last Modified Date] vs @LastDate from AppPref Table
--Uses OpenDataSource for AppPref table connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPVendUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPVendUpdate
go

Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AP' AND AppOptionType = 'LastVendNV5.0CnvDt')

set @lastdate = '01/01/10'

SELECT	*
INTO	[tERPVendUpdate]
FROM	[Porteous$Vendor] [Vend5.0]
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
go


------------------------------------------------------------------------------------------------



exec sp_columns [Porteous$Vendor]




SELECT	[No_] AS VendNo,
	[Name] AS [Name],
	LEFT([Search Name],10) AS [Code],
	[Bank Communication] AS Bank,
	[1099 Code] AS [1099Cd],
	[Payment Terms Code] AS TermsCd,
	[Vendor Posting Group] AS VendorPostingGrp,
	[Federal ID No_] AS FedTaxID,
	[Currency Code] AS CurrencyCd,
	[Priority] AS Priority,
	[Payment Method Code] AS PayMethodCd,
	[Blocked] AS CheckStatus,
	[Prepayment %] AS DiscPct,
	'WO1046_UpdateVendorMasterIns' AS EntryID,
	GETDATE() AS EntryDt,
	[Last Date Modified] AS ChangeID,
	[Search Name] as AlphaSearch,
	isnull([Pay-to Vendor No_],'') as fPayToNo
FROM	tERPVendInsert (NoLock)



------------------------------------------------------------------------------------------------



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
	'WO1046_UpdateVendorMasterINS' AS EntryID,
	GETDATE() AS EntryDt,
	VendNV.[Last Date Modified] AS ChangeDt,
	VendNV.[Name] AS Name1,
	VendNV.[No_] AS VendorNoNV
FROM	tERPVendInsert (NoLock) VendNV INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster Vend
	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster Vend
ON	VendNV.[No_] = Vend.VendNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	[Porteous$Location] (NoLock) Loc
ON	VendNV.[Location Code] = Loc.[Code]
go


select * from tERPVendInsert

------------------------------------------------------------------------------------------------



--Set VendorMaster.DeleteDt for Vendor Deletes
UPDATE	[VendorMaster]
SET	DeleteDt = GetDate()
FROM	[VendorMaster]
WHERE	(EXISTS	(SELECT	*
--		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendDelete] VendDel
		 WHERE	VendDel.[No_] = [VendorMaster].[VendNo] COLLATE Latin1_General_CS_AS))


------------------------------------------------------------------------------------------------

--Process VendorMaster & VendorAddress Updates in ERP
--Uses OpenDataSource for NV5 connection

UPDATE	VendorMaster
SET	VendNo = VendUpd.[No_],
	[Name] = VendUpd.[Name],
	[Code] = LEFT(VendUpd.[Search Name],10),
	Bank = VendUpd.[Bank Communication],
	[1099Cd] = VendUpd.[1099 Code],
	TermsCd = VendUpd.[Payment Terms Code],
	VendorPostingGrp = VendUpd.[Vendor Posting Group],
	FedTaxID = VendUpd.[Federal ID No_],
	CurrencyCd = VendUpd.[Currency Code],
	Priority = VendUpd.[Priority],
	PayMethodCd = VendUpd.[Payment Method Code],
	CheckStatus = VendUpd.[Blocked],
	DiscPct = VendUpd.[Prepayment %],
	ChangeID = 'WO1046_UpdateVendorMasterUPD',
	ChangeDt = VendUpd.[Last Date Modified]
--FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendUpdate VendUpd
FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPVendUpdate VendUpd
WHERE	VendUpd.[No_] = VendorMaster.VendNo COLLATE Latin1_General_CS_AS
go

UPDATE	VendorAddress
SET	Type =	CASE WHEN isnull([Pay-to Vendor No_],'') = '' or [Pay-to Vendor No_] = [No_]
			THEN 'PT'
			ELSE 'BF'
		END,
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
	LeadTimeCalc = CASE WHEN CHARINDEX('D', VendUpd.[Lead Time Calculation]) > 0
				THEN Replace(VendUpd.[Lead Time Calculation], 'D','')*1
				ELSE Replace(VendUpd.[Lead Time Calculation], '','')*1
			    END,
	BaseCalendarCd = VendUpd.[Base Calendar Code],
	PriceIncludesVATind = VendUpd.[Prices Including VAT],
	VATRegNo = VendUpd.[VAT Registration No_],
	VATBusPostingGrp = VendUpd.[VAT Bus_ Posting Group],
	ShipVia = VendUpd.[Shipping Agent Code],
	ShipMeth = LEFT(VendUpd.[Shipment Method Code],4),
	BuyerCd = LEFT(VendUpd.[Purchaser Code],4),
	TransitTimeCalc = CASE WHEN CHARINDEX('D', VendUpd.[Transit Time Calculation]) > 0
				THEN Replace(VendUpd.[Transit Time Calculation], 'D','')*1
				ELSE Replace(VendUpd.[Transit Time Calculation], '','')*1
			    END,
	ChangeID = 'WO1046_UpdateVendorMasterUPD',
	ChangeDt = VendUpd.[Last Date Modified],
	Name1 = VendUpd.[Name]
FROM	VendorAddress INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPVendUpdate] VendUpd
ON	VendUpd.[No_] = VendorAddress.VendorNoNV COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
ON	VendUpd.[Location Code] = Loc.[Code] COLLATE Latin1_General_CS_AS
go



------------------------------------------------------------------------------------------------






------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


--This should not be done until the end.
--Contacts also!

--Step22: UPDATE AppPref [Last Update] values (LastVendNV5.0CnvDt & LstVendConNV5.0CnvDt)

--UPDATE AppPref [Last Update] values
Declare	@LastUpdate DATETIME
SET	@LastUpdate = (SELECT GETDATE())

SET	@LastUpdate = CAST (FLOOR (CAST (GetDate()-13 AS FLOAT)) AS DATETIME)

--UPDATE LastVendNV5.0CnvDt & LstVendConNV5.0CnvDt
UPDATE	AppPref
SET	AppOptionValue = @LastUpdate, ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'AP' AND 
	(AppOptionType = 'LastVendNV5.0CnvDt' OR AppOptionType = 'LstVendConNV5.0CnvDt')




select distinct changedt from VendorMaster



SELECT	AppOptionValue
from AppPref
WHERE	ApplicationCd = 'AP' AND 
	(AppOptionType = 'LastVendNV5.0CnvDt' OR AppOptionType = 'LstVendConNV5.0CnvDt')



select * from tERPVendInsert



select * from VendorContact




--3676 total
--3343 distinct
select	  ContactNoNV as ContactNo
--	, * 
from	VendorContact
order by ContactNoNv




select * from VendorContact where ContactNoNV='CT035058'

Select * from VendorMaster where Vendno='1002584'



--delete
select EntryId, EntryDt, ChangeID, ChangeDt, deletedt,  * 
from VendorMaster where left(EntryID,7)='WO1046_' or left(ChangeID,7)='WO1046_' 
						or isnull(deletedt,'') <> ''

--delete
select EntryId, EntryDt, ChangeID, ChangeDt, deletedt, VendorNoNV, * 
from VendorAddress where left(EntryID,7)='WO1046_' or left(ChangeID,7)='WO1046_' 
						or isnull(deletedt,'') <> ''

--delete
select EntryId, EntryDt, ChangeID, ChangeDt, deletedt, * 
from VendorContact where left(EntryID,7)='WO1046_' or left(ChangeID,7)='WO1046_'
						or isnull(deletedt,'') <> ''
						or fVendAddrid in (1908,4213)



select * from VendorMaster where VendNo='0001645'
select * from VendorAddress where fVendMstrID=172
select * from VendorContact where fVendAddrid=172






update
--select * from 
VendorMaster 
set DeleteDt = GetDate()
where VendNo='1000506'


update
--select * from 
VendorAddress 
set DeleteDt = GetDate()
where fVendMstrid=1908




update
--select * from 
VendorContact
set DeleteDt = GetDate()
where fVendaddrid=1908

