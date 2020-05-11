DECLARE	
		@Period varchar(6),
		@CustNo varchar(10),
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

set @Period = '201204'
set @CustNo = '011571'

print 'CustNo: ' + @CustNo

	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurDt = CurFiscalMthBeginDt,
			@EndCurDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
print 'Period: ' + cast(@Period as varchar(20)) + ' - BegCurDt: ' + cast(@BegCurDt as varchar(20)) + ' - EndCurDt: ' + cast(@EndCurDt as varchar(20))

	SELECT	@BegLastDt = CurFiscalMthBeginDt,
			@EndLastDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
print 'LastPeriod: ' + cast(@LastPeriod as varchar(20)) + ' - BegLastDt: ' + cast(@BegLastDt as varchar(20)) + ' - EndLastDt: ' + cast(@EndLastDt as varchar(20))

	SELECT	@BegPrevDt = CurFiscalMthBeginDt,
			@EndPrevDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
print 'PrevPeriod: ' + cast(@PrevPeriod as varchar(20)) + ' - BegPrevDt: ' + cast(@BegPrevDt as varchar(20)) + ' - EndPrevDt: ' + cast(@EndPrevDt as varchar(20))

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurDt,
			@BegCurMTD = @BegCurDt,
			@EndCurMTD = @EndCurDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurDt
print 'MTDPer: ' + cast(@Period as varchar(20)) + ' - BegCurMTD: ' + cast(@BegCurMTD as varchar(20)) + ' - EndCurMTD: ' + cast(@EndCurMTD as varchar(20))

	SELECT	@YTDPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
	FROM	FiscalCalendar
	WHERE	CurrentDt = @BegCurYTD
print 'YTDPer: ' + cast(@YTDPer as varchar(20)) + ' - BegCurYTD: ' + cast(@BegCurYTD as varchar(20)) + ' - EndCurYTD: ' + cast(@EndCurYTD as varchar(20)) + ' - EndYTDPer: ' + cast(@Period as varchar(20))

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
print 'LastYTD: ' + cast(@LastYTD as varchar(20)) + ' - BegLastYTDPer: ' + cast(@BegLastYTDPer as varchar(20)) + ' - BegLastYTD: ' + cast(@BegLastYTD as varchar(20)) + ' - EndLastYTD: ' + cast(@EndLastYTD as varchar(20)) + ' - EndLastYTDPer: ' + cast(@EndLastYTDPer as varchar(20))

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
print 'PrevYTD: ' + cast(@PrevYTD as varchar(20)) + ' - BegPrevYTDPer: ' + cast(@BegPrevYTDPer as varchar(20)) + ' - BegPrevYTD: ' + cast(@BegPrevYTD as varchar(20)) + ' - EndPrevYTD: ' + cast(@EndPrevYTD as varchar(20)) + ' - EndPrevYTDPer: ' + cast(@EndPrevYTDPer as varchar(20))

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
print 'LastFiscalMthBeginDt: ' + cast(@LastFiscalMthBeginDt as varchar(20)) + ' - LastFiscalMthEndDt: ' + cast(@LastFiscalMthEndDt as varchar(20)) + ' - CuvnalYearMo12: ' + cast(@CuvnalYearMo12 as varchar(20)) + ' - CuvnalYearMo: ' + cast(@CuvnalYearMo as varchar(20))


--------------------------------------------------------------------------------------------------------------------------------------

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

--exec sp_columns CAS_CatGrpDesc
--------------------------------------------------------------------------------------------------------------------------------------
--TMD to be added - TMD added 8/23/12

--#tFamList: Load Product Families
SELECT	IC.ITEMID as ItemNo,
		MAX(CC.Code) as ProdFamCd,
		MAX(CC.DESCR) as ProdFamDesc
INTO	#tFamList
FROM	CatalogChapter CC (NoLock) INNER JOIN
		ItemCatalog IC (NoLock)
ON		IC.CHAPTER = CC.CODE
GROUP BY IC.ITEMID


