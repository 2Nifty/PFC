select * from CustomerMaster (NoLock) where CustShipLocation=10 and CreditInd not in ('X','E')


--exec sp_columns CustomerMaster


EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''10/05/2010'' AND Hdr.ARPostDt<= ''10/11/2010''', '1=1 AND tAllCust.CustShipLocation=''10''', 'N', '10/05/2010', '10/05/2010'


EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''10/05/2010'' AND Hdr.ARPostDt<= ''10/11/2010''', '1=1 AND tAllCust.CustShipLocation=''10''', 'Y', '10/05/2010', '10/05/2010'


select top 5 * from SOHeaderHist where ordertypedsc='Mill'


select distinct OrderType, OrderTypeDsc from SOHeaderHist order by OrderTypeDsc

select distinct OrderFreightCd from SOHeaderHist

select distinct OrderSource from SOHeaderHist


select SelltoCustNo, Count(*) from SOHeaderHist Hdr --inner join CustomerMaster on SellToCustNo=CustNo
where OrderSource='RQ' --and CreditInd not in ('X','E')
 and Hdr.ARPostDt>= '10/05/2010' AND Hdr.ARPostDt<= '10/11/2010'
--group by SellTocustNo
and SellToCustNo in 
(SELECT	
		CM.CustNo

	 FROM	CustomerMaster CM (NoLock)
	 WHERE	CM.CreditInd not in ('X','E') and CustShipLocation='15')

group by SellTocustNo



select SelltoCustNo, Count(*) from SOHeaderHist Hdr --inner join CustomerMaster on SellToCustNo=CustNo
where OrderFreightCd='PPD-1500' --and CreditInd not in ('X','E')
 and Hdr.ARPostDt>= '10/05/2010' AND Hdr.ARPostDt<= '10/11/2010'

and SellToCustNo in 
(SELECT	
		CM.CustNo

	 FROM	CustomerMaster CM (NoLock)
	 WHERE	CM.CreditInd not in ('X','E') and CustShipLocation='15')

group by SellTocustNo


select SellTocustNo, count(*) from SOHeaderHist Hdr --inner join CustomerMaster on SellToCustNo=CustNo
where OrderType<>'1' --and CreditInd not in ('X','E')
 and Hdr.ARPostDt>= '10/05/2010' AND Hdr.ARPostDt<= '10/11/2010'
--group by SellTocustNo
and SellToCustNo in 
(SELECT	
		CM.CustNo

	 FROM	CustomerMaster CM (NoLock)
	 WHERE	CM.CreditInd not in ('X','E') and CustShipLocation='15')

group by SellTocustNo






select * from
	(SELECT	CM.CustShipLocation,
		CM.CustNo,
		CM.CustName,
		CM.ChainCd,
		CM.PriceCd,
		CM.WeeklySalesGoal,
		CM.GrossMarginPct,
		CM.SalesTerritory,
		--InsideRep.RepNotes AS InsideRep,
		InsideRep.RepName AS InsideRep,
		OutsideRep.RepName AS OutsideRep
	 FROM	CustomerMaster CM (NoLock) LEFT OUTER JOIN
		RepMaster InsideRep (NoLock)
	 ON	InsideRep.RepNo = CM.SupportRepNo LEFT OUTER JOIN
		RepMaster OutsideRep (NoLock)
	 ON	OutsideRep.RepNo = CM.SlsRepNo
	 WHERE	CM.CreditInd not in ('X','E'))tAllCust  LEFT OUTER JOIN
	--tRegionLoc
	(SELECT	RegionalMgr.SalesRegionNo,
		RegionalMgr.RepName AS RegionalMgr,
		RegionalLoc.LocID
	 FROM	RepMaster RegionalMgr (NoLock) INNER JOIN
		LocMaster RegionalLoc (NoLock)
	 ON	RegionalMgr.SalesRegionNo = RegionalLoc.SalesRegionNo
	 WHERE	RepClass='R') tRegionLoc
	ON	tAllCust.CustShipLocation = tRegionLoc.LocID
where --CustShipLocation='15'
--and 
PriceCd='A'
--and  isnull(SalesTerritory,'') ='Hay03'
--and ChainCd='Alls-3'
--and OutsideRep='Kevin Chavis'
--and RegionalMgr='Kevin Chavis'
--and InsideRep='Emerie Castillo'









SELECT	
		CM.CustNo, CreditInd

	 FROM	CustomerMaster CM (NoLock)
	 WHERE	CM.CreditInd in ('x','e')





select distinct ARPostDt from SOHeaderHist order by ARPostDt






--This query matches the dashboard number 484,318.1583 for all branches (yesterday's sales)
SELECT	sum(Hdr.NetSales)
FROM	SOHeaderHist Hdr 
WHERE	Hdr.ARPostDt = '10/11/2010'

--This query matches the sales perf rpt number 479,044.5053 for all branches (yesterday's sales)
SELECT	sum(Hdr.NetSales)
FROM	SOHeaderHist Hdr inner join
	CustomerMaster Cust
ON	Hdr.SellToCustNo = Cust.CustNo
WHERE	Cust.CreditInd not in ('X','E')
	and Hdr.ARPostDt = '10/11/2010'


--This query matches the dashboard number 33,228.9022 for branch 15 (yesterday's sales)
SELECT	sum(Hdr.NetSales)
FROM	SOHeaderHist Hdr 
WHERE	Hdr.ARPostDt = '10/11/2010'
	and Hdr.CustShipLoc = '15'

--This query matches the sales perf rpt number 32,791.4713 for branch 15 (yesterday's sales)
SELECT	sum(Hdr.NetSales)
FROM	SOHeaderHist Hdr inner join
	CustomerMaster Cust
ON	Hdr.SellToCustNo = Cust.CustNo
WHERE	Cust.CreditInd not in ('X','E')
	and Hdr.ARPostDt = '10/11/2010'
	and Cust.CustShipLocation = '15'