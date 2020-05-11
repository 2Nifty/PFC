SELECT	CustNo, 
	SUM(AGINGCUR) AS CurrentAmt, 
--	100 * (dbo.fDivide(SUM(AGINGCUR),SUM(RemAmt),4)) as CurrentPct,
	CASE SUM(RemAmt)
		WHEN 0 THEN 0
		ELSE ROUND(100 * (SUM(AGINGCUR) / SUM(RemAmt)),4)
	END as CurrentPct,
	SUM(AGING30) AS Over30Amt, 
--	100 * (dbo.fDivide(SUM(AGING30),SUM(RemAmt),4)) as Over30Pct,
	CASE SUM(RemAmt)
		WHEN 0 THEN 0
		ELSE ROUND(100 * (SUM(AGING30) / SUM(RemAmt)),4)
	END as Over30Pct,
	SUM(AGING60) AS Over60Amt, 
--	100 * (dbo.fDivide(SUM(AGING60),SUM(RemAmt),4)) as Over60Pct,
	CASE SUM(RemAmt)
		WHEN 0 THEN 0
		ELSE ROUND(100 * (SUM(AGING60) / SUM(RemAmt)),4)
	END as Over60Pct,
	SUM(AGING90) AS Over90Amt, 
--	100 * (dbo.fDivide(SUM(AGING90),SUM(RemAmt),4)) as Over90Pct,
	CASE SUM(RemAmt)
		WHEN 0 THEN 0
		ELSE ROUND(100 * (SUM(AGING90) / SUM(RemAmt)),4)
	END as Over90Pct,
	SUM(RemAmt) AS BalanceDue,
	'WO2154' AS EntryID,
	GETDATE() AS EntryDt
FROM	(SELECT	CASE WHEN [Posting Date] > cast({ fn CURDATE() } AS DateTime) - 30 
			THEN SUM(RemAmt) 
			ELSE 0 
		END AS AGINGCUR, 
		CASE WHEN [Posting Date] BETWEEN cast({ fn CURDATE() } AS DateTime) - 59 AND cast({ fn CURDATE() } AS DateTime) - 30 
			THEN SUM(RemAmt) 
			ELSE 0 
		END AS AGING30, 
		CASE WHEN [Posting Date] BETWEEN cast({ fn CURDATE() } AS DateTime) - 89 AND cast({ fn CURDATE() } AS DateTime) - 60 
			THEN SUM(RemAmt) 
			ELSE 0 
		END AS AGING60, 
		CASE WHEN [Posting Date] < cast({ fn CURDATE() } AS DateTime) - 89 
			THEN SUM(RemAmt) 
			ELSE 0 
		END AS AGING90, 
		SUM(RemAmt) AS RemAmt, 
		[Posting Date], 
		[Sell-to Customer No_] AS CustNo
	 FROM	(SELECT	SUM(tmp.[Debit Amount]) - SUM(tmp.[Credit Amount]) AS RemAmt, 
			tmp.[Cust_ Ledger Entry No_], 
			[Porteous$Cust_ Ledger Entry].[Sell-to Customer No_], 
			[Porteous$Cust_ Ledger Entry].[Posting Date]
		 FROM	(SELECT	[Posting Date], 
				[Debit Amount], 
				[Credit Amount], 
				[Cust_ Ledger Entry No_], 
				[Customer No_]
			 FROM	[Porteous$Detailed Cust_ Ledg_ Entry] (NoLock)
			 GROUP BY [Posting Date], [Debit Amount], [Credit Amount], [Cust_ Ledger Entry No_], [Customer No_]) tmp INNER JOIN
			[Porteous$Cust_ Ledger Entry] (NoLock)
		 ON	tmp.[Cust_ Ledger Entry No_] = [Porteous$Cust_ Ledger Entry].[Entry No_]
		 GROUP BY tmp.[Cust_ Ledger Entry No_], [Porteous$Cust_ Ledger Entry].[Sell-to Customer No_], [Porteous$Cust_ Ledger Entry].[Posting Date], 
			  [Porteous$Cust_ Ledger Entry].[Due Date], [Porteous$Cust_ Ledger Entry].[Document Date]
		 HAVING	(SUM(tmp.[Debit Amount]) - SUM(tmp.[Credit Amount]) <> 0)) DetCustEntry
	 GROUP BY [Posting Date], [Sell-to Customer No_]) CustEntry
GROUP BY CustNo