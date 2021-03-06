USE [DEVPERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEProcessCustSlsSumm]    Script Date: 06/08/2011 16:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[pSOEProcessCustSlsSumm] 
	@begDt DATETIME,
	@endDt DATETIME,
	@userName VARCHAR(50)
AS
BEGIN
	-- =============================================
	-- Author:	Craig Parks
	-- Created:	12/26/2008
	-- Desc:	Build CustomerSalesSummary
	-- Params:	@begDt = Beginning Date to process
	--			@endDt = Ending Date to Process
	--			@userName = Procedure caller
	-- Mods:	? - Add UnitCost2 = StdCost, UnitCost3 = Replacement cost, OECost = IB.PriceCost to posting
	--			[TMD] 06/08/2011 - Reformatting Code
	-- =============================================

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@curPeriod INT,
			@endPeriod INT,
			@msg VARCHAR(100)

	EXEC pUTRetPeriod @date=@begDt, @periodType = 'C', @period = @curPeriod OUTPUT
	EXEC pUTRetPeriod @date=@endDt, @periodType = 'C', @period = @endPeriod OUTPUT
	--PRINT CONVERT(varchar,@curPeriod)

	IF @endPeriod <> @curPeriod
	  BEGIN
		SET @msg = 'Begin and End Invoice dates must be in the same period'
		EXEC pUTInsertErrLog @dbID = 'PERP', @table='FiscalPeriodCalendar', 
		@msg=@msg, @userName=@userName, @appFunction='Post Cust Sls Summ',
		@procedureName = 'pSOEProcessCustSlsSumm';
		RETURN (1) 
	  END;

	--Is Customer Sales Summary Posted for the Client?
	IF (SELECT AppOptionValue FROM dbo.AppPref (NOLOCK) WHERE ApplicationCd = 'SOE' AND AppOptionType = 'InvPostCustSls') <> 'Y'
		RETURN (0)

	--Update Sales Totals by Customer Item in CustomerSalesSummary with SODetailSum
   SELECT	SOHH.SellToCustNo,
			SODH.ItemNo,
			ISNULL(SODH.CustItemNo,'') as CustItemNo,
			SODH.SellStkUm,
			IM.ItemDesc,
			IM.ItemStat,
			@curPeriod AS Period,
			Count(*) AS SlsCnt,
			SUM(ISNULL(SODH.QtyShipped,0)) AS SlsQty,
			SUM(ISNULL(SODH.QtyOrdered,0)) AS SlsOrd,
			SUM(ISNULL(SODH.ExtendedPrice,0)) AS SlsDol,
			SUM(ISNULL(SODH.ExtendedCost,0)) AS SlsCost,
			SUM(ISNULL(SODH.QtyShipped,0) * ISNULL(SODH.UnitCost2,0)) AS SlsCost2,
			SUM(ISNULL(SODH.ExtendedNetWght,0)) AS SlsWght,
			MAX(ISNULL(SODH.UnitCost,0)) AS UC,
			MAX(ISNULL(SODH.UnitCost2,0)) AS StdCost,
			MAX(ISNULL(SODH.UnitCost3,0)) as ReplacementCost,
			MAX(ISNULL(SODH.OECost,0)) AS IBPriceCost,
			MAX(ISNULL(SODH.DiscUnitPrice,0)) AS UP,
			MAX(ISNULL(NetWght,0)) AS NetWght,
			MAX(SOHH.InvoiceDt) AS InvoiceDt,
			@username AS EntID,
			GetDate() AS EntDt,
			ISNULL(pCustSlsSummID,0) AS Status
	INTO	#SODetailSum
    FROM	SODetailHist (NOLOCK) SODH INNER JOIN
			SOHeaderHist (NOLOCK) SOHH
    ON		pSOHeaderHistID = fSOHeaderHistID LEFT OUTER JOIN
			CustomerSalesSummary (NOLOCK) CSS
	ON		SOHH.SellToCustNo = CSS.CustomerNo AND SODH.SellStkUM = CSS.BaseUM AND SODH.ItemNo = CSS.ItemNo AND
			ISNULL(CustItemNo,'') = CSS.CustomerItemNo AND @curPeriod = CSS.FiscalPeriodNo LEFT OUTER JOIN
			ItemMaster (NOLOCK) IM
	ON		SODH.ItemNo = IM.ItemNo,
			InvoiceFlags (NOLOCK) [IF]
	WHERE	[IF].OrderNo = SOHH.OrderNo AND [IF].InvoicePostedDt IS NULL AND [IF].StatusCd = 'IP'
    GROUP BY SOHH.SellToCustNo, SODH.ItemNo, ISNULL(SODH.CustItemNo,''), SODH.SellStkUm, IM.ItemDesc, IM.ItemStat, ISNULL(pCustSlsSummID,0)
