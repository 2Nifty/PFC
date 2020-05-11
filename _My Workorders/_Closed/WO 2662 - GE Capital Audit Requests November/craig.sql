if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tCD_TOD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tCD_TOD]
GO

CREATE TABLE dbo.tCD_TOD  (
	ShipLoc VARCHAR(10) NULL,
	Item VARCHAR(20) NULL,
	Sales float NULL,
	COGS float NULL,
	Wght float NULL,
	EntryDt datetime
)
GO

declare @beg int,
	@end int,
	@usefactor int

set	@beg = ((PFCReports.dbo.fGetCuvnalYear(GetDate() - 370) * 100) + PFCReports.dbo.fgetCuvnalMonth(Getdate()- 370) + 1)
set	@end =  (PFCReports.dbo.fGetCuvnalYear(GetDate()-5) * 100) + PFCReports.dbo.fgetCuvnalMonth(Getdate()-5)


select @beg, @end


--select * from CuvnalDtl
--WHERE	CurYear * 100 + CurMo Between @beg AND @end



INSERT
INTO	tCD_TOD
SELECT	ShipLoc,
	Item,
	SUM(ISNULL(InvQty,0) * ISNULL(SellPrice,0)) as Sales,
	SUM(ISNULL(InvQty,0)*ISNULL(SellCost,0)) AS COGS,
	SUM(ISNULL(SellWGT,0)) as Wght,
	Getdate() AS EntryDt
FROM	PFCReports.dbo.CuvnalDtl
WHERE	CurYear * 100 + CurMo Between @beg AND @end
GROUP BY ShipLoc, Item
GO




select * from tCD_TOD
order by Item, ShipLoc



--------------------------------------------------------------------------------------------------------------------------------------

--TRUNCATE TABLE R365Detail
--TRUNCATE TABLE R365Summ

--------------------------------------------------------------------------------------------------------------------------------------

--Load R365Detail table

declare @beg int,
	@end int,
	@usefactor int

set	@beg = ((PFCReports.dbo.fGetCuvnalYear(GetDate() - 370) * 100) + PFCReports.dbo.fgetCuvnalMonth(Getdate()- 370) + 1)
set	@end =  (PFCReports.dbo.fGetCuvnalYear(GetDate()-5) * 100) + PFCReports.dbo.fgetCuvnalMonth(Getdate()-5)
SET	@usefactor = 252

SELECT	SUBSTRING(ItemMaster.ItemNo,1,5) [CatNo],
	SUBSTRING(ItemMaster.ItemNo,7,4) [SizeNo],
	SUBSTRING(ItemMaster.ItemNo,12,3) [VarNo],
	[Branch],
	NULL PkgType,
	NULL PlatingType,
	[ItemMaster].[ItemNo],
	[ItemMaster].ItemDesc,
	BegQOH,
	BegQOH * ISNULL(NULLIF(EndAC,0),BegAC) [Ext OH],
	BegQOH * ItemMaster.Wght [On Hand Wght],
	0 [On Hand Wgt Val],
	0 [OHgt150DaysVal],
	0 [OHgt365DaysVal],
	ISNULL(CD.COGS,0) / @usefactor AS [Daily Use],
	ISNULL(CD.Wght,0) / @usefactor AS [Daily Wgt], 
	0 [Daily Wght Value],
	0 DaysOnHand,
	0 [DaysOHWght],
	[CatDesc] AS CatalogDesc,
	ItemMaster.Wght,GrossWght,
	0 [CatACperLb],
	Getdate() EntryDt,
	System_User EntryID,
	0 [CatGrpNo],
	' ' [CategoryDesc],
	0 [Catexcluded]
FROM	[ItemMaster],
	PFCAC.dbo.AvgCst_Daily LEFT OUTER JOIN
	tCD_TOD CD
ON 	PFCAC.dbo.AvgCst_Daily.Branch = CD.ShipLoc AND PFCAC.dbo.AvgCst_Daily.ItemNo = CD.Item
WHERE	ItemMaster.[ItemNo] = PFCAC.dbo.AvgCst_Daily.ItemNo 



--------------------------------------------------------------------------------------------------------------------------------------



DROP TABLE tCD
GO

UPDATE	R365Detail
SET	DaysOnHand = CASE WHEN DailysalesValue <> 0 THEN (OnhandValue / DailysalesValue) ELSE 0 END,
	DaysOnHandWght = CASE WHEN DailyWghtUse <> 0 THEN ([OnHandWght] / DailyWghtUse) ELSE 0 END

--Set Excluded Flag
UPDATE	R365Detail
SET	CatExcluded = 1
WHERE	EXISTS (SELECT 1 FROM	R365Exclusions
			 WHERE	R365Detail.CatalogNo = R365Exclusions.CatNo
				AND R365Detail.Variance = R365Exclusions.VarNo
				AND R365Exclusions.ExType='CATVAR') OR
	EXISTS (SELECT 1 FROM	R365Exclusions
			 WHERE	R365Detail.CatalogNo = R365Exclusions.CatNo
				AND R365Exclusions.ExType='CAT') OR
	EXISTS (SELECT 1 FROM	R365Exclusions
			 WHERE	R365Detail.CatalogNo BETWEEN R365Exclusions.CatNo AND R365Exclusions.CatRngLmt
				AND R365Exclusions.ExType='CATRNG')


--------------------------------------------------------------------------------------------------------------------------------------


-- Compute per LB AC by category
UPDATE	R365Detail
SET	CatACPerLB = (SELECT	SUM(ONHandValue) / SUM(ISNULL(NULLIF(OnHandWght,0),1))
		      FROM	R365Detail R365_2
		      WHERE	R365Detail.CatalogNo=R365_2.CatalogNo
		      GROUP BY	R365_2.CatalogNo)

