CREATE PROCEDURE dbo.pITotalInvBranchItem

@Period datetime, 
@Branch varchar(10)

AS
----pITotalInvBranchItem
----Written By: Tod Dixon
----Application: Inventory Management/ITotal

SELECT	ItemNo, Description, SalesVelocity as SVC, CategoryVelocity as CVC, isNULL(QtyOnHand,0) as Qty,
	CAST(isNULL(QtyOnHand,0) * isNULL(AvgCost,0) as Decimal(18,0)) as DolAtAvgCost,
	CAST(isNULL(QtyOnHand,0) * isNULL(NetWght,0) as Decimal(18,0)) as Weight,
	CAST(CASE isNULL(QtyOnHand,0) * isNULL(NetWght,0)
	     WHEN 0 THEN 0
	            ELSE isNULL(QtyOnHand * AvgCost,0) / isNULL(QtyOnHand * NetWght,0)
	     END as Decimal(18,3)) as DolPerLb,
	isNULL(ThirtyDayUsageQty,0) as ThirtyDayUsageQty,
	CAST(isNULL(ThirtyDayUsageQty,0) * isNULL(AvgCost,0) as Decimal(18,0)) as ThirtyDayUseQtyDolPerAvg,
	CAST(CASE(isNULL(ThirtyDayUsageQty,0) * isNULL(NetWght,0))
	     WHEN 0 THEN 0
	            ELSE (isNULL(QtyOnHand,0) * isNULL(AvgCost,0)) / (isNULL(ThirtyDayUsageQty,0) * isNULL(NetWght,0))
	     END as Decimal(18,1)) as MOH
FROM	rptITotal
--WHERE	CurrentDt = '2008-08-01' AND Branch = 05
WHERE	CurrentDt = @Period AND Branch = @Branch

GO