
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pBOLRpt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pBOLRpt]
Go


CREATE  PROCEDURE [dbo].[pBOLRpt]
@BLNo varchar(50)
as

----pBOLRpt
----Converted from NV By: Tod Dixon - 2009-Aug-27
----(Original NV SP: EnterpriseSQL.PFClive.spCanadaBL)
----Application: Inventory Management


print @BLNo

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCost') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCost

--Prime Vendor Code
SELECT	Item,
	isnull(CONVERT(decimal(18, 5), LEFT(Sub1, CHARINDEX(';', Sub1) - 1)),0) AS AntLandCost,
	CONVERT(decimal(18, 5), LEFT(Sub2, CHARINDEX(';', Sub2) - 1)) AS AntLandCostAlt,
	isnull([Direct Unit Cost],0) AS [Direct Unit Cost]
INTO	dbo.tLandedCost
FROM	(SELECT	Item,
		SUBSTRING(MaxPP, CHARINDEX(';', MaxPP) + 1, 150) AS Sub1,
		SUBSTRING(MaxAltPP, CHARINDEX(';', MaxAltPP) + 1, 150) AS Sub2,
		[Direct Unit Cost]
	 FROM	(SELECT	IV.[Item No_] AS Item,
			MAX(CONVERT(varchar, PP.[Starting Date], 102) + ';' + CONVERT(varchar, PP.[Anticipated Landed Cost]) + ';' +
			    CONVERT(varchar, (PP.[Anticipated Landed Cost] - PP.[Direct Unit Cost]) / PP.[Direct Unit Cost])) AS MaxPP,
			MAX(CONVERT(varchar, PP.[Starting Date], 102) + ';' + CONVERT(varchar, PP.[Anticipated Landed Cost Alt_]) + ';' +
			    CONVERT(varchar, (PP.[Anticipated Landed Cost] - PP.[Direct Unit Cost]) / PP.[Direct Unit Cost])) AS MaxAltPP,
			PP.[Direct Unit Cost]
		 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Vendor] IV INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Price] PP
		 ON	IV.[Vendor No_] = PP.[Vendor No_] AND IV.[Item No_] = PP.[Item No_]
		 WHERE	IV.[Priority Ranking] = 1 AND PP.[Direct Unit Cost] > 0 AND
			PP.[Ending Date] = CONVERT(DATETIME, '1753-01-01 00 : 00 : 00 ', 102)
		 GROUP BY IV.[Item No_], PP.[Direct Unit Cost]) PPMax) PPMax2
ORDER BY Item


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCostLines') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCostLines

--With Avg Cost & Landed Cost & Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
SELECT	TOHDR.OrderNo AS [TO #],
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
		LinCnt.ItemNo = ItemCnt.ItemNo AND HdrCnt.OrderLoc = SKUCnt.Location AND
		CASE WHEN HdrCnt.ConfirmShipDt = '' OR HdrCnt.ConfirmShipDt is null
		     THEN LinCnt.QtyOrdered
		     ELSE LinCnt.QtyOrdered - LinCnt.QtyShipped
		END > 0) AS CatLineCount,
	CAT.No_ AS [Cat No],
	ITEM.SellStkUM AS [Unit of Measure Code],
	TOLIN.QtyOrdered AS Quantity,
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN 0
		     ELSE TOLIN.QtyShipped
	END AS [Qty Shipped],
--	TOLIN.[Qty_ Shipped (Base)] AS [Base Qty Shipped],
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN 0
		     ELSE TOLIN.QtyShipped * ITEM.SellStkUMQty
	END AS [Base Qty Shipped],
	CAT.[Description] AS [Cat Desc],
	TOHDR.BOLNO AS [BL No],
	TOLIN.ItemNo AS [Item No_],
	TOHDR.OrderLoc AS [Transfer-from Code],
	TOLIN.GrossWght * TOLIN.QtyOrdered AS [Gross Wgt Ext],
	TOLIN.NetWght * TOLIN.QtyOrdered AS [Net Wgt Ext],
	TOLIN.NetWght * 0.4536 * TOLIN.QtyOrdered AS [Net Wgt Ext (KG)],
	SKU.UnitCost AS [Unit Cost],
	SKU.UnitCost * TOLIN.QtyOrdered AS [Avg Cost Ext],
	isnull(tLandedCost.AntLandCost,0) AS AntLandCost,
	isnull(tLandedCost.[Direct Unit Cost],0) AS [Direct Unit Cost],
	isnull((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost] * 100,0) AS [Landed Adder %],
	isnull(DUTY.Rate,0) AS [Duty %],
	isnull(SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost]),0) AS AvgCostAdders,
	(SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) AS [AvgCost Duty Only],
        (SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) * TOLIN.QtyOrdered AS [Avg Cost Ext (CAN)],
	ITEM.Tariff AS [Harmonizing Tariff Code],
	TOLIN.GrossWght AS [Gross Weight],
	TOLIN.NetWght AS [Net Weight]
INTO	dbo.tLandedCostLines
FROM	tLandedCost RIGHT OUTER JOIN
	ItemMaster ITEM
ON	ITEM.ItemNo = tLandedCost.Item INNER JOIN
	ItemBranch SKU
ON	ITEM.pItemMasterID = SKU.fItemMasterID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Harmonizing Tariff] DUTY
ON	ITEM.Tariff = DUTY.Code RIGHT OUTER JOIN
	SOHeaderRel TOHDR INNER JOIN
	SODetailRel TOLIN
ON	TOHDR.pSOHeaderRelID = TOLIN.fSOHeaderRelID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Category No_] CAT
ON	LEFT(TOLIN.ItemNo, 5) = CAT.[No_]
ON	TOLIN.ItemNo = ITEM.ItemNo
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = @BLNo AND
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN TOLIN.QtyOrdered
		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
	END > 0 AND
	TOLIN.ItemNo = ITEM.ItemNo AND TOHDR.OrderLoc = SKU.Location


--Update NULL records with Avg Cost
UPDATE	dbo.tLandedCostLines
SET	[AvgCost Duty Only] = [Unit Cost],
	[Avg Cost Ext (CAN)] = [Avg Cost Ext]
WHERE	([AvgCost Duty Only] IS NULL)

--UPDATE	dbo.tLandedCostLines
--SET	AntLandCost = 0
--WHERE	(AntLandCost IS NULL)

--UPDATE	dbo.tLandedCostLines
--SET	[Direct Unit Cost] = 0
--WHERE	([Direct Unit Cost] IS NULL)

--UPDATE	dbo.tLandedCostLines
--SET	[Landed Adder %] = 0
--WHERE	([Landed Adder %] IS NULL)

--UPDATE	dbo.tLandedCostLines
--SET	[Duty %] = 0
--WHERE	([Duty %] IS NULL)

--UPDATE	dbo.tLandedCostLines
--SET	[AvgCostAdders] = 0
--WHERE	([AvgCostAdders] IS NULL)


GO
