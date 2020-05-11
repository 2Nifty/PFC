

--[tWO2469.2_HTIUnmatchedItems]

--UPDATE PFCItem from tWO2469_HTIAlias
UPDATE	[tWO2469.2_HTIUnmatchedItems]
SET	PFCItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	HTIItem = AliasItemNo and AliasType = 'C'



--Check for valid PFCItem
UPDATE	[tWO2469.2_HTIUnmatchedItems]
SET	PFCItemFlg = 'Y'
FROM	ItemMaster IM
WHERE PFCitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster


--UPDATE AltItem from tWO2469_HTIAlias
UPDATE	[tWO2469.2_HTIUnmatchedItems]
SET	AltItem = isnull(Alias.ItemNo,'')
FROM	tWO2469_HTIAlias Alias
WHERE	PFCItem = AliasItemNo and AliasType = 'C'


--Check for valid PFCItem
UPDATE	[tWO2469.2_HTIUnmatchedItems]
SET	AltItemFlg = 'Y'
FROM	ItemMaster IM
WHERE Altitem = IM.ItemNo and  isnull(IM.DeleteDt,'') = ''
--OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster



select * from [tWO2469.2_HTIUnmatchedItems]




SELECT * FROM tWO2469_HTIUsage 
WHERE	HTIItem in (SELECT DISTINCT HTIItem FROM [tWO2469.2_HTIUnmatchedItems] WHERE PFCItemFlg = 'Y' OR AltItemFlg = 'Y')


--UPDATE tWO2469_HTIUsage from [tWO2469.2_HTIUnmatchedItems]
UPDATE	tWO2469_HTIUsage
SET	PFCItem = tmp.PFCItem,
	PFCItemFlg = tmp.PFCItemFlg,
	AltItem = tmp.AltItem,
	AltItemFlg = tmp.AltItemFlg
FROM	[tWO2469.2_HTIUnmatchedItems] tmp
WHERE	tWO2469_HTIUsage.HTIItem = tmp.HTIItem




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
FROM	(SELECT * FROM tWO2469_HTIUsage 
	 WHERE	HTIItem in (SELECT DISTINCT HTIItem FROM [tWO2469.2_HTIUnmatchedItems] WHERE PFCItemFlg = 'Y' AND AltItemFlg = 'N')) PFCItem

UNION

SELECT	HTILoc as Location,
	AltItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol,
	SalesDol,
	CartonQty,
	CostDol
FROM	(SELECT * FROM tWO2469_HTIUsage 
	 WHERE	HTIItem in (SELECT DISTINCT HTIItem FROM [tWO2469.2_HTIUnmatchedItems] WHERE AltItemFlg='Y')) AltItem
) tmp
GROUP BY Location, ItemNo




select * from tWO2469_HTIUsageSumm

select * from tWO2469_HTIUsageSm

select * from tWO2469_HTIUsageLg