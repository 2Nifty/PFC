
--Get FiscalPeriod info from DashboardRanges
DECLARE	@Period varchar(6),
		@BegPer	datetime,
		@EndPer	datetime

----Current MTD (201106) thru 6/09 - less than 1 minute - 16,722 records
SELECT	@Period = YearValue * 100 + MonthValue,
		@BegPer = BegDate,
		@EndPer = EndDate
FROM	DashboardRanges
WHERE	DashboardParameter = 'CurrentMonth'

select	@Period as Period, @BegPer as BegPer, @EndPer as EndPer



	SELECT	DISTINCT LEFT(ItemNo, 5) AS CategoryGroup, --CustShipLoc AS Location, ARPostDt,
		SUM(NetUnitPrice * QtyShipped) AS TotSales,
		SUM(GrossWght * QtyShipped) AS TotWght,
		CASE SUM(GrossWght * QtyShipped)
		   WHEN 0 THEN 0
			  ELSE SUM(NetUnitPrice * QtyShipped) / SUM(GrossWght * QtyShipped)
		END AS TotSalesPerLb,
		SUM(UnitCost * QtyShipped) AS TotCost,
		SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS TotMgn,
		CASE SUM(NetUnitPrice * QtyShipped)
		   WHEN 0 THEN 0
			  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
		END AS TotMgnPct,
		CASE SUM(GrossWght * QtyShipped)
		   WHEN 0 THEN 0
			  ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(GrossWght * QtyShipped)
		END AS TotMgnPerLb
	FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	WHERE	ARPostDt between @BegPer and @EndPer and LEFT(ItemNo, 5)='00024'
	GROUP BY LEFT(ItemNo, 5)--, CustShipLoc, ARPostDt




SELECT		--DISTINCT
--			Hdr.SellToCustNo as CustomerNo,
			LEFT(Dtl.ItemNo, 5) AS Category,
--			BuyGrp.[CatDesc] as CategoryDesc,
--			BuyGrp.[BuyGrpNo] as BuyCategory,
--			BuyGrp.[BuyGrpDesc] as BuyGroupDesc,
----			Hdr.CustShipLoc AS Location,
			@Period as FiscalPeriodNo,
			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS SalesDollars,
			SUM(Dtl.UnitCost * Dtl.QtyShipped) AS SalesCost,
			SUM(Dtl.GrossWght * Dtl.QtyShipped) AS TotalWeight,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID --LEFT OUTER JOIN
--			#BuyGrpCatDesc BuyGrp (NoLock)
--ON			LEFT(Dtl.ItemNo, 5) = BuyGrp.CatNo
WHERE		Hdr.ARPostDt between @BegPer and @EndPer and LEFT(Dtl.ItemNo, 5)='00024'
GROUP BY	--Hdr.SellToCustNo,
 LEFT(Dtl.ItemNo, 5)--, BuyGrp.CatDesc, BuyGrp.BuyGrpNo, BuyGrp.BuyGrpDesc
--			, FiscalPeriodNo, Hdr.CustShipLoc



select * 
--		sum(Salesdollars), sum(SalesCost)
from CustCatSalesSummary
where FiscalPeriodNo='201106' and Category='00024'
--group by Category, FiscalPeriodNo



SELECT	CatSumm.CustomerNo as CustNo,
		CatSumm.SalesDollars,
		CatSumm.TotalWeight as Lbs,
		CASE WHEN CatSumm.TotalWeight = 0
			 THEN 0
			 ELSE CatSumm.SalesDollars / CatSumm.TotalWeight
		END as SalesPerLb,
		SalesDollars - SalesCost as MarginDollars,
		CASE WHEN SalesDollars = 0
			 THEN 0
			 ELSE (SalesDollars - SalesCost) / SalesDollars * 100
		END AS MarginPct
FROM	CustomerMaster CM (NoLock) INNER JOIN
		CustCatSalesSummary CatSumm (NoLock)
ON		CM.CustNo = CatSumm.CustomerNo
WHERE	CM.ShipLocation = @Loc and
		CatSumm.FiscalPeriodNo = @CurMth and CatSumm.Category = @Cat