--------------------------------------------------------------------------------------------------------------------------------------

	--#tCurYTD: Current Year To Date Sales
	SELECT	CISS.ItemNo,
			--left(CISS.ItemNo,5) as CatNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesCurYTD,
			SUM(isnull(CISS.SalesCost,0)) as CostCurYTD,
			SUM(isnull(CISS.AvgCostDollars,0)) as AvgCostCurYTD,
			SUM(isnull(CISS.PriceCostDollars,0)) as PriceCostCurYTD,
			SUM(isnull(CISS.TotalWeight,0)) as WghtCurYTD,
			SUM((isnull(CISS.SalesDollars,0)) - (isnull(CISS.SalesCost,0))) as GMDlrCurYTD,
			CASE SUM(isnull(CISS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.AvgCostDollars,0))) / SUM(isnull(CISS.SalesDollars,0))
			END as AvgGMPctYTD,
			CASE SUM(isnull(CISS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.PriceCostDollars,0))) / SUM(isnull(CISS.SalesDollars,0))
			END as PriceGMPctYTD,
			CASE SUM(isnull(CISS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(CISS.SalesDollars,0)) / SUM(isnull(CISS.TotalWeight,0))
			END as DlrPerLbCurYTD,
			CASE SUM(isnull(CISS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.SalesCost,0))) / SUM(isnull(CISS.TotalWeight,0))
			END as GMPerLbCurYTD
	INTO	#tCurYTD
	FROM	tCustItemSalesSummary CISS (NoLock)
	WHERE	CISS.CustNo = @CustNo AND
			FiscalPeriodNo BETWEEN @YTDPer and @Period
	GROUP BY CISS.ItemNo
--group by left(CISS.ItemNo,5)


/**
	--#tCurYTD: Current Year To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesCurYTD,
			SUM(isnull(CCSS.SalesCost,0)) as CostCurYTD,
			SUM(isnull(CCSS.AvgCostDollars,0)) as AvgCostCurYTD,
			SUM(isnull(CCSS.PriceCostDollars,0)) as PriceCostCurYTD,
			SUM(isnull(CCSS.TotalWeight,0)) as WghtCurYTD,
			SUM((isnull(CCSS.SalesDollars,0)) - (isnull(CCSS.SalesCost,0))) as GMDlrCurYTD,
			CASE SUM(isnull(CCSS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.AvgCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
			END as AvgGMPctYTD,
			CASE SUM(isnull(CCSS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.PriceCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
			END as PriceGMPctYTD,
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
**/


	--#tCurMTD: Current Month To Date Sales
	SELECT	CISS.ItemNo,
--left(CISS.ItemNo,5) as CatNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesCurMTD,
			SUM(isnull(CISS.SalesCost,0)) as CostCurMTD,
			SUM(isnull(CISS.AvgCostDollars,0)) as AvgCostCurMTD,
			SUM(isnull(CISS.PriceCostDollars,0)) as PriceCostCurMTD,
			SUM(isnull(CISS.TotalWeight,0)) as WghtCurMTD,
			SUM((isnull(CISS.SalesDollars,0)) - (isnull(CISS.SalesCost,0))) as GMDlrCurMTD,
			CASE SUM(isnull(CISS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.AvgCostDollars,0))) / SUM(isnull(CISS.SalesDollars,0))
			END as AvgGMPctMTD,
			CASE SUM(isnull(CISS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.PriceCostDollars,0))) / SUM(isnull(CISS.SalesDollars,0))
			END as PriceGMPctMTD,
			CASE SUM(isnull(CISS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(CISS.SalesDollars,0)) / SUM(isnull(CISS.TotalWeight,0))
			END as DlrPerLbCurMTD,
			CASE SUM(isnull(CISS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CISS.SalesDollars,0)) - SUM(isnull(CISS.SalesCost,0))) / SUM(isnull(CISS.TotalWeight,0))
			END as GMPerLbCurMTD
	INTO	#tCurMTD
	FROM	tCustItemSalesSummary CISS (NoLock)
	WHERE	CISS.CustNo = @CustNo AND
			FiscalPeriodNo = @Period
	GROUP BY CISS.ItemNo
