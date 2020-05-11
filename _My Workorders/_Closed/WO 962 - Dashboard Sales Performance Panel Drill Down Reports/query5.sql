


------DAILY
--Report A - Sales Order Header Level  (SOHeaderRpt) - Done
exec pDashboardSODrilldownDaily '00', '******', '0000000000'

--Report B - Customer Sales Order Level  (SOCustomerRpt)
exec pDashboardSODrilldownDaily '00', '000000', '**********'

--Customer Number Detail Drilldown  (SOHeaderRpt) - Done
exec pDashboardSODrilldownDaily '00', '001087', '0000000000'

--Invoice Number Detail Drilldown  (SODetailRpt)
exec pDashboardSODrilldownDaily '00', '000000', 'IP2568474'




------MTD
--Report A - Sales Order Header Level
exec pDashboardSODrilldownMTD '00', '******', '0000000000'

--Report B - Customer Sales Order Level
exec pDashboardSODrilldownMTD '00', '000000', '**********'

--Customer Number Detail Drilldown
exec pDashboardSODrilldownMTD '00', '001087', '0000000000'

--Invoice Number Detail Drilldown
exec pDashboardSODrilldownMTD '00', '000000', 'IP2568474'

--Invoice Line Item Detail Drilldown
exec pDashboardSODrilldownMTD '00', '000000', '0000000000'





--select * from DashboardCustInvDaily order by ARPostDt


--SELECT	CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
--	SalesDollars, Lbs, SalesPerLb, Cost, MarginDollars, MarginPct, MarginPerLb
--FROM	DashboardCustInvDaily
--ORDER BY CustNo, InvoiceNo, LineNumber




--CREATE procedure [dbo].[pDashboardDrilldownDaily]
--@CustNo varchar(20),
--@InvoiceNo varchar(20)
--as

----pDashboardSODrilldownDaily
----Written By: Tod Dixon
----Application: Sales Management

DECLARE @CurDay		DATETIME	--Current DashBoard Date
DECLARE @CurEndDay	DATETIME	--Current DashBoard End Date
DECLARE @CustNo		VARCHAR(20)
DECLARE @InvoiceNo	VARCHAR(20)

SET @Curday = (SELECT BegDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')

--Select @Curday, @CurEndDay

select *	 FROM	SOHeaderHist 
--INNER JOIN
--		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID 
WHERE NOT EXISTS (Select InvoiceNo from DashboardCustInvDaily where InvoiceNo=SOHeaderHist.InvoiceNo) 
and ARPostDt = @CurDay or ARPostDt = @CurEndDay


select * from SODetailHist where 
fSOHeaderHistID = '959909' or 
fSOHeaderHistID = '959910' or 
fSOHeaderHistID = '960023' or 
fSOHeaderHistID = '960024' or 
fSOHeaderHistID = '960025' or 
fSOHeaderHistID = '960026' or 
fSOHeaderHistID = '960027' or 
fSOHeaderHistID = '962217' or 
fSOHeaderHistID = '962221' or 
fSOHeaderHistID = '962191' or 
fSOHeaderHistID = '962196' or 
fSOHeaderHistID = '962197' or 
fSOHeaderHistID = '962199' or 
fSOHeaderHistID = '962195'





SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt
	 FROM	DashboardCustInvDaily
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay


--SET @CustNo = '001087'
--SET @CustNo = '******'
SET @CustNo = '000000'
--SET @InvoiceNo = 'IP2568474'
SET @InvoiceNo = '0000000000'

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
			  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)
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
IF @InvoiceNo <> '0000000000'
   BEGIN
	SET @CustNo = (SELECT DISTINCT CustNo FROM DashboardCustInvDaily WHERE InvoiceNo = @InvoiceNo)
--	SELECT @CustNo

	SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
		SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct, MarginPerLb
	 FROM	DashboardCustInvDaily
	 WHERE	InvoiceNo = @InvoiceNo
   END


--Invoice Line Item Detail Drilldown
IF @CustNo = '000000' AND @InvoiceNo = '0000000000'
   BEGIN
	SET @CustNo = '~~~~~~'

	SELECT	DISTINCT CustNo, CustName, InvoiceNo, Location, ArPostDt, LineNumber, ItemNo,
		SalesDollars, Lbs, SalesPerLb, MarginDollars, MarginPct, MarginPerLb
	 FROM	DashboardCustInvDaily
	 WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
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
			  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)
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
			  ELSE (SUM(SalesDollars) - SUM(Cost)) / SUM(SalesDollars)
		END AS MarginPct
	FROM	DashboardCustInvDaily
	WHERE	ARPostDt = @CurDay or ARPostDt = @CurEndDay
	GROUP BY CustNo, CustName
   END

