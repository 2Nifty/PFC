
drop proc [pQuoteAndOrder]
go


/****** Object:  StoredProcedure [dbo].[pQuoteAndOrder]    Script Date: 09/15/2011 12:18:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[pQuoteAndOrder]
	@PeriodMonth varchar(10),
	@PeriodYear varchar(10),
	@StartDate varchar(32),
	@EndDate varchar(32),
	@LocationCode nvarchar(10),
	@CustNo nvarchar(10),
	@PriceCdCtl varchar(5)
AS

Declare	@strWhere nvarchar(1000)
Declare @strOrderWhere nvarchar(1000)
Declare	@strSql nvarchar(1000)
Declare	@strTempMonth varchar(50)
Declare @TableName varchar(40)
Declare	@TempTable varchar(50)
Declare @strCustMaster varchar(100)
Declare @strTempQuote varchar(100)
Declare @strTempSold varchar(100)
Declare @StrResult nvarchar(4000)

BEGIN
	SELECT	@strCustMaster	= '##PFCCUSTMAST_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SELECT  @strTempQuote	= '##PFCM_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SELECT  @strTempSold	= '##PFCY_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
	SELECT  @strResult		= '##PFC'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 

	-- ----------------------------------------------------------------------------------------------------------------------------
	-- Biniding where Condition
	-- ----------------------------------------------------------------------------------------------------------------------------

	SET @strWhere = '1=1'
	SET @strOrderWhere = '1=1'

	if @PeriodYear <> ''
        begin 
            Set @strWhere = @strWhere + ' AND (Year(a.QuotationDate) = ' + @PeriodYear + ''
			Set @strOrderWhere = @strOrderWhere + ' AND (Year(c.PurchaseOrderDate) = ' + @PeriodYear + ''
        end
    if @PeriodMonth <> ''
        begin 
            Set @strWhere = @strWhere + ' AND Month(a.QuotationDate) = ' + @PeriodMonth +')'
			Set @strOrderWhere = @strOrderWhere + ' AND Month(c.PurchaseOrderDate) = ' + @PeriodMonth +')'
        end

	if @StartDate <> '' and @EndDate <> '' 
        begin 
            Set @strWhere = @strWhere + ' AND (Cast(CONVERT(nvarchar(20), a.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
			Set @strOrderWhere = @strOrderWhere + ' AND (Cast(CONVERT(nvarchar(20), c.PurchaseOrderDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end
   
	if @LocationCode <> ''
        begin 
             --Set @strWhere = @strWhere + ' AND a.SalesLocationCode like ''%' + @LocationCode +'%'''
			Set @strWhere = @strWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
			Set @strOrderWhere = @strOrderWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end
 
	if @CustNo <> ''
        begin 
            Set @strWhere = @strWhere + ' AND a.CustomerNumber like ''%' + @CustNo +'%'''
			Set @strOrderWhere = @strOrderWhere + ' AND b.CustomerNumber like ''%' + @CustNo +'%'''
        end

	if @PriceCdCtl = 'false'
        begin 
            Set @strWhere = @strWhere + ' AND CM.PriceCd <> ''X'''
			Set @strOrderWhere = @strOrderWhere + ' AND CM.PriceCd <> ''X'''
        end
		
	-- Select Customer Information for given period
	set @strSql = '	Select	a.customerNumber, CM.CustShipLocation as SalesLocationCode
					into	' + @strCustMaster +
				  '	from	DTQ_CustomerQuotation a (NOLOCK) inner join
							OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM
					on		CM.CustNo = a.customerNumber  COLLATE Latin1_General_CS_AS
					where	

							a.DeleteFlag=0 and ' + @strWhere +
				  '	group by a.CustomerNumber, CM.CustShipLocation' 	
	Print 'Master'
	Print @StrSql		
	EXEC sp_executesql @strSql 	
       
    set @strSql = '	Select	a.customerNumber, count(a.QuoteNumber) as NoofQuotes,
							Sum(a.UnitPrice* a.RequestQuantity) as ExtAmount,
							Sum(a.GrossWeight * a.RequestQuantity) as ExtWeight
					into	' + @strTempQuote +
				  '	from	DTQ_CustomerQuotation a (NOLOCK) inner join
							OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM
					on		CM.CustNo = a.customerNumber COLLATE Latin1_General_CS_AS
					where	a.DeleteFlag = 0 and ' + @strWhere +
				  '	group by a.CustomerNumber' 	

	EXEC sp_executesql @strSql 			 
	--Print 'Quote'
	--Print @strSql
	      
	--No of Orders
	set @strSql = '	SELECT	b.CustomerNumber, count(b.QuoteNumber) as NoofOrders,
							Sum(b.GrossWeight*b.RequestQuantity) as ExtOrdWeight,
							Sum(a.TotalPrice) as ExtOrdAmount into ' + @strTempSold +
				  '	FROM	DTQ_CustomerPendingOrderDetail a (NOLOCK) INNER JOIN
							DTQ_CustomerQuotation b (NOLOCK)
					ON		a.QuotationItemDetailID = b.QuoteNumber INNER JOIN
							DTQ_CustomerPendingOrder c (NOLOCK)
					ON		a.PurchaseOrderID = c.ID AND c.OrderCompletedStatus =''true'' inner join
							OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM
					ON		CM.CustNo = b.CustomerNumber COLLATE Latin1_General_CS_AS
					where	' + @strOrderWhere +
				  '	group by b.CustomerNumber'	   	   

	EXEC sp_executesql @strSql
	print 'Order'
	print @strSql

    set @StrSql = '	SELECT	' + @strCustMaster + '.CustomerNumber,' + @strCustMaster + '.SalesLocationCode, 
							ISNULL(' + @strTempQuote + '.NoofQuotes,0) as NoofQuotes,
							ISNULL(cast((round(' + @strTempQuote + '.ExtAmount,2)) as Decimal(25,2)),0) as ExtAmount,
							ISNULL(cast((round(' + @strTempQuote + '.ExtWeight,1)) as Decimal(25,1)),0) as ExtWeight,
							ISNULL(' + @strTempSold + '.NoofOrders,0) as NoofOrders,
							ISNULL(cast((round(' + @strTempSold + '.ExtOrdAmount,2)) as Decimal(25,2)),0) as ExtOrdAmount, 
							ISNULL(cast((round(' + @strTempSold + '.ExtOrdWeight,1)) as Decimal(25,1)),0) as ExtOrdWeight
					INTO	' + @StrResult +
				  '	FROM	' + @strCustMaster + ' LEFT OUTER JOIN ' + @strTempSold +
				  '	ON		' + @strCustMaster + '.CustomerNumber = ' + @strTempSold  + '.CustomerNumber LEFT OUTER JOIN ' + @strTempQuote +
				  '	ON		' + @strCustMaster + '.CustomerNumber = ' + @strTempQuote + '.CustomerNumber '

	print @strSql
	Execute sp_executesql @StrSql
    EXEC('select * from ' + @strResult + '')

	EXEC('drop table ' + @strTempQuote + '')
	EXEC('drop table ' + @strTempSold + '')
	EXEC('drop table ' + @strResult + '')
	
END

-- ------------------------------------------------------------------------------------------------
--Exec [pQuoteAndOrderTemp] '','','05-04-2008','05-31-2008','15','000001'
--Exec [pQuoteAndOrder] '','','3-22-2011','3-23-2011','15','000001'
--Exec [pQuoteAndOrder] '12','2009','','','15','','true'
--Exec [pQuoteAndOrder] '12','2009','','','15','','false'
-- -----------------------------------------------------------------------------------------------
