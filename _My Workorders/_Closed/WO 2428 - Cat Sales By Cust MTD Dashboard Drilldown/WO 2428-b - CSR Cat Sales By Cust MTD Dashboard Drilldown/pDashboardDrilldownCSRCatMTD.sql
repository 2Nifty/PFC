USE [PERP]
GO

drop proc [pDashboardDrilldownCSRCatMTD]
go


/****** Object:  StoredProcedure [dbo].[pDashboardDrilldownCSRCatMTD]    Script Date: 06/30/2011 12:02:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[pDashboardDrilldownCSRCatMTD]
	@CSR varchar(50),
	@Cat varchar(50)

as

	--[pDashboardDrilldownCSRCatMTD]
	--Written By: TMD - 6/30/11
	--Application: CSR performance report by Category

	DECLARE	@CurMth varchar(6),
			@CurMthBegDt datetime,
			@CurMthEndDt datetime,
			@LastMth varchar(6),
			@LastMthBegDt datetime,
			@LastMthEndDt datetime,
			@PrevMth varchar(6),
			@PrevMthBegDt datetime,
			@PrevMthEndDt datetime

	--Assign Current Month
	SELECT	@CurMth = (YearValue * 100) + MonthValue,
			@CurMthBegDt = BegDate,
			@CurMthendDt = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges
--	FROM	DashboardRanges (NoLock)
	WHERE	DashboardParameter = 'CurrentMonth'

	--Assign Last Closed Month
	SELECT	@LastMth = (YearValue * 100) + MonthValue,
			@LastMthBegDt = BegDate,
			@LastMthEndDt = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
--	FROM	CuvnalRanges (NoLock)
	WHERE	CuvnalParameter = 'CurrentMonth'

	--Assign Previous Closed Month
	SELECT	@PrevMth = (YearValue * 100) + MonthValue,
			@PrevMthBegDt = BegDate,
			@PrevMthEndDt = EndDate
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
--	FROM	CuvnalRanges (NoLock)
	WHERE	CuvnalParameter = 'PreviousMonth'

	/*
	select	@CurMth as CurMth, @CurMthBegDt as CurMthBegDt, @CurMthEndDt as CurMthEndDt, @LastMth as LastMth, @LastMthBegDt as LastMthBegDt, @LastMthEndDt as LastMthEndDt, @PrevMth as PrevMth, @PrevMthBegDt as PrevMthBegDt, @PrevMthEndDt as PrevMthEndDt

	declare @CSR varchar(50), @Cat varchar(50)
	set @CSR = 'lmoore'
	set @Cat = '00250'
	*/

	--#tCustList - CustNo list by CSR
	SELECT	CM.CustNo,
			CM.CustName,
			RM.RepNotes as CSR,
			RM.RepName as CSRName
	INTO	#tCustList
	FROM	CustomerMaster (NOLOCK) CM Left Outer Join
			RepMaster (NOLOCK) RM
	ON		CM.SupportRepNo = RM.RepNo
	WHERE	RM.RepNotes like @CSR


	--Table[0]
	SELECT	tCurMth.CustNo,
			tCurMth.CustName,
			isnull(tCurMth.SalesDollars,0) as SalesDollars,
			isnull(tCurMth.Lbs,0) as Lbs,
			isnull(tCurMth.SalesPerLb,0) as SalesPerLb,
			isnull(tCurMth.MarginDollars,0) as MarginDollars,
			isnull(tCurMth.MarginPct,0) as MarginPct,
			isnull(tLastMth.SalesDollars,0) as LMSalesDollars,
			isnull(tLastMth.Lbs,0) as LMLbs,
			isnull(tLastMth.SalesPerLb,0) as LMSalesPerLb,
			isnull(tLastMth.MarginDollars,0) as LMMarginDollars,
			isnull(tLastMth.MarginPct,0) as LMMarginPct,
			isnull(tPrevMth.SalesDollars,0) as PMSalesDollars,
			isnull(tPrevMth.Lbs,0) as PMLbs,
			isnull(tPrevMth.SalesPerLb,0) as PMSalesPerLb,
			isnull(tPrevMth.MarginDollars,0) as PMMarginDollars,
			isnull(tPrevMth.MarginPct,0) as PMMarginPct
	FROM
	--Current Month [tCurMth]
	(	SELECT	Cust.CustNo
				,isnull(Cust.CustName, '* undefined *') as CustName
				,Sum(ISNULL(SOD.ExtendedPrice,0)) AS SalesDollars
				,Sum(ISNULL(SOD.ExtendedNetWght,0)) AS Lbs		
				,Cast((isnull(Case	When SUM(SOD.ExtendedNetWght) = 0 Then 0  
									Else ( SUM(SOD.ExtendedPrice) / SUM(SOD.ExtendedNetWght) ) End,0)) as Decimal(18,2))  as SalesPerLb
				,Cast(isnull((SUM(SOD.ExtendedPrice) - SUM(SOD.ExtendedCost)),0) as Decimal(18,2)) as MarginDollars
				,Cast((isnull(Case	When SUM(SOD.ExtendedPrice) = 0 Then 0  
									Else (((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost)) /SUM(SOD.ExtendedPrice)) * 100) End,0) ) as Decimal(18,2)) as MarginPct
