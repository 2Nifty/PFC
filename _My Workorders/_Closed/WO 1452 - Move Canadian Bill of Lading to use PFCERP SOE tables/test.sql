update SOHeaderRel set BOLNO='TodTest2' where OrderNo='14689'



select ConfirmShipDt, QtyOrdered, QtyShipped
from SOHeader inner join SODetail
on pSOHeaderID=SODetail.fSOHeaderID
where OrderNo='1005293'

select ConfirmShipDt, QtyOrdered, QtyShipped
from SOHeaderRel inner join SODetailRel
on pSOHeaderRelID=fSOHeaderRelID
where OrderNo='14687'



exec pBOLRpt "TodTest"


select * from tLandedCostLines



select BOLNO, ConfirmShipDt, ItemNo, QtyOrdered, QtyShipped, SODetail.*
from SOHeader inner join SODetail
on pSOHeaderID=SODetail.fSOHeaderID
where OrderNo='1005293' or OrderNo='1005295' or OrderNo='1005289'
order by OrderNo, LineNumber


select BOLNO, ConfirmShipDt, OrderNo, ItemNo, QtyOrdered, QtyShipped--, SODetailRel.*
from SOHeaderRel inner join SODetailRel
on pSOHeaderRelID=fSOHeaderRelID
where OrderNo='14687' or OrderNo='14689' or OrderNo='14683'
order by OrderNo, LineNumber



update SODetailRel
Set QtyShipped=1
from SOHeaderRel inner join SODetailRel
on pSOHeaderRelID=fSOHeaderRelID
where OrderNo='14687' and ItemNo='00080-3466-042'




1005293






--With Avg Cost & Landed Cost & Net Wgt Ext in KG & Landed Calcs & Cat Line Cnt
SELECT	TOHDR.OrderNo AS [TO #],
	TOLIN.LineNumber AS [Line No_],
	(SELECT	COUNT(LinCnt.LineNumber)
	 FROM	SOHeaderRel HdrCnt INNER JOIN
		SODetailRel LinCnt
	 ON	HdrCnt.pSOHeaderRelID = LinCnt.fSOHeaderRelID 
	 WHERE	HdrCnt.OrderType = 'TO' AND LEFT(LinCnt.ItemNo, 5) = LEFT(TOLIN.ItemNo, 5) AND HdrCnt.BOLNO = TOHDR.BOLNO) AS CatLineCount,
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
	tLandedCost.AntLandCost,
	tLandedCost.[Direct Unit Cost],
	isnull((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost] * 100,0) AS [Landed Adder %],
	isnull(DUTY.Rate,0) AS [Duty %],
	isnull(SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost]),0) AS AvgCostAdders,
	(SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) AS [AvgCost Duty Only],
        (SKU.UnitCost - SKU.UnitCost * ((tLandedCost.AntLandCost - tLandedCost.[Direct Unit Cost]) / tLandedCost.[Direct Unit Cost])) * (1 + DUTY.Rate / 100) * TOLIN.QtyOrdered AS [Avg Cost Ext (CAN)],
	ITEM.Tariff AS [Harmonizing Tariff Code],
	TOLIN.GrossWght AS [Gross Weight],
	TOLIN.NetWght AS [Net Weight]
--INTO	dbo.tLandedCostLines
FROM	ItemMaster ITEM INNER JOIN
	tLandedCost
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
ON	tLandedCost.Item = ITEM.ItemNo
WHERE	TOHDR.OrderType = 'TO' AND TOHDR.BOLNO = 'TodTest2' AND
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN TOLIN.QtyOrdered
		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
	END > 0 AND
	TOLIN.ItemNo = ITEM.ItemNo AND TOHDR.OrderLoc = SKU.Location
