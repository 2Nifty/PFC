
------------------------------------------------------------------------------------------------


DECLARE @tSORecall TABLE (
--Header
	[pSOHeaderHistID] [numeric](10, 0) ,
	[OrderNo] [numeric](10, 0) ,
	[OrderRelNo] [numeric](4, 0) ,
	[OrderType] [char] (2) ,
	[OrderTypeDsc] [varchar] (60) ,
	[InvoiceNo] [varchar] (20) ,
	[PriceCd] [char] (2) ,
	[DiscountCd] [char] (2) ,
	[TotalOrder] [numeric](38, 20) ,
	[TotalCost] [numeric](38, 20) ,
	[TotalCost2] [numeric](38, 20) ,
	[CommDol] [numeric](15, 5) ,
	[CommPct] [numeric](15, 4) ,
	[DiscPct] [numeric](15, 4) ,
	[ComSplit1] [numeric](5, 2) ,
	[ComSplit2] [numeric](5, 2) ,
	[ComSplit3] [numeric](5, 2) ,
	[SlsRepId1] [numeric](9, 0) ,
	[SlsRepId2] [numeric](9, 0) ,
	[SlsRepId3] [numeric](9, 0) ,
	[NetSales] [numeric](15, 5) ,
	[TaxSum] [numeric](15, 5) ,
	[NonTaxAmt] [numeric](15, 4) ,
	[TaxExpAmt] [numeric](15, 4) ,
	[NonTaxExpAmt] [numeric](15, 5) ,
	[TaxAmt] [numeric](15, 5) ,
	[CreditCdAmt] [numeric](15, 5) ,
	[ShipWght] [numeric](15, 4) ,
	[BOLWght] [numeric](15, 4) ,
	[BillToCustNo] [varchar] (10) ,
	[BillToCustName] [varchar] (40) ,
	[BillToAddress1] [varchar] (40) ,
	[BillToAddress2] [varchar] (40) ,
	[BillToAddress3] [varchar] (40) ,
	[BillToCity] [varchar] (20) ,
	[BillToState] [char] (2) ,
	[BillToZip] [varchar] (10) ,
	[BillToProvince] [varchar] (20) ,
	[BillToCountry] [varchar] (50) ,
	[BillToContactName] [varchar] (50) ,
	[BillToContactPhoneNo] [varchar] (15) ,
	[SellToCustNo] [varchar] (10) ,
	[SellToCustName] [varchar] (40) ,
	[SellToAddress1] [varchar] (40) ,
	[SellToAddress2] [varchar] (40) ,
	[SellToAddress3] [varchar] (40) ,
	[SellToCity] [varchar] (20) ,
	[SellToState] [char] (2) ,
	[SellToZip] [varchar] (10) ,
	[SellToProvince] [varchar] (20) ,
	[SellToCountry] [varchar] (50) ,
	[SellToContactName] [varchar] (50) ,
	[SellToContactPhoneNo] [varchar] (15) ,
	[DeleteDt] [datetime] ,
	[CompleteDt] [datetime] ,
	[VerifyDt] [datetime] ,
	[PrintDt] [datetime] ,
	[InvoiceDt] [datetime] ,
	[ARPostDt] [datetime] ,
	[SchShipDt] [datetime] ,
	[ConfirmShipDt] [datetime] ,
	[PickDt] [datetime] ,
	[PickCompDt] [datetime] ,
	[AllocDt] [datetime] ,
	[HoldDt] [datetime] ,
	[OrderDt] [datetime] ,
	[OrderPromDt] [datetime] ,
	[OrderLoc] [varchar] (10) ,
	[OrderLocName] [varchar] (30) ,
	[ShipLoc] [varchar] (10) ,
	[ShipLocName] [varchar] (30) ,
	[UsageLoc] [varchar] (10) ,
	[UsageLocName] [varchar] (30) ,
	[OrderStatus] [char] (2) ,
	[HoldReason] [char] (2) ,
	[HoldReasonName] [varchar] (30) ,
	[PriceRvwFlag] [char] (2) ,
	[ReasonCd] [varchar] (20) ,
	[ReasonCdName] [varchar] (30) ,
	[BOFlag] [char] (2) ,
	[OrderMethCd] [varchar] (20) ,
	[OrderMethName] [varchar] (30) ,
	[OrderTermsCd] [char] (4) ,
	[OrderTermsName] [varchar] (30) ,
	[OrderPriorityCd] [char] (4) ,
	[OrderPriName] [varchar] (30) ,
	[OrderExpdCd] [varchar] (20) ,
	[OrderExpdCdName] [varchar] (30) ,
	[TaxStat] [char] (2) ,
	[CreditStat] [char] (2) ,
	[SalesRepNo] [char] (4) ,
	[SalesRepName] [varchar] (30) ,
	[CustSvcRepNo] [char] (4) ,
	[CustSvcRepName] [varchar] (30) ,
	[CopiestoPrint] [smallint] ,
	[OrderCarrier] [varchar] (20) ,
	[OrderCarName] [varchar] (30) ,
	[CreditAuthNo] [varchar] (10) ,
	[BOLNO] [varchar] (20) ,
	[NoCartons] [numeric](9, 0) ,
	[ShipInstrCd] [char] (4) ,
	[ShipInstrCdName] [varchar] (30) ,
	[SalesTaxRt] [numeric](7, 4) ,
	[PORefNo] [numeric](10, 0) ,
	[ResaleNo] [varchar] (30) ,
	[VerifyType] [char] (2) ,
	[ConfirmDt] [datetime] ,
	[RlsWhseDt] [datetime] ,
	[StageDt] [datetime] ,
	[StageBin] [numeric](10, 0) ,
	[ConsolidateDt] [datetime] ,
	[ComInvPrtDt] [datetime] ,
	[ShippedDt] [datetime] ,
	[CommMedia] [char] (2) ,
	[SubType] [char] (2) ,
	[HeaderStatus] [varchar] (20) ,
	[OrigShipDt] [datetime] ,
	[OrigShipDt1] [datetime] ,
	[OrigShipDt2] [datetime] ,
	[OrigShipDt3] [datetime] ,
	[OneTimeSTNo] [numeric](10, 0) ,
	[LinesChanged] [char] (2) ,
	[LineItemOdom] [smallint] ,
	[NoLaterDt] [datetime] ,
	[CustoType] [char] (4) ,
	[CustTypeName] [varchar] (30) ,
	[ScanQty] [numeric](15, 2) ,
	[ListCd] [char] (2) ,
	[AckPrintedDt] [datetime] ,
	[CustShipLoc] [varchar] (10) ,
	[ShipThruLoc] [varchar] (10) ,
	[ReorderUseLoc] [varchar] (10) ,
	[User2] [varchar] (30) ,
	[User3] [varchar] (30) ,
	[User4] [varchar] (30) ,
	[User5] [varchar] (30) ,
	[ShippingMark1] [varchar] (40) ,
	[ShippingMark2] [varchar] (40) ,
	[ShippingMark3] [varchar] (40) ,
	[ShippingMark4] [varchar] (40) ,
	[OrderReprints] [int] ,
	[DropVendorID] [numeric](9, 0) ,
	[DropVendorName] [varchar] (30) ,
	[RecommendCarCd] [char] (5) ,
	[RecommendCarName] [varchar] (30) ,
	[SurChargeInd] [char] (2) ,
	[SummaryBillInd] [char] (2) ,
	[ReferenceNo] [varchar] (15) ,
	[CashItemOdm] [smallint] ,
	[CustTaxRateCd] [char] (4) ,
	[StateTaxCd] [char] (4) ,
	[CountyTaxCd] [char] (4) ,
	[CityTaxCd] [char] (4) ,
	[TaxDistrict] [char] (4) ,
	[RemitCd] [numeric](9, 0) ,
	[DiscNet1PCt] [numeric](5, 2) ,
	[DiscNet2PCt] [numeric](5, 2) ,
	[DiscNet3PCt] [numeric](5, 2) ,
	[ASNFmt] [varchar] (15) ,
	[JobName] [varchar] (40) ,
	[JobNo] [varchar] (30) ,
	[JobLocation] [varchar] (40) ,
	[Destination] [varchar] (40) ,
	[JobBuilding] [varchar] (40) ,
	[ASAPind] [char] (2) ,
	[ShipToCd] [varchar] (10) ,
	[ShipToName] [varchar] (40) ,
	[ShipToAddress1] [varchar] (40) ,
	[ShipToAddress2] [varchar] (40) ,
	[ShipToAddress3] [varchar] (40) ,
	[City] [varchar] (20) ,
	[State] [char] (2) ,
	[Zip] [varchar] (10) ,
	[PhoneNo] [varchar] (15) ,
	[FaxNo] [varchar] (15) ,
	[ContactName] [varchar] (50) ,
	[ContactPhoneNo] [varchar] (15) ,
	[Province] [varchar] (20) ,
	[Country] [varchar] (50) ,
	[CountryCd] [char] (4) ,
	[EntryDt] [datetime] ,
	[EntryID] [varchar] (50) ,
	[ChangeDt] [datetime] ,
	[ChangeID] [varchar] (50) ,
	[StatusCd] [char] (2) ,
	[CustPONo] [varchar] (20) ,
	[RefSONo] [varchar] (20) ,
	[OrderFreightCd] [char] (2) ,
	[OrderFreightName] [varchar] (30) ,
	[PendingDt] [datetime] ,
	[ShipMethodName] [varchar] (50) ,
	[Remarks] [varchar] (80) ,
	[TaxRateCd] [varchar] (20) ,
	[BranchReqDt] [datetime] ,
	[OrderContactName] [varchar] (50), 
--Detail
	[Dtl_pSODetailHistID] [int] ,
	[Dtl_fSOHeaderHistID] [numeric](10, 0) ,
	[Dtl_LineNumber] [int] ,
	[Dtl_LineSeq] [int] ,
	[Dtl_LineType] [char] (2) ,
	[Dtl_LinePriceInd] [char] (2) ,
	[Dtl_LineReason] [char] (2) ,
	[Dtl_LineReasonDsc] [varchar] (30) ,
	[Dtl_LineExpdCd] [char] (2) ,
	[Dtl_LineExpdCdDsc] [varchar] (30) ,
	[Dtl_LineStatus] [char] (2) ,
	[Dtl_POLine] [varchar] (20) ,
	[Dtl_TaxStatus] [char] (2) ,
	[Dtl_ItemNo] [varchar] (30) ,
	[Dtl_ItemDsc] [varchar] (50) ,
	[Dtl_BinLoc] [varchar] (15) ,
	[Dtl_IMLoc] [varchar] (10) ,
	[Dtl_DiscInd] [char] (2) ,
	[Dtl_ReleaseInd] [char] (2) ,
	[Dtl_CostInd] [char] (2) ,
	[Dtl_ServChrgInd] [char] (2) ,
	[Dtl_XrefCd] [char] (2) ,
	[Dtl_OrderLvlCd] [char] (2) ,
	[Dtl_BOLCategoryCd] [char] (2) ,
	[Dtl_PriceCd] [char] (2) ,
	[Dtl_DealerCd] [char] (2) ,
	[Dtl_LISC] [char] (2) ,
	[Dtl_LISource] [char] (2) ,
	[Dtl_RevLvl] [char] (2) ,
	[Dtl_QtyStat] [char] (2) ,
	[Dtl_DealerNo] [varchar] (10) ,
	[Dtl_ComPct] [numeric](5, 2) ,
	[Dtl_ComDol] [numeric](38, 20) ,
	[Dtl_NetUnitPrice] [numeric](38, 20) ,
	[Dtl_ListUnitPrice] [numeric](38, 20) ,
	[Dtl_DiscUnitPrice] [numeric](38, 20) ,
	[Dtl_DiscPct1] [smallint] ,
	[Dtl_DiscPct2] [smallint] ,
	[Dtl_DiscPct3] [smallint] ,
	[Dtl_QtyAvailLoc1] [varchar] (10) ,
	[Dtl_QtyAvail1] [numeric](15, 2) ,
	[Dtl_QtyAvailLoc2] [varchar] (10) ,
	[Dtl_QtyAvail2] [numeric](15, 2) ,
	[Dtl_QtyAvailLoc3] [varchar] (10) ,
	[Dtl_QtyAvail3] [numeric](15, 2) ,
	[Dtl_OrigOrderNo] [numeric](9, 0) ,
	[Dtl_OrigOrderLineNo] [numeric](9, 0) ,
	[Dtl_RqstdShipDt] [datetime] ,
	[Dtl_OrigShipDt] [datetime] ,
	[Dtl_ActualShipDt] [datetime] ,
	[Dtl_LineSchDtChange] [datetime] ,
	[Dtl_SuggstdShipDt] [datetime] ,
	[Dtl_DeleteDt] [datetime] ,
	[Dtl_QtyOrdered] [numeric](15, 2) ,
	[Dtl_QtyShipped] [numeric](15, 2) ,
	[Dtl_QtyBO] [numeric](15, 2) ,
	[Dtl_SellStkUM] [char] (2) ,
	[Dtl_SellStkFactor] [numeric](5, 0) ,
	[Dtl_UnitCost] [numeric](15, 5) ,
	[Dtl_UnitCost2] [numeric](15, 4) ,
	[Dtl_UnitCost3] [numeric](15, 5) ,
	[Dtl_RepCost] [numeric](15, 5) ,
	[Dtl_OECost] [numeric](15, 5) ,
	[Dtl_RebateAmt] [numeric](15, 5) ,
	[Dtl_SuggstdShipFrLoc] [varchar] (10) ,
	[Dtl_SuggstdShipFrName] [varchar] (40) ,
	[Dtl_NoReschd] [smallint] ,
	[Dtl_Remark] [varchar] (80) ,
	[Dtl_CustItemNo] [varchar] (30) ,
	[Dtl_CustItemDsc] [varchar] (50) ,
	[Dtl_BOMQtyPer] [numeric](10, 0) ,
	[Dtl_BOMQtyIssued] [numeric](10, 4) ,
	[Dtl_EntryDate] [datetime] ,
	[Dtl_EntryID] [varchar] (10) ,
	[Dtl_ChangeDate] [datetime] ,
	[Dtl_ChangeID] [varchar] (10) ,
	[Dtl_StatusCd] [char] (2) ,
	[Dtl_GrossWght] [numeric](15, 4) ,
	[Dtl_NetWght] [numeric](15, 4) ,
	[Dtl_ExtendedPrice] [decimal](18, 6) ,
	[Dtl_ExtendedCost] [decimal](18, 6) ,
	[Dtl_ExtendedNetWght] [decimal](18, 6) ,
	[Dtl_ExtendedGrossWght] [decimal](18, 6) ,
	[Dtl_SellStkQty] [decimal](18, 6) ,
	[Dtl_AlternateUM] [char] (4) ,
	[Dtl_AlternateUMQty] [decimal](18, 6) ,
--Expense
	[Exp_pSOExpenseHistID] [bigint] ,
	[Exp_fSOHeaderHistID] [numeric](10, 0) ,
	[Exp_LineNumber] [int] ,
	[Exp_ExpenseNo] [int] ,
	[Exp_ExpenseCd] [char] (4) ,
	[Exp_Amount] [float] ,
	[Exp_Cost] [float] ,
	[Exp_ExpenseInd] [char] (2) ,
	[Exp_TaxStatus] [char] (2) ,
	[Exp_DeliveryCharge] [float] ,
	[Exp_HandlingCharge] [float] ,
	[Exp_PackagingCharge] [float] ,
	[Exp_MiscCharge] [float] ,
	[Exp_PhoneCharge] [float] ,
	[Exp_DocumentLoc] [varchar] (10) ,
	[Exp_DeleteDt] [datetime] ,
	[Exp_EntryID] [varchar] (50) ,
	[Exp_EntryDt] [datetime] ,
	[Exp_ChangeID] [varchar] (50) ,
	[Exp_ChangeDt] [datetime] ,
	[Exp_StatusCd] [char] (2), 
--Comment
	[Cmt_pSOCommID] [numeric](9, 0) ,
	[Cmt_fSOHeaderID] [int] ,
	[Cmt_Type] [char] (2) ,
	[Cmt_FormsCd] [char] (2) ,
	[Cmt_CommLineNo] [int] ,
	[Cmt_CommLineSeqNo] [int] ,
	[Cmt_CommText] [varchar] (255) ,
	[Cmt_DeleteDt] [datetime] ,
	[Cmt_EntryID] [varchar] (50) ,
	[Cmt_EntryDt] [datetime] ,
	[Cmt_ChangeID] [varchar] (50) ,
	[Cmt_ChangeDt] [datetime] ,
	[Cmt_StatusCd] [char] (2) 
)

