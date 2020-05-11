use DEVPERP
go

drop proc pCustActivityChain
go

CREATE PROCEDURE [dbo].[pCustActivityChain]
	@Period varchar(6),
	@ChainCd varchar(10)
AS

DECLARE	@BegCurPer datetime,
		@EndCurPer datetime,
		@BegLastPer datetime,
		@EndLastPer datetime,
		@BegPrevPer datetime,
		@EndPrevPer datetime,
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
		@CuvSales decimal(18,6),
		@SQL nvarchar(4000)

BEGIN
	-- ============================================
	-- Date		Developer	Action          
	-- --------------------------------------------
	-- 12/22/2010	Tod		Create
	-- ============================================

	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurPer = CurFiscalMthBeginDt,
			@EndCurPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
--	select @BegCurPer, @EndCurPer

	SELECT	@BegLastPer = CurFiscalMthBeginDt,
			@EndLastPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
--	select @BegLastPer, @EndLastPer

	SELECT	@BegPrevPer = CurFiscalMthBeginDt,
			@EndPrevPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
--	select @BegPrevPer, @EndPrevPer

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurPer,
			@BegCurMTD = @BegCurPer,
			@EndCurMTD = @EndCurPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurPer
--	select @BegCurYTD, @EndCurYTD, @BegCurMTD, @EndCurMTD

	--SET Last Year's Fiscal
	SELECT	@LastYTD = FiscalYear,
			@BegLastYTD = CurFiscalYearBeginDt,
			@EndLastYTD = @EndLastPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndLastPer
--	select @LastYTD, @BegLastYTD, @EndLastYTD

	--SET 2 Years Previous Fiscal
	SELECT	@PrevYTD = FiscalYear,
			@BegPrevYTD = CurFiscalYearBeginDt,
			@EndPrevYTD = @EndPrevPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndPrevPer
