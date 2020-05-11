SELECT	CurrentDt,
		Branch, 
		ITotGroup, 
		SUM(isnull(QtyOnHand,0)) as ExtendedQtyOnHand, 
		SUM(isnull(QtyOnHand,0) * isnull(AvgCost,0)) as ExtendedAvgCost, 
		SUM(isnull(QtyOnHand,0) * isnull(NetWght,0)) as ExtendedNetWgt, 
		SUM(isnull(QtyOnHand,0) * isnull(GrossWght,0)) as ExtendedGrossWgt, 
		SUM(isnull(ThirtyDayUsageQty,0))  as ExtendedThirtyDayUsage, 
		SUM(isnull(ThirtyDayUsageQty,0) * isnull(AvgCost,0)) as ExtendedThirtyDayUseCost,
		SUM(isnull(ThirtyDayUsageQty,0) * isnull(NetWght,0)) as ExtendedThirtyDayUseWgt,
--		SYSTEM_USER AS EntryID
		'WO852' as EntryID,
		CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as EntryDt,

		--CRP Data
		SUM(isnull(AvailCost,0)) as AvailCost,
		SUM(isnull(AvailWght,0)) as AvailWght,
		SUM(isnull(AvailQty,0)) as AvailQty,
		SUM(isnull(TrfCost,0)) as TrfCost,
		SUM(isnull(TrfWght,0)) as TrfWght,
		SUM(isnull(TrfQty,0)) as TrfQty,
		SUM(isnull(OTWCost,0)) as OTWCost,
		SUM(isnull(OTWWght,0)) as OTWWght,
		SUM(isnull(OTWQty,0)) as OTWQty,
		SUM(isnull(RTSBCost,0)) as RTSBCost,
		SUM(isnull(RTSBWght,0)) as RTSBWght,
		SUM(isnull(RTSBQty,0)) as RTSBQty,
		SUM(isnull(OnOrdCost,0)) as OnOrdCost,
		SUM(isnull(OnOrdWght,0)) as OnOrdWght,
		SUM(isnull(OnOrdQty,0)) as OnOrdQty,
		SUM(isnull([Use30DayQty],0)) as [Use30DayQty]
FROM	rptITotal
GROUP BY CurrentDt, Branch, ITotGroup