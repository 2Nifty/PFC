--ItemMaster Record
Select	WC.[No_] as ItemNo
	,WC.[Name] as ItemDesc
	,'M' as ItemStat
	,'N' as Rectrans
	,WC.[Work Center Group Code] as CatDesc
	,left(isnull(RH.[Description],''),30) as ItemSize
	,1 as PcsPerPallet
	,1 as SellStkUMQty
	,'PC' as CostPurUM
	,'PC' as PriceUM
	,'PC' as SellUM
	,'PC' as StkUM
	,0 as Wght
	,0 as GrossWght
	,0 as CUMGrossWght
	,0 as CUMNetWght
	,0 as HundredWght
	,'N' as SerialNoCod
	,'N' as FormatCd
	,0 as WebEnabledInd
	,CAST({ fn CURDATE() } AS DATETIME) as EntryDt
	,System_User as EntryId
	,0 as ListPrice
	,isnull([Weight Factor],0) as DensityFactor
	/*,WC.[Overhead Rate] as LtsVarBurdenAmt
	,WC.[Indirect Cost %] as LbrBurdenPct
	,WC.[Direct Unit Cost] as LtsFixBurdenAmt
	,WC.[Unit Cost] as UnitCost
	*/
FROM	[Porteous$Work Center] WC Left Outer Join
	[Porteous$Routing Header] RH
ON	WC.[No_] = RH.[No_] Left Outer Join
	[Porteous$Package Size] Pkg
ON	WC.[No_] = Pkg.[Code]
Order by WC.[No_]