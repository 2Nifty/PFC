DECLARE @NewName varchar(50)

SET @NewName =	(SELECT 'tWO1341SOHeaderHistBKP' + 
		CAST(DATEPART(yyyy,GETDATE()) as char(4)) + '-' +
		CAST(DATENAME(mm,GETDATE()) as char(3)) + '-' +
		CAST(DATEPART(dd,GETDATE()) as char(2)))

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341SOHeaderHistBKP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
exec sp_rename 'tWO1341SOHeaderHistBKP', @NewName
GO

CREATE TABLE [dbo].[tWO1341SOHeaderHistBKP] (
	[pSOHeaderHistID] [int] NOT NULL ,
	[OrderNo] [decimal](10, 0) NULL ,
	[OrderRelNo] [decimal](4, 0) NULL ,
	[OrderType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderTypeDsc] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InvoiceNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PriceCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DiscountCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TotalOrder] [decimal](38, 20) NULL ,
	[TotalCost] [decimal](38, 20) NULL ,
	[TotalCost2] [decimal](38, 20) NULL ,
	[CommDol] [decimal](15, 5) NULL ,
	[CommPct] [decimal](15, 4) NULL ,
	[DiscPct] [decimal](15, 4) NULL ,
	[ComSplit1] [decimal](5, 2) NULL ,
	[ComSplit2] [decimal](5, 2) NULL ,
	[ComSplit3] [decimal](5, 2) NULL ,
	[SlsRepId1] [decimal](9, 0) NULL ,
	[SlsRepId2] [decimal](9, 0) NULL ,
	[SlsRepId3] [decimal](9, 0) NULL ,
	[NetSales] [decimal](15, 5) NULL ,
	[TaxSum] [decimal](15, 5) NULL ,
	[NonTaxAmt] [decimal](15, 4) NULL ,
	[TaxExpAmt] [decimal](15, 4) NULL ,
	[NonTaxExpAmt] [decimal](15, 5) NULL ,
	[TaxAmt] [decimal](15, 5) NULL ,
	[CreditCdAmt] [decimal](15, 5) NULL ,
	[ShipWght] [decimal](15, 4) NULL ,
	[BOLWght] [decimal](15, 4) NULL ,
	[BillToCustNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToCustName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToAddress1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToAddress2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToAddress3] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToProvince] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BillToContactPhoneNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToCustNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToCustName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToAddress1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToAddress2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToAddress3] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToProvince] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellToContactPhoneNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteDt] [datetime] NULL ,
	[CompleteDt] [datetime] NULL ,
	[VerifyDt] [datetime] NULL ,
	[PrintDt] [datetime] NULL ,
	[InvoiceDt] [datetime] NULL ,
	[ARPostDt] [datetime] NULL ,
	[SchShipDt] [datetime] NULL ,
	[ConfirmShipDt] [datetime] NULL ,
	[PickDt] [datetime] NULL ,
	[PickCompDt] [datetime] NULL ,
	[AllocDt] [datetime] NULL ,
	[HoldDt] [datetime] NULL ,
	[OrderDt] [datetime] NULL ,
	[OrderPromDt] [datetime] NULL ,
	[OrderLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderLocName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipLocName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UsageLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UsageLocName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HoldReason] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HoldReasonName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PriceRvwFlag] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReasonCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReasonCdName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BOFlag] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderMethCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderMethName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderTermsCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderTermsName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderPriorityCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderPriName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderExpdCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderExpdCdName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxStat] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreditStat] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SalesRepNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SalesRepName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustSvcRepNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustSvcRepName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CopiestoPrint] [smallint] NULL ,
	[OrderCarrier] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderCarName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreditAuthNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BOLNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NoCartons] [decimal](9, 0) NULL ,
	[ShipInstrCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipInstrCdName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SalesTaxRt] [decimal](7, 4) NULL ,
	[PORefNo] [decimal](10, 0) NULL ,
	[ResaleNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VerifyType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConfirmDt] [datetime] NULL ,
	[RlsWhseDt] [datetime] NULL ,
	[StageDt] [datetime] NULL ,
	[StageBin] [decimal](10, 0) NULL ,
	[ConsolidateDt] [datetime] NULL ,
	[ComInvPrtDt] [datetime] NULL ,
	[ShippedDt] [datetime] NULL ,
	[CommMedia] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SubType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HeaderStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrigShipDt] [datetime] NULL ,
	[OrigShipDt1] [datetime] NULL ,
	[OrigShipDt2] [datetime] NULL ,
	[OrigShipDt3] [datetime] NULL ,
	[OneTimeSTNo] [decimal](10, 0) NULL ,
	[LinesChanged] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineItemOdom] [smallint] NULL ,
	[NoLaterDt] [datetime] NULL ,
	[CustoType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustTypeName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ScanQty] [decimal](15, 2) NULL ,
	[ListCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AckPrintedDt] [datetime] NULL ,
	[CustShipLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipThruLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReorderUseLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[User2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[User3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[User4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[User5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShippingMark1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShippingMark2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShippingMark3] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShippingMark4] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderReprints] [int] NULL ,
	[DropVendorID] [decimal](9, 0) NULL ,
	[DropVendorName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RecommendCarCd] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RecommendCarName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SurChargeInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SummaryBillInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReferenceNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CashItemOdm] [smallint] NULL ,
	[CustTaxRateCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateTaxCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CountyTaxCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CityTaxCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxDistrict] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemitCd] [decimal](9, 0) NULL ,
	[DiscNet1PCt] [decimal](5, 2) NULL ,
	[DiscNet2PCt] [decimal](5, 2) NULL ,
	[DiscNet3PCt] [decimal](5, 2) NULL ,
	[ASNFmt] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[JobName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[JobNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[JobLocation] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Destination] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[JobBuilding] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ASAPind] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipToCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipToName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipToAddress1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipToAddress2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipToAddress3] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PhoneNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FaxNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhoneNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Province] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CountryCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StatusCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustPONo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RefSONo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderFreightCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderFreightName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PendingDt] [datetime] NULL ,
	[ShipMethodName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Remarks] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxRateCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BranchReqDt] [datetime] NULL ,
	[OrderContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DiscountAmt] [decimal](18, 6) NULL ,
	[fSOHeaderID] [int] NULL ,
	[CustReqDt] [datetime] NULL ,
	[ShipToContactID] [int] NULL ,
	[SellToContactID] [int] NULL ,
	[MakeOrderDt] [datetime] NULL ,
	[CustCarrierAcct] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AllowBOInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConsolidateOrdersInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipCompleteInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewDt] [datetime] NULL ,
	[AllocRelDt] [datetime] NULL ,
	[InvoiceSendMethod] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InvoiceSendDest] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InvoiceSendDate1] [datetime] NULL ,
	[InvoiceSendDate2] [datetime] NULL ,
	[InvoiceSendDate3] [datetime] NULL ,
	[InvoiceSent] [int] NULL ,
	[InvoiceFiled] [int] NULL ,
	[ResendInvoice] [int] NULL ,
	[RefileInvoice] [int] NULL ,
	[DiscountAmount] [decimal](18, 6) NULL ,
	[DiscountDt] [datetime] NULL ,
	[ARDueDt] [datetime] NULL ,
	[fCustomerAddressID] [int] NULL ,
	[DeleteReasonCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteReasonName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteUserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShipTrackingNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ShippingCost] [decimal](18, 6) NULL ,
	[DocumentSortInd] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CertRequiredInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderSource] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

