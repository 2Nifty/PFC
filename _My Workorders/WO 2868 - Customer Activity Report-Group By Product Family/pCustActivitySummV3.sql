USE [PFCReports]
GO

drop proc [pCustActivitySummV3]
go

/****** Object:  StoredProcedure [dbo].[pCustActivitySummV3]    Script Date: 08/14/2012 13:38:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pCustActivitySummV3]
	@LocPeriod varchar(6),
	@Location varchar(2)
AS
DECLARE	@BegCurDt datetime,
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
		@YTDPer varchar(6),
		@BegLastYTDPer varchar(6),
		@EndLastYTDPer varchar(6),
		@BegPrevYTDPer varchar(6),
		@EndPrevYTDPer varchar(6),
		@LastFiscalMthBeginDt datetime,
		@LastFiscalMthEndDt datetime,
		@CuvnalYearMo varchar(6),
		@CuvnalYearMo12 varchar(6),
		@CuvSales decimal(13,4),
		@SQL nvarchar(4000)

BEGIN
	/* ======================================================	
	Author:         Tod Dixon
	Create date:    12/22/2010
	Description:    Returns Customer Activity for the specifiec @LocPeriod & @Location
	Tables:			[0] Customer Header Info [tblCust]
					[1] Customer AR Aging [tblAging]
					[2] Customer Sales Activity [tblHist]
					[3] Customer Sales History By Category [dtSOHistCat]
					[4] Customer Sales History By Buy Group [dtSOHistGrp]
					[5] Customer Sales History By Product Family [dtSOHistFam]

	Note:			This procedure runs against PFCSQLP.PFCReports & uses OpenDataSource 
					against PFCERPDB for ListMaster, ListDetail & Tables tables.

	Modified:       05/30/12 Sathish - WO2940 add Default GM %  value to grid result (TMD added here 8/23/12)
	Modified:       08/14/12 TDixon	 - WO2868 Return new table group by Product Family
	==========================================================

	--Exec pCustActivitySummV2 '201204','03'
	Exec pCustActivitySummV3 '201204','03'

	*/

	SET NOCOUNT ON;

	EXEC pCustActivityDatesV3	@Period = @LocPeriod,
								@BegCurDt = @BegCurDt OUTPUT,
								@EndCurDt = @EndCurDt OUTPUT,
								@BegLastDt = @BegLastDt OUTPUT,
								@EndLastDt = @EndLastDt OUTPUT,
								@BegPrevDt = @BegPrevDt OUTPUT,
								@EndPrevDt = @EndPrevDt OUTPUT,
								@BegCurYTD = @BegCurYTD OUTPUT,
								@EndCurYTD = @EndCurYTD OUTPUT,
								@BegCurMTD = @BegCurMTD OUTPUT,
								@EndCurMTD = @EndCurMTD OUTPUT,
								@LastPeriod = @LastPeriod OUTPUT,
								@LastYTD = @LastYTD OUTPUT,
								@BegLastYTD = @BegLastYTD OUTPUT,
								@EndLastYTD = @EndLastYTD OUTPUT,
								@PrevPeriod = @PrevPeriod OUTPUT,
								@PrevYTD = @PrevYTD OUTPUT,
								@BegPrevYTD = @BegPrevYTD OUTPUT,
								@EndPrevYTD = @EndPrevYTD OUTPUT,
								@LastFiscalMthBeginDt = @LastFiscalMthBeginDt OUTPUT,
								@LastFiscalMthEndDt = @LastFiscalMthEndDt OUTPUT,
								@CuvnalYearMo = @CuvnalYearMo OUTPUT,
								@CuvnalYearMo12 = @CuvnalYearMo12 OUTPUT,
								@YTDPer = @YTDPer OUTPUT,
								@BegLastYTDPer = @BegLastYTDPer OUTPUT,
								@EndLastYTDPer = @EndLastYTDPer OUTPUT,
								@BegPrevYTDPer = @BegPrevYTDPer OUTPUT,
								@EndPrevYTDPer = @EndPrevYTDPer OUTPUT

	--SET @CuvSales Value for DSO calculation
	SELECT	@CuvSales = SUM(ISNULL(CMSales,0))
	FROM	CustomerMaster Cust (NoLock) INNER JOIN
			CuvnalSum CuvnalSum (NoLock)
	ON		Cust.CustNo = CuvnalSum.CustNo
	WHERE  ((CURYEAR * 100) + CurMo) BETWEEN @CuvnalYearMo12 AND @CuvnalYearMo AND Cust.CustShipLocation = @Location
	--select @CuvSales


	------------------------------------
	-- Get Branch & Sales History Data --
	------------------------------------
	print 'Get Branch & Sales History Data'

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
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListMaster] LM INNER JOIN
					OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListDetail] LD
			 ON		LM.pListMasterID = LD.fListMasterID
			 WHERE	LM.ListName = 'CategoryDesc') tCatList LEFT OUTER JOIN
			CAS_CatGrpDesc BuyGrp (NoLock)
	ON		tCatList.CatNo = BuyGrp.Category

	--#tFamList: Load Product Families
	SELECT	IC.ITEMID as ItemNo,
			MAX(CC.Code) as ProdFamCd,
			MAX(CC.DESCR) as ProdFamDesc
	INTO	#tFamList
	FROM	CatalogChapter CC (NoLock) INNER JOIN
			ItemCatalog IC (NoLock)
	ON		IC.CHAPTER = CC.CODE
	GROUP BY IC.ITEMID

	--#tCurYTD: Current Year To Date Sales
	SELECT	CISS.ItemNo,
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
	FROM	tCustItemSalesSummary CISS (NoLock) LEFT OUTER JOIN
			CustomerMaster Cust (NoLock)
	ON		CISS.CustNo = Cust.CustNo
	WHERE	Cust.CustShipLocation = @Location AND
			FiscalPeriodNo BETWEEN @YTDPer and @LocPeriod
	GROUP BY CISS.ItemNo

	--#tCurMTD: Current Month To Date Sales
	SELECT	CISS.ItemNo,
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
	FROM	tCustItemSalesSummary CISS (NoLock) LEFT OUTER JOIN
			CustomerMaster Cust (NoLock)
	ON		CISS.CustNo = Cust.CustNo
	WHERE	Cust.CustShipLocation = @Location AND
			FiscalPeriodNo = @LocPeriod
	GROUP BY CISS.ItemNo

	--#tLastYTD: Last Year To Date Sales
	SELECT	CISS.ItemNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesLastYTD
	INTO	#tLastYTD
	FROM	tCustItemSalesSummary CISS (NoLock) LEFT OUTER JOIN
			CustomerMaster Cust (NoLock)
	ON		CISS.CustNo = Cust.CustNo
	WHERE	Cust.CustShipLocation = @Location AND
			FiscalPeriodNo BETWEEN @BegLastYTDPer and @EndLastYTDPer
	GROUP BY CISS.ItemNo

	--#tPrevYTD: 2 Years Previous YTD Sales
	SELECT	CISS.ItemNo,
			SUM(isnull(CISS.SalesDollars,0)) as SalesPrevYTD
	INTO	#tPrevYTD
	FROM	tCustItemSalesSummary CISS (NoLock) LEFT OUTER JOIN
			CustomerMaster Cust (NoLock)
	ON		CISS.CustNo = Cust.CustNo
	WHERE	Cust.CustShipLocation = @Location AND
			FiscalPeriodNo BETWEEN @BegPrevYTDPer and @EndPrevYTDPer
	GROUP BY CISS.ItemNo

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

	--UPDATE #tSOHist Category BuyGroup data
	UPDATE	#tSOHist
	SET		CatDesc = isnull(Cat.CatDesc,'** NoCat **'),
			BuyGroupNo = isnull(Cat.BuyGroupNo,''),
			BuyGroupDesc = isnull(Cat.BuyGroupDesc,'** NoGroup **')
	FROM	#tSOHist SO LEFT OUTER JOIN
			#tCatList Cat
	ON		SO.CatNo = Cat.CatNo

	--UPDATE #tSOHist ProductFamily data
	UPDATE	#tSOHist
	SET		ProdFam = isnull(Fam.ProdFamCd,'NO_FAM'),
			ProdFamDesc = isnull(Fam.ProdFamDesc,'** NoFamily **')
	FROM	#tSOHist SO LEFT OUTER JOIN
			#tFamList Fam
	ON		SO.ItemNo = Fam.ItemNo

	-----------------
	-- Main Tables --
	-----------------
	--Table[0] - Customer Header Data
	SELECT	99 as pCustMstrId,
			'xxxxx' as CustNo,
			0 as DefaultGrossMarginPct,
			'Branch-' + @Location as ChainCd,
			'Summary' as ChainName

	--Table[1] - Branch A/R Aging Data
	SELECT	BranchAging.Branch,
			isnull(BranchAging.CurrentAmt,0) as CurrentAmt,
			isnull(BranchAging.CurrentPct,0) as CurrentPct,
			isnull(BranchAging.Over30Amt,0) as Over30Amt,
			isnull(BranchAging.Over30Pct,0) as Over30Pct,
			isnull(BranchAging.Over60Amt,0) as Over60Amt,
			isnull(BranchAging.Over60Pct,0) as Over60Pct,
			isnull(BranchAging.Over90Amt,0) as Over90Amt,
			isnull(BranchAging.Over90Pct,0) as Over90Pct,
			isnull(BranchAging.BalanceDue,0) as BalanceDue,
			isnull(round((365 * (BranchAging.BalanceDue / @CuvSales)),0),0) as DSO
	FROM	(SELECT	tmpAging.Branch,
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
			 FROM	(SELECT	Cust.CustShipLocation as Branch,
							isnull(Aging.CurrentAmt,0) as CurrentAmt,
							isnull(Aging.Over30Amt,0) as Over30Amt,
							isnull(Aging.Over60Amt,0) as Over60Amt,
							isnull(Aging.Over90Amt,0) as Over90Amt,
							isnull(Aging.BalanceDue,0) as BalanceDue
					 FROM	CustomerMaster Cust (NoLock) INNER JOIN
							ARAging Aging (NoLock)
					 ON		Cust.CustNo = Aging.CustNo
					 WHERE	Cust.CustShipLocation = @Location) tmpAging
			 GROUP BY tmpAging.Branch) BranchAging

	--Table[2] - Sales Activity By Branch
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
			isnull(CAS.CMSalesPerLb,0) as CMSalesPerLb,
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
			isnull(CAS.LMSalesPerLb,0) as LMSalesPerLb,
			isnull(CAS.LMGMPerLb,0) as LMGMPerLb,
			isnull(CAS.LMAvgDolPerOrder,0) as LMAvgDolPerOrder,
			isnull(CAS.LMAvgDolPerLine,0) as LMAvgDolPerLine,
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
			isnull(CAS.CYSalesPerLb,0) as CYSalesPerLb,
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
			isnull(CAS.LYSalesPerLb,0) as LYSalesPerLb,
			isnull(CAS.LYGMPerLb,0) as LYGMPerLb,
			isnull(CAS.LYAvgDolPerOrder,0) as LYAvgDolPerOrder,
			isnull(CAS.LYAvgDolPerLine,0) as LYAvgDolPerLine,
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
	FROM	CustomerActivity CAS (NoLock)
	WHERE	CAS.LookupValue = 'Branch-' + @Location AND
			CAS.RecordType = 'Summ' AND
			CAS.Period = @LocPeriod

	--Table[3] - Sales History By Category (Grid)
	SELECT	tSOHistCat.*,
			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr,
			'' as DefaultGMPct
	FROM	(SELECT	Cast(tSOHist.CatNo as varchar(50)) as GroupNo,
					tSOHist.CatDesc as GroupDesc,
					SUM(isnull(tSOHist.SalesCurYTD,0)) as SalesCurYTD,
					SUM(isnull(tSOHist.CostCurYTD,0)) as CostCurYTD,
					SUM(isnull(tSOHist.AvgCostCurYTD,0)) as AvgCostCurYTD,
					SUM(isnull(tSOHist.PriceCostCurYTD,0)) as PriceCostCurYTD,
					SUM(isnull(tSOHist.WghtCurYTD,0)) as WghtCurYTD,
					SUM(isnull(tSOHist.GMDlrCurYTD,0)) as GMDlrCurYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.AvgCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as AvgGMPctYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.PriceCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as PriceGMPctYTD,
					SUM(isnull(tSOHist.DlrPerLbCurYTD,0)) as DlrPerLbCurYTD,
					SUM(isnull(tSOHist.GMPerLbCurYTD,0)) as GMPerLbCurYTD,
					SUM(isnull(tSOHist.SalesCurMTD,0)) as SalesCurMTD,
					SUM(isnull(tSOHist.CostCurMTD,0)) as CostCurMTD,
					SUM(isnull(tSOHist.AvgCostCurMTD,0)) as AvgCostCurMTD,
					SUM(isnull(tSOHist.PriceCostCurMTD,0)) as PriceCostCurMTD,
					SUM(isnull(tSOHist.WghtCurMTD,0)) as WghtCurMTD,
					SUM(isnull(tSOHist.GMDlrCurMTD,0)) as GMDlrCurMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.AvgCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as AvgGMPctMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.PriceCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as PriceGMPctMTD,
					SUM(isnull(tSOHist.DlrPerLbCurMTD,0)) as DlrPerLbCurMTD,
					SUM(isnull(tSOHist.GMPerLbCurMTD,0)) as GMPerLbCurMTD,
					SUM(isnull(tSOHist.SalesLastYTD,0)) as SalesLastYTD,
					SUM(isnull(tSOHist.SalesPrevYTD,0)) as SalesPrevYTD
			 FROM	#tSOHist tSOHist
			 GROUP BY Cast(tSOHist.CatNo as varchar(50)), tSOHist.CatDesc) tSOHistCat
	ORDER BY tSOHistCat.SalesCurYTD DESC, tSOHistCat.SalesLastYTD DESC, tSOHistCat.SalesPrevYTD DESC

	--Table[4] - Sales History By Buy Group (Grid)
	SELECT	tSOHistBuyGrp.*,
			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr,
			'' as DefaultGMPct
	FROM	(SELECT	tSOHist.BuyGroupNo as GroupNo,
					tSOHist.BuyGroupDesc as GroupDesc,
					SUM(isnull(tSOHist.SalesCurYTD,0)) as SalesCurYTD,
					SUM(isnull(tSOHist.CostCurYTD,0)) as CostCurYTD,
					SUM(isnull(tSOHist.AvgCostCurYTD,0)) as AvgCostCurYTD,
					SUM(isnull(tSOHist.PriceCostCurYTD,0)) as PriceCostCurYTD,
					SUM(isnull(tSOHist.WghtCurYTD,0)) as WghtCurYTD,
					SUM(isnull(tSOHist.GMDlrCurYTD,0)) as GMDlrCurYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.AvgCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as AvgGMPctYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.PriceCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as PriceGMPctYTD,
					SUM(isnull(tSOHist.DlrPerLbCurYTD,0)) as DlrPerLbCurYTD,
					SUM(isnull(tSOHist.GMPerLbCurYTD,0)) as GMPerLbCurYTD,
					SUM(isnull(tSOHist.SalesCurMTD,0)) as SalesCurMTD,
					SUM(isnull(tSOHist.CostCurMTD,0)) as CostCurMTD,
					SUM(isnull(tSOHist.AvgCostCurMTD,0)) as AvgCostCurMTD,
					SUM(isnull(tSOHist.PriceCostCurMTD,0)) as PriceCostCurMTD,
					SUM(isnull(tSOHist.WghtCurMTD,0)) as WghtCurMTD,
					SUM(isnull(tSOHist.GMDlrCurMTD,0)) as GMDlrCurMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.AvgCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as AvgGMPctMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.PriceCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as PriceGMPctMTD,
					SUM(isnull(tSOHist.DlrPerLbCurMTD,0)) as DlrPerLbCurMTD,
					SUM(isnull(tSOHist.GMPerLbCurMTD,0)) as GMPerLbCurMTD,
					SUM(isnull(tSOHist.SalesLastYTD,0)) as SalesLastYTD,
					SUM(isnull(tSOHist.SalesPrevYTD,0)) as SalesPrevYTD
			 FROM	#tSOHist tSOHist
			 GROUP BY tSOHist.BuyGroupNo, tSOHist.BuyGroupDesc) tSOHistBuyGrp
	ORDER BY tSOHistBuyGrp.SalesCurYTD DESC, tSOHistBuyGrp.SalesLastYTD DESC, tSOHistBuyGrp.SalesPrevYTD DESC

	--Table[5] - Sales History By Product Family (Grid)
	SELECT	tSOHistProdFam.*,
			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr,
			'' as DefaultGMPct
	FROM	(SELECT	tSOHist.ProdFam as GroupNo,
					tSOHist.ProdFamDesc as GroupDesc,
					SUM(isnull(tSOHist.SalesCurYTD,0)) as SalesCurYTD,
					SUM(isnull(tSOHist.CostCurYTD,0)) as CostCurYTD,
					SUM(isnull(tSOHist.AvgCostCurYTD,0)) as AvgCostCurYTD,
					SUM(isnull(tSOHist.PriceCostCurYTD,0)) as PriceCostCurYTD,
					SUM(isnull(tSOHist.WghtCurYTD,0)) as WghtCurYTD,
					SUM(isnull(tSOHist.GMDlrCurYTD,0)) as GMDlrCurYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.AvgCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as AvgGMPctYTD,
					CASE SUM(isnull(tSOHist.SalesCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurYTD,0)) - SUM(isnull(tSOHist.PriceCostCurYTD,0))) / SUM(isnull(tSOHist.SalesCurYTD,0))
					END as PriceGMPctYTD,
					SUM(isnull(tSOHist.DlrPerLbCurYTD,0)) as DlrPerLbCurYTD,
					SUM(isnull(tSOHist.GMPerLbCurYTD,0)) as GMPerLbCurYTD,
					SUM(isnull(tSOHist.SalesCurMTD,0)) as SalesCurMTD,
					SUM(isnull(tSOHist.CostCurMTD,0)) as CostCurMTD,
					SUM(isnull(tSOHist.AvgCostCurMTD,0)) as AvgCostCurMTD,
					SUM(isnull(tSOHist.PriceCostCurMTD,0)) as PriceCostCurMTD,
					SUM(isnull(tSOHist.WghtCurMTD,0)) as WghtCurMTD,
					SUM(isnull(tSOHist.GMDlrCurMTD,0)) as GMDlrCurMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.AvgCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as AvgGMPctMTD,
					CASE SUM(isnull(tSOHist.SalesCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tSOHist.SalesCurMTD,0)) - SUM(isnull(tSOHist.PriceCostCurMTD,0))) / SUM(isnull(tSOHist.SalesCurMTD,0))
					END as PriceGMPctMTD,
					SUM(isnull(tSOHist.DlrPerLbCurMTD,0)) as DlrPerLbCurMTD,
					SUM(isnull(tSOHist.GMPerLbCurMTD,0)) as GMPerLbCurMTD,
					SUM(isnull(tSOHist.SalesLastYTD,0)) as SalesLastYTD,
					SUM(isnull(tSOHist.SalesPrevYTD,0)) as SalesPrevYTD
			 FROM	#tSOHist tSOHist
			 GROUP BY tSOHist.ProdFam, tSOHist.ProdFamDesc) tSOHistProdFam
	ORDER BY tSOHistProdFam.SalesCurYTD DESC, tSOHistProdFam.SalesLastYTD DESC, tSOHistProdFam.SalesPrevYTD DESC

	DROP TABLE	#tCatList
	DROP TABLE	#tFamList
	DROP TABLE	#tCurYTD
	DROP TABLE	#tCurMTD
	DROP TABLE	#tLastYTD
	DROP TABLE	#tPrevYTD
	DROP TABLE	#tSOHist
END
