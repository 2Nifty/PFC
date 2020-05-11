exec sp_columns CPR_Daily


select * from CPR_Daily where CorpFixedVelCode is Null


select distinct ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, (AvailQty * NetWght) as ExtWght,
		AvailQty, Use_30Day_Qty, NetWght
from CPR_Daily where ItemNo='00200-2600-021' and ItemNo=LocationCode


SELECT		ItemNo, LocationCode, CorpFixedVelCode, AvailQty, Use_30Day_Qty, NetWght, TotStkOrd_Qty
FROM		CPR_Daily
WHERE		(CorpFixedVelCode='A')
--where AvailQty < 0
ORDER BY	ItemNo, LocationCode


SELECT		ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, (AvailQty * NetWght) as ExtWght,
		AvailQty, Use_30Day_Qty, NetWght
FROM		CPR_Daily
WHERE		(CorpFixedVelCode='A')
ORDER BY	ItemNo, LocationCode


SELECT		ItemNo, CorpFixedVelCode, SUM(AvailQty-Use_30Day_Qty) as Critical, SUM(AvailQty * NetWght) as ExtWght,
		SUM(AvailQty) as TotAvl, SUM(Use_30Day_qty) as TotUse30
FROM		CPR_Daily
WHERE		(CorpFixedVelCode='A')
group by	ItemNo, CorpFixedVelCode
ORDER BY	ItemNo


SELECT		ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, (AvailQty * NetWght) as ExtWght,
		AvailQty, Use_30Day_Qty, NetWght
FROM		CPR_Daily
WHERE		ItemNo=LocationCode
ORDER BY	CorpFixedVelCode, ItemNo


select distinct ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, (AvailQty * NetWght) as ExtWght,
		AvailQty, Use_30Day_Qty, NetWght
from CPR_Daily where ItemNo='00020-2408-021' and ItemNo=LocationCode








--Critical Items
SELECT DISTINCT	ItemNo, CorpFixedVelCode, SUM(ExtWght)
FROM		CPR_Daily
WHERE		ItemNo=LocationCode and Critical<=0 
group by	ItemNo, CorpFixedVelCode
ORDER BY	CorpFixedVelCode, ItemNo

--Non-Critical Items
SELECT DISTINCT	ItemNo, CorpFixedVelCode, SUM(ExtWght)
FROM		CPR_Daily
WHERE		ItemNo=LocationCode and Critical>0 
group by	ItemNo, CorpFixedVelCode
ORDER BY	CorpFixedVelCode, ItemNo





SELECT     CPR_Daily.ItemNo, CPR_Daily.CorpFixedVelCode, AppPref.AppOptionType, AppPref.AppOptionValue, AppPref.AppOptionNumber
FROM         CPR_Daily INNER JOIN
                      AppPref ON CPR_Daily.CorpFixedVelCode = AppPref.AppOptionValue
WHERE     (AppPref.AppOptionType = 'CIUseMult')
ORDER BY CPR_Daily.CorpFixedVelCode


SELECT     CriticalItemDetail.CorpFixedVelCode, AppPref.AppOptionType, AppPref.AppOptionValue, AppPref.AppOptionNumber
FROM         CriticalItemDetail INNER JOIN
                      AppPref ON CriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE     (AppPref.AppOptionType = 'CIUseMult')




----------------------------------------------------------------------------------------------------------------
--vvvvv--


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemSummary') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemSummary

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].CriticalItemDetail') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table CriticalItemDetail

--Detail
SELECT DISTINCT	ItemNo, CorpFixedVelCode, Cast(Use_30Day_Qty * Net_Wgt as DECIMAL(38,6)) as ExtSoldWght, Avail_Qty as AvailQty,
		Use_30Day_Qty as TotUse30, Avail_Qty - Use_30Day_Qty as CriticalQty, 0 as CriticalFlag,
		0 as NonCriticalFlag, CAST(0 as DECIMAL(38,6)) as CriticalWght, CAST(0 as DECIMAL(38,6)) as NonCriticalWght
INTO		CriticalItemDetail
FROM		CPR_Daily
WHERE		ItemNo=LocationCode and CorpFixedVelCode<>'' --and Use_30Day_Qty >= 0
ORDER BY	CorpFixedVelCode, ItemNo


