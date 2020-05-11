CREATE PROCEDURE dbo.pITotalInvByCategoryItem

@Period datetime, 
@Category varchar(10)

AS
----pITotalInvByCategoryItem
----Written By: Tod Dixon
----Application: Inventory Management/ITotal

SELECT	ItemNo, Description, SUM(isNULL(QtyOnHand,0)) as Qty,
	CAST(SUM(isNULL(QtyOnHand,0) * isNULL(AvgCost,0)) as Decimal(18,0)) as DolAtAvgCost,
	CAST(SUM(isNULL(QtyOnHand,0) * isNULL(NetWght,0)) as decimal(18,0)) as Weight,
	CAST(CASE SUM(isNULL(QtyOnHand,0) * isNULL(NetWght,0))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(QtyOnHand * AvgCost,0)) / SUM(isNULL(QtyOnHand * NetWght,0))
	     END as Decimal(18,3)) as DolPerLb,
	SUM(isNULL(ThirtyDayUsageQty,0)) as ThirtyDayUsageQty,
	CAST(SUM(isNULL(ThirtyDayUsageQty,0) * isNULL(AvgCost,0)) as decimal(18,0)) as ThirtyDayUseQtyDolPerAvg,
	CAST(CASE(SUM(isNULL(ThirtyDayUsageQty,0) * isNULL(NetWght,0)))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(QtyOnHand,0) * isNULL(AvgCost,0)) / SUM(isNULL(ThirtyDayUsageQty,0) * isNULL(NetWght,0))
	     END as decimal(18,1)) as MOH
FROM	rptITotal
--WHERE	CurrentDt = '2008-08-01' AND Category = 00240
WHERE	CurrentDt = @Period AND Category = @Category
GROUP BY ItemNo, Description

GO