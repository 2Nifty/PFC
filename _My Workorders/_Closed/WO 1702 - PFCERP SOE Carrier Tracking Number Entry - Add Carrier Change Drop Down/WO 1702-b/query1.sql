--exec sp_columns CarrierMaster
--exec sp_columns tblCarriers

SELECT	*
from	OpenDataSource('SQLOLEDB','Data Source=pfcrfdb;User ID=pfcnormal;Password=pfcnormal').SLive.dbo.tblCarriers SLive


select MAX(Len(CarrierCode)) AS CarrierCode, MAX(Len([Description])) AS [Description], MAX(Len(CarrierType)) AS CarrierType, MAX(Len(CarrierSCAC)) AS CarrierSCAC
from	OpenDataSource('SQLOLEDB','Data Source=pfcrfdb;User ID=pfcnormal;Password=pfcnormal').SLive.dbo.tblCarriers SLive



select BOLNO, OrderCarrier, OrderCarName as CarName,  * from SOHeaderRel where InvoiceDt is null and (OrderNo ='100072' OR OrderNo ='100073' OR OrderNo ='100074' OR OrderNo ='100075' OR OrderNo ='100076' OR OrderNo ='100077')
order by OrderNo

update SOHeaderRel 
set	OrderCarrier = 'Hay Trf', OrderCarName = 'Hayward Transfer'
where OrderNo ='100072' OR OrderNo ='100073' OR OrderNo ='100074' OR OrderNo ='100075'--OR OrderNo ='100076' OR OrderNo ='100077'


select OrderCarrier, OrderCarName, * from SOHeader where OrderNo='1071251'




select	--distinct ShortDesc
	* 
from	CarrierMaster
Order By ShortDesc


select	--Tbl.TableCd, Tbl.Dsc,
	Tbl.*
from	Tables Tbl
where	Tbl.TableType = 'CAR'
order by tableCd

select BOLNO, OrderCarrier, OrderCarName as CarName,  * from SOHeaderRel where InvoiceDt is null and (OrderNo ='100072' OR OrderNo ='100073' OR OrderNo ='100074' OR OrderNo ='100075' OR OrderNo ='100076' OR OrderNo ='100077')
order by OrderNo


select COUNT(OrderCarname), distinct OrderCarname from SOHeaderrel order by OrderCarName



------------------------------------------------------------------------------------------

TRUNCATE Table CarrierMaster

--Load CarrierMaster
SELECT	SLive.CarrierCode AS Code,
	SLive.[Description] AS CarrierDesc,
	SLive.[Description] AS ShortDesc,
	SLive.CarrierType AS Type,
	SLive.CarrierSCAC AS SCACCd,
	0 AS APAppInd,
	0 AS ARAppInd,
	0 AS GLAppInd,
	0 AS IMAppInd,
	0 AS MMAppInd,
	0 AS POAppInd,
	0 AS SMAppInd,
	1 AS SOAppInd,
	1 AS WMAppInd,
	0 AS WOAppInd,
	'WO1702' AS EntryID,
	GetDate() AS EntryDt
--FROM	OpenDataSource('SQLOLEDB','Data Source=pfcrfdb;User ID=pfcnormal;Password=pfcnormal').SLive.dbo.tblCarriers SLive
FROM	tblCarriers SLive



SELECT	Tbl.TableCd AS Code,
	Tbl.Dsc AS CarrierDesc,
	Tbl.ShortDsc AS ShortDesc,
	0 AS APAppInd,
	0 AS ARAppInd,
	0 AS GLAppInd,
	0 AS IMAppInd,
	0 AS MMAppInd,
	0 AS POAppInd,
	0 AS SMAppInd,
	1 AS SOAppInd,
	1 AS WMAppInd,
	0 AS WOAppInd,
	'WO1702' AS EntryID,
	GetDate() AS EntryDt
FROM	Tables Tbl
WHERE	Tbl.TableType = 'CAR' AND (SOApp = 'Y' OR WMApp = 'Y') AND
	Tbl.TableCd NOT IN (SELECT Code FROM CarrierMaster)



------------------------------------------------------------------------------------------

--DUPS 30/MAX 30
UPDATE	CarrierMaster
SET	ShortDesc = CASE	
		--DUPS 30
			WHEN Code = 'HOMO' THEN 'UPS 2nd Day Air (HOMO)'
			WHEN Code = 'UPS BLUE' THEN 'UPS 2nd Day Air (BLUE)'
			WHEN Code = 'UPS2' THEN 'UPS 2ND DAY AIR'
			WHEN Code = 'UPS ORANGE' THEN 'UPS 3 Day Select (ORANGE)'
			WHEN Code = 'UPS3' THEN 'UPS 3 DAY SELECT'
			WHEN Code = 'UPS' THEN 'UPS Ground'
			WHEN Code = 'UPSG' THEN 'UPS Ground (UPSG)'
			WHEN Code = 'UPS RED' THEN 'UPS Next Day Air (RED)'
			WHEN Code = 'UPSN' THEN 'UPS NEXT DAY AIR'
		--MAX 30
			WHEN Code = 'FDEXGIEF' THEN 'FEDEX INTRANTIONAL ECON FGHT'
			WHEN Code = 'FDEXGIPF' THEN 'FEDEX INTRANTIONAL PRIO FGHT'
			WHEN Code = 'FDS' THEN 'FEDEX PRIO SAT DELIVERY'
			WHEN Code = 'UPSIES' THEN 'UPS INT EXPRESS SAVER'
			ELSE ShortDesc
		    END

