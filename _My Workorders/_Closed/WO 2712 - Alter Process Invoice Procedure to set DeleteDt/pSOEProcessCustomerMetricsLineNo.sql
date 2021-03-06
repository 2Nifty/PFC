

drop proc [pSOEProcessCustomerMetricsLineNo]
go

/****** Object:  StoredProcedure [dbo].[pSOEProcessCustomerMetricsLineNo]    Script Date: 01/05/2012 16:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSOEProcessCustomerMetricsLineNo] 
	@orderID BIGINT = 0, 
	@lineNo int = 0,
    @updIns Char(2) = NULL,		-- UPDATE or INSERT Ctl
    @table VARCHAR(50) = 'SOHeaderRel',
    @metricType Char(2) = 'SO',
    @entryID VARCHAR(50) = NULL,
    @custNo VARCHAR(10) = NULL,
    @orderLoc VARCHAR(10) = NULL,
    @shipLoc VARCHAR(10) = NULL
AS
BEGIN
	-- =============================================
	-- Created:	Craig Parks
	-- Date:	01/27/2009
	-- Desc:	Process a CustomerMetrics Line Item
	-- Params:	@orderID = ID of order for CustomerMetrics update
	--			@lineNo = order line for update insert
	--			@updIns = 'U' Update CustomerMetrics Row, 'I' Insert new row
	--			@table = Indicates source dataset for the Update / Insert
	--			@metricType = 'SO' Sales Order, 'IV' invoice, 'RQ' rep quote, 'WQ' web quote
	--			@entryID = procedure caller
	--			@custNo = Customer number from order quote header
	--			@orderLoc = Order location from Order / Quote header
	--			@shipLoc = Ship From Loc from Order Quote header
	--						(NOTE: this could differ from the IMLoc in the line
	--							   that indicates where the stock was drawn from)
	-- =============================================all 4 update statements (
	-- Mod: 01/28/2009 Craig Parks Create Invoice rows SOHeaderHist
	-- Mod: 01/29/2009 Craig Parks Incorporate Quotes and fDivide
	-- Mod: 07/21/2009 Craig Parks Add MetricMarginAtReplacementCost
	-- Mod: 08/19/2009 Craig Parks Add PriceUM, SellUM, MetricSellUMPrice Modify SalesLocation for Quotes
	-- Mod: 10/29/2009 Craig Parks Update Metrics for the Customer Item not just item
	-- Mod: 12/07/2009 Craig Parks Insure all columns names are qualified and add CustomerMetrics Order and Line Number
	-- Mod: 12/09/2009 Craig Parks Update CustomerMetrics.OrderNo with ID not order number of source table record
	--
	-- Mod: 09/16/2011 CSR:	Changed Margin and Margin/Lb calcs to use Smooth Average (STDCost field)
	-- Mod: 01/09/2012 TMD:	If the record being updated had the DeleteDt set, unset the DeleteDt
	-- =============================================

	SET NOCOUNT ON;

	--SOHeaderRel - Released Orders (REL)
	IF @table = 'SOHeaderRel' 
		BEGIN	-- Begin SOHeaderRel
			IF @updIns = 'U' 
				BEGIN	-- UPDATE existing Metric (REL)
					UPDATE	CustomerMetrics 
					SET		MetricDt = CONVERT(DATETIME,CONVERT(VARCHAR,SD.EntryDate,101)) -- Update CustomerMetrics Row
							,MetricQty=SD.QtyShipped
							,MetricSellPrice = ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice)
							,MetricMarginAtCost = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.OECost), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
							,MetricMarginAtStd = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.UnitCost2), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
							,MetricMarginAtReplacementCost = 100 * dbo.fDivide((ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice) - SD.UnitCost3), ISNULL(NULLIF(SD.DiscUnitPrice,0),SD.NetUnitPrice),4)
							,MetricSellPerLB = dbo.fDivide(SD.ExtendedPrice , SD.ExtendedNetWght,5)
							,MetricMarginPerLB = (dbo.fDivide(SD.ExtendedPrice, SD.ExtendedNetWght,5) - dbo.fDivide(SD.ExtendedCost, SD.ExtendedNetWght,5))
							,OrderLocation = @orderLoc
							,ShipFromLocation = @shipLoc
							,PriceUM = AlternateUM
							,SellUM = SellStkUM
							,MetricSellUMPrice = AlternatePrice
							,ChangeID = @entryID
							,ChangeDt = GetDate()
							,DeleteDt = null
							,CustomerMetrics.OrderNo = SD.fSOHeaderRelID
							,CustomerMetrics.LineNumber = SD.LineNumber
					FROM	SODetailRel SD (NOLOCK)  
					WHERE   fSOHeaderRelID = @orderID 
							AND SD.LineNumber = @lineNo 
							AND CustomerMetrics.ItemNo = SD.ItemNo
							AND CustomerMetrics.CustNo = @custNo
							-- Note that update only occurs when Entry Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,SD.EntryDate,101)) 
							AND MetricType = @metricType
				END		-- UPDATE existing Metric (REL)
			ELSE 
				BEGIN	-- INSERT Item Cust No Metric (REL)
					INSERT INTO	CustomerMetrics 
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
								,@orderLoc as OrderLocation
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
				END	-- INSERT Item Cust No Metric (REL)
		END	-- Begin SOHeaderRel

	ELSE

	--SOHeaderHist - Invoices (HIST)
	IF @table = 'SOHeaderHist'
		BEGIN	-- Begin SOHeaderHist
			IF @updIns = 'U' 
				BEGIN	-- UPDATE existing Metric (HIST)
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
							,OrderLocation = @orderLoc
							,ShipFromLocation = @shipLoc
							,PriceUM = AlternateUM
							,SellUM = SellStkUM
							,MetricSellUMPrice = AlternatePrice
							,ChangeID = @entryID
							,ChangeDt = GetDate()
							,DeleteDt = null
							,CustomerMetrics.OrderNo = SH.pSOHeaderHistID
							,CustomerMetrics.LineNumber = SD.LineNumber
					FROM	SODetailHist SD
							,SOHeaderHist SH 
					WHERE   SD.fSOHeaderHistID = @orderID 
							AND SD.fSOHeaderHistID = SH.pSOHeaderHistID
							AND SD.LineNumber = @lineNo 
							AND CustomerMetrics.ItemNo = SD.ItemNo
							AND CustomerMetrics.CustNo = @custNo
							-- Note that update only occurs when Invoice Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,SH.InvoiceDt,101)) 
							AND MetricType = @metricType
				END		-- UPDATE existing Metric (HIST)
			ELSE 
				BEGIN	-- INSERT Item Cust No Metric (HIST)
					INSERT INTO	CustomerMetrics 
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
								,@orderLoc as OrderLocation
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
				END	-- INSERT Item Cust No Metric (HIST)
		END	-- Begin SOHeaderHist

	ELSE

	--RepQuote - Internal Quote
	IF @table = 'RepQuote'
		BEGIN	-- Begin RepQuote
			IF @updIns = 'U' 
				BEGIN	-- UPDATE existing Metric (RepQuote)
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
							,DeleteDt = null
							,OrderNO = SD.ID
							,LineNumber = @lineNo
					FROM	dbo.DTQ_CustomerQuotation SD 
							,ItemBranch IB 
							,ItemMaster IM							
					WHERE	SD.ID = @orderID 
							AND IB.fItemMasterID = IM.pItemMasterID 
							AND CustomerMetrics.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
							AND CustomerMetrics.ItemNo = IM.ItemNo
							AND CustomerMetrics.CustNo = @custNo
							AND IB.Location = @orderLoc
							-- Note that update only occurs when Invoice Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < CONVERT(DATETIME,CONVERT(VARCHAR,QuotationDate,101)) 
							AND MetricType = @metricType
				END		-- UPDATE existing Metric (RepQuote)
			ELSE 
				BEGIN	-- INSERT Item Cust No Metric (RepQuote)
					INSERT INTO	CustomerMetrics 
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
								,@orderLoc as OrderLocation
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
								,@lineNo as LineNumber
								,LM.SalesRegionNo
						FROM	dbo.DTQ_CustomerQuotation SD (NOLOCK) 
						INNER JOIN ItemMaster IM (NOLOCK) ON
								IM.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
						INNER JOIN ItemBranch IB (NOLOCK) ON
								IB.fItemMasterID = IM.pItemMasterID 
						INNER JOIN CustomerMaster CM (NOLOCK) ON 
								SD.CustomerNumber = CM.CustNo 
						INNER JOIN LocMaster LM (NOLOCK) ON CM.CustShipLocation = LM.LocID
						WHERE   SD.ID = @orderID AND IB.Location = @orderLoc
				END	-- INSERT Item Cust No Metric (RepQuote)
		END -- End RepQuote

	ELSE

	--WebQuote - PFCDirect, Web, SDK, InxSQL
	IF @table = 'WebQuote'
		BEGIN	-- Begin WebQuote
			IF @updIns = 'U' 
				BEGIN	-- UPDATE existing Metric (WebQuote)
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
							,DeleteDt = null
							,OrderNo = WAP.QuoteRowID
							,LineNumber = @lineNo			
					FROM  	WebActivityPosting WAP (NOLOCK)
							,ItemBranch IB (NOLOCK)
							,ItemMaster IM (NOLOCK)			
					WHERE	fItemMasterID = pItemMasterID 
							AND WAP.QuoteRowID = @orderID 
							AND CustomerMetrics.ItemNo = WAP.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
							AND CustomerMetrics.ItemNo = IM.ItemNo
							AND CustomerMetrics.CustNo = @custNo    
							AND IB.Location = @orderLoc
							-- Note that update only occurs when Quote Date is greater that Custometrics date
							AND CustomerMetrics. MetricDt < dbo.fStripDate(WAP.QuoteDt) 
							AND MetricType = @metricType
				END		-- UPDATE existing Metric (WebQuote)
			ELSE 
				BEGIN	-- INSERT Item Cust No Metric (WebQuote)
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
								,@lineNo
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
				END		-- INSERT Item Cust No Metric (WebQuote)
		END	-- End WebQuote
END -- Procedure












