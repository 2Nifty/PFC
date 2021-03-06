drop proc [pQuoteAnalysisV2]
go

/****** Object:  StoredProcedure [dbo].[pQuoteAnalysisV2]    Script Date: 09/19/2011 16:23:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pQuoteAnalysisV2]
		@PeriodMonth varchar(10),
		@PeriodYear varchar(10),
		@StartDate varchar(32),
		@EndDate varchar(32),
		@LocationCode varchar(10),
		@CustNo nvarchar(10),
		@OrderSource varchar(10),
		@SourceType	varchar(20),	--ECOMM or MANUAL or MISSED_ECOMM or MISSED_MANUAL
		@ItemNotOrdFlg varchar(5),	--TRUE or FALSE
		@RecType varchar(5)			--HDR or DTL
AS

DECLARE	@strWhere nvarchar(4000),
		@strSql nvarchar(4000),
		@TableName varchar(40)

BEGIN
	SET NOCOUNT ON;

	-----------------------------------------
	--  BEGIN: Bind the  WHERE clause(s)   --
	-----------------------------------------
	Set @strWhere = '1=1'

	--By Period
	if @PeriodYear <> ''
        begin 
             Set @strWhere = @strWhere + ' AND (Year(Quote.QuotationDate) = ' + @PeriodYear + ''
        end
     	if @PeriodMonth <> ''
        begin 
             Set @strWhere = @strWhere + ' AND Month(Quote.QuotationDate) = ' + @PeriodMonth +')'
        end

	--By Date Range
	if @StartDate <> '' and @EndDate <> '' 
        begin 
             Set @strWhere = @strWhere + ' AND (Cast(CONVERT(nvarchar(20), Quote.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end

	--Specific Branch
	if @LocationCode <> ''
        begin 
             Set @strWhere = @strWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end

	--Specific Customer
	if @CustNo <> ''
        begin 
             Set @strWhere = @strWhere + ' AND Quote.CustomerNumber like ''%' + @CustNo +'%'''
        end

	--OrderSource filter
	if @OrderSource <> '' and UPPER(@OrderSource) <> 'ALL'
        begin 
			if UPPER(@OrderSource) = 'ALLCSR'
			   begin
					Set @strWhere = @strWhere + ' AND Src.Sequence <> 1'
			   end
			else
			   begin
					if UPPER(@OrderSource) = 'ALLEC'
					   begin
							Set @strWhere = @strWhere + ' AND Src.Sequence = 1'
					   end
					else
					   begin
							Set @strWhere = @strWhere + ' AND isnull(Quote.OrderSource,''RQ'') like ''%' + @OrderSource +'%'''
					   end
			   end
        end

	if @SourceType = 'ECOMM'
	   begin
			Set @strWhere = @strWhere + ' AND Src.Sequence = 1'
	   end

	if @SourceType = 'MANUAL'
	   begin
			Set @strWhere = @strWhere + ' AND Src.Sequence <> 1'
	   end

	if @SourceType = 'MISSED_ECOMM'
	   begin
			Set @strWhere = @strWhere + ' AND isnull(Quote.OrderSource,''RQ'') = ''WQ'''
	   end

	if @SourceType = 'MISSED_MANUAL'
	   begin
			Set @strWhere = @strWhere + ' AND isnull(Quote.OrderSource,''RQ'') = ''RQ'''
	   end

	--Items Not Ordered filter
	if UPPER(@ItemNotOrdFlg) = 'TRUE'
	   begin
			Set @strWhere = @strWhere + ' AND Quote.OrderCompletionStatus <> 1'
	   end
	---------------------------------------
	--  END: Bind the  WHERE clause(s)   --
	---------------------------------------

	if UPPER(@RecType) =	'HDR'
	   begin				--[HDR] Build the SELECT statement for the header summary
			set @strSql =	'SELECT	Quote.CustomerNumber, ' +
							'		Quote.SessionID as QuoteNumber, ' +
							'		CONVERT(nvarchar(20), MAX(Quote.QuotationDate), 101) as QuotationDate, ' +
							'		MAX(Quote.ExpiryDate) as ExpiryDate, ' +
							'		(CASE right(userid,2) WHEN ''-U'' ' +
							'							  THEN ''Web Order'' ' +
							'							  ELSE (CASE left(userid,3) WHEN ''esv'' ' +
							'														THEN ''SDK'' ' +
							'														ELSE (CASE isnumeric(userid) WHEN 1 THEN ''Direct Connect'' END) ' +
							'									END) ' +
							'		 END) as QuoteMethod, ' +
							'		CM.CustShipLocation as SalesBranchofRecord, ' +
							'		count(Quote.PFCItemNo) as LineCount, ' +
							'		sum(isnull(cast((round(Quote.RequestQuantity,0)) as Decimal(25,0)),0)) as RequestQuantity, ' +
							'		sum(Quote.UnitPrice * Quote.RequestQuantity) as ExtPrice, ' +
							'		sum(Quote.GrossWeight * Quote.RequestQuantity) as ExtWeight ' +
							'FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
							'		OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
							'ON		CM.CustNo = Quote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
							'		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.SequenceNo,0) as Sequence ' +
							'		 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
							'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
							'		 ON		LM.pListMasterID = LD.fListMasterID ' +
							'		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'		 ON	isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
							'WHERE	DeleteFlag = 0 and ' + @strWhere + ' ' +
							'GROUP BY Quote.CustomerNumber, Quote.SessionID, Quote.UserID, CM.CustShipLocation ' +
							'ORDER BY Quote.CustomerNumber, Quote.UserID, Quote.SessionID'
	   end
	else
	   begin				--[DTL] Build the SELECT statement for the line item detail
			set @strSql =	'SELECT	Quote.CustomerNumber, ' +
							'		Quote.CustomerName, ' +
							'		(CASE right(userid,2) WHEN ''-U'' ' +
							'							  THEN ''Web Order'' ' +
							'							  ELSE (CASE left(userid,3) WHEN ''esv'' ' +
							'														THEN ''SDK'' ' +
							'														ELSE (CASE isnumeric(userid) WHEN 1 THEN ''Direct Connect'' END) ' +
							'									END) ' +
							'		 END) as QuoteMethod, ' +
							'		CONVERT(nvarchar(20), Quote.QuotationDate, 101) as QuotationDate, ' +
							'		Quote.ExpiryDate, ' +
							'		Quote.UserItemNo, ' +
							'		Quote.PFCItemNo, ' +
							'		Quote.Description, ' +
							'		CM.CustShipLocation as SalesBranchofRecord, ' +
							'		isnull(cast((round(Quote.RequestQuantity,0)) as Decimal(25,0)),0) as RequestQuantity, ' +
							'		isnull(cast((round(Quote.AvailableQuantity,0)) as Decimal(25,0)),0) as RunningAvalQty, ' +
							'		isnull(cast((round(Quote.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice, ' +
							'		0 as Margin, ' +
							'		Quote.PriceUOM, ' +
							'		isnull(cast((round(Quote.UnitPrice * Quote.RequestQuantity,2)) as Decimal(25,2)),0) as TotalPrice, ' +
							'		isnull(cast((round(Quote.GrossWeight * Quote.RequestQuantity,1)) as Decimal(25,1)),0) as GrossWeight, ' +
							'		isnull(ECommUserName,''NA'') as ECommUserName, ' +
							'		isnull(ECommIPAddress,''NA'') as ECommIPAddress,  ' +
							'		isnull(ECommPhoneNo,''NA'') as ECommPhoneNo, ' +
							'		isnull(OrderSource,''NA'') as OrderSource ' +
							'FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN ' +
							'		OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
							'On		CM.CustNo = Quote.customerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN ' +
							'		(SELECT	LD.ListValue as OrdSrc, ' +
							'				isnull(LD.SequenceNo,0) as Sequence ' +
							'		 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN ' +
							'				OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ' +
							'		 ON		LM.pListMasterID = LD.fListMasterID ' +
							'		 WHERE	LM.ListName = ''SOEOrderSource'') Src ' +
							'		 ON	isnull(Quote.OrderSource,''RQ'') = Src.OrdSrc ' +
							'WHERE	DeleteFlag = 0 and ' + @strWhere + ' ' +
							'ORDER BY Quote.CustomerNumber, Quote.UserID '
	   end

	Print ''
	Print '-- **Quotes [' + @RecType + ']'
	Print @strSQL
	EXEC sp_executesql @strSQL
END

-- Exec [pQuoteAnalysisV2] '08','2011','','','15','003081','','','FALSE','HDR'
-- Exec [pQuoteAnalysisV2] '08','2011','','','15','003081','','','FALSE','DTL'
