
------------------------------------------------------------------------------------------

drop table tItemBranch

--Create #tItemBranch
SELECT	IM.ItemNo,
		IB.Location,
		IB.UnitCost as AvgCost,
		IB.PriceCost
INTO	tItemBranch
FROM	ItemMaster IM (NoLock) INNER JOIN
		ItemBranch IB (NoLock)
ON		IM.pItemMasterID = IB.fItemMasterID
select * from tItemBranch

/**
--Get FiscalPeriod info from DashboardRanges
DECLARE	@Period varchar(6),
		@BegPer	datetime,
		@EndPer	datetime

SELECT	@Period = YearValue * 100 + MonthValue,
		@BegPer = BegDate,
		@EndPer = EndDate
FROM	DashboardRanges
WHERE	DashboardParameter = 'CurrentMonth'
PRINT	'Period: ' + cast(@Period as varchar(20)) + ' - BegPer: ' + cast(@BegPer as varchar(20)) + ' - EndPer: ' + cast(@EndPer as varchar(20))
**/

--	=================================================================
--	--Hard code specific FiscalPeriodNo here
--			SET	@Period = '201104'
--			SET	@BegPer = '2011-mar-27'
--			SET	@EndPer = '2011-apr-30'
--	--select @Period as Period, @BegPer as BegPer, @EndPer as EndPer
--	=================================================================

--DELETE existing records for @Period
DELETE
FROM	tCustItemSalesSummary
WHERE	FiscalPeriodNo = @Period


--INSERT new records for @Period
INSERT INTO	tCustItemSalesSummary
			(CustNo,
			 ItemNo,
			 FiscalPeriodNo,
			 SalesDollars,
			 SalesCost,
			 TotalWeight,
			 AvgCostDollars,
			 PriceCostDollars,
			 EntryID,
			 EntryDt)
SELECT		--DISTINCT
			Hdr.SellToCustNo as CustomerNo,
			Dtl.ItemNo AS ItemNo,
			@Period as FiscalPeriodNo,
			SUM(isnull(Dtl.NetUnitPrice,0) * isnull(Dtl.QtyShipped,0)) AS SalesDollars,
			SUM(isnull(Dtl.UnitCost,0) * isnull(Dtl.QtyShipped,0)) AS SalesCost,
			SUM(isnull(Dtl.GrossWght,0) * isnull(Dtl.QtyShipped,0)) AS TotalWeight,
			SUM(isnull(IB.AvgCost,0) * isnull(Dtl.QtyShipped,0)) as AvgCostDollars,
			SUM(isnull(IB.PriceCost,0) * isnull(Dtl.QtyShipped,0)) as PriceCostDollars,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			#tItemBranch IB (NoLock)
ON			Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
WHERE		Hdr.ARPostDt between @BegPer and @EndPer AND ISNULL(Hdr.DeleteDt,'') = ''
GROUP BY	Hdr.SellToCustNo, Dtl.ItemNo