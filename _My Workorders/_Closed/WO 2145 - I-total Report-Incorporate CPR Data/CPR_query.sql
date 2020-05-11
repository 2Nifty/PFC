SELECT	TOP 5000
--		GrpNo,
--		GrpName,
		ItemNo,
--		Description,
		LocationCode,
		isnull(Avail_Cost,0) as AvailCost,
		isnull(Avail_Wgt,0) as AvailWeight,
		CASE isnull(Use_30Day_Qty,0)
			WHEN 0 THEN isnull(Avail_Qty,0)
			ELSE isnull(Avail_Qty,0) / isnull(Use_30Day_Qty,0)
		END as AvailMonths,
		isnull(Trf_Cost,0) as TransferCost,
		isnull(Trf_Wgt,0) as TransferWeight,
		CASE isnull(Use_30Day_Qty,0)
			WHEN 0 THEN isnull(Trf_Qty,0)
			ELSE isnull(Trf_Qty,0) / isnull(Use_30Day_Qty,0)
		END as TransferMonths,
		isnull(OW_Cost,0) as OTWCost,
		isnull(OW_Wgt,0) as OTWWeight,
		CASE isnull(Use_30Day_Qty,0)
			WHEN 0 THEN isnull(OW_Qty,0)
			ELSE isnull(OW_Qty,0) / isnull(Use_30Day_Qty,0)
		END as OTWMonths,
		0 as RTSBCost,
		isnull(RTSBQty,0) * isnull(Net_Wgt,0) as RTSBWeight,
		CASE isnull(Use_30Day_Qty,0)
			WHEN 0 THEN RTSBQty
			ELSE isnull(RTSBQty,0) / isnull(Use_30Day_Qty,0)
		END as RTSBMonths,
		isnull(OO_Cost,0) as OnOrderCost,
		isnull(OO_Wgt,0) as OnOrderWeight,
		CASE isnull(Use_30Day_Qty,0)
			WHEN 0 THEN isnull(OO_Qty,0)
			ELSE isnull(OO_Qty,0) / isnull(Use_30Day_Qty,0)
		END as OnOrderMonths--,
--		*

select count(*)
FROM	CPR_Daily (NoLock) --INNER JOIN
--		LocMaster (NoLock)
--ON		LocationCode = LocID

WHERE LocationCode >= '01' and LocationCode < = '90'





--GROUP BY ItemNo, LocationCode



--select * from LocMaster order by LocID