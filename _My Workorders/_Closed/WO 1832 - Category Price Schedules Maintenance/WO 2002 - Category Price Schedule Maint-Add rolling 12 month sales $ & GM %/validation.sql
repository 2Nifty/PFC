--select distinct left(ItemNo,5), CatDesc from ItemMaster
--order by left(ItemNo,5)

--64 unique descriptions
--select distinct GroupNo, [Description] from CategoryBuyGroups




		DECLARE	@Beg3MoDate DATETIME,
			@End3MoDate DATETIME,
			@Beg12MoDate DATETIME,
			@End12MoDate DATETIME

		--Beg3MoDate
		SELECT	DISTINCT
			@Beg3MoDate = CurFiscalMthBeginDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN	
			(SELECT	(DATEPART(yyyy,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			 FROM	FiscalCalendar
			 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		--End3MoDate
		SELECT	DISTINCT
			@End3MoDate = CurFiscalMthEndDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN
			(SELECT	(DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			 FROM	FiscalCalendar
			 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		--Beg12MoDate
		SELECT	DISTINCT
			@Beg12MoDate = CurFiscalMthBeginDt
		FROM	FiscalCalendar
		WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
			IN
			(SELECT	(DATEPART(yyyy,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
			 FROM	FiscalCalendar
			 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

				--End12MoDate
				SELECT	DISTINCT
					@End12MoDate = CurFiscalMthEndDt
				FROM	FiscalCalendar
				WHERE	(DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
					IN
					(SELECT	(DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
					 FROM	FiscalCalendar
					 WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

		SELECT	@Beg3MoDate as Beg3MoDate, @End3MoDate as End3MoDate, @Beg12MoDate as Beg12MoDate, @End12MoDate as End12MoDate



					--Categories 3 month
					SELECT	SOH.SellToCustNo as CustNo,
						CM.CustShipLocation as Branch,
						SOH.SellToCustName as CustName, 
--						SOD.ItemNo,
						LEFT(SOD.ItemNo,5) as CatNo,
						IM.CatDesc,
						ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
						CASE WHEN ISNULL(IB.PriceCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
						END as PriceGMDol --,
--						Price.DiscPct as ExistingCustPricePct
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
					 	CompetitorPrice CP (NoLock)
					 ON	CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
						CustomerPrice Price (NoLock)
					 ON	Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) AND Price.CustNo = SOH.SellToCustNo
					 --Use last 3 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
					 WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
--						(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate) AND
(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN '2010-05-30' and '2010-08-28') AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = '065251' and LEFT(SOD.ItemNo,5) = '00023'





					--Categories 12 month
					SELECT	SOH.SellToCustNo as CustNo,
						CM.CustShipLocation as Branch,
						SOH.SellToCustName as CustName, 
						LEFT(SOD.ItemNo,5) as CatNo,
						IM.CatDesc,
						ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales12Mo,
						CASE WHEN ISNULL(IB.PriceCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
						END as PriceGMDol12Mo
					 FROM	ItemBranch IB (NoLock) INNER JOIN
				 		SOHeaderHist SOH (NoLock) INNER JOIN
				 		SODetailHist SOD (NoLock)
					 ON	SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
				 		ItemMaster IM (NoLock)
					 ON	SOD.ItemNo = IM.ItemNo
					 ON	IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
					 	CustomerMaster CM (NoLock)
					 ON	CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
					 	CompetitorPrice CP (NoLock)
					 ON	CP.PFCItem = SOD.ItemNo
					 --Use last 12 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
					 WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
--						(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN '2009-08-30' and '2010-08-28') AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = '065251' and LEFT(SOD.ItemNo,5) = '00023'




					--Buy Groups 3 month
					SELECT	SOH.SellToCustNo as CustNo,
						CM.CustShipLocation as Branch,
						SOH.SellToCustName as CustName, 
						CAS.GroupNo,
						CAS.[Description] as GroupDesc,
						ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
						CASE WHEN ISNULL(IB.PriceCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
						END as PriceGMDol --,
--						Price.DiscPct as ExistingCustPricePct
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
					 	CompetitorPrice CP (NoLock)
					 ON	CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
						CustomerPrice Price (NoLock)
					 ON	Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) AND Price.CustNo = SOH.SellToCustNo
					 --Use last 3 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
					 WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
--						(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate) AND
(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN '2010-05-30' and '2010-08-28') AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = '065251' and CAS.GroupNo = 40




					--Buy Group 12 Month
					SELECT	SOH.SellToCustNo as CustNo,
						CM.CustShipLocation as Branch,
						SOH.SellToCustName as CustName, 
						CAS.GroupNo,
						CAS.[Description] as GroupDesc,
						ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales12Mo,
						CASE WHEN ISNULL(IB.PriceCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
						END as PriceGMDol12Mo
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
					 	CompetitorPrice CP (NoLock)
					 ON	CP.PFCItem = SOD.ItemNo
					 --Use last 12 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
					 WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
--						(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
(CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN '2009-08-30' and '2010-08-28') AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = '065251' and CAS.GroupNo = 40

