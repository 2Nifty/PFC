--query1.sql

select * from DashboardCustInvDaily



----------------------------------------------------------------------------------------------------------------------------------------------------------


Declare @SupportRep varchar(40);
Set @SupportRep = 'chaggerty'

------------------------------------------------------------
-- Create list of Customers to be reported based on Filter
------------------------------------------------------------

----Let's add all of the sales data fields to this table and use it for the driver.
--DashboardCustSalesGoal ???

	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#Cust')) Drop Table #Cust

	SELECT	CM.CustNo
			,CM.CustName
			,convert(varchar(40),RM.RepNotes) as RepNotes
			-- CSR: Combine Carson with SFS for Reporting
			,Case when CM.CustShipLocation = '01' then '15' else CM.CustShipLocation end as CustShipLocation
			,isnull(RM.RepName,'None Assigned') as InsideSalesRep
			,CASE WHEN CM.CreditInd = 'X' then 'Credit Hold' else 'Credit OK' end as CreditInd
			,CASE WHEN isnull(CM.DeleteDt,'')= '1900-01-01 00:00:00.000' THEN 'Open' ELSE 'Deleted' end as DeleteStatus
			,CM.ChainCd
			,CM.PriceCd
			,CM.SalesTerritory
			,isnull(RM2.RepName,'None Assigned') as OutsideSalesRep

,cast(0.0 as decimal(18, 6)) as MTDGoalDol
,cast(0.0 as decimal(18, 6)) as MTDGoalGMPct
,cast(0.0 as decimal(18, 6)) as YTDGoalDol
,cast(0.0 as decimal(18, 6)) as YTDGoalGMPct
,cast(0.0 as decimal(18, 6)) as YTDSalesDol
,cast(0.0 as decimal(18, 6)) as PrevMth1SalesDol
,cast(0.0 as decimal(18, 6)) as PrevMth1GMPct
,cast(0.0 as decimal(18, 6)) as PrevMth2SalesDol
,cast(0.0 as decimal(18, 6)) as PrevMth2GMPct
,cast(0.0 as decimal(18, 6)) as PrevMth3SalesDol
,cast(0.0 as decimal(18, 6)) as PrevMth3GMPct

	INTO	#Cust
	FROM	CustomerMaster CM (nolock) Left Outer Join
			RepMaster RM (nolock)
	ON		RM.RepNo = CM.SupportRepNo Left Outer Join
			RepMaster RM2 (nolock)
	ON		RM2.RepNo = CM.SlsRepNo

select * from #Cust

/*
------------------------------------------------------------	
-- Get Current Month value : !!!uses CuvnalRanges!!!
------------------------------------------------------------

--select * from Cuvnalranges

	DECLARE @CurMth int;

	SELECT	@CurMth = MonthValue
	FROM	CuvnalRanges
	WHERE	CuvnalParameter = 'CurrentMonth'

select @CurMth as CurrentMonth
*/



