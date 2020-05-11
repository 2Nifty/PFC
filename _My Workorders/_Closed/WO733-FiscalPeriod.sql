
SELECT DISTINCT FiscalPeriod, CASE FiscalMonth WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4)) END AS [Fiscal Month], 
CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt, 
CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt, 
CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) + '|' + CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMth 
--,CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2)
FROM FiscalCalendar 
WHERE (CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) = CurrentDt) OR
(CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalPeriodEndDt AND 
(CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt))
ORDER BY CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) DESC


SELECT DISTINCT FiscalPeriod, CASE FiscalMonth WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4)) END AS [Fiscal Month], CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt, CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt, CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) + '|' + CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMth FROM FiscalCalendar WHERE (CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) = CurrentDt) OR (CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalPeriodEndDt AND (CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt)) ORDER BY CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) DESC





SELECT CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) AS [Date], [Location Code], [Return Reason Code], COUNT([Return Reason Code]) AS [Record Count], SUM(ExtValue) AS ExtendedValue
FROM (SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_], [Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue
FROM [Porteous$Sales Cr_Memo Line]
WHERE (Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and ([Posting Date] BETWEEN CONVERT(DATETIME, '2008-03-02', 102) AND CONVERT(DATETIME, '2008-03-29', 102)) AND (Type = 2)) Reasons GROUP BY [Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) ORDER BY CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2), [Location Code], [Return Reason Code]





select * from FiscalCalendar where CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) = CurrentDt

 


 SELECT DISTINCT FiscalPeriod, CASE FiscalMonth WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4)) END AS [Fiscal Month], 
CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt, 
CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt, 
CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) + '|' + CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMth 
,CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2)
FROM FiscalCalendar 
where CurFiscalMthEndDt = '2007-05-26'

--select Getdate()-365


select * from FiscalCalendar where CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) = CurrentDt


where CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt





SELECT	DISTINCT
	FiscalPeriod,
	CASE FiscalMonth
		WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4))
		WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4))
	END AS [Fiscal Month],
	CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt,
	CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt
FROM	FiscalCalendar
WHERE	CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND
	CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalPeriodEndDt AND
	(CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR
	 CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt)
ORDER BY CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) DESC








SELECT DISTINCT
		CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2),
		FiscalPeriod,
		FiscalYear, Right('00'+FiscalMonth,2) AS FiscalMonth,
		CASE FiscalMonth
			WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4))
		END AS Month,
		CAST(FiscalYear AS VARCHAR(4)) + '/' + CAST(Right('00'+FiscalMonth,2) AS VARCHAR(2)) AS Period,
		CurFiscalMthBeginDt, CurFiscalMthEndDt,		CurFiscalPeriodBeginDt, CurFiscalPeriodEndDt
FROM         FiscalCalendar


WHERE		CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND
		CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalPeriodEndDt AND
		(CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR
		 CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt)

--WHERE     (CurFiscalPeriodBeginDt <= GETDATE()) AND (CurFiscalPeriodEndDt >= GETDATE())
--WHERE     (CurFiscalPeriodBeginDt >= GETDATE()-365) 
--AND (CurFiscalMthEndDt <= GETDATE())
order by CAST(FiscalYear AS VARCHAR(4)) + '/' + CAST(Right('00'+FiscalMonth,2) AS VARCHAR(2))




SELECT
CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2)
AS [Date]

CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2)






SELECT DISTINCT
		FiscalPeriod,
		CASE FiscalMonth
			WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4))
			WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4))
		END AS Month,
		CurFiscalMthBeginDt, CurFiscalMthEndDt
FROM         FiscalCalendar
WHERE     (CurFiscalPeriodBeginDt >= GETDATE()-365) AND (CurFiscalMthEndDt <= GETDATE())





