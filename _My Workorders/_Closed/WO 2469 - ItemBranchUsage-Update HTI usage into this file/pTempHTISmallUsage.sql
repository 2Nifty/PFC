
HITUsageSm11


DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 11
SET	@BegPer = '201005'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm11
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 10
SET	@BegPer = '201006'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm10
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 9
SET	@BegPer = '201007'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm09
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 8
SET	@BegPer = '201008'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm08
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 7
SET	@BegPer = '201009'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm07
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 6
SET	@BegPer = '201010'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm06
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 5
SET	@BegPer = '201011'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm05
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 4
SET	@BegPer = '201012'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm04
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 3
SET	@BegPer = '201101'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm03
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 2
SET	@BegPer = '201102'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm02
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

DECLARE @NoOfPer int,
	@BegPer varchar(6),
	@EndPer varchar(6)

SET	@NoOfPer = 1
SET	@BegPer = '201103'	--number of periods back based on NoOfPer (12mo = 201004)
SET	@EndPer = '201103'	--constant


SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
--	ceiling(isnull(Usage.NoOfSales,0) * isnull(Weeks,4)) as NoOfSales,
--	ceiling(isnull(Usage.SalesQty,0) * isnull(Weeks,4)) as SalesQty,
--	isnull(Usage.NoOfSales,0) * isnull(Weeks,4) as NoOfSalesRaw,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0)
	END as NoOfSales,
	CASE WHEN ROUND(isnull(Usage.NoOfSales,0) * isnull(Weeks,4),0) < 1
	     THEN 1
	     ELSE ROUND(isnull(Usage.SalesQty,0) * isnull(Weeks,4),0)
	END as SalesQty,
	ROUND((isnull(Usage.SalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	0 as SalesWght,
	ROUND((isnull(Usage.CostDol,0) * isnull(Weeks,4)),2) as CostDol
--INTO	#tHITUsageSm01
--select * 
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= @BegPer AND 
			FiscalCalYear * 100 + FiscalCalMonth <= @EndPer) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	Location,
		ItemNo,
		(isnull(CartonQty,0)) / @NoOfPer as NoOfSales,
		(isnull(CartonQty,0)) / @NoOfPer as SalesQty,
		(isnull(SalesDol,0)) / @NoOfPer as SalesDol,
		(isnull(CostDol,0)) / @NoOfPer as CostDol

--		(isnull(CartonQty,0)) as NoOfSales,
--		(isnull(CartonQty,0)) as SalesQty,
--		(isnull(SalesDol,0)) as SalesDol,
--		(isnull(CostDol,0)) as CostDol
	 FROM	tWO2469_HTIUsageSm
	)Usage

-----------------------------------------------------------------------------------------------------------------

SELECT * FROM #tHITUsageSm01 UNION
SELECT * FROM #tHITUsageSm02 UNION
SELECT * FROM #tHITUsageSm03 UNION
SELECT * FROM #tHITUsageSm04 UNION
SELECT * FROM #tHITUsageSm05 UNION
SELECT * FROM #tHITUsageSm06 UNION
SELECT * FROM #tHITUsageSm07 UNION
SELECT * FROM #tHITUsageSm08 UNION
SELECT * FROM #tHITUsageSm09 UNION
SELECT * FROM #tHITUsageSm10 UNION
SELECT * FROM #tHITUsageSm11

