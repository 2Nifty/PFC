USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pQuoteAndOrderHdrV2]    Script Date: 11/01/2011 16:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pQuoteAndOrderHdrV2]
		@PeriodMonth varchar(10),
		@PeriodYear varchar(10),
		@StartDate varchar(32),
		@EndDate varchar(32),
		@LocationCode nvarchar(10),
		@CustNo nvarchar(10),
		@OrderSource varchar(10),
		@SourceType	varchar(20),	--ECOMM - MANUAL - ECOMM_ORD - MANUAL_ORD - MISSED_ECOMM - MISSED_MANUAL
		@ItemNotOrdFlg varchar(5)	--TRUE - FALSE

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
			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.OrderSource,''RQ'') = ''WQ'''
	   end

	if @SourceType = 'MANUAL' or @SourceType = 'MANUAL_ORD'
	   begin
			Set @whereQuote = @whereQuote + ' AND Src.Sequence <> 1'
			if @SourceType = 'MANUAL_ORD'
				Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') <> '''''
	   end

	if @SourceType = 'MISSED_MANUAL'
	   begin
			Set @whereQuote = @whereQuote + ' AND isnull(Quote.OrderSource,''RQ'') = ''RQ'''
	   end
	------------------------------------------
	-- END: OrderSource Filter & SourceType --
	------------------------------------------

	--Items Not Ordered filter
	if UPPER(@ItemNotOrdFlg) = 'TRUE'
	   begin
			Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') = '''''
--			Set @whereWebActivity = @whereWebActivity + ' AND WebActivity.OrderCompletionStatus <> 1'	--USE MakeOrderID/Dt for completed quotes into orders per CSR 09/22/11
			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.MakeOrderID,'''') = '''''
	   end
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
							' 		CM.CustShipLocation as SalesBranchofRecord, ' +
							' 		WebActivity.SessionID as QuoteNumber, ' +
							'		WebActivity.OrderSource as OrdSrc, ' +
							'		Src.OrdSrcDsc as QuoteMethod, ' +
							' 		count(WebActivity.ItemNo) as LineCount, ' +
							' 		MAX(WebActivity.QuoteDt) as QuotationDate, ' +
							' 		null as ExpiryDate, ' +
							' 		sum(WebActivity.Qty) as RequestQuantity, ' +
							' 		sum(WebActivity.SellPrice * WebActivity.Qty) as ExtPrice, ' +
							' 		sum(IM.GrossWght * WebActivity.Qty) as ExtWeight ' +
							'FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN ' +
							' 		CustomerMaster CM (NOLOCK) ' +
							'ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
							'		ItemMaster IM (NOLOCK) ' +
							'ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
							' 		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.ListDtlDesc,''No Desc'') as OrdSrcDsc, ' +
							' 				isnull(LD.SequenceNo,0) as [Sequence] ' +
							' 		 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
							' 				ListDetail LD (NOLOCK) ' +
							' 		 ON		LM.pListMasterID = LD.fListMasterID ' +
							' 		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'ON		isnull(WebActivity.OrderSource,''RQ'') = Src.OrdSrc ' +
							'WHERE	' + @whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource + ' ' +
							'GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID, WebActivity.OrderSource, Src.OrdSrcDsc ' +
							'ORDER BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID '
	   end

	--Manual Quotes & Orders
	if UPPER(@SourceType) =	'MANUAL' or @SourceType = 'MANUAL_ORD' or UPPER(@SourceType) = 'MISSED_MANUAL'
	   begin
			set @strSQL =	'SELECT	CM.CustNo as CustomerNumber, ' +
							' 		CM.CustShipLocation as SalesBranchofRecord, ' +
							' 		Quote.SessionID as QuoteNumber, ' +
							'		Quote.OrderSource as OrdSrc, ' +
							'		Src.OrdSrcDsc as QuoteMethod, ' +
							' 		count(Quote.PFCItemNo) as LineCount, ' +
							' 		MAX(Quote.QuotationDate) as QuotationDate, ' +
							' 		MAX(Quote.ExpiryDate) as ExpiryDate, ' +
							' 		sum(Quote.RequestQuantity) as RequestQuantity, ' +
							' 		sum(Quote.UnitPrice * Quote.RequestQuantity) as ExtPrice, ' +
							' 		sum(Quote.GrossWeight * Quote.RequestQuantity) as ExtWeight ' +
							'FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
							' 		CustomerMaster CM (NOLOCK) ' +
							'ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN ' +
							' 		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.ListDtlDesc,''No Desc'') as OrdSrcDsc, ' +
							' 				isnull(LD.SequenceNo,0) as [Sequence] ' +
							' 		 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
							' 				ListDetail LD (NOLOCK) ' +
							' 		 ON		LM.pListMasterID = LD.fListMasterID ' +
							' 		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'ON		isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
							'WHERE	' + @whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource + ' ' +
							'GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID, Quote.OrderSource, Src.OrdSrcDsc ' +
							'ORDER BY CM.CustNo, CM.CustShipLocation, Quote.SessionID '
	   end

	Print ''
	Print '-- **' + @SourceType
	Print @strSQL
	EXEC sp_executesql @strSQL
END

-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','ECOMM','FALSE'
-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','ECOMM_ORD','FALSE'
-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','555555','','MANUAL','FALSE'
-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','MANUAL_ORD','FALSE'
-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','000016','','MISSED_ECOMM','FALSE'
-- Exec [pQuoteAndOrderHdrV2] '12','2010','','','','555555','','MISSED_MANUAL','FALSE'
