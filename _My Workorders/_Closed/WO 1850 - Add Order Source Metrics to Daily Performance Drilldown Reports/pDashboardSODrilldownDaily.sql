if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pDashboardSODrilldownDaily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pDashboardSODrilldownDaily]
GO

CREATE procedure [dbo].[pDashboardSODrilldownDaily]
@Loc varchar(20),
@CustNo varchar(20),
@InvoiceNo varchar(20)
as

----pDashboardSODrilldownDaily
----Written By: Tod Dixon
----Application: Sales Management

DECLARE	@CurDay		DATETIME	--Current DashBoard Date
DECLARE	@CurEndDay	DATETIME	--Current DashBoard End Date

SET	@Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET	@CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
--SELECT	@CurDay as CurDay, @CurEndDay as CurEndDay

--Customer Number Detail Drilldown
IF @CustNo <> '000000' AND @CustNo <> '******'
   BEGIN
	SELECT	DISTINCT
		OrderDtl.CustNo,
		OrderDtl.CustName,
		OrderSum.InvoiceNo,
		OrderDtl.Location,
		OrderDtl.ArPostDt,
		OrderDtl.OrderSource,
		OrderDtl.OrderSourceSeq,
		ISNULL(OrderSum.SalesDollars,0) AS SalesDollars,
		ISNULL(OrderSum.Lbs,0) AS Lbs,
		ISNULL(OrderSum.SalesPerLb,0) AS SalesPerLb,
		ISNULL(OrderSum.MarginDollars,0) AS MarginDollars,
		ISNULL(OrderSum.MarginPct,0) AS MarginPct,
		ISNULL(OrderSum.MarginPerLb,0) AS MarginPerLb
	FROM	(SELECT	InvoiceNo,
			SUM(SalesDollars) AS SalesDollars,
			SUM(Lbs) AS Lbs,
			CASE SUM(LBS)
			   WHEN 0 THEN 0
				  ELSE SUM(SalesDollars) / SUM(Lbs)
			END AS SalesPerLb,
			SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
			CASE SUM(LBS)
			   WHEN 0 THEN 0
				  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
			END AS MarginPerLb,
			CASE SUM(SalesDollars)
			   WHEN 0 THEN 0
				  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
			END AS MarginPct
		 FROM	DashboardCustInvDaily
		 WHERE	CustNo = @CustNo and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)
		 GROUP BY InvoiceNo) OrderSum
		INNER JOIN
		(SELECT	CustNo,
			CustName,
			InvoiceNo,
			Location,
			ArPostDt,
			OrderSource,
			OrderSourceSeq
		 FROM	DashboardCustInvDaily
		 WHERE	CustNo = @CustNo and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)) OrderDtl
		ON	OrderSum.InvoiceNo = OrderDtl.InvoiceNo

	SELECT	'--Customer Number Detail Drilldown (' + @CustNo + ')'
   END

--Invoice Number Detail Drilldown
IF @InvoiceNo <> '0000000000' AND @InvoiceNo <> '**********'
   BEGIN
	SET	@CustNo = (SELECT DISTINCT CustNo FROM DashboardCustInvDaily WHERE InvoiceNo = @InvoiceNo)
--	SELECT	@CustNo

	SELECT	DISTINCT
		CustNo,
		CustName,
		InvoiceNo,
		Location,
		ArPostDt,
		OrderSource,
		OrderSourceSeq,
		LineNumber,
		ItemNo,
		ISNULL(SalesDollars,0) AS SalesDollars,
		ISNULL(Lbs,0) AS Lbs,
		ISNULL(SalesPerLb,0) AS SalesPerLb,
		ISNULL(MarginDollars,0) AS MarginDollars,
		ISNULL(MarginPct,0) * 100 AS MarginPct,
		ISNULL(MarginPerLb,0) AS MarginPerLb
	FROM	DashboardCustInvDaily
	WHERE	InvoiceNo = @InvoiceNo

	SELECT	'--Invoice Number Detail Drilldown (' + @InvoiceNo + ')'
   END

