select BOLNO, * from SOHeaderRel 
update SOHeaderRel set BOLNO='060242'
where OrderNo in 
(102385,
150217,
96436,
122649,
122636,
140035,
134715,
101565,
143269,
134716,
136486,
150258,
148298,
150257,
131123,
139981,
132221,
129483,
129482,
139980,
121967,
115986,
115987)



select BOLNO, * from TOHeaderHist 
--update TOHeaderHist set BOLNO='060242'
where OrderNo in 
(102385,
150217,
96436,
122649,
122636,
140035,
134715,
101565,
143269,
134716,
136486,
150258,
148298,
150257,
131123,
139981,
132221,
129483,
129482,
139980,
121967,
115986,
115987)



select BOLNO, InvoiceDt as InvDt, * from SOHeaderRel where orderType='TO' and InvoiceDt is not null and BOLNO='' --and OrderNo='150293'
and InvoiceDt > getdate()-2
order by InvoiceDt

select BOLNO, InvoiceDt as InvDt, * from TOHeaderHist where orderType='TO' and InvoiceDt is not null and BOLNO='' and OrderNo='150293'
order by InvoiceDt



update SOHeaderRel set BOLNO='TODTEST' where orderType='TO' and InvoiceDt is not null and BOLNO='' and InvoiceDt > getdate()-2

update SOHeaderRel set BOLNO='' where BOLNO='TODTEST'


select * from SOHeaderRel where BOLNO='TODTEST'

SELECT	COUNT(DISTINCT OrderNo) AS TRFCount,
		COUNT(ItemNo) AS LineCount,
		SUM(NetWght * QtyOrdered) AS TotalNetWght
	 FROM	SOHeaderRel INNER JOIN
		SODetailRel
	 ON	pSOHeaderRelID = fSOHeaderRelID
	 WHERE	OrderType = 'TO' AND BOLNO = '060242B'



exec pBOLRpt '060242'







select  TOHDR.ConfirmShipDt, * from SOHeaderRel TOHDR --inner join SODetailRel TOLIN on pSOHeaderRelID = fSOHeaderRelID
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = '060242'

select  TOHDR.ConfirmShipDt, TOLIN.QtyOrdered, TOLIN.QtyShipped, TOLIN.* from SOHeaderRel TOHDR inner join SODetailRel TOLIN on pSOHeaderRelID = fSOHeaderRelID
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = '060242'



select TOLIN.* from SOHeaderRel TOHDR inner join SODetailRel TOLIN on pSOHeaderRelID = fSOHeaderRelID
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = '060242B' AND
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN TOLIN.QtyOrdered
		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
	END > 0 AND
	TOLIN.ItemNo = ITEM.ItemNo --AND TOHDR.ShipLoc = SKU.Location









if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tLandedCostLines060242') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tLandedCostLines060242

--With Avg Cost & Landed Cost & Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
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
		LinCnt.ItemNo = ItemCnt.ItemNo AND HdrCnt.ShipLoc = SKUCnt.Location) AS CatLineCount,
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
	TOHDR.ShipLoc AS [Transfer-from Code],
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
INTO	dbo.tLandedCostLines060242
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
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = '060242' AND
--	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
--		     THEN TOLIN.QtyOrdered
--		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
--	END > 0 AND
	TOLIN.ItemNo = ITEM.ItemNo AND TOHDR.ShipLoc = SKU.Location


--UPDATE TRFCount, LineCount & TotalNetWght
UPDATE	dbo.tLandedCostLines060242
SET	TRFCount = Calc.TRFCount,
	LineCount = Calc.LineCount,
	TotalNetWght = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT OrderNo) AS TRFCount,
		COUNT(ItemNo) AS LineCount,
		SUM(NetWght * QtyOrdered) AS TotalNetWght
	 FROM	SOHeaderRel INNER JOIN
		SODetailRel
	 ON	pSOHeaderRelID = fSOHeaderRelID
	 WHERE	OrderType = 'TO' AND BOLNO = '060242') Calc


--UPDATE TRFCountLanded, LineCountLanded & TotalNetWghtLanded
UPDATE	dbo.tLandedCostLines060242
SET	TRFCountLanded = Calc.TRFCount,
	LineCountLanded = Calc.LineCount,
	TotalNetWghtLanded = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT [TO #]) AS TRFCount,
		COUNT([Item No_]) AS LineCount,
		SUM([Net Wgt Ext]) AS TotalNetWght
	 FROM	dbo.tLandedCostLines060242
	 WHERE	[BL No] = '060242') Calc


--Update NULL records with Avg Cost
UPDATE	dbo.tLandedCostLines060242
SET	[AvgCost Duty Only] = [Unit Cost],
	[Avg Cost Ext (CAN)] = [Avg Cost Ext]
WHERE	([AvgCost Duty Only] IS NULL)





select * from tLandedCostLines060242


SELECT     [BL No], [Cat No], [Cat Desc], SUM(Quantity) AS CatQty, [Unit of Measure Code], CatLineCount, SUM([Avg Cost Ext]) AS [Avg Cost Ext],
           SUM([Avg Cost Ext (CAN)]) AS [Declared Cost Ext], SUM([Gross Wgt Ext]) AS [Gross Wgt], SUM([Net Wgt Ext]) AS [Net Wgt], SUM([Net Wgt Ext (KG)]) AS [Net Wgt (KG)]
FROM       tLandedCostLines060242
GROUP BY [Cat No], [Cat Desc], [Unit of Measure Code], CatLineCount, [BL No]
ORDER BY [Cat No]
