
SELECT	tmp2.Branch,
				tmp2.CustNo as CustomerNo,
				tmp2.CustName as CustomerName,
				CAST(tmp2.GroupNo as VARCHAR(5)) as GroupNo,
				tmp2.GroupDesc,
				tmp2.GroupSales as SalesHistory,
				ROUND(tmp2.PriceCostGMPct,2) as GMPctPriceCost,
				0.0 as TargetGMPct,
				'0' as Approved,
				'0' as RecType,
				'C' as GroupType,	--Category
				-1 as pUnprocessedCategoryPriceID,
				ExistingCustPricePct
			 FROM	(SELECT	CustNo,
					CustName,
					Branch,
					ListValue as GroupNo,
					ListDtlDesc as GroupDesc,
					ISNULL(SUM(Sales),0) as GroupSales,
					CASE WHEN SUM(Sales) = 0
						THEN 0 
						ELSE 100 * SUM(PriceGMDol) / SUM(Sales)
					END as PriceCostGMPct,
					MAX(ISNULL(ExistingCustPricePct,-1)) as ExistingCustPricePct
				 FROM	(SELECT	SOH.ARPostDt,
						SOH.SellToCustNo as CustNo,
						CM.CustShipLocation as Branch,
						SOH.SellToCustName as CustName, 
						SOD.ItemNo,
						LEFT(SOD.ItemNo,5) as ListValue,
						IM.CatDesc as ListDtlDesc,
						SOD.QtyShipped,
						SOD.NetUnitPrice,
						SOD.UnitCost,
						IB.PriceCost,
						IB.CurrentReplacementCost,
						IB.ReplacementCost,
						SOH.InvoiceNo,
						ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
						SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost as AvgGMDol,
						CASE WHEN ISNULL(IB.ReplacementCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.ReplacementCost 
						END as RplGMDol,
						CASE WHEN ISNULL(IB.PriceCost,0) = 0
							THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
							ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
						END as PriceGMDol,
						Price.DiscPct as ExistingCustPricePct
					 FROM	ItemBranch IB (NoLock) INNER JOIN
				 		SOHeaderHist SOH (NoLock) INNER JOIN
				 		SODetailHist SOD (NoLock)
					 ON	SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
				 		ItemMaster IM (NoLock)
					 ON	SOD.ItemNo = IM.ItemNo
					 ON	IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
					 	CategoryBuyGroups CAS (NoLock)
					 ON	CAS.Category = LEFT(SOD.ItemNo,5) INNER JOIN
					 	FiscalCalendar FC (NoLock)
					 ON	SOH.ARPostDt = FC.CurrentDt INNER JOIN
					 	CustomerMaster CM (NoLock)
					 ON	CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
					 	CompetitorPrice CP (NoLock)
					 ON	CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
						CustomerPrice Price (NoLock)
					 ON	Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) AND Price.CustNo = SOH.SellToCustNo
					--Use last 3 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
					 WHERE	SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
----no DEV data				 	(FC.FiscalCalYear * 100 + FiscalCalMonth Between (DATEPART(yyyy,DATEADD(m,-3,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-3,GETDATE())) AND
----for last 3 months				(DATEPART(yyyy,DATEADD(m,-1,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-1,GETDATE()))) AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = '001005'
) tmp
				 GROUP BY CustNo, CustName, Branch, ListValue, ListDtlDesc) tmp2



select * from ItemMaster where left(ItemNo,5)='00200'
order by CatDesc



update ItemMaster set CatDesc='Finished Hex Nut NC      '
where ItemNo='00200-2400-021'