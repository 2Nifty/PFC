SELECT RIGHT(('000' + SubTotGroup),3) AS SubTotGrp, RIGHT(('000' + BuyGroupNo),3) AS BuyGrp, BuyGroupNo + ' - ' + BuyGroupDesc AS CatGroup, * FROM POAgingRpt
ORDER BY RIGHT(('000' + SubTotGroup),3), RIGHT(('000' + BuyGroupNo),3)

select * from POAgingRpt

UPDATE POAgingRpt
SET BuyGroupDesc = 'Tap Bolts 12345 7890 23456 890 234567 9012345 7890 234567890 2345'
where left(BuyGroupDesc,9) = 'Tap Bolts'

select max(len(BuyGroupDesc)) from POAgingRpt


exec sp_columns POAgingRpt


SELECT	CPR.ItemNo,
	CAST(BuyGrp.GroupNo as varchar(10)) AS BuyGroupNo,
	BuyGrp.[Description] AS BuyGroupDesc,
	CAST(BuyGrp.ReportGroupNo as varchar(10)) AS SubTotGroup,
	BuyGrp.ReportGroup AS SubTotGroupDesc,
	isnull((Use_30Day_Qty * IM.Wght),0) AS AvgUseLbs,
	isnull(Avail_Wgt,0) AS AvlLbs,
	CASE WHEN isnull(Use_30Day_Qty,0) = 0
		THEN 0
		ELSE isnull((Avail_Wgt / Use_30Day_Qty * IM.Wght),0)
	END AS AvlMos,
	isnull(Trf_Wgt,0) as TrfLbs,

	CASE WHEN isnull(Use_30Day_Qty,0) = 0
		THEN 0
		ELSE isnull((Trf_Wgt / Use_30Day_Qty * IM.Wght),0)
	END AS TrfMos,

	isnull(OO_Wgt,0) as OOLbs,
	CASE WHEN isnull(Use_30Day_Qty,0) = 0
		THEN 0
		ELSE isnull((OO_Wgt / Use_30Day_Qty * IM.Wght),0)
	END AS OOMos,

	isnull(OW_Wgt,0) as OTWLbs,
	CASE WHEN isnull(Use_30Day_Qty,0) = 0
		THEN 0
		ELSE isnull((OW_Wgt / Use_30Day_Qty * IM.Wght),0)
	END AS OTWMos,

	--Add Totals		
