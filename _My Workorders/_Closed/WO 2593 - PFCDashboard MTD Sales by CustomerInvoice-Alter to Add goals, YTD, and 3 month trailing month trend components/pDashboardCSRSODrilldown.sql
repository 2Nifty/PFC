--exec [pDashboardCSRSODrilldown] '00', '000000', '**********', 'gyanez', 'MTD', 'Header'


--USE [PERP]
--GO

drop proc [pDashboardCSRSODrilldown]
go


/****** Object:  StoredProcedure [dbo].[pDashboardCSRSODrilldown]    Script Date: 10/20/2011 11:25:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[pDashboardCSRSODrilldown]
@Loc varchar(20),
@CustNo varchar(20),
@InvoiceNo varchar(20),
@csrName varchar(20),
@period varchar(20), -- MTD/Daily
@reportType varchar(10) -- Header/Detail
as

----[pDashboardCSRSODrilldownDaily]
----Written By: Sathish
----Application: CSR performance report

Declare	@CurDay		datetime	--Current DashBoard Date
Declare	@CurEndDay	datetime	--Current DashBoard End Date

	If @period = 'Daily'
	Begin
		Set	@Curday = (SELECT BegDate FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
		Set	@CurEndDay = (SELECT EndDate FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
	End
	Else If @period = 'MTD'
	Begin
		Select	@Curday=BegDate,@CurEndDay=EndDate 
		From	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges	
		Where	DashboardParameter='CurrentMonth'
	End
	--SELECT	@CurDay as CurDay, @CurEndDay as CurEndDay

	-- Get data for # order row in CSR performance report
	If(@reportType = 'Header') 
		Begin
			-- Sales Order Header By Invoice
			IF @CustNo = '******'
				BEGIN
				
				SELECT	DISTINCT
						OrderDtl.CustNo,
						OrderDtl.CustName,
						OrderSum.InvoiceNo,
						OrderDtl.Location,
						OrderDtl.ArPostDt,
						OrderDtl.OrderSource,			
						ISNULL(OrderSum.SalesDollars,0) AS SalesDollars,
						ISNULL(OrderSum.Lbs,0) AS Lbs,
						ISNULL(OrderSum.SalesPerLb,0) AS SalesPerLb,
						ISNULL(OrderSum.MarginDollars,0) AS MarginDollars,
						ISNULL(OrderSum.MarginPct,0) AS MarginPct,
						ISNULL(OrderSum.MarginPerLb,0) AS MarginPerLb
				FROM	(
							SELECT	InvoiceNo,
									SUM(NetSales) AS SalesDollars,
									SUM(ShipWght) AS Lbs,
									CASE SUM(ShipWght) WHEN 0 THEN 0 ELSE SUM(NetSales) / SUM(ShipWght) END AS SalesPerLb,
									SUM(NetSales) - SUM(TotalCost) AS MarginDollars,
									CASE SUM(ShipWght) WHEN 0 THEN 0 ELSE (SUM(NetSales) - SUM(TotalCost)) / SUM(ShipWght)	END AS MarginPerLb,
									CASE SUM(NetSales) WHEN 0 THEN 0 ELSE ((SUM(NetSales) - SUM(TotalCost)) / SUM(NetSales)) * 100 END AS MarginPct
							FROM	SOHeaderHist (NOLOCK)
							WHERE	(InvoiceDt between @CurDay and @CurEndDay)
									and DeleteDt is null
									and SellToCustNo in
										(	select	CustNo	
											from	CustomerMaster (NOLOCK) CM Left Outer Join 
													RepMaster (NOLOCK) RM
													On CM.SupportRepNo = RM.RepNo						
											Where	RM.RepNotes like @csrName)
							 GROUP BY InvoiceNo
						) OrderSum
					INNER JOIN
					(
						SELECT	SellToCustNo as CustNo,
								SellToCustName as CustName,
								InvoiceNo,
								CustShipLoc as Location,
								InvoiceDt as ArPostDt,
								OrderSource
						FROM	SOHeaderHist (NOLOCK)
						WHERE	(InvoiceDt between @CurDay and @CurEndDay)
								and DeleteDt is null
								and SellToCustNo in
								(	Select	CustNo	
									From	CustomerMaster (NOLOCK) CM Left Outer Join 
											RepMaster (NOLOCK) RM
											On CM.SupportRepNo = RM.RepNo						
									Where	RM.RepNotes like @csrName )
					) OrderDtl
					ON	OrderSum.InvoiceNo = OrderDtl.InvoiceNo

			   END

			-- Sales Order Header By Customer
			IF @CustNo = '000000'
			   BEGIN
				SELECT	CustAll.CustNo,
						CustAll.CustName,
						ISNULL(CustAll.SalesDollars,0) AS SalesDollars,
						ISNULL(CustAll.Lbs,0) AS Lbs,
						ISNULL(CustAll.SalesPerLb,0) AS SalesPerLb,
						ISNULL(CustAll.MarginDollars,0) AS MarginDollars,
						ISNULL(CustAll.MarginPerLb,0) AS MarginPerLb,
						ISNULL(CustAll.MarginPct,0) AS MarginPct,

						ISNULL(DCSG.MTDGoalDol,0) as MTDGoalDol,
						ISNULL(DCSG.MTDGoalGMPct,0) as MTDGoalGMPct,
						ISNULL(DCSG.MTDGoalDol,0) * ISNULL(DCSG.MTDGoalGMPct,0) as MTDGoalMgnDol,
						ISNULL(DCSG.YTDSalesDol,0) as YTDSalesDol,
						ISNULL(DCSG.YTDGoalDol,0) as YTDGoalDol,
						ISNULL(DCSG.YTDGoalGMPct,0) as YTDGoalGMPct,
						ISNULL(DCSG.YTDGoalDol,0) * ISNULL(DCSG.YTDGoalGMPct,0) as YTDGoalMgnDol,

						ISNULL(DCSG.PrevMth1SalesDol,0) as PrevMth1SalesDol,
						ISNULL(DCSG.PrevMth2SalesDol,0) as PrevMth2SalesDol,
						ISNULL(DCSG.PrevMth3SalesDol,0) as PrevMth3SalesDol,
						ISNULL(DCSG.PrevMth1GMPct,0) as PrevMth1GMPct,
						ISNULL(DCSG.PrevMth2GMPct,0) as PrevMth2GMPct,
						ISNULL(DCSG.PrevMth3GMPct,0) as PrevMth3GMPct,

						ISNULL(CustWeb.SalesDollarsWeb,0) AS SalesDollarsWeb,
						ISNULL(CustWeb.MarginDollarsWeb,0) AS MarginDollarsWeb,
						ISNULL(CustWeb.MarginPctWeb,0) AS MarginPctWeb,
						CASE ISNULL(CustAll.SalesDollars,0) WHEN 0 THEN 0 ELSE ISNULL(CustWeb.SalesDollarsWeb,0) / CustAll.SalesDollars * 100 END AS WebPctSales
				FROM	--CustAll
						(SELECT	SellToCustNo as CustNo,
								SellToCustName as CustName,
								SUM(NetSales) AS SalesDollars,
								SUM(ShipWght) AS Lbs,
								CASE SUM(ShipWght) WHEN 0 THEN 0 ELSE SUM(NetSales) / SUM(ShipWght) END AS SalesPerLb,
								SUM(NetSales) - SUM(TotalCost) AS MarginDollars,
								CASE SUM(ShipWght) WHEN 0 THEN 0 ELSE (SUM(NetSales) - SUM(TotalCost)) / SUM(ShipWght) END AS MarginPerLb,
								CASE SUM(NetSales) WHEN 0 THEN 0 ELSE ((SUM(NetSales) - SUM(TotalCost)) / SUM(NetSales)) * 100 END AS MarginPct
						 FROM	SOHeaderHist (NOLOCK)
						 WHERE	(InvoiceDt between @CurDay and @CurEndDay) AND DeleteDt is null
								and SellToCustNo in (SELECT	CustNo	
													 FROM	CustomerMaster (NOLOCK) CM Left Outer Join 
															RepMaster (NOLOCK) RM
													 ON		CM.SupportRepNo = RM.RepNo						
													 WHERE	RM.RepNotes like @csrName)
						 GROUP BY SellToCustNo, SellToCustName) CustAll
				LEFT OUTER JOIN
						--CustWeb
						(SELECT	SellToCustNo as CustNo,
								SellToCustName as CustName,
								SUM(NetSales) AS SalesDollarsWeb,
								SUM(NetSales) - SUM(TotalCost) AS MarginDollarsWeb,
								CASE SUM(NetSales) WHEN 0 THEN 0 ELSE ((SUM(NetSales) - SUM(TotalCost)) / SUM(NetSales)) * 100 END AS MarginPctWeb
						 FROM	SOHeaderHist (NOLOCK)
						 WHERE	(InvoiceDt between @CurDay and @CurEndDay) AND DeleteDt is null
								and OrderSource In ('DC','IX','WQ','FP','EI') 
								and SellToCustNo in (SELECT	CustNo	
													 FROM	CustomerMaster (NOLOCK) CM Left Outer Join 
															RepMaster (NOLOCK) RM
													 ON		CM.SupportRepNo = RM.RepNo						
													 WHERE	RM.RepNotes like @csrName)					
						 GROUP BY SellToCustNo, SellToCustName) CustWeb
				ON		CustAll.CustNo = CustWeb.CustNo
				LEFT OUTER JOIN
						DashboardCustSalesGoal DCSG
				ON		DCSG.CustNo = CustAll.CustNo

select 'Sales Order Header By Customer'

			   END
		END
	If(@reportType = 'Detail') 
		Begin			
			SELECT	SOH.SellToCustNo as CustNo
					,SOH.SellToCustName as CustName
					,SOH.InvoiceNo
					,SOH.CustShipLoc as Location
					,SOH.ArPostDt
					,SOH.OrderSource
					,SOD.LineNumber
					,SOD.ItemNo
					,ISNULL(ExtendedPrice,0) AS SalesDollars
					,ISNULL(ExtendedNetWght,0) AS Lbs		
					,Cast((isnull(Case when ExtendedNetWght = 0 then 0  else ( ExtendedPrice / ExtendedNetWght ) End,0)) as Decimal(18,2))  as SalesPerLb
					,Cast(isnull((ExtendedPrice - ExtendedCost),0) as Decimal(18,2)) as MarginDollars
					,Cast((isnull(Case when ExtendedPrice = 0 then 0  else (((ExtendedPrice-ExtendedCost) /ExtendedPrice) * 100) End,0) ) as Decimal(18,2)) as MarginPct
					,Cast((Case when ExtendedNetWght = 0 then 0  else ((ExtendedPrice-ExtendedCost)/ExtendedNetWght) End)  as Decimal(18,2))  as MarginPerLb
			FROM	SODetailHist SOD Left Outer Join SOHeaderHist SOH
					On  SOD.fSOHeaderHistID = SOH.pSOHeaderHistID
			WHERE	(SOH.InvoiceDt between @CurDay and @CurEndDay)
					and SOH.SellToCustNo in
					(	Select	CustNo	
						From	CustomerMaster (NOLOCK) CM Left Outer Join 
								RepMaster (NOLOCK) RM
								On CM.SupportRepNo = RM.RepNo						
						Where	RM.RepNotes like @csrName )
		End

-- Exec [pDashboardCSRSODrilldown] '00','000000','**********','KVESNESKI','MTD'