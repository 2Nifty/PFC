--Valid IM Locaitons
select * from LocMaster
where MaintainIMQtyInd='Y'
order by LocID




--SKUs To Be Generated
SELECT	Item.pItemMasterID,
	Item.ItemNo,
	Loc.LocID,
	Loc.RegionLocID,
	Item.ItemStat
FROM	LocMaster Loc (NoLock),
	ItemMaster Item (NoLock)
WHERE	Item.ItemStat = 'S' AND
	Item.WebEnabledInd = 1 AND
	Loc.MaintainIMQtyInd='Y' AND
	Item.ItemNo + Loc.LocID NOT IN (SELECT	Item.ItemNo + SKU.Location
					FROM	ItemMaster Item (NoLock) INNER JOIN
						ItemBranch SKU (NoLock)
					ON	Item.pItemMasterID = SKU.fItemMasterID INNER JOIN
						LocMaster Loc (NoLock)
					ON	SKU.Location = Loc.LocID
					WHERE	Item.ItemStat = 'S' AND Item.WebEnabledInd = 1 AND Loc.MaintainIMQtyInd='Y')
ORDER BY Item.ItemNo, Loc.LocID




exec sp_columns LocMaster

exec sp_columns Itembranch
select * from ItemBranch where fItemMasterID=1



--Total SKUs on file
SELECT	Item.pItemMasterID,
	Item.ItemNo,
	SKU.Location,
	Item.ItemStat
FROM	ItemMaster Item (NoLock) INNER JOIN
	ItemBranch SKU (NoLock)
ON	Item.pItemMasterID = SKU.fItemMasterID INNER JOIN
	LocMaster Loc (NoLock)
ON	SKU.Location = Loc.LocID
WHERE	Item.ItemStat = 'S' AND Item.WebEnabledInd = 1 AND Loc.MaintainIMQtyInd='Y' AND pItemMasterID < 50
ORDER BY Item.ItemNo, SKU.Location


----------------------------------------------------------------------------------


INSERT INTO	ItemBranch
		(Location, fItemMasterID, ReOrderPoint, BreakPoint, StockInd,
		 PlanningPartInd, MerchandiseInd, FinishGoodInd, SaleabilityInd,
		 RequirePlanInd, MasterSchedInd, ExpenseItemInd, RevLvl, DesignRevLvl,
		 QtyUOM, CostUOM, WghtPer100UOM, SuperEquivUOM, SuperEquivQty, OrderApprovalQty,
		 EOQ, Forecast, CatNo, SizeNo, VarNo, CostBasis, SellBasis, CostFactor, PriceFactor,
		 DiscCd, FinishCd, AssemblyCd, MakeCd, SalesVelocityCd, FixedVelocityCd, PackageCd,
		 PackageCostCd, UnitCost, AvgCost, StdCost, RepCost, LandedCost, LastLandedCost,
		 StdMtlCost, StdLbrCost, StdOperCost, StdOtherCost, FutureUnitCost, LtstMatlCost,
		 LtstLbrCost, LtstOperCost, LtstOtherCost, PrevAvgCost, PrevStdCost, PrevUnitCost,
		 UnitPrice1, UnitPrice2, ListPrice, PrevPrice1, FuturePrice1, FuturePrice2,
		 FutureListPrice, StdFixBurdenAmt, StdVarBurdenAmt, MatlBurdenPct, LbrBurdenPct,
		 LtstFixBurdenAmt, LtstVarBurdenAmt, PriceEffectDt, CostEffectDt, LastCostDt,
		 AvgCostDt, StdCostDt, PrevLastCostDt, PrevAvgCostDt, PrevStdCostDt, LastMtlCostDt,
		 LastLbrCostDt, UnitCostDt, FutureCostDt, PrevUnitCostDt, FutUnitCostDt, FutPrice1Dt,
		 FutPrice2Dt, FutListPriceDt, LastRecdDt, LastOrderDt, OrderRulesRevDt, MosFactor,
		 MosModPltng, MosModCorpFixVelocity, MosModLocation, LimitType, LimitAmt, LTSafetyStk,
		 WeeklyUsage, BlanketOrderOrderPoint, BdCode, BdCode1, BdCode2, LbrEscalation,
		 MtlEscalation, StdLbrHrs, LtstLbrHrs, OrderRulesRevID, AnalystID, BuyerID,
		 EntryID, EntryDt, ChangeID, ChangeDt, StatusCd,
		 ReplacementCost, ReplacementCostAlt, IMHealth, CatVelocityCd, Ranking, SuggSell,
		 SuggSellAlt, CurrentReplacementCost, CurrentReplacementCostAlt, PriceCost,
		 LatestReplacementCost, LatestReplacementCostAlt, PriceCostAlt, StdCostAlt,
		 SuperEquivDiscPct, ROPDays, DirectCostAdder, OverheadCostAdder, IndirectCostAdder)