IF @Loc = '00'		--ALL LOCATIONS
   BEGIN
	--Invoice Line Item Detail Drilldown
	IF @CustNo = '000000' AND @InvoiceNo = '0000000000'
	   BEGIN
		SET	@CustNo = '~~~~~~'

		SELECT	DISTINCT
			CustNo,
			CustName,
			InvoiceNo,
			Location,
			ArPostDt,
			OrderSource,
			OrderSourceSeq,
			LineNumber,
			ItemNo,
			ISNULL(SalesDollars,0) AS SalesDollars,
			ISNULL(Lbs,0) AS Lbs,
			ISNULL(SalesPerLb,0) AS SalesPerLb,
			ISNULL(MarginDollars,0) AS MarginDollars,
			ISNULL(MarginPct,0) * 100 AS MarginPct,
			ISNULL(MarginPerLb,0) AS MarginPerLb
		FROM	DashboardCustInvDaily
		WHERE	ItemNo IS NOT NULL and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)

		SELECT	'--Invoice Line Item Detail Drilldown (All Locations)'
	   END

	--Report A - Sales Order Header Level
	IF @CustNo = '******'
	   BEGIN
		SELECT	DISTINCT
			OrderDtl.CustNo,
			OrderDtl.CustName,
			OrderSum.InvoiceNo,
			OrderDtl.Location,
			OrderDtl.ArPostDt,
			OrderDtl.OrderSource,
			OrderDtl.OrderSourceSeq,
			ISNULL(OrderSum.SalesDollars,0) AS SalesDollars,
			ISNULL(OrderSum.Lbs,0) AS Lbs,
			ISNULL(OrderSum.SalesPerLb,0) AS SalesPerLb,
			ISNULL(OrderSum.MarginDollars,0) AS MarginDollars,
			ISNULL(OrderSum.MarginPct,0) AS MarginPct,
			ISNULL(OrderSum.MarginPerLb,0) AS MarginPerLb
		FROM	(SELECT	InvoiceNo,
				SUM(SalesDollars) AS SalesDollars,
				SUM(Lbs) AS Lbs,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE SUM(SalesDollars) / SUM(Lbs)
				END AS SalesPerLb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
				END AS MarginPerLb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPct
			 FROM	DashboardCustInvDaily
			 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
			 GROUP BY InvoiceNo) OrderSum
			INNER JOIN
			(SELECT	CustNo,
				CustName,
				InvoiceNo,
				Location,
				ArPostDt,
				OrderSource,
				OrderSourceSeq
			 FROM	DashboardCustInvDaily
			 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay) OrderDtl
			ON	OrderSum.InvoiceNo = OrderDtl.InvoiceNo

		SELECT	'--Report A - Sales Order Header Level (All Locations)'
	   END

	--Report B - Customer Sales Order Level
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
			ISNULL(CustWeb.SalesDollarsWeb,0) AS SalesDollarsWeb,
			ISNULL(CustWeb.MarginDollarsWeb,0) AS MarginDollarsWeb,
			ISNULL(CustWeb.MarginPctWeb,0) AS MarginPctWeb,
			CASE ISNULL(CustAll.SalesDollars,0)
			   WHEN 0 THEN 0
				  ELSE ISNULL(CustWeb.SalesDollarsWeb,0) / CustAll.SalesDollars * 100
			   END AS WebPctSales
		FROM	(SELECT	CustNo,
				CustName,
				SUM(SalesDollars) AS SalesDollars,
				SUM(Lbs) AS Lbs,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE SUM(SalesDollars) / SUM(Lbs)
				END AS SalesPerLb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
				END AS MarginPerLb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPct
			 FROM	DashboardCustInvDaily
			 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
			 GROUP BY CustNo, CustName) CustAll
			LEFT OUTER JOIN
			(SELECT	CustNo,
				CustName,
				SUM(SalesDollars) AS SalesDollarsWeb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollarsWeb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPctWeb
			 FROM	DashboardCustInvDaily
			 WHERE	(ARPostDt = @CurDay or ARPostDt = @CurEndDay) and OrderSourceSeq = 1
				--OrderSource IS NOT NULL and OrderSource <> '' and OrderSource <> 'M'
			 GROUP BY CustNo, CustName) CustWeb
			ON	CustAll.CustNo = CustWeb.CustNo

		SELECT	'--Report B - Customer Sales Order Level (All Locations)'
	   END
   END