--	select @PrevYTD, @BegPrevYTD, @EndPrevYTD

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
--	select @LastFiscalMthBeginDt as LastFiscalMthBeginDt, @LastFiscalMthEndDt as LastFiscalMthEndDt, @CuvnalYearMo12 as CuvnalYearMo12, @CuvnalYearMo as CuvnalYearMo

	--SET @CuvSales Value for DSO calculation
	SELECT	@CuvSales = SUM(ISNULL(CMSales,0))
	FROM	CustomerMaster Cust (NoLock) INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalSum CuvnalSum --(NoLock)
	ON		Cust.CustNo = CuvnalSum.CustNo
	WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND Cust.ChainCd = @ChainCd
	--select @CuvSales


	------------------------------------
	-- Get Chain & Sales History Data --
	------------------------------------
	print 'Get Chain & Sales History Data'

	-----------------
	-- Work Tables --
	-----------------
	--#tCatList: Load Categories
	SELECT	tCatList.CatNo,
			tCatList.CatDesc,
			BuyGrp.GroupNo as BuyGroupNo,
			BuyGrp.Description as BuyGroupDesc
	INTO	#tCatList
	FROM	(SELECT	LD.ListValue as CatNo,
					LD.ListDtlDesc as CatDesc
			 FROM	ListMaster LM (NoLock) INNER JOIN
					ListDetail LD (NoLock)
			 ON		LM.pListMasterID = LD.fListMasterID
			 WHERE	LM.ListName = 'CategoryDesc') tCatList LEFT OUTER JOIN
			CategoryBuyGroups BuyGrp (NoLock)
	ON		tCatList.CatNo = BuyGrp.Category

	--#tChainList: Load Chains
	SELECT	LD.ListValue as ChainCd,
			LD.ListDtlDesc as ChainName
	INTO	#tChainList
	FROM	ListMaster LM (NoLock) INNER JOIN
			ListDetail LD (NoLock)
	ON		LM.pListMasterID = LD.fListMasterID
	WHERE	LM.ListName = 'CustChainName'
	ORDER BY LD.ListValue

	--#tItemBranch: Load ItemBranch Avg and Price Cost
	SELECT	IM.ItemNo,
			IB.Location,
			IB.UnitCost as AvgCost,
			IB.PriceCost
	INTO	#tItemBranch
	FROM	ItemMaster IM (NoLock) INNER JOIN
			ItemBranch IB (NoLock)
	ON		IM.pItemMasterID = IB.fItemMasterID

	--#tCurYTD: Year To Date Sales
	SELECT	tCurYTD.CatNo,
			SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as SalesCurYTD,
			SUM(isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as CostCurYTD,
			SUM(isnull(tCurYTD.AvgCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as AvgCostCurYTD,
			SUM(isnull(tCurYTD.PriceCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as PriceCostCurYTD,
			SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as WghtCurYTD,
			SUM((isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) as GMDlrCurYTD,
			CASE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.AvgCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
			END as AvgGMPctYTD,
			CASE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.PriceCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
			END as PriceGMPctYTD,
			CASE SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) / SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
			END as DlrPerLbCurYTD,
			CASE SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
			END as GMPerLbCurYTD
	INTO	#tCurYTD
	FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
					Dtl.NetUnitPrice as PriceCurYTD,
					Dtl.QtyShipped as QtyCurYTD,
					Dtl.GrossWght as WghtCurYTD,
					Dtl.UnitCost as CostCurYTD,
					IB.AvgCost as AvgCostCurYTD,
					IB.PriceCost as PriceCostCurYTD
			 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
					SODetailHist Dtl (NoLock)
			 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
					CustomerMaster Cust (NoLock)
			 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
					#tItemBranch IB (NoLock)
			 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
			 WHERE	Cust.ChainCd = @ChainCd AND
					CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurYTD and @EndCurYTD) tCurYTD
	GROUP BY tCurYTD.CatNo

	--#tCurMTD: Month To Date Sales
	SELECT	tCurMTD.CatNo,
			SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as SalesCurMTD,
			SUM(isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as CostCurMTD,
			SUM(isnull(tCurMTD.AvgCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as AvgCostCurMTD,
			SUM(isnull(tCurMTD.PriceCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as PriceCostCurMTD,
			SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as WghtCurMTD,
			SUM((isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) as GMDlrCurMTD,
			CASE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.AvgCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
			END as AvgGMPctMTD,
			CASE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.PriceCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
			END as PriceGMPctMTD,
			CASE SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					WHEN 0 THEN 0
					ELSE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) / SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
			END as DlrPerLbCurMTD,
			CASE SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					WHEN 0 THEN 0
					ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
			END as GMPerLbCurMTD
	INTO	#tCurMTD
	FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
					Dtl.NetUnitPrice as PriceCurMTD,
					Dtl.QtyShipped as QtyCurMTD,
					Dtl.GrossWght as WghtCurMTD,
					Dtl.UnitCost as CostCurMTD,
					IB.AvgCost as AvgCostCurMTD,
					IB.PriceCost as PriceCostCurMTD
			 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
					SODetailHist Dtl (NoLock)
			 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
					CustomerMaster Cust (NoLock)
			 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
					#tItemBranch IB (NoLock)
			 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
			 WHERE	Cust.ChainCd = @ChainCd AND
					CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurMTD and @EndCurMTD) tCurMTD
	GROUP BY tCurMTD.CatNo

	--#tLastYTD: Last Year Sales
	SELECT	tLastYTD.CatNo,
			SUM(isnull(tLastYTD.PriceLastYTD,0) * isnull(tLastYTD.QtyLastYTD,0)) as SalesLastYTD
	INTO	#tLastYTD
	FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
					Dtl.NetUnitPrice as PriceLastYTD,
					Dtl.QtyShipped as QtyLastYTD
			 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
					SODetailHist Dtl (NoLock)
			 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
					CustomerMaster Cust (NoLock)
			 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
					#tItemBranch IB (NoLock)
			 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
			 WHERE	Cust.ChainCd = @ChainCd AND
					CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegLastYTD and @EndLastYTD) tLastYTD
	GROUP BY tLastYTD.CatNo

	--#tPrevYTD: 2 Years Previous Sales
	SELECT	tPrevYTD.CatNo,
			SUM(isnull(tPrevYTD.PricePrevYTD,0) * isnull(tPrevYTD.QtyPrevYTD,0)) as SalesPrevYTD
	INTO	#tPrevYTD
	FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
					Dtl.NetUnitPrice as PricePrevYTD,
					Dtl.QtyShipped as QtyPrevYTD
			 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
					SODetailHist Dtl (NoLock)
			 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
					CustomerMaster Cust (NoLock)
			 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
					#tItemBranch IB (NoLock)
			 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
			 WHERE	Cust.ChainCd = @ChainCd AND
					CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegPrevYTD and @EndPrevYTD) tPrevYTD
	GROUP BY tPrevYTD.CatNo

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
	INTO	#tSOHist
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


	-----------------
	-- Main Tables --
	-----------------

	--Table[0] - Customer Header Data
	SELECT	Cust.pCustMstrId,
			Cust.CustNo,
			isnull(Cust.TargetGrossMarginPct,0) as DefaultGrossMarginPct,
			Cust.ChainCd,
			Chain.ChainName
	FROM	CustomerMaster Cust (NoLock) INNER JOIN
			#tChainList Chain (NoLock)
	ON		Cust.ChainCd = Chain.ChainCd
	WHERE	Cust.ChainCd = @ChainCd

	--Table[1] - Chain A/R Aging Data
	SELECT	ChainAging.ChainCd,
			ChainAging.CurrentAmt,
			ChainAging.CurrentPct,
			ChainAging.Over30Amt,
			ChainAging.Over30Pct,
			ChainAging.Over60Amt,
			ChainAging.Over60Pct,
			ChainAging.Over90Amt,
			ChainAging.Over90Pct,
			ChainAging.BalanceDue,
--			365 * (ChainAging.BalanceDue / @CuvSales) as DSO
			round((365 * (ChainAging.BalanceDue / @CuvSales)),0) as DSO
	FROM	(SELECT	tmpAging.ChainCd,
					SUM(tmpAging.CurrentAmt) as CurrentAmt,
					CASE SUM(tmpAging.BalanceDue)
						WHEN 0 THEN 0
						ELSE SUM(tmpAging.CurrentAmt) / SUM(tmpAging.BalanceDue) * 100
					END as CurrentPct,
					SUM(tmpAging.Over30Amt) as Over30Amt,
					CASE SUM(tmpAging.BalanceDue)
						WHEN 0 THEN 0
						ELSE SUM(tmpAging.Over30Amt) / SUM(tmpAging.BalanceDue) * 100
					END as Over30Pct,
					SUM(tmpAging.Over60Amt) as Over60Amt,
					CASE SUM(tmpAging.BalanceDue)
						WHEN 0 THEN 0
						ELSE SUM(tmpAging.Over60Amt) / SUM(tmpAging.BalanceDue) * 100
					END as Over60Pct,
					SUM(tmpAging.Over90Amt) as Over90Amt,
					CASE SUM(tmpAging.BalanceDue)
						WHEN 0 THEN 0
						ELSE SUM(tmpAging.Over90Amt) / SUM(tmpAging.BalanceDue) * 100
					END as Over90Pct,
					SUM(tmpAging.BalanceDue) as BalanceDue
			 FROM	(SELECT	Cust.ChainCd,
							isnull(Aging.CurrentAmt,0) as CurrentAmt,
							isnull(Aging.Over30Amt,0) as Over30Amt,
							isnull(Aging.Over60Amt,0) as Over60Amt,
							isnull(Aging.Over90Amt,0) as Over90Amt,
							isnull(Aging.BalanceDue,0) as BalanceDue
					 FROM	CustomerMaster Cust (NoLock) INNER JOIN
							ARAging Aging (NoLock)
					 ON		Cust.CustNo = Aging.CustNo
					 WHERE	Cust.ChainCd = @ChainCd) tmpAging
			 GROUP BY tmpAging.ChainCd) ChainAging

	--Table[2] - Sales Activity By Chain
	SELECT	isnull(CAS.MonthName,'~month~') as [MonthName],
			--CM - Fiscal Month/Current Year
			isnull(CAS.CMCorpRank,'') as CMCorpRank,
			isnull(CAS.CMTerRank,'') as CMTerRank,
			isnull(CAS.CMSales,0) as CMSales,
			CASE isnull(LMSales,0)
				WHEN 0 THEN 0
				ELSE (isnull(CMSales,0) - isnull(LMSales,0)) / isnull(LMSales,0)
			END as CMSalesPct,
			isnull(CAS.CMGM,0) as CMGM,
			isnull(CAS.CMGMPct,0) as CMGMPct,
			isnull(CAS.CMLbs,0) as CMLbs,
			isnull(CAS.CMGMPerLb,0) as CMGMPerLb,
			isnull(CAS.CMAvgDolPerOrder,0) as CMAvgDolPerOrder,
			isnull(CAS.CMAvgDolPerLine,0) as CMAvgDolPerLine,
			isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
			isnull(CAS.CMOESales,0) as CMOESales,
			isnull(CAS.CMEComSales,0) as CMEComSales,
			isnull(CAS.CMMillSales,0) as CMMillSales,
			isnull(CAS.CMOELbs,0) as CMOELbs,
			isnull(CAS.CMEComLbs,0) as CMEComLbs,
			isnull(CAS.CMMillLbs,0) as CMMillLbs,
			isnull(CAS.CMOEOrders,0) as CMOEOrders,
			isnull(CAS.CMEComOrders,0) as CMEComOrders,
			isnull(CAS.CMMillOrders,0) as CMMillOrders,
			isnull(CAS.CMOELines,0) as CMOELines,
			isnull(CAS.CMEComLines,0) as CMEComLines,
			isnull(CAS.CMMillLines,0) as CMMillLines,
			isnull(CAS.CMOEQDol,0) as CMOEQDol,
			isnull(CAS.CMEComQDol,0) as CMEComQDol,
			isnull(CAS.CMOEQOrders,0) as CMOEQOrders,
			isnull(CAS.CMEComQOrders,0) as CMEComQOrders,
			isnull(CAS.CMOEQLines,0) as CMOEQLines,
			isnull(CAS.CMEComQLines,0) as CMEComQLines,
			isnull(CAS.CMRGACount,0) as CMRGACount,
			isnull(CAS.CMCreditCount,0) as CMCreditCount,
			--LM - Fiscal Month/Last Year
			isnull(CAS.LMCorpRank,'') as LMCorpRank,
			isnull(CAS.LMTerRank,'') as LMTerRank,
			isnull(CAS.LMSales,0) as LMSales,
			isnull(CAS.LMGM,0) as LMGM,
			isnull(CAS.LMGMPct,0) as LMGMPct,
			isnull(CAS.LMLbs,0) as LMLbs,
			isnull(CAS.LMGMPerLb,0) as LMGMPerLb,
			isnull(CAS.LMAvgDolPerOrder,0) as LMAvgDolPerOrder,
			isnull(CAS.LMAvgDolPerLine,0) as LMAvgDolPerLine,
--			isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
			isnull(CAS.LMOESales,0) as LMOESales,
			isnull(CAS.LMEComSales,0) as LMEComSales,
			isnull(CAS.LMMillSales,0) as LMMillSales,
			isnull(CAS.LMOELbs,0) as LMOELbs,
			isnull(CAS.LMEComLbs,0) as LMEComLbs,
			isnull(CAS.LMMillLbs,0) as LMMillLbs,
			isnull(CAS.LMOEOrders,0) as LMOEOrders,
			isnull(CAS.LMEComOrders,0) as LMEComOrders,
			isnull(CAS.LMMillOrders,0) as LMMillOrders,
			isnull(CAS.LMOELines,0) as LMOELines,
			isnull(CAS.LMEComLines,0) as LMEComLines,
			isnull(CAS.LMMillLines,0) as LMMillLines,
			isnull(CAS.LMOEQDol,0) as LMOEQDol,
			isnull(CAS.LMEComQDol,0) as LMEComQDol,
			isnull(CAS.LMOEQOrders,0) as LMOEQOrders,
			isnull(CAS.LMEComQOrders,0) as LMEComQOrders,
			isnull(CAS.LMOEQLines,0) as LMOEQLines,
			isnull(CAS.LMEComQLines,0) as LMEComQLines,
			isnull(CAS.LMRGACount,0) as LMRGACount,
			isnull(CAS.LMCreditCount,0) as LMCreditCount,
			--CY - Fiscal Year/Current Year
			isnull(CAS.CYCorpRank,'') as CYCorpRank,
			isnull(CAS.CYTerRank,'') as CYTerRank,
			isnull(CAS.CYSales,0) as CYSales,
			CASE isnull(LYSales,0)
				WHEN 0 THEN 0
				ELSE (isnull(CYSales,0) - isnull(LYSales,0)) / isnull(LYSales,0)
			END as CYSalesPct,
			isnull(CAS.CYGM,0) as CYGM,
			isnull(CAS.CYGMPct,0) as CYGMPct,
			isnull(CAS.CYLbs,0) as CYLbs,
			isnull(CAS.CYGMPerLb,0) as CYGMPerLb,
			isnull(CAS.CYAvgDolPerOrder,0) as CYAvgDolPerOrder,
			isnull(CAS.CYAvgDolPerLine,0) as CYAvgDolPerLine,
			isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
			isnull(CAS.CYOESales,0) as CYOESales,
			isnull(CAS.CYEComSales,0) as CYEComSales,
			isnull(CAS.CYMillSales,0) as CYMillSales,
			isnull(CAS.CYOELbs,0) as CYOELbs,
			isnull(CAS.CYEComLbs,0) as CYEComLbs,
			isnull(CAS.CYMillLbs,0) as CYMillLbs,
			isnull(CAS.CYOEOrders,0) as CYOEOrders,
			isnull(CAS.CYEComOrders,0) as CYEComOrders,
			isnull(CAS.CYMillOrders,0) as CYMillOrders,
			isnull(CAS.CYOELines,0) as CYOELines,
			isnull(CAS.CYEComLines,0) as CYEComLines,
			isnull(CAS.CYMillLines,0) as CYMillLines,
			isnull(CAS.CYOEQDol,0) as CYOEQDol,
			isnull(CAS.CYEComQDol,0) as CYEComQDol,
			isnull(CAS.CYOEQOrders,0) as CYOEQOrders,
			isnull(CAS.CYEComQOrders,0) as CYEComQOrders,
			isnull(CAS.CYOEQLines,0) as CYOEQLines,
			isnull(CAS.CYEComQLines,0) as CYEComQLines,
			isnull(CAS.CYRGACount,0) as CYRGACount,
			isnull(CAS.CYCreditCount,0) as CYCreditCount,
			--LY - Fiscal Year/Last Year
			isnull(CAS.LYCorpRank,'') as LYCorpRank,
			isnull(CAS.LYTerRank,'') as LYTerRank,
			isnull(CAS.LYSales,0) as LYSales,
			isnull(CAS.LYGM,0) as LYGM,
			isnull(CAS.LYGMPct,0) as LYGMPct,
			isnull(CAS.LYLbs,0) as LYLbs,
			isnull(CAS.LYGMPerLb,0) as LYGMPerLb,
			isnull(CAS.LYAvgDolPerOrder,0) as LYAvgDolPerOrder,
			isnull(CAS.LYAvgDolPerLine,0) as LYAvgDolPerLine,
--			isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
			isnull(CAS.LYOESales,0) as LYOESales,
			isnull(CAS.LYEComSales,0) as LYEComSales,
			isnull(CAS.LYMillSales,0) as LYMillSales,
			isnull(CAS.LYOELbs,0) as LYOELbs,
			isnull(CAS.LYEComLbs,0) as LYEComLbs,
			isnull(CAS.LYMillLbs,0) as LYMillLbs,
			isnull(CAS.LYOEOrders,0) as LYOEOrders,
			isnull(CAS.LYEComOrders,0) as LYEComOrders,
			isnull(CAS.LYMillOrders,0) as LYMillOrders,
			isnull(CAS.LYOELines,0) as LYOELines,
			isnull(CAS.LYEComLines,0) as LYEComLines,
			isnull(CAS.LYMillLines,0) as LYMillLines,
			isnull(CAS.LYOEQDol,0) as LYOEQDol,
			isnull(CAS.LYEComQDol,0) as LYEComQDol,
			isnull(CAS.LYOEQOrders,0) as LYOEQOrders,
			isnull(CAS.LYEComQOrders,0) as LYEComQOrders,
			isnull(CAS.LYOEQLines,0) as LYOEQLines,
			isnull(CAS.LYEComQLines,0) as LYEComQLines,
			isnull(CAS.LYRGACount,0) as LYRGACount,
			isnull(CAS.LYCreditCount,0) as LYCreditCount,
			isnull(CAS.Prev3YrName,'') as Prev3YrName,
			isnull(CAS.Prev3YrSales,0) as Prev3YrSales,
			isnull(CAS.Prev3YrLbs,0) as Prev3YrLbs,
			isnull(CAS.Prev4YrName,'') as Prev4YrName,
			isnull(CAS.Prev4YrSales,0) as Prev4YrSales,
			isnull(CAS.Prev4YrLbs,0) as Prev4YrLbs
--			,CAS.*
	FROM	CustomerActivity CAS (NoLock)
	WHERE	CAS.LookupValue = @ChainCd AND
			CAS.RecordType = 'Chain' AND
			CAS.Period = @Period

	--Table[3] - Sales History By Category (Grid)
	SELECT	tSOHist.CatNo as GroupNo,
			tSOHist.CatDesc as GroupDesc,
			tSOHist.SalesCurYTD,
			tSOHist.CostCurYTD,
			tSOHist.AvgCostCurYTD,
			tSOHist.PriceCostCurYTD,
			tSOHist.WghtCurYTD,
			tSOHist.GMDlrCurYTD,
			tSOHist.AvgGMPctYTD,
			tSOHist.PriceGMPctYTD,
			tSOHist.DlrPerLbCurYTD,
			tSOHist.GMPerLbCurYTD,
			tSOHist.SalesCurMTD,
			tSOHist.CostCurMTD,
			tSOHist.AvgCostCurMTD,
			tSOHist.PriceCostCurMTD,
			tSOHist.WghtCurMTD,
			tSOHist.GMDlrCurMTD,
			tSOHist.AvgGMPctMTD,
			tSOHist.PriceGMPctMTD,
			tSOHist.DlrPerLbCurMTD,
			tSOHist.GMPerLbCurMTD,
			tSOHist.SalesLastYTD,
			tSOHist.SalesPrevYTD,
			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr
	FROM	#tSOHist tSOHist
	ORDER BY tSOHist.SalesCurYTD DESC, tSOHist.SalesLastYTD DESC, tSOHist.SalesPrevYTD DESC

	--Table[4] - Sales History By Buy Group (Grid)
	SELECT	tSOHistBuyGrp.*,
			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr
	FROM	(SELECT	tSOHist.BuyGroupNo as GroupNo,
					tSOHist.BuyGroupDesc as GroupDesc,
					SUM(tSOHist.SalesCurYTD) as SalesCurYTD,
					SUM(tSOHist.CostCurYTD) as CostCurYTD,
					SUM(tSOHist.AvgCostCurYTD) as AvgCostCurYTD,
					SUM(tSOHist.PriceCostCurYTD) as PriceCostCurYTD,
					SUM(tSOHist.WghtCurYTD) as WghtCurYTD,
					SUM(tSOHist.GMDlrCurYTD) as GMDlrCurYTD,
--					SUM(tSOHist.AvgGMPctYTD) as AvgGMPctYTD,
--					SUM(tSOHist.PriceGMPctYTD) as PriceGMPctYTD,
					CASE SUM(tSOHist.SalesCurYTD)
							WHEN 0 THEN 0
							ELSE (SUM(tSOHist.SalesCurYTD) - SUM(tSOHist.AvgCostCurYTD)) / SUM(tSOHist.SalesCurYTD)
					END as AvgGMPctYTD,
					CASE SUM(tSOHist.SalesCurYTD)
							WHEN 0 THEN 0
							ELSE (SUM(tSOHist.SalesCurYTD) - SUM(tSOHist.PriceCostCurYTD)) / SUM(tSOHist.SalesCurYTD)
					END as PriceGMPctYTD,
					SUM(tSOHist.DlrPerLbCurYTD) as DlrPerLbCurYTD,
					SUM(tSOHist.GMPerLbCurYTD) as GMPerLbCurYTD,
					SUM(tSOHist.SalesCurMTD) as SalesCurMTD,
					SUM(tSOHist.CostCurMTD) as CostCurMTD,
					SUM(tSOHist.AvgCostCurMTD) as AvgCostCurMTD,
					SUM(tSOHist.PriceCostCurMTD) as PriceCostCurMTD,
					SUM(tSOHist.WghtCurMTD) as WghtCurMTD,
					SUM(tSOHist.GMDlrCurMTD) as GMDlrCurMTD,
--					SUM(tSOHist.AvgGMPctMTD) as AvgGMPctMTD,
--					SUM(tSOHist.PriceGMPctMTD) as PriceGMPctMTD,
					CASE SUM(tSOHist.SalesCurMTD)
							WHEN 0 THEN 0
							ELSE (SUM(tSOHist.SalesCurMTD) - SUM(tSOHist.AvgCostCurMTD)) / SUM(tSOHist.SalesCurMTD)
					END as AvgGMPctMTD,
					CASE SUM(tSOHist.SalesCurMTD)
							WHEN 0 THEN 0
							ELSE (SUM(tSOHist.SalesCurMTD) - SUM(tSOHist.PriceCostCurMTD)) / SUM(tSOHist.SalesCurMTD)
					END as PriceGMPctMTD,
					SUM(tSOHist.DlrPerLbCurMTD) as DlrPerLbCurMTD,
					SUM(tSOHist.GMPerLbCurMTD) as GMPerLbCurMTD,
					SUM(tSOHist.SalesLastYTD) as SalesLastYTD,
					SUM(tSOHist.SalesPrevYTD) as SalesPrevYTD
			 FROM	#tSOHist tSOHist
			 GROUP BY tSOHist.BuyGroupNo, tSOHist.BuyGroupDesc) tSOHistBuyGrp
	ORDER BY tSOHistBuyGrp.SalesCurYTD DESC, tSOHistBuyGrp.SalesLastYTD DESC, tSOHistBuyGrp.SalesPrevYTD DESC

	DROP TABLE	#tCatList
	DROP TABLE	#tChainList
	DROP TABLE	#tItemBranch
	DROP TABLE	#tCurYTD
	DROP TABLE	#tCurMTD
	DROP TABLE	#tLastYTD
	DROP TABLE	#tPrevYTD
	DROP TABLE	#tSOHist


	--------------------------
	-- For Testing Purposes --
	--------------------------
	/*
	exec pCustActivityChain	'200912',		--Period
							'AAB'			--ChainCd

	*/
END
GO
