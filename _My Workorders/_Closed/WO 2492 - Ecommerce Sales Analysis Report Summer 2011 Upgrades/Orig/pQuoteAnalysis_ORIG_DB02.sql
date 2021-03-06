drop proc [pQuoteAnalysis]
GO


/****** Object:  StoredProcedure [dbo].[pQuoteAnalysis]    Script Date: 09/19/2011 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================
-- Procedure	:	[PFC_RPT_SP_QuoteAnalysis]
-- ----------------------------------------------------------------------------------------------------
-- Date             Developer  		            Action          Purpose
-- ----------------------------------------------------------------------------------------------------
--- 01/Apr/2008     Gajendran                   Added      Implemented Order Type 
-- ====================================================================================================  
CREATE PROCEDURE [dbo].[pQuoteAnalysis]
@PeriodMonth varchar(10) ,@PeriodYear varchar(10),@StartDate varchar(32),@EndDate varchar(32),@LocationCode varchar(10),@CustNo nvarchar(10)
AS
Declare	@strWhere  nvarchar(4000)
Declare	@strSql nvarchar(4000)
Declare @TableName varchar(40)

BEGIN
	
  	-- ----------------------------------------------------------------------------------------------------------------------------
	-- Biniding where Condition
	-- ----------------------------------------------------------------------------------------------------------------------------
	if @PeriodYear <> ''
        begin 
             Set @strWhere = ' (Year(a.QuotationDate) = ' + @PeriodYear + ''
        end
     	if @PeriodMonth <> ''
        begin 
             Set @strWhere = @strWhere + ' AND Month(a.QuotationDate) = ' + @PeriodMonth +')'
        end
	if @StartDate <> '' and @EndDate <> '' 
        begin 
             Set @strWhere = '(Cast(CONVERT(nvarchar(20), a.QuotationDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end
	if @LocationCode <> ''
        begin 
             Set @strWhere = @strWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end
	if @CustNo <> ''
        begin 
             Set @strWhere = @strWhere + ' AND a.CustomerNumber like ''%' + @CustNo +'%'''
        end
      set @strSql = 'Select  a.customerNumber,
                             a.CustomerName,
							(case right(userid,2) when ''-U'' then ''Web Order'' else   (case left(userid,3) when ''esv'' then ''SDK'' else(case isnumeric(userid) when 1 then ''Direct Connect'' end) end) end) as QuoteMethod,
                             CONVERT(nvarchar(20), a.QuotationDate, 101) as QuotationDate,
                             a.ExpiryDate,a.UserItemNo,a.PFCItemNo,a.Description,
							 CM.CustShipLocation as SalesBranchofRecord,
                             isnull(cast((round(a.RequestQuantity,0)) as Decimal(25,0)),0) as RequestQuantity,							 
                             isnull(cast((round(a.AvailableQuantity,0)) as Decimal(25,0)),0) as RunningAvalQty,
                             isnull(cast((round(a.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice,
                             0 as Margin,
                             a.PriceUOM,
                             isnull(cast((round(a.UnitPrice*a.RequestQuantity,2)) as Decimal(25,2)),0) as TotalPrice,
                             isnull(cast((round(a.GrossWeight*a.RequestQuantity,1)) as Decimal(25,1)),0) as GrossWeight,
							 isnull(ECommUserName,''NA'') as ECommUserName, isnull(ECommIPAddress,''NA'') as ECommIPAddress, 
							 isnull(ECommPhoneNo,''NA'') as ECommPhoneNo, isnull(OrderSource,''NA'') as OrderSource    
						FROM DTQ_CustomerQuotation a (NOLOCK) 
						Inner Join OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM On
						CM.CustNo = a.customerNumber  COLLATE Latin1_General_CS_AS
						where DeleteFlag=0 and ' + @strWhere + ' Order by a.CustomerNumber,a.UserID ' 	
		 EXEC sp_executesql @strSql 		
		--	 Print 'Quote'
		 Print @strSql
		-- EXEC('select * from '+@strTempQuote+'')
END
-- Exec [pQuoteAnalysis] '','','12-03-2010','12-03-2010','15',''






