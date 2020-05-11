
select * from tWO2469_HTIUsageSm


UPDATE	tWO2469_HTIUsageSm
SET	CartonQty = CASE WHEN ROUND(isnull(CartonQty,0),0) < 1
	     		 THEN 1
	     		 ELSE ROUND(isnull(CartonQty,0),0)
		    END



select	CartonQty,
	CASE WHEN ROUND(isnull(Usage.CartonQty,0),0) < 1
	     		 THEN 1
	     		 ELSE ROUND(isnull(Usage.CartonQty,0),0)
		    END as CartonQtyRnd

from	tWO2469_HTIUsageSm Usage


-----------------------------------------------------------------------------------------


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

--select distinct CartonQty
--select *
	 FROM	tWO2469_HTIUsageSm
	 WHERE	(isnull(CartonQty,0)) = @NoOfPer
--order by CartonQty

	)Usage



