drop procedure pSOECreateHistOrdDetail
go


CREATE PROCEDURE [dbo].[pSOECreateHistOrdDetail] 
	@userName VARCHAR(50) = NULL,
	@orderID BIGINT = 0
AS
BEGIN
	-- =============================================
	-- Author:	Craig Parks
	-- Create date:	11/4/2008
	-- Parameters: 	@username = Calling Process
	-- 		@orderID release Order ID and History Order Number
	-- Description:	Create Sales Order History Detail lines
	-- Modified: 1/9/2009 Craig parks Add new Detail column: UsageLoc
	-- Modified: 1/14/2009 CSP Add Alternate Price
	-- Modified 2/11/2009 Craig Parks Add Super Eqv and CarrierCd
	-- Modified 3/2/2009 Craig Parks Add column IMLocName
	-- Modified: 4/2/2009 Craig Parks Add StkUM
	-- Modified: 6/23/2009 Craig Parks Add FreightCd
	-- Modified: 8/13/2009 Craig Parks Move Transfer Orders to TODetailHist
	-- Modified: 11/2/2009 Craig Parks Add Quote Reference columns ReferenceNo & ReferenceNoDt
	-- Modified: 10/21/10 TMD: Write to TODetailHist where SUBTYPE = 41 thru 49 [WO2097]
	-- =============================================

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@subType VARCHAR(2)
	SELECT @subType = SubType FROM SOHeaderRel WHERE OrderNo = @orderID

	-- See if the Released order is a Transfer or WorkOrder SubType
	IF (CONVERT(INT, @subtype) = 5 or (CONVERT(INT, @subtype) >= 41 and CONVERT(INT, @subtype) <= 49))
	   BEGIN	-- Insert into TODetailHist
		EXEC [pSOECreateTOHistOrdDetail] @username=@username, @orderID=@orderID
	   END
	ELSE
	   BEGIN	-- Insert into SODetailHist
		INSERT
		INTO	dbo.SODetailHist
			(fSOHeaderHistID, LineNumber, LineSeq, LineType, LinePriceInd, LineReason, LineReasonDsc,
			 LineExpdCd, LineExpdCdDsc, LineStatus, POLine, TaxStatus, ItemNo, ItemDsc, BinLoc, IMLoc,
			 DiscInd, ReleaseInd, CostInd, ServChrgInd, XrefCd, OrderLvlCd, BOLCategoryCd, PriceCd,
			 DealerCd, LISC, LISource, RevLvl, QtyStat, DealerNo, ComPct, ComDol, NetUnitPrice,
			 ListUnitPrice, DiscUnitPrice, DiscPct1, DiscPct2, DiscPct3, QtyAvailLoc1, QtyAvail1,
			 QtyAvailLoc2, QtyAvail2, QtyAvailLoc3, QtyAvail3, OrigOrderNo, OrigOrderLineNo,
			 RqstdShipDt, OrigShipDt, ActualShipDt, LineSchDtChange, SuggstdShipDt, DeleteDt,
			 QtyOrdered, QtyShipped, QtyBO, SellStkUM, SellStkFactor, UnitCost, UnitCost2, UnitCost3,
			 RepCost, OECost, RebateAmt, SuggstdShipFrLoc, SuggstdShipFrName, NoReschd, Remark,
			 CustItemNo, CustItemDsc, BOMQtyPer, BOMQtyIssued, EntryDate, EntryID, GrossWght, NetWght,
			 ExtendedPrice, ExtendedCost, ExtendedNetWght, ExtendedGrossWght, SellStkQty, AlternateUM,
			 AlternateUMQty, ShipThruLoc, fSODetailID, QtyStatus, ExcludedFromUsageFlag, OriginalQtyRequested,
			 UsageLoc, AlternatePrice, SuperEquivQty, SuperEquivUM, CarrierCd, IMLocName, StkUM, FreightCd,
			 CertRequiredInd, ReferenceNo, ReferenceNoDt)
		SELECT	SOHH.pSOHeaderHistID, LineNumber, LineSeq, LineType, LinePriceInd, LineReason, LineReasonDsc,
			LineExpdCd, LineExpdCdDsc, LineStatus, POLine, TaxStatus, ItemNo, ItemDsc, BinLoc, IMLoc,
			DiscInd, ReleaseInd, CostInd, ServChrgInd, XrefCd, OrderLvlCd, BOLCategoryCd, SODR.PriceCd,
			DealerCd, LISC, LISource, RevLvl, QtyStat, DealerNo, ComPct, ComDol, NetUnitPrice,
			ListUnitPrice, DiscUnitPrice, DiscPct1, DiscPct2, DiscPct3, QtyAvailLoc1, QtyAvail1,
			QtyAvailLoc2, QtyAvail2, QtyAvailLoc3, QtyAvail3, OrigOrderNo, OrigOrderLineNo,
			RqstdShipDt, SODR.OrigShipDt, ActualShipDt, LineSchDtChange, SuggstdShipDt, SODR.DeleteDt,
			QtyOrdered, QtyShipped, QtyBO, SellStkUM, SellStkFactor, UnitCost, UnitCost2, UnitCost3,
			RepCost, OECost, RebateAmt, SuggstdShipFrLoc, SuggstdShipFrName, NoReschd, Remark,
			CustItemNo, CustItemDsc, BOMQtyPer, BOMQtyIssued, GetDate() AS EntryDt, @userName, GrossWght, NetWght,
			ExtendedPrice, ExtendedCost, ExtendedNetWght, ExtendedGrossWght, SellStkQty, AlternateUM,
			AlternateUMQty,SODR.ShipThruLoc,pSODetailRelID,QtyStatus,ExcludedFromUsageFlag, OriginalQtyRequested,
			SODR.UsageLoc, AlternatePrice, SuperEquivQty, SuperEquivUM, CarrierCd, IMLocName, StkUM, FreightCd,
			SODR.CertRequiredInd, SODR.ReferenceNo, SODR.ReferenceNoDt
		FROM	SOHeaderHist (NOLOCK) SOHH,
			SODetailRel (NOLOCK) SODR
		WHERE	SODR.fSOHeaderRelID = @orderID AND SOHH.OrderNo = @orderID AND SODR.DeleteDt IS NULL
	   END -- Create SODetailHist
	RETURN(0)
END