CREATE procedure [dbo].[pAItemSalesRpt] as
----pAItemSalesRpt
----Written By: Tod Dixon
----Application: Sales/CPR

SELECT DISTINCT	CPR_Daily.ItemNo, CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END as Loc,
		CPR_Daily.Description, CPR_Daily.CorpFixedVelCode, ROUND(CPR_Daily.Use_30Day_Qty, 0) AS TotUse30,
		CAST(ROUND(CPR_Daily.Use_30Day_Qty, 0) * CPR_Daily.Net_Wgt AS DECIMAL(38, 6)) AS TotUseWgt, 
		CAST(CPR_Daily.Avail_Qty AS Integer) AS AvailQty, CAST(CPR_Daily.Avail_Qty * CPR_Daily.Net_Wgt AS DECIMAL(38, 6)) AS AvailWgt, 
		CPR_Daily.Net_Wgt, CPR_Daily.Avg_CostM, CPR_Daily.[6MthAvgSellPrice], CPR_Daily.LastWkAvgSellPrice,
		CPR_Daily.[2ndWkAvgSellPrice], CPR_Daily.[3rdWkAvgSellPrice], CPR_Daily.[4thWkAvgSellPrice], ItemBranch.SuggSell
FROM		CPR_Daily INNER JOIN
		ItemMaster ON CPR_Daily.ItemNo = ItemMaster.ItemNo INNER JOIN
		ItemBranch ON ItemMaster.pItemMasterID = ItemBranch.fItemMasterID
WHERE		CPR_Daily.CorpFixedVelCode='A' AND
		(ItemBranch.Location = CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END)
ORDER BY	CPR_Daily.ItemNo, CASE WHEN (CPR_Daily.ItemNo=CPR_Daily.LocationCode) THEN 00 ELSE CPR_Daily.LocationCode END
go