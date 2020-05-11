
select * from SOHeaderHist


--------------------------------------------------------------------------------------------------------

SELECT	CustNo, 
	SUM(AGINGCUR) AS [AGINGCUR], 
	SUM(AGING30) AS [AGING30], 
	SUM(AGING60) AS [AGING60], 
	SUM(AGING90) AS [AGING90], 
	SUM(RemAmt)  AS BALDUE--, Case when sum(AGINGCUR) = 0 THEN 0 ELSE SUM(AGINGCUR /BALDUE) AS AGINGCURPCT
FROM
	(SELECT	CASE 	WHEN [Posting Date] > cast({ fn CURDATE() } AS DateTime) - 30 
			THEN SUM(RemAmt) 
			ELSE 0 
			END AS AGINGCUR, 
		CASE 	WHEN [Posting Date] BETWEEN cast({ fn CURDATE() } AS DateTime) - 59 AND cast({ fn CURDATE() } AS DateTime) - 30 
			THEN SUM(RemAmt) 
			ELSE 0 
			END AS AGING30, 
		CASE 	WHEN [Posting Date] BETWEEN cast({ fn CURDATE() } AS DateTime) - 89 AND cast({ fn CURDATE() } AS DateTime) - 60 
			THEN SUM(RemAmt) 
			ELSE 0 
			END AS AGING60, 
		CASE 	WHEN [Posting Date] < cast({ fn CURDATE() } AS DateTime) - 89 
			THEN SUM(RemAmt) 
			ELSE 0 
			END AS AGING90, 
		SUM(RemAmt) AS RemAmt, 
		[Posting Date], 
		[Sell-to Customer No_] AS CustNo
	FROM
		(SELECT	 SUM(tmp.[Debit Amount]) - SUM(tmp.[Credit Amount]) AS RemAmt, 
			tmp.[Cust_ Ledger Entry No_], 
			PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Sell-to Customer No_], 
			PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Posting Date]
		FROM
			(SELECT	[Posting Date], 
				[Debit Amount], 
				[Credit Amount], 
				[Cust_ Ledger Entry No_], 
				[Customer No_]
			FROM	PFClive.dbo.[Porteous$Detailed Cust_ Ledg_ Entry] (NoLock)
			GROUP BY [Posting Date], [Debit Amount], [Credit Amount], [Cust_ Ledger Entry No_], [Customer No_]
			) tmp 
		INNER JOIN PFClive.dbo.[Porteous$Cust_ Ledger Entry] (NoLock) ON 
			tmp.[Cust_ Ledger Entry No_] = PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Entry No_]
		GROUP BY tmp.[Cust_ Ledger Entry No_], PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Sell-to Customer No_], PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Posting Date], 
			PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Due Date], PFClive.dbo.[Porteous$Cust_ Ledger Entry].[Document Date]
		HAVING	(SUM(tmp.[Debit Amount]) - SUM(tmp.[Credit Amount]) <> 0)
		) DetCustEntry
	GROUP BY [Posting Date], [Sell-to Customer No_]) CustEntry

where CustNo='001117'
GROUP BY CustNo




select * from AR_Aging where CustNo='001117'



--------------------------------------------------------------------------------------



DECLARE @CuvnalYear INT,
@CuvnalMonth INT,
@CuvnalMonthYear BIGINT,
@CuvnalMo12 INT,
@CuvnalYearMo12 INT,
@CuvnalMonthYear12 INT

-- Establish FY Range
SELECT @CuvnalYear = PFCReports.dbo.fGetCuvnalYear(GETDATE())
SELECT @CuvnalMonth = PFCReports.dbo.fGetCuvnalMonth(GETDATE())
SET @CuvnalMonthYear = (@CuvnalYear * 100) + @CuvnalMonth
SELECT @CuvnalMo12 = dbo.fGetCuvnalMo12( dbo.fGetCuvnalMonth(GETDATE()))
SELECT @CuvnalYearMo12 = PFCReports.dbo.fGetCuvnalYear12(dbo.fGetCuvnalMonth(Getdate()),@CuvnalMo12,dbo.fGetCuvnalYear(Getdate()))
SET @CuvnalMonthYear12 = (@CuvnalYearMo12 * 100) + @CuvnalMo12

UPDATE	CAS_CustomerData
SET	AgingCur = [Current],
	Aging30 = [Over30],
	Aging60 = [Over60],
	AgingOver90 = [Over90],
	AgingTot = [BALDue],
	AgingCurPct= 100 * (dbo.fDivide([Current],BALDue,4)),
	Aging30Pct= 100 * (dbo.fDivide([Over30],BALDue,4)),
	Aging60Pct= 100 * (dbo.fDivide([Over60],BALDue,4)),
	Aging90Pct= 100 * (dbo.fDivide([Over90],BALDue,4)),
	DSO = 365 *
		(dbo.fdivide((SELECT BalDue FROM AR_Aging WHERE CAS_CustomerData.CustNO = AR_Aging.CustNO),
			     (SELECT SUM(ISNULL(CMSales,0)) FROM CuvnalSum WHERE  ((CURYEAR * 100) + CurMo)  BETWEEN @CuvnalMonthYear12 AND @CuvnalMonthYear AND CAS_CustomerData.CustNO =CuvnalSum.CustNo),2))
FROM	AR_Aging
WHERE	CAS_CustomerData.CustNo = AR_Aging.CustNo
	AND CurMonth = dbo.fGetCuvnalMonth (GETDATE())
	AND CurYear = dbo.fGetCuvnalYear (Getdate())