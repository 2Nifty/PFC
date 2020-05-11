drop procedure pSOECreateHistOrdHeader
go

CREATE PROCEDURE [dbo].[pSOECreateHistOrdHeader] 
	@userName VARCHAR(50) = 0, 
	@orderID BIGINT
AS
BEGIN
	-- =============================================
	-- Author:	Craig Parks
	-- Create date:	12/1/2008
	-- Parameters:	@orderID = Release Order ID for History Inv creation, 
	--		@userName = Caller
	-- Description:	Create a History Order from a Released order
	-- Modified: 1/9/2008 Craig Parks Added new Header Columns DiscountAmt through ShipCompleteInd
	-- Modified: 1/22/2009 Craig Parks Add ReviewID, ReviewDT, AllocRelDt
	-- Modified: 3/3/2009 Craig Parks Add the following columns:
	--	InvoiceSendMethod, InvoiceSendDest, InvoiceSendDate1, InvoiceSendDate2, 
	--	InvoiceSendDate3, InvoiceSent, InvoiceFiled, ResendInvoice, RefileInvoice, 
	--	DiscountAmount, DiscountDt, ARDueDt, fCustomerAddressID
	-- Modified: 4/1/2009 Craig Parks Set fSOHeaderHistID to Orginal orderID
	-- Modified: 4/2/2009 Craig Parks Add DeleteReasonCd, DeleteReasonName & DeleteUserID
	-- Modified: 4/15/2009 Craig Parks Insure ResendInvoice and InvoiceSent are 0
	--	Set EntryID to EntryID of User who created Original Order
	-- Modified: 5/1/2009 Craig Parks Add Shipping columns ShipTrackingNo, ShippingCost
	-- Modified: 6/23/2009 Craig Parks Add DocumentSortInd
	-- Modified: 8/13/2009 Craig Parks Move Transfer Orders to Transfer Order History
	-- Modified: 8/20/2009 Craig Parks Move order extensions for Rel to Hist see TotalOrder
	-- Modified: 11/2/2009 Craig Parks add ReferenceNoDt
	-- Modified: 10/21/10 TMD: Write to TOHeaderHist where SUBTYPE = 41 thru 49 [WO2097]
	-- =============================================

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@subType VARCHAR(2)
	SELECT @subType = SubType FROM SOHeaderRel WHERE OrderNo = @orderID

	-- See if the Released order is a Transfer or WorkOrder SubType
	IF (CONVERT(INT, @subtype) = 5 or (CONVERT(INT, @subtype) >= 41 and CONVERT(INT, @subtype) <= 49))
	   BEGIN	-- Insert into TOHeaderHist
		EXEC [pSOECreateTOHistOrdHeader] @username=@username, @orderID=@orderID
	   END
	ELSE
	   BEGIN	-- Insert into SOHeaderHist
		INSERT
		INTO	dbo.SOHeaderHist
			(OrderNo, OrderRelNo, OrderType, OrderTypeDsc, PriceCd, DiscountCd, 
			 TotalOrder, TotalCost, TotalCost2, CommDol, CommPct, DiscPct, 
			 ComSplit1, ComSplit2, ComSplit3, SlsRepId1, SlsRepId2, SlsRepId3, 
			 NetSales, TaxSum, NonTaxAmt, TaxExpAmt, NonTaxExpAmt, TaxAmt, 
			 CreditCdAmt, ShipWght, BOLWght, BillToCustNo, BillToCustName, 
			 BillToAddress1, BillToAddress2, BillToAddress3, BillToCity, 
			 BillToState, BillToZip, BillToProvince, BillToCountry, 
			 BillToContactName, BillToContactPhoneNo, SellToCustNo, SellToCustName, 
			 SellToAddress1, SellToAddress2, SellToAddress3, SellToCity, 
			 SellToState, SellToZip, SellToProvince, SellToCountry, 
			 SellToContactName, SellToContactPhoneNo, DeleteDt, CompleteDt, 
			 VerifyDt, PrintDt, InvoiceDt, ARPostDt, SchShipDt, ConfirmShipDt, 
			 PickDt, PickCompDt, AllocDt, HoldDt, OrderDt, OrderPromDt, 
			 OrderLoc, OrderLocName, ShipLoc, ShipLocName, UsageLoc, UsageLocName, 
			 OrderStatus, HoldReason, HoldReasonName, PriceRvwFlag, ReasonCd, ReasonCdName, 
			 BOFlag, OrderMethCd, OrderMethName, OrderTermsCd, OrderTermsName, 
			 OrderPriorityCd, OrderPriName, OrderExpdCd, OrderExpdCdName, TaxStat, 
			 CreditStat, SalesRepNo, SalesRepName, CustSvcRepNo, CustSvcRepName, 
			 CopiestoPrint, OrderCarrier, OrderCarName, CreditAuthNo, BOLNO, NoCartons, 
			 ShipInstrCd, ShipInstrCdName, SalesTaxRt, PORefNo, ResaleNo, VerifyType, 
			 ConfirmDt, RlsWhseDt, StageDt, StageBin, ConsolidateDt, ComInvPrtDt, 
			 ShippedDt, CommMedia, SubType, HeaderStatus, OrigShipDt, OrigShipDt1, 
			 OrigShipDt2, OrigShipDt3, OneTimeSTNo, LinesChanged, LineItemOdom, 
			 NoLaterDt, CustoType, CustTypeName, ScanQty, ListCd, AckPrintedDt, 
			 CustShipLoc, ShipThruLoc, ReorderUseLoc, User2, User3, User4, User5, 
			 ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, OrderReprints, 
			 DropVendorID, DropVendorName, RecommendCarCd, RecommendCarName, SurChargeInd, 
			 SummaryBillInd, ReferenceNo, CashItemOdm, CustTaxRateCd, StateTaxCd, CountyTaxCd, 
			 CityTaxCd, TaxDistrict, RemitCd, DiscNet1PCt, DiscNet2PCt, DiscNet3PCt, 
			 ASNFmt, JobName, JobNo, JobLocation, Destination, JobBuilding, ASAPind, 
			 ShipToCd, ShipToName, ShipToAddress1, ShipToAddress2, ShipToAddress3, 
			 City, State, Zip, PhoneNo, FaxNo, ContactName, ContactPhoneNo, Province, 
			 Country, CountryCd, EntryDt, EntryID, CustPONo, RefSONo, OrderFreightCd, 
			 OrderFreightName, PendingDt, ShipMethodName, Remarks, TaxRateCd, CustReqDt, 
			 BranchReqDt, OrderContactName, fSOHeaderID, DiscountAmt, ShipToContactID, 
			 SellToContactID, MakeOrderDt, CustCarrierAcct, AllowBOInd, ConsolidateOrdersInd, 
			 ShipCompleteInd, ReviewID, ReviewDt, AllocRelDt, InvoiceSendMethod, InvoiceSendDest, 
			 InvoiceSendDate1, InvoiceSendDate2, InvoiceSendDate3, InvoiceSent, InvoiceFiled, 
			 ResendInvoice, RefileInvoice, DiscountAmount, DiscountDt, ARDueDt, fCustomerAddressID, 
			 DeleteReasonCd, DeleteReasonName, DeleteUserID, ShipTrackingNo, ShippingCost, 
			 DocumentSortInd, CertRequiredInd, OrderSource, ReferenceNoDt)
		SELECT	SR.OrderNo, SR.OrderRelNo, OrderType, OrderTypeDsc, PriceCd, DiscountCd, 
			TotalOrder, TotalCost, TotalCost2, CommDol, CommPct, DiscPct, 
			ComSplit1, ComSplit2, ComSplit3, SlsRepId1, SlsRepId2, SlsRepId3, 
			NetSales, TaxSum, NonTaxAmt, TaxExpAmt, NonTaxExpAmt, TaxAmt, 
			CreditCdAmt, ShipWght, BOLWght, BillToCustNo, BillToCustName, 
			BillToAddress1, BillToAddress2, BillToAddress3, BillToCity, 
			BillToState, BillToZip, BillToProvince, BillToCountry, 
			BillToContactName, BillToContactPhoneNo, SellToCustNo, SellToCustName, 
			SellToAddress1, SellToAddress2, SellToAddress3, SellToCity, 
			SellToState, SellToZip, SellToProvince, SellToCountry, 
			SellToContactName, SellToContactPhoneNo, DeleteDt, CompleteDt, 
			VerifyDt, PrintDt, SR.InvoiceDt, ARPostDt, SchShipDt, ConfirmShipDt, 
			PickDt, PickCompDt, AllocDt, HoldDt, OrderDt, OrderPromDt, 
			OrderLoc, OrderLocName, ShipLOC, ShipLocName, UsageLoc, UsageLocName, 
			OrderStatus, HoldReason, HoldReasonName, PriceRvwFlag, ReasonCd, ReasonCdName, 
			BOFlag, OrderMethCd, OrderMethName, OrderTermsCd, OrderTermsName, 
			OrderPriorityCd, OrderPriName, OrderExpdCd, OrderExpdCdName, TaxStat, 
			CreditStat, SalesRepNo, SalesRepName, CustSvcRepNo, CustSvcRepName, 
			CopiestoPrint, OrderCarrier, OrderCarName, CreditAuthNo, BOLNO, NoCartons, 
			ShipInstrCd, ShipInstrCdName, SalesTaxRt, PORefNo, ResaleNo, VerifyType, 
			ConfirmDt, RlsWhseDt, StageDt, StageBin, ConsolidateDt, ComInvPrtDt, 
			ShippedDt, CommMedia, SubType, HeaderStatus, OrigShipDt, OrigShipDt1, 
			OrigShipDt2, OrigShipDt3, OneTimeSTNo, LinesChanged, 0 AS LineOdom, 
			NoLaterDt, CustoType, CustTypeName, ScanQty, ListCd, AckPrintedDt, 
			CustShipLoc, ShipThruLoc, ReorderUseLoc, User2, User3, User4, User5, 
			ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, OrderReprints, 
			DropVendorID, DropVendorName, RecommendCarCd, RecommendCarName, SurChargeInd, 
			SummaryBillInd, ReferenceNo, CashItemOdm, CustTaxRateCd, StateTaxCd, CountyTaxCd, 
			CityTaxCd, TaxDistrict, RemitCd, DiscNet1PCt, DiscNet2PCt, DiscNet3PCt, 
			ASNFmt, JobName, JobNo, JobLocation, Destination, JobBuilding, ASAPind, 
			ShipToCd, ShipToName, ShipToAddress1, ShipToAddress2, ShipToAddress3, 
			City, State, Zip, PhoneNo, FaxNo, ContactName, ContactPhoneNo, Province, 
			Country, CountryCd, GetDate() AS EntryDt, EntryID, CustPONo, RefSONo, OrderFreightCd, 
			OrderFreightName, PendingDt, ShipMethodName, Remarks, TaxRateCd, CustReqDt, 
			BranchReqDt, OrderContactName, fSOHeaderID, DiscountAmt, ShipToContactID, 
			SellToContactID, MakeOrderDt, CustCarrierAcct, AllowBOInd, ConsolidateOrdersInd, 
			ShipCompleteInd, ReviewID, ReviewDt, AllocRelDt, InvoiceSendMethod, InvoiceSendDest, 
			InvoiceSendDate1, InvoiceSendDate2, InvoiceSendDate3, 0 AS InvoiceSent, 0 AS InvoiceFiled, 
			0 AS ResendInvoice, 0 AS RefileInvoice, DiscountAmount, DiscountDt, ARDueDt, fCustomerAddressID, 
			DeleteReasonCd, DeleteReasonName, DeleteUserID, ShipTrackingNo, ShippingCost, 
			DocumentSortInd, CertRequiredInd, OrderSource, ReferenceNoDt
		FROM	SOHeaderRel (NOLOCK) SR 
		WHERE	pSOHeaderRelID = @orderID
	   END -- Create SOHeaderHist
	RETURN(0)
END