
select --HTILoc, 
	sum(HTISalesDol) as SalesDol, sum(HTICartonQty) as CartonQty, sum(HTICostDol) as CostDol from tWO2469_HTI2009
--group by HTILoc
--order by HTILoc



select * from tWO2469_HTIUsage





SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol,
	SalesDol,
	CartonQty,
	CostDol
FROM	tWO2469_HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N'

UNION

SELECT	HTILoc as Location,
	AltItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol,
	SalesDol,
	CartonQty,
	CostDol
FROM	tWO2469_HTIUsage
WHERE	AltItemFlg='Y'
--(32593 row(s) affected)


--48967
select count(*)  from tWO2469_HTIUsage

--32593
select --count(*)
	*
from tWO2469_HTIUsage
WHERE	PFCItemFlg = 'Y' OR AltItemFlg = 'Y'

--Set LoadID & LoadDt
UPDATE	tWO2469_HTIUsage
SET	LoadID = 'WO2469.1_Primary_HTI_Usage_History_Load',
	LoadDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
WHERE	PFCItemFlg = 'Y' OR AltItemFlg = 'Y'


--6571
----NoAlias tab
--Invalid PFCItem - Invalid AltItem
SELECT	count(*)  --16374
--	Distinct
--	HTIItem, 
--	PFCItem, PFCItemFlg, AltItem, AltItemFlg
FROM	tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N'
--order by PFCItem DESC, HTIItem


select *  from tWO2469_HTIUsage
select * from HTIUsage



select *  from tWO2469_HTIUsageSumm
select *  from tWO2469_HTIUsageLg
select *  from tWO2469_HTIUsageSm

select *  from tWO2469_HTI_IBU

select *  from HTI_IBU



select * from tWO2469_HTIAlias


select * from HTIUsage





--UPDATE PFCItem from tWO2469_HTIAlias
UPDATE	HTIUsage
SET	PFCItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	HTIItem = AliasItemNo and AliasType = 'C'


--Check for valid PFCItem
UPDATE	HTIUsage
SET	PFCItemFlg = 'Y'
FROM	ItemMaster IM
WHERE PFCitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster


--UPDATE AltItem from tWO2469_HTIAlias
UPDATE	HTIUsage
SET	AltItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	PFCItem = AliasItemNo and AliasType = 'C'


--Check for valid PFCItem
UPDATE	HTIUsage
SET	AltItemFlg = 'Y'
FROM	ItemMaster IM
WHERE Altitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster



select * from HTIUsage
where isnull(LoadDt,'')='' and
(PFCItemFlg = 'Y' or AltItemFlg = 'Y')




update HTIUsage set PFCItem='00020-2400-401', PFCItemFlg='Y'
where HTIItem='14F28RZ'


--Load tWO2469_HTIUsageSumm
SELECT	Location,
	ItemNo,
	sum(isnull(HTISalesDol,0)) as HTISalesDol,
	sum(isnull(HTICartonQty,0)) as HTICartonQty,
	sum(isnull(HTICostDol,0)) as HTICostDol,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CartonQty,0)) as CartonQty,
	sum(isnull(CostDol,0)) as CostDol
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
FROM	HTIUsage
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
FROM	HTIUsage
WHERE	isnull(LoadDt,'')='' AND AltItemFlg='Y'
) tmp
GROUP BY Location, ItemNo




--Set LoadID & LoadDt
UPDATE	HTIUsage
SET	LoadID = 'WO2469.2_Secondary_HTI_Usage_History_Load',
	LoadDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
WHERE	PFCItemFlg = 'Y' OR AltItemFlg = 'Y'






SELECT	*,
	'WO2469.1_Primary_HTI_Usage_History_Load' as LoadId,
	CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as LoadDt
FROM	tWO2469_HTI_IBU

