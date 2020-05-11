--All Item Detail
SELECT DISTINCT	CPR_Daily.ItemNo,
		CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END as LocationCode, LEFT(CPR_Daily.ItemNo,5) as Category, CAST(ROUND(Use_30Day_Qty, 0) as Integer) AS TotUse30,
		CAST(Avail_Qty AS Integer) AS AvailQty, Cast(ROUND(Use_30Day_Qty, 0) * Net_Wgt AS DECIMAL(38, 6)) AS ExtSoldWght,
		Avail_Qty * Net_Wgt AS AvailQtyWght, 
		CASE Cast(ROUND(Use_30Day_Qty, 0) * Net_Wgt AS DECIMAL(38, 6))
		   WHEN 0 THEN 0
		   ELSE Avail_Qty * Net_Wgt / Cast(ROUND(Use_30Day_Qty, 0) * Net_Wgt AS DECIMAL(38, 6))
		END AS MonthsOH,
		Rop_Calc, CorpFixedVelCode, SVCode AS SalesVelCode, 
--		ItemMaster.CatVelocityCd AS CategoryVelCode,
		Net_Wgt, Description, PlatingNo
FROM		CPR_Daily 
--INNER JOIN
--                ItemMaster ON CPR_Daily.ItemNo = ItemMaster.ItemNo
--CROSS JOIN
--		(SELECT COUNT(*) AS BulkItemCount FROM
--			(SELECT ItemNo FROM CPR_Daily
--				WHERE	(SUBSTRING(ItemNo, 12, 1) = '0' OR SUBSTRING(ItemNo, 12, 1) = '5') AND
--					 CorpFixedVelCode <> '' AND (SVCode <> 'N' OR SVCode IS NULL)
--				GROUP BY ItemNo) Items) ItemCount
WHERE		(SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '0' OR SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '5') AND CorpFixedVelCode <> '' AND (SVCode <> 'N' OR SVCode IS NULL)
ORDER BY	CPR_Daily.ItemNo, CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END




-----------------------------------------------------------------------------------------

--Load All Bulk Items (ZERO Items)
SELECT DISTINCT	CPR_Daily.ItemNo,
		CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END as LocationCode, Cast(' ' as varchar(30)) as LocationName, LEFT(CPR_Daily.ItemNo,5) as Category,
		CAST(0 AS Integer) AS TotUse30, CAST(0 AS Integer) AS AvailQty, CAST(0 AS DECIMAL(38,6)) AS ExtSoldWght,
		CAST(0 AS DECIMAL(38,6)) AS AvailQtyWght, CAST(0 AS DECIMAL(18,2)) AS MonthsOH, CAST(0 AS DECIMAL(38,6)) AS Rop_Calc,
		CorpFixedVelCode, SVCode AS SalesVelCode, ' ' AS CatVelCode, Net_Wgt, Description, PlatingNo
INTO		CatStkDetail
FROM		CPR_Daily 
WHERE		(SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '0' OR SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '5') AND
		((CorpFixedVelCode is not NULL and SVCode is not NULL) or (ItemNo=LocationCode))
ORDER BY	CPR_Daily.ItemNo, CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END

--Update Category Velocity Code
UPDATE	CatStkDetail
SET	CatVelCode = CatVelocityCd
FROM	CatStkDetail INNER JOIN
	ItemMaster ON CatStkDetail.ItemNo = ItemMaster.ItemNo


--Update Location Name
Update	CatStkDetail
Set	LocationName=LocName
FROM	CatStkDetail INNER JOIN
	LocMaster ON CatStkDetail.LocationCode = LocMaster.LocID


--Update Item Detail
UPDATE	CatStkDetail
SET	TotUse30 = CAST(ROUND(CPR.Use_30Day_Qty, 0) as Integer),
	AvailQty = CAST(CPR.Avail_Qty AS Integer),
	ExtSoldWght =  Cast(ROUND(CPR.Use_30Day_Qty, 0) * CPR.Net_Wgt AS DECIMAL(38, 6)),
	AvailQtyWght = CPR.Avail_Qty * CPR.Net_Wgt,
	MonthsOH = CASE Cast(ROUND(CPR.Use_30Day_Qty, 0) * CPR.Net_Wgt AS DECIMAL(38, 6))
			WHEN 0 THEN 0
			ELSE CPR.Avail_Qty * CPR.Net_Wgt / Cast(ROUND(CPR.Use_30Day_Qty, 0) * CPR.Net_Wgt AS DECIMAL(38, 6))
		   END,
	ROP_Calc = CPR.ROP_Calc
FROM	CatStkDetail CAT INNER JOIN
	CPR_Daily CPR ON CAT.ItemNo = CPR.ItemNo AND
	CAT.LocationCode = CASE CPR.LocationCode
					WHEN CPR.ItemNo THEN '00'
					ELSE CPR.LocationCode
				    END
WHERE	(SUBSTRING(CAT.ItemNo, 12, 1) = '0' OR SUBSTRING(CAT.ItemNo, 12, 1) = '5') AND CAT.CorpFixedVelCode <> '' AND (CAT.SalesVelCode <> 'N' OR CAT.SalesVelCode IS NULL)






-----------------------------------------------------------------------------------------



(SELECT	LocationCode AS Loc, LEFT(ItemNo,5) AS Cat,  PlatingNo AS Plt, COUNT(LocationCode) AS ItemCount
FROM	CatStkDetail
	 WHERE	(SUBSTRING(ItemNo, 12, 1) = '0' OR SUBSTRING(ItemNo, 12, 1) = '5')
GROUP BY LocationCode, LEFT(ItemNo,5), PlatingNo
ORDER BY LEFT(ItemNo,5), LocationCode, PlatingNo) Items









select distinct LocationCode, * from CPR_Daily
WHERE		CorpFixedVelCode =''  --is NULL and SVCode is NULL AND ItemNo<>LocationCode  --(SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '0' OR SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '5')

select top 100 ROP_Calc, * from CPR_Daily


SELECT DISTINCT	ItemNo, LocationCode, Cast(' ' as varchar(30)) as LocationName, CorpFixedVelCode, Cast(' ' as char(3)) as CatVelCode,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as ExtSoldWght, CAST(Avail_Qty as Integer) as AvailQty,
		ROUND(Use_30Day_Qty,0) as TotUse30, Avail_Qty - ROUND(Use_30Day_Qty,0) as CriticalQty, 0 as CriticalFlag,
		0 as NonCriticalFlag, Cast((Avail_Qty - ROUND(Use_30Day_Qty,0)) * -1 * Net_Wgt as DECIMAL(38,6)) as CriticalWght,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as NonCriticalWght, Cast (0 as DECIMAL(38,6)) as CriticalWghtPct,
		Cast (0 as DECIMAL(38,6)) as NonCriticalWghtPct, CAST(0 as DECIMAL(18,2)) as TargetPct, CAST(0 as DECIMAL(18,2)) as TargetPctCat,
		Description, SVCode, Net_Wgt
--INTO		CriticalItemDetail
FROM		CPR_Daily
WHERE		CorpFixedVelCode<>'' and (SVCode<>'N' or SVCode is NULL) --and ItemNo<>LocationCode --and Use_30Day_Qty >= 0
ORDER BY	CorpFixedVelCode, ItemNo, LocationCode