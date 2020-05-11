select * from CustomerMaster

--exec pDashboardDrilldownCustCatMTD '15', '00050'
--exec pDashboardDrilldownMTD '00'
--exec pLoadDashboardCatLocDaily

---------------------------------------------------------------------------------------

use pfcreports
go

drop proc [dbo].pDashboardDrilldownCustCatMTD
go

CREATE  procedure [dbo].pDashboardDrilldownCustCatMTD
@Loc varchar(50),
@Cat varchar(50)
as

----pDashboardDrilldownCustCatMTD
----Written By: Tod Dixon
----Application: Sales Management


DECLARE	@CurMth varchar(6),
		@LastMth varchar(6),
		@PrevMth varchar(6)

--Assign Current Month
SELECT	@CurMth = (YearValue * 100) + MonthValue
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges
FROM	DashboardRanges (NoLock)
WHERE	DashboardParameter = 'CurrentMonth'

--Assign Last Closed Month
SELECT	@LastMth = (YearValue * 100) + MonthValue
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
FROM	CuvnalRanges (NoLock)
WHERE	CuvnalParameter = 'CurrentMonth'

--Assign Previous Closed Month
SELECT	@PrevMth = (YearValue * 100) + MonthValue
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
FROM	CuvnalRanges (NoLock)
WHERE	CuvnalParameter = 'PreviousMonth'

--select @CurMth as CurMth,@LastMth as LastMth,@PrevMth as PrevMth

IF	@Loc = '00'
  BEGIN
	SET @Loc = '%'
  END
ELSE
  BEGIN
	SET @Loc = '%' + @Loc + '%'
  END
--select @Loc

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
(
SELECT	CatSumm.CustomerNo as CustNo,
		isnull(CM.CustName, '* undefined *') as CustName,
		CatSumm.SalesDollars,
		CatSumm.TotalWeight as Lbs,
		CASE WHEN CatSumm.TotalWeight = 0
			 THEN 0
			 ELSE CatSumm.SalesDollars / CatSumm.TotalWeight
		END as SalesPerLb,
		SalesDollars - SalesCost as MarginDollars,
		CASE WHEN SalesDollars = 0
			 THEN 0
			 ELSE (SalesDollars - SalesCost) / SalesDollars * 100
		END AS MarginPct
FROM	CustomerMaster CM (NoLock) RIGHT OUTER JOIN
		CustCatSalesSummary CatSumm (NoLock)
ON		CM.CustNo = CatSumm.CustomerNo
WHERE	CM.CustShipLocation LIKE @Loc and
		CatSumm.FiscalPeriodNo = @CurMth and CatSumm.Category = @Cat
) tCurMth

LEFT OUTER JOIN

--Last Closed Month [tLastMth]
(
SELECT	CatSumm.CustomerNo as CustNo,
		CatSumm.SalesDollars,
		CatSumm.TotalWeight as Lbs,
		CASE WHEN CatSumm.TotalWeight = 0
			 THEN 0
			 ELSE CatSumm.SalesDollars / CatSumm.TotalWeight
		END as SalesPerLb,
		SalesDollars - SalesCost as MarginDollars,
		CASE WHEN SalesDollars = 0
			 THEN 0
			 ELSE (SalesDollars - SalesCost) / SalesDollars * 100
		END AS MarginPct
FROM	CustomerMaster CM (NoLock) RIGHT OUTER JOIN
		CustCatSalesSummary CatSumm (NoLock)
ON		CM.CustNo = CatSumm.CustomerNo
WHERE	CM.CustShipLocation LIKE @Loc and
		CatSumm.FiscalPeriodNo = @PrevMth and CatSumm.Category = @Cat
) tLastMth

ON	tCurMth.CustNo = tLastMth.CustNo
LEFT OUTER JOIN

--Previous Closed Month [tPrevMth]
(
SELECT	CatSumm.CustomerNo as CustNo,
		CatSumm.SalesDollars,
		CatSumm.TotalWeight as Lbs,
		CASE WHEN CatSumm.TotalWeight = 0
			 THEN 0
			 ELSE CatSumm.SalesDollars / CatSumm.TotalWeight
		END as SalesPerLb,
		SalesDollars - SalesCost as MarginDollars,
		CASE WHEN SalesDollars = 0
			 THEN 0
			 ELSE (SalesDollars - SalesCost) / SalesDollars * 100
		END AS MarginPct
FROM	CustomerMaster CM (NoLock) RIGHT OUTER JOIN
		CustCatSalesSummary CatSumm (NoLock)
ON		CM.CustNo = CatSumm.CustomerNo
WHERE	CM.CustShipLocation LIKE @Loc and
		CatSumm.FiscalPeriodNo = @LastMth and CatSumm.Category = @Cat
) tPrevMth
ON	tCurMth.CustNo = tPrevMth.CustNo

GO
