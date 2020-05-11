

select distinct LoadID--* 
from HTIUsage



--update HTIUsage
--set	PFCItem='', PFCItemFlg='N',
--	AltItem='', AltItemFlg='N',
--	LoadID=null, LoadDt=null


select * from HTIUsage
where isnull(LoadID,'')='WO2469.2_Secondary_HTI_Usage_History_Load'


select * 
into #tUsage
from HTIUsage

select * from #tUsage
where HTIItem in
(select AliasItemNo from tWO2469_HTIAlias)




--UPDATE PFCItem from tWO2469_HTIAlias
UPDATE	#tUsage
SET	PFCItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	HTIItem = AliasItemNo and AliasType = 'C'



--Check for valid PFCItem
UPDATE	#tUsage
SET	PFCItemFlg = 'Y'
FROM	ItemMaster IM
WHERE PFCitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster




--UPDATE AltItem from tWO2469_HTIAlias
UPDATE	#tUsage
SET	AltItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	PFCItem = AliasItemNo and AliasType = 'C'


--Check for valid PFCItem
UPDATE	#tUsage
SET	AltItemFlg = 'Y'
FROM	ItemMaster IM
WHERE Altitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster

select * from #tUsage
--where (PFCItemFlg = 'Y' OR AltItemFlg = 'Y')
--WHERE	isnull(LoadDt,'')='' AND PFCItemFlg = 'Y' AND AltItemFlg = 'N'
WHERE	isnull(LoadDt,'')='' AND AltItemFlg='Y'


--Load tWO2469_HTIUsageSumm
SELECT	Location,
	ItemNo,
	sum(isnull(HTISalesDol,0)) as HTISalesDol,
	sum(isnull(HTICartonQty,0)) as HTICartonQty,
	sum(isnull(HTICostDol,0)) as HTICostDol,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CartonQty,0)) as CartonQty,
	sum(isnull(CostDol,0)) as CostDol

into #tUsageSumm

FROM
(
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol,
	SalesDol,
	CartonQty,
	CostDol
FROM	#tUsage
WHERE	isnull(LoadDt,'')='' AND PFCItemFlg = 'Y' AND AltItemFlg = 'N'

UNION

SELECT	HTILoc as Location,
	AltItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol,
	SalesDol,
	CartonQty,
	CostDol
FROM	#tUsage
WHERE	isnull(LoadDt,'')='' AND AltItemFlg='Y'
) tmp
GROUP BY Location, ItemNo


UPDATE	#tUsageSumm
SET	SalesDol = SalesDol * 0.60,
	CartonQty = CartonQty * 0.60,
	CostDol = CostDol * 0.60
WHERE	left(ItemNo,5) <> '00086' and left(ItemNo,5) <> '00087' and 
	left(ItemNo,5) <> '00153' and left(ItemNo,5)<> '00690' and
	(left(ItemNo,5) not between '00900' and '00972') and
	(left(ItemNo,5) not between '20056' and '20972')



select * from #tUsageSumm


SELECT	Location,
	ItemNo,
	SalesDol,
	CartonQty,
	CostDol
into	#tUsageSm
FROM	#tUsageSumm
WHERE	CartonQty < 12

UPDATE	#tUsageSm
SET	CartonQty = CASE WHEN ROUND(isnull(CartonQty,0),0) < 1
	     		 THEN 1
	     		 ELSE ROUND(isnull(CartonQty,0),0)
		    END

select * from #tUsageSm





SELECT	Location,
	ItemNo,
	SalesDol,
	CartonQty,
	CostDol
into	#tUsageLg
FROM	#tUsageSumm
WHERE	CartonQty >= 12


select * from #tUsageLg


select * from #tUsage
where isnull(LoadDt,'')='' and (PFCItemFlg = 'Y' OR AltItemFlg = 'Y')
--WHERE	isnull(LoadDt,'')='' AND PFCItemFlg = 'Y' AND AltItemFlg = 'N'
WHERE	isnull(LoadDt,'')='' AND AltItemFlg='Y'


--Set LoadID & LoadDt
UPDATE	#tUsage
SET	LoadID = 'WO2469.2_Secondary_HTI_Usage_History_Load',
	LoadDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
WHERE	isnull(LoadDt,'')='' AND
	(PFCItemFlg = 'Y' OR AltItemFlg = 'Y')


select * from HTIUsage
select * from #tUsage
order by LoadDt



