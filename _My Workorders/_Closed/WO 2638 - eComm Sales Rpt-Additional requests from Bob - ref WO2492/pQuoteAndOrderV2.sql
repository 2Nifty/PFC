--USE [PERP]
--GO

drop proc [pQuoteAndOrderV2]
go

/****** Object:  StoredProcedure [dbo].[pQuoteAndOrderV2]    Script Date: 11/01/2011 16:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pQuoteAndOrderV2]
		@PeriodMonth varchar(10),
		@PeriodYear varchar(10),
		@StartDate varchar(32),
		@EndDate varchar(32),
		@LocationCode nvarchar(10),
		@CustNo nvarchar(10),
		@PriceCdCtl varchar(5),		--TRUE or FALSE
		@OrderSource varchar(10),
		@ItemNotOrdFlg varchar(5)	--TRUE or FALSE
AS

DECLARE	@strSQL nvarchar(4000),
		@whereCommon nvarchar(4000),
		@whereWebActivity nvarchar(2000),
		@whereWebSource nvarchar(2000),
		@whereQuote nvarchar(2000),
		@whereQuoteSource nvarchar(2000)

DECLARE	@tblECommQuote varchar(200),
		@tblECommOrder varchar(200),
		@tblManualQuote varchar(200),
		@tblManualOrder varchar(200),
		@tblMissedECommQuote varchar(200),
		@tblMissedManualQuote varchar(200),
		@tblCustMaster varchar(200),
		@tblResult nvarchar(200)

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

	--PriceCd = 'X' filter
	if UPPER(@PriceCdCtl) = 'FALSE'
        begin 
            Set @whereCommon = @whereCommon + ' AND CM.PriceCd <> ''X'''
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

	--Items Not Ordered filter
	if UPPER(@ItemNotOrdFlg) = 'TRUE'
	   begin
			Set @whereQuote = @whereQuote + ' AND isnull(Quote.MakeOrderID,'''') = '''''
--			Set @whereWebActivity = @whereWebActivity + ' AND WebActivity.OrderCompletionStatus <> 1'	--USE MakeOrderID/Dt for completed quotes into orders per CSR 09/22/11
			Set @whereWebActivity = @whereWebActivity + ' AND isnull(WebActivity.MakeOrderID,'''') = '''''
	   end

	Print '-- whereWebActivity: ' + @whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource
	Print '-- whereQuote: ' + @whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource
	---------------------------------------
	--  END: Bind the  WHERE clause(s)   --
	---------------------------------------

/*	
	-----------------------------------------------------------------------------------------------------------------
	-- Since the CustomerMaster is joined in all of the Quote and Order tables, we do not need this Customer table --
	-----------------------------------------------------------------------------------------------------------------

	--Get CustomerMaster Information for given period
	SELECT	@tblCustMaster	= '##tCustMaster_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8)
	SET		@strSQL =	'SELECT	Quote.CustomerNumber, CM.CustShipLocation as SalesLocationCode ' +
						'INTO	' + @tblCustMaster + ' ' +
						'FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
						'		OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'ON		CM.CustNo = Quote.CustomerNumber COLLATE Latin1_General_CS_AS ' +
						'WHERE	Quote.DeleteFlag = 0 and ' + @CustWhere + ' ' +
						'GROUP BY Quote.CustomerNumber, CM.CustShipLocation' 	

	Print ''
	Print '-- **CustomerMaster'
	Print '--SELECT * FROM ' + @tblCustMaster
	Print '--DROP TABLE ' + @tblCustMaster
	Print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblCustMaster + '')
*/

	------------------------------------------------
	--  BEGIN: Get eCommerce Quote & Order Data   --
	------------------------------------------------
	Print ''
	Print '-- BEGIN: Get eCommerce Quote & Order Data'

	--eCommerce Quotes FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1
    SELECT  @tblECommQuote = '##tECommQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 

    SET		@strSQL =	'SELECT	ECommQuote.CustNo as CustomerNumber, ' +
						'		ECommQuote.SalesLocationCode, ' +
						'		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes, ' +
						'		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount, ' +
						'		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight ' +
						'INTO	' + @tblECommQuote + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				WebActivity.SessionID, ' +
						'				count(WebActivity.QuoteNo) as NoOfECommQuotes, ' +
						'				sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtAmount, ' +
						'				sum(IM.GrossWght * WebActivity.Qty) as eCommExtWeight ' +
						'		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN ' +
						'				CustomerMaster  CM (NOLOCK) ' +
						'		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
						'				ItemMaster IM (NOLOCK) ' +
						'		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		isnull(WebActivity.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.[Sequence] = 1 AND ' +			--This is an eComm Order Source
