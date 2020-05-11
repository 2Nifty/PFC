
-- ==================================================================================================
-- Procedure	:	[PFC_RPT_SP_QuoteAndOrder]
-- ----------------------------------------------------------------------------------------------------
-- Date             Developer  		            Action          Purpose
-- ----------------------------------------------------------------------------------------------------
--- 02/May/2008     Gajendran                   Added           To Generate DailySalesAnalysis
--- 17/Jul/2008     Slater                      Modified        To use a union of invoice and credit users
-- ====================================================================================================  

CREATE PROCEDURE [dbo].[pDailySalesAnalysis] @Location varchar(10),@StartDate varchar(32),@EndDate varchar(32)
AS
Declare	@strSql nvarchar(4000)
Declare	@strTempInv varchar(50)
Declare	@strTempCR varchar(50)
Declare	@strWhere  varchar(500) 
Declare	@strResult nvarchar(4000)


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  @strTempInv  = '##INV_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
    SELECT  @strTempCR =   '##CR_'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
  	SELECT  @strResult  = '##PFC'+left(CONVERT(UNIQUEIDENTIFIER, CONVERT(BINARY(10), NEWID()) + CONVERT(BINARY(6), GETDATE())),8) 
 

     if @Location <> 'ALL'
        begin 
             Set @strWhere = 'Branch = ' + @Location + ' AND '+' Posted >='''+@StartDate+''' AND Posted <='''+ @EndDate +''''

	   end

    if @Location = 'ALL'
        begin 
             Set @strWhere = '(Posted between ''' + @StartDate + ''' AND '''+ @EndDate + ''')'
	   end
---------------------------------------------------------------
-- SUM Calculation for FootballInvRaw Group By Branch & UserID
---------------------------------------------------------------
		    select @strSql = 'SELECT dbo.FootballInvRaw.ADUserID, dbo.FootballInvRaw.Branch, 
                              ISNULL(SUM(dbo.FootballInvRaw.InvoiceSalesDollar),0) AS salesD, 
							  case(ISNULL(SUM(dbo.FootballInvRaw.InvoicePounds), 0)) when 0 then 0 else ISNULL(SUM(dbo.FootballInvRaw.InvoiceSalesDollar), 0)/ISNULL(SUM(dbo.FootballInvRaw.InvoicePounds), 1) end AS salesDLB, 
                              ISNULL(SUM(dbo.FootballInvRaw.InvoiceMarginDollar),0) AS SalesGP, 
							  case(ISNULL(SUM(dbo.FootballInvRaw.InvoiceSalesDollar),0)) when 0 then 0 else ISNULL(SUM(dbo.FootballInvRaw.InvoiceMarginDollar), 0) /  ISNULL(SUM(dbo.FootballInvRaw.InvoiceSalesDollar),1) end AS SalesGPPer, 
                              case(ISNULL(SUM(dbo.FootballInvRaw.InvoicePounds), 0)) when 0 then 0 else ISNULL(SUM(dbo.FootballInvRaw.InvoiceMarginDollar), 0)/ ISNULL(SUM(dbo.FootballInvRaw.InvoicePounds), 1) end AS SalesGPDLB, 
							  ISNULL(SUM(dbo.FootballInvRaw.InvoiceOrderCount),0) AS SalesOrders, 
                              ISNULL(SUM(dbo.FootballInvRaw.InvoiceLineCount),0) AS SalesLines, 
							  ISNULL(SUM(dbo.FootballInvRaw.InvoicePounds),0) AS SalesPounds into '+@strTempInv+' from dbo.FootballInvRaw where ' + @strWhere + ' group by dbo.FootballInvRaw.Branch,dbo.FootballInvRaw.ADUserID order by dbo.FootballInvRaw.Branch'
--			Print 'INV'
			Print @strSql
			EXEC sp_executesql @strSql 
--		    EXEC('select * from '+@strTempInv+'')


---------------------------------------------------------------
-- SUM Calculation for FootballCRRaw Group By Branch & UserID
---------------------------------------------------------------

			select @strSql =    'SELECT dbo.FootballCRRaw.ADUserID, dbo.FootballCRRaw.Branch,
                              ISNULL(SUM(dbo.FootballCRRaw.CreditSalesDollar),0) AS CreditD, 
							  case(ISNULL(SUM(dbo.FootballCRRaw.CreditPounds), 0)) when 0 then 0 else ISNULL(SUM(dbo.FootballCRRaw.CreditSalesDollar),0) /ISNULL(SUM(dbo.FootballCRRaw.CreditPounds), 1) end AS CreditDLb, 
                              ISNULL(SUM(dbo.FootballCRRaw.CreditMarginDollar),0) AS CreditGP, 
							  case(ISNULL(SUM(dbo.FootballCRRaw.CreditSalesDollar), 0)) when 0 then 0 else ISNULL(SUM(dbo.FootballCRRaw.CreditMarginDollar),0) / ISNULL(SUM(dbo.FootballCRRaw.CreditSalesDollar), 1) end AS CreditGPPer, 
                              case(ISNULL(SUM(dbo.FootballCRRaw.CreditPounds), 0)) when 0 then 0 else ISNULL(SUM(dbo.FootballCRRaw.CreditMarginDollar),0) / ISNULL(SUM(dbo.FootballCRRaw.CreditPounds), 1) end AS CreditGPDLb, 
							  ISNULL(SUM(dbo.FootballCRRaw.CreditOrderCount),0) AS CreditOrders, 
                              ISNULL(SUM(dbo.FootballCRRaw.CreditLineCount),0) AS CreditLines, 
							  ISNULL(SUM(dbo.FootballCRRaw.CreditPounds),0) AS CreditPounds into '+ @strTempCR+' from dbo.FootballCRRaw  where ' + @strWhere + ' group by dbo.FootballCRRaw.Branch,dbo.FootballCRRaw.ADUserID order by dbo.FootballCRRaw.Branch'
--			Print 'CR'
			Print @strSql
			EXEC sp_executesql @strSql 
--			EXEC('select * from '+@strTempCR+'')
--			print 'Completed'

---------------------------------------------------------------
-- Joining  FootballInvRaw & FootballCRRaw 
---------------------------------------------------------------


			set @StrSql = 'SELECT stage2.ADUserID as SalesPerson, 
				   stage2.Branch, 
				   ISNULL('+@strTempInv+'.salesD,0) as SalesDol,
				   ISNULL('+@strTempInv+'.salesDLB,0) as SalesDolLB,
				   ISNULL('+@strTempInv+'.SalesGP,0) as SalesGP,
				   ISNULL('+@strTempInv+'.SalesGPPer,0) as SalesGPPct,
				   ISNULL('+@strTempInv+'.SalesGPDLB,0) as SalesGPDolLB, 
				   ISNULL('+@strTempInv+'.SalesOrders,0) as SalesOrders, 
				   ISNULL('+@strTempInv+'.SalesLines,0) as SalesLines, 
				   ISNULL('+@strTempInv+'.SalesPounds,0) as SalesPounds, 

			       ISNULL('+@strTempCR+'.CreditD,0) as CreditDol, 
				   ISNULL('+@strTempCR+'.CreditDLb,0) as CreditDolLB,  
				   ISNULL('+@strTempCR+'.CreditGP,0) as CreditGP,
				   ISNULL('+@strTempCR+'.CreditGPPer,0) as CreditGPPct,
				   ISNULL('+@strTempCR+'.CreditGPDLb,0) as CreditGPDolLB, 
				   ISNULL('+@strTempCR+'.CreditOrders,0) as CreditOrders, 
				   ISNULL('+@strTempCR+'.CreditLines,0) as  CreditLines,
				   ISNULL('+@strTempCR+'.CreditPounds,0) as CreditPounds

				    into '+@strResult+' 
					FROM (
						select ADUserID, Branch 
						from 
						(select ADUserID, Branch from '+@strTempInv+'
							union 
						select ADUserID, Branch from '+@strTempCR+') stage1
						group by ADUserID, Branch) stage2 LEFT OUTER JOIN 
					'+@strTempInv+' ON stage2.ADUserID = 
				   '+@strTempInv+'.ADUserID  AND stage2.Branch ='+@strTempInv+'.Branch LEFT OUTER JOIN 
				   '+@strTempCR+' ON stage2.ADUserID = 
				   '+@strTempCR+'.ADUserID AND stage2.Branch ='+@strTempCR+'.Branch order by 2'
-- print @StrSql
 EXEC sp_executesql @strSql 


---------------------------------------------------------------
-- Select Statment for @strResult Table & SalesPerson Condition
---------------------------------------------------------------

 EXEC('select case(left('+@strResult+'.SalesPerson,2)) when ''UL'' then '+@strResult+'.SalesPerson else (case ('+@strResult+'.SalesPerson) when ''Support Team'' then '+@strResult+'.SalesPerson else DashboardUsersTemp.name end) end as SalesPerson,
 Branch,SalesDol,SalesDolLB,SalesGP,SalesGPPct,SalesGPDolLB,SalesOrders,SalesLines,SalesPounds,
 CreditDol,CreditDolLB,CreditGP,CreditGPPct,CreditGPDolLB,CreditOrders,CreditLines,CreditPounds
 from '+@strResult+' LEFT OUTER JOIN DashboardUsersTemp ON '+@strResult+'.SalesPerson = DashboardUsersTemp.USERID')

		EXEC('drop table '+@strTempInv+'')
		EXEC('drop table '+@strTempCR+'')
		EXEC('drop table '+@strResult+'')
END

--  Test Executin ----------------------------------------------------
-- Exec pDailySalesAnalysis '10','04-01-2008','04-28-2008'
----------------------------------------------------------------------

GO
