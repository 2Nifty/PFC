
--UPDATE	SOHeader
UPDATE	SOHeaderRel
SET	OrderCarrier = CASE
			WHEN OrderCarrier = '' THEN '01'
			WHEN OrderCarrier = 'A & B' THEN '01'
			WHEN OrderCarrier = 'A. DUIE' THEN '01'
			WHEN OrderCarrier = 'AAA' THEN '01'
			WHEN OrderCarrier = 'ARROW' THEN '01'
			WHEN OrderCarrier = 'AVERITT' THEN '01'
			WHEN OrderCarrier = 'CE FREIGHT' THEN '01'
			WHEN OrderCarrier = 'CE TRANS' THEN '01'
			WHEN OrderCarrier = 'CHILI' THEN '01'
			WHEN OrderCarrier = 'CHRIS' THEN '01'
			WHEN OrderCarrier = 'CLICK' THEN '01'
			WHEN OrderCarrier = 'CON WAY' THEN '01'
			WHEN OrderCarrier = 'CONNECTION' THEN '01'
			WHEN OrderCarrier = 'CRYSTAL' THEN '01'
			WHEN OrderCarrier = 'DANZAS' THEN '01'
			WHEN OrderCarrier = 'DATS' THEN '01'
			WHEN OrderCarrier = 'DAYTON' THEN '01'
			WHEN OrderCarrier = 'DHL' THEN '01'
			WHEN OrderCarrier = 'DIAMOND' THEN '01'
			WHEN OrderCarrier = 'DOHRN' THEN '01'
			WHEN OrderCarrier = 'DYNAMEX' THEN '01'
			WHEN OrderCarrier = 'ESTES' THEN '01'
			WHEN OrderCarrier = 'EXPRESS' THEN '01'
			WHEN OrderCarrier = 'F-HUB-WC' THEN '01'
			WHEN OrderCarrier = 'FED EX' THEN '01'
			WHEN OrderCarrier = 'FEDEX EAST' THEN '01'
			WHEN OrderCarrier = 'FRAMES' THEN '01'
			WHEN OrderCarrier = 'HERCULES F' THEN '01'
			WHEN OrderCarrier = 'HORIZON' THEN '01'
			WHEN OrderCarrier = 'KINDERSLEY' THEN '01'
			WHEN OrderCarrier = 'LA YUMA' THEN '01'
			WHEN OrderCarrier = 'LANTRAX' THEN '01'
			WHEN OrderCarrier = 'LTL' THEN '01'
			WHEN OrderCarrier = 'MAP' THEN '01'
			WHEN OrderCarrier = 'MAXIMUM' THEN '01'
			WHEN OrderCarrier = 'MERIDIAN' THEN '01'
			WHEN OrderCarrier = 'MIDWEST' THEN '01'
			WHEN OrderCarrier = 'MILAN' THEN '01'
			WHEN OrderCarrier = 'MONROE' THEN '01'
			WHEN OrderCarrier = 'N & M' THEN '01'
			WHEN OrderCarrier = 'NORTH PARK' THEN '01'
			WHEN OrderCarrier = 'OAK HARBOR' THEN '01'
			WHEN OrderCarrier = 'OLD DOM' THEN '01'
			WHEN OrderCarrier = 'OVERNITE' THEN '01'
			WHEN OrderCarrier = 'PARKE' THEN '01'
			WHEN OrderCarrier = 'PENINSULA' THEN '01'
			WHEN OrderCarrier = 'PITT OHIO' THEN '01'
			WHEN OrderCarrier = 'PJAX' THEN '01'
			WHEN OrderCarrier = 'POZAS BROS' THEN '01'
			WHEN OrderCarrier = 'PRIORITY' THEN '01'
			WHEN OrderCarrier = 'R & L' THEN '01'
			WHEN OrderCarrier = 'RAC' THEN '01'
			WHEN OrderCarrier = 'RJM' THEN '01'
			WHEN OrderCarrier = 'ROADWAY' THEN '01'
			WHEN OrderCarrier = 'RRR' THEN '01'
			WHEN OrderCarrier = 'SAIA' THEN '01'
			WHEN OrderCarrier = 'SOUTHEAST' THEN '01'
			WHEN OrderCarrier = 'SOUTHWEST' THEN '01'
			WHEN OrderCarrier = 'SPRINTER' THEN '01'
			WHEN OrderCarrier = 'STEVE' THEN '01'
			WHEN OrderCarrier = 'TEXOMA' THEN '01'
			WHEN OrderCarrier = 'TIGER' THEN '01'
			WHEN OrderCarrier = 'TRAVIS' THEN '01'
			WHEN OrderCarrier = 'UNASSIGNED' THEN '01'
			WHEN OrderCarrier = 'USF HOL' THEN '01'
			WHEN OrderCarrier = 'USF RED' THEN '01'
			WHEN OrderCarrier = 'VAN KAM' THEN '01'
			WHEN OrderCarrier = 'WILSON' THEN '01'
			WHEN OrderCarrier = 'YELLOW' THEN '01'
			WHEN OrderCarrier = 'UPS' THEN '02'
			WHEN OrderCarrier = 'UPS FREIGH' THEN '02'
			WHEN OrderCarrier = 'UPS RED' THEN '03'
			WHEN OrderCarrier = 'UPS BLUE' THEN '04'
			WHEN OrderCarrier = 'UPS EARLY' THEN '05'
			WHEN OrderCarrier = 'UPS ORANGE' THEN '06'
			WHEN OrderCarrier = 'UPS RED SA' THEN '07'
			WHEN OrderCarrier = 'MAERSK' THEN 'Mill'
			WHEN OrderCarrier = 'BR TR+FHUB' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+ WC' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+FRT' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+OT' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+UPS' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #10' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #100' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #11' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #2' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #5' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #553' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #566' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #577' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #578' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #595' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #596' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #599' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #6' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #602' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #603' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #605' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #606' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #607' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #608' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #609' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #610' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #611' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #612' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #7' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #9' THEN 'PFC'
			WHEN OrderCarrier = 'PFCTRUCK' THEN 'PFC'
			WHEN OrderCarrier = 'W/C AT SFS' THEN 'WC'
			WHEN OrderCarrier = 'WILL CALL' THEN 'WC'
			ELSE '01'
		       END


--UPDATE	SOHeader
UPDATE	SOHeaderRel
SET	OrderCarName = Car.Dsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Car
WHERE	TableType = 'CAR' AND OrderCarrier = Car.TableCd



--UPDATE	SODetail
--SET	CarrierCd = OrderCarrier
--FROM	SODetail INNER JOIN
--	SOHeader
--ON	pSOHeaderID = SODetail.fSOHeaderID


UPDATE	SODetailRel
SET	CarrierCd = OrderCarrier
FROM	SODetailRel INNER JOIN
	SOHeaderRel
ON	pSOHeaderRelID = SODetailRel.fSOHeaderRelID



----------------------------------------------------------------------------------------


select Hdr.OrderCarrier, Hdr.OrderCarName, Dtl.CarrierCd, *
FROM	SODetail Dtl INNER JOIN
	SOHeader Hdr
ON	pSOHeaderID = Dtl.fSOHeaderID
Order by Hdr.OrderCarrier


select Hdr.OrderCarrier, Hdr.OrderCarName, Dtl.CarrierCd, *
FROM	SODetailRel Dtl INNER JOIN
	SOHeaderRel Hdr
ON	pSOHeaderRelID = Dtl.fSOHeaderRelID
Order by Hdr.OrderCarrier