--						'				WebActivity.DeleteFlag = 0 AND ' +	--IGNORE per Tom White Jr 09/22/11
										@whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource + ' ' +
						'		 GROUP BY	CM.CustNo, CM.CustShipLocation, WebActivity.SessionID) ECommQuote ' +
						'GROUP BY  ECommQuote.CustNo, ECommQuote.SalesLocationCode'

	Print '--	**eCommerce Quotes FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1'
	Print '			--SELECT * FROM ' + @tblECommQuote
	Print '			--DROP TABLE ' + @tblECommQuote
	Print '		' + @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblECommQuote + '')

	--eCommerce Orders FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1 AND isnull(WebActivity.MakeOrderID,'') <> ''
	--	[USE MakeOrderID/Dt for completed quotes into orders per CSR 09/22/11]
	--	[IGNORE Detail tables per Tom White Jr 09/22/11]
    SELECT  @tblECommOrder = '##tECommOrder_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ECommOrder.CustNo as CustomerNumber, ' +
						'		ECommOrder.SalesLocationCode, ' +
						'		count(ECommOrder.NoOfECommOrders) as NoOfECommOrders, ' +
						'		sum(isnull(ECommOrder.eCommExtOrdAmount,0)) as eCommExtOrdAmount, ' +
						'		sum(isnull(ECommOrder.eCommExtOrdWeight,0)) as eCommExtOrdWeight ' +
						'INTO	' + @tblECommOrder + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				WebActivity.SessionID, ' +
						'				count(WebActivity.QuoteNo) as NoOfECommOrders, ' +
						'				Sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtOrdAmount, ' +
						'				Sum(IM.GrossWght * WebActivity.Qty) as eCommExtOrdWeight ' +

/*	--IGNORE the Detail tables per Tom White Jr 09/22/11
						'		 FROM	DTQ_CustomerPendingOrderDetail OrdDtl (NOLOCK) INNER JOIN ' +
						'				WebActivityPosting WebActivity (NOLOCK) ' +
						'		 ON		OrdDtl.QuotationItemDetailID = WebActivity.QuoteNo INNER JOIN ' +
						'				DTQ_CustomerPendingOrder OrdHdr (NOLOCK) ' +
						'		 ON		OrdDtl.PurchaseOrderID = OrdHdr.[ID] AND OrdHdr.OrderCompletedStatus =''true'' INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
						'				ItemMaster IM (NOLOCK) ' +
						'		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
*/
						'		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
						'				ItemMaster IM (NOLOCK) ' +
						'		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		isnull(WebActivity.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.[Sequence] = 1 AND ' +								--This is and eComm Order Source
--						'				WebActivity.OrderCompletionStatus = 1 AND ' +			--USE MakeOrderID/Dt for completed quotes into orders per CSR 09/22/11
						'				isnull(WebActivity.MakeOrderID,'''') <> '''' AND ' +	--This is a Made Order
										@whereCommon + ' AND ' + @whereWebActivity + ' AND ' + @whereWebSource + ' ' +
						'		 GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID) ECommOrder ' +
						'GROUP BY  ECommOrder.CustNo, ECommOrder.SalesLocationCode'

	Print ''
	print '--	**eCommerce Orders FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1 AND WebActivity.OrderCompletionStatus = 1'
	Print '			--SELECT * FROM ' + @tblECommOrder
	Print '			--DROP TABLE ' + @tblECommOrder
	print '		' + @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblECommOrder + '')

	Print '-- END: Get eCommerce Quote & Order Data'
	----------------------------------------------
	--  END: Get eCommerce Quote & Order Data   --
	----------------------------------------------

	---------------------------------------------
	--  BEGIN: Get Manual Quote & Order Data   --
	---------------------------------------------
	Print '*****************************************************'
	Print '-- BEGIN: Get Manual Quote & Order Data'

	--Manual Quotes FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1
    SELECT  @tblManualQuote	= '##tManualQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualQuote.CustNo as CustomerNumber, ' +
						'		ManualQuote.SalesLocationCode, ' +
						'		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes, ' +
						'		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount, ' +
						'		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight ' +
						'INTO	' + @tblManualQuote + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				Quote.SessionID, ' +
						'				count(Quote.QuoteNumber) as NoOfManualQuotes, ' +
						'				sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtAmount, ' +
						'				sum(Quote.GrossWeight * Quote.RequestQuantity) as ManualExtWeight ' +
						'		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.[Sequence] <> 1 AND ' +		--This is a Manual Order Source
