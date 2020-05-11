

	Set @strSql =	'SELECT	isnull(tAllCustSales.Branch, tAllCust.CustShipLocation) AS Branch,
				isnull(tAllCustSales.CustNo, tAllCust.CustNo) AS CustNo,
				isnull(tAllCust.CustName,'''') AS CustName,
				isnull(tAllCustSales.NetSales,0) AS NetSales,
				isnull(tAllCustSales.NetExp,0) AS NetExp,
				isnull(tAllCustSales.TotAR,0) AS TotAR,
				isnull(tAllCustSales.GMDollar,0) AS GMDollar,
				isnull(tAllCustSales.GMPct,0) AS GMPct,
				isnull(tAllCustSales.TotWgt,0) AS TotWgt,							
				isnull(tAllCustSales.ECommSales,0) AS ECommSales,
				isnull(tAllCustSales.ECommGMDollar,0) AS ECommGMDollar,
				isnull(tAllCustSales.eCommGMPct,0) AS eCommGMPct,
				isnull(tAllCust.ChainCd,'''') AS Chain,
				isnull(tAllCust.PriceCd,'''') AS PriceCd,
				isnull(tAllCust.SalesTerritory,'''') AS SalesTerritory,
				CAST(ISNULL(tAllCust.InsideRep,'''') AS varchar(250)) AS InsideRep,
				CAST(ISNULL(tAllCust.OutsideRep,'''') AS varchar(250)) AS OutsideRep,
				isnull(tAllCustSales.State,'''') AS State,
				isnull(tAllCust.WeeklySalesGoal,0) / 5 * ' + @totWorkDays + ' AS GoalGMDol
				isnull(tAllCust.GrossMarginPct ,0) * 100 AS GoalGMPct
			 FROM	--tAllCust
				(SELECT	CM.CustShipLocation,
					CM.CustNo,
					CM.CustName,
					CM.ChainCd,
					CM.PriceCd,
					CM.SalesTerritory,
					CM.WeeklySalesGoal,
					CM.GrossMarginPct,
					InsideRep.RepNotes AS InsideRep,
					OutsideRep.RepName AS OutsideRep
				 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster CM LEFT OUTER JOIN
					OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.RepMaster InsideRep
				 ON	InsideRep .RepNo = CM.SupportRepNo LEFT OUTER JOIN
					OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.RepMaster OutsideRep
				 ON	OutsideRep.RepNo = CM.SlsRepNo
				 WHERE	CreditInd not in (''X'',''E'')) tAllCust LEFT OUTER JOIN
				--tAllCustSales
				(SELECT	tSales.Branch,
					tSales.CustNo,
					sum(tSales.NetSales) AS NetSales,
					sum(tSales.NetExp) AS NetExp,
					sum(tSales.TotAR) AS TotAR,
					sum(tSales.GMDollar) AS GMDollar,
					CASE WHEN SUM(tSales.NetSales) = 0 THEN 0 ELSE ((sum(tSales.GMDollar)) / sum((tSales.NetSales))) * 100 END AS GMPct,
					sum(tSales.TotWgt) TotWgt,
					sum(tSales.ECommSales) AS ECommSales,
					sum(tSales.ECommGMDollar) AS ECommGMDollar,
					CASE WHEN sum(tSales.ECommSales) = 0 THEN 0 ELSE (sum(tSales.ECommGMDollar) / sum(tSales.ECommSales) * 100) END AS ECommGMPct,
					tSales.State
				 FROM	--tSales
					(SELECT	Hdr.CustShipLoc AS Branch,
						Hdr.SellToCustNo AS CustNo,
						SUM(Hdr.NetSales) AS NetSales, 
						SUM(Hdr.TotalOrder - Hdr.NetSales) AS NetExp, 
						SUM(Hdr.TotalOrder) AS TotAR, 
						SUM(Hdr.NetSales - Hdr.TotalCost) AS GMDollar, 
						CASE WHEN SUM(Hdr.NetSales) = 0 THEN 0 ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END AS GMPct,
						SUM(Hdr.ShipWght) AS TotWgt, 
						CASE WHEN List.SequenceNo = 1 THEN SUM(isnull(Hdr.NetSales,0)) ELSE 0 END AS ECommSales,
						CASE WHEN List.SequenceNo = 1 THEN isnull(SUM(Hdr.NetSales - Hdr.TotalCost),0) ELSE 0 END AS ECommGMDollar,
						max(Hdr.BillToState) AS State
					 FROM	SOHeaderHist Hdr (NoLock) LEFT OUTER JOIN
					--Cust
					(SELECT	CustNo
					 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.CustomerMaster) Cust
					ON	Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
					--List
					(SELECT	LM.ListName,
						LD.ListValue,
						LD.ListDtlDesc,
						LD.SequenceNo
					 FROM	OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN
						OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD
					 ON	LM.pListMasterID=LD.fListMasterID
					 WHERE	LM.ListName = ''SOEOrderSource'') List
					ON	List.ListValue = Hdr.OrderSource
					WHERE	' +  @whereSales + '
					GROUP BY Hdr.SellToCustNo, Hdr.CustShipLoc, List.SequenceNo) tSales
				 GROUP BY tSales.CustNo, tSales.Branch, tSales.State) tAllCustSales
			 ON	tAllCust.CustNo = tAllCustSales.CustNo
			 WHERE	' +  @whereCust + '
			 ORDER BY CustNo, Branch'