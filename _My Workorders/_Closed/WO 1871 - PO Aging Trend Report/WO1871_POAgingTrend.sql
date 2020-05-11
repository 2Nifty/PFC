SELECT	POAgingTrend.BuyGroupNo,
	POAgingTrend.BuyGroupDesc,
	POAgingTrend.SubTotGroup,
	POAgingTrend.SubTotGroupDesc,
	ROUND(POAgingTrend.TotAvgUseLbs,0) AS AvgUseLbs,
	ROUND(POAgingTrend.TotAvlLbs,0) AS AvlLbs,
	ROUND(POAgingTrend.AvlMos,1) AS AvlMos,
	ROUND(POAgingTrend.TotTrfLbs,0) AS TrfLbs,
	ROUND(POAgingTrend.TrfMos,1) AS TrfMos,
	ROUND(POAgingTrend.TotOTWLbs,0) AS OTWLbs,
	ROUND(POAgingTrend.OTWMos,1) AS OTWMos,
	ROUND(POAgingTrend.TotRTSLbs,0) AS RTSLbs,
	ROUND(POAgingTrend.RTSMos,1) AS RTSMos,
	ROUND(POAgingTrend.TotOOLbs,0) AS OOLbs,
	ROUND(POAgingTrend.OOMos,1) AS OOMos,
--	ROUND(POAgingTrend.TotAvlLbs,0) + ROUND(POAgingTrend.TotTrfLbs,0) + ROUND(POAgingTrend.TotOOLbs,0) + ROUND(POAgingTrend.TotOTWLbs,0) AS TotalLbs,
--	ROUND(POAgingTrend.AvlMos,1) + ROUND(POAgingTrend.TrfMos,1) + ROUND(POAgingTrend.OOMos,1) + ROUND(POAgingTrend.OTWMos,1) AS TotalMos,
	ROUND(POAgingTrend.TotalLbs,0) AS TotalLbs,
	ROUND(POAgingTrend.TotalMos,1) AS TotalMos,
	ROUND(POAgingTrend.TotCPRValue,0) AS CPRValue,
	ROUND(POAgingTrend.TotCPRLbs,0) AS CPRLbs,
	ROUND(POAgingTrend.CRPMos,1) AS CRPMos,
	ROUND(POAgingTrend.AvlMos,1) + ROUND(POAgingTrend.TrfMos,1) + ROUND(POAgingTrend.OOMos,1) + ROUND(POAgingTrend.OTWMos,1) + ROUND(POAgingTrend.CRPMos,1) AS GrdTotMos,

	ROUND(POAgingTrend.TotForecastLbs,0) AS ForecastLbs,

	ROUND(POAgingTrend.TotMonth1RcptLbs,0) AS Month1RcptLbs,
	ROUND(POAgingTrend.TotMonth1AvlLbs,0) AS Month1AvlLbs,
	ROUND(POAgingTrend.Month1Mos,1) AS Month1Mos,

	ROUND(POAgingTrend.TotMonth2RcptLbs,0) AS Month2RcptLbs,
	ROUND(POAgingTrend.TotMonth2AvlLbs,0) AS Month2AvlLbs,
	ROUND(POAgingTrend.Month2Mos,1) AS Month2Mos,

	ROUND(POAgingTrend.TotMonth3RcptLbs,0) AS Month3RcptLbs,
	ROUND(POAgingTrend.TotMonth3AvlLbs,0) AS Month3AvlLbs,
	ROUND(POAgingTrend.Month3Mos,1) AS Month3Mos
