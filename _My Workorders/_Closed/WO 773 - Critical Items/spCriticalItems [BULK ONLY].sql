if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spCriticalItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spCriticalItems]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE  PROCEDURE dbo.spCriticalItems
as

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemSummary') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemSummary

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemSummaryCat') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemSummaryCat

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemDetail') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemDetail


----------
--Detail--
----------
SELECT DISTINCT	ItemNo, LocationCode, Cast(' ' as varchar(30)) as LocationName, CorpFixedVelCode, Cast(' ' as char(3)) as CatVelCode,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as ExtSoldWght, CAST(Avail_Qty as Integer) as AvailQty,
		ROUND(Use_30Day_Qty,0) as TotUse30, Avail_Qty - ROUND(Use_30Day_Qty,0) as CriticalQty, 0 as CriticalFlag,
		0 as NonCriticalFlag, Cast((Avail_Qty - ROUND(Use_30Day_Qty,0)) * -1 * Net_Wgt as DECIMAL(38,6)) as CriticalWght,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as NonCriticalWght, Cast (0 as DECIMAL(38,6)) as CriticalWghtPct,
		Cast (0 as DECIMAL(38,6)) as NonCriticalWghtPct, CAST(0 as DECIMAL(18,2)) as TargetPct, CAST(0 as DECIMAL(18,2)) as TargetPctCat,
		Description, SVCode, Net_Wgt
INTO		CriticalItemDetail
FROM		CPR_Daily
WHERE	CorpFixedVelCode<>'' and (SVCode<>'N' or SVCode is NULL) and
		(SUBSTRING(ItemNo,12,1)='0' or SUBSTRING(ItemNo,12,1)='1' or SUBSTRING(ItemNo,12,1)='5')
		--and ItemNo<>LocationCode --and Use_30Day_Qty >= 0
ORDER BY	CorpFixedVelCode, ItemNo

--Update Category Velocity Code
UPDATE		CriticalItemDetail
SET		CatVelCode = CatVelocityCd
FROM		CriticalItemDetail INNER JOIN
                ItemMaster ON CriticalItemDetail.ItemNo = ItemMaster.ItemNo


--Update NULL Velocity Codes
UPDATE		CriticalItemDetail
SET		CatVelCode = 'N'
WHERE		CatVelCode = '' OR CatVelCode IS NULL

UPDATE		CriticalItemDetail
SET		CorpFixedVelCode = 'I'
WHERE		CorpFixedVelCode = '' OR CorpFixedVelCode IS NULL


--UPDATE Summary Locations
UPDATE		CriticalItemDetail
SET		LocationCode = '00'
WHERE		ItemNo=LocationCode

--UPDATE Negative Usage
UPDATE		CriticalItemDetail
SET		ExtSoldWght = 1, TotUse30 = 0, CriticalQty = AvailQty
WHERE		TotUse30 < 0

UPDATE		CriticalItemDetail
SET		ExtSoldWght = 1
WHERE		ExtSoldWght = 0


--Apply USAGE MULTIPLIER
UPDATE		CriticalItemDetail
SET		CriticalQty = CriticalQty * AppPref.AppOptionNumber
FROM		CriticalItemDetail INNER JOIN
		AppPref ON CriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		AppPref.AppOptionType = 'CIUseMult'

--UPDATE Critical Items
UPDATE		CriticalItemDetail
SET		CriticalFlag = 1, NonCriticalWght = NonCriticalWght - CriticalWght
WHERE		CriticalQty < 0

--UPDATE Non Critical Items
UPDATE		CriticalItemDetail
SET		NonCriticalFlag = 1, CriticalWght = 0
WHERE		CriticalQty >= 0

--UPDATE Critical Weight Pct
UPDATE		CriticalItemDetail
SET		CriticalWghtPct = 
		  CASE
		    WHEN ExtSoldWght <= 0 THEN 0
		    WHEN ExtSoldWght > 0 THEN CriticalWght / ExtSoldWght
		  END
WHERE		CriticalFlag = 1

UPDATE		CriticalItemDetail
SET		CriticalWghtPct = 1
WHERE		CriticalWghtPct > 1

--UPDATE Non-Critical Weight Pct
UPDATE		CriticalItemDetail
SET		NonCriticalWghtPct = 1 - CriticalWghtPct

--UPDATE Target Pctage
UPDATE		CriticalItemDetail
SET		TargetPct = AppPref.AppOptionNumber
FROM		CriticalItemDetail INNER JOIN
		AppPref ON CriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--UPDATE Target Pctage Cat
UPDATE		CriticalItemDetail
SET		TargetPctCat = AppPref.AppOptionNumber
FROM		CriticalItemDetail INNER JOIN
		AppPref ON CriticalItemDetail.CatVelCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--Update Location Name
Update	CriticalItemDetail
Set	LocationName=LocName
FROM         CriticalItemDetail INNER JOIN
                      LocMaster ON CriticalItemDetail.LocationCode = LocMaster.LocID


