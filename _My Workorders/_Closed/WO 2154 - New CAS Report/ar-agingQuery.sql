DECLARE	@CuvnalYear INT,
	@CuvnalMonth INT,
	@CuvnalMonthYear BIGINT,
	@CuvnalMo12 INT,
	@CuvnalYearMo12 INT,
	@CuvnalMonthYear12 INT
--	@CuvnalFYBegin BIGINT 

--Establish FY Range
SELECT	@CuvnalYear = PFCReports.dbo.fGetCuvnalYear(GETDATE())
SELECT	@CuvnalMonth = PFCReports.dbo.fGetCuvnalMonth(GETDATE())
SET	@CuvnalMonthYear = (@CuvnalYear * 100) + @CuvnalMonth
SELECT	@CuvnalMo12 = dbo.fGetCuvnalMo12( dbo.fGetCuvnalMonth(GETDATE()))
SELECT	@CuvnalYearMo12 = PFCReports.dbo.fGetCuvnalYear12(dbo.fGetCuvnalMonth(Getdate()),@CuvnalMo12,dbo.fGetCuvnalYear(Getdate()))
--SET	@CuvnalFYBegin = (@CuvnalYearMo1FY * 100) + @CuvnalMo1FY
SET	@CuvnalMonthYear12 = (@CuvnalYearMo12 * 100) + @CuvnalMo12







SELECT	AR_AGING.CustNo,
	AR_AGING.[Current] as AgingCur,
	AR_AGING.[Over30] as Aging30,
	AR_AGING.[Over60] as Aging60,
	AR_AGING.[Over90] as Aging90,
	AR_AGING.[BALDue] as AgingTot,
	100 * (dbo.fDivide(AR_AGING.[Current],AR_AGING.[BALDue],4)) as AgingCurPct,
	100 * (dbo.fDivide(AR_AGING.[Over30],AR_AGING.[BALDue],4)) as Aging30Pct,
	100 * (dbo.fDivide(AR_AGING.[Over60],AR_AGING.[BALDue],4)) as Aging60Pct,
	100 * (dbo.fDivide(AR_AGING.[Over90],AR_AGING.[BALDue],4)) as Aging90Pct,
	null as DSO --,
	--365 * (dbo.fdivide(([BalDue]), (SELECT SUM(ISNULL(CMSales,0)) FROM CuvnalSum WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalMonthYear12 AND @CuvnalMonthYear AND CAS_CustomerData.CustNO =CuvnalSum.CustNo),2)) as DSO
FROM	AR_AGING (NoLock)


select * from AR_Aging where CustNo='001117'





select * from AR_aging


UPDATE CAS_CustomerData SET
AgingCur = [Current],
Aging30 = [Over30],
Aging60 = [Over60],
AgingOver90 = [Over90],
AgingTot = [BALDue],
AgingCurPct= 100 * (dbo.fDivide([Current],BALDue,4)),
Aging30Pct= 100 * (dbo.fDivide([Over30],BALDue,4)),
Aging60Pct= 100 * (dbo.fDivide([Over60],BALDue,4)),
Aging90Pct= 100 * (dbo.fDivide([Over90],BALDue,4)),

DSO =365 *
(dbo.fdivide((SELECT BalDue FROM AR_Aging WHERE CAS_CustomerData.CustNO = AR_Aging.CustNO),
(SELECT SUM(ISNULL(CMSales,0)) FROM CuvnalSum
WHERE  ((CURYEAR * 100) + CurMo)  BETWEEN
@CuvnalMonthYear12 AND @CuvnalMonthYear
AND CAS_CustomerData.CustNO =CuvnalSum.CustNo),2))


FROM AR_Aging WHERE CAS_CustomerData.CustNo = AR_Aging.CustNo
AND CurMonth = dbo.fGetCuvnalMonth (GETDATE())
AND CurYear = dbo.fGetCuvnalYear (Getdate())




-------------------------------------------------------------------------------------------




	SELECT	AR_Aging.CustNo,
			AR_Aging.[Current] as AgingCur,
			AR_Aging.[Over30] as Aging30,
			AR_Aging.[Over60] as Aging60,
			AR_Aging.[Over90] as Aging90,
			AR_Aging.[BALDue] as AgingTot,
			100 * (dbo.fDivide(AR_Aging.[Current],AR_Aging.[BALDue],4)) as AgingCurPct,
			100 * (dbo.fDivide(AR_Aging.[Over30],AR_Aging.[BALDue],4)) as Aging30Pct,
			100 * (dbo.fDivide(AR_Aging.[Over60],AR_Aging.[BALDue],4)) as Aging60Pct,
			100 * (dbo.fDivide(AR_Aging.[Over90],AR_Aging.[BALDue],4)) as Aging90Pct,
			null as DSO --,
--			365 * (dbo.fdivide(([BalDue]), (SELECT SUM(ISNULL(CMSales,0)) FROM CuvnalSum WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalMonthYear12 AND @CuvnalMonthYear AND CAS_CustomerData.CustNO =CuvnalSum.CustNo),2)) as DSO
	FROM	CustomerMaster Cust (NoLock) INNER JOIN
			AR_Aging (NoLock)
	ON		Cust.CustNo = AR_Aging.CustNo
	WHERE	Cust.ChainCd='AAB'



select * from CustomerMaster where CustNo='001117'