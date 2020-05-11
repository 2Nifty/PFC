

SELECT	Location, Customer AS CustChain,
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
	   END AS ArpForecastLbs,
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
	   END AS AugForecastLbs
FROM	SalesForecastPounds
ORDER BY Location, CustChain, Category







SELECT	Location,

	--1st Quarter
	SUM(isNULL(Q1ForecastLbs,0)) AS Q1ForecastLbs,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 4)
	   END AS SepForecastLbs,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 5)
	   END AS OctForecastLbs,
	CASE SUM(isNULL(Q1ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q1ForecastLbs / 13) * 4)
	   END AS NovForecastLbs,

	--2nd Quarter
	SUM(isNULL(Q2ForecastLbs,0)) AS Q2ForecastLbs,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 4)
	   END AS DecForecastLbs,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 5)
	   END AS JanForecastLbs,
	CASE SUM(isNULL(Q2ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q2ForecastLbs / 13) * 4)
	   END AS FebForecastLbs,

	--3rd Quarter
	SUM(isNULL(Q3ForecastLbs,0)) AS Q3ForecastLbs,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 4)
	   END AS MarForecastLbs,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 5)
	   END AS ArpForecastLbs,
	CASE SUM(isNULL(Q3ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q3ForecastLbs / 13) * 4)
	   END AS MayForecastLbs,

	--4th Quarter
	SUM(isNULL(Q4ForecastLbs,0)) AS Q4ForecastLbs,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 4)
	   END AS JunForecastLbs,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 5)
	   END AS JulForecastLbs,
	CASE SUM(isNULL(Q4ForecastLbs,0))
	   WHEN 0 THEN 0
		  ELSE SUM((Q4ForecastLbs / 13) * 4)
	   END AS AugForecastLbs
FROM	SalesForecastPounds
GROUP BY Location
--Order By Location