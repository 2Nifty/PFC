USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pCustPriceGetHist]    Script Date: 08/27/2010 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[pCustPriceGetHist]
@CustNo varchar(20)
as
/*
	=============================================
	Author:		Tom Slater
	Create date: 3/15/2010
	Description: Get Customer Price History for Category Price Schedule Maintenance
	=============================================
	Derived from pWO1755_GetCustData Written By Charles Rojas
	Create Date: 02/19/10

	exec pCustPriceGetHist '004401'
*/

BEGIN
	DECLARE @RecsFound BIGINT;
	SET @RecsFound = 0;

	--See if there are any approval records waiting
	SELECT	@RecsFound = count(*)
	FROM	UnprocessedCategoryPrice (NoLock)
	WHERE	CustomerNo = @CustNo;

	IF ISNULL(@RecsFound,0) > 0
	   BEGIN
		--TABLE[0]
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
		ORDER BY CustomerNo, SalesHistory desc;

		--TABLE[1]
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
		FROM	CustomerMaster CM (NoLock) 
		WHERE	CM.CustNo = @CustNo;
	   END
	ELSE
	   BEGIN
		--TABLE[0]
		SELECT	DISTINCT
			tUnion.Branch,
			tUnion.CustomerNo,
			tUnion.CustomerName,
			tUnion.GroupType,
			tUnion.GroupNo,
			tUnion.GroupDesc,
			CASE WHEN GroupType = 'C'
				THEN CBG.GroupNo
				ELSE tUnion.GroupNo
			END as BuyGroupNo,
			CASE WHEN GroupType = 'C'
				THEN CBG.[Description]
				ELSE tUnion.GroupDesc
			END as BuyGroupDesc,
			tUnion.SalesHistory,
			tUnion.GMPctPriceCost,
			tUnion.TargetGMPct,
			tUnion.Approved,
			tUnion.RecType,
			tUnion.pUnprocessedCategoryPriceID,
			tUnion.ExistingCustPricePct
			--Categories
		FROM	(SELECT	tmp2.Branch,
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
						(FC.FiscalCalYear * 100 + FiscalCalMonth Between (DATEPART(yyyy,DATEADD(m,-3,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-3,GETDATE())) AND
						(DATEPART(yyyy,DATEADD(m,-1,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-1,GETDATE()))) AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = @CustNo) tmp
				 GROUP BY CustNo, CustName, Branch, ListValue, ListDtlDesc) tmp2
			--Buy Groups
		UNION	 SELECT	tmp2.Branch,
				tmp2.CustNo as CustomerNo,
				tmp2.CustName as CustomerName,
				CAST(tmp2.GroupNo as VARCHAR(5)) as GroupNo,
				tmp2.GroupDesc,
				tmp2.GroupSales as SalesHistory,
				ROUND(tmp2.PriceCostGMPct,2) as GMPctPriceCost,
				0.0 as TargetGMPct,
				'0' as Approved,
				'0' as RecType,
				'B' as GroupType,	--Buy Group
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
						CAS.GroupNo as ListValue,
						CAS.[Description] as ListDtlDesc,
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
						(FC.FiscalCalYear * 100 + FiscalCalMonth Between (DATEPART(yyyy,DATEADD(m,-3,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-3,GETDATE())) AND
						(DATEPART(yyyy,DATEADD(m,-1,GETDATE())) * 100) + DATEPART(m,DATEADD(m,-1,GETDATE()))) AND
						CASE WHEN CP.PFCItem is null
							THEN ''
							ELSE 'Skip'
						END <> 'SKIP' AND
						SOH.SellToCustNo = @CustNo) tmp
				 GROUP BY CustNo, CustName, Branch, ListValue, ListDtlDesc) tmp2) tUnion LEFT OUTER JOIN
			CategoryBuyGroups CBG (NoLock) ON Category = tUnion.GroupNo
		ORDER BY CustomerNo, SalesHistory desc;

		--TABLE[1]
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
		FROM	CustomerMaster CM (NoLock) 
		WHERE	CM.CustNo = @CustNo;	
	   END;
END
