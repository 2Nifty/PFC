if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tDashBoardBudget') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tDashBoardBudget

DECLARE @@StartPer VARCHAR(10)
SET @@StartPer='200809'

SELECT
	Location, Customer AS CustChain, OrderType,
	REPLICATE('0',5-LEN(CatgrpNo))+CAST(CatGrpNo AS varchar(10)) AS Category,
--1st Quarter
	isNULL(Q1ForecastLbs,0) AS Q1ForecastLbs,
	CASE isNULL(Q1ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ForecastLbs / 13) * 4
	   END AS SepForecastLbs,
	CASE isNULL(Q1ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ForecastLbs / 13) * 5
	   END AS OctForecastLbs,
	CASE isNULL(Q1ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ForecastLbs / 13) * 4
	   END AS NovForecastLbs,
--2nd Quarter
	isNULL(Q2ForecastLbs,0) AS Q2ForecastLbs,
	CASE isNULL(Q2ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ForecastLbs / 13) * 4
	   END AS DecForecastLbs,
	CASE isNULL(Q2ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ForecastLbs / 13) * 5
	   END AS JanForecastLbs,
	CASE isNULL(Q2ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ForecastLbs / 13) * 4
	   END AS FebForecastLbs,
--3rd Quarter
	isNULL(Q3ForecastLbs,0) AS Q3ForecastLbs,
	CASE isNULL(Q3ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ForecastLbs / 13) * 4
	   END AS MarForecastLbs,
	CASE isNULL(Q3ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ForecastLbs / 13) * 5
	   END AS AprForecastLbs,
	CASE isNULL(Q3ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ForecastLbs / 13) * 4
	   END AS MayForecastLbs,
--4th Quarter
	isNULL(Q4ForecastLbs,0) AS Q4ForecastLbs,
	CASE isNULL(Q4ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ForecastLbs / 13) * 4
	   END AS JunForecastLbs,
	CASE isNULL(Q4ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ForecastLbs / 13) * 5
	   END AS JulForecastLbs,
	CASE isNULL(Q4ForecastLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ForecastLbs / 13) * 4
	   END AS AugForecastLbs,
	Summ.*, DashBoard.*
INTO 	tDashBoardBudget
FROM	SalesForecastPounds
INNER JOIN
(SELECT	Location AS SummLoc,
 --1st Quarter
	SUM(isNULL(Q1ForecastLbs,0)) AS Q1ForecastLbsSUMM,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 4)
	   END AS SepForecastLbsSUMM,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 5)
	   END AS OctForecastLbsSUMM,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 4)
	   END AS NovForecastLbsSUMM,
 --2nd Quarter
	SUM(isNULL(Q2ForecastLbs,0)) AS Q2ForecastLbsSUMM,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 4)
	   END AS DecForecastLbsSUMM,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 5)
	   END AS JanForecastLbsSUMM,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 4)
	   END AS FebForecastLbsSUMM,
 --3rd Quarter
	SUM(isNULL(Q3ForecastLbs,0)) AS Q3ForecastLbsSUMM,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 4)
	   END AS MarForecastLbsSUMM,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 5)
	   END AS AprForecastLbsSUMM,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 4)
	   END AS MayForecastLbsSUMM,
 --4th Quarter
	SUM(isNULL(Q4ForecastLbs,0)) AS Q4ForecastLbsSUMM,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 4)
	   END AS JunForecastLbsSUMM,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 5)
	   END AS JulForecastLbsSUMM,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 4)
	   END AS AugForecastLbsSUMM
FROM	SalesForecastPounds
GROUP BY Location) Summ
ON	Location=SummLoc
INNER JOIN
(SELECT	Loc_No, CurYear * 100 + CurMonth AS Period, CurMonth,
	BUD_LbsShipped AS Lbs, BUD_SalesDollar AS SalesDollars, 
	BUD_GrossMarginDollar AS MgnDollars, BUDBrnExp AS Expense
FROM	DashBoardBudgets
WHERE	(CurYear * 100 + CurMonth >= @@StartPer)) DashBoard
ON	Location=Loc_No


