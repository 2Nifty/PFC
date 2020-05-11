select ShipMethCd, ShipViaCd, ShipTermsCd, * from CustomerMaster where CustNo='056603'



select SOApp, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables
where  TableType='Fght' or TableType='Car'
order by TableType, TableCd



select max(len(TableCd))
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables
where  --TableType='Fght'
	TableType='Car'



exec sp_columns SOHeader
exec sp_columns CustomerMaster
exec sp_columns tables


update CustomerMaster
set ShipTermsCd='WC',
	ShipViaCd='04'
where CustNo='056603'


select * from SOHeader




----------------------------------------------------------------------------------------------------------------

--Freight
UPDATE	CustomerMaster
SET	--ShipMethCd = CASE
	ShipTermsCd = CASE
			WHEN [Shipment Method Code] = 'BRNCHBEST' THEN 'BRANCHBEST'	--Do Not Use This Code
			WHEN [Shipment Method Code] = 'COL-3RD' THEN 'COL-3RD'
			WHEN [Shipment Method Code] = 'COL-COD' THEN 'COL-COD'
			WHEN [Shipment Method Code] = 'COLLECT' THEN 'COL'
			WHEN [Shipment Method Code] = 'CONTAINER' THEN 'CON'
			WHEN [Shipment Method Code] = 'DELIVERY' THEN 'Delivery'
			WHEN [Shipment Method Code] = 'PPD' THEN 'PPD'			--Do Not Use This Code
			WHEN [Shipment Method Code] = 'PPD & $25' THEN 'PPD25'
			WHEN [Shipment Method Code] = 'PPD & $35' THEN 'PPD35'
			WHEN [Shipment Method Code] = 'PPD & $40' THEN 'PPD40'
			WHEN [Shipment Method Code] = 'PPD & $50' THEN 'PPD50'
			WHEN [Shipment Method Code] = 'PPD & $75' THEN 'PPD75'
			WHEN [Shipment Method Code] = 'PPD & CHG' THEN 'PPDCHG'
			WHEN [Shipment Method Code] = 'PPD-1000LB' THEN 'PPD-1000'
			WHEN [Shipment Method Code] = 'PPD-1500LB' THEN 'PPD-1500'
			WHEN [Shipment Method Code] = 'PPD-2000LB' THEN 'PPD-2000'
			WHEN [Shipment Method Code] = 'PPD-2500LB' THEN 'PPD-2500'
			WHEN [Shipment Method Code] = 'PPD-250LB' THEN 'PPD-250'
			WHEN [Shipment Method Code] = 'PPD-3500LB' THEN 'PPD-3500'
			WHEN [Shipment Method Code] = 'PPD-3RD' THEN 'PPD3rd'
			WHEN [Shipment Method Code] = 'PPD-5000LB' THEN 'PPD-5000'
			WHEN [Shipment Method Code] = 'PPD-500LB' THEN 'PPD-500'
			WHEN [Shipment Method Code] = 'PPD-600LB' THEN 'PPD-600'
			WHEN [Shipment Method Code] = 'PPD-750LB' THEN 'PPD-750'
			WHEN [Shipment Method Code] = 'PPD-ADD' THEN 'PPDADD'		--Do Not Use This Code
			WHEN [Shipment Method Code] = 'PPD-ANCHOR' THEN 'PPDANC'
			WHEN [Shipment Method Code] = 'PPD-DEV' THEN 'PPDDEV'
			WHEN [Shipment Method Code] = 'PPD-HDWE' THEN 'PPDHDWE'
			WHEN [Shipment Method Code] = 'PPD-LOCAL' THEN 'PPD-Local'
			WHEN [Shipment Method Code] = 'PPD-MILL' THEN 'PPDMILL'
			WHEN [Shipment Method Code] = 'PPD-NC-BO' THEN 'PPDBO'
			WHEN [Shipment Method Code] = 'PPD-NC-ERR' THEN 'PPDERR'
			WHEN [Shipment Method Code] = 'PPD-NC-TRN' THEN 'PPDTRN'
			WHEN [Shipment Method Code] = 'P-PPD' THEN 'P-PPD'
			WHEN [Shipment Method Code] = 'P-UPS' THEN 'P-UPS'
			WHEN [Shipment Method Code] = 'P-WILL CAL' THEN 'P-WC'
			WHEN [Shipment Method Code] = 'UPS' THEN 'UPS'			--Do Not Use This Code
			WHEN [Shipment Method Code] = 'WILL CALL' THEN 'WC'		--Do Not Use This Code
			ELSE 'Blank'
		      END
FROM	CustomerMaster Cust INNER JOIN
	tERPCustInsert tmp
--	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPCustInsert tmp

----	tERPCustUpdate tmp
----	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPCustUpdate tmp