FROM	(SELECT	DISTINCT
		Groups.BuyGroupNo,
		Groups.BuyGroupDesc,
		Groups.SubTotGroup,
		Groups.SubTotGroupDesc,
		isnull(TotCPR.TotAvgUseLbs,0) AS TotAvgUseLbs,
		isnull(TotCPR.TotAvlLbs,0) AS TotAvlLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(TotCPR.TotAvlLbs,0) / TotCPR.TotAvgUseLbs
		END AS AvlMos,
		isnull(TotCPR.TotTrfLbs,0) AS TotTrfLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(TotCPR.TotTrfLbs,0) / TotCPR.TotAvgUseLbs
		END AS TrfMos,
		isnull(TotCPR.TotOTWLbs,0) AS TotOTWLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(TotCPR.TotOTWLbs,0) / TotCPR.TotAvgUseLbs
		END AS OTWMos,
		isnull(RTS.TotRTSLbs,0) AS TotRTSLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(RTS.TotRTSLbs,0) / TotCPR.TotAvgUseLbs
		END AS RTSMos,
		isnull(TotCPR.TotOOLbs,0) AS TotOOLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(TotCPR.TotOOLbs,0) / TotCPR.TotAvgUseLbs
		END AS OOMos,
		isnull(TotCPR.TotAvlLbs,0) + isnull(TotCPR.TotTrfLbs,0) + isnull(TotCPR.TotOTWLbs,0) + isnull(TotCPR.TotOOLbs,0) AS TotalLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE (isnull(TotCPR.TotAvlLbs,0) + isnull(TotCPR.TotTrfLbs,0) + isnull(TotCPR.TotOTWLbs,0) + isnull(TotCPR.TotOOLbs,0)) / TotCPR.TotAvgUseLbs
		END AS TotalMos,
		isnull(TotCPR.TotCPRValue,0) AS TotCPRValue,
		isnull(TotCPR.TotCPRLbs,0) AS TotCPRLbs,
		CASE WHEN isnull(TotCPR.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(TotCPR.TotCPRLbs,0) / TotCPR.TotAvgUseLbs
		END AS CRPMos,

		--3 Month Forecast
		isnull(TotCPR.TotForecastLbs,0) AS TotForecastLbs,

		0 AS TotMonth1RcptLbs,
--		isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] - isnull(TotCPR.TotForecastLbs,0) AS TotMonth1AvlLbs,
		0 AS TotMonth1AvlLbs,
		CASE WHEN isnull(TotCPR.TotForecastLbs,0) = 0
			THEN 0
--			ELSE (isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] - isnull(TotCPR.TotForecastLbs,0)) / TotCPR.TotForecastLbs
			ELSE 0
		END AS Month1Mos,

		0 AS TotMonth2RcptLbs,
--		isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] + [TotMonth2RcptLbs] - (isnull(TotCPR.TotForecastLbs,0) * 2) AS TotMonth2AvlLbs,
		0 AS TotMonth2AvlLbs,
		CASE WHEN isnull(TotCPR.TotForecastLbs,0) = 0
			THEN 0
--			ELSE (isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] + [TotMonth2RcptLbs] - (isnull(TotCPR.TotForecastLbs,0) * 2)) / TotCPR.TotForecastLbs
			ELSE 0
		END AS Month2Mos,

		0 AS TotMonth3RcptLbs,
--		isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] + [TotMonth2RcptLbs] + [TotMonth3RcptLbs] - (isnull(TotCPR.TotForecastLbs,0) * 3) AS TotMonth3AvlLbs,
		0 AS TotMonth3AvlLbs,
		CASE WHEN isnull(TotCPR.TotForecastLbs,0) = 0
			THEN 0