SELECT	MissingSKU.*,
	MissingSKU.LocID, SKU3.fItemMasterID, SKU3.ReOrderPoint, SKU3.BreakPoint, SKU3.StockInd,
	SKU3.PlanningPartInd, SKU3.MerchandiseInd, SKU3.FinishGoodInd, SKU3.SaleabilityInd,
	SKU3.RequirePlanInd, SKU3.MasterSchedInd, SKU3.ExpenseItemInd, SKU3.RevLvl, SKU3.DesignRevLvl,
	SKU3.QtyUOM, SKU3.CostUOM, SKU3.WghtPer100UOM, SKU3.SuperEquivUOM, SKU3.SuperEquivQty, SKU3.OrderApprovalQty,
	SKU3.EOQ, SKU3.Forecast, SKU3.CatNo, SKU3.SizeNo, SKU3.VarNo, SKU3.CostBasis, SKU3.SellBasis, SKU3.CostFactor, SKU3.PriceFactor,
	SKU3.DiscCd, SKU3.FinishCd, SKU3.AssemblyCd, SKU3.MakeCd, SKU3.SalesVelocityCd, SKU3.FixedVelocityCd, SKU3.PackageCd,
	SKU3.PackageCostCd, SKU3.UnitCost, SKU3.AvgCost, SKU3.StdCost, SKU3.RepCost, SKU3.LandedCost, SKU3.LastLandedCost,
	SKU3.StdMtlCost, SKU3.StdLbrCost, SKU3.StdOperCost, SKU3.StdOtherCost, SKU3.FutureUnitCost, SKU3.LtstMatlCost,
	SKU3.LtstLbrCost, SKU3.LtstOperCost, SKU3.LtstOtherCost, SKU3.PrevAvgCost, SKU3.PrevStdCost, SKU3.PrevUnitCost,
	SKU3.UnitPrice1, SKU3.UnitPrice2, SKU3.ListPrice, SKU3.PrevPrice1, SKU3.FuturePrice1, SKU3.FuturePrice2,
	SKU3.FutureListPrice, SKU3.StdFixBurdenAmt, SKU3.StdVarBurdenAmt, SKU3.MatlBurdenPct, SKU3.LbrBurdenPct,
	SKU3.LtstFixBurdenAmt, SKU3.LtstVarBurdenAmt, SKU3.PriceEffectDt, SKU3.CostEffectDt, SKU3.LastCostDt,
	SKU3.AvgCostDt, SKU3.StdCostDt, SKU3.PrevLastCostDt, SKU3.PrevAvgCostDt, SKU3.PrevStdCostDt, SKU3.LastMtlCostDt,
	SKU3.LastLbrCostDt, SKU3.UnitCostDt, SKU3.FutureCostDt, SKU3.PrevUnitCostDt, SKU3.FutUnitCostDt, SKU3.FutPrice1Dt,
	SKU3.FutPrice2Dt, SKU3.FutListPriceDt, SKU3.LastRecdDt, SKU3.LastOrderDt, SKU3.OrderRulesRevDt, SKU3.MosFactor,
	SKU3.MosModPltng, SKU3.MosModCorpFixVelocity, SKU3.MosModLocation, SKU3.LimitType, SKU3.LimitAmt, SKU3.LTSafetyStk,
	SKU3.WeeklyUsage, SKU3.BlanketOrderOrderPoint, SKU3.BdCode, SKU3.BdCode1, SKU3.BdCode2, SKU3.LbrEscalation,
	SKU3.MtlEscalation, SKU3.StdLbrHrs, SKU3.LtstLbrHrs, SKU3.OrderRulesRevID, SKU3.AnalystID, SKU3.BuyerID,
	'WO1481-Rgn' + MissingSKU.RegionLocID AS EntryID, GETDATE() AS EntryDt, null AS ChangeID, null AS ChangeDt, SKU3.StatusCd,
--	'WO1481-Def' + MissingSKU.RegionLocID AS EntryID, GETDATE() AS EntryDt, null AS ChangeID, null AS ChangeDt, SKU3.StatusCd,
	SKU3.ReplacementCost, SKU3.ReplacementCostAlt, SKU3.IMHealth, SKU3.CatVelocityCd, SKU3.Ranking, SKU3.SuggSell,
	SKU3.SuggSellAlt, SKU3.CurrentReplacementCost, SKU3.CurrentReplacementCostAlt, SKU3.PriceCost,
	SKU3.LatestReplacementCost, SKU3.LatestReplacementCostAlt, SKU3.PriceCostAlt, SKU3.StdCostAlt,
	SKU3.SuperEquivDiscPct, SKU3.ROPDays, SKU3.DirectCostAdder, SKU3.OverheadCostAdder, SKU3.IndirectCostAdder