----	[Porteous$Customer] tmp
----	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer] tmp
ON	Cust.CustNo = tmp.[No_]




----------------------------------------------------------------------------------------------------------------

--Carrier
UPDATE	CustomerMaster
SET	ShipViaCd = CASE
			WHEN [Shipping Agent Code] = '3RD PARTY' THEN '01'
			WHEN [Shipping Agent Code] = 'A & B' THEN '01'
			WHEN [Shipping Agent Code] = 'A & T' THEN '01'
			WHEN [Shipping Agent Code] = 'A. DUIE' THEN '01'
			WHEN [Shipping Agent Code] = 'AAA' THEN '01'
			WHEN [Shipping Agent Code] = 'ABF' THEN '01'
			WHEN [Shipping Agent Code] = 'ACI' THEN '01'
			WHEN [Shipping Agent Code] = 'ACI CART' THEN '01'
			WHEN [Shipping Agent Code] = 'AES' THEN '01'
			WHEN [Shipping Agent Code] = 'ALL CITY' THEN '01'
			WHEN [Shipping Agent Code] = 'ALLIANCE' THEN '01'
			WHEN [Shipping Agent Code] = 'ARROW' THEN '01'
			WHEN [Shipping Agent Code] = 'AVERITT' THEN '01'
			WHEN [Shipping Agent Code] = 'BEAVER' THEN '01'
			WHEN [Shipping Agent Code] = 'BENTON' THEN '01'
			WHEN [Shipping Agent Code] = 'BJJ VOUK' THEN '01'
			WHEN [Shipping Agent Code] = 'BLUE WING' THEN '01'
			WHEN [Shipping Agent Code] = 'BOISE' THEN '01'
			WHEN [Shipping Agent Code] = 'BULLOCK EX' THEN '01'
			WHEN [Shipping Agent Code] = 'CANADIAN F' THEN '01'
			WHEN [Shipping Agent Code] = 'CE FREIGHT' THEN '01'
			WHEN [Shipping Agent Code] = 'CE TRANS' THEN '01'
			WHEN [Shipping Agent Code] = 'CHICAGO' THEN '01'
			WHEN [Shipping Agent Code] = 'CHILI' THEN '01'
			WHEN [Shipping Agent Code] = 'CHRIS' THEN '01'
			WHEN [Shipping Agent Code] = 'CIRCLE' THEN '01'
			WHEN [Shipping Agent Code] = 'CITY WIDE' THEN '01'
			WHEN [Shipping Agent Code] = 'CLICK' THEN '01'
			WHEN [Shipping Agent Code] = 'COAST' THEN '01'
			WHEN [Shipping Agent Code] = 'COLORADO' THEN '01'
			WHEN [Shipping Agent Code] = 'COMET' THEN '01'
			WHEN [Shipping Agent Code] = 'CON WAY' THEN '01'
			WHEN [Shipping Agent Code] = 'CONDOR' THEN '01'
			WHEN [Shipping Agent Code] = 'CONNECTION' THEN '01'
			WHEN [Shipping Agent Code] = 'CONTINENTA' THEN '01'
			WHEN [Shipping Agent Code] = 'CONW DEF' THEN '01'
			WHEN [Shipping Agent Code] = 'CRST' THEN '01'
			WHEN [Shipping Agent Code] = 'CRYSTAL' THEN '01'
			WHEN [Shipping Agent Code] = 'CYCLE' THEN '01'
			WHEN [Shipping Agent Code] = 'D & F' THEN '01'
			WHEN [Shipping Agent Code] = 'DALTON' THEN '01'
			WHEN [Shipping Agent Code] = 'DANZAS' THEN '01'
			WHEN [Shipping Agent Code] = 'DATS' THEN '01'
			WHEN [Shipping Agent Code] = 'DAYTON' THEN '01'
			WHEN [Shipping Agent Code] = 'DFW EXPRES' THEN '01'
			WHEN [Shipping Agent Code] = 'DHL' THEN '01'
			WHEN [Shipping Agent Code] = 'DIAMOND' THEN '01'
			WHEN [Shipping Agent Code] = 'DOHRN' THEN '01'
			WHEN [Shipping Agent Code] = 'DURA' THEN '01'
			WHEN [Shipping Agent Code] = 'DYNAMEX' THEN '01'
			WHEN [Shipping Agent Code] = 'ESPEN' THEN '01'
			WHEN [Shipping Agent Code] = 'ESTES' THEN '01'
			WHEN [Shipping Agent Code] = 'EVEREADY' THEN '01'
			WHEN [Shipping Agent Code] = 'EXPRESS' THEN '01'
			WHEN [Shipping Agent Code] = 'FARMERS' THEN '01'
			WHEN [Shipping Agent Code] = 'FED EX' THEN '01'
			WHEN [Shipping Agent Code] = 'FEDEX EAST' THEN '01'
			WHEN [Shipping Agent Code] = 'FEDEX WEST' THEN '01'
			WHEN [Shipping Agent Code] = 'F-HUB-WC' THEN '01'
			WHEN [Shipping Agent Code] = 'FNB' THEN '01'
			WHEN [Shipping Agent Code] = 'FRAMES' THEN '01'
			WHEN [Shipping Agent Code] = 'G & M' THEN '01'
			WHEN [Shipping Agent Code] = 'GI' THEN '01'
			WHEN [Shipping Agent Code] = 'GREYHOUND' THEN '01'
			WHEN [Shipping Agent Code] = 'HARM''S' THEN '01'
			WHEN [Shipping Agent Code] = 'HAROLD''S' THEN '01'
			WHEN [Shipping Agent Code] = 'HERCULES F' THEN '01'
			WHEN [Shipping Agent Code] = 'HORIZON' THEN '01'
			WHEN [Shipping Agent Code] = 'HUB' THEN '01'
			WHEN [Shipping Agent Code] = 'INLAND' THEN '01'
			WHEN [Shipping Agent Code] = 'INTERMARK' THEN '01'
			WHEN [Shipping Agent Code] = 'INTERSTATE' THEN '01'
			WHEN [Shipping Agent Code] = 'JACKJONES' THEN '01'
			WHEN [Shipping Agent Code] = 'KDL' THEN '01'
			WHEN [Shipping Agent Code] = 'KINDERSLEY' THEN '01'
			WHEN [Shipping Agent Code] = 'LA YUMA' THEN '01'
			WHEN [Shipping Agent Code] = 'LADNER' THEN '01'
			WHEN [Shipping Agent Code] = 'LANDSTAR' THEN '01'
			WHEN [Shipping Agent Code] = 'LANTRAX' THEN '01'
			WHEN [Shipping Agent Code] = 'LOWER' THEN '01'
			WHEN [Shipping Agent Code] = 'LTL' THEN '01'
			WHEN [Shipping Agent Code] = 'MADISON' THEN '01'
			WHEN [Shipping Agent Code] = 'MAP' THEN '01'
			WHEN [Shipping Agent Code] = 'MATHESON' THEN '01'
			WHEN [Shipping Agent Code] = 'MATSON' THEN '01'
			WHEN [Shipping Agent Code] = 'MAXIMUM' THEN '01'
			WHEN [Shipping Agent Code] = 'MERIDIAN' THEN '01'
			WHEN [Shipping Agent Code] = 'MIDWEST' THEN '01'
			WHEN [Shipping Agent Code] = 'MILAN' THEN '01'
			WHEN [Shipping Agent Code] = 'MOLERWAY' THEN '01'
			WHEN [Shipping Agent Code] = 'MONROE' THEN '01'
			WHEN [Shipping Agent Code] = 'MOTOR' THEN '01'
			WHEN [Shipping Agent Code] = 'MST' THEN '01'
			WHEN [Shipping Agent Code] = 'N & M' THEN '01'
			WHEN [Shipping Agent Code] = 'NEAGLE' THEN '01'
			WHEN [Shipping Agent Code] = 'NEBRASKA' THEN '01'
			WHEN [Shipping Agent Code] = 'NORTH PARK' THEN '01'
			WHEN [Shipping Agent Code] = 'OAK HARBOR' THEN '01'
			WHEN [Shipping Agent Code] = 'OLD DOM' THEN '01'
			WHEN [Shipping Agent Code] = 'OVERNITE' THEN '01'
			WHEN [Shipping Agent Code] = 'PARKE' THEN '01'
			WHEN [Shipping Agent Code] = 'PENINSULA' THEN '01'
			WHEN [Shipping Agent Code] = 'PITT OHIO' THEN '01'
			WHEN [Shipping Agent Code] = 'PJAX' THEN '01'
			WHEN [Shipping Agent Code] = 'PORTER' THEN '01'
			WHEN [Shipping Agent Code] = 'POZAS BROS' THEN '01'
			WHEN [Shipping Agent Code] = 'PRIORITY' THEN '01'
			WHEN [Shipping Agent Code] = 'R & L' THEN '01'
			WHEN [Shipping Agent Code] = 'RAC' THEN '01'
			WHEN [Shipping Agent Code] = 'RAPID' THEN '01'
			WHEN [Shipping Agent Code] = 'RICK R' THEN '01'
			WHEN [Shipping Agent Code] = 'RJM' THEN '01'
			WHEN [Shipping Agent Code] = 'RJW' THEN '01'
			WHEN [Shipping Agent Code] = 'RLT' THEN '01'
			WHEN [Shipping Agent Code] = 'ROADWAY' THEN '01'
			WHEN [Shipping Agent Code] = 'RRR' THEN '01'
			WHEN [Shipping Agent Code] = 'RUSH' THEN '01'
			WHEN [Shipping Agent Code] = 'SAIA' THEN '01'
			WHEN [Shipping Agent Code] = 'SALSON' THEN '01'
			WHEN [Shipping Agent Code] = 'SCHNEIDER' THEN '01'
			WHEN [Shipping Agent Code] = 'SERVICE' THEN '01'
			WHEN [Shipping Agent Code] = 'SOUTHEAST' THEN '01'
			WHEN [Shipping Agent Code] = 'SOUTHWEST' THEN '01'
			WHEN [Shipping Agent Code] = 'SPRINTER' THEN '01'
			WHEN [Shipping Agent Code] = 'ST SERVICE' THEN '01'
			WHEN [Shipping Agent Code] = 'STAR' THEN '01'
			WHEN [Shipping Agent Code] = 'STEVE' THEN '01'
			WHEN [Shipping Agent Code] = 'TAX AIR' THEN '01'
			WHEN [Shipping Agent Code] = 'TEXOMA' THEN '01'
			WHEN [Shipping Agent Code] = 'TIGER' THEN '01'
			WHEN [Shipping Agent Code] = 'TJ TRANS' THEN '01'
			WHEN [Shipping Agent Code] = 'TNT' THEN '01'
			WHEN [Shipping Agent Code] = 'TRAVIS' THEN '01'
			WHEN [Shipping Agent Code] = 'TTI' THEN '01'
			WHEN [Shipping Agent Code] = 'U' THEN '01'
			WHEN [Shipping Agent Code] = 'UNASSIGNED' THEN '01'
			WHEN [Shipping Agent Code] = 'USF BEST' THEN '01'
			WHEN [Shipping Agent Code] = 'USF DUGAN' THEN '01'
			WHEN [Shipping Agent Code] = 'USF HOL' THEN '01'
			WHEN [Shipping Agent Code] = 'USF RED' THEN '01'
			WHEN [Shipping Agent Code] = 'VAN KAM' THEN '01'
			WHEN [Shipping Agent Code] = 'VEGAS' THEN '01'
			WHEN [Shipping Agent Code] = 'VOLUNTEER' THEN '01'
			WHEN [Shipping Agent Code] = 'WARD' THEN '01'
			WHEN [Shipping Agent Code] = 'WATKINS' THEN '01'
			WHEN [Shipping Agent Code] = 'WHEELER' THEN '01'
			WHEN [Shipping Agent Code] = 'WILSON' THEN '01'
			WHEN [Shipping Agent Code] = 'WSKT' THEN '01'
			WHEN [Shipping Agent Code] = 'YELLOW' THEN '01'
			WHEN [Shipping Agent Code] = 'UPS' THEN '02'
			WHEN [Shipping Agent Code] = 'UPS FREIGH' THEN '02'
			WHEN [Shipping Agent Code] = 'UPS RED' THEN '03'
			WHEN [Shipping Agent Code] = 'UPS BLUE' THEN '04'
			WHEN [Shipping Agent Code] = 'UPS EARLY' THEN '05'
			WHEN [Shipping Agent Code] = 'UPS ORANGE' THEN '06'
			WHEN [Shipping Agent Code] = 'UPS RED SA' THEN '07'
			WHEN [Shipping Agent Code] = 'MAERSK' THEN 'Mill'
			WHEN [Shipping Agent Code] = 'BR TR+FHUB' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'BR TRK+ WC' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'BR TRK+FRT' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'BR TRK+OT' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'BR TRK+UPS' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #1' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #10' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #100' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #11' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #2' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #5' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #553' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #555' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #566' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #577' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #578' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #595' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #596' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #597' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #598' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #599' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #6' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #600' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #601' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #602' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #603' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #604' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #605' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #606' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #607' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #608' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #609' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #610' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #611' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #612' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #613' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #614' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #7' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #8' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC #9' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFC DET' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'PFCTRUCK' THEN 'PFC'
			WHEN [Shipping Agent Code] = 'W/C AT EK' THEN 'WC'
			WHEN [Shipping Agent Code] = 'W/C AT SFS' THEN 'WC'
			WHEN [Shipping Agent Code] = 'WILL CALL' THEN 'WC'
			ELSE '01'
		      END
FROM	CustomerMaster Cust INNER JOIN
	tERPCustInsert tmp
--	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPCustInsert tmp

----	tERPCustUpdate tmp
----	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.tERPCustUpdate tmp

----	[Porteous$Customer] tmp
----	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer] tmp
ON	Cust.CustNo = tmp.[No_]





