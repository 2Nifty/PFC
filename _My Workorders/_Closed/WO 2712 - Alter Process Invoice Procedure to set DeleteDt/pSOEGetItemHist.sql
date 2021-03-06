USE [PERP]
GO

drop proc [pSOEGetItemHist]
go

/****** Object:  StoredProcedure [dbo].[pSOEGetItemHist]    Script Date: 01/05/2012 16:51:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================
-- Procedure	:[pSOEGetItemHist]
-- ----------------------------------------------------------------------------------------------------
-- Date				Developer  		    Action          Purpose
-- ----------------------------------------------------------------------------------------------------
-- 08/24/2011		Sathish             Modified        New parameter added (@operateMode)
--
-- Notes:
-- @operateMode = FULL - Procedure return Region results
-- @operateMode = SHORT or empty - Procedure won't return Region results
-- Ouptput:
-- Table 1 = It contains error message info
-- Table 2 = It contains customer last quote, invoice, ecomm & open order info
-- Table 3 = It contains region last quote info
-- Table 4 = It contains region last order info
-- ====================================================================================================  
/*

exec [pSOEGetItemHist] '00200-2600-021', '555555', 'Metrics','full'

exec [pSOEGetItemHist] '00250-3000-021', '001117', 'Metrics',''

exec [pSOEGetItemHist] '1794289', '', 'LastMetrics', 'IV' 

*/

CREATE PROCEDURE [dbo].[pSOEGetItemHist] 
	@SearchItemNo VARCHAR(20) = '',
	@Organization VARCHAR(20) = '',
	@HistoryType VARCHAR(20) = '',		-- Metrics=get CustomerMetrics; Summary=get CustomerSalesSummary
	@operateMode Varchar(20) = 'full'

AS
BEGIN
	SET NOCOUNT ON;

	declare @ErrorClass char(4);
	declare @ErrorType char(4);
	declare @ErrorCode varchar(4);

	set @ErrorClass = 'SOE';
	set @ErrorType = '';
	set @ErrorCode = '0000';

	GOTO NormalEnd;

ErrorResult:
	-- something bad happened, we send back only the procedure results
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;
	GOTO ProcEnd;

