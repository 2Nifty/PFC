create	Procedure [dbo].[pCustPriceGetHist]
	@CustNo varchar(20)
as
/*
	==================================================================================================================
	Author:	Tom Slater
	Create date: 3/15/2010
	Description: Get Customer Price History for Category Price Schedule Maintenance
	(Derived from pWO1755_GetCustData Written By Charles Rojas - Create Date: 02/19/10)
	(TMD-Originally programmed to return 3Mo Sales (Price) History by Customer; Grouped by BuyGroupNo)

	Modified 03/31/10 (TMD-WO1805)	-Added SELECT for 2nd table (TABLE[1]) to return Price Schedules
	Modified 06/29/10 (TMD-WO1832)	-Created table UNION to return data GROUPed BY both CatNo and BuyGroupNo
	Modified 10/05/10 (TMD-WO2002)	-Removed date functions from the WHERE statements
					-Added initial setup to load @Beg3MoDate, @End3MoDate,
					    @Beg12MoDate & @End12MoDate FROM FiscalCalendar
					-Added table JOINs to return SalesHistory12Mo & GMPctPriceCost12Mo
	Modified 11/05/10 (TMD-WO2152)	-Use CM.CustName instead of SOH.SellToCustName for SOHist Grouping
					-Removed inner SELECTs that were returning the 3Mo and 12Mo SOHist
					    (SOHist data will be stored in temp tables as described below)
					-Added initial setup to load temp tables with 12Mo SOHist for selected Customer
					    (#SalesByCat & #SalesByGrp, Grouped by CatNo & GroupNo respectively)
					-Removed references to CompetitorPrice table
					    (Originally used for Low Cost Leader Items)
					-Added UPDATE for Items where CustomerPrice.CustNo='LLL'
					    (Reflects Low Cost Leader Items)
					-Added calculations to return Margin @ Average Cost (GMPctAvgCost)
					-Added table JOINs to return SalesHistoryTot, GMPctPriceCostTot & GMPctAvgCostTot
					    (Reflects 3Mo SOHist INCLUDING Low Cost Leader Items)
					-Added table JOINs to return SalesHistoryEComm, GMPctPriceCostEComm & GMPctAvgCostEComm
					    (Reflects 3Mo SOHist for E-Commerce Orders Only)
	==================================================================================================================

	exec pCustPriceGetHist '065251'
*/


BEGIN
	DECLARE	@RecsFound BIGINT
	SET	@RecsFound = 0

	--See if there are any approval records waiting
	SELECT	@RecsFound = count(*)
	FROM	UnprocessedCategoryPrice (NoLock)
	WHERE	CustomerNo = @CustNo

	IF ISNULL(@RecsFound,0) > 0
	   BEGIN
		----------------------------------
		--    *** Begin TABLE[0] ***    --
		-----------------------------------------------------------
		--    Unprocessed records in UnprocessedCategoryPrice    --
		-----------------------------------------------------------
		SELECT	pUnprocessedCategoryPriceID,
			Branch,
			CustomerNo,
			CustomerName,
			GroupType,
			GroupNo,
			GroupDesc,
			BuyGroupNo,
			BuyGroupDesc,
			SalesHistory,
			GMPctPriceCost,
			GMPctAvgCost,
			SalesHistoryTot,
			GMPctPriceCostTot,
			GMPctAvgCostTot,
			SalesHistoryEComm,
			GMPctPriceCostEComm,
			GMPctAvgCostEComm,
			SalesHistory12Mo,
			GMPctPriceCost12Mo,
			GMPctAvgCost12Mo,
			TargetGMPct,
			Approved,
			EntryID,
			EntryDt,
			ChangeID,
			ChangeDt,
			StatusCd,
			ISNULL(ExistingCustPricePct,-1) as ExistingCustPricePct,
			'1' as RecType
		FROM	UnprocessedCategoryPrice (NoLock)
		WHERE	CustomerNo = @CustNo
		ORDER BY CustomerNo, SalesHistory desc
		--------------------------------
		--    *** End TABLE[0] ***    --
		--------------------------------
	   END
	ELSE
	   BEGIN

