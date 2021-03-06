USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pBOLRpt]    Script Date: 06/18/2010 17:44:12 ******/
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

--Prime Vendor Code
/*SELECT	Item,
		isnull(CONVERT(decimal(18, 5), LEFT(Sub1, CHARINDEX(';', Sub1) - 1)),0) AS AntLandCost,
		CONVERT(decimal(18, 5), LEFT(Sub2, CHARINDEX(';', Sub2) - 1)) AS AntLandCostAlt,
		isnull([Direct Unit Cost],0) AS [Direct Unit Cost]
--INTO	dbo.tLandedCost
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
				FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Vendor] IV 
				INNER JOIN OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Price] PP ON	
						IV.[Vendor No_] = PP.[Vendor No_] 
						AND IV.[Item No_] = PP.[Item No_]
				WHERE	IV.[Priority Ranking] = 1 
						AND PP.[Direct Unit Cost] > 0 
						AND PP.[Ending Date] = CONVERT(DATETIME, '1753-01-01 00 : 00 : 00 ', 102)
		 GROUP BY		IV.[Item No_], PP.[Direct Unit Cost]) PPMax) PPMax2
ORDER BY Item
*/

--Move to Use West Coast (Branch 15) Replacement Cost instead (the one refreshed weekly)
Select	IM.ItemNo as Item
		,IB.LatestReplacementCost as AntLandCost
		,IB.LatestReplacementCostAlt as AntLandCostAlt
		,IB.UnitCost as [Direct Unit Cost]
		,RPL.PrimeVendorFOBUnitCost as FOBUnitCost
		,RPL.PrimeVendorFOBSalesAltCost as FOBALtCost
		,RPL.DutyPercent as DutyPct
INTO	dbo.tLandedCost
From	ItemMaster IM (nolock) 
Inner Join ItemBranch IB (nolock) ON
		IM.pItemMasterID = IB.fItemMasterID
INNER Join CostCalcSystemLatesRepl RPL (nolock) ON
		RPL.ItemNo = IM.ItemNo
		And RPL.Branch = IB.Location
Where	IB.Location ='15'

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCostLines') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCostLines

--With Avg Cost & Landed Cost ListName = 'CategoryDesc'& Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
SELECT	
	0 AS TrfCount,
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
		LinCnt.ItemNo = ItemCnt.ItemNo AND HdrCnt.ShipLoc = SKUCnt.Location --AND
--		CASE WHEN HdrCnt.ConfirmShipDt = '' OR HdrCnt.ConfirmShipDt is null
--		     THEN LinCnt.QtyOrdered
--		     ELSE LinCnt.QtyOrdered - LinCnt.QtyShipped
--		END > 0
	 ) AS CatLineCount,
	CAT.ListValue AS [Cat No],
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
	CAT.ListDtlDesc AS [Cat Desc],
	TOHDR.BOLNO AS [BL No],
	TOLIN.ItemNo AS [Item No_],
	TOHDR.ShipLoc AS [Transfer-from Code],
	TOLIN.GrossWght * TOLIN.QtyOrdered AS [Gross Wgt Ext],
	TOLIN.NetWght * TOLIN.QtyOrdered AS [Net Wgt Ext],
	TOLIN.NetWght * 0.4536 * TOLIN.QtyOrdered AS [Net Wgt Ext (KG)],
	SKU.UnitCost AS [Unit Cost],
	SKU.UnitCost  * TOLIN.QtyOrdered AS [Avg Cost Ext],
	isnull(tLandedCost.AntLandCost,0) AS AntLandCost,
--	isnull(tLandedCost.[Direct Unit Cost],0) AS [Direct Unit Cost],
	isnull(tLandedCost.FOBUnitCost,0) AS [Direct Unit Cost],
--	isnull((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost] * 100,0) AS [Landed Adder %],
	CASE	when isnull(tLandedCost.AntLandCost,0) = 0 then 0 
			else (isnull(tLandedCost.AntLandCost,0)-isnull(tLandedCost.FOBUnitCost,0)) / isnull(tLandedCost.AntLandCost,0) * 100 
	End as [Landed Adder %],
	isnull(tLandedCost.DutyPct,0) AS [Duty %],
--	isnull(tLandedCost.[Direct Unit Cost]  - tLandedCost.[Direct Unit Cost]  * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost]),0) AS AvgCostAdders,
	(SKU.UnitCost * ((tLandedCost.AntLandCost-tLandedCost.FOBUnitCost) /tLandedCost.FOBUnitCost)) as AvgCostAdders,
--	(SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + tLandedCost.DutyPct / 100) AS [AvgCost Duty Only],
	(SKU.UnitCost - (SKU.UnitCost * ((tLandedCost.AntLandCost-tLandedCost.FOBUnitCost) /tLandedCost.FOBUnitCost))) * (1 + tLandedCost.DutyPct / 100) AS [AvgCost Duty Only], 
--  (SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + tLandedCost.DutyPct / 100) * TOLIN.QtyOrdered AS [Avg Cost Ext (CAN)],
	((SKU.UnitCost - (SKU.UnitCost * ((tLandedCost.AntLandCost-tLandedCost.FOBUnitCost) /tLandedCost.FOBUnitCost)))) * (1 + tLandedCost.DutyPct / 100)  * TOLIN.QtyOrdered AS [Avg Cost Ext (CAN)],
	ITEM.Tariff AS [Harmonizing Tariff Code],
	TOLIN.GrossWght AS [Gross Weight],
	TOLIN.NetWght AS [Net Weight]
INTO	dbo.tLandedCostLines
FROM	tLandedCost RIGHT OUTER JOIN
	ItemMaster ITEM
ON	ITEM.ItemNo = tLandedCost.Item INNER JOIN
	ItemBranch SKU
ON	ITEM.pItemMasterID = SKU.fItemMasterID 
 --INNER JOIN OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Harmonizing Tariff] DUTY
--ON	ITEM.Tariff = DUTY.Code 
--CSR 06/18/10 Use ERP Tarrif
RIGHT OUTER JOIN SOHeaderRel TOHDR (nolock)
INNER JOIN SODetailRel TOLIN (nolock)
ON	TOHDR.pSOHeaderRelID = TOLIN.fSOHeaderRelID 
--INNER JOIN OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Category No_] CAT
--ON	LEFT(TOLIN.ItemNo, 5) = CAT.[No_]
--Use ERP Category Lookup
INNER JOIN ListMaster LM (nolock)
Inner Join ListDetail CAT (nolock) ON
		LM.pListMasterID = CAT.fListMasterID ON
		CAT.ListValue = LEFT(TOLIN.ItemNo, 5)
ON	TOLIN.ItemNo = ITEM.ItemNo
WHERE	TOHDR.OrderType = 'TO' 
		AND TOHDR.BOLNO = @BLNo 
		AND	TOLIN.ItemNo = ITEM.ItemNo AND TOHDR.ShipLoc = SKU.Location
		AND LM.ListName = 'CategoryDesc'
--		CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
--		     THEN TOLIN.QtyOrdered
--		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
--		END > 0 AND

CREATE CLUSTERED INDEX [idxCatNoBLNO] ON [dbo].[tLandedCostLines] 
(
	[Cat No] ASC,
	[BL No] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


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
