--USE [PERP]
--GO

drop proc [pQuoteAndOrderDtlV2]
go

/****** Object:  StoredProcedure [dbo].[pQuoteAndOrderDtlV2]    Script Date: 11/01/2011 16:58:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pQuoteAndOrderDtlV2]
		@PeriodMonth varchar(10),
		@PeriodYear varchar(10),
		@StartDate varchar(32),
		@EndDate varchar(32),
		@LocationCode nvarchar(10),
		@CustNo nvarchar(10),
		@OrderSource varchar(10),
		@SourceType	varchar(20),	--ECOMM - MANUAL - ECOMM_ORD - MANUAL_ORD - MISSED_ECOMM - MISSED_MANUAL
		@ItemNotOrdFlg varchar(5),	--TRUE - FALSE
		@QuoteNumber varchar(50)

AS
DECLARE	@strSQL nvarchar(4000),
		@whereCommon nvarchar(4000),
		@whereWebActivity nvarchar(2000),
		@whereWebSource nvarchar(2000),
		@whereQuote nvarchar(2000),
		@whereQuoteSource nvarchar(2000)

BEGIN
	SET NOCOUNT ON;

	-----------------------------------------
	--  BEGIN: Bind the WHERE clause(s)   --
	-----------------------------------------
	SET @whereCommon = '0=0'
	SET @whereWebActivity = '1=1'
	SET @whereWebSource = '2=2'
	SET @whereQuote = '11=11'
	SET @whereQuoteSource = '22=22'

	---------------------------------
	-- BEGIN: Customer data fields --
	---------------------------------
	--Specific CustShipLocation
	if @LocationCode <> ''
        begin 
			Set @whereCommon = @whereCommon + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end

	--Specific CustNo
	if @CustNo <> ''
        begin 
            Set @whereCommon = @whereCommon + ' AND CM.CustNo like ''%' + @CustNo +'%'''
        end
	-------------------------------
	-- END: Customer data fields --
	-------------------------------

	------------------------------
	-- BEGIN: Period/Date Range --
	------------------------------
	--By Period
	if @PeriodYear <> ''
        begin 
			Set @whereWebActivity = @whereWebActivity + ' AND Year(WebActivity.QuoteDt) = ' + @PeriodYear
			Set @whereQuote = @whereQuote + ' AND Year(Quote.QuotationDate) = ' + @PeriodYear
        end
    if @PeriodMonth <> ''
        begin 
			Set @whereWebActivity = @whereWebActivity + ' AND Month(WebActivity.QuoteDt) = ' + @PeriodMonth
			Set @whereQuote = @whereQuote + ' AND Month(Quote.QuotationDate) = ' + @PeriodMonth
        end

	--By Date Range
	if @StartDate <> '' and @EndDate <> '' 
        begin 
			Set @whereWebActivity = @whereWebActivity + ' AND (Cast(CONVERT(nvarchar(20), WebActivity.QuoteDt, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
			Set @whereQuote = @whereQuote + ' AND (Cast(CONVERT(nvarchar(20), Quote.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end
	----------------------------
	-- END: Period/Date Range --
	----------------------------

	--------------------------------------------
	-- BEGIN: OrderSource Filter & SourceType --
	--------------------------------------------
	--OrderSource filter
	if @OrderSource <> '' and UPPER(@OrderSource) <> 'ALL'
        begin 
			if UPPER(@OrderSource) = 'ALLCSR'
			   begin
					Set @whereQuoteSource = @whereQuoteSource + ' AND Src.[Sequence] <> 1'
					Set @whereWebSource = @whereWebSource + ' AND Src.[Sequence] <> 1'
			   end
			else
			   begin
					if UPPER(@OrderSource) = 'ALLEC'
					   begin
							Set @whereQuoteSource = @whereQuoteSource + ' AND Src.[Sequence] = 1'
							Set @whereWebSource = @whereWebSource + ' AND Src.[Sequence] = 1'
					   end
					else
					   begin
							Set @whereQuoteSource = @whereQuoteSource + ' AND isnull(Quote.OrderSource,''RQ'') like ''%' + @OrderSource +'%'''
							Set @whereWebSource = @whereWebSource + ' AND isnull(WebActivity.OrderSource,''RQ'') like ''%' + @OrderSource +'%'''
					   end
			   end
        end

	--Report Source Type
	if @SourceType = 'ECOMM' or @SourceType = 'ECOMM_ORD'
	   begin
			Set @whereWebActivity = @whereWebActivity + ' AND Src.Sequence = 1'
			if @SourceType = 'ECOMM_ORD'
				Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.MakeOrderID,'''') <> '''''
	   end

	if @SourceType = 'MISSED_ECOMM'
	   begin
--			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.OrderSource,''RQ'') = ''WQ'''
			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.MakeOrderID,'''') = '''''
	   end

	if @SourceType = 'MANUAL' or @SourceType = 'MANUAL_ORD'
	   begin
			Set @whereQuote = @whereQuote + ' AND Src.Sequence <> 1'
			if @SourceType = 'MANUAL_ORD'
				Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') <> '''''
	   end

	if @SourceType = 'MISSED_MANUAL'
	   begin
--			Set @whereQuote = @whereQuote + ' AND isnull(Quote.OrderSource,''RQ'') = ''RQ'''
			Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') = '''''
	   end
	------------------------------------------
	-- END: OrderSource Filter & SourceType --
	------------------------------------------

	--Items Not Ordered filter
	if UPPER(@ItemNotOrdFlg) = 'TRUE'
	   begin
--			Set @whereWebActivity = @whereWebActivity + ' AND WebActivity.OrderCompletionStatus <> 1'	--USE MakeOrderID/Dt for completed quotes into orders per CSR 09/22/11
			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.MakeOrderID,'''') = '''''
			Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') = '''''
	   end

	--Specific Quote Number
	if @QuoteNumber <> ''
	   begin
			Set @whereWebActivity = @whereWebActivity + ' AND WebActivity.SessionID like ''%' + @QuoteNumber +'%'''
			Set @whereQuote = @whereQuote + ' AND Quote.SessionID like ''%' + @QuoteNumber +'%'''
	   end

	Print '-- whereWebActivity: ' + @whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource
	Print '-- whereQuote: ' + @whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource
	---------------------------------------
	--  END: Bind the  WHERE clause(s)   --
	---------------------------------------

	----------------------------------------------------------------
	--  BEGIN: Build the SELECT statement for the header summary  --
	----------------------------------------------------------------
	--eCommerce Quotes & Orders
	if UPPER(@SourceType) =	'ECOMM' or @SourceType = 'ECOMM_ORD' or UPPER(@SourceType) = 'MISSED_ECOMM'
	   begin
			set @strSQL =	'SELECT	CM.CustNo as CustomerNumber, ' +
							' 		CM.CustShipLocation as SalesBranchofRecord, ' +		--SalesLocationCode
							' 		WebActivity.SessionID as QuoteNumber, ' +
							'		CONVERT(nvarchar(20), WebActivity.QuoteDt, 101) as QuotationDate, ' +
							' 		null as ExpiryDate, ' +
							'		isnull(WebActivity.OrderSource,''n/a'') as OrderSource, ' +
							'		Src.OrdSrcDsc as QuoteMethod, ' +					--OrderMethod
							'		isnull(PendHdr.PurchaseOrderNo,''No PO'') as PurchaseOrderNo, ' +
							'		PendHdr.PurchaseOrderDate, ' +
							' 		WebActivity.CustItemNo as UserItemNo, ' +
							' 		WebActivity.ItemNo as PFCItemNo, ' +
							'		IM.ItemDesc as Description, ' +
							'		isnull(cast((round(WebActivity.Qty,0)) as Decimal(25,0)),0) as RequestQuantity, ' +
							'		isnull(cast((round(WebActivity.AvailQty,0)) as Decimal(25,0)),0) as RunningAvailQty, ' +
							'		isnull(cast((round(WebActivity.SellPrice,2)) as Decimal(25,2)),0) as UnitPrice, ' +
							'		0 as Margin, ' +
							'		WebActivity.SellUM as PriceUOM, ' +
							'		isnull(cast((round(WebActivity.SellPrice * WebActivity.Qty,2)) as Decimal(25,2)),0) as TotalPrice, ' +
							'		isnull(cast((round(IM.GrossWght * WebActivity.Qty,1)) as Decimal(25,1)),0) as GrossWeight, ' +	--Weight
							'		isnull(PendHdr.ECommUserName,''NA'') as ECommUserName, ' +
							'		isnull(PendHdr.ECommIPAddress,''NA'') as ECommIPAddress,  ' +
							'		isnull(PendHdr.ECommPhoneNo,''NA'') as ECommPhoneNo ' +
							'FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN ' +
							' 		CustomerMaster CM (NOLOCK) ' +
							'ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
							'		ItemMaster IM (NOLOCK) ' +
							'ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
--							'		(SELECT	Dtl.QuotationItemDetailID, ' +
--							'				Hdr.PurchaseOrderNo, ' +
--							'				HDR.PurchaseOrderDate ' +
--							'		 FROM	DTQ_CustomerPendingOrder Hdr (NOLOCK) INNER JOIN ' +
--							'				DTQ_CustomerPendingOrderDetail Dtl (NOLOCK) ' +
--							'		 ON		Hdr.ID = Dtl.PurchaseOrderID) PendOrd ' +
----							'ON		WebActivity.QuoteNo = PendOrd.QuotationItemDetailID LEFT OUTER JOIN' +
--							'ON		WebActivity.SessionID = PendOrd.QuotationItemDetailID LEFT OUTER JOIN ' +
							' 		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.ListDtlDesc,''No Desc'') as OrdSrcDsc, ' +
							' 				isnull(LD.SequenceNo,0) as [Sequence] ' +
							' 		 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
							' 				ListDetail LD (NOLOCK) ' +
							' 		 ON		LM.pListMasterID = LD.fListMasterID ' +
							' 		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'ON		isnull(WebActivity.OrderSource,''RQ'') = Src.OrdSrc LEFT OUTER JOIN ' +
							'		DTQ_CustomerPendingOrderDetail PendDtl (NOLOCK) ' +
							'ON		WebActivity.SessionID = PendDtl.QuotationItemDetailID LEFT OUTER JOIN ' +
							'		DTQ_CustomerPendingOrder PendHdr (NOLOCK) ' +
							'ON		PendHdr.ID = PendDtl.PurchaseOrderID ' +
							'WHERE	' + @whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource + ' ' +
							'ORDER BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID '
	   end

	--Manual Quotes & Orders
	if UPPER(@SourceType) =	'MANUAL' or @SourceType = 'MANUAL_ORD' or UPPER(@SourceType) = 'MISSED_MANUAL'
	   begin
			set @strSQL =	'SELECT	CM.CustNo as CustomerNumber, ' +
							' 		CM.CustShipLocation as SalesBranchofRecord, ' +		--SalesLocationCode
							' 		Quote.SessionID as QuoteNumber, ' +
							'		CONVERT(nvarchar(20), Quote.QuotationDate, 101) as QuotationDate, ' +
							' 		Quote.ExpiryDate, ' +
							'		isnull(Quote.OrderSource,''n/a'') as OrderSource, ' +
							'		Src.OrdSrcDsc as QuoteMethod, ' +					--OrderMethod
							'		isnull(RelHdr.CustPONo,''No PO'') as PurchaseOrderNo, ' +
							'		RelHdr.OrderDt as PurchaseOrderDate, ' +
							'		Quote.UserItemNo, ' +
							' 		Quote.PFCItemNo, ' +
							'		Quote.Description, ' +
							'		isnull(cast((round(Quote.RequestQuantity,0)) as Decimal(25,0)),0) as RequestQuantity, ' +
							'		isnull(cast((round(Quote.AvailableQuantity,0)) as Decimal(25,0)),0) as RunningAvailQty, ' +
							'		isnull(cast((round(Quote.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice, ' +
							'		0 as Margin, ' +
							'		Quote.PriceUOM, ' +
							'		isnull(cast((round(Quote.UnitPrice * Quote.RequestQuantity,2)) as Decimal(25,2)),0) as TotalPrice, ' +
							'		isnull(cast((round(Quote.GrossWeight * Quote.RequestQuantity,1)) as Decimal(25,1)),0) as GrossWeight, ' +	--Weight
							'		''Manual'' as ECommUserName, ' +
							'		''Manual'' as ECommIPAddress,  ' +
							'		''Manual'' as ECommPhoneNo ' +
							'FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
							' 		CustomerMaster CM (NOLOCK) ' +
							'ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN ' +
							'		SOHeaderRel RelHdr (NOLOCK) ' +
							'ON		Quote.SessionID = RelHdr.ReferenceNo LEFT OUTER JOIN ' +
							' 		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.ListDtlDesc,''No Desc'') as OrdSrcDsc, ' +
							' 				isnull(LD.SequenceNo,0) as [Sequence] ' +
							' 		 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
							' 				ListDetail LD (NOLOCK) ' +
							' 		 ON		LM.pListMasterID = LD.fListMasterID ' +
							' 		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'ON		isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
							'WHERE	' + @whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource + ' ' +
							'ORDER BY CM.CustNo, CM.CustShipLocation, Quote.SessionID '
	   end

	Print ''
	Print '-- **' + @SourceType
	Print @strSQL
	EXEC sp_executesql @strSQL
END

-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','032186','','ECOMM','FALSE','10120110'

-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','032186','ALL','ECOMM_ORD','FALSE','10520110'  --4
-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','555555','ALL','MANUAL','FALSE','1035600002'  --3

-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','032186','','MANUAL_ORD','FALSE'
-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','000016','','MISSED_ECOMM','FALSE'
-- Exec [pQuoteAndOrderDtlV2] '12','2010','','','','555555','','MISSED_MANUAL','FALSE'