--UPDATE Negative Usage
UPDATE		CriticalItemDetail
SET		ExtSoldWght = 0, TotUse30 = 0, CriticalQty = AvailQty
WHERE		TotUse30 < 0


--Apply USAGE MULTIPLIER
UPDATE		CriticalItemDetail
SET		CriticalQty = CriticalQty * AppPref.AppOptionNumber
FROM		CriticalItemDetail INNER JOIN
		AppPref ON CriticalItemDetail.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		AppPref.AppOptionType = 'CIUseMult'


--UPDATE Critical Items
UPDATE		CriticalItemDetail
SET		CriticalFlag = 1, CriticalWght = ExtSoldWght
WHERE		CriticalQty <= 0


--UPDATE Non Critical Items
UPDATE		CriticalItemDetail
SET		NonCriticalFlag = 1, NonCriticalWght = ExtSoldWght
WHERE		CriticalQty > 0


--SUMMARY
SELECT		CorpFixedVelCode, COUNT(CorpFixedVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
		CAST(SUM(CriticalFlag) as DECIMAL(38,6)) / CAST(COUNT(CorpFixedVelCode) as DECIMAL(38,6)) as CriticalCountPct,
		CAST(SUM(ExtSoldWght) as NUMERIC) as TotWght, CAST(SUM(CriticalWght) as NUMERIC) as TotWghtCritical,
		SUM(CriticalWght) / SUM(ExtSoldWght) as CriticalWghtPct,
		1-(SUM(CriticalWght) / SUM(ExtSoldWght)) as NonCriticalWghtPct,
		CAST(0 as DECIMAL(18,1)) as TargetPct
INTO		CriticalItemSummary
FROM		CriticalItemDetail
GROUP BY	CorpFixedVelCode
ORDER BY	CorpFixedVelCode


--UPDATE Target Pctage
UPDATE		CriticalItemSummary
SET		TargetPct = AppPref.AppOptionNumber
FROM		CriticalItemSummary INNER JOIN
		AppPref ON CriticalItemSummary.CorpFixedVelCode = AppPref.AppOptionValue
WHERE		(AppPref.AppOptionType = 'CITargetPer')


--UPDATE Critical flag in CPR_Daily
UPDATE		CPR_Daily
SET		Critical = 'N'
FROM		CPR_Daily INNER JOIN
		CriticalItemDetail ON CPR_Daily.ItemNo = CriticalItemDetail.ItemNo
WHERE		CriticalItemDetail.CriticalFlag = '0'

UPDATE		CPR_Daily
SET		Critical = 'Y'
FROM		CPR_Daily INNER JOIN
		CriticalItemDetail ON CPR_Daily.ItemNo = CriticalItemDetail.ItemNo
WHERE		CriticalItemDetail.CriticalFlag = '1'



--------------------------


select * from AppPref

select * from CriticalItemSummary
select * from CriticalItemDetail where CorpFixedVelCode='A'
select * from CriticalItemDetail where TotUse30 < 0


SELECT     distinct ItemNo, CorpFixedVelCode, Critical
FROM         CPR_Daily
WHERE     (CorpFixedVelCode = 'A') and Critical='Y'

--^^^^^--
----------------------------------------------------------------------------------------------------------------






if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempWO582CorpA') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tempWO582CorpA

SELECT		ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, AvailQty, Use_30Day_Qty, NetWght
INTO		tempWO582CorpA
FROM		CPR_Daily
WHERE		(CorpFixedVelCode='A') and LocationCode='01'
ORDER BY	CorpFixedVelCode, ItemNo, LocationCode



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempWO582CorpACritical') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tempWO582CorpACritical

SELECT		ItemNo, LocationCode, CorpFixedVelCode, AvailQty-Use_30Day_Qty AS Critical, AvailQty, Use_30Day_Qty, NetWght
INTO		tempWO582CorpACritical
FROM		CPR_Daily
WHERE		(AvailQty-Use_30Day_Qty < 1) and (CorpFixedVelCode='A') and LocationCode='01'
ORDER BY	CorpFixedVelCode, ItemNo, LocationCode

select * from tempWO582CorpA


SELECT	SUM(NetWght * AvailQty)
FROM	tempWO582CorpA
Where AvailQty > 0

SELECT	SUM(NetWght * AvailQty)
FROM	tempWO582CorpACritical
Where AvailQty > 0




Alter table CPR_Daily ADD Critical Char (2) NULL

Alter table CPR_Daily DROP Column Critical

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CriticalItemSummary]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CriticalItemSummary]
GO