--drop table #12MoSalesByCat
--drop table #12MoSalesByGrp
--drop table #SalesByCat
--drop table #SalesByGrp

		---------------------------------------
		--    *** Begin Sales History ***    --
		---------------------------------------------------------
		--    Load local date variables FROM FiscalCalendar    --
		---------------------------------------------------------
		DECLARE	@Beg3MoDate DATETIME,
			@End3MoDate DATETIME,
			@Beg12MoDate DATETIME,
			@End12MoDate DATETIME

		--Beg3MoDate
		SELECT	DISTINCT @Beg3MoDate = CurFiscalMthBeginDt
		FROM 	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN (SELECT (DATEPART(yyyy,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			    FROM   FiscalCalendar
			    WHERE  CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		--End3MoDate
		SELECT	DISTINCT @End3MoDate = CurFiscalMthEndDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN (SELECT (DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			    FROM   FiscalCalendar
			    WHERE  CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		--Beg12MoDate
		SELECT	DISTINCT @Beg12MoDate = CurFiscalMthBeginDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN (SELECT (DATEPART(yyyy,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			    FROM   FiscalCalendar
			    WHERE  CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		--End12MoDate
		SELECT	DISTINCT @End12MoDate = CurFiscalMthEndDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN (SELECT (DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			    FROM   FiscalCalendar
			    WHERE  CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

--select @Beg3MoDate as Beg3MoDate, @End3MoDate as End3MoDate, @Beg12MoDate as Beg12MoDate, @End12MoDate as End12MoDate

--declare @CustNo varchar(20)
--set @CustNo='065251'


		------------------------------------------------------------
		--    Build 12Mo BULK Sales data for selected Customer    --
		------------------------------------------------------------

		--Group by Category (#12MoSalesByCat)
		SELECT	SOH.SellToCustNo as CustNo,
			CM.CustShipLocation as Branch,
--			SOH.SellToCustName as CustName, 
			CM.CustName,
			SOD.ItemNo,
			LEFT(SOD.ItemNo,5) as CatNo,
--			IM.CatDesc,
			ISNULL(CatList.CatDesc,'N/A') as CatDesc,
			ISNULL(CAST(CAS.GroupNo as VARCHAR(10)),'N/A') as BuyGroupNo,
			ISNULL(CAS.[Description],'N/A') as BuyGroupDesc,
			ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
			END as PriceGMDol,
			SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost as AvgGMDol,
			Price.DiscPct as ExistingCustPricePct,
			SOH.ARPostDt,
			SOH.OrderSource,
			ISNULL(SourceList.SourceSeq,'') as OrderSourceSeq,
			'     ' as LLInd
		INTO	#12MoSalesByCat
		FROM	ItemBranch IB (NoLock) INNER JOIN
			SOHeaderHist SOH (NoLock) INNER JOIN
			SODetailHist SOD (NoLock)
		ON	SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
		ON	SOD.ItemNo = IM.ItemNo
		ON	IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
			CategoryBuyGroups CAS (NoLock)
		ON	CAS.Category = LEFT(SOD.ItemNo,5) INNER JOIN
			CustomerMaster CM (NoLock)
		ON	CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
--			CompetitorPrice CP (NoLock)
--		ON	CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
			CustomerPrice Price (NoLock)
		ON	(Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) or Price.ItemNo = CAS.Category) AND Price.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
			(SELECT	LD.ListValue AS CatNo, LD.ListDtlDesc AS CatDesc
			 FROM	ListMaster (NoLock) LM INNER JOIN
				ListDetail (NoLock) LD
			 ON	LM.pListMasterID = LD.fListMasterID
			 WHERE	LM.ListName = 'CategoryDesc') CatList
		ON  	CatList.CatNo = LEFT(SOD.ItemNo,5) LEFT OUTER JOIN
			(SELECT	LD.ListValue AS Source, LD.ListDtlDesc AS SourceDesc, LD.SequenceNo AS SourceSeq
			 FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			 ON	LM.pListMasterId = LD.fListMasterId
			 WHERE	LM.ListName = 'SOEOrderSource') SourceList
		ON	SourceList.Source = SOH.OrderSource
			--Use last 12 closed months of Sales Invoice data, Bulk Only
		WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
			(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
--			CASE WHEN CP.PFCItem is null
--			     THEN ''
--			     ELSE 'Skip'
--			END <> 'SKIP' AND
			SOH.SellToCustNo = @CustNo

		--UPDATE Low Cost Leader Items
		UPDATE	#12MoSalesByCat
		SET	LLInd = Price.CustNo
		FROM	CustomerPrice Price
		WHERE	#12MoSalesByCat.ItemNo = Price.ItemNo AND
			Price.CustNo = 'LLL'

--select * from #12MoSalesByCat
--drop table #12MoSalesByCat


		--Group by Buy Group (#12MoSalesByGrp)
		SELECT	SOH.SellToCustNo as CustNo,
			CM.CustShipLocation as Branch,
--			SOH.SellToCustName as CustName, 
			CM.CustName,
			SOD.ItemNo,
--			CAS.GroupNo,
			ISNULL(CAST(CAS.GroupNo as VARCHAR(10)),'N/A') as GroupNo,
			ISNULL(CAS.[Description],'N/A') as GroupDesc,
			ISNULL(CAST(CAS.GroupNo as VARCHAR(10)),'N/A') as BuyGroupNo,
			ISNULL(CAS.[Description],'N/A') as BuyGroupDesc,
			ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
			END as PriceGMDol,
			SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost as AvgGMDol,
			Price.DiscPct as ExistingCustPricePct,
			SOH.ARPostDt,
			SOH.OrderSource,
			ISNULL(SourceList.SourceSeq,'') as OrderSourceSeq,
			'     ' as LLInd
		INTO	#12MoSalesByGrp
		FROM	ItemBranch IB (NoLock) INNER JOIN
			SOHeaderHist SOH (NoLock) INNER JOIN
			SODetailHist SOD (NoLock)
		ON	SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
			ItemMaster IM (NoLock)
		ON	SOD.ItemNo = IM.ItemNo
		ON	IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
			CategoryBuyGroups CAS (NoLock)
		ON	CAS.Category = LEFT(SOD.ItemNo,5) INNER JOIN
			CustomerMaster CM (NoLock)
		ON	CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
--			CompetitorPrice CP (NoLock)
--		ON	CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
			CustomerPrice Price (NoLock)
		ON	(Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) or Price.ItemNo = CAS.Category) AND Price.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
			(SELECT	LD.ListValue AS Source, LD.ListDtlDesc AS SourceDesc, LD.SequenceNo AS SourceSeq
			 FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			 ON	LM.pListMasterId = LD.fListMasterId
			 WHERE	LM.ListName = 'SOEOrderSource') SourceList
		ON	SourceList.Source = SOH.OrderSource
			--Use last 12 closed months of Sales Invoice data, Bulk Only
		WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
			(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
--			CASE WHEN CP.PFCItem is null
--			     THEN ''
--			     ELSE 'Skip'
--			END <> 'SKIP' AND
			SOH.SellToCustNo = @CustNo

		--UPDATE Low Cost Leader Items
		UPDATE	#12MoSalesByGrp
		SET	LLInd = Price.CustNo
		FROM	CustomerPrice Price
		WHERE	#12MoSalesByGrp.ItemNo = Price.ItemNo AND
			Price.CustNo = 'LLL'

--select * from #12MoSalesByGrp
--drop table #12MoSalesByGrp


		-------------------------------------------------------
		--    JOIN Sales data for specific date GROUPings    --
		--     + 12Mo Sales EXCLUDING Low Cost Leaders       --
		--     +  3Mo Sales EXCLUDING Low Cost Leaders       --
		--     +  3Mo Sales INCLUDING Low Cost Leaders       --
		--     +  3Mo Sales E-Commerce Only                  --
		-------------------------------------------------------

		--Group by Category (#SalesByCat)
		SELECT	tCatSales12MoSum.CustNo,
			tCatSales12MoSum.CustName,
			tCatSales12MoSum.Branch,
			tCatSales12MoSum.GroupNo,
			tCatSales12MoSum.GroupDesc,
			tCatSales12MoSum.BuyGroupNo,
			tCatSales12MoSum.BuyGroupDesc,
			tCatSales12MoSum.ExistingCustPricePct,
			ISNULL(tCatSales12MoSum.GroupSales12Mo,0) as GroupSales12Mo,
			ISNULL(tCatSales12MoSum.PriceCostGMPct12Mo,0) as PriceCostGMPct12Mo,
			ISNULL(tCatSales12MoSum.AvgCostGMPct12Mo,0) as AvgCostGMPct12Mo,
			ISNULL(tCatSalesSum.GroupSales,0) as GroupSales,
			ISNULL(tCatSalesSum.PriceCostGMPct,0) as PriceCostGMPct,
			ISNULL(tCatSalesSum.AvgCostGMPct,0) as AvgCostGMPct,
			ISNULL(tCatSalesTotSum.GroupSalesTot,0) as GroupSalesTot,
			ISNULL(tCatSalesTotSum.PriceCostGMPctTot,0) as PriceCostGMPctTot,
			ISNULL(tCatSalesTotSum.AvgCostGMPctTot,0) as AvgCostGMPctTot,
			ISNULL(tCatSalesECommSum.GroupSalesEComm,0) as GroupSalesEComm,
			ISNULL(tCatSalesECommSum.PriceCostGMPctEComm,0) as PriceCostGMPctEComm,
			ISNULL(tCatSalesECommSum.AvgCostGMPctEComm,0) as AvgCostGMPctEComm
		INTO	#SalesByCat
		FROM	--12Mo Sales EXCLUDING Low Cost Leaders: tCatSales12MoSum
			(SELECT	tCatSales12Mo.CustNo,
				tCatSales12Mo.CustName,
				tCatSales12Mo.Branch,
				tCatSales12Mo.CatNo as GroupNo,
				tCatSales12Mo.CatDesc as GroupDesc,
				tCatSales12Mo.BuyGroupNo,
				tCatSales12Mo.BuyGroupDesc,
				SUM(ISNULL(tCatSales12Mo.Sales,0)) as GroupSales12Mo,
				CASE WHEN SUM(ISNULL(tCatSales12Mo.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSales12Mo.PriceGMDol,0)) / SUM(ISNULL(tCatSales12Mo.Sales,0))
				END as PriceCostGMPct12Mo,
				CASE WHEN SUM(ISNULL(tCatSales12Mo.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSales12Mo.AvgGMDol,0)) / SUM(ISNULL(tCatSales12Mo.Sales,0))
				END as AvgCostGMPct12Mo,
				MAX(ISNULL(tCatSales12Mo.ExistingCustPricePct,-1)) as ExistingCustPricePct
			 FROM	(SELECT	*
				 FROM	#12MoSalesByCat (NoLock)
				 WHERE	LLInd <> 'LLL') tCatSales12Mo
			 GROUP BY tCatSales12Mo.CustNo, tCatSales12Mo.CustName, tCatSales12Mo.Branch, tCatSales12Mo.CatNo, tCatSales12Mo.CatDesc,
				  tCatSales12Mo.BuyGroupNo, tCatSales12Mo.BuyGroupDesc) tCatSales12MoSum LEFT OUTER JOIN

			--3Mo Sales EXCLUDING Low Cost Leaders: tCatSalesSum
			(SELECT	tCatSales.CatNo as GroupNo,
				SUM(ISNULL(tCatSales.Sales,0)) as GroupSales,
				CASE WHEN SUM(ISNULL(tCatSales.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSales.PriceGMDol,0)) / SUM(ISNULL(tCatSales.Sales,0))
				END as PriceCostGMPct,
				CASE WHEN SUM(ISNULL(tCatSales.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSales.AvgGMDol,0)) / SUM(ISNULL(tCatSales.Sales,0))
				END as AvgCostGMPct
			 FROM	(SELECT	*
				 FROM	#12MoSalesByCat (NoLock)
				 WHERE	LLInd <> 'LLL' AND
					(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tCatSales
			 GROUP BY tCatSales.CatNo) tCatSalesSum
			ON	tCatSales12MoSum.GroupNo = tCatSalesSum.GroupNo LEFT OUTER JOIN

			--3Mo Sales INCLUDING Low Cost Leaders: tCatSalesTotSum
			(SELECT	tCatSalesTot.CatNo as GroupNo,
				SUM(ISNULL(tCatSalesTot.Sales,0)) as GroupSalesTot,
				CASE WHEN SUM(ISNULL(tCatSalesTot.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSalesTot.PriceGMDol,0)) / SUM(ISNULL(tCatSalesTot.Sales,0))
				END as PriceCostGMPctTot,
				CASE WHEN SUM(ISNULL(tCatSalesTot.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSalesTot.AvgGMDol,0)) / SUM(ISNULL(tCatSalesTot.Sales,0))
				END as AvgCostGMPctTot
			 FROM	(SELECT	*
				 FROM	#12MoSalesByCat (NoLock)
				 WHERE	(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tCatSalesTot
			 GROUP BY tCatSalesTot.CatNo) tCatSalesTotSum
			ON	tCatSales12MoSum.GroupNo = tCatSalesTotSum.GroupNo LEFT OUTER JOIN

			--3Mo Sales E-Commerce Only: tCatSalesECommSum
		 	(SELECT	tCatSalesEComm.CatNo as GroupNo,
				SUM(ISNULL(tCatSalesEComm.Sales,0)) as GroupSalesEComm,
				CASE WHEN SUM(ISNULL(tCatSalesEComm.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSalesEComm.PriceGMDol,0)) / SUM(ISNULL(tCatSalesEComm.Sales,0))
				END as PriceCostGMPctEComm,
				CASE WHEN SUM(ISNULL(tCatSalesEComm.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tCatSalesEComm.AvgGMDol,0)) / SUM(ISNULL(tCatSalesEComm.Sales,0))
				END as AvgCostGMPctEComm
			 FROM	(SELECT	*
				 FROM	#12MoSalesByCat (NoLock)
				 WHERE	OrderSourceSeq = '1' AND LLInd <> 'LLL' AND
					(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tCatSalesEComm
			 GROUP BY tCatSalesEComm.CatNo) tCatSalesECommSum
			ON	tCatSales12MoSum.GroupNo = tCatSalesECommSum.GroupNo

--select * from #SalesByCat
--drop table #SalesByCat


		--Group by Buy Group (#SalesByGrp)
		SELECT	tGrpSales12MoSum.CustNo,
			tGrpSales12MoSum.CustName,
			tGrpSales12MoSum.Branch,
			tGrpSales12MoSum.GroupNo,
			tGrpSales12MoSum.GroupDesc,
			tGrpSales12MoSum.BuyGroupNo,
			tGrpSales12MoSum.BuyGroupDesc,
			tGrpSales12MoSum.ExistingCustPricePct,
			ISNULL(tGrpSales12MoSum.GroupSales12Mo,0) as GroupSales12Mo,
			ISNULL(tGrpSales12MoSum.PriceCostGMPct12Mo,0) as PriceCostGMPct12Mo,
			ISNULL(tGrpSales12MoSum.AvgCostGMPct12Mo,0) as AvgCostGMPct12Mo,
			ISNULL(tGrpSalesSum.GroupSales,0) as GroupSales,
			ISNULL(tGrpSalesSum.PriceCostGMPct,0) as PriceCostGMPct,
			ISNULL(tGrpSalesSum.AvgCostGMPct,0) as AvgCostGMPct,
			ISNULL(tGrpSalesTotSum.GroupSalesTot,0) as GroupSalesTot,
			ISNULL(tGrpSalesTotSum.PriceCostGMPctTot,0) as PriceCostGMPctTot,
			ISNULL(tGrpSalesTotSum.AvgCostGMPctTot,0) as AvgCostGMPctTot,
			ISNULL(tGrpSalesECommSum.GroupSalesEComm,0) as GroupSalesEComm,
			ISNULL(tGrpSalesECommSum.PriceCostGMPctEComm,0) as PriceCostGMPctEComm,
			ISNULL(tGrpSalesECommSum.AvgCostGMPctEComm,0) as AvgCostGMPctEComm
		INTO	#SalesByGrp
		FROM	--12Mo Sales EXCLUDING Low Cost Leaders: tGrpSales12MoSum
			(SELECT	tGrpSales12Mo.CustNo,
				tGrpSales12Mo.CustName,
				tGrpSales12Mo.Branch,
				tGrpSales12Mo.GroupNo,
				tGrpSales12Mo.GroupDesc,
				tGrpSales12Mo.BuyGroupNo,
				tGrpSales12Mo.BuyGroupDesc,
				SUM(ISNULL(tGrpSales12Mo.Sales,0)) as GroupSales12Mo,
				CASE WHEN SUM(ISNULL(tGrpSales12Mo.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSales12Mo.PriceGMDol,0)) / SUM(ISNULL(tGrpSales12Mo.Sales,0))
				END as PriceCostGMPct12Mo,
				CASE WHEN SUM(ISNULL(tGrpSales12Mo.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSales12Mo.AvgGMDol,0)) / SUM(ISNULL(tGrpSales12Mo.Sales,0))
				END as AvgCostGMPct12Mo,
				MAX(ISNULL(tGrpSales12Mo.ExistingCustPricePct,-1)) as ExistingCustPricePct
			 FROM	(SELECT	*
				 FROM	#12MoSalesByGrp (NoLock)
				 WHERE	LLInd <> 'LLL') tGrpSales12Mo
			 GROUP BY tGrpSales12Mo.CustNo, tGrpSales12Mo.CustName, tGrpSales12Mo.Branch, tGrpSales12Mo.GroupNo, tGrpSales12Mo.GroupDesc,
				  tGrpSales12Mo.BuyGroupNo, tGrpSales12Mo.BuyGroupDesc) tGrpSales12MoSum LEFT OUTER JOIN

			--3Mo Sales EXCLUDING Low Cost Leaders: tGrpSalesSum
			(SELECT	tGrpSales.GroupNo,
				SUM(ISNULL(tGrpSales.Sales,0)) as GroupSales,
				CASE WHEN SUM(ISNULL(tGrpSales.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSales.PriceGMDol,0)) / SUM(ISNULL(tGrpSales.Sales,0))
				END as PriceCostGMPct,
				CASE WHEN SUM(ISNULL(tGrpSales.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSales.AvgGMDol,0)) / SUM(ISNULL(tGrpSales.Sales,0))
				END as AvgCostGMPct
			 FROM	(SELECT	*
				 FROM	#12MoSalesByGrp (NoLock)
				 WHERE	LLInd <> 'LLL' AND
					(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tGrpSales
			 GROUP BY tGrpSales.GroupNo) tGrpSalesSum
			ON	tGrpSales12MoSum.GroupNo = tGrpSalesSum.GroupNo LEFT OUTER JOIN

			--3Mo Sales INCLUDING Low Cost Leaders: tGrpSalesTotSum
			(SELECT	tGrpSalesTot.GroupNo,
				SUM(ISNULL(tGrpSalesTot.Sales,0)) as GroupSalesTot,
				CASE WHEN SUM(ISNULL(tGrpSalesTot.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSalesTot.PriceGMDol,0)) / SUM(ISNULL(tGrpSalesTot.Sales,0))
				END as PriceCostGMPctTot,
				CASE WHEN SUM(ISNULL(tGrpSalesTot.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSalesTot.AvgGMDol,0)) / SUM(ISNULL(tGrpSalesTot.Sales,0))
				END as AvgCostGMPctTot
			 FROM	(SELECT	*
				 FROM	#12MoSalesByGrp (NoLock)
				 WHERE	(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tGrpSalesTot
			 GROUP BY tGrpSalesTot.GroupNo) tGrpSalesTotSum
			ON	tGrpSales12MoSum.GroupNo = tGrpSalesTotSum.GroupNo LEFT OUTER JOIN

			--3Mo Sales E-Commerce Only: tGrpSalesECommSum
		 	(SELECT	tGrpSalesEComm.GroupNo,
				SUM(ISNULL(tGrpSalesEComm.Sales,0)) as GroupSalesEComm,
				CASE WHEN SUM(ISNULL(tGrpSalesEComm.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSalesEComm.PriceGMDol,0)) / SUM(ISNULL(tGrpSalesEComm.Sales,0))
				END as PriceCostGMPctEComm,
				CASE WHEN SUM(ISNULL(tGrpSalesEComm.Sales,0)) = 0
				     THEN 0 
				     ELSE 100 * SUM(ISNULL(tGrpSalesEComm.AvgGMDol,0)) / SUM(ISNULL(tGrpSalesEComm.Sales,0))
				END as AvgCostGMPctEComm
			 FROM	(SELECT	*
				 FROM	#12MoSalesByGrp (NoLock)
				 WHERE	OrderSourceSeq = '1' AND LLInd <> 'LLL' AND
					(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate)) tGrpSalesEComm
			 GROUP BY tGrpSalesEComm.GroupNo) tGrpSalesECommSum
			ON	tGrpSales12MoSum.GroupNo = tGrpSalesECommSum.GroupNo

--select * from #SalesByGrp
--drop table #SalesByGrp

		-------------------------------------
		--    *** End Sales History ***    --
		-------------------------------------


		----------------------------------
		--    *** Begin TABLE[0] ***    --
		---------------------------------------------------------------------------
		--    Table UNION of SOHist data GROUPed BY both CatNo and BuyGroupNo    --
		---------------------------------------------------------------------------
		SELECT	DISTINCT
			tUnion.Branch,
			tUnion.CustomerNo,
			tUnion.CustomerName,
			tUnion.GroupType,
			tUnion.GroupNo,
			tUnion.GroupDesc,
			BuyGroupNo,
			BuyGroupDesc,
			ISNULL(tUnion.SalesHistory,0) as SalesHistory,
			ISNULL(tUnion.GMPctPriceCost,0) as GMPctPriceCost,
			ISNULL(tUnion.GMPctAvgCost,0) as GMPctAvgCost,
			ISNULL(tUnion.SalesHistoryTot,0) as SalesHistoryTot,
			ISNULL(tUnion.GMPctPriceCostTot,0) as GMPctPriceCostTot,
			ISNULL(tUnion.GMPctAvgCostTot,0) as GMPctAvgCostTot,
			ISNULL(tUnion.SalesHistoryEComm,0) as SalesHistoryEComm,
			ISNULL(tUnion.GMPctPriceCostEComm,0) as GMPctPriceCostEComm,
			ISNULL(tUnion.GMPctAvgCostEComm,0) as GMPctAvgCostEComm,
			ISNULL(tUnion.SalesHistory12Mo,0) as SalesHistory12Mo,
			ISNULL(tUnion.GMPctPriceCost12Mo,0) as GMPctPriceCost12Mo,
			ISNULL(tUnion.GMPctAvgCost12Mo,0) as GMPctAvgCost12Mo,
			ISNULL(tUnion.TargetGMPct,0) as TargetGMPct,
			tUnion.Approved,
			tUnion.RecType,
			tUnion.pUnprocessedCategoryPriceID,
			ISNULL(tUnion.ExistingCustPricePct,0) as ExistingCustPricePct

			--------------------------------------
			--    Categories: GROUP BY CatNo    --
			--------------------------------------
		FROM	(SELECT	SalesByCat.Branch,
				SalesByCat.CustNo as CustomerNo,
				SalesByCat.CustName as CustomerName,
				SalesByCat.GroupNo,
				SalesByCat.GroupDesc,
				SalesByCat.BuyGroupNo,
				SalesByCat.BuyGroupDesc,
				SalesByCat.GroupSales as SalesHistory,
				ROUND(SalesByCat.PriceCostGMPct,2) as GMPctPriceCost,
				ROUND(SalesByCat.AvgCostGMPct,2) as GMPctAvgCost,
				SalesByCat.GroupSalesTot as SalesHistoryTot,
				ROUND(SalesByCat.PriceCostGMPctTot,2) as GMPctPriceCostTot,
				ROUND(SalesByCat.AvgCostGMPctTot,2) as GMPctAvgCostTot,
				SalesByCat.GroupSalesEComm as SalesHistoryEComm,
				ROUND(SalesByCat.PriceCostGMPctEComm,2) as GMPctPriceCostEComm,
				ROUND(SalesByCat.AvgCostGMPctEComm,2) as GMPctAvgCostEComm,
				SalesByCat.GroupSales12Mo as SalesHistory12Mo,
				ROUND(SalesByCat.PriceCostGMPct12Mo,2) as GMPctPriceCost12Mo,
				ROUND(SalesByCat.AvgCostGMPct12Mo,2) as GMPctAvgCost12Mo,
				0.0 as TargetGMPct,
				'0' as Approved,
				'0' as RecType,
				'C' as GroupType,	--'C' = Category
				-1 as pUnprocessedCategoryPriceID,
				SalesByCat.ExistingCustPricePct
			 FROM	#SalesByCat SalesByCat
		UNION 
			----------------------------------------
			--    Buy Groups: GROUP BY GroupNo    --
			----------------------------------------
			 SELECT	SalesByGrp.Branch,
				SalesByGrp.CustNo as CustomerNo,
				SalesByGrp.CustName as CustomerName,
				SalesByGrp.GroupNo,
				SalesByGrp.GroupDesc,
				SalesByGrp.BuyGroupNo,
				SalesByGrp.BuyGroupDesc,
				SalesByGrp.GroupSales as SalesHistory,
				ROUND(SalesByGrp.PriceCostGMPct,2) as GMPctPriceCost,
				ROUND(SalesByGrp.AvgCostGMPct,2) as GMPctAvgCost,
				SalesByGrp.GroupSalesTot as SalesHistoryTot,
				ROUND(SalesByGrp.PriceCostGMPctTot,2) as GMPctPriceCostTot,
				ROUND(SalesByGrp.AvgCostGMPctTot,2) as GMPctAvgCostTot,
				SalesByGrp.GroupSalesEComm as SalesHistoryEComm,
				ROUND(SalesByGrp.PriceCostGMPctEComm,2) as GMPctPriceCostEComm,
				ROUND(SalesByGrp.AvgCostGMPctEComm,2) as GMPctAvgCostEComm,
				SalesByGrp.GroupSales12Mo as SalesHistory12Mo,
				ROUND(SalesByGrp.PriceCostGMPct12Mo,2) as GMPctPriceCost12Mo,
				ROUND(SalesByGrp.AvgCostGMPct12Mo,2) as GMPctAvgCost12Mo,
				0.0 as TargetGMPct,
				'0' as Approved,
				'0' as RecType,
				'B' as GroupType,	--'B' = Buy Group
				-1 as pUnprocessedCategoryPriceID,
				SalesByGrp.ExistingCustPricePct
			 FROM	#SalesByGrp SalesByGrp) tUnion
		ORDER BY ISNULL(tUnion.SalesHistory,0) DESC
		--------------------------------
		--    *** End TABLE[0] ***    --
		--------------------------------

--select	CustNo, CustName, Branch, CatNo, CatDesc,
--	SUM(ISNULL(Sales,0)) as Sales12Mo
--from	#12MoSalesByCat
--where	LLInd <> 'LLL'
--group by CustNo, CustName, Branch, CatNo, CatDesc
--order by CatNo
--select * from #temp where Grouptype='C' Order By GroupNo

--select	CustNo, CustName, Branch, GroupNo, GroupDesc,
--	SUM(ISNULL(Sales,0)) as Sales12Mo
--from	#12MoSalesByGrp
--where	LLInd <> 'LLL'
--group by CustNo, CustName, Branch, GroupNo, GroupDesc
--order by GroupNo
--select * from #temp where Grouptype='B' Order By GroupNo


		DROP TABLE #12MoSalesByCat
		DROP TABLE #12MoSalesByGrp
		DROP TABLE #SalesByCat
		DROP TABLE #SalesByGrp
	   END


	----------------------------------
	--    *** Begin TABLE[1] ***    --
	--------------------------------------------------------
	--    2nd table to return Customer Price Schedules    --
	--------------------------------------------------------
	SELECT	CustNo as CustomerNo,
		CustName as CustomerName,
		ShipLocation as Branch,
		CreditInd,
		ContractSchd1,
		ContractSchd2,
		ContractSchd3,
		ContractSchedule4,
		ContractSchedule5,
		ContractSchedule6,
		ContractSchedule7,
		TargetGrossMarginPct,
		WebDiscountPct,
		WebDiscountInd,
		(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
		    (SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID = fListMasterID WHERE ListName = 'CustDefPriceSchd') LD
		 ON LD.ListValue = CustomerDefaultPrice WHERE CustNo = @CustNo) as CustomerDefaultPrice,
		(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
		    (SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID = fListMasterID WHERE ListName = 'CustPriceInd') LD
		 ON LD.ListValue = CustomerPriceInd WHERE CustNo = @CustNo) as CustomerPriceInd
	FROM  CustomerMaster CM (NoLock) 
	WHERE CM.CustNo = @CustNo
	--------------------------------
	--    *** End TABLE[1] ***    --
	--------------------------------
END