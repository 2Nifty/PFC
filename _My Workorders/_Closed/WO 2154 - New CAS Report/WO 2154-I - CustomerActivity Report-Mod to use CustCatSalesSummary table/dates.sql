--select * from CustCatSalesSummary

--select * from Dashboardranges

--select * from FiscalCalendar


DECLARE	@Period	varchar(6),
		@CustNo	varchar(6),
		@BegCurDt datetime,
		@EndCurDt datetime,
		@BegLastDt datetime,
		@EndLastDt datetime,
		@BegPrevDt datetime,
		@EndPrevDt datetime,
		@BegCurYTD datetime,
		@EndCurYTD datetime,
		@BegCurMTD datetime,
		@EndCurMTD datetime,
		@LastPeriod varchar(6),
		@LastYTD varchar(4),
		@BegLastYTD datetime,
		@EndLastYTD datetime,
		@PrevPeriod varchar(6),
		@PrevYTD varchar(4),
		@BegPrevYTD datetime,
		@EndPrevYTD datetime,
		@LastFiscalMthBeginDt datetime,
		@LastFiscalMthEndDt datetime,
		@CuvnalYearMo varchar(6),
		@CuvnalYearMo12 varchar(6),
		@CuvSales decimal(13,4),
		@SQL nvarchar(4000)


declare @YTDPer varchar(6),
		@BegLastYTDPer varchar(6),
		@EndLastYTDPer varchar(6),
		@BegPrevYTDPer varchar(6),
		@EndPrevYTDPer varchar(6)

set @Period='201106'
set @CustNo='028745'

	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurDt = CurFiscalMthBeginDt,
			@EndCurDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
	select @Period as Period, @BegCurDt as BegCurDt, @EndCurDt as EndCurDt

	SELECT	@BegLastDt = CurFiscalMthBeginDt,
			@EndLastDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
	select @LastPeriod as LastPeriod, @BegLastDt as BegLastDt, @EndLastDt as EndLastDt

	SELECT	@BegPrevDt = CurFiscalMthBeginDt,
			@EndPrevDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
	select @PrevPeriod as PrevPeriod, @BegPrevDt as BegPrevDt, @EndPrevDt as EndPrevDt

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurDt,
			@BegCurMTD = @BegCurDt,
			@EndCurMTD = @EndCurDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurDt
	select @Period as MTDPer, @BegCurMTD as BegCurMTD, @EndCurMTD as EndCurMTD

	SELECT	@YTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegCurYTD
	select @YTDPer as BegYTDPer, @BegCurYTD as BegCurYTD, @EndCurYTD as EndCurYTD, @Period as EndYTDPer





	--SET Last Year's Fiscal
	SELECT	@LastYTD = FiscalYear,
			@BegLastYTD = CurFiscalYearBeginDt,
			@EndLastYTD = @EndLastDt,
			@EndLastYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndLastDt

	SELECT	@BegLastYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegLastYTD
	select @LastYTD as LastYTD, @BegLastYTDPer as BegLastYTDPer, @BegLastYTD as BegLastYTD, @EndLastYTD as EndLastYTD, @EndLastYTDPer as EndLastYTDPer




	--SET 2 Years Previous Fiscal
	SELECT	@PrevYTD = FiscalYear,
			@BegPrevYTD = CurFiscalYearBeginDt,
			@EndPrevYTD = @EndPrevDt,
			@EndPrevYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndPrevDt

	SELECT	@BegPrevYTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegPrevYTD
	select @PrevYTD as PrevYTD, @BegPrevYTDPer as BegPrevYTDPer, @BegPrevYTD as BegPrevYTD, @EndPrevYTD as EndPrevYTD, @EndPrevYTDPer as EndPrevYTDPer





	--SET Cuvnal Dates (@CuvnalYearMo12 & @CuvnalYearMo)
	SELECT @LastFiscalMthBeginDt = LastFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	SELECT @LastFiscalMthEndDt = LastFiscalMthEndDt FROM FiscalCalendar WHERE CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)

	SELECT	@CuvnalYearMo12 = tmp.CuvnalYearMo12
	FROM	(SELECT	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalYearMo12
			 FROM	FiscalCalendar
			 WHERE	CurFiscalMthBeginDt = @LastFiscalMthBeginDt and CurFiscalMthEndDt = @LastFiscalMthEndDt
			 ORDER BY CurrentDt DESC) tmp

	SELECT	@CuvnalYearMo = tmp.CuvnalYearMo
	FROM	(SELECT	TOP 1 CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as CuvnalYearMo
			 FROM 	FiscalCalendar
			 WHERE	CurFiscalMthEndDt <= CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
			 ORDER BY CurrentDt DESC) tmp
	select @LastFiscalMthBeginDt as LastFiscalMthBeginDt, @LastFiscalMthEndDt as LastFiscalMthEndDt, @CuvnalYearMo12 as CuvnalYearMo12, @CuvnalYearMo as CuvnalYearMo


