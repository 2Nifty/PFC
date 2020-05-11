
CREATE procedure [dbo].[pDashboardSODrilldownDaily]
@Loc varchar(20),
@CustNo varchar(20),
@InvoiceNo varchar(20)
as

----pDashboardSODrilldownDaily
----Written By: Tod Dixon
----Application: Sales Management

DECLARE @CurDay		DATETIME	--Current DashBoard Date
DECLARE @CurEndDay	DATETIME	--Current DashBoard End Date

SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')


--Customer Number Detail Drilldown
IF @CustNo <> '000000' AND @CustNo <> '******'
   BEGIN
	SELECT	DISTINCT CustNo, CustName, OrderSum.InvoiceNo, Location, ArPostDt,
		SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct, MarginPerLb
	FROM
	(SELECT	InvoiceNo, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
	(SELECT	CustNo, CustName, InvoiceNo, Location, ArPostDt
	 FROM	DashboardCustInvDaily
	 WHERE	CustNo = @CustNo and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)) OrderDtl
	ON OrderSum.InvoiceNo = OrderDtl.InvoiceNo
   END


--Invoice Number Detail Drilldown
IF @InvoiceNo <> '0000000000' AND @InvoiceNo <> '**********'
   BEGIN
	SET @CustNo = (SELECT DISTINCT CustNo FROM DashboardCustInvDaily WHERE InvoiceNo = @InvoiceNo)
--	SELECT @CustNo

	SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
		SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct * 100 AS MarginPct, MarginPerLb
	 FROM	DashboardCustInvDaily
	 WHERE	InvoiceNo = @InvoiceNo
   END


IF @Loc = '00'		--ALL LOCATIONS
   BEGIN
	--Invoice Line Item Detail Drilldown
	IF @CustNo = '000000' AND @InvoiceNo = '0000000000'
	   BEGIN
		SET @CustNo = '~~~~~~'

		SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
			SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct * 100 AS MarginPct, MarginPerLb
		 FROM	DashboardCustInvDaily
		 WHERE	ItemNo IS NOT NULL and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)
	   END

	--Report A - Sales Order Header Level
	IF @CustNo = '******'
	   BEGIN
		SELECT	DISTINCT CustNo, CustName, OrderSum.InvoiceNo, Location, ArPostDt,
			SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct, MarginPerLb
		FROM
		(SELECT	InvoiceNo, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
		(SELECT	CustNo, CustName, InvoiceNo, Location, ArPostDt
		 FROM	DashboardCustInvDaily
		 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay) OrderDtl
		ON OrderSum.InvoiceNo = OrderDtl.InvoiceNo
	   END


	--Report B - Customer Sales Order Level
	IF @CustNo = '000000'
	   BEGIN
		SELECT	CustNo, CustName, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
		GROUP BY CustNo, CustName
	   END
   END
ELSE			--SPECIFIC LOCATION
   BEGIN
	--Invoice Line Item Detail Drilldown
	IF @CustNo = '000000' AND @InvoiceNo = '0000000000'
	   BEGIN
		SET @CustNo = '~~~~~~'

		SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
			SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct * 100 AS MarginPct, MarginPerLb
		 FROM	DashboardCustInvDaily
		 WHERE	Location = @Loc AND ItemNo IS NOT NULL and (ARPostDt = @CurDay or ARPostDt = @CurEndDay)
	   END

	--Report A - Sales Order Header Level
	IF @CustNo = '******'
	   BEGIN
		SELECT	DISTINCT CustNo, CustName, OrderSum.InvoiceNo, Location, ArPostDt,
			SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct, MarginPerLb
		FROM
		(SELECT	InvoiceNo, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
		(SELECT	CustNo, CustName, InvoiceNo, Location, ArPostDt
		 FROM	DashboardCustInvDaily
		 WHERE	Location = @Loc AND (ARPostDt = @CurDay OR ARPostDt = @CurEndDay)) OrderDtl
		ON OrderSum.InvoiceNo = OrderDtl.InvoiceNo
	   END


	--Report B - Customer Sales Order Level
	IF @CustNo = '000000'
	   BEGIN
		SELECT	CustNo, CustName, SUM(SalesDollars) AS SalesDollars, SUM(Lbs) AS Lbs,
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
		GROUP BY CustNo, CustName
	   END
   END

GO
