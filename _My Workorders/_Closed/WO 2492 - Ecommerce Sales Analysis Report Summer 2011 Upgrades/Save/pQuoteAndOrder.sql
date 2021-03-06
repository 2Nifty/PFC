--USE [PFCQuotesDB]
--GO


drop proc [pQuoteAndOrder]
go


/****** Object:  StoredProcedure [dbo].[pQuoteAndOrder]    Script Date: 09/08/2011 12:54:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pQuoteAndOrder]
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

DECLARE	@CustWhere nvarchar(2000),
		@QuoteWhere nvarchar(2000),
		@OrderWhere nvarchar(2000),
		@QuoteSrcWhere nvarchar(2000),
		@OrderSrcWhere nvarchar(2000),
		@strSQL nvarchar(4000),
		@strTempMonth varchar(50),
		@TableName varchar(40),
		@TempTable varchar(50),
		@tblCustMaster varchar(200),
		@tblECommQuote varchar(200),
		@tblECommOrder varchar(200),
		@tblManualQuote varchar(200),
		@tblManualOrder varchar(200),
		@tblMissedECommQuote varchar(200),
		@tblMissedManualQuote varchar(200),
		@tblResult nvarchar(200)

BEGIN
	SET NOCOUNT ON;

	-----------------------------------------
	--  BEGIN: Bind the  WHERE clause(s)   --
	-----------------------------------------
	SET @CustWhere = '1=1'
	SET @QuoteWhere = '1=1'
	SET @OrderWhere = '1=1'
	SET @QuoteSrcWhere = '1=1'
	SET @OrderSrcWhere = '1=1'

	--By Period
	if @PeriodYear <> ''
        begin 
            Set @CustWhere = @CustWhere + ' AND (Year(CustQuote.QuotationDate) = ' + @PeriodYear + ''
            Set @QuoteWhere = @QuoteWhere + ' AND (Year(CustQuote.QuotationDate) = ' + @PeriodYear + ''
			Set @OrderWhere = @OrderWhere + ' AND (Year(PendOrdHdr.PurchaseOrderDate) = ' + @PeriodYear + ''
        end
    if @PeriodMonth <> ''
        begin 
            Set @CustWhere = @CustWhere + ' AND Month(CustQuote.QuotationDate) = ' + @PeriodMonth +')'
            Set @QuoteWhere = @QuoteWhere + ' AND Month(CustQuote.QuotationDate) = ' + @PeriodMonth +')'
			Set @OrderWhere = @OrderWhere + ' AND Month(PendOrdHdr.PurchaseOrderDate) = ' + @PeriodMonth +')'
        end

	--By Date Range
	if @StartDate <> '' and @EndDate <> '' 
        begin 
            Set @CustWhere = @CustWhere + ' AND (Cast(CONVERT(nvarchar(20), CustQuote.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
            Set @QuoteWhere = @QuoteWhere + ' AND (Cast(CONVERT(nvarchar(20), CustQuote.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
			Set @OrderWhere = @OrderWhere + ' AND (Cast(CONVERT(nvarchar(20), PendOrdHdr.PurchaseOrderDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end

	--Specific Branch
	if @LocationCode <> ''
        begin 
			Set @CustWhere = @CustWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
			Set @QuoteWhere = @QuoteWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
			Set @OrderWhere = @OrderWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end

	--Specific Customer
	if @CustNo <> ''
        begin 
            Set @CustWhere = @CustWhere + ' AND CustQuote.CustomerNumber like ''%' + @CustNo +'%'''
            Set @QuoteWhere = @QuoteWhere + ' AND CustQuote.CustomerNumber like ''%' + @CustNo +'%'''
			Set @OrderWhere = @OrderWhere + ' AND CustQuote.CustomerNumber like ''%' + @CustNo +'%'''
        end

	--PriceCd = 'X' filter
	if UPPER(@PriceCdCtl) = 'FALSE'
        begin 
            Set @CustWhere = @CustWhere + ' AND CM.PriceCd <> ''X'''
            Set @QuoteWhere = @QuoteWhere + ' AND CM.PriceCd <> ''X'''
			Set @OrderWhere = @OrderWhere + ' AND CM.PriceCd <> ''X'''
        end

	--OrderSource filter
	if @OrderSource <> '' and UPPER(@OrderSource) <> 'ALL'
        begin 
			if UPPER(@OrderSource) = 'ALLCSR'
			   begin
					Set @QuoteSrcWhere = @QuoteSrcWhere + ' AND Src.Sequence <> 1'
					Set @OrderSrcWhere = @OrderSrcWhere + ' AND Src.Sequence <> 1'
			   end
			else
			   begin
					if UPPER(@OrderSource) = 'ALLEC'
					   begin
							Set @QuoteSrcWhere = @QuoteSrcWhere + ' AND Src.Sequence = 1'
							Set @OrderSrcWhere = @OrderSrcWhere + ' AND Src.Sequence = 1'
					   end
					else
					   begin
							Set @QuoteSrcWhere = @QuoteSrcWhere + ' AND CustQuote.OrderSource like ''%' + @OrderSource +'%'''
							Set @OrderSrcWhere = @OrderSrcWhere + ' AND PendOrdHdr.OrderSource like ''%' + @OrderSource +'%'''
					   end
			   end
        end

	--Items Not Ordered filter
	if UPPER(@ItemNotOrdFlg) = 'TRUE'
	   begin
			Set @QuoteWhere = @QuoteWhere + ' AND CustQuote.OrderCompletionStatus <> 1'
			Set @OrderWhere = @OrderWhere + ' AND CustQuote.OrderCompletionStatus <> 1'
	   end

	Print '-- QuoteWhere: ' + @QuoteWhere + ' AND ' + @QuoteSrcWhere
	Print '-- OrderWhere: ' + @OrderWhere + ' AND ' + @OrderSrcWhere
	---------------------------------------
	--  END: Bind the  WHERE clause(s)   --
	---------------------------------------

	--Get CustomerMaster Information for given period
	SELECT	@tblCustMaster	= '##tCustMaster_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8)
	SET		@strSQL =	'SELECT	CustQuote.CustomerNumber, CM.CustShipLocation as SalesLocationCode ' +
						'INTO	' + @tblCustMaster + ' ' +
						'FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN ' +
						'		OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS ' +
						'WHERE	CustQuote.DeleteFlag = 0 and ' + @CustWhere + ' ' +
						'GROUP BY CustQuote.CustomerNumber, CM.CustShipLocation' 	

	Print ''
	Print '-- **CustomerMaster'
	Print '--SELECT * FROM ' + @tblCustMaster
	Print '--DROP TABLE ' + @tblCustMaster
	Print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblCustMaster + '')

	------------------------------------------------
	--  BEGIN: Get eCommerce Quote & Order Data   --
	------------------------------------------------
	--eCommerce Quotes
    SELECT  @tblECommQuote	= '##tECommQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ECommQuote.CustomerNumber, ' +
						'		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes, ' +
						'		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount, ' +
						'		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight ' +
						'INTO	' + @tblECommQuote + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				CustQuote.SessionID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfECommQuotes, ' +
						'				sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as eCommExtAmount, ' +
						'				sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtWeight ' +
--						'		 INTO	' + @tblECommQuote + ' ' +
						'		 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE		CustQuote.DeleteFlag = 0 and Src.Sequence = 1 and ' + @QuoteWhere + ' AND ' + @QuoteSrcWhere + ' ' +
						'		 GROUP BY	CustQuote.CustomerNumber, CustQuote.SessionID) ECommQuote ' +
						'GROUP BY  ECommQuote.CustomerNumber'

	Print ''
	Print '-- **eCommerce Quotes'
	Print '--SELECT * FROM ' + @tblECommQuote
	Print '--DROP TABLE ' + @tblECommQuote
	Print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblECommQuote + '')

	--eCommerce Orders
    SELECT  @tblECommOrder	= '##tECommOrder_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ECommOrder.CustomerNumber, ' +
						'		count(ECommOrder.NoOfECommOrders) as NoOfECommOrders, ' +
						'		sum(isnull(ECommOrder.eCommExtOrdWeight,0)) as eCommExtOrdWeight, ' +
						'		sum(isnull(ECommOrder.eCommExtOrdAmount,0)) as eCommExtOrdAmount ' +
						'INTO	' + @tblECommOrder + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				PendOrdHdr.ID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfECommOrders, ' +
						'				Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtOrdWeight, ' +
						'				Sum(PendOrdDtl.TotalPrice) as eCommExtOrdAmount ' +
--						'		 INTO	' + @tblECommOrder + ' ' +
						'		 FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN ' +
						'				DTQ_CustomerQuotation CustQuote (NOLOCK) ' +
						'		 ON		PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN ' +
						'				DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) ' +
						'		 ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus =''true'' inner join ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON	CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE	Src.Sequence = 1 and ' + @OrderWhere + ' AND ' + @OrderSrcWhere + ' ' +
						'		 GROUP BY CustQuote.CustomerNumber, PendOrdHdr.ID) ECommOrder ' +
						'GROUP BY  ECommOrder.CustomerNumber'

	Print ''
	print '-- **eCommerce Orders'
	Print '--SELECT * FROM ' + @tblECommOrder
	Print '--DROP TABLE ' + @tblECommOrder
	print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblECommOrder + '')
	----------------------------------------------
	--  END: Get eCommerce Quote & Order Data   --
	----------------------------------------------

	---------------------------------------------
	--  BEGIN: Get Manual Quote & Order Data   --
	---------------------------------------------
	--Manual Quotes
    SELECT  @tblManualQuote	= '##tManualQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualQuote.CustomerNumber, ' +
						'		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes, ' +
						'		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount, ' +
						'		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight ' +
						'INTO	' + @tblManualQuote + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				CustQuote.SessionID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfManualQuotes, ' +
						'				sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount, ' +
						'				sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight ' +
--						'		 INTO	' + @tblManualQuote + ' ' +
						'		 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE	CustQuote.DeleteFlag = 0 and Src.Sequence <> 1 and ' + @QuoteWhere + ' AND ' + @QuoteSrcWhere + ' ' +
						'		 GROUP BY CustQuote.CustomerNumber, CustQuote.SessionID) ManualQuote ' +
						'GROUP BY ManualQuote.CustomerNumber'

	Print ''
	Print '-- **Manual Quotes'
	Print '--SELECT * FROM ' + @tblManualQuote
	Print '--DROP TABLE ' + @tblManualQuote
	Print @strSQL 
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblManualQuote + '')

	--Manual Orders
    SELECT  @tblManualOrder	= '##tManualOrder_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualOrder.CustomerNumber, ' +
						'		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders, ' +
						'		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight, ' +
						'		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount ' +
						'INTO	' + @tblManualOrder + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				PendOrdHdr.ID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfManualOrders, ' +
						'				Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtOrdWeight, ' +
						'				Sum(PendOrdDtl.TotalPrice) as ManualExtOrdAmount ' +
--						'		 INTO	' + @tblManualOrder + ' ' +
						'		 FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN ' +
						'				DTQ_CustomerQuotation CustQuote (NOLOCK) ' +
						'		 ON		PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN ' +
						'				DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) ' +
						'		 ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus =''true'' inner join ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE	Src.Sequence <> 1 and ' + @OrderWhere + ' AND ' + @OrderSrcWhere + ' ' +
						'		 GROUP BY CustQuote.CustomerNumber, PendOrdHdr.ID) ManualOrder ' +
						'GROUP BY ManualOrder.CustomerNumber'

	Print ''
	print '-- **Manual Orders'
	Print '--SELECT * FROM ' + @tblManualOrder
	Print '--DROP TABLE ' + @tblManualOrder
	print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblManualOrder + '')
	-------------------------------------------
	--  END: Get Manual Quote & Order Data   --
	-------------------------------------------

	-----------------------------------------------
	--  BEGIN: Get Missed eCommerce Quote Data   --
	-----------------------------------------------
	--Missed eCommerce Quotes
    SELECT  @tblMissedECommQuote = '##tMissedECommQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ECommQuote.CustomerNumber, ' +
						'		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes, ' +
						'		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount, ' +
						'		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight ' +
						'INTO	' + @tblMissedECommQuote + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				CustQuote.SessionID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfECommQuotes, ' +
						'				sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as eCommExtAmount, ' +
						'				sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtWeight ' +
--						'		 INTO	' + @tblMissedECommQuote + ' ' +
						'		 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE	CustQuote.DeleteFlag = 0 and Src.OrdSrc = ''WQ'' and CustQuote.OrderCompletionStatus <> 1 and ' + @QuoteWhere + ' ' +
						'		 GROUP BY CustQuote.CustomerNumber, CustQuote.SessionID) ECommQuote ' +
						'GROUP BY ECommQuote.CustomerNumber'

	Print ''
	Print '-- **Missed eCommerce Quotes'
	Print '--SELECT * FROM ' + @tblMissedECommQuote
	Print '--DROP TABLE ' + @tblMissedECommQuote
	Print @strSQL
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblMissedECommQuote + '')
	---------------------------------------------
	--  END: Get Missed eCommerce Quote Data   --
	---------------------------------------------

	--------------------------------------------
	--  BEGIN: Get Missed Manual Quote Data   --
	--------------------------------------------
	--Missed Manual Quotes
    SELECT  @tblMissedManualQuote = '##tMissedManualQuote_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SET		@strSQL =	'SELECT	ManualQuote.CustomerNumber, ' +
						'		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes, ' +
						'		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount, ' +
						'		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight ' +
						'INTO	' + @tblMissedManualQuote + ' ' +
						'FROM	(SELECT	CustQuote.CustomerNumber, ' +
						'				CustQuote.SessionID, ' +
						'				count(CustQuote.QuoteNumber) as NoOfManualQuotes, ' +
						'				sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount, ' +
						'				sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight ' +
--						'		 INTO	' + @tblMissedManualQuote + ' ' +
						'		 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN ' +
						'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
						'		 ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
						'				(SELECT	LD.ListValue as OrdSrc, ' +
						'						isnull(LD.SequenceNo,0) as Sequence ' +
						'				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
						'						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
						'				 ON		LM.pListMasterID = LD.fListMasterID ' +
						'				 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
						'		 ON		CustQuote.OrderSource = Src.OrdSrc ' +
						'		 WHERE	CustQuote.DeleteFlag = 0 and Src.OrdSrc = ''RQ'' and CustQuote.OrderCompletionStatus <> 1 and ' + @QuoteWhere + ' ' +
						'		 GROUP BY CustQuote.CustomerNumber, CustQuote.SessionID) ManualQuote ' +
						'GROUP BY ManualQuote.CustomerNumber'

	Print ''
	Print '-- **Missed Manual Quotes'
	Print '--SELECT * FROM ' + @tblMissedManualQuote
	Print '--DROP TABLE ' + @tblMissedManualQuote
	Print @strSQL 
	EXEC sp_executesql @strSQL

--exec('select * from ' + @tblMissedManualQuote + '')
	------------------------------------------
	--  END: Get Missed Manual Quote Data   --
	------------------------------------------


	--Compile & return the complete dataset for the specific SummaryLevel
	SELECT  @tblResult		= '##tResult'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
	--Summarize by Order/Quote Number 
	SET	@strSQL =	'SELECT	' + @tblCustMaster + '.CustomerNumber, ' + 
								@tblCustMaster + '.SalesLocationCode, ' +
					'			ISNULL(' + @tblECommQuote + '.NoOfECommQuotes,0) as NoOfECommQuotes, ' +
					'			ISNULL(cast((round(' + @tblECommQuote + '.eCommExtAmount,2)) as Decimal(25,2)),0) as eCommExtAmount, ' +
					'			ISNULL(cast((round(' + @tblECommQuote + '.eCommExtWeight,1)) as Decimal(25,1)),0) as eCommExtWeight, ' +
					'			ISNULL(' + @tblECommOrder + '.NoOfECommOrders,0) as NoOfECommOrders, ' +
					'			ISNULL(cast((round(' + @tblECommOrder + '.eCommExtOrdAmount,2)) as Decimal(25,2)),0) as eCommExtOrdAmount, ' +
					'			ISNULL(cast((round(' + @tblECommOrder + '.eCommExtOrdWeight,1)) as Decimal(25,1)),0) as eCommExtOrdWeight, ' +
					'			ISNULL(' + @tblManualQuote + '.NoOfManualQuotes,0) as NoOfManualQuotes, ' +
					'			ISNULL(cast((round(' + @tblManualQuote + '.ManualExtAmount,2)) as Decimal(25,2)),0) as ManualExtAmount, ' +
					'			ISNULL(cast((round(' + @tblManualQuote + '.ManualExtWeight,1)) as Decimal(25,1)),0) as ManualExtWeight, ' +
					'			ISNULL(' + @tblManualOrder + '.NoOfManualOrders,0) as NoOfManualOrders, ' +
					'			ISNULL(cast((round(' + @tblManualOrder + '.ManualExtOrdAmount,2)) as Decimal(25,2)),0) as ManualExtOrdAmount, ' +
					'			ISNULL(cast((round(' + @tblManualOrder + '.ManualExtOrdWeight,1)) as Decimal(25,1)),0) as ManualExtOrdWeight, ' +
					'			ISNULL(' + @tblMissedECommQuote + '.NoOfECommQuotes,0) as NoOfMissedECommQuotes, ' +
					'			ISNULL(cast((round(' + @tblMissedECommQuote + '.eCommExtAmount,2)) as Decimal(25,2)),0) as MissedECommExtAmount, ' +
					'			ISNULL(cast((round(' + @tblMissedECommQuote + '.eCommExtWeight,1)) as Decimal(25,1)),0) as MissedECommExtWeight, ' +
					'			ISNULL(' + @tblMissedManualQuote + '.NoOfManualQuotes,0) as NoOfMissedManualQuotes, ' +
					'			ISNULL(cast((round(' + @tblMissedManualQuote + '.ManualExtAmount,2)) as Decimal(25,2)),0) as MissedManualExtAmount, ' +
					'			ISNULL(cast((round(' + @tblMissedManualQuote + '.ManualExtWeight,1)) as Decimal(25,1)),0) as MissedManualExtWeight ' +
					'INTO	' + @tblResult + ' ' +
					'FROM	' + @tblCustMaster + ' LEFT OUTER JOIN ' + 
								@tblECommOrder + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblECommOrder  + '.CustomerNumber LEFT OUTER JOIN ' + 
								@tblECommQuote + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblECommQuote + '.CustomerNumber LEFT OUTER JOIN ' +
								@tblManualQuote + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblManualQuote + '.CustomerNumber LEFT OUTER JOIN ' +
								@tblManualOrder + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblManualOrder + '.CustomerNumber LEFT OUTER JOIN ' +
								@tblMissedECommQuote + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblMissedECommQuote + '.CustomerNumber LEFT OUTER JOIN ' +
								@tblMissedManualQuote + ' ' +
					'ON		' + @tblCustMaster + '.CustomerNumber = ' + @tblMissedManualQuote + '.CustomerNumber'

	Print ''
	print '-- **Compile & return the complete dataset'
	Print '--SELECT * FROM ' + @tblResult
	Print '--DROP TABLE ' + @tblResult
	print @strSQL
	Execute sp_executesql @strSQL

	--Return the data
    EXEC('select * from ' + @tblResult + '')

	EXEC('drop table ' + @tblCustMaster + '')
	EXEC('drop table ' + @tblECommQuote + '')
	EXEC('drop table ' + @tblECommOrder + '')
	EXEC('drop table ' + @tblManualQuote + '')
	EXEC('drop table ' + @tblManualOrder + '')
	EXEC('drop table ' + @tblResult + '')
	
END

-- ------------------------------------------------------------------------------------------------
-- Exec [pQuoteAndOrder] '12','2009','','','15','','false','','false'
-- Exec [pQuoteAndOrder] '12','2009','','','15','','false','','false'
-- -----------------------------------------------------------------------------------------------