/*

------------------------------------------------------------	
-- Get Goal Data from CustomerSalesForecast based on @CurMth
------------------------------------------------------------

IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#Goal')) Drop Table #Goal


SELECT	CSF.CustNo,
---		CM.InsideSalesRep,

		--Current MTD Goal $
		CASE @CurMth
		   WHEN 9 THEN CSF.SepSales
		   WHEN 10 THEN CSF.OctSales
		   WHEN 11 THEN CSF.NovSales
		   WHEN 12 THEN CSF.DecSales
		   WHEN 1 THEN CSF.JanSales
		   WHEN 2 THEN CSF.FebSales
		   WHEN 3 THEN CSF.MarSales
		   WHEN 4 THEN CSF.AprSales
		   WHEN 5 THEN CSF.MaySales
		   WHEN 6 THEN CSF.JunSales
		   WHEN 7 THEN CSF.JulSales
		   WHEN 8 THEN CSF.AugSales
		END as MTDGoalDol,

		--Current MTD Goal GM %
		CASE @CurMth
		   WHEN 9 THEN CSF.SepGMPct * 100
		   WHEN 10 THEN CSF.OctGMPct * 100
		   WHEN 11 THEN CSF.NovGMPct * 100
		   WHEN 12 THEN CSF.DecGMPct * 100
		   WHEN 1 THEN CSF.JanGMPct * 100
		   WHEN 2 THEN CSF.FebGMPct * 100
		   WHEN 3 THEN CSF.MarGMPct * 100
		   WHEN 4 THEN CSF.AprGMPct * 100
		   WHEN 5 THEN CSF.MayGMPct * 100
		   WHEN 6 THEN CSF.JunGMPct * 100
		   WHEN 7 THEN CSF.JulGMPct * 100
		   WHEN 8 THEN CSF.AugGMPct * 100
		END as MTDGoalGMPct,

		--Current YTD Goal $
		CASE @CurMth
		   WHEN 9 THEN CSF.SepSales
		   WHEN 10 THEN CSF.SepSales + CSF.OctSales
		   WHEN 11 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales
		   WHEN 12 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales
		   WHEN 1 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales
		   WHEN 2 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales
		   WHEN 3 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales
		   WHEN 4 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales
		   WHEN 5 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales
		   WHEN 6 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales
		   WHEN 7 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales
		   WHEN 8 THEN CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales + CSF.AugSales
		END as YTDGoalDol,

		--Current YTD Goal GM %
		CASE @CurMth
		   WHEN 9 THEN CSF.SepGMPct * 100

		   WHEN 10 THEN CASE WHEN (CSF.SepSales + CSF.OctSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct)) / (CSF.SepSales + CSF.OctSales)) * 100
				END
		   WHEN 11 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales)) * 100
				END
		   WHEN 12 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales)) * 100
				END
		   WHEN 1 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales)) * 100
				END
		   WHEN 2 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales)) * 100
				END
		   WHEN 3 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales)) * 100
				END
		   WHEN 4 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct) + (CSF.AprSales * CSF.AprGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales)) * 100
				END
		   WHEN 5 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct) + (CSF.AprSales * CSF.AprGMPct) + (CSF.MaySales * CSF.MayGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales)) * 100
				END
		   WHEN 6 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct) + (CSF.AprSales * CSF.AprGMPct) + (CSF.MaySales * CSF.MayGMPct) + (CSF.JunSales * CSF.JunGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales)) * 100
				END	
		   WHEN 7 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct) + (CSF.AprSales * CSF.AprGMPct) + (CSF.MaySales * CSF.MayGMPct) + (CSF.JunSales * CSF.JunGMPct) + (CSF.JulSales * CSF.JulGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales)) * 100
				END
		   WHEN 8 THEN CASE WHEN (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales + CSF.AugSales) = 0
					THEN 0
					ELSE (((CSF.SepSales * CSF.SepGMPct) + (CSF.OctSales * CSF.OctGMPct) + (CSF.NovSales * CSF.NovGMPct) + (CSF.DecSales * CSF.DecGMPct) + (CSF.JanSales * CSF.JanGMPct) + (CSF.FebSales * CSF.FebGMPct) + (CSF.MarSales * CSF.MarGMPct) + (CSF.AprSales * CSF.AprGMPct) + (CSF.MaySales * CSF.MayGMPct) + (CSF.JunSales * CSF.JunGMPct) + (CSF.JulSales * CSF.JulGMPct) + (CSF.AugSales * CSF.AugGMPct)) / (CSF.SepSales + CSF.OctSales + CSF.NovSales + CSF.DecSales + CSF.JanSales + CSF.FebSales + CSF.MarSales + CSF.AprSales + CSF.MaySales + CSF.JunSales + CSF.JulSales + CSF.AugSales)) * 100
				END
		END as YTDGoalGMPct
--into	#Goal
From	CustomerSalesForecast CSF (nolock) Inner Join
		#Cust CM
ON		CM.CustNo = CSF.CustNo
Where	CSF.RecordType = 'F' AND CM.RepNotes = 'chaggerty'

--^^It looks like we need to specify which FiscalYear in CustomerSalesForecast???	-- Nope, use ERP
--Maybe need to add FiscalYear column to CuvnalRanges??					-- Nope, use ERP
--Is CustomerSalesForecast table data valid on SQLP.PFCReports???			-- No, use ERP.

*/


--UPDATE Goal data in #Cust
UPDATE	#Cust
SET		MTDGoalDol = #Goal.MTDGoalDol,
		MTDGoalGMPct = #Goal.MTDGoalGMPct,
		YTDGoalDol = #Goal.YTDGoalDol,
		YTDGoalGMPct = #Goal.YTDGoalGMPct
FROM	#Goal
WHERE	#Cust.CustNo = #Goal.CustNo



select * from #Cust where MTDGoalDol <> 0
--select * from #Goal

-------------------------------------------------------------

--^^It looks like we need to specify which FiscalYear in CustomerSalesForecast???
--Maybe need to add FiscalYear column to CuvnalRanges??
--Is CustomerSalesForecast table data valid on SQLP.PFCReports???
select * from CustomerSalesForecast
where	RecordType = 'F' 