--				,Cast((Case When SUM(SOD.ExtendedNetWght) = 0 Then 0  
--							Else ((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost))/SUM(SOD.ExtendedNetWght)) End)  as Decimal(18,2))  as MarginPerLb
		FROM	SOHeaderHist (NOLOCK) SOH INNER JOIN
				SODetailHist (NOLOCK) SOD
		ON		SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
				#tCustList (NOLOCK) Cust
		ON		SOH.SellToCustNo = Cust.CustNo
		WHERE	(SOH.InvoiceDt between @CurMthBegDt and @CurMthEndDt) and
--				SOH.SellToCustNo in (SELECT CustNo from #tCustList) and
				SUBSTRING(SOD.ItemNo, 0, 6) = @Cat and
				SOH.DeleteDt is null and SOD.DeleteDt is null		
		GROUP BY Cust.CustNo, Cust.CustName
	)	tCurMth

	LEFT OUTER JOIN

	--Last Closed Month [tLastMth]
	(	SELECT	Cust.CustNo
				,Sum(ISNULL(SOD.ExtendedPrice,0)) AS SalesDollars
				,Sum(ISNULL(SOD.ExtendedNetWght,0)) AS Lbs		
				,Cast((isnull(Case	When SUM(SOD.ExtendedNetWght) = 0 Then 0  
									Else ( SUM(SOD.ExtendedPrice) / SUM(SOD.ExtendedNetWght) ) End,0)) as Decimal(18,2))  as SalesPerLb
				,Cast(isnull((SUM(SOD.ExtendedPrice) - SUM(SOD.ExtendedCost)),0) as Decimal(18,2)) as MarginDollars
				,Cast((isnull(Case	When SUM(SOD.ExtendedPrice) = 0 Then 0  
									Else (((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost)) /SUM(SOD.ExtendedPrice)) * 100) End,0) ) as Decimal(18,2)) as MarginPct
--				,Cast((Case When SUM(SOD.ExtendedNetWght) = 0 Then 0  
--							Else ((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost))/SUM(SOD.ExtendedNetWght)) End)  as Decimal(18,2))  as MarginPerLb
		FROM	SOHeaderHist (NOLOCK) SOH INNER JOIN
				SODetailHist (NOLOCK) SOD
		ON		SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
				#tCustList (NOLOCK) Cust
		ON		SOH.SellToCustNo = Cust.CustNo
		WHERE	(SOH.InvoiceDt between @LastMthBegDt and @LastMthEndDt) and
--				SOH.SellToCustNo in (SELECT CustNo from #tCustList) and
				SUBSTRING(SOD.ItemNo, 0, 6) = @Cat and
				SOH.DeleteDt is null and SOD.DeleteDt is null		
		GROUP BY Cust.CustNo, Cust.CustName
	) tLastMth

	ON	tCurMth.CustNo = tLastMth.CustNo
	LEFT OUTER JOIN

	--Prev Closed Month [tPrevMth]
	(	SELECT	Cust.CustNo
				,Sum(ISNULL(SOD.ExtendedPrice,0)) AS SalesDollars
				,Sum(ISNULL(SOD.ExtendedNetWght,0)) AS Lbs		
				,Cast((isnull(Case	When SUM(SOD.ExtendedNetWght) = 0 Then 0  
									Else ( SUM(SOD.ExtendedPrice) / SUM(SOD.ExtendedNetWght) ) End,0)) as Decimal(18,2))  as SalesPerLb
				,Cast(isnull((SUM(SOD.ExtendedPrice) - SUM(SOD.ExtendedCost)),0) as Decimal(18,2)) as MarginDollars
				,Cast((isnull(Case	When SUM(SOD.ExtendedPrice) = 0 Then 0  
									Else (((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost)) /SUM(SOD.ExtendedPrice)) * 100) End,0) ) as Decimal(18,2)) as MarginPct
--				,Cast((Case When SUM(SOD.ExtendedNetWght) = 0 Then 0  
--							Else ((SUM(SOD.ExtendedPrice)-SUM(SOD.ExtendedCost))/SUM(SOD.ExtendedNetWght)) End)  as Decimal(18,2))  as MarginPerLb
		FROM	SOHeaderHist (NOLOCK) SOH INNER JOIN
				SODetailHist (NOLOCK) SOD
		ON		SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
				#tCustList (NOLOCK) Cust
		ON		SOH.SellToCustNo = Cust.CustNo
		WHERE	(SOH.InvoiceDt between @PrevMthBegDt and @PrevMthEndDt) and
--				SOH.SellToCustNo in (SELECT CustNo from #tCustList) and
				SUBSTRING(SOD.ItemNo, 0, 6) = @Cat and
				SOH.DeleteDt is null and SOD.DeleteDt is null		
		GROUP BY Cust.CustNo, Cust.CustName
	) tPrevMth
	ON	tCurMth.CustNo = tPrevMth.CustNo

	DROP TABLE #tCustList
go

-- Exec [pDashboardDrilldownCSRCatMTD] 'lmoore','00250'
-- Exec pDashboardCSRDrilldown 'lmoore','MTD'

