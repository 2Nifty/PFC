
SELECT	isnull(tAllCustSales.Branch, tAllCust.CustShipLocation) as Branch,
	isnull(tAllCustSales.CustNo, tAllCust.CustNo) as CustNo,
	isnull(tAllCust.CustName,'') as CustName,
	isnull(tAllCustSales.NetSales,0) as NetSales,
	isnull(tAllCustSales.NetExp,0) as NetExp,
	isnull(tAllCustSales.TotAR,0) as TotAR,
	isnull(tAllCustSales.GMDollar,0) as GMDollar,
	isnull(tAllCustSales.GMPct,0) as GMPct,
	isnull(tAllCustSales.TotWgt,0) as TotWgt,							
	isnull(tAllCustSales.ECommSales,0) as ECommSales,
	isnull(tAllCustSales.ECommGMDollar,0) as ECommGMDollar,
	isnull(tAllCustSales.eCommGMPct,0) as eCommGMPct,
	isnull(tAllCust.ChainCd,'') as Chain,
	isnull(tAllCust.PriceCd,'') as PriceCd,
	isnull(tAllCust.SalesTerritory,'') as SalesTerritory,
	CAST(ISNULL(tAllCust.InsideRep,'') as varchar(250)) as InsideRep,
	CAST(ISNULL(tAllCust.OutsideRep,'') as varchar(250)) as OutsideRep,
	isnull(tAllCustSales.State,'') as State,
	isnull(tAllCust.WeeklySalesGoal,0) / 5 * 25 as GoalGMDol,
	isnull(tAllCust.GrossMarginPct ,0) * 100 as GoalGMPct
FROM	--tAllCust
	(SELECT	CM.CustShipLocation,
		CM.CustNo,
		CM.CustName,
		CM.ChainCd,
		CM.PriceCd,
		CM.SalesTerritory,
		CM.WeeklySalesGoal,
		CM.GrossMarginPct,
		InsideRep.RepNotes as InsideRep,
		OutsideRep.RepName as OutsideRep
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM LEFT OUTER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.RepMaster InsideRep
	 ON	InsideRep .RepNo = CM.SupportRepNo LEFT OUTER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.RepMaster OutsideRep
	 ON	OutsideRep.RepNo = CM.SlsRepNo
	 WHERE	CreditInd not in ('X','E')) tAllCust LEFT OUTER JOIN
	--tAllCustSales
	(SELECT	tSales.Branch
		,tSales.CustNo
		,sum(tSales.NetSales) as NetSales
		,sum(tSales.NetExp) as NetExp
		,sum(tSales.TotAR) as TotAR
		,sum(tSales.GMDollar) as GMDollar
		,CASE WHEN SUM(tSales.NetSales) = 0 THEN 0 ELSE ((sum(tSales.GMDollar)) / sum((tSales.NetSales))) * 100 END as GMPct
		,sum(tSales.TotWgt) TotWgt							
		,sum(tSales.ECommSales) as ECommSales
		,sum(tSales.ECommGMDollar) as ECommGMDollar
		,CASE WHEN sum(tSales.ECommSales) = 0 THEN 0 ELSE (sum(tSales.ECommGMDollar) / sum(tSales.ECommSales) * 100) END as ECommGMPct 
		,tSales.State
	 FROM	--tSales
		(SELECT	Hdr.CustShipLoc as Branch,
			Hdr.SellToCustNo as CustNo,
			SUM(Hdr.NetSales) as NetSales, 
			SUM(Hdr.TotalOrder - Hdr.NetSales) as NetExp, 
			SUM(Hdr.TotalOrder) as TotAR, 
			SUM(Hdr.NetSales - Hdr.TotalCost) as GMDollar, 
			CASE WHEN SUM(Hdr.NetSales) = 0 THEN 0 ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END as GMPct,
			SUM(Hdr.ShipWght) as TotWgt, 
			CASE WHEN List.SequenceNo = 1 THEN SUM(isnull(Hdr.NetSales,0)) ELSE 0 END as ECommSales,
			CASE WHEN List.SequenceNo = 1 THEN isnull(SUM(Hdr.NetSales - Hdr.TotalCost),0) ELSE 0 END as ECommGMDollar,
			max(Hdr.BillToState) as State
		 FROM	SOHeaderHist Hdr (NoLock) LEFT OUTER JOIN
		--Cust
		(SELECT	CustNo
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster) Cust
		ON	Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
		--List
		(SELECT	LM.ListName,
			LD.ListValue,
			LD.ListDtlDesc,
			LD.SequenceNo
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
		 ON	LM.pListMasterID=LD.fListMasterID
		 WHERE	LM.ListName = 'SOEOrderSource') List
		ON	List.ListValue = Hdr.OrderSource
		WHERE	Hdr.ARPostDt>= '7/26/2010' AND Hdr.ARPostDt<= '8/27/2010' AND Hdr.CustShipLoc='15'
		GROUP BY Hdr.SellToCustNo, Hdr.CustShipLoc, List.SequenceNo) tSales
	 GROUP BY tSales.CustNo, tSales.Branch, tSales.State) tAllCustSales
ON	tAllCust.CustNo = tAllCustSales.CustNo
WHERE	tAllCust.CustShipLocation = '15'
ORDER BY CustNo, Branch