----------------
--Corp SUMMARY--
----------------
SELECT		CorpFixedVelCode as VelocityCode, COUNT(CorpFixedVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
		CriticalCountPct = 
		  CASE
		    WHEN COUNT(CorpFixedVelCode) <= 0 THEN 0
		    WHEN COUNT(CorpFixedVelCode) > 0 THEN CAST(SUM(CriticalFlag) as DECIMAL(38,6)) / CAST(COUNT(CorpFixedVelCode) as DECIMAL(38,6))
		  END,
		CAST(SUM(ExtSoldWght) as NUMERIC) as TotWght, CAST(SUM(CriticalWght) as NUMERIC) as TotWghtCritical,
		CriticalWghtPct = 
		  CASE
		    WHEN SUM(ExtSoldWght) <= 0 THEN 0
		    WHEN SUM(ExtSoldWght) > 0 THEN SUM(CriticalWght) / SUM(ExtSoldWght)
		  END,
		CAST(0 as DECIMAL(38,6)) as NonCriticalWghtPct,
		CAST(0 as DECIMAL(18,2)) as TargetPct, LocationCode, Cast(' ' as varchar(30)) as LocationName
INTO		CriticalItemSummary
FROM		CriticalItemDetail
GROUP BY	CorpFixedVelCode, LocationCode
ORDER BY	CorpFixedVelCode, LocationCode

UPDATE		CriticalItemSummary
SET		CriticalWghtPct = 1
WHERE		CriticalWghtPct > 1

UPDATE		CriticalItemSummary
SET		NonCriticalWghtPct = 1-CriticalWghtPct

--UPDATE Target Pctage
UPDATE		CriticalItemSummary
SET		TargetPct = AppPref.AppOptionNumber
FROM		CriticalItemSummary INNER JOIN
		AppPref ON CriticalItemSummary.VelocityCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--Update Location name
Update	CriticalItemSummary
Set	LocationName=LocName
FROM         CriticalItemSummary INNER JOIN
                      LocMaster ON CriticalItemSummary.LocationCode = LocMaster.LocID


---------------
--Cat SUMMARY--
---------------
SELECT		CatVelCode as VelocityCode, COUNT(CatVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
		CriticalCountPct = 
		  CASE
		    WHEN COUNT(CatVelCode) <= 0 THEN 0
		    WHEN COUNT(CatVelCode) > 0 THEN CAST(SUM(CriticalFlag) as DECIMAL(38,6)) / CAST(COUNT(CatVelCode) as DECIMAL(38,6))
		  END,
		CAST(SUM(ExtSoldWght) as NUMERIC) as TotWght, CAST(SUM(CriticalWght) as NUMERIC) as TotWghtCritical,
		CriticalWghtPct = 
		  CASE
		    WHEN SUM(ExtSoldWght) <= 0 THEN 0
		    WHEN SUM(ExtSoldWght) > 0 THEN SUM(CriticalWght) / SUM(ExtSoldWght)
		  END,
		CAST(0 as DECIMAL(38,6)) as NonCriticalWghtPct,
		CAST(0 as DECIMAL(18,2)) as TargetPct, LocationCode, Cast(' ' as varchar(30)) as LocationName
INTO		CriticalItemSummaryCat
FROM		CriticalItemDetail
GROUP BY	CatVelCode, LocationCode
ORDER BY	CatVelCode, LocationCode


UPDATE		CriticalItemSummaryCat
SET		CriticalWghtPct = 1
WHERE		CriticalWghtPct > 1

UPDATE		CriticalItemSummaryCat
SET		NonCriticalWghtPct = 1-CriticalWghtPct

--UPDATE Target Pctage
UPDATE		CriticalItemSummaryCat
SET		TargetPct = AppPref.AppOptionNumber
FROM		CriticalItemSummaryCat INNER JOIN
		AppPref ON CriticalItemSummaryCat.VelocityCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--Update Location name
Update	CriticalItemSummaryCat
Set	LocationName=LocName
FROM         CriticalItemSummaryCat INNER JOIN
                      LocMaster ON CriticalItemSummaryCat.LocationCode = LocMaster.LocID


------------------------------------
--UPDATE Critical flag in CPR_Daily
UPDATE		CPR_Daily
SET		Critical = ''

UPDATE		CPR_Daily
SET		Critical = 'N'
FROM		CPR_Daily INNER JOIN
		CriticalItemDetail ON CPR_Daily.ItemNo = CriticalItemDetail.ItemNo and CPR_Daily.LocationCode = CriticalItemDetail.LocationCode
WHERE		CriticalItemDetail.CriticalFlag = '0'

UPDATE		CPR_Daily
SET		Critical = 'Y'
FROM		CPR_Daily INNER JOIN
		CriticalItemDetail ON CPR_Daily.ItemNo = CriticalItemDetail.ItemNo and CPR_Daily.LocationCode = CriticalItemDetail.LocationCode
WHERE		CriticalItemDetail.CriticalFlag = '1'
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

