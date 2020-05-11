DECLARE	@BegPer as VARCHAR(6),
	@EndPer as VARCHAR(6),
	@BegPerDt as DATETIME,
	@EndPerdt as DATETIME


SELECT	@BegPer = min(CurPeriodNo),
	@EndPer = max(CurPeriodNo)
FROM	ItemBranchUsage (NoLock)

SELECT	DISTINCT
	@BegPerDt = CurFiscalMthBeginDt
FROM	FisCalCalendar Per (NoLock)
WHERE	RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) = @BegPer

SELECT	DISTINCT
	@EndPerDt = CurFiscalMthEndDt
FROM	FisCalCalendar Per (NoLock)
WHERE	RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) = @EndPer

select @BegPer as BegPer, @BegPerDt as BegPerDt, @EndPer as EndPer, @EndPerDt as EndPerDt