--						'				Quote.DeleteFlag = 0 AND ' +	--IGNORE per Tom White Jr 09/22/11
										@whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource + ' ' +
						'		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID) ManualQuote ' +
						'GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode'

	Print '--	**Manual Quotes FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1'
	Print '			--SELECT * FROM ' + @tblManualQuote
	Print '			--DROP TABLE ' + @tblManualQuote
	Print '		' + @strSQL 
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblManualQuote + '')

	--Manual Orders FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1 AND isnull(Quote.MakeOrderID,'') <> ''
	--	[IGNORE Detail tables per Tom White Jr 09/22/11]
    SELECT  @tblManualOrder	= '##tManualOrder_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualOrder.CustNo as CustomerNumber, ' +
						'		ManualOrder.SalesLocationCode, ' +
						'		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders, ' +
						'		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount, ' +
						'		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight ' +
						'INTO	' + @tblManualOrder + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				Quote.SessionID, ' +
						'				count(Quote.QuoteNumber) as NoOfManualOrders, ' +
						'				Sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtOrdAmount, ' +
						'				sum(IM.GrossWght * Quote.RequestQuantity) as ManualExtOrdWeight ' +

/*	--IGNORE the Detail tables per Tom White Jr 09/22/11
						'		 FROM	DTQ_CustomerPendingOrderDetail OrdDtl (NOLOCK) INNER JOIN ' +
						'				DTQ_CustomerQuotation Quote (NOLOCK) ' +
						'		 ON		OrdDtl.QuotationItemDetailID = Quote.QuoteNumber INNER JOIN ' +
						'				DTQ_CustomerPendingOrder OrdHdr (NOLOCK) ' +
						'		 ON		OrdDtl.PurchaseOrderID = OrdHdr.[ID] AND OrdHdr.OrderCompletedStatus =''true'' INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN ' +
*/
						'		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = Quote.CustomerNumber INNER JOIN ' +
						'				ItemMaster IM (NOLOCK) ' +
						'		 ON		IM.ItemNo = Quote.PFCItemNo LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.[Sequence] <> 1 AND ' +						--This is a Manual Order Source
						'				isnull(Quote.MakeOrderID,'''') <> '''' AND ' +	--This is a Made Order
										@whereCommon + ' AND ' + @whereQuote + ' AND ' + @whereQuoteSource + ' ' +
						'		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID) ManualOrder ' +
						'GROUP BY ManualOrder.CustNo, ManualOrder.SalesLocationCode'

	print ''
	print '--	**Manual Orders FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1 AND isnull(Quote.MakeOrderID,'''') <> '''''
	Print '			--SELECT * FROM ' + @tblManualOrder
	Print '			--DROP TABLE ' + @tblManualOrder
	print '		' + @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblManualOrder + '')

	Print '-- END: Get Manual Quote & Order Data'
	-------------------------------------------
	--  END: Get Manual Quote & Order Data   --
	-------------------------------------------

	-----------------------------------------------
	--  BEGIN: Get Missed eCommerce Quote Data   --
	-----------------------------------------------
	Print '*****************************************************'
	Print '-- BEGIN: Get Missed eCommerce Quote Data'

	--Missed eCommerce Quotes FROM WebActivityPosting WHERE isnull(WebActivity.MakeOrderID,'') = ''
	--	USE MakeOrderID/Dt for "Missed" quotes per CSR 09/22/11
    SELECT  @tblMissedECommQuote = '##tMissedECommQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ECommQuote.CustNo as CustomerNumber, ' +
						'		ECommQuote.SalesLocationCode, ' +
						'		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes, ' +
						'		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount, ' +
						'		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight ' +
						'INTO	' + @tblMissedECommQuote + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				WebActivity.SessionID, ' +
						'				count(WebActivity.QuoteNo) as NoOfECommQuotes, ' +
						'				sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtAmount, ' +
						'				sum(IM.GrossWght * WebActivity.Qty) as eCommExtWeight ' +
						'		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN ' +
						'				ItemMaster IM (NOLOCK) ' +
						'		 ON		IM.ItemNo = WebActivity.ItemNo ' +