--			ELSE (isnull(TotCPR.TotAvlLbs,0) + [TotMonth1RcptLbs] + [TotMonth2RcptLbs] + [TotMonth3RcptLbs] - (isnull(TotCPR.TotForecastLbs,0) * 3)) / TotCPR.TotForecastLbs
			ELSE 0
		END AS Month3Mos
	 FROM	--CategoryBuyGroups [Groups]
		(SELECT	CAST(BuyGrp.GroupNo as varchar(10)) AS BuyGroupNo,
			BuyGrp.[Description] AS BuyGroupDesc,
			CAST(BuyGrp.ReportGroupNo as varchar(10)) AS SubTotGroup,
			BuyGrp.ReportGroup AS SubTotGroupDesc
		 FROM	CategoryBuyGroups BuyGrp (NoLock)) Groups LEFT OUTER JOIN	--LEFT OUTER JOIN gives us all of the CategoryBuyGroups

		--CPR_Daily [TotCPR]
		(SELECT	BuyGrp.GroupNo,
			SUM(isnull(CPR.Use_30Day_Qty,0) * isnull(IM.Wght,0)) AS TotAvgUseLbs,
			SUM(isnull(CPR.Avail_Wgt,0)) AS TotAvlLbs,
			SUM(isnull(CPR.Trf_Wgt,0)) as TotTrfLbs,
			SUM(isnull(CPR.OW_Wgt,0)) as TotOTWLbs,
			SUM(isnull(CPR.OO_Wgt,0)) as TotOOLbs,
			SUM(isnull(CPR.LastDirect_Cost,0) * ((isnull(CPR.Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(CPR.TotStkOrd_Qty,0))) as TotCPRValue,
			SUM(isnull(IM.Wght,0) * ((isnull(CPR.Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(CPR.TotStkOrd_Qty,0))) as TotCPRLbs,
			SUM((isnull(CPR.Use_30Day_Qty,0) * isnull(IM.Wght,0)) + (isnull(CPR.Use_30Day_Qty,0) * isnull(IM.Wght,0) * isnull(BuyGrp.UsageForecastPct,0) * 0.01)) AS TotForecastLbs
		 FROM	CPR_Daily CPR (NoLock) INNER JOIN
			CategoryBuyGroups BuyGrp (NoLock)
		 ON	BuyGrp.Category = left(CPR.ItemNo,5) INNER JOIN
			ItemMaster IM (NoLock)
		 ON	IM.ItemNo = CPR.ItemNo INNER JOIN
			LocMaster Loc (NoLock)
		 ON	Loc.LocID = CPR.LocationCode
		 WHERE	(CPR.LocationCode BETWEEN '01' AND '80')
		 GROUP BY BuyGrp.GroupNo) TotCPR
	 	ON	Groups.BuyGroupNo = TotCPR.GroupNo LEFT OUTER JOIN		--LEFT OUTER JOIN gives us all of the CategoryBuyGroups
		--Ready To Ship (PO's) [RTS]
		(SELECT	TotRTS.GroupNo,
			ROUND(SUM(TotRTS.TotLbs),0) as TotRTSLbs
		 FROM	(SELECT	PO.GroupNo,
			 	SUM(PO.ExtWgt) as TotLbs
	 		 FROM	(SELECT	POL.ReceivingLocation AS Loc, 
					BUY.GroupNo,
					BUY.[Description] as GrpDesc,
					(POL.QtyOrdered - POL.QtyReceived) * IM.Wght AS ExtWgt
				 FROM	PODetail POL (NoLock) INNER JOIN
		 			ItemMaster IM (NoLock)
				 ON	IM.ItemNo = POL.ItemNo LEFT OUTER JOIN
				 	CategoryBuyGroups BUY (NoLock)
				 ON	LEFT(POL.ItemNo, 5) = BUY.Category COLLATE Latin1_General_CS_AS
				 WHERE	
--					POL.Type = 2 AND								--PO Line Type = ITEM - *Navision only*
					(POL.QtyOrdered - POL.QtyReceived) > 0 AND					--PO has outstanding Qty
				 	(POL.ScheduledReceiptDt > CONVERT(DATETIME, '2010-01-01 00:00:00', 102)) AND	--Ignoring old PO's
					(POL.ReceivingLocation between '00' and '18') AND				--Branches 00 to 18 only
					(POL.POStatusCd = 'B') AND							--RTS is 'B' Status only
					LEFT(POL.POOrderNo,1) in ('0','1','2') AND					--POOrderNo begins with 0, 1, 2
--					SUBSTRING(POL.ItemNo,12,1) in ('0','1','5') AND					--Bulk Items only
					IM.WebEnabledInd ='1') PO							--Web Enabled only
			 GROUP BY PO.Loc, PO.GroupNo) TotRTS
		 GROUP BY TotRTS.GroupNo) RTS
		ON	TotCPR.GroupNo = RTS.GroupNo) POAgingTrend
--This will return only CategoryBuyGroups with at least one non-zero value
WHERE	(ROUND(POAgingTrend.TotAvgUseLbs,0) <> 0 OR
	 ROUND(POAgingTrend.TotAvlLbs,0) <> 0 OR
	 ROUND(POAgingTrend.AvlMos,1) <> 0 OR
	 ROUND(POAgingTrend.TotTrfLbs,0) <> 0 OR
	 ROUND(POAgingTrend.TrfMos,1) <> 0 OR
	 ROUND(POAgingTrend.TotOTWLbs,0) <> 0 OR
	 ROUND(POAgingTrend.OTWMos,1) <> 0 OR
	 ROUND(POAgingTrend.TotRTSLbs,0) <> 0 OR
	 ROUND(POAgingTrend.RTSMos,1) <> 0 OR
	 ROUND(POAgingTrend.TotOOLbs,0) <> 0 OR
	 ROUND(POAgingTrend.OOMos,1) <> 0 OR
	 ROUND(POAgingTrend.TotCPRValue,0) <> 0 OR
	 ROUND(POAgingTrend.TotCPRLbs,0) <> 0 OR
	 ROUND(POAgingTrend.CRPMos,1) <> 0)

