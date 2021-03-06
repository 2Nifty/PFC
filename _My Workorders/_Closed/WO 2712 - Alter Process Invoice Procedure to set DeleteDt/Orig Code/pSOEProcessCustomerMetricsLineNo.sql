USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEProcessCustomerMetricsLineNo]    Script Date: 01/05/2012 16:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[pSOEProcessCustomerMetricsLineNo] 
	-- Add the parameters for the stored procedure here
	@orderID BIGINT = 0, 
	@lineNo int = 0,
    @updIns Char(2) = NULL,
    @table VARCHAR(50) = 'SOHeaderRel',
    @metricType Char(2) = 'SO',
    @entryID VARCHAR(50) = NULL,
    @custNo VARCHAR(10) = NULL,
    @orderLoc VARCHAR(10) = NULL,
    @shipLoc VARCHAR(10) = NULL
AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 1/27/2009
-- Description:	Process a customerMetrics Line Item
-- Parameters: @orderID = ID of order for Customermetrics update
--  @lineNo = order line for update insert
--  @uPDINS = 'U' Update CustomerMetrics Row, 'I' Insert new row
--  @table = Indicates source dataset for the Update / Insert
--  @metricType = 'SO' Sales Order, 'IV' invoice, 'RQ' rep quote, 'WQ' web quote
--  @entryID = procedure caller
--  @custno = Customer number from order quote header
--  @orderLoc = Order location from Order / Quote header
--  @shipLoc = Ship From Loc from Order Quote header (NOTE: this could differ from the
--    IMLoc in the line taht indicates where the stock was drawn from.)
-- Modified: 1/28/2009 Craig Parks Create Invoice rows SOHeaderHist
-- Modified: 1/29/2009 Craig Parks Incorporate Quotes and fDivide
-- Modified: 7/21/2009 Craig Parks Add MetricMarginAtReplacementCost
-- Modified: 8/19/2009 Craig Parks Add PriceUM, SellUM, MetricSellUMPrice Modify SalesLocation for Quotes
-- Modified: 10/29/2009 Craig Parks Update Metrics for the Customer Item not just item
-- Modified: 12/7/2009 Craig Parks Insure all columns names are qualified and add CustomerMetrics Order and Line Number
-- Modified: 12/9/2009 Craig Parks Update CustomerMetrics.OrderNo with ID not order number of source table record
-- Modified: 09/16/11 CSR - Changed Margin and Margin/Lb calcs to use Smooth Average (STDCost field)
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
IF @table = 'SOHeaderRel' 
	BEGIN
		IF @uPDINS = 'U' 
			BEGIN
				UPDATE	CustomerMetrics 
				SET		MetricDt = CONVERT(DATETIME,CONVERT(VARCHAR,SD.EntryDate,101)) -- Update CustomerMetrics Row
						,MetricQty=SD.QtyShipped
						,MetricSellPrice = ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice)
						,MetricMarginAtCost = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.OECost), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
						,MetricMarginAtStd = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.UnitCost2), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
						,MetricMarginAtReplacementCost = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.UnitCost3), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
						,MetricSellPerLB = dbo.fDivide(SD.ExtendedPrice , SD.ExtendedNetWght,5)
						,MetricMarginPerLB = (dbo.fDivide(SD.ExtendedPrice, SD.ExtendedNetWght,5) - dbo.fDivide(SD.ExtendedCost, SD.ExtendedNetWght,5))
						,OrderLocation = @OrderLoc
						,ShipFromLocation = @shipLoc
						,PriceUM = AlternateUM
						,SellUM = SellStkUM
						,MetricSellUMPrice = AlternatePrice
						,ChangeID = @entryID
						,ChangeDt = GetDate()
						,CustomerMetrics.OrderNo = SD.fSOHeaderRelID
						,CustomerMetrics.LineNumber = SD.LineNumber
				FROM	SODetailRel SD (NOLOCK)  
				WHERE   fSOHeaderRelID = @orderID 
						AND SD.LineNumber = @lineNo 
						AND CustomerMetrics.ItemNo = SD.ItemNo
						AND CustomerMetrics.CustNo = @CustNo
						-- Note that update only occurs when Entry Date is greater that Custometrics date
						AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,SD.EntryDate,101)) 
						AND MetricType = @metricType
			END -- Update existing Metric
		ELSE 
			BEGIN -- Item Cust No Insert required
				INSERT INTO CustomerMetrics 
						(CustNo
						,ItemNo
						,MetricDt
						,MetricType
						,EntryDt
						,EntryID
						,OrderLocation
						,ShipFromLocation
						,MetricQty
						,MetricSellPrice
						,MetricMarginAtCost
						,MetricMarginAtStd
						,MetricMarginAtReplacementCost
						,MetricSellPerLB
						,MetricMarginPerLB
						,PriceUM
						,SellUM
						,MetricSellUMPrice
						,OrderNo
						,LineNumber
						,SalesRegionNo)
						SELECT	@custNo as CustNo
								,SD.ItemNo as ItemNo
								,CONVERT(DATETIME,CONVERT(VARCHAR,SD.EntryDate,101)) as MetricDt
								,@metricType as MetricType
								,GetDate() as EntryDt
								,'pSOEProcessCustomerMetrics' as EntryID
								,@OrderLoc as OrderLocation
								,@shipLoc as ShipFromLocation
								,SD.QtyShipped as MetricQty
								,ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) as MetricSellPrice
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.OECost) / SD.NetUnitPrice)*100
								End as MetricMarginAtCost
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.UnitCost2) / SD.NetUnitPrice)*100
								End as MetricMarginAtSTD
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.UnitCost3) / SD.NetUnitPrice)*100 
								End as MetricMarginAtReplacementCost
								,CASE	WHEN isnull(SD.ExtendedNetWght,0)= 0 THEN 0
										ELSE SD.ExtendedPrice / SD.ExtendedNetWght 
								End as MetricSellPerLb							
								,CASE	WHEN isnull(SD.ExtendedNetWght,0)= 0 THEN 0
										ELSE (SD.ExtendedPrice-SD.ExtendedCost) / SD.ExtendedNetWght 
								End as MetricMarginPerLb
								,AlternateUM as PriceUM
								,SellStkUM as SellUM
								,AlternatePrice as MetricSellUMPrice
								,SD.fSOHeaderRelID as OrderNo
								,SD.LineNumber as LineNumber
								,LM.SalesRegionNo
						FROM	SODetailRel (NOLOCK) SD 
								,SOHeaderRel (NOLOCK) SH 
								,LocMaster (NOLOCK) LM								
						WHERE	SD.fSOHeaderRelID = @orderID 
								and SD.LineNumber = @lineNo
								AND SD.fSOHeaderRelID = SH.pSOHeaderRelID
								AND LM.LocID = SH.CustShipLoc
				END -- Process Insert 1 Line
			END -- Process Sales Order
		ELSE IF @table = 'SOHeaderHist' 
			BEGIN -- Process invoices
			IF @uPDINS = 'U' 
				BEGIN -- ItemCust No Update
					UPDATE	CustomerMetrics 
					SET		MetricDt = CONVERT(DATETIME,CONVERT(VARCHAR,SH.InvoiceDt,101))
							,MetricQty=SD.QtyShipped
							,MetricSellPrice = ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice)
							,MetricMarginAtCost = CASE	WHEN isnull(SD.NetUnitPrice,0) = 0 then 0
														ELSE ((SD.NetUnitPrice - SD.OECost)/SD.NetUnitPrice)*100 END
							,MetricMarginAtStd =  CASE	WHEN isnull(SD.NetUnitPrice,0) = 0 then 0
														ELSE ((SD.NetUnitPrice - SD.UnitCost2)/SD.NetUnitPrice)*100 END 
							,MetricSellPerLB =    CASE	WHEN isnull(SD.ExtendedNetWght,0) = 0 then 0
														ELSE SD.ExtendedPrice/SD.ExtendedNetWght END 
							,MetricMarginPerLB =  CASE	WHEN isnull(SD.ExtendedNetWght,0) = 0 then 0
														ELSE (SD.NetUnitPrice - SD.OECost)/SD.ExtendedNetWght END
							,MetricMarginAtReplacementCost =
												  CASE	WHEN isnull(SD.NetUnitPrice,0) = 0 then 0
														ELSE ((SD.NetUnitPrice - SD.UnitCost3)/SD.NetUnitPrice)*100 END
							,OrderLocation = @OrderLoc
							,ShipFromLocation = @shipLoc
							,PriceUM = AlternateUM
							,SellUM = SellStkUM
							,MetricSellUMPrice = AlternatePrice
							,ChangeID = @entryID
							,ChangeDt = GetDate()
							,CustomerMetrics.OrderNo = SH.pSOHeaderHistID
							,CustomerMetrics.LineNumber = SD.LineNumber
					FROM	SODetailHist SD
							,SOHeaderHist SH 
					WHERE   SD.fSOHeaderHistID = @orderID 
							AND SD.fSOHeaderHistID = SH.pSOHeaderHistID
							AND SD.LineNumber = @lineNo 
							AND CustomerMetrics.ItemNo = SD.ItemNo
							AND CustomerMetrics.CustNo = @CustNo
							-- Note that update only occurs when Invoice Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,SH.InvoiceDt,101)) 
							AND MetricType = @metricType
				END -- Update existing Metric
			ELSE 
				BEGIN -- Item Cust No Insert required
					INSERT INTO CustomerMetrics 
						(CustNo
						,ItemNo
						,MetricDt
						,MetricType
						,EntryDt
						,EntryID
						,OrderLocation
						,ShipFromLocation
						,MetricQty
						,MetricSellPrice
						,MetricMarginAtCost
						,MetricMarginAtStd
						,MetricMarginAtReplacementCost
						,MetricSellPerLB
						,MetricMarginPerLB
						,PriceUM 
						,SellUM 
						,MetricSellUMPrice 
						,OrderNo
						,LineNumber
						,SalesRegionNo)
						SELECT	@custNo AS CustNo
								,SD.ItemNo as ItemNo
								,CONVERT(DATETIME,CONVERT(VARCHAR,SH.InvoiceDt,101)) as MetricDt
								,@metricType as MetricType
								,GetDate() as EntryDt
								,'pSOEProcessCustomerMetrics' as EntryID
								,@OrderLoc as OrderLocation
								,@shipLoc as ShipFromLocation
								,SD.QtyShipped as MetricQty
								,ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) as MetricSellPrice
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.OECost) / SD.NetUnitPrice)*100
								End as MetricMarginAtCost
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.UnitCost2) / SD.NetUnitPrice)*100 
								End as MetricMarginAtSTD
								,CASE	WHEN isnull(SD.NetUnitPrice,0)= 0 THEN 0
										ELSE ((SD.NetUnitPrice - SD.UnitCost3) / SD.NetUnitPrice)*100 
								End as MetricMarginAtReplacementCost
								,CASE	WHEN isnull(SD.ExtendedNetWght,0)= 0 THEN 0
										ELSE SD.ExtendedPrice / SD.ExtendedNetWght 
								End as MetricSellPerLb							
								,CASE	WHEN isnull(SD.ExtendedNetWght,0)= 0 THEN 0
										ELSE (SD.ExtendedPrice-SD.ExtendedCost) / SD.ExtendedNetWght 
								End as MetricMarginPerLb
								,AlternateUM as PriceUM
								,SellStkUM as SellUM
								,AlternatePrice as MetricSellUMPrice
								,SH.pSOHeaderHistID as OrderNo
								,SD.LineNumber as LineNumber
								,LM.SalesRegionNo								
						FROM	SoDetailHist SD (NOLOCK) 
								INNER JOIN SOHeaderHist SH (NOLOCK) ON
									SD.fSOHeaderHistID = SH.pSOHeaderHistID	
								INNER JOIN CustomerMaster CM (NOLOCK) ON 
									SH.SellToCustNo = CM.CustNo 
								INNER JOIN LocMaster LM (NOLOCK) ON 
									CM.CustShipLocation = LM.LocID																
						WHERE   SD.fSOHeaderHistID = @orderID 
								and SD.LineNumber = @lineNo
				END -- Process Insert 1 Line
			END -- @table SOHeaderHist
		ELSE IF (@table = 'RepQuote') 
			BEGIN -- Process Quotes
				IF @uPDINS = 'U' 
				BEGIN -- ItemCust No Update
					UPDATE	CustomerMetrics 
					SET		MetricDt = CONVERT(DATETIME,CONVERT(VARCHAR,SD.QuotationDate,101))
							,MetricQty=SD.RequestQuantity
							,MetricSellPrice = ISNULL(NULLIF(SD.UnitPrice,0),0)
							-- CSR WO2550 Use Smooth Average Cost (STD Cost field) for RQ 
							,MetricMarginAtCost = CASE	WHEN isnull(SD.UnitPrice,0) = 0 then 0
														ELSE ((SD.UnitPrice - isnull(IB.StdCost,0))/SD.UnitPrice)*100 END
							-- CSR WO2550 Show Price Cost in STD field for RQ 
							,MetricMarginAtStd =  CASE	WHEN isnull(SD.UnitPrice,0) = 0 then 0
														ELSE ((SD.UnitPrice - isnull(IB.PriceCost,0))/SD.UnitPrice)*100 END 
							,MetricSellPerLB =    CASE	WHEN isnull(IM.Wght,0) = 0 then 0
														ELSE SD.UnitPrice/IM.Wght END 
							,MetricMarginPerLB =  CASE	WHEN isnull(IM.Wght,0)= 0 then 0
														ELSE (SD.UnitPrice - isnull(IB.StdCost,0))/IM.Wght END
							,MetricMarginAtReplacementCost =
												  CASE	WHEN isnull(SD.UnitPrice,0) = 0 then 0
														ELSE ((SD.UnitPrice - isnull(IB.ReplacementCost,0))/SD.UnitPrice)*100 END
							,OrderLocation = SalesLocationCode
							,ShipFromLocation = @shipLoc
							,PriceUM = PriceUOM
							,SellUM = BaseUOM
							,MetricSellUMPrice = AltPrice
							,ChangeID = @entryID
							,ChangeDt = GetDate()
							,OrderNO = SD.ID
							,LineNumber = @LineNo
					FROM	dbo.DTQ_CustomerQuotation SD 
							,ItemBranch IB 
							,ItemMaster IM							
					WHERE	SD.ID = @orderID 
							AND IB.fItemMasterID = IM.pItemMasterID 
							AND CustomerMetrics.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
							AND CustomerMetrics.ItemNo = IM.ItemNo
							AND CustomerMetrics.CustNo = @CustNo
							AND IB.Location = @orderLoc
							-- Note that update only occurs when Invoice Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,QuotationDate,101)) 
							AND MetricType = @metricType
				END -- Update existing Metric
			ELSE 
				BEGIN -- Item Cust No Insert required
					INSERT INTO CustomerMetrics 
							(CustNo
							,ItemNo
							,MetricDt
							,MetricType
							,EntryDt
							,EntryID
							,OrderLocation
							,ShipFromLocation
							,MetricQty
							,MetricSellPrice
							,MetricMarginAtCost
							,MetricMarginAtStd
							,MetricMarginAtReplacementCost
							,MetricSellPerLB
							,MetricMarginPerLB
							,PriceUM 
							,SellUM
							,MetricSellUMPrice 
							,OrderNo
							,LineNumber
							,SalesRegionNo)
							SELECT	@custNo as CustNo
									,SD.PFCItemNo as ItemNo
									,CONVERT(DATETIME,CONVERT(VARCHAR,QuotationDate,101)) as MetricDt
									,@metricType as MetricType
									,GetDate() as EntryDt
									,'pSOEProcessCustomerMetrics' as EntryID
									,@OrderLoc as OrderLocation
									,SalesLocationCode as ShipFromLocation
									,SD.RequestQuantity as MetricQty
									,ISNULL(SD.UnitPrice,0) as MetricSellPrice
									-- CSR WO2550 Use Smooth Average Cost (STD Cost field) for RQ 
									,CASE	WHEN isnull(SD.UnitPrice,0)= 0 THEN 0
											ELSE ((SD.UnitPrice - isnull(IB.StdCost,0)) / SD.UnitPrice)*100 
									End as MetricMarginAtCost
									,CASE	WHEN isnull(SD.UnitPrice,0)= 0 THEN 0
											ELSE ((SD.UnitPrice - isnull(IB.PriceCost,0)) / SD.UnitPrice)*100 
									End as MetricMarginAtStd
									,CASE	WHEN isnull(SD.UnitPrice,0)= 0 THEN 0
											ELSE ((SD.UnitPrice - isnull(IB.ReplacementCost,0)) / SD.UnitPrice)*100 
									End as MetricMarginAtReplacementCost
									,CASE	WHEN ISNULL(IM.Wght,0) = 0 then 0
											ELSE SD.TotalPrice / IM.Wght
									END as MetricSellPerLB
									,CASE	WHEN ISNULL(IM.Wght,0)  = 0 then 0
											ELSE (SD.UnitPrice - isnull(IB.StdCost,0)) /IM.Wght
									END as MetricMarginPerLB
									,PriceUOM
									,BaseUOM as SellUM
									,AltPrice as MetricSellUMPrice
									,SD.ID as OrderNo
									,@LineNo as LineNumber
									,LM.SalesRegionNo
						    FROM	dbo.DTQ_CustomerQuotation SD (NOLOCK) 
							INNER JOIN ItemMaster IM (NOLOCK) ON
									IM.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
							INNER JOIN ItemBranch IB (NOLOCK) ON
									IB.fItemMasterID = IM.pItemMasterID 
							INNER JOIN CustomerMaster CM (NOLOCK) ON 
									SD.CustomerNumber = CM.CustNo 
							INNER JOIN LocMaster LM (NOLOCK) ON CM.CustShipLocation = LM.LocID
							WHERE   SD.ID = @orderID 
									AND IB.Location = @orderLoc
				END -- Process Insert 1 Line
			END -- @Table = 'RepQuote
		ELSE IF (@table = 'WebQuote') 
			BEGIN -- Process WebQuotes
			IF @updIns = 'U' 
				BEGIN -- ItemCust No Update
					UPDATE	CustomerMetrics 
					SET		MetricDt = dbo.fStripDate(WAP.QuoteDt)
							,MetricQty=WAP.Qty
							,MetricSellPrice = ISNULL(NULLIF(WAP.SellPrice,0),0)
							,MetricMarginAtCost = 100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.AvgCost), WAP.SellPrice,4)
							,MetricMarginAtStd = 100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.StdCost), WAP.SellPrice,4)
							,MetricMarginAtReplacementCost = 100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.ReplacementCost), ISNULL(NULLIF(WAP.SellPrice,0),0),4)
							,MetricSellPerLB = dbo.fDivide((WAP.SellPrice * WAP.Qty), (ISNULL(IM.Wght,0) * WAP.Qty),5)
							,MetricMarginPerLB = (dbo.fDivide((WAP.SellPrice * WAP.Qty), (ISNULL(IM.Wght,0) * WAP.Qty),5) - dbo.fDivide((IB.AvgCost * WAP.Qty), (ISNULL(IM.Wght,0) * WAP.Qty),5))
							,OrderLocation = ISNULL(WAP.EntryLocation,WAP.ShipFromLocation)
							,ShipFromLocation = WAP.ShipFromLocation
							,PriceUM = WAP.AlternateUM
							,SellUM = WAP.SellUM
							,MetricSellUMPrice = AlternatePrice
							,ChangeID = @entryID
							,ChangeDt = GetDate()
							,OrderNo = WAP.QuoteRowID
							,LineNumber = @LineNo			
					FROM  	WebActivityPosting WAP (NOLOCK)
							,ItemBranch IB (NOLOCK)
							,ItemMaster IM (NOLOCK)			
					WHERE	fItemMasterID = pItemMasterID 
							AND WAP.QuoteRowID = @orderID 
							AND CustomerMetrics.ItemNo = WAP.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
							AND CustomerMetrics.ItemNo = IM.ItemNo
							AND CustomerMetrics.CustNo = @CustNo    
							AND IB.Location = @orderLoc
							-- Note that update only occurs when Quote Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < dbo.fStripDate(WAP.QuoteDt) 
							AND MetricType = @metricType									
		
				END -- Update existing Metric
			ELSE 
				BEGIN -- Item Cust No Insert required
					INSERT INTO CustomerMetrics 
							(CustNo
							,ItemNo
							,MetricDt
							,MetricType
							,EntryDt
							,EntryID
							,OrderLocation
							,ShipFromLocation
							,MetricQty
							,MetricSellPrice
							,MetricMarginAtCost
							,MetricMarginAtStd
							,MetricMarginAtReplacementCost
							,MetricSellPerLB
							,MetricMarginPerLB
							,PriceUM 
							,SellUM 
							,MetricSellUMPrice 
							,OrderNo
							,LineNumber
							,SalesRegionNo)
							SELECT	@custNo
									,WAP.ItemNo
									,dbo.fStripDate(QuoteDt)
									,@metricType
									,GetDate()
									,'pSOEProcessCustomerMetrics'
									,ISNULL(WAP.EntryLocation,WAP.ShipFromLocation)
									,WAP.ShipFromLocation
									,WAP.Qty
									,ISNULL(WAP.SellPrice,0)
									,100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.AvgCost), WAP.SellPrice,4)
									,100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.StdCost), WAP.SellPrice,4)
									,100 * dbo.fDivide((ISNULL(NULLIF(WAP.SellPrice,0),0) - IB.ReplacementCost), ISNULL(NULLIF(WAP.SellPrice,0),0),4)
									,dbo.fDivide((WAP.SellPrice * WAP.Qty), (ISNULL(IM.Wght,0) * WAP.Qty),5)
									,(dbo.fDivide((WAP.SellPrice * WAP.Qty), (ISNULL(IM.Wght,0) * WAP.Qty),5) - dbo.fDivide((IB.AvgCost * WAP.Qty), (ISNULL(IM.Wght,0) * Qty),5))
									,WAP.AlternateUM
									,WAP.SellUM
									,WAP.AlternatePrice
									,WAP.QuoteRowID
									,@LineNo
									,LM.SalesRegionNo
							FROM	WebActivityPosting WAP (NOLOCK)
									,ItemBranch IB (NOLOCK)
									,ItemMaster IM (NOLOCK)
									,LocMaster LM (NOLOCK)
									,CustomerMaster CM (NOLOCK)			
							WHERE	fItemMasterID = pItemMasterID 
									AND WAP.QuoteRowID = @orderID 
									AND IM.ItemNo = WAP.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
									AND IB.Location = @orderLoc			
									AND CM.CustNo = @custNo
									AND LM.LocID = CM.CustShipLocation
				END -- Process Insert 1 Metric

		END -- @table  Web Quote
END -- Procedure

/* SELECT * FROM ItemBranch JOIN ItemMaster  ON fItemMasterID = pItemMasterID where ItemNo = '00022-2450-601'
and Location = '01'

*/