CREATE TABLE [dbo].[CriticalItemSummary] (
	[pCriticalItemSummaryID] [numeric](9, 0) IDENTITY (1, 1) NOT NULL ,
	[CorpFixedVelCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TotCount] [int] NULL ,
	[CriticalCount] [int] NULL ,
	[CriticalCountPct] [decimal](38, 3) NULL ,
	[TotWght] [numeric](18, 0) NULL ,
	[TotWghtCritical] [numeric](18, 0) NULL ,
	[CriticalWghtPct] [decimal](38, 3) NULL ,
	[NonCriticalWghtPct] [decimal](38, 3) NULL ,
	[TargetPct] [decimal](38, 3) NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CriticalItemDetail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CriticalItemDetail]
GO

CREATE TABLE [dbo].[CriticalItemDetail] (
	[pCriticalItemDetailID] [numeric](9, 0) IDENTITY (1, 1) NOT NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CorpFixedVelCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExtSoldWght] [decimal](38, 6) NULL ,
	[AvailQty] [decimal](38, 20) NULL ,
	[TotUse30] [decimal](38, 17) NULL ,
	[CriticalQty] [decimal](38, 17) NULL ,
	[CriticalFlag] [int] NOT NULL ,
	[NonCriticalFlag] [int] NOT NULL ,
	[CriticalWght] [decimal](38, 6) NULL ,
	[NonCriticalWght] [decimal](38, 6) NULL 
) ON [PRIMARY]
GO





SELECT     [Inbound Bill of Lading No_] AS EXPR1
FROM         [Porteous$Transfer Header]





--SUMMARY
SELECT		CorpFixedVelCode, COUNT(CorpFixedVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
		CAST(CAST(SUM(CriticalFlag) as DECIMAL(38,6)) / CAST(COUNT(CorpFixedVelCode) as DECIMAL(38,6)) * 100 as DECIMAL(18,1)) as CriticalCountPct,
		CAST(SUM(ExtSoldWght) as NUMERIC) as TotWght, CAST(SUM(CriticalWght) as NUMERIC) as TotWghtCritical,
		CAST(SUM(CriticalWght) / SUM(ExtSoldWght) * 100 as DECIMAL(18,1)) as CriticalWghtPct,
		CAST(100 - (SUM(CriticalWght) / SUM(ExtSoldWght) * 100) as DECIMAL(18,1)) as NonCriticalWghtPct,
		CAST(0 as DECIMAL(18,1)) as TargetPct
FROM		CriticalItemDetail
GROUP BY	CorpFixedVelCode
ORDER BY	CorpFixedVelCode

--SUMMARY
SELECT		CorpFixedVelCode, COUNT(CorpFixedVelCode) as TotCount, SUM(CriticalFlag) as CriticalCount,
		CAST(CAST(SUM(CriticalFlag) as DECIMAL(38,6)) / CAST(COUNT(CorpFixedVelCode) as DECIMAL(38,6)) as DECIMAL(38,3)) as CriticalCountPct,
		CAST(SUM(ExtSoldWght) as NUMERIC) as TotWght, CAST(SUM(CriticalWght) as NUMERIC) as TotWghtCritical,
		CAST(SUM(CriticalWght) / SUM(ExtSoldWght) as DECIMAL(38,3)) as CriticalWghtPct,
		CAST(1 - (SUM(CriticalWght) / SUM(ExtSoldWght)) as DECIMAL(38,3)) as NonCriticalWghtPct,
		CAST(0 as DECIMAL(38,3)) as TargetPct
FROM		CriticalItemDetail
GROUP BY	CorpFixedVelCode
ORDER BY	CorpFixedVelCode