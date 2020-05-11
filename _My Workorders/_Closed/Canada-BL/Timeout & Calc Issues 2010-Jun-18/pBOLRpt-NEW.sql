USE [PERP]
GO

/****** Object:  StoredProcedure [dbo].[pBOLRpt]    Script Date: 06/18/2010 17:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[pBOLRpt]
@BLNo varchar(50)
as
----pBOLRpt
----Converted from NV By: Tod Dixon - 2009-Aug-27
----(Original NV SP: EnterpriseSQL.PFClive.spCanadaBL)
----Application: Inventory Management

print @BLNo

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCost') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCost

--Modified to Use West Coast (Branch 15) Replacement Cost instead (the one refreshed weekly)
SELECT	IM.ItemNo as Item
	,isnull(IB.LatestReplacementCost,0) as AntLandCost
	,isnull(IB.LatestReplacementCostAlt,0) as AntLandCostAlt
	,isnull(IB.UnitCost,0) as [Direct Unit Cost]
	,isnull(RPL.PrimeVendorFOBUnitCost,0) as FOBUnitCost
	,isnull(RPL.PrimeVendorFOBSalesAltCost,0) as FOBALtCost
	,isnull(RPL.DutyPercent,0) as DutyPct
INTO	dbo.tLandedCost
FROM	ItemMaster IM (NoLock) INNER JOIN ItemBranch IB (NoLock)
ON	IM.pItemMasterID = IB.fItemMasterID INNER JOIN
	CostCalcSystemLatesRepl RPL (NoLock)
ON	RPL.ItemNo = IM.ItemNo AND RPL.Branch = IB.Location
WHERE	IB.Location ='15'


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCostLines') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCostLines

--With Avg Cost & Landed Cost ListName = 'CategoryDesc'& Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
SELECT	0 AS TrfCount,
	0 AS LineCount,
	CAST(0 AS numeric(31, 6)) AS TotalNetWght,
	0 AS TrfCountLanded,
	0 AS LineCountLanded,
	CAST(0 AS numeric(31, 6)) AS TotalNetWghtLanded,
	TOHDR.OrderNo AS [TO #],
	TOLIN.LineNumber AS [Line No_],
	(SELECT	COUNT(LinCnt.LineNumber)
	 FROM	SOHeaderRel HdrCnt INNER JOIN
		SODetailRel LinCnt
	 ON	HdrCnt.pSOHeaderRelID = LinCnt.fSOHeaderRelID INNER JOIN
		ItemMaster ItemCnt
	 ON	ItemCnt.ItemNo = LinCnt.ItemNo INNER JOIN
		ItemBranch SKUCnt
	 ON	ItemCnt.pItemMasterID = SKUCnt.fItemMasterID 
	 WHERE	HdrCnt.OrderType = 'TO' AND
	 	LEFT(LinCnt.ItemNo, 5) = LEFT(TOLIN.ItemNo, 5) AND
	 	HdrCnt.BOLNO = TOHDR.BOLNO AND ItemCnt.SellStkUM = ITEM.SellStkUM AND
		LinCnt.ItemNo = ItemCnt.ItemNo AND HdrCnt.ShipLoc = SKUCnt.Location) AS CatLineCount,
	CAT.ListValue AS [Cat No],
	ITEM.SellStkUM AS [Unit of Measure Code],
	TOLIN.QtyOrdered AS Quantity,
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		THEN 0
		ELSE TOLIN.QtyShipped
	END AS [Qty Shipped],
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		THEN 0
		ELSE TOLIN.QtyShipped * ITEM.SellStkUMQty
	END AS [Base Qty Shipped],
	CAT.ListDtlDesc AS [Cat Desc],
	TOHDR.BOLNO AS [BL No],
	TOLIN.ItemNo AS [Item No_],
	TOHDR.ShipLoc AS [Transfer-from Code],
	TOLIN.GrossWght * TOLIN.QtyOrdered AS [Gross Wgt Ext],
	TOLIN.NetWght * TOLIN.QtyOrdered AS [Net Wgt Ext],
	TOLIN.NetWght * 0.4536 * TOLIN.QtyOrdered AS [Net Wgt Ext (KG)],
	SKU.UnitCost AS [Unit Cost],
	SKU.UnitCost  * TOLIN.QtyOrdered AS [Avg Cost Ext],
	tLandedCost.AntLandCost AS AntLandCost,
	tLandedCost.FOBUnitCost AS [Direct Unit Cost],
	CASE WHEN tLandedCost.AntLandCost = 0
		THEN 0
		ELSE (tLandedCost.AntLandCost - tLandedCost.FOBUnitCost) / tLandedCost.AntLandCost * 100 
	END AS [Landed Adder %],
	tLandedCost.DutyPct AS [Duty %],
	CASE WHEN tLandedCost.FOBUnitCost = 0
		THEN 0
		ELSE (SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.FOBUnitCost) / tLandedCost.FOBUnitCost))
	END AS AvgCostAdders,
	CASE WHEN tLandedCost.FOBUnitCost = 0
		THEN 0
		ELSE (SKU.UnitCost - (SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.FOBUnitCost) / tLandedCost.FOBUnitCost))) * (1 + tLandedCost.DutyPct / 100)
	END AS [AvgCost Duty Only], 
	CASE WHEN tLandedCost.FOBUnitCost = 0
		THEN 0
		ELSE ((SKU.UnitCost - (SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.FOBUnitCost) / tLandedCost.FOBUnitCost)))) * (1 + tLandedCost.DutyPct / 100)  * TOLIN.QtyOrdered
	END AS [Avg Cost Ext (CAN)],
	ITEM.Tariff AS [Harmonizing Tariff Code],
	TOLIN.GrossWght AS [Gross Weight],
	TOLIN.NetWght AS [Net Weight]
INTO	dbo.tLandedCostLines
FROM	tLandedCost (NoLock) RIGHT OUTER JOIN
	ItemMaster ITEM (NoLock)
ON	ITEM.ItemNo = tLandedCost.Item INNER JOIN
	ItemBranch SKU (NoLock)
ON	ITEM.pItemMasterID = SKU.fItemMasterID RIGHT OUTER JOIN
	SOHeaderRel TOHDR (NoLock) INNER JOIN
	SODetailRel TOLIN (NoLock)
ON	TOHDR.pSOHeaderRelID = TOLIN.fSOHeaderRelID INNER JOIN
	ListMaster LM (NoLock) INNER JOIN
	ListDetail CAT (NoLock)
ON	LM.pListMasterID = CAT.fListMasterID
ON	CAT.ListValue = LEFT(TOLIN.ItemNo, 5)
ON	TOLIN.ItemNo = ITEM.ItemNo
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = @BLNo AND
	TOLIN.ItemNo = ITEM.ItemNo AND TOHDR.ShipLoc = SKU.Location AND
	LM.ListName = 'CategoryDesc'

CREATE CLUSTERED INDEX [idxCatNoBLNO] ON [dbo].[tLandedCostLines] 
(
	[Cat No] ASC,
	[BL No] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


--UPDATE TRFCount, LineCount & TotalNetWght
UPDATE	dbo.tLandedCostLines
SET	TRFCount = Calc.TRFCount,
	LineCount = Calc.LineCount,
	TotalNetWght = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT OrderNo) AS TRFCount,
		COUNT(ItemNo) AS LineCount,
		SUM(NetWght * QtyOrdered) AS TotalNetWght
	 FROM	SOHeaderRel INNER JOIN
		SODetailRel
	 ON	pSOHeaderRelID = fSOHeaderRelID
	 WHERE	OrderType = 'TO' AND BOLNO = @BLNo) Calc


--UPDATE TRFCountLanded, LineCountLanded & TotalNetWghtLanded
UPDATE	dbo.tLandedCostLines
SET	TRFCountLanded = Calc.TRFCount,
	LineCountLanded = Calc.LineCount,
	TotalNetWghtLanded = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT [TO #]) AS TRFCount,
		COUNT([Item No_]) AS LineCount,
		SUM([Net Wgt Ext]) AS TotalNetWght
	 FROM	dbo.tLandedCostLines
	 WHERE	[BL No] = @BLNo) Calc


--Update NULL records with Avg Cost
UPDATE	dbo.tLandedCostLines
SET	[AvgCost Duty Only] = [Unit Cost],
	[Avg Cost Ext (CAN)] = [Avg Cost Ext]
WHERE	([AvgCost Duty Only] IS NULL)

GO