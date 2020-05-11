CREATE PROCEDURE dbo.pITotalBranchInvOH

@Period datetime

AS
----pITotalBranchInvOH
----Written By: Tod Dixon
----Application: Inventory Management/ITotal


SELECT	ITotal.Branch, ITotal.Branch + ' - ' + Loc.LocName as BranchDesc, SUM(isNULL(ITotal.QtyOnHand,0)) as Qty,
	CAST(SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.AvgCost,0)) as Decimal(18,0)) as DolAtAvgCost,
	CAST(SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.NetWght,0)) as decimal(18,0)) as Weight,
	CAST(CASE SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.NetWght,0))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(ITotal.QtyOnHand * ITotal.AvgCost,0)) / SUM(isNULL(ITotal.QtyOnHand * ITotal.NetWght,0))
	     END as Decimal(18,3)) as DolPerLb,
	SUM(isNULL(ITotal.ThirtyDayUsageQty,0)) as ThirtyDayUsageQty,
	CAST(SUM(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.AvgCost,0)) as decimal(18,0)) as ThirtyDayUseQtyDolPerAvg,
	CAST(CASE(SUM(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.NetWght,0)))
	     WHEN 0 THEN 0
	            ELSE SUM(isNULL(ITotal.QtyOnHand,0) * isNULL(ITotal.AvgCost,0)) / Sum(isNULL(ITotal.ThirtyDayUsageQty,0) * isNULL(ITotal.NetWght,0))
	     END as decimal(18,1))as MOH
FROM	rptITotal ITotal, LocMaster Loc
--WHERE	ITotal.CurrentDt = '2008-08-01' AND ITotal.Branch = Loc.LocID
WHERE	ITotal.CurrentDt = @Period AND ITotal.Branch = Loc.LocID
GROUP BY ITotal.Branch, Loc.LocName

GO