---------------------------------------------------------------------


	--#tCatList: Load Categories
	SELECT	tCatList.CatNo,
			tCatList.CatDesc,
			BuyGrp.GroupNo as BuyGroupNo,
			BuyGrp.Description as BuyGroupDesc
	INTO	#tCatList
	FROM	(SELECT	LD.ListValue as CatNo,
					LD.ListDtlDesc as CatDesc
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListMaster] LM INNER JOIN
					OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListDetail] LD
			 ON		LM.pListMasterID = LD.fListMasterID
			 WHERE	LM.ListName = 'CategoryDesc') tCatList LEFT OUTER JOIN
			CAS_CatGrpDesc BuyGrp (NoLock)
	ON		tCatList.CatNo = BuyGrp.Category



	--#tCurYTD: Current Year To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesCurYTD,
			SUM(isnull(CCSS.SalesCost,0)) as CostCurYTD,
--			SUM(isnull(CCSS.AvgCost,0)) as AvgCostCurYTD,
--			SUM(isnull(CCSS.PriceCost,0)) as PriceCostCurYTD,
			SUM(isnull(CCSS.TotalWeight,0)) as WghtCurYTD,
			SUM((isnull(CCSS.SalesDollars,0)) - (isnull(CCSS.SalesCost,0))) as GMDlrCurYTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.AvgCost,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as AvgGMPctYTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.PriceCost,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as PriceGMPctYTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(CCSS.SalesDollars,0)) / SUM(isnull(CCSS.TotalWeight,0))
			END as DlrPerLbCurYTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.SalesCost,0))) / SUM(isnull(CCSS.TotalWeight,0))
			END as GMPerLbCurYTD
	--INTO	#tCurYTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo BETWEEN @YTDPer and @Period
	GROUP BY CCSS.Category

	--#tCurMTD: Current Month To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesCurMTD,
			SUM(isnull(CCSS.SalesCost,0)) as CostCurMTD,
--			SUM(isnull(CCSS.AvgCost,0)) as AvgCostCurMTD,
--			SUM(isnull(CCSS.PriceCost,0)) as PriceCostCurMTD,
			SUM(isnull(CCSS.TotalWeight,0)) as WghtCurMTD,
			SUM((isnull(CCSS.SalesDollars,0)) - (isnull(CCSS.SalesCost,0))) as GMDlrCurMTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.AvgCost,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as AvgGMPctMTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.PriceCost,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as PriceGMPctMTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(CCSS.SalesDollars,0)) / SUM(isnull(CCSS.TotalWeight,0))
			END as DlrPerLbCurMTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.SalesCost,0))) / SUM(isnull(CCSS.TotalWeight,0))
			END as GMPerLbCurMTD
	INTO	#tCurMTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo = @Period
	GROUP BY CCSS.Category

	--#tLastYTD: Last Year To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesLastYTD
	INTO	#tLastYTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegLastYTDPer and @EndLastYTDPer
	GROUP BY CCSS.Category

	--#tPrevYTD: 2 Years Previous YTD Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesPrevYTD
	INTO	#tPrevYTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegPrevYTDPer and @EndPrevYTDPer
	GROUP BY CCSS.Category



	--#tSOHist: Sales History
	SELECT	isnull(Cat.CatNo,'') as CatNo,
			isnull(Cat.CatDesc,'') as CatDesc,
			isnull(Cat.BuyGroupNo,'') as BuyGroupNo,
			isnull(Cat.BuyGroupDesc,'') as BuyGroupDesc,
			isnull(tSOHist.SalesCurYTD,0) as SalesCurYTD,
			isnull(tSOHist.CostCurYTD,0) as CostCurYTD,
