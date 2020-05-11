





-- ==================================================================================================
-- Procedure	:	[pSalesPerformRpt]
-- Result		:	
-- ----------------------------------------------------------------------------------------------------
-- Date             Developer  		            Action          
-- ----------------------------------------------------------------------------------------------------
-- 08/12/2010       Sathish						Create
-- ====================================================================================================  
CREATE PROCEDURE [dbo].[pSalesPerformRpt]
@whereClause nvarchar(4000),
@startDt varchar(20),
@endDt varchar(20)
AS
Declare	@strWhere  nvarchar(4000)
Declare	@strSql    nvarchar(4000)
Declare	@totWorkDays varchar(10)
BEGIN	
	-- --------------------------------------------------------------------------------------------------------
	-- EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''3/30/2010'' AND Hdr.ARPostDt<= ''7/25/2010'' AND Hdr.CustShipLoc=''15''', '3/30/2010', '7/25/2010'
	-- --------------------------------------------------------------------------------------------------------

	select @totWorkDays=count(*) from FiscalCalendar where CurrentDt>= @startDt AND CurrentDt<= @endDt and WorkDay=1

	Set @strSql =	'SELECT	Branch
							,CustNo
							,CustName
							,sum(NetSales) as NetSales
							,sum(NetExp) as NetExp
							,sum(TotAR) as TotAR
							,sum(GMDollar) as GMDollar
							,(CASE WHEN SUM(NetSales) = 0  THEN 0  ELSE ((SUM(GMDollar)) / SUM((NetSales))) * 100 END) as GMPct
							,sum(TotWgt) TotWgt							
							,sum(ECommSales) as ECommSales
							,sum(ECommGMDollar) as ECommGMDollar
							,Case 	when  sum(ECommSales) = 0 then 0 else (sum(ECommGMDollar)/sum(ECommSales) * 100) end as ECommGMPct 
							,Chain
							,PriceCd
							,SalesTerritory
							,InsideRep
							,OutsideRep
							,State
							,(WeeklySalesGoal/5 * '+ @totWorkDays +') as GoalGMDol
							,(GrossMarginPct*100) as GoalGMPct
					From	(
						select	Hdr.CustShipLoc as Branch,Hdr.SellToCustNo as CustNo, 
								Hdr.SellToCustName as CustName, 
								SUM(Hdr.NetSales) as NetSales, 
								SUM(Hdr.TotalOrder - Hdr.NetSales) as NetExp, 
								SUM(Hdr.TotalOrder) as TotAR, 
								SUM(Hdr.NetSales - Hdr.TotalCost) as GMDollar, 
								(CASE WHEN SUM(Hdr.NetSales) = 0  THEN 0  ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END) as GMPct,SUM(Hdr.ShipWght) as TotWgt, 
								CASE 	WHEN  List.SequenceNo = 1 then SUM(isnull(Hdr.NetSales,0)) else 0 end as ECommSales,
								CASE 	WHEN  List.SequenceNo = 1 then isnull(SUM(Hdr.NetSales - Hdr.TotalCost),0) else 0 end as ECommGMDollar,
								Cust.ChainCd as Chain, 
								Cust.PriceCd,
								isnull(Cust.SalesTerritory,'''') as SalesTerritory,
								RepMast.InsideRep,
								RepMast.OutsideRep,
								max(Hdr.BillToState) as State,
								isnull(Cust.WeeklySalesGoal,0) as WeeklySalesGoal,
								isnull(Cust.GrossMarginPct ,0) as GrossMarginPct
						from  	SOHeaderHist Hdr (NOLOCK) 
						LEFT OUTER JOIN  (Select * from OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster) Cust ON 
							Hdr.SellToCustNo = Cust.CustNo 
						LEFT OUTER JOIN 
							(SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo  
							FROM OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM 
							INNER JOIN OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD  ON     
								LM.pListMasterID=LD.fListMasterID  
							WHERE  LM.ListName = ''SOEOrderSource'') List ON 
								List.ListValue = Hdr.OrderSource
						LEFT OUTER JOIN
							(SELECT CAST(ISNULL(InsideRep.RepNotes,'''') as varchar(250)) as InsideRep,CAST(ISNULL(OutsideRep.RepName,'''') as varchar(250)) as OutsideRep,CM.CustNo as RepCustNo
							From OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM 
							Left Outer Join OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.RepMaster InsideRep ON 
								InsideRep .RepNo = CM.SupportRepNo
							Left Outer Join OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.RepMaster OutsideRep ON 
								OutsideRep.RepNo = CM.SlsRepNo) RepMast ON
							RepMast.RepCustNo = Hdr.SellToCustNo
						where 	' +  @whereClause +					
						'GROUP BY Hdr.SellToCustNo,Hdr.SellToCustName,Hdr.CustShipLoc,Cust.ChainCd,Cust.PriceCd,Cust.SalesTerritory, List.SequenceNo,RepMast.InsideRep,RepMast.OutsideRep,cust.WeeklySalesGoal,Cust.GrossMarginPct
						) tmp
					Group by Chain, PriceCd, SalesTerritory, CustNo, CustName, Branch,InsideRep,OutsideRep,State,WeeklySalesGoal,GrossMarginPct
					Order by CustNo, Branch'
	print @strSql
	EXEC sp_executesql @strSql 
	
END







GO
