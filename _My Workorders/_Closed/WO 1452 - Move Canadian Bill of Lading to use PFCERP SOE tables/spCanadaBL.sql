

CREATE  PROCEDURE dbo.spCanadaBL
@BLNo varchar(50)
as

print @BLNo

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempLandedCost') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tempLandedCost

--Prime Vendor Code
SELECT	Item, CONVERT(decimal(18, 5), LEFT(Sub1, CHARINDEX(';', Sub1) - 1)) AS AntLandCost,
	CONVERT(decimal(18, 5), LEFT(Sub2, CHARINDEX(';', Sub2) - 1)) AS AntLandCostAlt, [Direct Unit Cost]
INTO	dbo.tempLandedCost
FROM	(SELECT	Item, SUBSTRING(MaxPP, CHARINDEX(';', MaxPP) + 1, 150) AS Sub1,
		SUBSTRING(MaxAltPP, CHARINDEX(';', MaxAltPP) + 1, 150) AS Sub2, [Direct Unit Cost]
	 FROM	(SELECT	IV.[Item No_] AS Item,
			MAX(CONVERT(varchar, PP.[Starting Date], 102) + ';' + CONVERT(varchar, PP.[Anticipated Landed Cost]) + ';' +
			    CONVERT(varchar, (PP.[Anticipated Landed Cost] - PP.[Direct Unit Cost]) / PP.[Direct Unit Cost])) AS MaxPP,
			MAX(CONVERT(varchar, PP.[Starting Date], 102) + ';' + CONVERT(varchar, PP.[Anticipated Landed Cost Alt_]) + ';' +
			    CONVERT(varchar, (PP.[Anticipated Landed Cost] - PP.[Direct Unit Cost]) / PP.[Direct Unit Cost])) AS MaxAltPP,
			PP.[Direct Unit Cost]
		 FROM	[Porteous$Item Vendor] IV INNER JOIN
			[Porteous$Purchase Price] PP
		 ON	IV.[Vendor No_] = PP.[Vendor No_] AND IV.[Item No_] = PP.[Item No_]
		 WHERE	IV.[Priority Ranking] = 1 AND PP.[Direct Unit Cost] > 0 AND
			PP.[Ending Date] = CONVERT(DATETIME, '1753 - 01 - 01 00 : 00 : 00 ', 102)
		 GROUP BY IV.[Item No_], PP.[Direct Unit Cost]) PPMax) PPMax2
ORDER BY Item


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempLandedCostLines') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tempLandedCostLines

--With Avg Cost & Landed Cost & Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
SELECT	TOHDR.No_ AS [TO #], TOLIN.[Line No_],
	(SELECT	COUNT(LinCnt.[Line No_])
	 FROM	[Porteous$Transfer Header] HdrCnt INNER JOIN
		[Porteous$Transfer Line] LinCnt
	 ON	HdrCnt.No_ = LinCnt.[Document No_]
	 WHERE	LEFT(LinCnt.[Item No_], 5) = LEFT(TOLIN.[Item No_], 5) AND HdrCnt.[Inbound Bill of Lading No_] = TOHDR.[Inbound Bill of Lading No_] AND
		LinCnt.[Unit of Measure Code] = TOLIN.[Unit of Measure Code]) AS CatLineCount,
	CAT.No_ AS [Cat No], TOLIN.[Unit of Measure Code], TOLIN.Quantity, TOLIN.[Quantity Shipped] AS [Qty Shipped],
	TOLIN.[Qty_ Shipped (Base)] AS [Base Qty Shipped], CAT.[Description] AS [Cat Desc], TOHDR.[Inbound Bill of Lading No_] AS [BL No],
	TOLIN.[Item No_], TOHDR.[Transfer-from Code], TOLIN.[Gross Weight] * TOLIN.Quantity AS [Gross Wgt Ext],
	TOLIN.[Net Weight] * TOLIN.Quantity AS [Net Wgt Ext], TOLIN.[Net Weight] * 0.4536 * TOLIN.Quantity AS [Net Wgt Ext (KG)],
	SKU.[Unit Cost], SKU.[Unit Cost] * TOLIN.Quantity AS [Avg Cost Ext], tempLandedCost.AntLandCost, tempLandedCost.[Direct Unit Cost],
	(tempLandedCost.AntLandCost - tempLandedCost.[Direct Unit Cost]) / tempLandedCost.[Direct Unit Cost] * 100 AS [Landed Adder %], DUTY.Rate AS [Duty %],
	SKU.[Unit Cost] - SKU.[Unit Cost] * ((tempLandedCost.AntLandCost - tempLandedCost.[Direct Unit Cost]) / tempLandedCost.[Direct Unit Cost]) AS AvgCostAdders,
	(SKU.[Unit Cost] - SKU.[Unit Cost] * ((tempLandedCost.AntLandCost - tempLandedCost.[Direct Unit Cost]) / tempLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) AS [AvgCost Duty Only],
        (SKU.[Unit Cost] - SKU.[Unit Cost] * ((tempLandedCost.AntLandCost - tempLandedCost.[Direct Unit Cost]) / tempLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) * TOLIN.Quantity AS [Avg Cost Ext (CAN)],
	ITEM.[Harmonizing Tariff Code], TOLIN.[Gross Weight], TOLIN.[Net Weight]
INTO	dbo.tempLandedCostLines
FROM	Porteous$Item ITEM INNER JOIN
	tempLandedCost
ON	ITEM.No_ = tempLandedCost.Item INNER JOIN
	[Porteous$Harmonizing Tariff] DUTY
ON	ITEM.[Harmonizing Tariff Code] = DUTY.Code RIGHT OUTER JOIN
	[Porteous$Transfer Header] TOHDR INNER JOIN
	[Porteous$Transfer Line] TOLIN
ON	TOHDR.No_ = TOLIN.[Document No_] INNER JOIN
	[Porteous$Category No_] CAT
ON	LEFT(TOLIN.[Item No_], 5) = CAT.No_ INNER JOIN
	[Porteous$Stockkeeping Unit] SKU
ON	TOLIN.[Item No_] = SKU.[Item No_] AND TOHDR.[Transfer-from Code] = SKU.[Location Code]
ON	tempLandedCost.Item = SKU.[Item No_]
WHERE	(TOHDR.[Inbound Bill of Lading No_] = @BLNo) AND (TOLIN.[Qty_ to Ship] > 0)


--Update NULL records with Avg Cost
UPDATE	dbo.tempLandedCostLines
SET	[AvgCost Duty Only] = [Unit Cost], [Avg Cost Ext (CAN)] = [Avg Cost Ext]
WHERE	([AvgCost Duty Only] IS NULL)

UPDATE	dbo.tempLandedCostLines
SET	AntLandCost = 0
WHERE	(AntLandCost IS NULL)

UPDATE	dbo.tempLandedCostLines
SET	[Direct Unit Cost] = 0
WHERE	([Direct Unit Cost] IS NULL)

UPDATE	dbo.tempLandedCostLines
SET	[Landed Adder %] = 0
WHERE	([Landed Adder %] IS NULL)

UPDATE	dbo.tempLandedCostLines
SET	[Duty %] = 0
WHERE	([Duty %] IS NULL)

UPDATE	dbo.tempLandedCostLines
SET	[AvgCostAdders] = 0
WHERE	([AvgCostAdders] IS NULL)


GO