--group by left(CISS.ItemNo,5)



/**
	--#tCurMTD: Current Month To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesCurMTD,
			SUM(isnull(CCSS.SalesCost,0)) as CostCurMTD,
			SUM(isnull(CCSS.AvgCostDollars,0)) as AvgCostCurMTD,
			SUM(isnull(CCSS.PriceCostDollars,0)) as PriceCostCurMTD,
			SUM(isnull(CCSS.TotalWeight,0)) as WghtCurMTD,
			SUM((isnull(CCSS.SalesDollars,0)) - (isnull(CCSS.SalesCost,0))) as GMDlrCurMTD,
			CASE SUM(isnull(CCSS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.AvgCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
			END as AvgGMPctMTD,
			CASE SUM(isnull(CCSS.SalesDollars,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.PriceCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
			END as PriceGMPctMTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(CCSS.SalesDollars,0)) / SUM(isnull(CCSS.TotalWeight,0))
			END as DlrPerLbCurMTD,
			CASE SUM(isnull(CCSS.TotalWeight,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.SalesCost,0))) / SUM(isnull(CCSS.TotalWeight,0))
			END as GMPerLbCurMTD
	--INTO	#tCurMTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo = @Period
	GROUP BY CCSS.Category
**/


	--#tLastYTD: Last Year To Date Sales
	SELECT	CISS.ItemNo,
--left(CISS.ItemNo,5) as CatNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesLastYTD
	INTO	#tLastYTD
	FROM	tCustItemSalesSummary CISS (NoLock)
	WHERE	CISS.CustNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegLastYTDPer and @EndLastYTDPer
	GROUP BY CISS.ItemNo
--group by left(CISS.ItemNo,5)

/**
	--#tLastYTD: Last Year To Date Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesLastYTD
	--INTO	#tLastYTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegLastYTDPer and @EndLastYTDPer
	GROUP BY CCSS.Category
**/

	--#tPrevYTD: 2 Years Previous YTD Sales
	SELECT	CISS.ItemNo,
--left(CISS.ItemNo,5) as CatNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesPrevYTD
	INTO	#tPrevYTD
	FROM	tCustItemSalesSummary CISS (NoLock)
	WHERE	CISS.CustNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegPrevYTDPer and @EndPrevYTDPer
	GROUP BY CISS.ItemNo
--group by left(CISS.ItemNo,5)

/**
	--#tPrevYTD: 2 Years Previous YTD Sales
	SELECT	CCSS.Category as CatNo,
			SUM(isnull(CCSS.SalesDollars,0)) as SalesPrevYTD
	--INTO	#tPrevYTD
	FROM	CustCatSalesSummary CCSS (NoLock)
	WHERE	CCSS.CustomerNo = @CustNo AND
			FiscalPeriodNo BETWEEN @BegPrevYTDPer and @EndPrevYTDPer
	GROUP BY CCSS.Category
**/



--select * from #tCurYTD
--select * from #tCurMTD
--select * from #tLastYTD
--select * from #tPrevYTD

--drop table #tSOHist


---------------------------------------------------------------------------------------------------------------------------------------------------
--TMD: This is new

