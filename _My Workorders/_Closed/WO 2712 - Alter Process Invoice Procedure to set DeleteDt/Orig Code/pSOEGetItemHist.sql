USE [PERP]
GO
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
	@HistoryType VARCHAR(20) = '',
	@operateMode Varchar(20) = 'full'

AS
BEGIN
	SET NOCOUNT ON;
	-- HistoryType is Metrics to get CustomerMetrics or Summary to get CustomerSalesSummary
	-- setup environment
	declare @ErrorClass char(4);
	declare @ErrorType char(4);
	declare @ErrorCode varchar(4);
	-- set defaults
	set @ErrorClass = 'SOE';
	set @ErrorType = '';
	set @ErrorCode = '0000';
	-- Normal end of procedure
	GOTO NormalEnd;

ErrorResult:
	-- something bad happened, we send back only the procedure results
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;
	GOTO ProcEnd;
NormalEnd:
	-- Normal end of procedure. Return procedure results and data
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;
	-- give it back
	if @HistoryType = 'Metrics'
	Begin
		-- Last Quote data by cust #
		SELECT MetricType
			,MetricDt
			,MetricQty
			,MetricSellPrice
			,MetricMarginAtCost as MetricMarginAtCost
			,MetricMarginAtStd as MetricMarginAtStd
			,MetricMarginAtReplacementCost
			,MetricSellPerLB
			,MetricMarginPerLB
			,MetricSellUMPrice
--			,case 
--				when OrderNo is null then '-1'
--				when MetricType='SO' then (select convert(varchar(20), OrderNo) from SOHeaderRel with (NOLOCK) where pSOHeaderRelID=CustomerMetrics.OrderNo)
--				when MetricType='IV' then (select InvoiceNo from SOHeaderHist with (NOLOCK) where pSOHeaderHistID=CustomerMetrics.OrderNo)
--				when MetricType='RQ' then (select distinct SessionID from DTQ_CustomerQuotation with (NOLOCK) where ID=CustomerMetrics.OrderNo)
--				else convert(varchar(20), OrderNo) end as OrderNo		
			,Isnull(OrderNo,'-1') as OrderNo
			FROM CustomerMetrics  WITH (NOLOCK)	
			where ItemNo = @SearchItemNo
			and CustNo = @Organization

		If (@operateMode = 'full')
		Begin
			Declare @Region varchar(10);		

			Select	@Region = SalesRegionNo
			From	LocMaster LM (nolock) Inner Join 
					CustomerMaster CM (nolock) ON CM.CustShipLocation = LM.LocID
			Where	CM.CustNo = @Organization

			-- Last Quote data by region
			SELECT	Top 1 MetricType
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
			where	CM.SalesRegionNo = @Region
					And CM.ItemNo = @SearchItemNo
					And MetricType ='RQ'
			Order by CM.MetricDt Desc, pCustMetricsID Desc

			-- Last Order data by region
			SELECT	Top 1 MetricType
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
			where	CM.SalesRegionNo = @Region
					And CM.ItemNo = @SearchItemNo
					And MetricType ='SO'
			Order by CM.MetricDt Desc, pCustMetricsID Desc

			-- Get Competitor Pricing						
			Select	COMP.CompetitorListCd
					,COMP.CompetitorName
					,isnull(CI.pCompetitorItemsID,0) as pCompetitorItemsID
					,CAST(isnull(CI.CompetitorPrice,0) as decimal(18,2)) as CompetitorPrice
					,isnull(CI.CompetitorPriceUM,'') as CompetitorPriceUM	
					,Case	When isnull(CI.CompetitorStockInd,'N') = 'Y' 
							Then 'STOCK' 
							Else 'NO STOCK'
					 End as CompetitorStockInd
					,CONVERT(nvarchar(20), CI.CompetitorPriceDate, 101)  as CompetitorPriceDate					
			From	Competitor COMP (NOLOCK)
			Left Outer Join CompetitorItems CI (NOLOCK) On 
					COMP.RegionLocID = CI.RegionLocID 
					and CI.CompetitorListCd = COMP.CompetitorListCd
					and	CI.PFCItemNo = @SearchItemNo
			Where	COMP.RegionLocID = @Region
			Order By COMP.DisplaySequenceNo Asc 

		End
	
	End
	if @HistoryType = 'Summary'
		begin
		SELECT top 13 FiscalPeriodNo
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
			from CustomerSalesSummary WITH (NOLOCK)
			where ItemNo = @SearchItemNo
			and CustomerNo = @Organization
			order by FiscalPeriodNo desc
		end
		-- In this mode we just get the true id of the order to open the sorecall\quoterecall page
		if @HistoryType = 'LastMetrics' 
		begin
			If( @operateMode = 'SO')
			Begin 
				Select	convert(varchar(20), OrderNo) as OrderNo 
				From	SOHeaderRel with (NOLOCK) 
				Where	pSOHeaderRelID=@SearchItemNo
			End 
			If( @operateMode = 'IV')
			Begin
				Select	InvoiceNo as OrderNo 
				From	SOHeaderHist with (NOLOCK) 
				Where	pSOHeaderHistID=@SearchItemNo
			End
			If( @operateMode = 'RQ')
			Begin
				Select	distinct SessionID as OrderNo  
				From	DTQ_CustomerQuotation with (NOLOCK) 
				Where	ID=@SearchItemNo
			End	
			If( @operateMode = 'WQ')
			Begin
				Select	SessionID  as OrderNo
						,QuoteNo
				From	WebactivityPosting (NOLOCK)
				Where	QuoteRowID = @SearchItemNo
			End			
		end

ProcEnd:
-- final clean up

END