--Set On hand Wght value
UPDATE	R365Detail
SET	DaysOnHandWght = CASE WHEN ISNULL(DailyWghtValue,0) <> 0 THEN (OnhandWght * CatACPerLB) / DailyWghtValue ELSE 0 END,
	OnhandWghtValue = OnhandWght * CatACPerLB

-- Set Daly use value for weight
UPDATE	R365Detail
SET	DailyWghtValue = DailyWghtUse * CatACPerLB

-- Set over 150 days and over 365 days on hand
UPDATE	R365Detail
SET	[OHgt150Days] = CASE WHEN DailyWghtValue =0
				THEN 0
				ELSE CASE WHEN DaysOnHand > 365
						THEN (OnHandWghtValue - (150 * DailyWghtValue) - (OnHandWghtValue - (365 * DailyWghtValue)))
					  WHEN DaysOnHand > 150
						THEN (OnHandWghtValue - (150 * DailyWghtValue))
					  ELSE 0
				     END
			END,
	[OHgt365Days] = CASE WHEN DailyWghtValue =0
				THEN OnHandWghtValue
				ELSE CASE WHEN DaysOnHand > 365 THEN (OnHandWghtValue - (365 * DailyWghtValue)) ELSE 0 END
			END




--------------------------------------------------------------------------------------------------------------------------------------


UPDATE	R365Detail
SET	CategoryGrpNo = GroupNo,
	CategoryDsc = [Description]
FROM	CAS_CatGrpDesc
WHERE	Category = CatalogNo


--------------------------------------------------------------------------------------------------------------------------------------

--R365Summ table
--Set 365 day summary with exclusions

SELECT	'WE' Type,
	'00' Location,
	ISNULL(CategoryGrpNo,0.0) [Category Group],
	SUM(OnHand) [Containers On Hand],
	SUM(OnHandWghtValue) [Inventory Cost Extended],
	sum(DailyWghtValue) [Average Cost Per Day],
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN SUM((OnHandWghtValue)) / SUM(ISNULL(DailyWghtValue,0))
		ELSE 0 --999999 Modified 1/15/8 per TJWjr
	END [Days Supply On Hand],
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN CASE WHEN (SUM(OnHandWghtValue) / SUM(ISNULL(DailyWghtValue,0))) > 365
			     THEN SUM((OnHandWghtValue - (150 * DailyWghtValue)) - (OnHandWghtValue - (365 * DailyWghtValue))) 
			  WHEN (SUM((OnHandWghtValue)) / SUM(ISNULL(DailyWghtValue,0))) > 150
			     THEN SUM((OnHandWghtValue - (150 * DailyWghtValue)))
			  ELSE 0
		     END
	     ELSE 0
	END [On hand Over 150 Days], 
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN CASE WHEN (SUM(OnHandWghtValue) / SUM(ISNULL(DailyWghtValue,0))) > 365
			     THEN SUM((OnHandWghtValue) - (365 * DailyWghtValue))
			     ELSE 0 
		     END 
		ELSE 0
	END [On Hand Over 365 Days],
	ISNULL(CategoryDsc,'None') [Description],
	system_User EntryID,
	getdate() EntryDt,
	system_user ChangeID,
	Getdate() ChangeDt,
	'' StatusCd
FROM	R365Detail R365
WHERE	CatExcluded = 0
GROUP BY CategoryGrpNo, CategoryDsc --WITH RollUP CatalogNo
ORDER BY CategoryGrpNo -- CatalogNo

--------------------------------------------------------------------------------------------------------------------------------------

--R365Summ table
--Create 365 Report Data No Exclusions

SELECT	'NE' Type,
	'00' Location,
	ISNULL(CategoryGrpNo,0.0) [Category Group],
	SUM(OnHand) [Containers On Hand],
	SUM(OnHandWghtValue) [Inventory Cost Extended],
	sum(DailyWghtValue) [Average Cost Per Day],
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN SUM((OnHandWghtValue)) / SUM(ISNULL(DailyWghtValue,0))
		ELSE 0 -- 999999 Modified 1.15.8 per TJWjr
	END [Days Supply On Hand],
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN CASE WHEN (SUM(OnHandWghtValue) / SUM(ISNULL(DailyWghtValue,0))) > 365
			     THEN SUM((OnHandWghtValue - (150 * DailyWghtValue)) - (OnHandWghtValue - (365 * DailyWghtValue)))
			  WHEN (SUM((OnHandWghtValue)) / SUM(ISNULL(DailyWghtValue,0))) > 150
			     THEN SUM((OnHandWghtValue - (150 * DailyWghtValue)))
			  ELSE 0
		     END
	     ELSE 0
	END [On hand Over 150 Days],
	CASE WHEN SUM(ISNULL(DailyWghtValue,0)) <> 0
		THEN CASE WHEN (SUM(OnHandWghtValue) / SUM(ISNULL(DailyWghtValue,0))) > 365
			     THEN SUM((OnHandWghtValue) - (365 * DailyWghtValue))
			     ELSE 0
		     END
		ELSE 0
	END [On Hand Over 365 Days],
	ISNULL(CategoryDsc,'None') [Description],
	system_User EntryID,
	getdate() EntryDt,
	system_user ChangeID,
	Getdate() ChangeDt,
	'' StatusCd
FROM	R365Detail R365
GROUP BY CategoryGrpNo, CategoryDsc --WITH RollUP CatalogNo
ORDER BY CategoryGrpNo -- CatalogNo