ELSE			--SPECIFIC LOCATION
   BEGIN
	--Invoice Line Item Detail Drilldown
	IF @CustNo = '000000' AND @InvoiceNo = '0000000000'
	   BEGIN
		SET	@CustNo = '~~~~~~'

		SELECT	DISTINCT
			CustNo,
			CustName,
			InvoiceNo,
			Location,
			ArPostDt,
			OrderSource,
			OrderSourceSeq,
			LineNumber,
			ItemNo,
			ISNULL(SalesDollars,0) AS SalesDollars,
			ISNULL(Lbs,0) AS Lbs,
			ISNULL(SalesPerLb,0) AS SalesPerLb,
			ISNULL(MarginDollars,0) AS MarginDollars,
			ISNULL(MarginPct,0) * 100 AS MarginPct,
			ISNULL(MarginPerLb,0) AS MarginPerLb
		FROM	DashboardCustInvDaily
		WHERE	Location = @Loc AND ItemNo IS NOT NULL and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)

		SELECT	'--Invoice Line Item Detail Drilldown (SPECIFIC LOCATION: ' + @Loc + ')'
	   END

	--Report A - Sales Order Header Level
	IF @CustNo = '******'
	   BEGIN
		SELECT	DISTINCT
			OrderDtl.CustNo,
			OrderDtl.CustName,
			OrderSum.InvoiceNo,
			OrderDtl.Location,
			OrderDtl.ArPostDt,
			OrderDtl.OrderSource,
			OrderDtl.OrderSourceSeq,
			ISNULL(OrderSum.SalesDollars,0) AS SalesDollars,
			ISNULL(OrderSum.Lbs,0) AS Lbs,
			ISNULL(OrderSum.SalesPerLb,0) AS SalesPerLb,
			ISNULL(OrderSum.MarginDollars,0) AS MarginDollars,
			ISNULL(OrderSum.MarginPct,0) AS MarginPct,
			ISNULL(OrderSum.MarginPerLb,0) AS MarginPerLb
		FROM	(SELECT	InvoiceNo,
				SUM(SalesDollars) AS SalesDollars,
				SUM(Lbs) AS Lbs,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE SUM(SalesDollars) / SUM(Lbs)
				END AS SalesPerLb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
				END AS MarginPerLb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPct
			 FROM	DashboardCustInvDaily
			 WHERE	Location = @Loc AND (ARPostDt = @CurDay OR ARPostDt = @CurEndDay)
			 GROUP BY InvoiceNo) OrderSum
			INNER JOIN
			(SELECT	CustNo,
				CustName,
				InvoiceNo,
				Location,
				ArPostDt,
				OrderSource,
				OrderSourceSeq
			 FROM	DashboardCustInvDaily
			 WHERE	Location = @Loc AND (ARPostDt = @CurDay OR ARPostDt = @CurEndDay)) OrderDtl
			ON	OrderSum.InvoiceNo = OrderDtl.InvoiceNo

		SELECT	'--Report A - Sales Order Header Level (SPECIFIC LOCATION: ' + @Loc + ')'
	   END

	--Report B - Customer Sales Order Level
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
			ISNULL(CustWeb.SalesDollarsWeb,0) AS SalesDollarsWeb,
			ISNULL(CustWeb.MarginDollarsWeb,0) AS MarginDollarsWeb,
			ISNULL(CustWeb.MarginPctWeb,0) AS MarginPctWeb,
			CASE ISNULL(CustAll.SalesDollars,0)
			   WHEN 0 THEN 0
				  ELSE ISNULL(CustWeb.SalesDollarsWeb,0) / CustAll.SalesDollars * 100
			   END AS WebPctSales
		FROM	(SELECT	CustNo,
				CustName,
				SUM(SalesDollars) AS SalesDollars,
				SUM(Lbs) AS Lbs,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE SUM(SalesDollars) / SUM(Lbs)
				END AS SalesPerLb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollars,
				CASE SUM(LBS)
				   WHEN 0 THEN 0
					  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(Lbs)
				END AS MarginPerLb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPct
			 FROM	DashboardCustInvDaily
			 WHERE	Location = @Loc AND (ARPostDt = @CurDay OR ARPostDt = @CurEndDay)
			 GROUP BY CustNo, CustName) CustAll
			LEFT OUTER JOIN
			(SELECT	CustNo,
				CustName,
				SUM(SalesDollars) AS SalesDollarsWeb,
				SUM(SalesDollars) - SUM(Cost) AS MarginDollarsWeb,
				CASE SUM(SalesDollars)
				   WHEN 0 THEN 0
					  ELSE ((SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)) * 100
				END AS MarginPctWeb
			 FROM	DashboardCustInvDaily
			 WHERE	(ARPostDt = @CurDay OR ARPostDt = @CurEndDay) and Location = @Loc and OrderSourceSeq = 1
				--OrderSource IS NOT NULL and OrderSource <> '' and OrderSource <> 'M'
			 GROUP BY CustNo, CustName) CustWeb
			ON	CustAll.CustNo = CustWeb.CustNo

		SELECT	'--Report B - Customer Sales Order Level (SPECIFIC LOCATION: ' + @Loc + ')'
	   END
   END

GO