/*	--We don't need the OrderSource List here
						'		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		isnull(WebActivity.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.OrdSrc = ''WQ'' AND ' +							--This is a Web Quote/Order
*/
						'		 WHERE	isnull(WebActivity.MakeOrderID,'''') = '''' AND ' +	--This is NOT a Made Order
--						'				WebActivity.OrderSource = ''WQ'' AND ' +			--This is a Web Quote/Order
--						'				WebActivity.DeleteFlag = 0 AND ' +					--IGNORE per Tom White Jr 09/22/11
--						'				WebActivity.OrderCompletionStatus <> 1 AND ' +		--USE MakeOrderID/Dt for "Missed" quotes per CSR 09/22/11
										@whereCommon + ' AND ' + @whereWebActivity + ' ' +
						'		 GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID) ECommQuote ' +
						'GROUP BY ECommQuote.CustNo, ECommQuote.SalesLocationCode'

	Print '--	**Missed eCommerce Quotes FROM WebActivityPosting WHERE isnull(WebActivity.MakeOrderID,'''') = '''''
	Print '			--SELECT * FROM ' + @tblMissedECommQuote
	Print '			--DROP TABLE ' + @tblMissedECommQuote
	Print '		' + @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblMissedECommQuote + '')

	Print '-- END: Get Missed eCommerce Quote Data'
	---------------------------------------------
	--  END: Get Missed eCommerce Quote Data   --
	---------------------------------------------

	--------------------------------------------
	--  BEGIN: Get Missed Manual Quote Data   --
	--------------------------------------------
	Print '*****************************************************'
	Print '-- BEGIN: Get Missed Manual Quote Data'

	--Missed Manual Quotes FROM DTQ_CustomerQuotation WHERE	Quote.OrderSource = 'RQ' AND isnull(Quote.MakeOrderID,'') = ''
    SELECT  @tblMissedManualQuote = '##tMissedManualQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualQuote.CustNo as CustomerNumber, ' +
						'		ManualQuote.SalesLocationCode, ' +
						'		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes, ' +
						'		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount, ' +
						'		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight ' +
						'INTO	' + @tblMissedManualQuote + ' ' +
						'FROM	(SELECT	CM.CustNo, ' +
						'				CM.CustShipLocation as SalesLocationCode, ' +
						'				Quote.SessionID, ' +
						'				count(Quote.QuoteNumber) as NoOfManualQuotes, ' +
						'				sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtAmount, ' +
						'				sum(Quote.GrossWeight * Quote.RequestQuantity) as ManualExtWeight ' +
						'		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
						'				CustomerMaster CM (NOLOCK) ' +
						'		 ON		CM.CustNo = Quote.CustomerNumber ' +
/*	--We don't need the OrderSource List here
						'		 ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as [Sequence] ' +
						'				 FROM	ListMaster LM (NOLOCK) INNER JOIN ' +
						'						ListDetail LD (NOLOCK) ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON	isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
						'		 WHERE	Src.OrdSrc = ''RQ'' AND ' +						--This is a CSR Quote/Order
*/
						'		 WHERE	isnull(Quote.MakeOrderID,'''') = '''' AND ' +	--This is NOT a Made Order
