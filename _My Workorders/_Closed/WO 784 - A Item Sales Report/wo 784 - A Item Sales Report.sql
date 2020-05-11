--CPR_DAILY

--SELECT DISTINCT	ItemNo, CASE WHEN (ItemNo=LocationCode) THEN 00 ELSE LocationCode END as LocationCode,
--		Description, CorpFixedVelCode, ROUND(Use_30Day_Qty,0) as TotUse30, 
--		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as TotUseWgt,
--		CAST(Avail_Qty as Integer) as AvailQty,
--		CAST(Avail_Qty * Net_Wgt as DECIMAL(38,6)) as AvailWgt,
--		Net_Wgt, Avg_CostM, [6MthAvgSellPrice], [LastWkAvgSellPrice],
--		[2ndWkAvgSellPrice], [3rdWkAvgSellPrice], [4thWkAvgSellPrice]
--FROM		CPR_Daily
--WHERE		CorpFixedVelCode='A' --AND ItemNo=LocationCode
----WHERE		CatVelocityCd='A' AND ItemNo=LocationCode
--ORDER BY	ItemNo, LocationCode

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


SELECT DISTINCT	CPR_Daily.ItemNo, CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END as Loc,
		CPR_Daily.Description, CPR_Daily.CorpFixedVelCode, ROUND(CPR_Daily.Use_30Day_Qty, 0) AS TotUse30,
		CAST(ROUND(CPR_Daily.Use_30Day_Qty, 0) * CPR_Daily.Net_Wgt AS DECIMAL(38, 6)) AS TotUseWgt, 
		CAST(CPR_Daily.Avail_Qty AS Integer) AS AvailQty, CAST(CPR_Daily.Avail_Qty * CPR_Daily.Net_Wgt AS DECIMAL(38, 6)) AS AvailWgt, 
		CPR_Daily.Net_Wgt, CPR_Daily.Avg_CostM, CPR_Daily.[6MthAvgSellPrice], CPR_Daily.LastWkAvgSellPrice,
		CPR_Daily.[2ndWkAvgSellPrice], CPR_Daily.[3rdWkAvgSellPrice], CPR_Daily.[4thWkAvgSellPrice], ItemBranch.SuggSell
FROM		CPR_Daily INNER JOIN
		ItemMaster ON CPR_Daily.ItemNo = ItemMaster.ItemNo INNER JOIN
		ItemBranch ON ItemMaster.pItemMasterID = ItemBranch.fItemMasterID
----WHERE	CatVelocityCd='A' AND ItemNo=LocationCode
WHERE		CPR_Daily.CorpFixedVelCode='A' AND
		(ItemBranch.Location = CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END)
ORDER BY	CPR_Daily.ItemNo, CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END



---------------------------------------------------------------------------------------------------------------------------


--select  top 100 * from [SODetailHist]