--#tSOHist: Sales History
SELECT	isnull(tCurYTD.ItemNo, isnull(tCurMTD.ItemNo, isnull(tLastYTD.ItemNo, isnull(tPrevYTD.ItemNo,'NoItem')))) as ItemNo,
		isnull(left(tCurYTD.ItemNo,5), isnull(left(tCurMTD.ItemNo,5), isnull(left(tLastYTD.ItemNo,5), isnull(left(tPrevYTD.ItemNo,5),'NoCat')))) as CatNo,
		cast(' ' as VARCHAR(255)) as CatDesc,
		cast(' ' as VARCHAR(255)) as BuyGroupNo,
		cast(' ' as VARCHAR(255)) as BuyGroupDesc,
		cast(' ' as VARCHAR(255)) as ProdFam,
		cast(' ' as VARCHAR(255)) as ProdFamDesc,
		isnull(tCurYTD.SalesCurYTD,0) as SalesCurYTD,
		isnull(tCurYTD.CostCurYTD,0) as CostCurYTD,
		isnull(tCurYTD.AvgCostCurYTD,0) as AvgCostCurYTD,
		isnull(tCurYTD.PriceCostCurYTD,0) as PriceCostCurYTD,
		isnull(tCurYTD.WghtCurYTD,0) as WghtCurYTD,
		isnull(tCurYTD.GMDlrCurYTD,0) as GMDlrCurYTD,
		isnull(tCurYTD.AvgGMPctYTD,0) as AvgGMPctYTD,
		isnull(tCurYTD.PriceGMPctYTD,0) as PriceGMPctYTD,
		isnull(tCurYTD.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
		isnull(tCurYTD.GMPerLbCurYTD,0) as GMPerLbCurYTD,
		isnull(tCurMTD.SalesCurMTD,0) as SalesCurMTD,
		isnull(tCurMTD.CostCurMTD,0) as CostCurMTD,
		isnull(tCurMTD.AvgCostCurMTD,0) as AvgCostCurMTD,
		isnull(tCurMTD.PriceCostCurMTD,0) as PriceCostCurMTD,
		isnull(tCurMTD.WghtCurMTD,0) as WghtCurMTD,
		isnull(tCurMTD.GMDlrCurMTD,0) as GMDlrCurMTD,
		isnull(tCurMTD.AvgGMPctMTD,0) as AvgGMPctMTD,
		isnull(tCurMTD.PriceGMPctMTD,0) as PriceGMPctMTD,
		isnull(tCurMTD.DlrPerLbCurMTD,0) as DlrPerLbCurMTD,
		isnull(tCurMTD.GMPerLbCurMTD,0) as GMPerLbCurMTD,
		isnull(tLastYTD.SalesLastYTD,0) as SalesLastYTD,
		isnull(tPrevYTD.SalesPrevYTD,0) as SalesPrevYTD
INTO	#tSOHist
FROM	#tCurYTD tCurYTD (NoLock) FULL OUTER JOIN
		#tCurMTD tCurMTD (NoLock)
ON		tCurYTD.ItemNo = tCurMTD.ItemNo FULL OUTER JOIN
		#tLastYTD tLastYTD (NoLock)
ON		tCurYTD.ItemNo = tLastYTD.ItemNo FULL OUTER JOIN
		#tPrevYTD tPrevYTD (NoLock)
ON		tCurYTD.ItemNo = tPrevYTD.ItemNo

--UPDATE Category BuyGroup data
UPDATE	#tSOHist
SET		CatDesc = isnull(Cat.CatDesc,'** NoCat **'),
		BuyGroupNo = isnull(Cat.BuyGroupNo,''),
		BuyGroupDesc = isnull(Cat.BuyGroupDesc,'** NoGroup **')
FROM	#tSOHist SO LEFT OUTER JOIN
		#tCatList Cat
ON		SO.CatNo = Cat.CatNo

--UPDATE ProductFamily data
UPDATE	#tSOHist
SET		ProdFam = isnull(Fam.ProdFamCd,'NO_FAM'),
		ProdFamDesc = isnull(Fam.ProdFamDesc,'** NoFamily **')
FROM	#tSOHist SO LEFT OUTER JOIN
		#tFamList Fam
ON		SO.ItemNo = Fam.ItemNo


select * from #tSOHist
--select * from #tFamList




















---------------------------------------------------------------------------------------------------------------------------------------------------


/**
	--#tSOHist: Sales History
	SELECT	isnull(tSOHist.ItemNo,'') as ItemNo,
			isnull(Cat.CatNo,'') as CatNo,
			isnull(Cat.CatDesc,'') as CatDesc,
			isnull(Cat.BuyGroupNo,'') as BuyGroupNo,
			isnull(Cat.BuyGroupDesc,'') as BuyGroupDesc,
			isnull(tSOHist.SalesCurYTD,0) as SalesCurYTD,
			isnull(tSOHist.CostCurYTD,0) as CostCurYTD,
			isnull(tSOHist.AvgCostCurYTD,0) as AvgCostCurYTD,
			isnull(tSOHist.PriceCostCurYTD,0) as PriceCostCurYTD,
			isnull(tSOHist.WghtCurYTD,0) as WghtCurYTD,
			isnull(tSOHist.GMDlrCurYTD,0) as GMDlrCurYTD,
			isnull(tSOHist.AvgGMPctYTD,0) as AvgGMPctYTD,
			isnull(tSOHist.PriceGMPctYTD,0) as PriceGMPctYTD,
			isnull(tSOHist.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
			isnull(tSOHist.GMPerLbCurYTD,0) as GMPerLbCurYTD,
			isnull(tSOHist.SalesCurMTD,0) as SalesCurMTD,
			isnull(tSOHist.CostCurMTD,0) as CostCurMTD,
			isnull(tSOHist.AvgCostCurMTD,0) as AvgCostCurMTD,
			isnull(tSOHist.PriceCostCurMTD,0) as PriceCostCurMTD,
			isnull(tSOHist.WghtCurMTD,0) as WghtCurMTD,
			isnull(tSOHist.GMDlrCurMTD,0) as GMDlrCurMTD,
			isnull(tSOHist.AvgGMPctMTD,0) as AvgGMPctMTD,
			isnull(tSOHist.PriceGMPctMTD,0) as PriceGMPctMTD,
			isnull(tSOHist.DlrPerLbCurMTD,0) as DlrPerLbCurMTD,
			isnull(tSOHist.GMPerLbCurMTD,0) as GMPerLbCurMTD,
			isnull(tSOHist.SalesLastYTD,0) as SalesLastYTD,
			isnull(tSOHist.SalesPrevYTD,0) as SalesPrevYTD
	--INTO	#tSOHist
	FROM	#tCatList Cat (NoLock) right outer join
			(

			SELECT	isnull(tCurYTD.ItemNo, isnull(tCurMTD.ItemNo, isnull(tLastYTD.ItemNo, isnull(tPrevYTD.ItemNo,'NoItem')))) as ItemNo,
					isnull(left(tCurYTD.ItemNo,5), isnull(left(tCurMTD.ItemNo,5), isnull(left(tLastYTD.ItemNo,5), isnull(left(tPrevYTD.ItemNo,5),'NoCat')))) as CatNo,
					tCurYTD.SalesCurYTD,
					tCurYTD.CostCurYTD,
					tCurYTD.AvgCostCurYTD,
					tCurYTD.PriceCostCurYTD,
					tCurYTD.WghtCurYTD,
					tCurYTD.GMDlrCurYTD,
					tCurYTD.AvgGMPctYTD,
					tCurYTD.PriceGMPctYTD,
					tCurYTD.DlrPerLbCurYTD,
					tCurYTD.GMPerLbCurYTD,
					tCurMTD.SalesCurMTD,
					tCurMTD.CostCurMTD,
					tCurMTD.AvgCostCurMTD,
					tCurMTD.PriceCostCurMTD,
					tCurMTD.WghtCurMTD,
					tCurMTD.GMDlrCurMTD,
					tCurMTD.AvgGMPctMTD,
					tCurMTD.PriceGMPctMTD,
					tCurMTD.DlrPerLbCurMTD,
					tCurMTD.GMPerLbCurMTD,
					tLastYTD.SalesLastYTD,
					tPrevYTD.SalesPrevYTD
			 FROM	#tCurYTD tCurYTD (NoLock) FULL OUTER JOIN
					#tCurMTD tCurMTD (NoLock)
			 ON		tCurYTD.ItemNo = tCurMTD.ItemNo FULL OUTER JOIN
					#tLastYTD tLastYTD (NoLock)
			 ON		tCurYTD.ItemNo = tLastYTD.ItemNo FULL OUTER JOIN
					#tPrevYTD tPrevYTD (NoLock)
			 ON		tCurYTD.ItemNo = tPrevYTD.ItemNo
) tSOHist
			ON		tSOHist.CatNo = Cat.CatNo
**/


/**
	--#tSOHist: Sales History
	SELECT	isnull(Cat.CatNo,'') as CatNo,
			isnull(Cat.CatDesc,'') as CatDesc,
			isnull(Cat.BuyGroupNo,'') as BuyGroupNo,
			isnull(Cat.BuyGroupDesc,'') as BuyGroupDesc,
			isnull(tSOHist.SalesCurYTD,0) as SalesCurYTD,
			isnull(tSOHist.CostCurYTD,0) as CostCurYTD,
			isnull(tSOHist.AvgCostCurYTD,0) as AvgCostCurYTD,
			isnull(tSOHist.PriceCostCurYTD,0) as PriceCostCurYTD,
			isnull(tSOHist.WghtCurYTD,0) as WghtCurYTD,
			isnull(tSOHist.GMDlrCurYTD,0) as GMDlrCurYTD,
			isnull(tSOHist.AvgGMPctYTD,0) as AvgGMPctYTD,
			isnull(tSOHist.PriceGMPctYTD,0) as PriceGMPctYTD,
			isnull(tSOHist.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
			isnull(tSOHist.GMPerLbCurYTD,0) as GMPerLbCurYTD,
			isnull(tSOHist.SalesCurMTD,0) as SalesCurMTD,
			isnull(tSOHist.CostCurMTD,0) as CostCurMTD,
			isnull(tSOHist.AvgCostCurMTD,0) as AvgCostCurMTD,
			isnull(tSOHist.PriceCostCurMTD,0) as PriceCostCurMTD,
			isnull(tSOHist.WghtCurMTD,0) as WghtCurMTD,
			isnull(tSOHist.GMDlrCurMTD,0) as GMDlrCurMTD,
			isnull(tSOHist.AvgGMPctMTD,0) as AvgGMPctMTD,
			isnull(tSOHist.PriceGMPctMTD,0) as PriceGMPctMTD,
			isnull(tSOHist.DlrPerLbCurMTD,0) as DlrPerLbCurMTD,
			isnull(tSOHist.GMPerLbCurMTD,0) as GMPerLbCurMTD,
			isnull(tSOHist.SalesLastYTD,0) as SalesLastYTD,
			isnull(tSOHist.SalesPrevYTD,0) as SalesPrevYTD
	--INTO	#tSOHist
	FROM	#tCatList Cat (NoLock) INNER JOIN
			(SELECT	isnull(tCurYTD.CatNo, isnull(tCurMTD.CatNo, isnull(tLastYTD.CatNo, isnull(tPrevYTD.CatNo,'NoCat')))) as CatNo,
					tCurYTD.SalesCurYTD,
					tCurYTD.CostCurYTD,
					tCurYTD.AvgCostCurYTD,
					tCurYTD.PriceCostCurYTD,
					tCurYTD.WghtCurYTD,
					tCurYTD.GMDlrCurYTD,
					tCurYTD.AvgGMPctYTD,
					tCurYTD.PriceGMPctYTD,
					tCurYTD.DlrPerLbCurYTD,
					tCurYTD.GMPerLbCurYTD,
					tCurMTD.SalesCurMTD,
					tCurMTD.CostCurMTD,
					tCurMTD.AvgCostCurMTD,
					tCurMTD.PriceCostCurMTD,
					tCurMTD.WghtCurMTD,
					tCurMTD.GMDlrCurMTD,
					tCurMTD.AvgGMPctMTD,
					tCurMTD.PriceGMPctMTD,
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
**/

















--------------------------------------------------------------------------------------------------------------------------------------
--
--	--#tCurYTD: Current Year To Date Sales
--	SELECT	CCSS.Category as CatNo,
--			SUM(isnull(CCSS.SalesDollars,0)) as SalesCurYTD,
--			SUM(isnull(CCSS.SalesCost,0)) as CostCurYTD,
--			SUM(isnull(CCSS.AvgCostDollars,0)) as AvgCostCurYTD,
--			SUM(isnull(CCSS.PriceCostDollars,0)) as PriceCostCurYTD,
--			SUM(isnull(CCSS.TotalWeight,0)) as WghtCurYTD,
--			SUM((isnull(CCSS.SalesDollars,0)) - (isnull(CCSS.SalesCost,0))) as GMDlrCurYTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.AvgCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as AvgGMPctYTD,
--			CASE SUM(isnull(CCSS.SalesDollars,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.PriceCostDollars,0))) / SUM(isnull(CCSS.SalesDollars,0))
--			END as PriceGMPctYTD,
--			CASE SUM(isnull(CCSS.TotalWeight,0))
--					WHEN 0 THEN 0
--					ELSE SUM(isnull(CCSS.SalesDollars,0)) / SUM(isnull(CCSS.TotalWeight,0))
--			END as DlrPerLbCurYTD,
--			CASE SUM(isnull(CCSS.TotalWeight,0))
--					WHEN 0 THEN 0
--					ELSE (SUM(isnull(CCSS.SalesDollars,0)) - SUM(isnull(CCSS.SalesCost,0))) / SUM(isnull(CCSS.TotalWeight,0))
--			END as GMPerLbCurYTD
--	INTO	#tCurYTD
--	FROM	CustCatSalesSummary CCSS (NoLock)
--	WHERE	CCSS.CustomerNo = @CustNo AND
--			FiscalPeriodNo BETWEEN @YTDPer and @Period
--	GROUP BY CCSS.Category