SELECT	Location, CustChain, Category, OrderType, Period,
	CASE CurMonth
	   WHEN '09' THEN 1
	   WHEN '10' THEN 2
	   WHEN '11' THEN 3
	   WHEN '12' THEN 4
	   WHEN '01' THEN 5
	   WHEN '02' THEN 6
	   WHEN '03' THEN 7
	   WHEN '04' THEN 8
	   WHEN '05' THEN 9
	   WHEN '06' THEN 10
	   WHEN '07' THEN 11
	   WHEN '08' THEN 12
	END AS FiscalPeriod,
	CASE CurMonth
	   WHEN '09' THEN CASE SepForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (SepForecastLbs / SepForecastLbsSUMM) END
	   WHEN '10' THEN CASE OctForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (OctForecastLbs / OctForecastLbsSUMM) END
	   WHEN '11' THEN CASE NovForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (NovForecastLbs / NovForecastLbsSUMM) END
	   WHEN '12' THEN CASE DecForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (DecForecastLbs / DecForecastLbsSUMM) END
	   WHEN '01' THEN CASE JanForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (JanForecastLbs / JanForecastLbsSUMM) END
	   WHEN '02' THEN CASE FebForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (FebForecastLbs / FebForecastLbsSUMM) END
	   WHEN '03' THEN CASE MarForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (MarForecastLbs / MarForecastLbsSUMM) END
	   WHEN '04' THEN CASE AprForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (AprForecastLbs / AprForecastLbsSUMM) END
	   WHEN '05' THEN CASE MayForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (MayForecastLbs / MayForecastLbsSUMM) END
	   WHEN '06' THEN CASE JunForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (JunForecastLbs / JunForecastLbsSUMM) END
	   WHEN '07' THEN CASE JulForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (JulForecastLbs / JulForecastLbsSUMM) END
	   WHEN '08' THEN CASE AugForecastLbsSUMM WHEN 0 THEN 0 ELSE Lbs * (AugForecastLbs / AugForecastLbsSUMM) END
	END AS Lbs,
	CASE CurMonth
	   WHEN '09' THEN CASE SepForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (SepForecastLbs / SepForecastLbsSUMM) END
	   WHEN '10' THEN CASE OctForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (OctForecastLbs / OctForecastLbsSUMM) END
	   WHEN '11' THEN CASE NovForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (NovForecastLbs / NovForecastLbsSUMM) END
	   WHEN '12' THEN CASE DecForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (DecForecastLbs / DecForecastLbsSUMM) END
	   WHEN '01' THEN CASE JanForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (JanForecastLbs / JanForecastLbsSUMM) END
	   WHEN '02' THEN CASE FebForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (FebForecastLbs / FebForecastLbsSUMM) END
	   WHEN '03' THEN CASE MarForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (MarForecastLbs / MarForecastLbsSUMM) END
	   WHEN '04' THEN CASE AprForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (AprForecastLbs / AprForecastLbsSUMM) END
	   WHEN '05' THEN CASE MayForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (MayForecastLbs / MayForecastLbsSUMM) END
	   WHEN '06' THEN CASE JunForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (JunForecastLbs / JunForecastLbsSUMM) END
	   WHEN '07' THEN CASE JulForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (JulForecastLbs / JulForecastLbsSUMM) END
	   WHEN '08' THEN CASE AugForecastLbsSUMM WHEN 0 THEN 0 ELSE SalesDollars * (AugForecastLbs / AugForecastLbsSUMM) END
	END AS SalesDollars,
	CASE CurMonth
	   WHEN '09' THEN CASE SepForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (SepForecastLbs / SepForecastLbsSUMM) END
	   WHEN '10' THEN CASE OctForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (OctForecastLbs / OctForecastLbsSUMM) END
	   WHEN '11' THEN CASE NovForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (NovForecastLbs / NovForecastLbsSUMM) END
	   WHEN '12' THEN CASE DecForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (DecForecastLbs / DecForecastLbsSUMM) END
	   WHEN '01' THEN CASE JanForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (JanForecastLbs / JanForecastLbsSUMM) END
	   WHEN '02' THEN CASE FebForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (FebForecastLbs / FebForecastLbsSUMM) END
	   WHEN '03' THEN CASE MarForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (MarForecastLbs / MarForecastLbsSUMM) END
	   WHEN '04' THEN CASE AprForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (AprForecastLbs / AprForecastLbsSUMM) END
	   WHEN '05' THEN CASE MayForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (MayForecastLbs / MayForecastLbsSUMM) END
	   WHEN '06' THEN CASE JunForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (JunForecastLbs / JunForecastLbsSUMM) END
	   WHEN '07' THEN CASE JulForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (JulForecastLbs / JulForecastLbsSUMM) END
	   WHEN '08' THEN CASE AugForecastLbsSUMM WHEN 0 THEN 0 ELSE MgnDollars * (AugForecastLbs / AugForecastLbsSUMM) END
	END AS MgnDollars,
	CASE CurMonth
	   WHEN '09' THEN CASE SepForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (SepForecastLbs / SepForecastLbsSUMM) END
	   WHEN '10' THEN CASE OctForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (OctForecastLbs / OctForecastLbsSUMM) END
	   WHEN '11' THEN CASE NovForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (NovForecastLbs / NovForecastLbsSUMM) END
	   WHEN '12' THEN CASE DecForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (DecForecastLbs / DecForecastLbsSUMM) END
	   WHEN '01' THEN CASE JanForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (JanForecastLbs / JanForecastLbsSUMM) END
	   WHEN '02' THEN CASE FebForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (FebForecastLbs / FebForecastLbsSUMM) END
	   WHEN '03' THEN CASE MarForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (MarForecastLbs / MarForecastLbsSUMM) END
	   WHEN '04' THEN CASE AprForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (AprForecastLbs / AprForecastLbsSUMM) END
	   WHEN '05' THEN CASE MayForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (MayForecastLbs / MayForecastLbsSUMM) END
	   WHEN '06' THEN CASE JunForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (JunForecastLbs / JunForecastLbsSUMM) END
	   WHEN '07' THEN CASE JulForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (JulForecastLbs / JulForecastLbsSUMM) END
	   WHEN '08' THEN CASE AugForecastLbsSUMM WHEN 0 THEN 0 ELSE Expense * (AugForecastLbs / AugForecastLbsSUMM) END
	END AS Expense, 'NVLUNIGHT' AS EntryID, GETDATE() AS EntryDt
--INTO	CustCatBudget
FROM	tDashBoardBudget
ORDER BY Location, CustChain, Category, Period

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tDashBoardBudget') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tDashBoardBudget