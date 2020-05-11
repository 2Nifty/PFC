USE [PFCReports]
GO

drop proc [tProcessCustItemSalesSumm]
go

/****** Object:  StoredProcedure [dbo].[tProcessCustItemSalesSumm]    Script Date: 08/21/2012 11:58:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[tProcessCustItemSalesSumm]
	@Period varchar(6),
	@BegPer	datetime,
	@EndPer	datetime
AS
BEGIN

	SET NOCOUNT ON;


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
			SUM(isnull(Dtl.UnitCost,0) * isnull(Dtl.QtyShipped,0)) AS AvgCostDollars,
			--SUM(isnull(IB.AvgCost,0) * isnull(Dtl.QtyShipped,0)) as AvgCostDollars,
			SUM(isnull(IB.PriceCost,0) * isnull(Dtl.QtyShipped,0)) as PriceCostDollars,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			tItemBranch IB (NoLock)
ON			Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
WHERE		Hdr.ARPostDt between @BegPer and @EndPer AND ISNULL(Hdr.DeleteDt,'') = ''
GROUP BY	Hdr.SellToCustNo, Dtl.ItemNo


END