--	floor(isnull(LastDirect_Cost,0) * ((isnull(Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(TotStkOrd_Qty,0))) as CPRValue,
--	floor(isnull(IM.Wght,0) * ((isnull(Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(TotStkOrd_Qty,0))) as CPRLbs,
	isnull(LastDirect_Cost,0) * ((isnull(Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(TotStkOrd_Qty,0)) as CPRValue,
	isnull(IM.Wght,0) * ((isnull(Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(TotStkOrd_Qty,0)) as CPRLbs,

	CASE WHEN isnull(Use_30Day_Qty,0) = 0
		THEN 0
		ELSE isnull(((isnull(IM.Wght,0) * ((isnull(Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(TotStkOrd_Qty,0))) / Use_30Day_Qty * IM.Wght),0)
	END AS CPRMos,
	isnull(TotStkOrd_Qty,0) as TotStkOrd_Qty,
	isnull(LastDirect_Cost,0) as LastDirect_Cost,
	isnull(Use_30Day_Qty,0)*1 as Use_30Day_Qty,
	isnull(IM.Wght,0) as WgtPerEa,
	isnull(BuyGrp.MonthsBuyFactor,0) as MosBuyFct
FROM	CPR_Daily CPR (nolock) INNER JOIN
	CategoryBuyGroups BuyGrp (nolock)
ON	BuyGrp.Category = left(CPR.ItemNo,5) INNER JOIN
	ItemMaster IM (nolock)
ON	IM.ItemNo = CPR.ItemNo
-----------------------
--WHERE BuyGrp.ReportGroupNo=10
WHERE BuyGrp.GroupNo=15
ORDER BY CPR.ItemNo



----------------------------------------------------------------------------------------------


SELECT	POAgingTrend.BuyGroupNo,
	POAgingTrend.BuyGroupDesc,
	POAgingTrend.SubTotGroup,
	POAgingTrend.SubTotGroupDesc,
	ROUND(POAgingTrend.TotAvgUseLbs,0) AS TotAvgUseLbs,
	ROUND(POAgingTrend.TotAvlLbs,0) AS TotAvlLbs,
	ROUND(POAgingTrend.AvlMos,1) AS AvlMos,
	ROUND(POAgingTrend.TotTrfLbs,0) AS TotTrfLbs,
	ROUND(POAgingTrend.TrfMos,1) AS TrfMos,
	ROUND(POAgingTrend.TotOOLbs,0) AS TotOOLbs,
	ROUND(POAgingTrend.OOMos,1) AS OOMos,
	ROUND(POAgingTrend.TotOTWLbs,0) AS TotOTWLbs,
	ROUND(POAgingTrend.OTWMos,1) AS OTWMos,
	ROUND(POAgingTrend.TotAvlLbs,0) + ROUND(POAgingTrend.TotTrfLbs,0) + ROUND(POAgingTrend.TotOOLbs,0) + ROUND(POAgingTrend.TotOTWLbs,0) AS TotalLbs,
	ROUND(POAgingTrend.AvlMos,1) + ROUND(POAgingTrend.TrfMos,1) + ROUND(POAgingTrend.OOMos,1) + ROUND(POAgingTrend.OTWMos,1) AS TotalMos,
	ROUND(POAgingTrend.TotCPRValue,0) AS TotCPRValue,
	ROUND(POAgingTrend.TotCPRLbs,0) AS TotCPRLbs,
	ROUND(POAgingTrend.CRPMos,1) AS CRPMos,
	ROUND(POAgingTrend.AvlMos,1) + ROUND(POAgingTrend.TrfMos,1) + ROUND(POAgingTrend.OOMos,1) + ROUND(POAgingTrend.OTWMos,1) + ROUND(POAgingTrend.CRPMos,1) AS GrdTotMos
FROM	(SELECT	DISTINCT
		Groups.BuyGroupNo,
		Groups.BuyGroupDesc,
		Groups.SubTotGroup,
		Groups.SubTotGroupDesc,
		isnull(Totals.TotAvgUseLbs,0) AS TotAvgUseLbs,
		isnull(Totals.TotAvlLbs,0) AS TotAvlLbs,
		CASE WHEN isnull(Totals.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(Totals.TotAvlLbs,0) / Totals.TotAvgUseLbs
		END AS AvlMos,
		isnull(Totals.TotTrfLbs,0) AS TotTrfLbs,
		CASE WHEN isnull(Totals.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(Totals.TotTrfLbs,0) / Totals.TotAvgUseLbs
		END AS TrfMos,
		isnull(Totals.TotOOLbs,0) AS TotOOLbs,
		CASE WHEN isnull(Totals.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(Totals.TotOOLbs,0) / Totals.TotAvgUseLbs
		END AS OOMos,
		isnull(Totals.TotOTWLbs,0) AS TotOTWLbs,
		CASE WHEN isnull(Totals.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(Totals.TotOTWLbs,0) / Totals.TotAvgUseLbs
		END AS OTWMos,
		isnull(Totals.TotCPRValue,0) AS TotCPRValue,
		isnull(Totals.TotCPRLbs,0) AS TotCPRLbs,
		CASE WHEN isnull(Totals.TotAvgUseLbs,0) = 0
			THEN 0
			ELSE isnull(Totals.TotCPRLbs,0) / Totals.TotAvgUseLbs
		END AS CRPMos
	 FROM	(SELECT	CAST(BuyGrp.GroupNo as varchar(10)) AS BuyGroupNo,
			BuyGrp.[Description] AS BuyGroupDesc,
			CAST(BuyGrp.ReportGroupNo as varchar(10)) AS SubTotGroup,
			BuyGrp.ReportGroup AS SubTotGroupDesc
		 FROM	CategoryBuyGroups BuyGrp (nolock)) Groups INNER JOIN
		(SELECT	BuyGrp.GroupNo,
			SUM(isnull((CPR.Use_30Day_Qty * IM.Wght),0)) AS TotAvgUseLbs,
			SUM(isnull(CPR.Avail_Wgt,0)) AS TotAvlLbs,
			SUM(isnull(CPR.Trf_Wgt,0)) as TotTrfLbs,
			SUM(isnull(CPR.OO_Wgt,0)) as TotOOLbs,
			SUM(isnull(CPR.OW_Wgt,0)) as TotOTWLbs,
			SUM(isnull(CPR.LastDirect_Cost,0) * ((isnull(CPR.Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(CPR.TotStkOrd_Qty,0))) as TotCPRValue,
			SUM(isnull(IM.Wght,0) * ((isnull(CPR.Use_30Day_Qty,0) * isnull(BuyGrp.MonthsBuyFactor,0)) - isnull(CPR.TotStkOrd_Qty,0))) as TotCPRLbs
		 FROM	CPR_Daily CPR (nolock) INNER JOIN
			CategoryBuyGroups BuyGrp (nolock)
		 ON	BuyGrp.Category = left(CPR.ItemNo,5) INNER JOIN
			ItemMaster IM (nolock)
		 ON	IM.ItemNo = CPR.ItemNo
		 GROUP BY BuyGrp.GroupNo) Totals
	 ON	Groups.BuyGroupNo = Totals.GroupNo) POAgingTrend
-----------------------
where POAgingTrend.SubTotgroup='10'
ORDER BY POAgingTrend.BuyGroupNo






--select * from CategoryBuyGroups



--select	round(123.4,0),
--		round(1233.5,0),

--		round(12.34,1),
--		round(123.35,1)