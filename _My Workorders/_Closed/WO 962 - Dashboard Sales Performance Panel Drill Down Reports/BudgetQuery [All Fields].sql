
DECLARE @@StartPer VARCHAR(10)
SET @@StartPer='200809'

SELECT
	Location, Customer AS CustChain, CustomerName AS CustName, OrderType,
	REPLICATE('0',5-LEN(CatgrpNo))+CAST(CatGrpNo AS varchar(10)) AS Category, CatGrpDesc AS CatDesc,
	AcceptedDt,
--1st Quarter Actual
	isNULL(Q1ActualLbs,0) AS Q1ActualLbs,
	CASE isNULL(Q1ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ActualLbs / 13) * 4
	   END AS SepActualLbs,
	CASE isNULL(Q1ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ActualLbs / 13) * 5
	   END AS OctActualLbs,
	CASE isNULL(Q1ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q1ActualLbs / 13) * 4
	   END AS NovActualLbs,
--1st Quarter Forecast
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
--2nd Quarter Actual
	isNULL(Q2ActualLbs,0) AS Q2ActualLbs,
	CASE isNULL(Q2ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ActualLbs / 13) * 4
	   END AS DecActualLbs,
	CASE isNULL(Q2ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ActualLbs / 13) * 5
	   END AS JanActualLbs,
	CASE isNULL(Q2ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q2ActualLbs / 13) * 4
	   END AS FebActualLbs,
--2nd Quarter Forecast
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
--3rd Quarter Actual
	isNULL(Q3ActualLbs,0) AS Q3ActualLbs,
	CASE isNULL(Q3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ActualLbs / 13) * 4
	   END AS MarActualLbs,
	CASE isNULL(Q3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ActualLbs / 13) * 5
	   END AS AprActualLbs,
	CASE isNULL(Q3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q3ActualLbs / 13) * 4
	   END AS MayActualLbs,