INSERT @tSoRecall(
[pSOHeaderHistID] ,
[OrderNo] ,
[OrderRelNo] ,
[OrderType] ,
[OrderTypeDsc] ,
[InvoiceNo] ,
[PriceCd] ,
[DiscountCd] ,
[TotalOrder] ,
[TotalCost] ,
[TotalCost2] ,
[CommDol] ,
[CommPct] ,
[DiscPct] ,
[ComSplit1] ,
[ComSplit2] ,
[ComSplit3] ,
[SlsRepId1] ,
[SlsRepId2] ,
[SlsRepId3] ,
[NetSales] ,
[TaxSum] ,
[NonTaxAmt] ,
[TaxExpAmt] ,
[NonTaxExpAmt] ,
[TaxAmt] ,
[CreditCdAmt] ,
[ShipWght] ,
[BOLWght] ,
[BillToCustNo] ,
[BillToCustName] ,
[BillToAddress1] ,
[BillToAddress2] ,
[BillToAddress3] ,
[BillToCity] ,
[BillToState] ,
[BillToZip] ,
[BillToProvince] ,
[BillToCountry] ,
[BillToContactName] ,
[BillToContactPhoneNo] ,
[SellToCustNo] ,
[SellToCustName] ,
[SellToAddress1] ,
[SellToAddress2] ,
[SellToAddress3] ,
[SellToCity] ,
[SellToState] ,
[SellToZip] ,
[SellToProvince] ,
[SellToCountry] ,
[SellToContactName] ,
[SellToContactPhoneNo] ,
[DeleteDt] ,
[CompleteDt] ,
[VerifyDt] ,
[PrintDt] ,
[InvoiceDt] ,
[ARPostDt] ,
[SchShipDt] ,
[ConfirmShipDt] ,
[PickDt] ,
[PickCompDt] ,
[AllocDt] ,
[HoldDt] ,
[OrderDt] ,
[OrderPromDt] ,
[OrderLoc] ,
[OrderLocName] ,
[ShipLoc] ,
[ShipLocName] ,
[UsageLoc] ,
[UsageLocName] ,
[OrderStatus] ,
[HoldReason] ,
[HoldReasonName] ,
[PriceRvwFlag] ,
[ReasonCd] ,
[ReasonCdName] ,
[BOFlag] ,
[OrderMethCd] ,
[OrderMethName] ,
[OrderTermsCd] ,
[OrderTermsName] ,
[OrderPriorityCd] ,
[OrderPriName] ,
[OrderExpdCd] ,
[OrderExpdCdName] ,
[TaxStat] ,
[CreditStat] ,
[SalesRepNo] ,
[SalesRepName] ,
[CustSvcRepNo] ,
[CustSvcRepName] ,
[CopiestoPrint] ,
[OrderCarrier] ,
[OrderCarName] ,
[CreditAuthNo] ,
[BOLNO] ,
[NoCartons] ,
[ShipInstrCd] ,
[ShipInstrCdName] ,
[SalesTaxRt] ,
[PORefNo] ,
[ResaleNo] ,
[VerifyType] ,
[ConfirmDt] ,
[RlsWhseDt] ,
[StageDt] ,
[StageBin] ,
[ConsolidateDt] ,
[ComInvPrtDt] ,
[ShippedDt] ,
[CommMedia] ,
[SubType] ,
[HeaderStatus] ,
[OrigShipDt] ,
[OrigShipDt1] ,
[OrigShipDt2] ,
[OrigShipDt3] ,
[OneTimeSTNo] ,
[LinesChanged] ,
[LineItemOdom] ,
[NoLaterDt] ,
[CustoType] ,
[CustTypeName] ,
[ScanQty] ,
[ListCd] ,
[AckPrintedDt] ,
[CustShipLoc] ,
[ShipThruLoc] ,
[ReorderUseLoc] ,
[User2] ,
[User3] ,
[User4] ,
[User5] ,
[ShippingMark1] ,
[ShippingMark2] ,
[ShippingMark3] ,
[ShippingMark4] ,
[OrderReprints] ,
[DropVendorID] ,
[DropVendorName] ,
[RecommendCarCd] ,
[RecommendCarName] ,
[SurChargeInd] ,
[SummaryBillInd] ,
[ReferenceNo] ,
[CashItemOdm] ,
[CustTaxRateCd] ,
[StateTaxCd] ,
[CountyTaxCd] ,
[CityTaxCd] ,
[TaxDistrict] ,
[RemitCd] ,
[DiscNet1PCt] ,
[DiscNet2PCt] ,
[DiscNet3PCt] ,
[ASNFmt] ,
[JobName] ,
[JobNo] ,
[JobLocation] ,
[Destination] ,
[JobBuilding] ,
[ASAPind] ,
[ShipToCd] ,
[ShipToName] ,
[ShipToAddress1] ,
[ShipToAddress2] ,
[ShipToAddress3] ,
[City] ,
[State] ,
[Zip] ,
[PhoneNo] ,
[FaxNo] ,
[ContactName] ,
[ContactPhoneNo] ,
[Province] ,
[Country] ,
[CountryCd] ,
[EntryDt] ,
[EntryID] ,
[ChangeDt] ,
[ChangeID] ,
[StatusCd] ,
[CustPONo] ,
[RefSONo] ,
[OrderFreightCd] ,
[OrderFreightName] ,
[PendingDt] ,
[ShipMethodName] ,
[Remarks] ,
[TaxRateCd] ,
[BranchReqDt] ,
[OrderContactName] ,
[Dtl_pSODetailHistID] ,
[Dtl_fSOHeaderHistID] ,
[Dtl_LineNumber] ,
[Dtl_LineSeq] ,
[Dtl_LineType] ,
[Dtl_LinePriceInd] ,
[Dtl_LineReason] ,
[Dtl_LineReasonDsc] ,
[Dtl_LineExpdCd] ,
[Dtl_LineExpdCdDsc] ,
[Dtl_LineStatus] ,
[Dtl_POLine] ,
[Dtl_TaxStatus] ,
[Dtl_ItemNo] ,
[Dtl_ItemDsc] ,
[Dtl_BinLoc] ,
[Dtl_IMLoc] ,
[Dtl_DiscInd] ,
[Dtl_ReleaseInd] ,
[Dtl_CostInd] ,
[Dtl_ServChrgInd] ,
[Dtl_XrefCd] ,
[Dtl_OrderLvlCd] ,
[Dtl_BOLCategoryCd] ,
[Dtl_PriceCd] ,
[Dtl_DealerCd] ,
[Dtl_LISC] ,
[Dtl_LISource] ,
[Dtl_RevLvl] ,
[Dtl_QtyStat] ,
[Dtl_DealerNo] ,
[Dtl_ComPct] ,
[Dtl_ComDol] ,
[Dtl_NetUnitPrice] ,
[Dtl_ListUnitPrice] ,
[Dtl_DiscUnitPrice] ,
[Dtl_DiscPct1] ,
[Dtl_DiscPct2] ,
[Dtl_DiscPct3] ,
[Dtl_QtyAvailLoc1] ,
[Dtl_QtyAvail1] ,
[Dtl_QtyAvailLoc2] ,
[Dtl_QtyAvail2] ,
[Dtl_QtyAvailLoc3] ,
[Dtl_QtyAvail3] ,
[Dtl_OrigOrderNo] ,
[Dtl_OrigOrderLineNo] ,
[Dtl_RqstdShipDt] ,
[Dtl_OrigShipDt] ,
[Dtl_ActualShipDt] ,
[Dtl_LineSchDtChange] ,
[Dtl_SuggstdShipDt] ,
[Dtl_DeleteDt] ,
[Dtl_QtyOrdered] ,
[Dtl_QtyShipped] ,
[Dtl_QtyBO] ,
[Dtl_SellStkUM] ,
[Dtl_SellStkFactor] ,
[Dtl_UnitCost] ,
[Dtl_UnitCost2] ,
[Dtl_UnitCost3] ,
[Dtl_RepCost] ,
[Dtl_OECost] ,
[Dtl_RebateAmt] ,
[Dtl_SuggstdShipFrLoc] ,
[Dtl_SuggstdShipFrName] ,
[Dtl_NoReschd] ,
[Dtl_Remark] ,
[Dtl_CustItemNo] ,
[Dtl_CustItemDsc] ,
[Dtl_BOMQtyPer] ,
[Dtl_BOMQtyIssued] ,
[Dtl_EntryDate] ,
[Dtl_EntryID] ,
[Dtl_ChangeDate] ,
[Dtl_ChangeID] ,
[Dtl_StatusCd] ,
[Dtl_GrossWght] ,
[Dtl_NetWght] ,
[Dtl_ExtendedPrice] ,
[Dtl_ExtendedCost] ,
[Dtl_ExtendedNetWght] ,
[Dtl_ExtendedGrossWght] ,
[Dtl_SellStkQty] ,
[Dtl_AlternateUM] ,
[Dtl_AlternateUMQty])
SELECT    *
FROM         SOHeaderHist inner JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID 
WHERE InvoiceNo='IP2479093'