--#tCurYTD: Current Year To Date Sales
SELECT
			Dtl.ItemNo,
--			Hdr.ArPostDt,
--			CAST(Cal.FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+Cal.FiscalCalMonth as VARCHAR(3)),2) as Period,
			SellToCustNo as CustNo,
			SUM(isnull(Dtl.NetUnitPrice,0) * isnull(Dtl.QtyShipped,0)) AS SalesCurYTD,
			SUM(isnull(Dtl.UnitCost,0) * isnull(Dtl.QtyShipped,0)) AS CostCurYTD,
			SUM(isnull(Dtl.GrossWght,0) * isnull(Dtl.QtyShipped,0)) AS WghtCurYTD,
			SUM(isnull(IB.AvgCost,0) * Dtl.QtyShipped) as AvgCostDollars,
			SUM(isnull(IB.PriceCost,0) * Dtl.QtyShipped) as PriceCostDollars
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			#tItemBranch IB (NoLock)
ON			Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location LEFT OUTER JOIN
			#BuyGrpCatDesc BuyGrp (NoLock)
ON			LEFT(Dtl.ItemNo, 5) = BuyGrp.CatNo
WHERE		Hdr.ARPostDt between @BegPer and @EndPer
			AND ISNULL(Hdr.DeleteDt,'') = ''
GROUP BY	Dtl.ItemNo, BuyGrp.CatDesc, BuyGrp.BuyGrpNo, BuyGrp.BuyGrpDesc


/**
x		SalesDollars										--SalesCurYTD,
x		SalesCost											--CostCurYTD,
x		AvgCostDollars										--AvgCostCurYTD,
x		PriceCostDollars									--PriceCostCurYTD,
x		TotalWeight											--WghtCurYTD,
		SalesDollars - SalesCost							--GMDlrCurYTD,
		(SalesDollars - AvgCostDollars) / SalesDollars		--AvgGMPctYTD,
		(SalesDollars - PriceCostDollars) / SalesDollars	--PriceGMPctYTD,
		SalesDollars / TotalWeight							--DlrPerLbCurYTD
		(SalesDollars - SalesCost) / TotalWeight			--GMPerLbCurYTD
**/


FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
		SODetailHist Dtl (NoLock)
ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		FiscalCalendar Cal (NoLock)
ON		CAST (FLOOR (CAST (Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN CAST (FLOOR (CAST (@BegCurYTD AS FLOAT)) AS DATETIME) and CAST (FLOOR (CAST (@EndCurYTD AS FLOAT)) AS DATETIME)
