drop proc [pOrderAnalysisV2]
go

/****** Object:  StoredProcedure [dbo].[pOrderAnalysisV2]    Script Date: 09/19/2011 16:23:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[pOrderAnalysisV2]
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
             Set @strWhere = @strWhere + ' AND (Year(PendOrdHdr.PurchaseOrderDate) = ' + @PeriodYear + ''
        end
     	if @PeriodMonth <> ''
        begin 
             Set @strWhere = @strWhere + ' AND Month(PendOrdHdr.PurchaseOrderDate) = ' + @PeriodMonth +')'
        end

	--By Date Range
	if @StartDate <> '' and @EndDate <> '' 
        begin 
             Set @strWhere = @strWhere + ' AND (Cast(CONVERT(nvarchar(20), PendOrdHdr.PurchaseOrderDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end

	--Specific Branch
	if @LocationCode <> ''
        begin 
             Set @strWhere = @strWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end

	--Specific Customer
	if @CustNo <> ''
        begin 
             Set @strWhere = @strWhere + ' AND PendOrdHdr.CustomerNumber like ''%' + @CustNo +'%'''
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
select * from CustomerMaster
	   end
	else
	   begin				--[DTL] Build the SELECT statement for the line item detail
			set @strSql =	'SELECT	Quote.CustomerNumber, ' +
							'		Quote.CustomerName, ' +
							'		PendOrdHdr.PurchaseOrderNo, ' +
							'		(case right( Quote.userid,2) when ''-U'' then ''Web Order'' else (case left( Quote.userid,3) when ''int'' then ''SDK'' when ''esv'' then ''SDK'' else(case isnumeric( Quote.userid) when 1 then ''Direct Connect'' end) end) end) as OrderMethod, ' +
							'		PendOrdHdr.PurchaseOrderDate, ' +
							'		PendOrdDtl.UserItemNo, ' +
							'		PendOrdDtl.PFCItemNo, ' +
							'		ReqQty.LocationCode, ' +
							'		Quote.Description, ' +
							'		CM.CustShipLocation as SalesLocationCode, ' +
							'		isnull(cast((round( ReqQty.RequestedQuantity,0)) as Decimal(25,0)),0) as RequestQuantity, ' +
							'		isnull(cast((round( Quote.AvailableQuantity,0)) as Decimal(25,0)),0) as AvailableQuantity, ' +
							'		isnull(cast((round( PendOrdDtl.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice, ' +
							'		0 as Margin, ' +
							'		PendOrdDtl.PriceUOM, ' +
							'		isnull(cast((round( PendOrdDtl.TotalPrice,2)) as Decimal(25,2)),0) as TotalPrice, ' +
							'		isnull(cast((round( PendOrdDtl.Weight,1)) as Decimal(25,1)),0) as Weight, ' +
							'		isnull(PendOrdHdr.ECommUserName,''NA'') as ECommUserName, ' +
							'		isnull(PendOrdHdr.ECommIPAddress,''NA'') as ECommIPAddress, ' +
							'		isnull(PendOrdHdr.ECommPhoneNo,''NA'') as ECommPhoneNo, ' +
							'		isnull(PendOrdHdr.OrderSource,''NA'') as OrderSource ' +
							'FROM	DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) INNER JOIN ' +
							'		DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) ' +
							'ON		PendOrdHdr.ID = PendOrdDtl.PurchaseOrderID AND PendOrdHdr.OrderCompletedStatus =''true'' INNER JOIN ' +
							'		DTQ_RequestedQuantity ReqQty (NOLOCK) ' +
							'ON		PendOrdDtl.ID = ReqQty.PendingOrderID INNER JOIN ' +
							'		DTQ_CustomerQuotation Quote (NOLOCK) ' +
							'ON		PendOrdDtl.QuotationItemDetailID = Quote.QuoteNumber AND ReqQty.QuoteNumber = Quote.QuoteNumber INNER JOIN ' +
							'		OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM ' +
							'ON		CM.CustNo = Quote.CustomerNumber COLLATE Latin1_General_CS_AS ' +
							'WHERE	' + @strWhere
	   end

	Print ''
	Print '-- **Orders [' + @RecType + ']'
	Print @strSQL
	EXEC sp_executesql @strSQL
END

-- Exec [pOrderAnalysisV2] '08','2011','','','15','003081','','','FALSE','HDR'
-- Exec [pOrderAnalysisV2] '08','2011','','','15','','','','FALSE','DTL'
