Declare @SupportRep varchar(40);
Set @SupportRep = 'chaggerty'
-------------------------------------------------------------------------------------------------------------------------------------	
-- Create list of Customers to be reported based on Filter
-------------------------------------------------------------------------------------------------------------------------------------
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..##Custs'))
		BEGIN 
			Drop Table ##Custs
		END

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
	INTO	##Custs
	FROM	CustomerMaster CM (nolock)
	Left Outer Join RepMaster RM (nolock) ON
			RM.RepNo = CM.SupportRepNo
	Left Outer Join RepMaster RM2 (nolock) ON
			RM2.RepNo = CM.SlsRepNo
-------------------------------------------------------------------------------------------------------------------------------------	
-- Get Current Month End data : !!!uses CuvnalRanges!!!
-------------------------------------------------------------------------------------------------------------------------------------
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..##Month'))
		BEGIN 
			Drop Table ##Month
		END
	IF  Exists (Select * FROM tempdb.dbo.sysobjects Where  ID = OBJECT_ID('tempdb..##UpdateRecords'))
		BEGIN 
			Drop Table ##UpdateRecords
		END
	DECLARE @UpdateMonth int;
	DECLARE @MoveYear int;
	-- Find Period to be updated using CuvnalRanges
	SELECT	YearValue
			,MonthValue as UpdateMonth
			,YearValue*100+MonthValue as UpdatePeriod
			,BegDate
			,EndDate
	INTO	##Month
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CuvnalRanges
	WHERE	CuvnalParameter = 'CurrentMonth'
	-- Set Update Month
	SELECT	@UpdateMonth = UpdateMonth
			,@MoveYear = YearValue
	FROM	##Month
-------------------------------------------------------------------------------------------------------------------------------------	
-- Query to get column data
-------------------------------------------------------------------------------------------------------------------------------------
-- September
	IF	@UpdateMonth = 9
		BEGIN
			Select	CSF.CustNo
					,CM.InsideSalesRep
					,CSF.SepSales  as MTDGoalDol
					,CSF.SepGMPct*100 as MTDGoalGMPct
					,CSF.SepSales  as YTDGoalDol
					,CSF.SepGMPct*100 as YTDGoalGMPct
			From	CustomerSalesForecast CSF (nolock)
			Inner Join ##Custs CM ON
					CM.CustNo = CSF.CustNo
			Where	CSF.RecordType = 'F'
					And CM.RepNotes = 'chaggerty'
		END

-- October
	IF	@UpdateMonth = 10
		BEGIN
			Select	CSF.CustNo
					,CM.InsideSalesRep
					,CSF.OctSales  as MTDGoalDol
					,CSF.OctGMPct*100 as MTDGoalGMPct
					,CSF.SepSales+CSF.OctSales  as YTDGoalDol
					,Case	when (CSF.SepSales+CSF.OctSales)=0 then 0
							else (((CSF.SepSales*CSF.SepGMPct)+(CSF.OctSales*CSF.OctGMPct))/(CSF.SepSales+CSF.OctSales))*100
					end as YTDGoalGMPct
			From	CustomerSalesForecast CSF (nolock)
			Inner Join ##Custs CM ON
					CM.CustNo = CSF.CustNo
			Where	CSF.RecordType = 'F'
					And CM.RepNotes = 'chaggerty'
		END

-- November (just keep on adding each month)