NormalEnd:
	-- Normal end of procedure. Return procedure results and data
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;

	if @HistoryType = 'Metrics'
		BEGIN	--Metrics

			-- Last Quote data by cust #
			SELECT	MetricType
					,MetricDt
					,MetricQty
					,MetricSellPrice
					,MetricMarginAtCost as MetricMarginAtCost
					,MetricMarginAtStd as MetricMarginAtStd
					,MetricMarginAtReplacementCost
					,MetricSellPerLB
					,MetricMarginPerLB
					,MetricSellUMPrice
	--				,case 
	--					when OrderNo is null then '-1'
	--					when MetricType='SO' then (select convert(varchar(20), OrderNo) from SOHeaderRel (NOLOCK) where pSOHeaderRelID=CustomerMetrics.OrderNo)
	--					when MetricType='IV' then (select InvoiceNo from SOHeaderHist (NOLOCK) where pSOHeaderHistID=CustomerMetrics.OrderNo)
	--					when MetricType='RQ' then (select distinct SessionID from DTQ_CustomerQuotation (NOLOCK) where ID=CustomerMetrics.OrderNo)
	--					else convert(varchar(20), OrderNo) end as OrderNo		
					,Isnull(OrderNo,'-1') as OrderNo
			FROM	CustomerMetrics (NOLOCK)	
			WHERE	ItemNo = @SearchItemNo and CustNo = @Organization and isnull(DeleteDt,'') = ''

			if (@operateMode = 'full')
				BEGIN	--Mode=Full
					DECLARE @Region varchar(10);		

					SELECT	@Region = SalesRegionNo
					FROM	LocMaster LM (nolock) Inner Join 
							CustomerMaster CM (nolock) ON CM.CustShipLocation = LM.LocID
					WHERE	CM.CustNo = @Organization

					-- Last Quote data by region
					SELECT	Top 1
							MetricType
							,MetricDt
							,MetricQty
							,MetricSellPrice
							,MetricMarginAtCost as MetricMarginAtCost
							,MetricMarginAtStd as MetricMarginAtStd
							,MetricMarginAtReplacementCost
							,MetricSellPerLB
							,MetricMarginPerLB
							,MetricSellUMPrice					
							,OrderNo
					FROM	CustomerMetrics CM (NOLOCK)	Inner Join 
							CustomerMaster Cust (NOLOCK) ON CM.CustNo = Cust.CustNo 
					WHERE	CM.SalesRegionNo = @Region
							And CM.ItemNo = @SearchItemNo
							And MetricType ='RQ'
							and isnull(CM.DeleteDt,'') = ''
					Order by CM.MetricDt Desc, pCustMetricsID Desc

					-- Last Order data by region
					SELECT	Top 1
							MetricType
							,MetricDt
							,MetricQty
							,MetricSellPrice
							,MetricMarginAtCost as MetricMarginAtCost
							,MetricMarginAtStd as MetricMarginAtStd
							,MetricMarginAtReplacementCost
							,MetricSellPerLB
							,MetricMarginPerLB
							,MetricSellUMPrice					
							,OrderNo
					FROM	CustomerMetrics CM (NOLOCK)	Inner Join 
							CustomerMaster Cust (NOLOCK) ON CM.CustNo = Cust.CustNo 
					WHERE	CM.SalesRegionNo = @Region
							And CM.ItemNo = @SearchItemNo
							And MetricType ='SO'
							and isnull(CM.DeleteDt,'') = ''
					Order by CM.MetricDt Desc, pCustMetricsID Desc

					-- Get Competitor Pricing						
					SELECT	COMP.CompetitorListCd
							,COMP.CompetitorName
							,isnull(CI.pCompetitorItemsID,0) as pCompetitorItemsID
							,CAST(isnull(CI.CompetitorPrice,0) as decimal(18,2)) as CompetitorPrice
							,isnull(CI.CompetitorPriceUM,'') as CompetitorPriceUM	
							,Case	When isnull(CI.CompetitorStockInd,'N') = 'Y' 
									Then 'STOCK' 
									Else 'NO STOCK'
							 End as CompetitorStockInd
							,CONVERT(nvarchar(20), CI.CompetitorPriceDate, 101)  as CompetitorPriceDate					
					FROM	Competitor COMP (NOLOCK)
					Left Outer Join CompetitorItems CI (NOLOCK) On 
							COMP.RegionLocID = CI.RegionLocID 
							and CI.CompetitorListCd = COMP.CompetitorListCd
							and	CI.PFCItemNo = @SearchItemNo
					WHERE	COMP.RegionLocID = @Region
					Order By COMP.DisplaySequenceNo Asc 
				END	--Mode=Full
		END	--Metrics

	if @HistoryType = 'Summary'
		BEGIN	--Summary
			SELECT	top 13
					FiscalPeriodNo
					,SalesDollars
					,SalesCost
					,NoofOrders
					,OtherSalesCost
					,OtherSalesDol
					,CommissionDollars
					,LatestSalesCost
					,LatestSalesPrice
					,case LatestSalesPrice
						when 0 then 0
						else 100*(LatestSalesPrice-LatestSalesCost)/LatestSalesPrice end as LatestMargin
					,case UnitWeight
						when 0 then 0
						else LatestSalesPrice/UnitWeight end as LatestPriceLB
					,TotalWeight
					,UnitWeight
					,QtyShipped
					,QtyOrdered
			FROM	CustomerSalesSummary (NOLOCK)
			WHERE	ItemNo = @SearchItemNo and CustomerNo = @Organization
			Order by FiscalPeriodNo desc
		END	--Summary

		-- In this mode we just get the true id of the order to open the sorecall\quoterecall page
	if @HistoryType = 'LastMetrics' 
		BEGIN	--Last Metrics
			if (@operateMode = 'SO')
				BEGIN 
					SELECT	convert(varchar(20), OrderNo) as OrderNo 
					FROM	SOHeaderRel (NOLOCK) 
					WHERE	pSOHeaderRelID=@SearchItemNo
				END 

			if (@operateMode = 'IV')
				BEGIN
					SELECT	InvoiceNo as OrderNo 
					FROM	SOHeaderHist (NOLOCK) 
					WHERE	pSOHeaderHistID=@SearchItemNo
				END

			if (@operateMode = 'RQ')
				BEGIN
					SELECT	distinct SessionID as OrderNo  
					FROM	DTQ_CustomerQuotation (NOLOCK) 
					WHERE	ID=@SearchItemNo
				END	

			if (@operateMode = 'WQ')
				BEGIN
					SELECT	SessionID  as OrderNo, QuoteNo
					FROM	WebactivityPosting (NOLOCK)
					WHERE	QuoteRowID = @SearchItemNo
				END			
		END	--Last Metrics

ProcEnd:

END