--						'				Quote.OrderSource = ''RQ'' AND ' +				--This is a CSR Quote/Order
--						'				Quote.DeleteFlag = 0 AND ' +					--IGNORE per Tom White Jr 09/22/11
--						'				Quote.OrderCompletionStatus <> 1 AND ' +		--This table uses MakeOrderID instead
										@whereCommon + ' AND ' + @whereQuote + ' ' +
						'		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID) ManualQuote ' +
						'GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode'

	Print '--	**Missed Manual Quotes FROM DTQ_CustomerQuotation WHERE	Quote.OrderSource = ''RQ'' AND isnull(Quote.MakeOrderID,'''') = '''''
	Print '			--SELECT * FROM ' + @tblMissedManualQuote
	Print '			--DROP TABLE ' + @tblMissedManualQuote
	Print '		' + @strSQL 
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblMissedManualQuote + '')

	Print '-- END: Get Missed Manual Quote Data'
	------------------------------------------
	--  END: Get Missed Manual Quote Data   --
	------------------------------------------

	-----------------------------------------------------
	--  BEGIN: Compile & return the complete dataset   --
	-----------------------------------------------------
	Print '*****************************************************'
	Print '-- BEGIN: Compile & return the complete dataset'

	--Create a DISTINCT list of all CustomerNumber/SalesLocation values from all the recordsets
	SELECT	@tblCustMaster = '##tCustMaster_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8)
	SET	@strSQL =	'SELECT		DISTINCT ' + 
					'			isnull(tECommQuote.CustomerNumber, isnull(tECommOrd.CustomerNumber, isnull(tManualQuote.CustomerNumber, isnull(tManualOrd.CustomerNumber, isnull(tMissedEcomm.CustomerNumber, isnull(tMissedManual.CustomerNumber,''No Cust'')))))) as CustomerNumber, ' +
					'			isnull(tECommQuote.SalesLocationCode, isnull(tECommOrd.SalesLocationCode, isnull(tManualQuote.SalesLocationCode, isnull(tManualOrd.SalesLocationCode, isnull(tMissedEcomm.SalesLocationCode, isnull(tMissedManual.SalesLocationCode,''No Loc'')))))) as SalesLocationCode ' +
					'INTO	' + @tblCustMaster + ' ' +
					'FROM	' + @tblECommOrder + ' tECommOrd FULL OUTER JOIN ' +
								@tblECommQuote + ' tECommQuote ' +
					'ON			tECommOrd.CustomerNumber = tECommQuote.CustomerNumber AND tECommOrd.SalesLocationCode = tECommQuote.SalesLocationCode FULL OUTER JOIN ' + 
								@tblManualQuote + ' tManualQuote ' +
					'ON			tECommQuote.CustomerNumber = tManualQuote.CustomerNumber AND tECommQuote.SalesLocationCode = tManualQuote.SalesLocationCode FULL OUTER JOIN ' +
								@tblManualOrder + ' tManualOrd ' +
					'ON			tManualQuote.CustomerNumber = tManualOrd.CustomerNumber AND tManualQuote.SalesLocationCode = tManualOrd.SalesLocationCode FULL OUTER JOIN ' +
								@tblMissedECommQuote + ' tMissedEcomm ' +
					'ON			tManualOrd.CustomerNumber = tMissedEcomm.CustomerNumber AND tManualOrd.SalesLocationCode = tMissedEcomm.SalesLocationCode FULL OUTER JOIN ' +
								@tblMissedManualQuote + ' tMissedManual ' +
					'ON			tMissedEcomm.CustomerNumber = tMissedManual.CustomerNumber AND tMissedEcomm.SalesLocationCode = tMissedManual.SalesLocationCode '

	Print '--	**DISTINCT CustomerNumber/SalesLocation list'
	Print '			--SELECT * FROM ' + @tblCustMaster
	Print '			--DROP TABLE ' + @tblCustMaster
	Print '		' + @strSQL 
	EXEC sp_executesql @strSQL

	--Compile all recordsets by CustomerNumber/SalesLocation
	SELECT  @tblResult = '##tResult'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
	SET	@strSQL =	'SELECT		isnull(tCust.CustomerNumber, ''No Cust'') as CustomerNumber, ' + 
					'			isnull(tCust.SalesLocationCode, ''No Loc'') as SalesLocationCode, ' +
					' 			ISNULL(tECommQuote.NoOfECommQuotes,0) as NoOfECommQuotes, ' +
					' 			ISNULL(cast((round(tECommQuote.eCommExtAmount,2)) as Decimal(25,2)),0) as eCommExtAmount, ' +
					' 			ISNULL(cast((round(tECommQuote.eCommExtWeight,1)) as Decimal(25,1)),0) as eCommExtWeight, ' +
					' 			ISNULL(tECommOrd.NoOfECommOrders,0) as NoOfECommOrders, ' +
					' 			ISNULL(cast((round(tECommOrd.eCommExtOrdAmount,2)) as Decimal(25,2)),0) as eCommExtOrdAmount, ' +
					' 			ISNULL(cast((round(tECommOrd.eCommExtOrdWeight,1)) as Decimal(25,1)),0) as eCommExtOrdWeight, ' +
					' 			ISNULL(tManualQuote.NoOfManualQuotes,0) as NoOfManualQuotes, ' +
					' 			ISNULL(cast((round(tManualQuote.ManualExtAmount,2)) as Decimal(25,2)),0) as ManualExtAmount, ' +
					' 			ISNULL(cast((round(tManualQuote.ManualExtWeight,1)) as Decimal(25,1)),0) as ManualExtWeight, ' +
					' 			ISNULL(tManualOrd.NoOfManualOrders,0) as NoOfManualOrders, ' +
					' 			ISNULL(cast((round(tManualOrd.ManualExtOrdAmount,2)) as Decimal(25,2)),0) as ManualExtOrdAmount, ' +
					' 			ISNULL(cast((round(tManualOrd.ManualExtOrdWeight,1)) as Decimal(25,1)),0) as ManualExtOrdWeight, ' +
					' 			ISNULL(tMissedEcomm.NoOfECommQuotes,0) as NoOfMissedECommQuotes, ' +
					' 			ISNULL(cast((round(tMissedEcomm.eCommExtAmount,2)) as Decimal(25,2)),0) as MissedECommExtAmount, ' +
					' 			ISNULL(cast((round(tMissedEcomm.eCommExtWeight,1)) as Decimal(25,1)),0) as MissedECommExtWeight, ' +
					' 			ISNULL(tMissedManual.NoOfManualQuotes,0) as NoOfMissedManualQuotes, ' +
					' 			ISNULL(cast((round(tMissedManual.ManualExtAmount,2)) as Decimal(25,2)),0) as MissedManualExtAmount, ' +
					' 			ISNULL(cast((round(tMissedManual.ManualExtWeight,1)) as Decimal(25,1)),0) as MissedManualExtWeight ' +
					'INTO	' + @tblResult + ' ' +
					'FROM	' + @tblCustMaster + ' tCust LEFT OUTER JOIN ' + 
								@tblECommOrder + ' tECommOrd ' +
					'ON			tCust.CustomerNumber = tECommOrd.CustomerNumber AND tCust.SalesLocationCode = tECommOrd.SalesLocationCode LEFT OUTER JOIN ' + 
								@tblECommQuote + ' tECommQuote ' +
					'ON			tCust.CustomerNumber = tECommQuote.CustomerNumber AND tCust.SalesLocationCode = tECommQuote.SalesLocationCode LEFT OUTER JOIN ' +
								@tblManualQuote + ' tManualQuote ' +
					'ON			tCust.CustomerNumber = tManualQuote.CustomerNumber AND tCust.SalesLocationCode = tManualQuote.SalesLocationCode LEFT OUTER JOIN ' +
								@tblManualOrder + ' tManualOrd ' +
					'ON			tCust.CustomerNumber = tManualOrd.CustomerNumber AND tCust.SalesLocationCode = tManualOrd.SalesLocationCode LEFT OUTER JOIN ' +
								@tblMissedECommQuote + ' tMissedEcomm ' +
					'ON			tCust.CustomerNumber = tMissedEcomm.CustomerNumber AND tCust.SalesLocationCode = tMissedEcomm.SalesLocationCode LEFT OUTER JOIN ' +
								@tblMissedManualQuote + ' tMissedManual ' +
					'ON			tCust.CustomerNumber = tMissedManual.CustomerNumber AND tCust.SalesLocationCode = tMissedManual.SalesLocationCode '

	Print ''
	print '--	**Compile all recordsets by CustomerNumber/SalesLocation'
	Print '			--SELECT * FROM ' + @tblResult
	Print '			--DROP TABLE ' + @tblResult
	print '		' + @strSQL
	Execute sp_executesql @strSQL

	--Return the data
    EXEC('select * from ' + @tblResult + '')

	Print '-- END: Compile & return the complete dataset'
	-----------------------------------------------------
	--  END: Compile & return the complete dataset   --
	-----------------------------------------------------

	EXEC('drop table ' + @tblECommQuote + '')
	EXEC('drop table ' + @tblECommOrder + '')
	EXEC('drop table ' + @tblManualQuote + '')
	EXEC('drop table ' + @tblManualOrder + '')
	EXEC('drop table ' + @tblMissedECommQuote + '')
	EXEC('drop table ' + @tblMissedManualQuote + '')
	EXEC('drop table ' + @tblCustMaster + '')
	EXEC('drop table ' + @tblResult + '')
END

-- ------------------------------------------------------------------------------------------------
-- Exec [pQuoteAndOrderV2] '08','2011','','','15','','false','','false'
-- Exec [pQuoteAndOrderV2] '12','2010','','','','','false','','false'
-- -----------------------------------------------------------------------------------------------