INSERT @tSoRecall(
[pSOHeaderHistID] ,
[OrderNo] ,
[OrderRelNo] ,
[OrderType] ,
[OrderTypeDsc] ,
[InvoiceNo] ,
[PriceCd] ,
[DiscountCd] ,
[TotalOrder] ,
[TotalCost] ,
[TotalCost2] ,
[CommDol] ,
[CommPct] ,
[DiscPct] ,
[ComSplit1] ,
[ComSplit2] ,
[ComSplit3] ,
[SlsRepId1] ,
[SlsRepId2] ,
[SlsRepId3] ,
[NetSales] ,
[TaxSum] ,
[NonTaxAmt] ,
[TaxExpAmt] ,
[NonTaxExpAmt] ,
[TaxAmt] ,
[CreditCdAmt] ,
[ShipWght] ,
[BOLWght] ,
[BillToCustNo] ,
[BillToCustName] ,
[BillToAddress1] ,
[BillToAddress2] ,
[BillToAddress3] ,
[BillToCity] ,
[BillToState] ,
[BillToZip] ,
[BillToProvince] ,
[BillToCountry] ,
[BillToContactName] ,
[BillToContactPhoneNo] ,
[SellToCustNo] ,
[SellToCustName] ,
[SellToAddress1] ,
[SellToAddress2] ,
[SellToAddress3] ,
[SellToCity] ,
[SellToState] ,
[SellToZip] ,
[SellToProvince] ,
[SellToCountry] ,
[SellToContactName] ,
[SellToContactPhoneNo] ,
[DeleteDt] ,
[CompleteDt] ,
[VerifyDt] ,
[PrintDt] ,
[InvoiceDt] ,
[ARPostDt] ,
[SchShipDt] ,
[ConfirmShipDt] ,
[PickDt] ,
[PickCompDt] ,
[AllocDt] ,
[HoldDt] ,
[OrderDt] ,
[OrderPromDt] ,
[OrderLoc] ,
[OrderLocName] ,
[ShipLoc] ,
[ShipLocName] ,
[UsageLoc] ,
[UsageLocName] ,
[OrderStatus] ,
[HoldReason] ,
[HoldReasonName] ,
[PriceRvwFlag] ,
[ReasonCd] ,
[ReasonCdName] ,
[BOFlag] ,
[OrderMethCd] ,
[OrderMethName] ,
[OrderTermsCd] ,
[OrderTermsName] ,
[OrderPriorityCd] ,
[OrderPriName] ,
[OrderExpdCd] ,
[OrderExpdCdName] ,
[TaxStat] ,
[CreditStat] ,
[SalesRepNo] ,
[SalesRepName] ,
[CustSvcRepNo] ,
[CustSvcRepName] ,
[CopiestoPrint] ,
[OrderCarrier] ,
[OrderCarName] ,
[CreditAuthNo] ,
[BOLNO] ,
[NoCartons] ,
[ShipInstrCd] ,
[ShipInstrCdName] ,
[SalesTaxRt] ,
[PORefNo] ,
[ResaleNo] ,
[VerifyType] ,
[ConfirmDt] ,
[RlsWhseDt] ,
[StageDt] ,
[StageBin] ,
[ConsolidateDt] ,
[ComInvPrtDt] ,
[ShippedDt] ,
[CommMedia] ,
[SubType] ,
[HeaderStatus] ,
[OrigShipDt] ,
[OrigShipDt1] ,
[OrigShipDt2] ,
[OrigShipDt3] ,
[OneTimeSTNo] ,
[LinesChanged] ,
[LineItemOdom] ,
[NoLaterDt] ,
[CustoType] ,
[CustTypeName] ,
[ScanQty] ,
[ListCd] ,
[AckPrintedDt] ,
[CustShipLoc] ,
[ShipThruLoc] ,
[ReorderUseLoc] ,
[User2] ,
[User3] ,
[User4] ,
[User5] ,
[ShippingMark1] ,
[ShippingMark2] ,
[ShippingMark3] ,
[ShippingMark4] ,
[OrderReprints] ,
[DropVendorID] ,
[DropVendorName] ,
[RecommendCarCd] ,
[RecommendCarName] ,
[SurChargeInd] ,
[SummaryBillInd] ,
[ReferenceNo] ,
[CashItemOdm] ,
[CustTaxRateCd] ,
[StateTaxCd] ,
[CountyTaxCd] ,
[CityTaxCd] ,
[TaxDistrict] ,
[RemitCd] ,
[DiscNet1PCt] ,
[DiscNet2PCt] ,
[DiscNet3PCt] ,
[ASNFmt] ,
[JobName] ,
[JobNo] ,
[JobLocation] ,
[Destination] ,
[JobBuilding] ,
[ASAPind] ,
[ShipToCd] ,
[ShipToName] ,
[ShipToAddress1] ,
[ShipToAddress2] ,
[ShipToAddress3] ,
[City] ,
[State] ,
[Zip] ,
[PhoneNo] ,
[FaxNo] ,
[ContactName] ,
[ContactPhoneNo] ,
[Province] ,
[Country] ,
[CountryCd] ,
[EntryDt] ,
[EntryID] ,
[ChangeDt] ,
[ChangeID] ,
[StatusCd] ,
[CustPONo] ,
[RefSONo] ,
[OrderFreightCd] ,
[OrderFreightName] ,
[PendingDt] ,
[ShipMethodName] ,
[Remarks] ,
[TaxRateCd] ,
[BranchReqDt] ,
[OrderContactName] ,
[Exp_pSOExpenseHistID] ,
[Exp_fSOHeaderHistID] ,
[Exp_LineNumber] ,
[Exp_ExpenseNo] ,
[Exp_ExpenseCd] ,
[Exp_Amount] ,
[Exp_Cost] ,
[Exp_ExpenseInd] ,
[Exp_TaxStatus] ,
[Exp_DeliveryCharge] ,
[Exp_HandlingCharge] ,
[Exp_PackagingCharge] ,
[Exp_MiscCharge] ,
[Exp_PhoneCharge] ,
[Exp_DocumentLoc] ,
[Exp_DeleteDt] ,
[Exp_EntryID] ,
[Exp_EntryDt] ,
[Exp_ChangeID] ,
[Exp_ChangeDt] ,
[Exp_StatusCd])
SELECT    *
FROM         SOHeaderHist inner JOIN
                     SOExpenseHist ON SOHeaderHist.pSOHeaderHistID = SOExpenseHist.fSOHeaderHistID 
