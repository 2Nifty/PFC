drop proc [dbo].[pSalesPerformRpt]
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSalesPerformRpt]
	@whereSales nvarchar(4000),
	@whereCust nvarchar(4000),
	@allCustFlg char(1),
	@startDt varchar(20),
	@endDt varchar(20)

AS
DECLARE	@strSql nvarchar(4000)
DECLARE	@strSql2 nvarchar(4000)
DECLARE	@totWorkDays varchar(10)

BEGIN
	-- ============================================
	-- Procedure	:	[pSalesPerformRpt]
	-- Result	:	
	-- --------------------------------------------
	-- Date		Developer	Action          
	-- --------------------------------------------
	-- 08/12/2010	Sathish		Create
	-- 12/03/2010	crojas		Remove Credit Hold filter per Bob P.
	-- ============================================

	-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''7/26/2009'' AND Hdr.ARPostDt<= ''8/27/2009'' AND Hdr.CustShipLoc=''15''', 'Branch = ''15''', 'Y', '7/26/2009', '8/27/2009'
	-- EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''7/26/2009'' AND Hdr.ARPostDt<= ''8/27/2009'' AND Hdr.CustShipLoc=''15''', 'Branch = ''15''', 'N', '7/26/2009', '8/27/2009'
	--
	-- EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''12/27/2009'' AND Hdr.ARPostDt<= ''2/6/2010''', '1=1', 'N', '12/27/2009', '2/6/2010'
	-- EXEC [pSalesPerformRpt] 'Hdr.ARPostDt>= ''12/27/2009'' AND Hdr.ARPostDt<= ''2/6/2010''', 'RegionalMgr = ''Kevin Chavis''', 'N', '12/27/2009', '2/6/2010'
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	SELECT @totWorkDays = count(*) FROM FiscalCalendar WHERE CurrentDt >= @startDt AND CurrentDt <= @endDt AND WorkDay=1

	----------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------
	--													--
	--	NOTE:	The length of the query requires it to be split across multiple NVARCHAR strings.	--
	--		The two strings are then executed together as follows: EXEC (@strSql + @strSql2).	--
	--													--
	----------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------