DECLARE @NewName varchar(50)

SET @NewName =	(SELECT 'tWO1341SODetailHistBKP' + 
		CAST(DATEPART(yyyy,GETDATE()) as char(4)) + '-' +
		CAST(DATENAME(mm,GETDATE()) as char(3)) + '-' +
		CAST(DATEPART(dd,GETDATE()) as char(2)))

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341SODetailHistBKP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
exec sp_rename 'tWO1341SODetailHistBKP', @NewName
GO

CREATE TABLE [dbo].[tWO1341SODetailHistBKP] (
	[pSODetailHistID] [int] NOT NULL ,
	[fSOHeaderHistID] [int] NULL ,
	[LineNumber] [int] NULL ,
	[LineSeq] [int] NULL ,
	[LineType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LinePriceInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineReason] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineReasonDsc] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineExpdCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineExpdCdDsc] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LineStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POLine] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ItemDsc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BinLoc] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IMLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DiscInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReleaseInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CostInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ServChrgInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[XrefCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderLvlCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BOLCategoryCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PriceCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DealerCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LISC] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LISource] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RevLvl] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QtyStat] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DealerNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ComPct] [decimal](5, 2) NULL ,
	[ComDol] [decimal](38, 20) NULL ,
	[NetUnitPrice] [decimal](38, 20) NULL ,
	[ListUnitPrice] [decimal](38, 20) NULL ,
	[DiscUnitPrice] [decimal](38, 20) NULL ,
	[DiscPct1] [smallint] NULL ,
	[DiscPct2] [smallint] NULL ,
	[DiscPct3] [smallint] NULL ,
	[QtyAvailLoc1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QtyAvail1] [decimal](15, 2) NULL ,
	[QtyAvailLoc2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QtyAvail2] [decimal](15, 2) NULL ,
	[QtyAvailLoc3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[QtyAvail3] [decimal](15, 2) NULL ,
	[OrigOrderNo] [decimal](9, 0) NULL ,
	[OrigOrderLineNo] [decimal](9, 0) NULL ,
	[RqstdShipDt] [datetime] NULL ,
	[OrigShipDt] [datetime] NULL ,
	[ActualShipDt] [datetime] NULL ,
	[LineSchDtChange] [datetime] NULL ,
	[SuggstdShipDt] [datetime] NULL ,
	[DeleteDt] [datetime] NULL ,
	[QtyOrdered] [decimal](15, 2) NULL ,
	[QtyShipped] [decimal](15, 2) NULL ,
	[QtyBO] [decimal](15, 2) NULL ,
	[SellStkUM] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SellStkFactor] [decimal](5, 0) NULL ,
	[UnitCost] [decimal](15, 5) NULL ,
	[UnitCost2] [decimal](15, 5) NULL ,
	[UnitCost3] [decimal](15, 5) NULL ,
	[RepCost] [decimal](15, 5) NULL ,
	[OECost] [decimal](15, 5) NULL ,
	[RebateAmt] [decimal](15, 5) NULL ,
	[SuggstdShipFrLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SuggstdShipFrName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NoReschd] [smallint] NULL ,
	[Remark] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustItemNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CustItemDsc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BOMQtyPer] [decimal](10, 0) NULL ,
	[BOMQtyIssued] [decimal](10, 4) NULL ,
	[EntryDate] [datetime] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDate] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GrossWght] [decimal](15, 4) NULL ,
	[NetWght] [decimal](15, 4) NULL ,
	[ExtendedPrice] [decimal](18, 6) NULL ,
	[ExtendedCost] [decimal](18, 6) NULL ,
	[ExtendedNetWght] [decimal](18, 6) NULL ,
	[ExtendedGrossWght] [decimal](18, 6) NULL ,
	[SellStkQty] [decimal](18, 6) NULL ,
	[AlternateUM] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternateUMQty] [decimal](18, 6) NULL ,
	[ShipThruLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[fSODetailID] [int] NULL ,
	[QtyStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExcludedFromUsageFlag] [tinyint] NULL ,
	[OriginalQtyRequested] [decimal](18, 6) NULL ,
	[UsageLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternatePrice] [decimal](18, 6) NULL ,
	[SuperEquivQty] [decimal](18, 6) NULL ,
	[SuperEquivUM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CarrierCd] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IMLocName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StkUM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FreightCd] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CertRequiredInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

