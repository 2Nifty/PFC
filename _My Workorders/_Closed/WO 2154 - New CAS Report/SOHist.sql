

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
@Period varchar(6),
@CustNo varchar(20)

set @Period='200904'
set @CustNo='107'


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
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurYTD and @EndCurYTD) tCurYTD
			GROUP BY tCurYTD.CatNo

			--#tCurMTD: Month To Date Sales
			SELECT	tCurMTD.CatNo,
					SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as SalesCurMTD,
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
					 WHERE	Cust.pCustMstrID = @CustNo AND
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
					 WHERE	Cust.pCustMstrID = @CustNo AND
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
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegPrevYTD and @EndPrevYTD) tPrevYTD
			GROUP BY tPrevYTD.CatNo


--select * from #tCurYTD
--select * from #tCurMTD
--select * from #tPrevYTD
--select * from #tLastYTD


			--#tSOHist: Sales History
			SELECT	isnull(Cat.CatNo,'') as CatNo,
					isnull(Cat.CatDesc,'') as CatDesc,
					isnull(Cat.BuyGroupNo,'') as BuyGroupNo,
					isnull(Cat.BuyGroupDesc,'') as BuyGroupDesc,
					isnull(tSOHist.SalesCurYTD,0) as SalesCurYTD,
					isnull(tSOHist.WghtCurYTD,0) as WghtCurYTD,
					isnull(tSOHist.GMDlrCurYTD,0) as GMDlrCurYTD,
					isnull(tSOHist.AvgGMPctYTD,0) as AvgGMPctYTD,
					isnull(tSOHist.PriceGMPctYTD,0) as PriceGMPctYTD,
					isnull(tSOHist.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
					isnull(tSOHist.GMPerLbCurYTD,0) as GMPerLbCurYTD,
					isnull(tSOHist.SalesCurMTD,0) as SalesCurMTD,
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
							tCurYTD.WghtCurYTD,
							tCurYTD.GMDlrCurYTD,
							tCurYTD.AvgGMPctYTD,
							tCurYTD.PriceGMPctYTD,
							tCurYTD.DlrPerLbCurYTD,
							tCurYTD.GMPerLbCurYTD,
							tCurMTD.SalesCurMTD,
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



select * from #tSOHist
where CatNo='00080'

			--Table[3] - Sales History By Category (Grid)
		--	SELECT	tSOHistCat.*,
		--			'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
		--			'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr


SELECT	tSOHist.CatNo as GroupNo,
		tSOHist.CatDesc as GroupDesc,
		SalesCurYTD,
		WghtCurYTD,
		GMDlrCurYTD,
		AvgGMPctYTD,
		PriceGMPctYTD,
		DlrPerLbCurYTD,
		GMPerLbCurYTD,
		SalesCurMTD,
		WghtCurMTD,
		GMDlrCurMTD,
		AvgGMPctMTD,
		PriceGMPctMTD,
		DlrPerLbCurMTD,
		GMPerLbCurMTD,
		SalesLastYTD,
		SalesPrevYTD,
		'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
		'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr
FROM	#tSOHist




SELECT	tSOHistCat.GroupNo,
		tSOHistCat.GroupDesc,
		SUM(tSOHistCat.SalesCurYTD) as SalesCurYTD,
		SUM(tSOHistCat.SalesCurMTD) as SalesCurMTD,
		SUM(tSOHistCat.SalesPrevYTD) as SalesLastYTD,
		SUM(tSOHistCat.WghtCurYTD) as WgthCurYTD,
		SUM(tSOHistCat.WghtCurMTD) as WghtCurMTD,
		SUM(tSOHistCat.GMDlrCurYTD) as GMDlrCurYTD,
		SUM(tSOHistCat.GMDlrCurMTD) as GMDlrCurMTD




			FROM	(SELECT	tSOHist.CatNo as GroupNo,
							tSOHist.CatDesc as GroupDesc,
							isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0) as SalesCurYTD,
							isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0) as SalesCurMTD,
							isnull(tSOHist.PriceLastYTD,0) * isnull(tSOHist.QtyLastYTD,0) as SalesLastYTD,
							isnull(tSOHist.PricePrevYTD,0) * isnull(tSOHist.QtyPrevYTD,0) as SalesPrevYTD,
							isnull(tSOHist.WghtCurYTD,0) * isnull(tSOHist.QtyCurYTD,0) as WghtCurYTD,
							isnull(tSOHist.WghtCurMTD,0) * isnull(tSOHist.QtyCurMTD,0) as WghtCurMTD,
							(isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) - (isnull(tSOHist.CostCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) as GMDlrCurYTD,
							(isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) - (isnull(tSOHist.CostCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) as GMDlrCurMTD,

							CASE (isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) - (isnull(tSOHist.AvgCostCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))) / (isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
							END as AvgGMPctYTD,

							CASE (isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) - (isnull(tSOHist.AvgCostCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))) / (isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
							END as AvgGMPctMTD,

							CASE (isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) - (isnull(tSOHist.PriceCostCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))) / (isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
							END as PriceGMPctYTD,

							CASE (isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) - (isnull(tSOHist.PriceCostCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))) / (isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
							END as PriceGMPctMTD,

							CASE (isnull(tSOHist.WghtCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE (isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) / (isnull(tSOHist.WghtCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
							END as DlrPerLbCurYTD,

							CASE (isnull(tSOHist.WghtCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurYTD,0) * isnull(tSOHist.QtyCurYTD,0)) - (isnull(tSOHist.CostCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))) / (isnull(tSOHist.WghtCurYTD,0) * isnull(tSOHist.QtyCurYTD,0))
							END as GMPerLbCurYTD,

							CASE (isnull(tSOHist.WghtCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE (isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) / (isnull(tSOHist.WghtCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
							END as DlrPerLbCurMTD,

							CASE (isnull(tSOHist.WghtCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tSOHist.PriceCurMTD,0) * isnull(tSOHist.QtyCurMTD,0)) - (isnull(tSOHist.CostCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))) / (isnull(tSOHist.WghtCurMTD,0) * isnull(tSOHist.QtyCurMTD,0))
							END as GMPerLbCurMTD
					 FROM	#tSOHist tSOHist (NoLock)) tSOHistCat





					 GROUP BY tSOHistCat.GroupNo, tSOHistCat.GroupDesc


					--ORDER BY tSOHistCat.SalesCurYTD DESC, tSOHistCat.SalesLastYTD DESC, tSOHistCat.SalesPrevYTD DESC



			DROP TABLE #tCurYTD
			DROP TABLE #tCurMTD
			DROP TABLE #tLastYTD
			DROP TABLE #tPrevYTD
			DROP TABLE #tSOHist
			DROP TABLE	#tCatList
			DROP TABLE	#tItemBranch