SET @strSql =
'SELECT	isnull(tAllCustSales.Branch, tAllCust.CustShipLocation) AS Branch,
	isnull(tAllCustSales.CustNo, tAllCust.CustNo) AS CustNo,
	isnull(tAllCust.CustName,'''') AS CustName,
	isnull(tAllCust.ChainCd,'''') AS Chain,
	isnull(tAllCust.PriceCd,'''') AS PriceCd,
	isnull(tAllCustSales.NetSales,0) AS NetSales,
	isnull(tAllCustSales.GMDollar,0) AS GMDollar,
	isnull(tAllCustSales.GMPct,0) AS GMPct,
	isnull(tAllCust.WeeklySalesGoal,0) / 5 * ' + @totWorkDays + ' AS GoalGMDol,
	--isnull(tAllCust.GrossMarginPct ,0) * 100 AS GoalGMPct,
	isnull(tAllCust.GrossMarginPct ,0) AS GoalGMPct,
	isnull(tAllCustSales.TotWgt,0) AS TotWgt,							
	isnull(tAllCustSales.ECommSales,0) AS ECommSales,
	isnull(tAllCustSales.ECommGMDollar,0) AS ECommGMDollar,
	isnull(tAllCustSales.eCommGMPct,0) AS eCommGMPct,
	isnull(tAllCustSales.State,'''') AS State,
	isnull(tAllCust.SalesTerritory,'''') AS SalesTerritory,
	CAST(ISNULL(tAllCust.InsideRep,'''') AS varchar(250)) AS InsideRep,
	CAST(ISNULL(tAllCust.OutsideRep,'''') AS varchar(250)) AS OutsideRep,
	CAST(ISNULL(tRegionLoc.RegionalMgr,''Open'') AS varchar(250)) AS RegionalMgr,
	isnull(tAllCust.WebUserCnt,0) as WebUserCnt,
	isnull(tAllCust.InxsUserCnt,0) as InxsUserCnt,
	isnull(tAllCust.DCUserCnt,0) as DCUserCnt,
	isnull(tAllCust.SDKUserCnt,0) as SDKUserCnt,
	isnull(tAllCust.XrefCnt,0) as XrefCnt,
	isnull(tAllCust.BuyGroup,'''') as BuyGroup
 FROM	--tAllCust
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
		OutsideRep.RepName AS OutsideRep,
		CM.WebUserCnt,
		CM.InxsUserCnt,
		CM.DCUserCnt,
		CM.SDKUserCnt,
		CM.XrefCnt,
		CM.BuyGroup
	 FROM	CustomerMaster CM (NoLock) LEFT OUTER JOIN
		RepMaster InsideRep (NoLock)
	 ON	InsideRep.RepNo = CM.SupportRepNo LEFT OUTER JOIN
		RepMaster OutsideRep (NoLock)
	 ON	OutsideRep.RepNo = CM.SlsRepNo
	 -- Removed per Bob P on 12/03/2010
	 --WHERE	isnull(CM.CreditInd,'''') not in (''X'',''E'')
	 WHERE	(isnull(CM.DeleteDt,'''') = '''') AND (isnull(CM.CustCd,'''') <> ''BT'')) tAllCust LEFT OUTER JOIN
	--tRegionLoc
	(SELECT	RegionalMgr.SalesRegionNo,
		RegionalMgr.RepName AS RegionalMgr,
		RegionalLoc.LocID
	 FROM	RepMaster RegionalMgr (NoLock) INNER JOIN
		LocMaster RegionalLoc (NoLock)
	 ON	RegionalMgr.SalesRegionNo = RegionalLoc.SalesRegionNo
	 WHERE	RepClass=''R'') tRegionLoc
	ON	tAllCust.CustShipLocation = tRegionLoc.LocID '

if (@allCustFlg = 'Y')
     SET @strSql = @strSql + 'LEFT OUTER JOIN'
else
     SET @strSql = @strSql + 'INNER JOIN'

SET @strSql = @strSql + '
	--tAllCustSales
	(SELECT	tSales.Branch,
		tSales.CustNo,
		sum(tSales.NetSales) AS NetSales,
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
			SUM(Hdr.NetSales - Hdr.TotalCost) AS GMDollar, 
			CASE WHEN SUM(Hdr.NetSales) = 0 THEN 0 ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END AS GMPct,
			SUM(Hdr.ShipWght) AS TotWgt, 
			CASE WHEN List.SequenceNo = 1 THEN SUM(isnull(Hdr.NetSales,0)) ELSE 0 END AS ECommSales,
			CASE WHEN List.SequenceNo = 1 THEN isnull(SUM(Hdr.NetSales - Hdr.TotalCost),0) ELSE 0 END AS ECommGMDollar,
			max(Hdr.BillToState) AS State
		 FROM	SOHeaderHist Hdr (NoLock) LEFT OUTER JOIN'

SET @strSql2 =
'		--Cust
		(SELECT	CustNo
		 FROM	CustomerMaster (NoLock)) Cust
		ON	Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
		--List
		(SELECT	LM.ListName,
			LD.ListValue,
			LD.ListDtlDesc,
			LD.SequenceNo
		 FROM	ListMaster LM (NoLock) INNER JOIN
			ListDetail LD (NoLock)
		 ON	LM.pListMasterID=LD.fListMasterID
		 WHERE	LM.ListName = ''SOEOrderSource'') List
		ON	List.ListValue = Hdr.OrderSource
		WHERE	' +  @whereSales + '
		GROUP BY Hdr.SellToCustNo, Hdr.CustShipLoc, List.SequenceNo) tSales
	 GROUP BY tSales.CustNo, tSales.Branch, tSales.State) tAllCustSales
 ON	tAllCust.CustNo = tAllCustSales.CustNo
 WHERE	' +  @whereCust + '
 ORDER BY CustNo, Branch'

print @strSql
print @strSql2

--EXEC sp_executesql @strSql 
EXEC (@strSql + @strSql2)

END

