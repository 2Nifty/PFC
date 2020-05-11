
CREATE VIEW [dbo].[vRTS_Details]
AS
SELECT CPRDailyRTS.ItemNo
	,CPRDailyRTS.LocationCode
	,CPRDailyRTS.SVCode
	,CPRDailyRTS.HubSort
	,CPRDailyRTS.ROP_Nv AS ROPNv
	,CPRDailyRTS.ROPHubCalc
	,CPRDailyRTS.ROPDays
	,CPRDailyRTS.Avail_Qty + CPRDailyRTS.OW_Qty + CPRDailyRTS.Trf_Qty AS AvailQty
	,GERRTSHdr.ReqQty AS Required
	,GERRTSHdr.RecommQty
	,GERRTSHdr.CommitQty
	,CPRDailyRTS.OW_Qty + CPRDailyRTS.Trf_Qty AS InTransit
	,LocMaster.LocIMRegion
	,isnull(CPRDailyRTS.RTSBQty,0) as RTSBQty
	,case 
		when isnull(CPRDailyRTS.ROPHubCalc,0) > 0 then ISNULL(SupEqv_Qty/((ROPHubCalc/CPRDailyRTS.ROPDays)*30), 0)
		else 0 end AS SupEqQty
	,case 
		when isnull(CPRDailyRTS.ROPHubCalc,0) > 0 then ISNULL((Avail_Qty+OW_Qty+Trf_Qty+RTSBQty)/(ROPHubCalc/3), 0) 
		else 0 end AS Avail_Mos
--  case when CPRDailyRTS.Use_30Day_Qty >0 then ISNULL(Avail_Qty/CPRDailyRTS.Use_30Day_Qty, 0) else 0 end AS Avail_Mos
FROM CPRDailyRTS with (NOLOCK)
INNER JOIN GERRTSHdr with (NOLOCK) 
ON CPRDailyRTS.LocationCode = GERRTSHdr.LocCd 
	AND CPRDailyRTS.ItemNo = GERRTSHdr.ItemNo 
INNER JOIN LocMaster with (NOLOCK) 
ON GERRTSHdr.LocCd = LocMaster.LocID