--select * from #SODetailSum

	-- Build CustomerSlsSumm for Items not Currently in table for which there are Sales
	INSERT INTO	dbo.CustomerSalesSummary (
				CustomerNo,
				CustomerItemNo,
				ItemNo,
				BaseUM,
				FiscalPeriodNo,
				SalesDollars,
				SalesCost,
				NoofOrders,
				OtherSalesCost,
				OtherSalesDol,
				CommissionDollars,
				LatestSalesCost,
				LatestSalesPrice,
				UnitCost2,
				UnitCost3,
				OECost,
				TotalWeight,
				UnitWeight,
				QtyShipped,
				QtyOrdered,
				PostingDt,
				ItemStatCd,
				EntryID,
				EntryDt,
				ItemDesc)
	SELECT		SOS.SellToCustNo AS CustomerNo,
				SOS.CustItemNo AS CustomerItemNo,
				SOS.ItemNo AS ItemNo,
				SOS.SellStkUM AS BaseUM,
				SOS.Period AS FiscalPeriodNo,
				SOS.SlsDol AS SalesDollars,
				SOS.SlsCost AS SalesCost,
				SOS.SlsCnt AS NoofOrders,
				SOS.SlsCost2 AS OtherSalesCost,
				0 AS OtherSalesDol,
				0 AS CommissionDollars,
				SOS.UC AS LatestSalesCost,
				SOS.UP AS LatestSalesPrice,
				SOS.StdCost AS UnitCost2,
				SOS.ReplacementCost AS UnitCost3,
				SOS.IBPriceCost AS OECost,
				SOS.SlsWght AS TotalWeight,
				SOS.NetWght AS UnitWeight,
				SOS.SlsQty AS QtyShipped,
				SOS.SlsOrd AS QtyOrdered,
				SOS.InvoiceDt AS PostingDt,
				SOS.ItemStat AS ItemStatCd,
				@userName AS EntryID,
				GetDate() AS EntryDt,
				SOS.ItemDesc AS ItemDesc
	FROM		#SODetailSum (NOLOCK) SOS 
	WHERE		SOS.Status = '0'	--Status is pCustSlsSummID 0 indicates there is no existing row and requires insert

	--Update existing rows in Customer Sales Summ
	UPDATE	dbo.CustomerSalesSummary
	SET		NoofOrders = NoofOrders + SlsCnt,
			QtyShipped = QtyShipped + SlsQty,
			QtyOrdered = QtyOrdered + SlsOrd,
			SalesDollars = SalesDollars + [SlsDol],
			TotalWeight = TotalWeight + SlsWght,
			SalesCost = SalesCost + SlsCost,
			OtherSalesCost = OtherSalesCost + SlsCost2,
			LatestSalesCost = UC,
			UnitCost2 = StdCost,
			UnitCost3 = ReplacementCost,
			OECost = IBPriceCost,
			LatestSalesPrice = UP,
			UnitWeight = NetWght,
			PostingDt = InvoiceDt,
			ItemStatCd = ItemStat,
			ItemDesc = SOS.ItemDesc,
			ChangeID = 'pSOEProcessCustSlsSumm',
			ChangeDt = GetDate()
	FROM	#SODetailSum SOS 
	WHERE	SOS.SellToCustNo = CustomerSalesSummary.CustomerNo AND
			SOS.SellStkUM = CustomerSalesSummary.BaseUM AND
			SOS.ItemNo = CustomerSalesSummary.ItemNo AND
			ISNULL(SOS.CustItemNo,'') = CustomerSalesSummary.CustomerItemNo AND
			SOS.Period = CustomerSalesSummary.FiscalPeriodNo AND SOS.Status <> '0'

	--Drop the temp invoice table
    DROP TABLE #SODetailSum

    RETURN (0)
END -- Procedure


