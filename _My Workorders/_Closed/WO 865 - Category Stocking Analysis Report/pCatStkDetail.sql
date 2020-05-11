
CREATE   PROCEDURE [dbo].[pCatStkDetail] AS

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CatStkDetail') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CatStkDetail

--Load All Bulk Items (ZERO Items)
SELECT DISTINCT	CPR_Daily.ItemNo,
		CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END as LocationCode, Cast(' ' as varchar(30)) as LocationName, LEFT(CPR_Daily.ItemNo,5) as Category,
		CAST(0 AS Integer) AS TotUse30, CAST(0 AS Integer) AS AvailQty, CAST(0 AS DECIMAL(38,6)) AS ExtSoldWght,
		CAST(0 AS DECIMAL(38,6)) AS AvailQtyWght, CAST(0 AS DECIMAL(18,2)) AS MonthsOH, CAST(0 AS DECIMAL(38,6)) AS Rop_Calc,
		CorpFixedVelCode, SVCode AS SalesVelCode, ' ' AS CatVelCode, Net_Wgt, Description, PlatingNo,
		system_user AS EntryID, GetDate() AS EntryDt, NULL AS ChangeID, NULL AS ChangeDt
INTO		CatStkDetail
FROM		CPR_Daily 
WHERE		(SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '0' OR SUBSTRING(CPR_Daily.ItemNo, 12, 1) = '5') AND
		((CorpFixedVelCode is not NULL and SVCode is not NULL) or (ItemNo=LocationCode))
ORDER BY	CPR_Daily.ItemNo, CASE LocationCode
		  WHEN CPR_Daily.ItemNo THEN '00'
		  ELSE LocationCode
		END

Create index idxCatStkDetailLocCd on CatStkDetail([LocationCode])
Create index idxCatStkDetailCat on CatStkDetail(Category)
Create index idxCatStkDetailPlatNo on CatStkDetail(PlatingNo)

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

go
