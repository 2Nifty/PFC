CREATE PROCEDURE dbo.pITotalInvByCategoryBranch

@Period datetime, 
@Category varchar(10)

AS
----pITotalInvByCategoryBranch
----Written By: Tod Dixon
----Application: Inventory Management/ITotal

SELECT	ITotal.Branch, ITotal.Branch + ' - ' + Loc.LocName as BranchDesc, SUM(isNULL(ITotal.QtyOnHand,0)) as Qty,
	CAST(SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.AvgCost,0)) as Decimal(18,0)) as DolAtAvgCost,
	CAST(SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.NetWght,0)) as Decimal(18,0)) as Weight,
	CAST(CASE SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.NetWght,0))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(ITotal.QtyOnHand * ITotal.AvgCost,0)) / SUM(isNULL(ITotal.QtyOnHand * ITotal.NetWght,0))
	     END as Decimal(18,3))as DolPerLb,
	SUM(isNULL(ITotal.ThirtyDayUsageQty,0)) as ThirtyDayUsageQty,
	CAST(SUM(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.AvgCost,0)) as Decimal(18,0)) as ThirtyDayUseQtyDolPerAvg,
	CAST(CASE(SUM(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.NetWght,0)))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.AvgCost,0)) / SUM(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.NetWght,0))
	     END as Decimal(18,1)) as MOH
FROM	rptITotal ITotal, LocMaster Loc
--WHERE	ITotal.CurrentDt = '2008-08-01' AND ITotal.Category = 00240 AND ITotal.Branch = LocID
WHERE	ITotal.CurrentDt = @Period AND ITotal.Category = @Category AND ITotal.Branch = LocID
GROUP BY Branch, LocName

GO