FROM	(SELECT	Item1.pItemMasterID,
		Item1.ItemNo,
		Loc1.LocID,
		Loc1.RegionLocID,
--		'15' AS RegionLocID,
		Item1.ItemStat
	 FROM	LocMaster Loc1 (NoLock),
		ItemMaster Item1 (NoLock)
	 WHERE	Item1.ItemStat = 'S' AND
		Item1.WebEnabledInd = 1 AND
		Loc1.MaintainIMQtyInd='Y' AND
		ISNULL(Loc1.RegionLocID, '') <> '' AND
		Item1.ItemNo + Loc1.LocID NOT IN (SELECT Item2.ItemNo + SKU2.Location
						  FROM	 ItemMaster Item2 (NoLock) INNER JOIN
							 ItemBranch SKU2 (NoLock)
						  ON	 Item2.pItemMasterID = SKU2.fItemMasterID INNER JOIN
							 LocMaster Loc2 (NoLock)
						  ON	 SKU2.Location = Loc2.LocID
						  WHERE	 Item2.ItemStat = 'S' AND Item2.WebEnabledInd = 1 AND Loc2.MaintainIMQtyInd='Y')) MissingSKU INNER JOIN
	ItemBranch SKU3 (NoLock)
ON	MissingSKU.pItemMasterID = SKU3.fItemMasterID AND
	SKU3.Location = MissingSKU.RegionLocID
--WHERE	ISNULL(MissingSKU.RegionLocID, '') <> ''



-------------------------------------------------------------------------------------------


delete from ItemBranch where left(entryID,7)='WO1481-'

SELECT * FROM ItemBranch (NoLock) WHERE left(entryID,7)='WO1481-'




SELECT	count(*), Item.ItemNo
FROM	ItemMaster Item (NoLock) INNER JOIN
	ItemBranch SKU (NoLock)
ON	Item.pItemMasterID = SKU.fItemMasterID
WHERE	left(SKU.EntryID,10)='WO1481-Def'
and	left(right(Item.ItemNo,3),1)='9'
--and	left(right(Item.ItemNo,3),2)<>'40'
--and	left(right(Item.ItemNo,3),2)<>'04'
group by Item.ItemNo
order by ItemNo



--regionlocid
SELECT	right(SKU.EntryID,2) as CloneFromLoc, Item.ItemNo, SKU.*
FROM	ItemMaster Item (NoLock) INNER JOIN
	ItemBranch SKU (NoLock)
ON	Item.pItemMasterID = SKU.fItemMasterID
WHERE	left(SKU.EntryID,10)='WO1481-Rgn'

and Item.ItemNo in
('00020-2410-020',
'00020-2422-020',
'00022-2552-401',
'00022-2822-411',
'00022-2863-021',
'00024-2870-504',
'00024-2874-501',
'00050-3224-400',
'00050-3440-400',
'00051-2814-021',
'00056-2410-040',
'00056-2433-041',
'00056-2750-040',
'00080-2614-402',
'00081-3216-402',
'00090-3026-702',
'00090-3433-202',
'00105-2510-021',
'00105-2516-022',
'00105-2718-020',
'00110-2616-404',
'00121-2620-701',
'00154-3242-000',
'00156-2825-004',
'00157-2820-100',
'00216-5200-004',
'00217-4600-000',
'00243-4000-042',
'00370-4200-514',
'00384-2824-014',
'00384-3030-080',
'00400-0640-411',
'00400-2552-021',
'00761-2016-700',
'00761-2016-720',
'00761-2016-780',
'00762-0001-752',
'00764-0100-500',
'00790-0826-429',
'01110-2626-500',
'01900-2530-200',
'20056-0840-090',
'20056-0845-041',
'99999-6670-204')

ORDER BY Item.ItemNo, SKU.Location


--br15
SELECT	right(SKU.EntryID,2) as CloneFromLoc, Item.ItemNo, SKU.*
FROM	ItemMaster Item (NoLock) INNER JOIN
	ItemBranch SKU (NoLock)
ON	Item.pItemMasterID = SKU.fItemMasterID
WHERE	left(SKU.EntryID,10)='WO1481-Def'


and Item.ItemNo in
('00020-2410-020',
'00020-2422-020',
'00022-2552-401',
'00022-2822-411',
'00022-2863-021',
'00024-2870-504',
'00024-2874-501',
'00050-3224-400',
'00050-3440-400',
'00051-2814-021',
'00056-2410-040',
'00056-2433-041',
'00056-2750-040',
'00080-2614-402',
'00081-3216-402',
'00090-3026-702',
'00090-3433-202',
'00105-2510-021',
'00105-2516-022',
'00105-2718-020',
'00110-2616-404',
'00121-2620-701',
'00154-3242-000',
'00156-2825-004',
'00157-2820-100',
'00216-5200-004',
'00217-4600-000',
'00243-4000-042',
'00370-4200-514',
'00384-2824-014',
'00384-3030-080',
'00400-0640-411',
'00400-2552-021',
'00761-2016-700',
'00761-2016-720',
'00761-2016-780',
'00762-0001-752',
'00764-0100-500',
'00790-0826-429',
'01110-2626-500',
'01900-2530-200',
'20056-0840-090',
'20056-0845-041',
'99999-6670-204')

ORDER BY Item.ItemNo, SKU.Location




exec sp_columns ItemBranch


select * from ItemBranch where (fItemMasterID=4 or fItemMasterID=16) and (Location='15' or EntryID='WO2088')
order by fItemMasterID, Location