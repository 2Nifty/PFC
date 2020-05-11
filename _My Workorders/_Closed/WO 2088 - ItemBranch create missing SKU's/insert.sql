--Load #MissingSKU with list of missing SKUs
SELECT	Item.pItemMasterID,
	Item.ItemNo,
	Loc.LocID,
	Loc.RegionLocID,
	Item.ItemStat
INTO	#MissingSKU
FROM	tWO1481_LocMaster Loc (NoLock),
	ItemMaster Item (NoLock)
WHERE	Item.ItemStat = 'S' AND
	Item.WebEnabledInd = 1 AND
	Loc.MaintainIMQtyInd='Y' AND
	ISNULL(Loc.RegionLocID, '') <> '' AND
	Item.ItemNo + Loc.LocID NOT IN (SELECT	tmpItem.ItemNo + tmpSKU.Location
					FROM	ItemMaster tmpItem (NoLock) INNER JOIN
						ItemBranch tmpSKU (NoLock)
					ON	tmpItem.pItemMasterID = tmpSKU.fItemMasterID INNER JOIN
						tWO1481_LocMaster tmpLoc (NoLock)
					ON	tmpSKU.Location = tmpLoc.LocID
					WHERE	tmpItem.ItemStat = 'S' AND tmpItem.WebEnabledInd = 1 AND tmpLoc.MaintainIMQtyInd='Y')

--SELECT * FROM #MissingSKU

--INSERT ItemBranch clone records based on RegionLocID
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
SELECT	--MississingSKU.*,
	MissingSKU.LocID, SKU3.fItemMasterID, 0 as ReOrderPoint, SKU3.BreakPoint, 0 as StockInd,
	SKU3.PlanningPartInd, SKU3.MerchandiseInd, SKU3.FinishGoodInd, SKU3.SaleabilityInd,
	SKU3.RequirePlanInd, SKU3.MasterSchedInd, SKU3.ExpenseItemInd, SKU3.RevLvl, SKU3.DesignRevLvl,
	SKU3.QtyUOM, SKU3.CostUOM, SKU3.WghtPer100UOM, SKU3.SuperEquivUOM, SKU3.SuperEquivQty, SKU3.OrderApprovalQty,
	SKU3.EOQ, SKU3.Forecast, SKU3.CatNo, SKU3.SizeNo, SKU3.VarNo, SKU3.CostBasis, SKU3.SellBasis, SKU3.CostFactor, SKU3.PriceFactor,
	SKU3.DiscCd, SKU3.FinishCd, SKU3.AssemblyCd, SKU3.MakeCd, 'N' as SalesVelocityCd, SKU3.FixedVelocityCd, SKU3.PackageCd,
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
	SKU3.ReplacementCost, SKU3.ReplacementCostAlt, SKU3.IMHealth, SKU3.CatVelocityCd, SKU3.Ranking, SKU3.SuggSell,
	SKU3.SuggSellAlt, SKU3.CurrentReplacementCost, SKU3.CurrentReplacementCostAlt, SKU3.PriceCost,
	SKU3.LatestReplacementCost, SKU3.LatestReplacementCostAlt, SKU3.PriceCostAlt, SKU3.StdCostAlt,
	SKU3.SuperEquivDiscPct, SKU3.ROPDays, SKU3.DirectCostAdder, SKU3.OverheadCostAdder, SKU3.IndirectCostAdder
FROM	#MissingSKU MissingSKU INNER JOIN
	ItemBranch SKU3 (NoLock)
ON	MissingSKU.pItemMasterID = SKU3.fItemMasterID AND
	SKU3.Location = MissingSKU.RegionLocID

DROP TABLE #MissingSKU



------------------------------------------------------------------------------------------------------------

--Load #MissingSKU with list of missing SKUs
SELECT	Item.pItemMasterID,
	Item.ItemNo,
	Loc.LocID,
	'15' AS RegionLocID,
	Item.ItemStat
INTO	#MissingSKU
FROM	tWO1481_LocMaster Loc (NoLock),
	ItemMaster Item (NoLock)
WHERE	Item.ItemStat = 'S' AND
	Item.WebEnabledInd = 1 AND
	Loc.MaintainIMQtyInd='Y' AND
	Item.ItemNo + Loc.LocID NOT IN (SELECT	tmpItem.ItemNo + tmpSKU.Location
					FROM	ItemMaster tmpItem (NoLock) INNER JOIN
						ItemBranch tmpSKU (NoLock)
					ON	tmpItem.pItemMasterID = tmpSKU.fItemMasterID INNER JOIN
						tWO1481_LocMaster tmpLoc (NoLock)
					ON	tmpSKU.Location = tmpLoc.LocID
					WHERE	tmpItem.ItemStat = 'S' AND tmpItem.WebEnabledInd = 1 AND tmpLoc.MaintainIMQtyInd='Y')

--SELECT * FROM #MissingSKU

--INSERT ItemBranch clone records based on Branch15
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
SELECT	--MississingSKU.*,
	MissingSKU.LocID, SKU3.fItemMasterID, 0 as ReOrderPoint, SKU3.BreakPoint, 0 as StockInd,
	SKU3.PlanningPartInd, SKU3.MerchandiseInd, SKU3.FinishGoodInd, SKU3.SaleabilityInd,
	SKU3.RequirePlanInd, SKU3.MasterSchedInd, SKU3.ExpenseItemInd, SKU3.RevLvl, SKU3.DesignRevLvl,
	SKU3.QtyUOM, SKU3.CostUOM, SKU3.WghtPer100UOM, SKU3.SuperEquivUOM, SKU3.SuperEquivQty, SKU3.OrderApprovalQty,
	SKU3.EOQ, SKU3.Forecast, SKU3.CatNo, SKU3.SizeNo, SKU3.VarNo, SKU3.CostBasis, SKU3.SellBasis, SKU3.CostFactor, SKU3.PriceFactor,
	SKU3.DiscCd, SKU3.FinishCd, SKU3.AssemblyCd, SKU3.MakeCd, 'N' as SalesVelocityCd, SKU3.FixedVelocityCd, SKU3.PackageCd,
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
	'WO1481-Def' + MissingSKU.RegionLocID AS EntryID, GETDATE() AS EntryDt, null AS ChangeID, null AS ChangeDt, SKU3.StatusCd,
	SKU3.ReplacementCost, SKU3.ReplacementCostAlt, SKU3.IMHealth, SKU3.CatVelocityCd, SKU3.Ranking, SKU3.SuggSell,
	SKU3.SuggSellAlt, SKU3.CurrentReplacementCost, SKU3.CurrentReplacementCostAlt, SKU3.PriceCost,
	SKU3.LatestReplacementCost, SKU3.LatestReplacementCostAlt, SKU3.PriceCostAlt, SKU3.StdCostAlt,
	SKU3.SuperEquivDiscPct, SKU3.ROPDays, SKU3.DirectCostAdder, SKU3.OverheadCostAdder, SKU3.IndirectCostAdder
FROM	#MissingSKU MissingSKU INNER JOIN
	ItemBranch SKU3 (NoLock)
ON	MissingSKU.pItemMasterID = SKU3.fItemMasterID AND
	SKU3.Location = MissingSKU.RegionLocID

DROP TABLE #MissingSKU