DECLARE @NewName varchar(50)

SET @NewName =	(SELECT 'tWO1341SOExpenseHistBKP' + 
		CAST(DATEPART(yyyy,GETDATE()) as char(4)) + '-' +
		CAST(DATENAME(mm,GETDATE()) as char(3)) + '-' +
		CAST(DATEPART(dd,GETDATE()) as char(2)))

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341SOExpenseHistBKP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
exec sp_rename 'tWO1341SOExpenseHistBKP', @NewName
GO

CREATE TABLE [dbo].[tWO1341SOExpenseHistBKP] (
	[pSOExpenseHistID] [bigint] NOT NULL ,
	[fSOHeaderHistID] [decimal](10, 0) NULL ,
	[LineNumber] [int] NULL ,
	[ExpenseNo] [int] NULL ,
	[ExpenseCd] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Amount] [float] NULL ,
	[Cost] [float] NULL ,
	[ExpenseInd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TaxStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeliveryCharge] [float] NULL ,
	[HandlingCharge] [float] NULL ,
	[PackagingCharge] [float] NULL ,
	[MiscCharge] [float] NULL ,
	[PhoneCharge] [float] NULL ,
	[DocumentLoc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DeleteDt] [datetime] NULL ,
	[EntryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryDt] [datetime] NULL ,
	[ChangeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ChangeDt] [datetime] NULL ,
	[StatusCd] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExpenseDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

