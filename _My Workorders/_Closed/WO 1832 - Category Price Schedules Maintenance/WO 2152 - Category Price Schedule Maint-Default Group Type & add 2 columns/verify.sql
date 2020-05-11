
--drop table #12MoSalesByCat
--drop table #12MoSalesByGrp

		--Begin Sales History
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

--SELECT @Beg3MoDate as Beg3MoDate, @End3MoDate as End3MoDate, @Beg12MoDate as Beg12MoDate, @End12MoDate as End12MoDate

declare @CustNo varchar(20)
set @CustNo='065251'

		--Build 12Mo Sales data by Category (#12MoSalesByCat)
		SELECT	SOH.SellToCustNo as CustNo,
			CM.CustShipLocation as Branch,
--			SOH.SellToCustName as CustName, 
			CM.CustName,
			SOD.ItemNo,
			LEFT(SOD.ItemNo,5) as CatNo,
--			IM.CatDesc,
			CatList.CatDesc,
			ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,

			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * IB.PriceCost 
			END as PriceCost,

			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
			END as PriceGMDol,


SOD.QtyShipped * SOD.UnitCost as AvgCost,
			SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost as AvgGMDol,
			Price.DiscPct as ExistingCustPricePct,
			SOH.ARPostDt,
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
		ON  	CatList.CatNo = LEFT(SOD.ItemNo,5)
			--Use last 12 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
		WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
			(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
--			CASE WHEN CP.PFCItem is null
--			     THEN ''
--			     ELSE 'Skip'
--			END <> 'SKIP' AND
			SOH.SellToCustNo = @CustNo
and LEFT(SOD.ItemNo,5) = '00050'

		UPDATE	#12MoSalesByCat
		SET	LLInd = Price.CustNo
		FROM	CustomerPrice Price
		WHERE	#12MoSalesByCat.ItemNo = Price.ItemNo AND
			Price.CustNo = 'LLL'

--select distinct * from CustomerPrice where CustNo='LLL' order by ItemNo
--select * from #12MoSalesByCat
--drop table #12MoSalesByCat

		--Build 12Mo Sales data by Buy Group (#12MoSalesByGrp)
		SELECT	SOH.SellToCustNo as CustNo,
			CM.CustShipLocation as Branch,
--			SOH.SellToCustName as CustName, 
			CM.CustName,
			SOD.ItemNo,
			CAS.GroupNo,
			CAS.[Description] as GroupDesc,
			ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * IB.PriceCost 
			END as PriceCost,
			CASE WHEN ISNULL(IB.PriceCost,0) = 0
			     THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
			     ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
			END as PriceGMDol,
			SOD.QtyShipped * SOD.UnitCost as AvgCost,
			SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost as AvgGMDol,
			Price.DiscPct as ExistingCustPricePct,
			SOH.ARPostDt,
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
		ON	(Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) or Price.ItemNo = CAS.Category) AND Price.CustNo = SOH.SellToCustNo
			--Use last 12 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
		WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
			(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
--			CASE WHEN CP.PFCItem is null
--			     THEN ''
--			     ELSE 'Skip'
--			END <> 'SKIP' AND
			SOH.SellToCustNo = @CustNo
and CAS.GroupNo = '120'

	
		UPDATE	#12MoSalesByGrp
		SET	LLInd = Price.CustNo
		FROM	CustomerPrice Price
		WHERE	#12MoSalesByGrp.ItemNo = Price.ItemNo AND
			Price.CustNo = 'LLL'

--select * from #12MoSalesByGrp
--drop table #12MoSalesByGrp

--End Sales History





				SELECT	tCatSalesTot.CustNo,
					tCatSalesTot.CustName,
					tCatSalesTot.Branch,
					tCatSalesTot.CatNo as GroupNo,
					tCatSalesTot.CatDesc as GroupDesc,
					SUM(ISNULL(tCatSalesTot.Sales,0)) as GroupSalesTot,
SUM(ISNULL(tCatSalesTot.PriceCost,0)) as GroupPriceCostTot,
					CASE WHEN SUM(ISNULL(tCatSalesTot.Sales,0)) = 0
					     THEN 0 
					     ELSE 100 * SUM(ISNULL(tCatSalesTot.PriceGMDol,0)) / SUM(ISNULL(tCatSalesTot.Sales,0))
					END as PriceCostGMPctTot,
SUM(ISNULL(tCatSalesTot.AvgCost,0)) as GroupAvgCostTot,
					CASE WHEN SUM(ISNULL(tCatSalesTot.Sales,0)) = 0
					     THEN 0 
					     ELSE 100 * SUM(ISNULL(tCatSalesTot.AvgGMDol,0)) / SUM(ISNULL(tCatSalesTot.Sales,0))
					END as AvgCostGMPctTot
				 FROM	(SELECT	*
					 FROM	#12MoSalesByCat
					 WHERE	(CAST(FLOOR(CAST(ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate AND LLInd <> 'LLL')) tCatSalesTot
				 GROUP BY tCatSalesTot.CustNo, tCatSalesTot.CustName, tCatSalesTot.Branch, tCatSalesTot.CatNo, tCatSalesTot.CatDesc


