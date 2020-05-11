exec pSalesPerformRpt 
'Hdr.ARPostDt>= ''8/1/2010'' AND Hdr.ARPostDt<= ''8/28/2010'' AND Hdr.CustShipLoc=''14''', 
'8/1/2010' ,
'8/28/2010'


Hdr.ARPostDt>= '8/1/2010' AND Hdr.ARPostDt<= '8/28/2010' AND Hdr.CustShipLoc='14'



							select	Hdr.CustShipLoc as Branch,Hdr.SellToCustNo as CustNo, 
								Hdr.SellToCustName as CustName, 
OrderNo, --OrderRelNo, 
InvoiceNo,
OrderType, 
OrderTypeDsc,
Hdr.NetSales as NetSales  --, 
--								SUM(Hdr.NetSales) as NetSales, 
--								SUM(Hdr.TotalOrder - Hdr.NetSales) as NetExp, 
--								SUM(Hdr.TotalOrder) as TotAR, 
--								SUM(Hdr.NetSales - Hdr.TotalCost) as GMDollar, 
--								(CASE WHEN SUM(Hdr.NetSales) = 0  THEN 0  ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END) as GMPct,SUM(Hdr.ShipWght) as TotWgt, 
--								CASE 	WHEN  List.SequenceNo = 1 then SUM(isnull(Hdr.NetSales,0)) else 0 end as ECommSales,
--								CASE 	WHEN  List.SequenceNo = 1 then isnull(SUM(Hdr.NetSales - Hdr.TotalCost),0) else 0 end as ECommGMDollar,
--								Cust.ChainCd as Chain, 
--								Cust.PriceCd,
--								isnull(Cust.SalesTerritory,'') as SalesTerritory,
--								RepMast.InsideRep,
--								RepMast.OutsideRep,
--								max(Hdr.BillToState) as State,
--								isnull(Cust.WeeklySalesGoal,0) as WeeklySalesGoal,
--								isnull(Cust.GrossMarginPct ,0) as GrossMarginPct
						from  	SOHeaderHist Hdr (NOLOCK) 
						LEFT OUTER JOIN  (Select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster) Cust ON 
							Hdr.SellToCustNo = Cust.CustNo 
						LEFT OUTER JOIN 
							(SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo  
							FROM OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM 
							INNER JOIN OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD  ON     
								LM.pListMasterID=LD.fListMasterID  
							WHERE  LM.ListName = 'SOEOrderSource') List ON 
								List.ListValue = Hdr.OrderSource
						LEFT OUTER JOIN
							(SELECT CAST(ISNULL(InsideRep.RepNotes,'') as varchar(250)) as InsideRep,CAST(ISNULL(OutsideRep.RepName,'') as varchar(250)) as OutsideRep,CM.CustNo as RepCustNo
							From OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
							Left Outer Join OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.RepMaster InsideRep ON 
								InsideRep .RepNo = CM.SupportRepNo
							Left Outer Join OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.RepMaster OutsideRep ON 
								OutsideRep.RepNo = CM.SlsRepNo) RepMast ON
							RepMast.RepCustNo = Hdr.SellToCustNo
						where 	Hdr.ARPostDt>= '8/1/2010' AND Hdr.ARPostDt<= '8/28/2010' AND CustShipLoc='14'
--Hdr.SellToCustNo='200688'
Order By OrderType
--						GROUP BY Hdr.SellToCustNo,Hdr.SellToCustName,Hdr.CustShipLoc,Cust.ChainCd,Cust.PriceCd,Cust.SalesTerritory, List.SequenceNo,RepMast.InsideRep,RepMast.OutsideRep,cust.WeeklySalesGoal,Cust.GrossMarginPct