--			isnull(tSOHist.AvgCostCurYTD,0) as AvgCostCurYTD,
--			isnull(tSOHist.PriceCostCurYTD,0) as PriceCostCurYTD,
			isnull(tSOHist.WghtCurYTD,0) as WghtCurYTD,
			isnull(tSOHist.GMDlrCurYTD,0) as GMDlrCurYTD,
--			isnull(tSOHist.AvgGMPctYTD,0) as AvgGMPctYTD,
--			isnull(tSOHist.PriceGMPctYTD,0) as PriceGMPctYTD,
			isnull(tSOHist.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
			isnull(tSOHist.GMPerLbCurYTD,0) as GMPerLbCurYTD,
			isnull(tSOHist.SalesCurMTD,0) as SalesCurMTD,
			isnull(tSOHist.CostCurMTD,0) as CostCurMTD,
--			isnull(tSOHist.AvgCostCurMTD,0) as AvgCostCurMTD,
--			isnull(tSOHist.PriceCostCurMTD,0) as PriceCostCurMTD,
			isnull(tSOHist.WghtCurMTD,0) as WghtCurMTD,
			isnull(tSOHist.GMDlrCurMTD,0) as GMDlrCurMTD,
--			isnull(tSOHist.AvgGMPctMTD,0) as AvgGMPctMTD,
--			isnull(tSOHist.PriceGMPctMTD,0) as PriceGMPctMTD,
			isnull(tSOHist.DlrPerLbCurMTD,0) as DlrPerLbCurMTD,
			isnull(tSOHist.GMPerLbCurMTD,0) as GMPerLbCurMTD,
			isnull(tSOHist.SalesLastYTD,0) as SalesLastYTD,
			isnull(tSOHist.SalesPrevYTD,0) as SalesPrevYTD
--	INTO	#tSOHist
	FROM	#tCatList Cat (NoLock) INNER JOIN
			(SELECT	isnull(tCurYTD.CatNo, isnull(tCurMTD.CatNo, isnull(tLastYTD.CatNo, isnull(tPrevYTD.CatNo,'NoCat')))) as CatNo,
					tCurYTD.SalesCurYTD,
					tCurYTD.CostCurYTD,
--					tCurYTD.AvgCostCurYTD,
--					tCurYTD.PriceCostCurYTD,
					tCurYTD.WghtCurYTD,
					tCurYTD.GMDlrCurYTD,
--					tCurYTD.AvgGMPctYTD,
--					tCurYTD.PriceGMPctYTD,
					tCurYTD.DlrPerLbCurYTD,
					tCurYTD.GMPerLbCurYTD,
					tCurMTD.SalesCurMTD,
					tCurMTD.CostCurMTD,
--					tCurMTD.AvgCostCurMTD,
--					tCurMTD.PriceCostCurMTD,
					tCurMTD.WghtCurMTD,
					tCurMTD.GMDlrCurMTD,
--					tCurMTD.AvgGMPctMTD,
--					tCurMTD.PriceGMPctMTD,
					tCurMTD.DlrPerLbCurMTD,
					tCurMTD.GMPerLbCurMTD,
					tLastYTD.SalesLastYTD,
					tPrevYTD.SalesPrevYTD
			 FROM	#tCurYTD tCurYTD (NoLock) FULL OUTER JOIN
					#tCurMTD tCurMTD (NoLock)
			 ON		tCurYTD.CatNo = tCurMTD.CatNo FULL OUTER JOIN
					#tLastYTD tLastYTD (NoLock)
			 ON		tCurYTD.CatNo = tLastYTD.CatNo FULL OUTER JOIN
					#tPrevYTD tPrevYTD (NoLock)
			 ON		tCurYTD.CatNo = tPrevYTD.CatNo) tSOHist
			ON		tSOHist.CatNo = Cat.CatNo



	DROP TABLE	#tCatList
	DROP TABLE	#tCurYTD
	DROP TABLE	#tCurMTD
	DROP TABLE	#tLastYTD
	DROP TABLE	#tPrevYTD