------------------------------------------------------------------------------------------

--DUPS 15
UPDATE	CarrierMaster
SET	ShortDesc = CASE	WHEN Code = 'FDEXIF' THEN 'FEDEX INT FIRST'
				WHEN Code = 'FDEXIP' THEN 'FEDEX INT PRIO'
				WHEN Code = 'FDEXGIE' THEN 'FEDEX INT ECON'
				WHEN Code = 'FDEXGIEF' THEN 'FEDEX IN ECOFGT'
				WHEN Code = 'FDEXGIEH' THEN 'FEDEX INT EXHRS'
				WHEN Code = 'FDEXGIG' THEN 'FEDEX INT GRND'
				WHEN Code = 'FDEXGIPF' THEN 'FEDEX IN PRIFGT'
				WHEN Code = 'FDEXPO' THEN 'FEDEX PRIO O/N'
				WHEN Code = 'FDS' THEN 'FEDEX PRIO SAT'
				WHEN Code = 'UPS2' THEN 'UPS 2ND DAY AIR'
				WHEN Code = 'UPS BLUE' THEN 'UPS 2 DAY(BLUE)'
				WHEN Code = 'HOMO' THEN 'UPS 2 DAY(HOMO)'
				WHEN Code = 'UPS ORANGE' THEN 'UPS 3 DAY(ORNG)'
				WHEN Code = 'UPS3' THEN 'UPS 3 DAY(SEL)'
				WHEN Code = 'UPS' THEN 'UPS GROUND'
				WHEN Code = 'UPSG' THEN 'UPS GRND (UPSG)'
				WHEN Code = 'UPSIE' THEN 'UPS INT EXPRESS'
				WHEN Code = 'UPSIEC' THEN 'UPS INT ECONOMY'
				WHEN Code = 'UPSIEP' THEN 'UPS INT EXP +'
				WHEN Code = 'UPSIES' THEN 'UPS INT EXP SVR'
				WHEN Code = 'UPSIEX' THEN 'UPS INT EXP'
				WHEN Code = 'UPSISD' THEN 'UPS INT STD'
				WHEN Code = 'UPSN' THEN 'UPS NEXTDAY'
				WHEN Code = 'UPSNXA' THEN 'UPS ND (EARLY)'
				WHEN Code = 'UPSNXS' THEN 'UPS ND (SAVER)'
				WHEN Code = 'UPS RED' THEN 'UPS ND (RED)'
				WHEN Code = 'UPS EARLY' THEN 'UPS ND (AM)'
				ELSE ShortDesc
		    END



------------------------------------------------------------------------------------------


select 
--SUBSTRING(CarrierDesc,1,CHARINDEX('INTRANTIONAL',CarrierDesc)-1) + 'INT ' + SUBSTRING(CarrierDesc,CHARINDEX('INTRANTIONAL',CarrierDesc)+13,LEN(CarrierDesc)),
*
from CarrierMaster
WHERE CarrierDesc = 'FEDEX INTRANTIONAL PRIORITY'




select	distinct ShortDesc
	--* 
from	CarrierMaster
Order By ShortDesc


exec sp_columns CarrierMaster
exec sp_columns SOHeader



select Code, CarrierDesc, ShortDesc --,SUBSTRING(CarrierDesc,1,30)
from	CarrierMaster
where LEN(CarrierDesc) >= 30


select	LEN(BillToCustName) AS BillToCustName, --40
	LEN(SellToCustName) AS SellToCustName, --40
	LEN(SellToAddress1) AS SellToAddress1, --40
	LEN(SellToCity) AS SellToCity, --20
	LEN(ShipToName) AS ShipToName, --40
	LEN(ShipToAddress1) AS ShipToAddress1, --40
	LEN(City) AS City, --20
	LEN(ContactName) AS ContactName --50
from SOHeaderRel where OrderNo='100073'




update SOHeaderRel
set	--BillToCustName = BillToCustName + 'ZZZZZZZZZZZZZZZ',
	--SellToCustName = SellToCustName + 'ZZZZZZZZZZZZZZZ',
	--ShipToName = ShipToName + 'ZZZZZZZZZZZZZZZ'
	--SellToAddress1 = SellToAddress1 + ' AAAAAA AAAAAA AAAAAA',
	--SellToCity = SellToCity + ' BBBBBBBB BBBBBB',
	--City = City + ' BBBBBBBB BBBBBB'
	ShipToAddress1 = ShipToAddress1 + ' AAAAAA AAAAAA AAAAAA',
	Contactname = ContactName + 'ABCDEFG HIJKLMNO PQRTSU VWXYZ 1234567890 123456789'
where OrderNo='100073'



select ShortDesc
from	CarrierMaster
where LEN(ShortDesc)=30