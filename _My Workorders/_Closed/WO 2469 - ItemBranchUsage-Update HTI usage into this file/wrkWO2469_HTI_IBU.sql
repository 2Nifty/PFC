select * from tWO2469_HTIUsage





DECLARE	@Period varchar(6),
	@Weeks integer


DECLARE c1 CURSOR READ_ONLY FOR
	SELECT	Period, count(*)
	FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= 201004 AND 
			FiscalCalYear * 100 + FiscalCalMonth <= 201103) tmp
	group by Period
	order by Period


OPEN c1

FETCH NEXT FROM c1 INTO @Period, @Weeks

WHILE @@FETCH_STATUS = 0
   BEGIN
	--select @Period as Period, @Weeks as Weeks

	INSERT
	INTO	tWO2469_HTI_IBU
		(Location,
		 ItemNo,
		 Period,
		 NoOfSales,
		 SalesQty,
		 SalesDol,
		 SalesWght,
		 CostDol)


	SELECT	HTILoc as Location,
		PFCItem as ItemNo,
		@Period as Period,
		isnull(HTIWkCartonQty,0) * @Weeks as NoOfSales,
		isnull(HTIWkCartonQty,0) * @Weeks as SalesQty,
		isnull(HTIWkSalesDol,0) * @Weeks as SalesDol,
		isnull(HTIWkNetWght,0) * @Weeks as SalesWght,
		isnull(HTIWkCostDol,0) * @Weeks as CostDol
	FROM	tWO2469_HTIUsage
	WHERE	PFCItemFlg='Y'
   END

CLOSE c1
DEALLOCATE c1

go
