drop proc [pOrderAnalysis]
GO


/****** Object:  StoredProcedure [dbo].[pOrderAnalysis]    Script Date: 09/19/2011 16:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================
-- Procedure	:	[pOrderAnalysis]
-- ----------------------------------------------------------------------------------------------------
-- Date             Developer  		            Action          Purpose
-- ----------------------------------------------------------------------------------------------------
--- 02/Apr/2008     Gajendran                   Added           Order Analysis Report
-- ====================================================================================================  
CREATE PROCEDURE [dbo].[pOrderAnalysis]
@PeriodMonth varchar(10) ,@PeriodYear varchar(10),@StartDate varchar(32),@EndDate varchar(32),@LocationCode varchar(10),@CustNo varchar(10)
AS
Declare	@strWhere  nvarchar(4000)
Declare	@strSql nvarchar(4000)

BEGIN
	
   -- ----------------------------------------------------------------------------------------------------------------------------
	-- Biniding where Condition
	-- ----------------------------------------------------------------------------------------------------------------------------
	if @PeriodYear <> ''
        begin 
             Set @strWhere = ' (Year(DTQ_CustomerPendingOrder.PurchaseOrderDate) = ' + @PeriodYear + ''
        end
     	if @PeriodMonth <> ''
        begin 
             Set @strWhere = @strWhere + ' AND Month(DTQ_CustomerPendingOrder.PurchaseOrderDate) = ' + @PeriodMonth +')'
        end

	if @StartDate <> '' and @EndDate <> '' 
        begin 
             Set @strWhere = '(Cast(CONVERT(nvarchar(20), DTQ_CustomerPendingOrder.PurchaseOrderDate, 101) as Datetime) between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
        end
	
	if @LocationCode <> ''
        begin 
             Set @strWhere = @strWhere + ' AND CM.CustShipLocation like ''%' + @LocationCode +'%'''
        end
    
	if @CustNo <> ''
        begin 
             Set @strWhere = @strWhere + ' AND DTQ_CustomerPendingOrder.CustomerNumber like ''%' + @CustNo +'%'''
        end
        

       set @strSql = 'SELECT      DTQ_CustomerQuotation.CustomerNumber, DTQ_CustomerQuotation.CustomerName,
                       DTQ_CustomerPendingOrder.PurchaseOrderNo, 
                      (case right( DTQ_CustomerQuotation.userid,2) when ''-U'' then ''Web Order'' else (case left( DTQ_CustomerQuotation.userid,3) when ''int'' then ''SDK'' when ''esv'' then ''SDK'' else(case isnumeric( DTQ_CustomerQuotation.userid) when 1 then ''Direct Connect'' end) end) end) as OrderMethod, 
                       DTQ_CustomerPendingOrder.PurchaseOrderDate,  DTQ_CustomerPendingOrderDetail.UserItemNo, 
                       DTQ_CustomerPendingOrderDetail.PFCItemNo,  DTQ_RequestedQuantity.LocationCode, DTQ_CustomerQuotation.Description,
					  CM.CustShipLocation as SalesLocationCode, 
                      isnull(cast((round( DTQ_RequestedQuantity.RequestedQuantity,0)) as Decimal(25,0)),0) as RequestQuantity, 
                      isnull(cast((round( DTQ_CustomerQuotation.AvailableQuantity,0)) as Decimal(25,0)),0) as AvailableQuantity,
                      isnull(cast((round( DTQ_CustomerPendingOrderDetail.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice,
                      0 as Margin,
                       DTQ_CustomerPendingOrderDetail.PriceUOM,
                      isnull(cast((round( DTQ_CustomerPendingOrderDetail.TotalPrice,2)) as Decimal(25,2)),0) as TotalPrice, 
                      isnull(cast((round( DTQ_CustomerPendingOrderDetail.Weight,1)) as Decimal(25,1)),0) as Weight,
					  isnull(DTQ_CustomerPendingOrder.ECommUserName,''NA'') as ECommUserName, 
					  isnull(DTQ_CustomerPendingOrder.ECommIPAddress,''NA'') as ECommIPAddress, 
					  isnull(DTQ_CustomerPendingOrder.ECommPhoneNo,''NA'') as ECommPhoneNo, 
					  isnull(DTQ_CustomerPendingOrder.OrderSource,''NA'') as OrderSource    
                      
					            
					  FROM   DTQ_CustomerPendingOrder 
					  INNER JOIN DTQ_CustomerPendingOrderDetail ON  DTQ_CustomerPendingOrder.ID =  DTQ_CustomerPendingOrderDetail.PurchaseOrderID  AND DTQ_CustomerPendingOrder.OrderCompletedStatus =''true''
					  INNER JOIN DTQ_RequestedQuantity ON  DTQ_CustomerPendingOrderDetail.ID =  DTQ_RequestedQuantity.PendingOrderID 
					  INNER JOIN DTQ_CustomerQuotation ON  DTQ_CustomerPendingOrderDetail.QuotationItemDetailID =  DTQ_CustomerQuotation.QuoteNumber 
							AND DTQ_RequestedQuantity.QuoteNumber =  DTQ_CustomerQuotation.QuoteNumber
					  INNER JOIN OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM On
					  CM.CustNo = DTQ_CustomerQuotation.customerNumber  COLLATE Latin1_General_CS_AS 
					  where ' + @strWhere + ''
		
EXEC sp_executesql @strSql 		
		--	 Print 'Quote'
			 Print @strSql
		-- EXEC('select * from '+@strTempQuote+'')
END

-- ------------------------------------------------------------------------------------------------
-- Exec [pOrderAnalysis] '','','3-22-2011','3-23-2011','15','000001'
-- Exec [pOrderAnalysis] '08','2009','','','15',''
-- -----------------------------------------------------------------------------------------------






