WHERE InvoiceNo='IP2479093'


INSERT @tSoRecall(
[pSOHeaderHistID] ,
[OrderNo] ,
[OrderRelNo] ,
[OrderType] ,
[OrderTypeDsc] ,
[InvoiceNo] ,
[PriceCd] ,
[DiscountCd] ,
[TotalOrder] ,
[TotalCost] ,
[TotalCost2] ,
[CommDol] ,
[CommPct] ,
[DiscPct] ,
[ComSplit1] ,
[ComSplit2] ,
[ComSplit3] ,
[SlsRepId1] ,
[SlsRepId2] ,
[SlsRepId3] ,
[NetSales] ,
[TaxSum] ,
[NonTaxAmt] ,
[TaxExpAmt] ,
[NonTaxExpAmt] ,
[TaxAmt] ,
[CreditCdAmt] ,
[ShipWght] ,
[BOLWght] ,
[BillToCustNo] ,
[BillToCustName] ,
[BillToAddress1] ,
[BillToAddress2] ,
[BillToAddress3] ,
[BillToCity] ,
[BillToState] ,
[BillToZip] ,
[BillToProvince] ,
[BillToCountry] ,
[BillToContactName] ,
[BillToContactPhoneNo] ,
[SellToCustNo] ,
[SellToCustName] ,
[SellToAddress1] ,
[SellToAddress2] ,
[SellToAddress3] ,
[SellToCity] ,
[SellToState] ,
[SellToZip] ,
[SellToProvince] ,
[SellToCountry] ,
[SellToContactName] ,
[SellToContactPhoneNo] ,
[DeleteDt] ,
[CompleteDt] ,
[VerifyDt] ,
[PrintDt] ,
[InvoiceDt] ,
[ARPostDt] ,
[SchShipDt] ,
[ConfirmShipDt] ,
[PickDt] ,
[PickCompDt] ,
[AllocDt] ,
[HoldDt] ,
[OrderDt] ,
[OrderPromDt] ,
[OrderLoc] ,
[OrderLocName] ,
[ShipLoc] ,
[ShipLocName] ,
[UsageLoc] ,
[UsageLocName] ,
[OrderStatus] ,
[HoldReason] ,
[HoldReasonName] ,
[PriceRvwFlag] ,
[ReasonCd] ,
[ReasonCdName] ,
[BOFlag] ,
[OrderMethCd] ,
[OrderMethName] ,
[OrderTermsCd] ,
[OrderTermsName] ,
[OrderPriorityCd] ,
[OrderPriName] ,
[OrderExpdCd] ,
[OrderExpdCdName] ,
[TaxStat] ,
[CreditStat] ,
[SalesRepNo] ,
[SalesRepName] ,
[CustSvcRepNo] ,
[CustSvcRepName] ,
[CopiestoPrint] ,
[OrderCarrier] ,
[OrderCarName] ,
[CreditAuthNo] ,
[BOLNO] ,
[NoCartons] ,
[ShipInstrCd] ,
[ShipInstrCdName] ,
[SalesTaxRt] ,
[PORefNo] ,
[ResaleNo] ,
[VerifyType] ,
[ConfirmDt] ,
[RlsWhseDt] ,
[StageDt] ,
[StageBin] ,
[ConsolidateDt] ,
[ComInvPrtDt] ,
[ShippedDt] ,
[CommMedia] ,
[SubType] ,
[HeaderStatus] ,
[OrigShipDt] ,
[OrigShipDt1] ,
[OrigShipDt2] ,
[OrigShipDt3] ,
[OneTimeSTNo] ,
[LinesChanged] ,
[LineItemOdom] ,
[NoLaterDt] ,
[CustoType] ,
[CustTypeName] ,
[ScanQty] ,
[ListCd] ,
[AckPrintedDt] ,
[CustShipLoc] ,
[ShipThruLoc] ,
[ReorderUseLoc] ,
[User2] ,
[User3] ,
[User4] ,
[User5] ,
[ShippingMark1] ,
[ShippingMark2] ,
[ShippingMark3] ,
[ShippingMark4] ,
[OrderReprints] ,
[DropVendorID] ,
[DropVendorName] ,
[RecommendCarCd] ,
[RecommendCarName] ,
[SurChargeInd] ,
[SummaryBillInd] ,
[ReferenceNo] ,
[CashItemOdm] ,
[CustTaxRateCd] ,
[StateTaxCd] ,
[CountyTaxCd] ,
[CityTaxCd] ,
[TaxDistrict] ,
[RemitCd] ,
[DiscNet1PCt] ,
[DiscNet2PCt] ,
[DiscNet3PCt] ,
[ASNFmt] ,
[JobName] ,
[JobNo] ,
[JobLocation] ,
[Destination] ,
[JobBuilding] ,
[ASAPind] ,
[ShipToCd] ,
[ShipToName] ,
[ShipToAddress1] ,
[ShipToAddress2] ,
[ShipToAddress3] ,
[City] ,
[State] ,
[Zip] ,
[PhoneNo] ,
[FaxNo] ,
[ContactName] ,
[ContactPhoneNo] ,
[Province] ,
[Country] ,
[CountryCd] ,
[EntryDt] ,
[EntryID] ,
[ChangeDt] ,
[ChangeID] ,
[StatusCd] ,
[CustPONo] ,
[RefSONo] ,
[OrderFreightCd] ,
[OrderFreightName] ,
[PendingDt] ,
[ShipMethodName] ,
[Remarks] ,
[TaxRateCd] ,
[BranchReqDt] ,
[OrderContactName] ,
[Cmt_pSOCommID] ,
[Cmt_fSOHeaderID] ,
[Cmt_Type] ,
[Cmt_FormsCd] ,
[Cmt_CommLineNo] ,
[Cmt_CommLineSeqNo] ,
[Cmt_CommText] ,
[Cmt_DeleteDt] ,
[Cmt_EntryID] ,
[Cmt_EntryDt] ,
[Cmt_ChangeID] ,
[Cmt_ChangeDt] ,
[Cmt_StatusCd] )
SELECT    *
FROM         SOHeaderHist inner JOIN
                     SOComments ON SOHeaderHist.pSOHeaderHistID = SOComments.fSOHeaderID 
WHERE InvoiceNo='IP2479093'


select	pSOHeaderHistID, OrderNo, InvoiceNo, TotalOrder, TotalCost, NetSales, SellToCustNo, ARPostDt, CustShipLoc,
	Dtl_LineNumber, Dtl_LineType, dtl_ItemNo, DTL_NetUnitPrice, DTL_QtyOrdered, Dtl_QtyShipped, Dtl_UnitCost, Dtl_NetWght,
	Exp_LineNumber, Exp_ExpenseCd, Exp_Amount, Exp_DocumentLoc, Cmt_Type, Cmt_CommLineNo, Cmt_CommText
 from @tSORecall

--select DISTINCT 'SOHeaderHist' AS HeaderTbl, 'SODetailHist' AS DetailTbl, 'SOExpenseHist' AS ExpenseTbl, 'SOComments' as CommentTbl, pSOHeaderHistID  from @tSORecall

IF @@RowCount = 0
   BEGIN
      print 'No Data'
   END
ELSE
   BEGIN
      print 'Data Found'
   END