---------------------------------------------------------------------------------------------------

------------------------------------------------------------	
-- YTD Sales by Customer from SOHist
------------------------------------------------------------

--Can we add PreviousMonth2 and PreviousMonth3 to this table???
select * from CuvnalRanges
--select * form FiscalCalendar



DECLARE	@BegYTD DATETIME
DECLARE @EndYTD DATETIME


select	@BegYTD = BegDate,
		@EndYTD = EndDate
from	CuvnalRanges
WHERE	CuvnalParameter = 'CurrentYear'


select	@BegYTD as BegYTD,
		@EndYTD as EndYTD


IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..#YTDSales')) Drop Table #YTDSales

--YTD Sales & Cost Extended
SELECT	Hdr.SellToCustNo AS CustNo,
		Dtl.NetUnitPrice * Dtl.QtyShipped as YTDSalesDol,
		Dtl.UnitCost * Dtl.QtyShipped as YTDCost
INTO	#YTDSales
FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN
		SODetailHist Dtl (NoLock) 
ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		#Cust CM (NoLock)
ON		Hdr.SellToCustNo = CM.CustNo
WHERE	Hdr.ARPostDt between @BegYTD and @EndYTD And
		ISNULL(Hdr.DeleteDt,'') = ''



--UPDATE YTDSales data in #Cust
UPDATE	#Cust
SET		YTDSalesDol = tSales.YTDSalesDol
FROM	(SELECT	CustNo,
				SUM(YTDSalesDol) as YTDSalesDol,
				CASE SUM(YTDSalesDol)
				   WHEN 0 THEN 0
						  ELSE ((SUM(YTDSalesDol) - SUM(YTDCost)) / SUM(YTDSalesDol)) * 100
				END AS MarginPct
		 FROM	#YTDSales
		 GROUP BY CustNo) tSales
WHERE	#Cust.CustNo = tSales.CustNo



select * from #Cust where YTDSalesDol <> 0 and MTDGoalDol <> 0
--select * from #YTDSales




--------------------------------------------------
--PrevMth1

DECLARE	@BegPrevMth1 DATETIME
DECLARE @EndPrevMth1 DATETIME

select	@BegPrevMth1 = BegDate,
		@EndPrevMth1 = EndDate
from	CuvnalRanges
WHERE	CuvnalParameter = 'PreviousMonth'

select	@BegYTD as BegYTD,
		@EndYTD as EndYTD,
		@BegPrevMth1 as BegPrevMth1,
		@EndPrevMth1 as EndPrevMth2


--Prev Month1 Sales & Cost Extended
SELECT	Hdr.SellToCustNo AS CustNo,
		Dtl.NetUnitPrice * Dtl.QtyShipped as PrevMth1SalesDol,
		Dtl.UnitCost * Dtl.QtyShipped as PrevMth1Cost
FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN
		SODetailHist Dtl (NoLock) 
ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		#Cust CM (NoLock)
ON		Hdr.SellToCustNo = CM.CustNo
WHERE	Hdr.ARPostDt between @BegPrevMth1 and @EndPrevMth1 And
		ISNULL(Hdr.DeleteDt,'') = ''





---------------------------------------------------------------------------------------------------------------------

group by Hdr.SellToCustNo


SELECT	Hdr.SellToCustNo AS CustNo,
		SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) as YTDSalesDol,
		CASE SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)
		   WHEN 0 THEN 0
			  ELSE ((SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) - SUM(Dtl.UnitCost * Dtl.QtyShipped)) / SUM(Dtl.NetUnitPrice * Dtl.QtyShipped)) * 100
		END AS YTDGMPct
FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN
		SODetailHist Dtl (NoLock) 
ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		#Cust CM (NoLock)
ON		Hdr.SellToCustNo = CM.CustNo
WHERE	Hdr.ARPostDt between @BegYTD and @EndYTD And
		ISNULL(Hdr.DeleteDt,'') = ''





SELECT	
				Hdr.SellToCustNo AS CustNo,
				Dtl.NetUnitPrice * Dtl.QtyShipped AS LineSales,
				Dtl.UnitCost * Dtl.QtyShipped AS LineCost
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
				CustomerMaster CM (NoLock)
		 ON		Hdr.SellToCustNo = CM.CustNo
		 WHERE	Hdr.ARPostDt between @CurMthBeg and @CurEndDay
				And ISNULL(Hdr.DeleteDt,'') = ''


group by Hdr.SellToCustNo
