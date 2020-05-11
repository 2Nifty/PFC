
select [ItemNo], [CorpFixedVelCode] as VelCode from tempCriticalItemDetail where [VelCode]='E'


--CREATE  PROCEDURE dbo.spCriticalItems
--as

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemSummary') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemSummary

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempCriticalItemDetail') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tempCriticalItemDetail

--Detail
SELECT DISTINCT	ItemNo, LocationCode, Cast(' ' as varchar(30)) as LocationName, CorpFixedVelCode, Cast(' ' as char(3)) as CatVelCode,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as ExtSoldWght, CAST(Avail_Qty as Integer) as AvailQty,
		ROUND(Use_30Day_Qty,0) as TotUse30, Avail_Qty - ROUND(Use_30Day_Qty,0) as CriticalQty, 0 as CriticalFlag,
		0 as NonCriticalFlag, Cast((Avail_Qty - ROUND(Use_30Day_Qty,0)) * -1 * Net_Wgt as DECIMAL(38,6)) as CriticalWght,
		Cast(ROUND(Use_30Day_Qty,0) * Net_Wgt as DECIMAL(38,6)) as NonCriticalWght, Cast (0 as DECIMAL(38,6)) as CriticalWghtPct,
		Cast (0 as DECIMAL(38,6)) as NonCriticalWghtPct, CAST(0 as DECIMAL(18,2)) as TargetPct, Description
INTO		tempCriticalItemDetail
FROM		CPR_Daily
WHERE		CorpFixedVelCode<>'' --and ItemNo<>LocationCode --and Use_30Day_Qty >= 0
ORDER BY	CorpFixedVelCode, ItemNo

--Update Category Velocity Code
UPDATE		tempCriticalItemDetail
SET		CatVelCode = CatVelocityCd
FROM		tempCriticalItemDetail INNER JOIN
                ItemMaster ON tempCriticalItemDetail.ItemNo = ItemMaster.ItemNo

--UPDATE Summary Locations
UPDATE		tempCriticalItemDetail
SET		LocationCode = '00'
WHERE		ItemNo=LocationCode

--UPDATE Negative Usage
UPDATE		tempCriticalItemDetail
SET		ExtSoldWght = 0, TotUse30 = 0, CriticalQty = AvailQty
WHERE		TotUse30 < 0

--Apply USAGE MULTIPLIER
UPDATE		tempCriticalItemDetail
SET		CriticalQty = CriticalQty * AppPref.AppOptionNumber
FROM		tempCriticalItemDetail INNER JOIN
		AppPref ON tempCriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		AppPref.AppOptionType = 'CIUseMult'

--UPDATE Critical Items
UPDATE		tempCriticalItemDetail
SET		CriticalFlag = 1, NonCriticalWght = NonCriticalWght - CriticalWght
WHERE		CriticalQty < 0

--UPDATE Non Critical Items
UPDATE		tempCriticalItemDetail
SET		NonCriticalFlag = 1, CriticalWght = 0
WHERE		CriticalQty >= 0

--UPDATE Critical Weight Pct
UPDATE		tempCriticalItemDetail
SET		CriticalWghtPct = 
		  CASE
		    WHEN ExtSoldWght <= 0 THEN 0
		    WHEN ExtSoldWght > 0 THEN CriticalWght / ExtSoldWght
		  END
WHERE		CriticalFlag = 1

UPDATE		tempCriticalItemDetail
SET		CriticalWghtPct = 1
WHERE		CriticalWghtPct > 1

--UPDATE Non-Critical Weight Pct
UPDATE		tempCriticalItemDetail
SET		NonCriticalWghtPct = 1 - CriticalWghtPct

--UPDATE Target Pctage
UPDATE		tempCriticalItemDetail
SET		TargetPct = AppPref.AppOptionNumber
FROM		tempCriticalItemDetail INNER JOIN
		AppPref ON tempCriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--Update Location Name
Update	tempCriticalItemDetail
Set	LocationName=LocName
FROM         tempCriticalItemDetail INNER JOIN
                      LocMaster ON tempCriticalItemDetail.LocationCode = LocMaster.LocID



--Corp SUMMARY
SELECT		'CORP' as VelType, CorpFixedVelCode, COUNT(CorpFixedVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
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
INTO		tempCriticalItemSummary
FROM		tempCriticalItemDetail
GROUP BY	CorpFixedVelCode, LocationCode
ORDER BY	CorpFixedVelCode, LocationCode


--Cat SUMMARY
SELECT		'CAT' as VelType, CatVelCode, COUNT(CatVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
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
INTO		tempCriticalItemSummaryCat
FROM		tempCriticalItemDetail
GROUP BY	CatVelCode, LocationCode
ORDER BY	CatVelCode, LocationCode

select * from tempCriticalItemSummaryCat
UNION
Select * from tempCriticalItemSummary
into tempDixon



UPDATE		CriticalItemSummary
SET		CriticalWghtPct = 1
WHERE		CriticalWghtPct > 1

UPDATE		CriticalItemSummary
SET		NonCriticalWghtPct = 1-CriticalWghtPct


--UPDATE Target Pctage
UPDATE		CriticalItemSummary
SET		TargetPct = AppPref.AppOptionNumber
FROM		CriticalItemSummary INNER JOIN
		AppPref ON CriticalItemSummary.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')

--UPDATE Critical flag in CPR_Daily
UPDATE		CPR_Daily
SET		Critical = ''

UPDATE		CPR_Daily
SET		Critical = 'N'
FROM		CPR_Daily INNER JOIN
		tempCriticalItemDetail ON CPR_Daily.ItemNo = tempCriticalItemDetail.ItemNo and CPR_Daily.LocationCode = tempCriticalItemDetail.LocationCode
WHERE		tempCriticalItemDetail.CriticalFlag = '0'

UPDATE		CPR_Daily
SET		Critical = 'Y'
FROM		CPR_Daily INNER JOIN
		tempCriticalItemDetail ON CPR_Daily.ItemNo = tempCriticalItemDetail.ItemNo and CPR_Daily.LocationCode = tempCriticalItemDetail.LocationCode
WHERE		tempCriticalItemDetail.CriticalFlag = '1'

--Update Location name
Update	CriticalItemSummary
Set	LocationName=LocName
FROM         CriticalItemSummary INNER JOIN
                      LocMaster ON CriticalItemSummary.LocationCode = LocMaster.LocID



--GO
