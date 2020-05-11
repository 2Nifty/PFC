

select GETDATE()-365


select DATEADD(YEAR, -1, GETDATE())


select	DATEADD(YEAR, -1, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)),
	CAST (FLOOR (CAST (GetDate() + 1 AS FLOAT)) AS DATETIME)

--last 3 closed months (Orig)
select	FC.FiscalCalYear * 100 + FiscalCalMonth as Fiscal,
	(DATEPART(yyyy,DATEADD(m,-3,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-3,GETDATE())) AS Beg3MoDate,
	(DATEPART(yyyy,DATEADD(m,-1,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-1,GETDATE())) AS End3MoDate
FROM FiscalCalendar FC
WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)


---------------------------------------------------------------------------------------------------------------

DECLARE	@BegDate DATETIME,
	@EndDate DATETIME

--last 3 closed months (FIX)
select	FC.FiscalCalYear * 100 + FiscalCalMonth as Fiscal,
	(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)) as FiscalDt,
	(DATEPART(yyyy,DATEADD(m,-3,(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-3,(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) AS Beg3MoDate,
	(DATEPART(yyyy,DATEADD(m,-1,(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) AS End3MoDate
FROM FiscalCalendar FC
WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

--Beg3MoDate
SELECT	DISTINCT
	@BegDate = CurFiscalMthBeginDt
FROM	FiscalCalendar
WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
	IN	
	(SELECT	(DATEPART(yyyy,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
	 FROM	FiscalCalendar
	 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

--End3MoDate
SELECT	DISTINCT
	@EndDate = CurFiscalMthEndDt
FROM	FiscalCalendar
WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
	IN
	(SELECT	(DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
	 FROM	FiscalCalendar
	 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))


SELECT	@BegDate as Beg3MoDate, @EndDate as End3MoDate



--last 12 closed months
select	FC.FiscalCalYear * 100 + FiscalCalMonth as Fiscal,
	(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)) as FiscalDt,
	(DATEPART(yyyy,DATEADD(m,-12,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS Beg12MoDate,
	(DATEPART(yyyy,DATEADD(m,-1,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS End12MoDate--,
--	(DATEPART(yyyy,DATEADD(m,-11,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-11,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS Beg12MoDateCurrent,
--	(DATEPART(yyyy,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME))) * 100) + DATEPART(m,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME))) AS End12MoDateCurrent
FROM FiscalCalendar FC
WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)



--Beg12MoDate
SELECT	DISTINCT
	@BegDate = CurFiscalMthBeginDt
	--CurFiscalMthBeginDt
FROM	FiscalCalendar
WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
	IN
	(SELECT	(DATEPART(yyyy,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
	 FROM	FiscalCalendar
	 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

--End12MoDate
SELECT	DISTINCT
	@EndDate = CurFiscalMthEndDt
	--CurFiscalMthBeginDt
FROM	FiscalCalendar
WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
	IN
	(SELECT	(DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
	 FROM	FiscalCalendar
	 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))


SELECT	@BegDate as Beg12MoDate, @EndDate as End12MoDate





----------------------------------------------------------------------------------------------------------------------


--last 12 closed months
select	FC.FiscalCalYear * 100 + FiscalCalMonth as Fiscal,
	(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)) as FiscalDt,
	(DATEPART(yyyy,DATEADD(m,-12,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS Beg12MoDate,
	(DATEPART(yyyy,DATEADD(m,-1,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS End12MoDate,
	(DATEPART(yyyy,DATEADD(m,-11,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) * 100) + DATEPART(m,DATEADD(m,-11,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME)))) AS Beg12MoDateCurrent,
	(DATEPART(yyyy,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME))) * 100) + DATEPART(m,(CAST(CAST(((FC.FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)) as DATETIME))) AS End12MoDateCurrent
FROM FiscalCalendar FC
WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)




select * from FiscalCalendar
exec sp_columns FiscalCalendar



----------------------------------------------------------------------------------------------------


DECLARE	@BegDate DATETIME,
	@EndDate DATETIME

SET	@BegDate = DATEADD(YEAR, -1, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))
SET	@EndDate = CAST (FLOOR (CAST (GetDate() + 1 AS FLOAT)) AS DATETIME)
--SELECT	@BegDate, @EndDate


SELECT	CatNo,
	isnull(TotSales,0) AS Sales,
	isnull(TotCost,0) AS Cost,
	isnull(TotMgn,0) AS Mgn,
	isnull(TotMgnPct,0) * 100 AS MgnPct
FROM	(SELECT	LEFT(ItemNo, 5) AS Category,
		SUM(NetUnitPrice * QtyShipped) AS TotSales,
		SUM(UnitCost * QtyShipped) AS TotCost,
		SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
		CASE SUM(NetUnitPrice * QtyShipped)
		   WHEN 0 THEN 0
			  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
		END AS TotMgnPct
	 FROM	SOHeaderHist (NoLock) INNER JOIN
		SODetailHist (NoLock)
	 ON	pSOHeaderHistID = fSOHeaderHistID 
	 WHERE	ARPostDt BETWEEN @BegDate AND @EndDate
	 GROUP BY LEFT(ItemNo, 5)) Hist RIGHT OUTER JOIN
	(SELECT	DISTINCT ListValue AS CatNo
	 FROM	ListMaster (NoLock) INNER JOIN
		ListDetail (NoLock)
	 ON	pListMasterID = fListMasterId
	 WHERE	ListName = 'CategoryDesc') CatList
ON	Category = CatNo
ORDER BY CatNo




----------------------------------------------------------------------------------------------------


SELECT	CatNo AS Category,
	SUM(isnull(NetUnitPrice,0) * isnull(QtyShipped,0)) AS TotSales,
	SUM(isnull(UnitCost,0) * isnull(QtyShipped,0)) AS TotCost,
	SUM(isnull(NetUnitPrice,0) * isnull(QtyShipped,0)) - SUM(isnull(UnitCost,0) * isnull(QtyShipped,0)) AS TotMgn,
	CASE SUM(isnull(NetUnitPrice,0) * isnull(QtyShipped,0))
	   WHEN 0 THEN 0
		  ELSE (SUM(isnull(NetUnitPrice,0) * isnull(QtyShipped,0)) - SUM(isnull(UnitCost,0) * isnull(QtyShipped,0))) / SUM(isnull(NetUnitPrice,0) * isnull(QtyShipped,0))
	END AS TotMgnPct
FROM

(


SELECT	distinct CatNo--,
--	ARPostDt,
--	NetUnitPrice,
--	QtyShipped,
--	UnitCost
FROM	SOHeaderHist (NoLock) INNER JOIN
	SODetailHist (NoLock)
ON	pSOHeaderHistID = fSOHeaderHistID RIGHT OUTER JOIN
	(SELECT	DISTINCT ListValue AS CatNo
	 FROM	ListMaster (NoLock) INNER JOIN
		ListDetail (NoLock)
	 ON	pListMasterID = fListMasterId
	 WHERE	ListName = 'CategoryDesc') CatList
ON	LEFT(ItemNo, 5) = CatNo

) Hist

WHERE	ARPostDt BETWEEN @BegDate AND @EndDate
GROUP BY CatNo
ORDER BY CatNo



----------------------------------------------------------------------------------------------------


SELECT	CatNo AS Category,
	SUM(NetUnitPrice * QtyShipped) AS TotSales,
	SUM(UnitCost * QtyShipped) AS TotCost,
	SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
	CASE SUM(NetUnitPrice * QtyShipped)
	   WHEN 0 THEN 0
		  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
	END AS TotMgnPct
FROM	SOHeaderHist (NoLock) INNER JOIN
	SODetailHist (NoLock)
ON	pSOHeaderHistID = fSOHeaderHistID RIGHT OUTER JOIN

	(SELECT	DISTINCT ListValue AS CatNo
	 FROM	ListMaster (NoLock) INNER JOIN
		ListDetail (NoLock)
	 ON	pListMasterID = fListMasterId
	 WHERE	ListName = 'CategoryDesc') CatList
ON	LEFT(ItemNo, 5) = CatNo
WHERE	ARPostDt BETWEEN @BegDate AND @EndDate
GROUP BY CatNo
ORDER BY CatNo



----------------------------------------------------------------------------------------------------

SELECT	DISTINCT ListValue AS CatNo
FROM	ListMaster (NoLock) INNER JOIN
	ListDetail (NoLock)
ON	pListMasterID = fListMasterId
WHERE	ListName = 'CategoryDesc'