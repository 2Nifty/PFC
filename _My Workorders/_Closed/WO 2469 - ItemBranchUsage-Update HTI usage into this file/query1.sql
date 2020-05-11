select * from ItemAlias where isnull(AliasType,'')=''



select distinct AliasType from ItemAlias


select distinct OrganizationNo from ItemAlias order by OrganizationNo


select * from Itemalias where AliasItemNo='USS38Z'


select --distinct aliastype
	*
from 	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemAlias] Alias
where AliasWhseNo='HTI' and AliasType='C'


-----------------------------------------------------------------------


SELECT	'10' as HTILoc,
	[HTI Part #] as HTIPart,
	ItemNo,
	[Description] as HTIDescription,
	[Packing] as HTIPack,
	[Sales Revenue] as HTISales,
	[Cartons] as HTICartons,
	[Cost] as HTICost,
	isnull([Sales Revenue],0) / 52 as HTISalesWk,
	isnull([Cartons],0) / 52 as HTICartonsWk,
	isnull([Cost],0) / 52 as HTICostWk
FROM	[Chicago$] LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemAlias]
ON	[HTI Part #] = AliasItemNo



select *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemAlias]
WHERE	AliasWhseNo='HTI' and AliasType='SO' and AliasItemNo = '00020-2408-101'


select pfcitem, count(*) from tWO2469_HTIUsage
where PFCItem in 
(select AliasItemNo
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemAlias]
WHERE	AliasWhseNo='HTI' and AliasType='SO')
group by pfcitem


select * from tWO2469_HTIUsage



select * from tWO2469_HTIAlias
select * FROM ItemMaster

select * from tWO2469_HTIUsage 
where isnull(PFCItem,'')=''

exec sp_columns Item

select * from itembranchusage

--------------------------------------------------------------------------------------------------------------------


select distinct HTIItem from tWO2469_HTIUsage where PFCItemFlg='N'






select * from tWO2469_HTIUsage where PFCItemFlg='Y'









INSERT
INTO	tWO2469_HTI_IBU
	(Location,
	 ItemNo,
	 Period,
	 NoOfSales,
	 SalesQty,
	 SalesDol,
	 SalesWght,
	 CostDol)
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	@Period as Period,
	isnull(HTIWkCartonQty,0) * @Weeks as NoOfSales,
	isnull(HTIWkCartonQty,0) * @Weeks as SalesQty,
	isnull(HTIWkSalesDol,0) * @Weeks as SalesDol,
	isnull(HTIWkNetWght,0) * @Weeks as SalesWght,
	isnull(HTIWkCostDol,0) * @Weeks as CostDol
from tWO2469_HTIUsage where PFCItemFlg='Y'


--truncate table tWO2469_HTI_IBU
select distinct Period FROM tWO2469_HTI_IBU




--Load tWO2469_HTI_IBU
INSERT
INTO	tWO2469_HTI_IBU
	(Location,
	 ItemNo,
	 Period,
	 NoOfSales,
	 SalesQty,
	 SalesDol,
	 SalesWght,
	 CostDol)
SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSales,
	isnull(Usage.SalesQty,0) * isnull(Weeks,4) as SalesQty,
	isnull(Usage.SalesDol,0) * isnull(Weeks,4) as SalesDol,
	isnull(Usage.SalesWght,0) * isnull(Weeks,4) as SalesWght,
	isnull(Usage.CostDol,0) * isnull(Weeks,4) as CostDol
FROM	(SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= 201004 AND 
			FiscalCalYear * 100 + FiscalCalMonth <= 201103) tmp
	group by Period) Per,
	(SELECT	HTILoc as Location,
		PFCItem as ItemNo,
		isnull(HTIWkCartonQty,0) as NoOfSales,
		isnull(HTIWkCartonQty,0) as SalesQty,
		isnull(HTIWkSalesDol,0) as SalesDol,
		isnull(HTIWkNetWght,0) as SalesWght,
		isnull(HTIWkCostDol,0) as CostDol
	 FROM	tWO2469_HTIUsage
	 WHERE	PFCItemFlg='Y') Usage








select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemAlias] Alias


SELECT *
FROM	tWO2469_HTIUsage





exec sp_columns LocMaster


select * from LocMaster





