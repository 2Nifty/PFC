
Select ItemNo,LocationCode,SVCode,convert(decimal(25,1),isnull(ROPHubCalc,0)) as 'ROPHubCalc',
						convert(bigint,AvailQty) as 'AvailQty',convert(bigint,InTransit) as InTransit,
						convert(bigint,Required)as 'Required',convert(bigint,RecommQty) as 'RecommQty',
						 isnull(convert(bigint,CommitQty),0) as 'CommitQty',LocIMRegion,convert(bigint,RTSBQty) as 'RTSBQty',
						 convert(decimal(25,1),isnull(SupEqQty,0)) as SupEqQty,
						 convert(decimal(25,0),isnull(Avail_Mos,0)) as Avail_Mos, ROPDays 
						 From vRTS_Details  where ItemNo='00170-4412-021' and SVCode<>'N'
						 Order by HubSort asc



select
Distinct LocIMRegion
from vRTS_Details
where ItemNo




	

SELECT	vRTS.ItemNo, 
	vRTS.LocationCode,
	vRTS.SVCode,
	CONVERT(DECIMAL(25,1),isnull(vRTS.ROPHubCalc,0)) as 'ROPHubCalc',
	CONVERT(BIGINT,vRTS.AvailQty) as 'AvailQty',
	CONVERT(BIGINT,vRTS.InTransit) as InTransit,
	tROPFct.ROPFactor,
	CONVERT(DECIMAL(25,1),(isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor)) as 'FactoredROP',
	(isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) as 'Allocated',

CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) as 'Allocated Rounded',


--CASE WHEN CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0
--	THEN CASE WHEN (isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) < 0
--		THEN -1
--		ELSE 1
--	   END
--     ELSE CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0))
--END AS [Alloc Rounded no 0],


CASE WHEN CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0 AND
	  (isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) < 0
		THEN -1
     WHEN CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0 AND
	  (isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) > 0
		THEN 1
     ELSE CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0))
END AS [Alloc Rounded no 0],


	CONVERT(BIGINT,vRTS.Required) as 'Required',
	CONVERT(BIGINT,vRTS.RecommQty) as 'RecommQty', 
	isnull(CONVERT(BIGINT,vRTS.CommitQty),0) as 'CommitQty',
	vRTS.LocIMRegion,
	CONVERT(BIGINT,vRTS.RTSBQty) as 'RTSBQty', 
	CONVERT(DECIMAL(25,1),isnull(vRTS.SupEqQty,0)) as SupEqQty, 
	CONVERT(DECIMAL(25,0),isnull(vRTS.Avail_Mos,0)) as Avail_Mos,
	vRTS.ROPDays 
FROM	vRTS_Details vRTS (NoLock) INNER JOIN
	(SELECT	isnull(tItemSum.ItemNo,tPOSum.ItemNo) AS ItemNo,
		CASE isnull(TotROP,0)
		     WHEN 0 THEN 0
			    ELSE (isnull(TotAvl,0) + isnull(TotRTSB,0) + isnull(TotOW,0) + isnull(TotRemain,0)) / isnull(TotROP,0)
		END AS ROPFactor
	 FROM	(SELECT	ItemNo,
			SUM(CONVERT(DECIMAL(25,1),isnull(ROPHubCalc,0))) AS TotROP,
			SUM(CONVERT(BIGINT,AvailQty)) AS TotAvl,
			SUM(CONVERT(BIGINT,RTSBQty)) AS TotRTSB,
			SUM(CONVERT(BIGINT,InTransit)) AS TotOW
		 FROM   vRTS_Details (NoLock)
		 WHERE  SVCode <> 'N' 
		 GROUP BY ItemNo) tItemSum FULL OUTER JOIN
		(SELECT	GER.ItemNo,
			SUM(GER.QtyRemaining) as TotRemain
		 FROM	GERRTS GER (NoLock), LocMaster Loc (NoLock)
		 WHERE	GER.LocCd = Loc.LocID And GER.StatusCd = '00'
		 GROUP BY GER.ItemNo) tPOSum
	 ON	tItemSum.ItemNo = tPOSum.ItemNo) tROPFct
ON	vRTS.ItemNo = tROPFct.ItemNo

--where 
--(isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) <> 0 AND
--CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0

WHERE  vRTS.ItemNo = '00024-4278-020' AND vRTS.SVCode <> 'N' 
ORDER BY vRTS.HubSort asc




--SELECT	A.VendNo as Vendor, A.PONo as [PO#], A.Qty, A.GrossWght as [Lbs], A.PortOfLading as [Landing Port], A.QtyRemaining as [Remaining Qty],
--	A.GERRTSStatCd as [Sts Code], A.LocCd as [PFC Destination], A.ItemNo, B.ShortCode as [BrDesc], A.MfgPlant



SELECT	isnull(tItemSum.ItemNo,tPOSum.ItemNo) AS ItemNo,
	CASE isnull(TotROP,0)
	     WHEN 0 THEN 0
		    ELSE (isnull(TotAvl,0) + isnull(TotRTSB,0) + isnull(TotOW,0) + isnull(TotRemain,0)) / isnull(TotROP,0)
	END AS ROPFactor
FROM	(SELECT	ItemNo,
		SUM(CONVERT(DECIMAL(25,1),isnull(ROPHubCalc,0))) AS TotROP,
		SUM(CONVERT(BIGINT,AvailQty)) AS TotAvl,
		SUM(CONVERT(BIGINT,RTSBQty)) AS TotRTSB,
		SUM(CONVERT(BIGINT,InTransit)) AS TotOW
	 FROM   vRTS_Details 
	 WHERE  SVCode <> 'N' 
	 GROUP BY ItemNo) tItemSum FULL OUTER JOIN
	(SELECT	GER.ItemNo,
		SUM(GER.QtyRemaining) as TotRemain
	 FROM	GERRTS GER, LocMaster Loc
	 WHERE	GER.LocCd = Loc.LocID And GER.StatusCd = '00'
	 GROUP BY GER.ItemNo) tPOSum
ON	tItemSum.ItemNo = tPOSum.ItemNo