--3rd Quarter Forecast
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
--4th Quarter Actual
	isNULL(Q4ActualLbs,0) AS Q4ActualLbs,
	CASE isNULL(Q4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ActualLbs / 13) * 4
	   END AS JunActualLbs,
	CASE isNULL(Q4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ActualLbs / 13) * 5
	   END AS JulActualLbs,
	CASE isNULL(Q4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (Q4ActualLbs / 13) * 4
	   END AS AugActualLbs,
--3rd Quarter Last Year
	isNULL(LYQ3ActualLbs,0) AS LYQ3ActualLbs,
	CASE isNULL(LYQ3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ3ActualLbs / 13) * 4
	   END AS LYMarActualLbs,
	CASE isNULL(LYQ3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ3ActualLbs / 13) * 5
	   END AS LYAprActualLbs,
	CASE isNULL(LYQ3ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ3ActualLbs / 13) * 4
	   END AS LYMayActualLbs,
--4th Quarter Forecast
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
--4th Quarter Last Year
	isNULL(LYQ4ActualLbs,0) AS LYQ4ActualLbs,
	CASE isNULL(LYQ4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ4ActualLbs / 13) * 4
	   END AS LYJunActualLbs,
	CASE isNULL(LYQ4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ4ActualLbs / 13) * 5
	   END AS LYJulActualLbs,
	CASE isNULL(LYQ4ActualLbs,0)
	   WHEN 0 THEN 0
		  ELSE (LYQ4ActualLbs / 13) * 4
	   END AS LYAugActualLbs,
	ProcessStartDt, ProcessEndDt, Summ.*, DashBoard.*
INTO 	#tempBudget
FROM	SalesForecastPounds
INNER JOIN
(SELECT	Location AS SummLoc,
 --1st Quarter Actual
	SUM(isNULL(Q1ActualLbs,0)) AS Q1ActualLbsSUMM,
	CASE SUM(isNULL(Q1ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ActualLbs / 13) * 4)
	   END AS SepActualLbsSUMM,
	CASE SUM(isNULL(Q1ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ActualLbs / 13) * 5)
	   END AS OctActualLbsSUMM,
	CASE SUM(isNULL(Q1ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ActualLbs / 13) * 4)
	   END AS NovActualLbsSUMM,
 --1st Quarter Forecast
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
 --2nd Quarter Actual
	SUM(isNULL(Q2ActualLbs,0)) AS Q2ActualLbsSUMM,
	CASE SUM(isNULL(Q2ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ActualLbs / 13) * 4)
	   END AS DecActualLbsSUMM,
	CASE SUM(isNULL(Q2ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ActualLbs / 13) * 5)
	   END AS JanActualLbsSUMM,
	CASE SUM(isNULL(Q2ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ActualLbs / 13) * 4)
	   END AS FebActualLbsSUMM,
 --2nd Quarter Forecast
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
 --3rd Quarter Actual
	SUM(isNULL(Q3ActualLbs,0)) AS Q3ActualLbsSUMM,
	CASE SUM(isNULL(Q3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ActualLbs / 13) * 4)
	   END AS MarActualLbsSUMM,
	CASE SUM(isNULL(Q3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ActualLbs / 13) * 5)
	   END AS AprActualLbsSUMM,
	CASE SUM(isNULL(Q3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ActualLbs / 13) * 4)
	   END AS MayActualLbsSUMM,
 --3rd Quarter Forecast
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
 --3rd Quarter Last Year
	SUM(isNULL(LYQ3ActualLbs,0)) AS LYQ3ActualLbsSUMM,
	CASE SUM(isNULL(LYQ3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ3ActualLbs / 13) * 4)
	   END AS LYMarActualLbsSUMM,
	CASE SUM(isNULL(LYQ3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ3ActualLbs / 13) * 5)
	   END AS LYAprActualLbsSUMM,
	CASE SUM(isNULL(LYQ3ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ3ActualLbs / 13) * 4)
	   END AS LYMayActualLbsSUMM,
 --4th Quarter Actual
	SUM(isNULL(Q4ActualLbs,0)) AS Q4ActualLbsSUMM,
	CASE SUM(isNULL(Q4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ActualLbs / 13) * 4)
	   END AS JunActualLbsSUMM,
	CASE SUM(isNULL(Q4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ActualLbs / 13) * 5)
	   END AS JulActualLbsSUMM,
	CASE SUM(isNULL(Q4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ActualLbs / 13) * 4)
	   END AS AugActualLbsSUMM,
 --4th Quarter Forecast
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
	   END AS AugForecastLbsSUMM,
 --4th Quarter Last Year
	SUM(isNULL(LYQ4ActualLbs,0)) AS LYQ4ActualLbsSUMM,
	CASE SUM(isNULL(LYQ4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ4ActualLbs / 13) * 4)
	   END AS LYJunActualLbsSUMM,
	CASE SUM(isNULL(LYQ4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ4ActualLbs / 13) * 5)
	   END AS LYJulActualLbsSUMM,
	CASE SUM(isNULL(LYQ4ActualLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((LYQ4ActualLbs / 13) * 4)
	   END AS LYAugActualLbsSUMM
FROM	SalesForecastPounds
GROUP BY Location) Summ
ON	Location=SummLoc
INNER JOIN
(SELECT	Loc_No, CurYear * 100 + CurMonth AS Period, CurMonth,
	BUD_GrossMarginDollar AS MgnDollars, BUD_GrossMarginPct AS MgnPct,
	BUD_SalesDollar AS SalesDollars, BUD_OrderCount AS OrderCount,
	BUD_LineCount AS LineCount, BUD_LbsShipped AS Lbs,
	BUD_PricePerLb AS PricePerLb, BUD_GMPerLb AS MgnPerLb, BUDBrnExp AS Expense
FROM	DashBoardBudgets
WHERE	(CurYear * 100 + CurMonth >= @@StartPer)) DashBoard
ON	Location=Loc_No


SELECT	Location, CustChain, Category, Period,
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
	END AS Expense
--INTO	CustCatBudget
FROM	#tempBudget
ORDER BY Location, CustChain, Category, Period

drop table #tempBudget