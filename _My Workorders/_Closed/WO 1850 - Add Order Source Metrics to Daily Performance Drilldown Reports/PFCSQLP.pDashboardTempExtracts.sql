-- =============================================
-- Author:		Slater
-- Create date: 9/14/2008
-- Description:	Summarizes Dashboard data to the company level
-- Update Date: 03/13/09 [CSR]
-- Update Desc: 03/13/09 [CSR] - Removed 10% adder to Branch Expense Budget per Tom W request
-- =============================================
CREATE PROCEDURE [dbo].[pDashBoardTempExtracts] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Ensure read only access
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- Disable warning: Null value is eliminated by an aggregate or other SET operation
	SET ANSI_WARNINGS OFF
	--
	declare @ShowResults bit
	--set @ShowResults = 1 
	set @ShowResults = 0 
	--
	-- Extract Order headers in dashboard complete range
	select 
	ADUserID = case isnull(DashboardUsersTemp.UserID,'***')
		when '***' then SOHeaderHist.EntryID 
		else DashboardUsersTemp.UserID end,
	UserBranch = case isnull(DashBoardUserBranch.DshBrd_WindowsId,'***')
		when '***' then '00' 
		else DashBoardUserBranch.Dsh_Brd_BrnNo end,
	*
	into #DashBoardOrders
	from
	SOHeaderHist
	left outer join DashboardUsersTemp  (NOLOCK)
	on SOHeaderHist.EntryID = DashboardUsersTemp.UserID
	LEFT OUTER JOIN DashBoardUserBranch  (NOLOCK)
	ON DashboardUsersTemp.UserID = DashBoardUserBranch.DshBrd_WindowsId,
	(select
		(select BegDate from DashboardRanges (NOLOCK) WHERE (DashboardParameter = 'LastMonth')) as FirstDate,
		(select EndDate from DashboardRanges (NOLOCK) WHERE (DashboardParameter = 'CurrentMonth')) as LastDate) ranges
	where ARPostDt >= FirstDate AND 
		ARPostDt <= LastDate

	if @ShowResults = 1 select * from #DashBoardOrders order BY ADUserID, UserBranch, ARPostDt 
	--
	-- Create the daily totals
	select 
	ADUserID,
	Loc_No,
	CurMonth, 
	CurYear, 
	(sum(LineAmts) - sum(CostAmts)) as TD_GrossMarginDollar,
	TD_GrossMarginPct=case sum(LineAmts) when 0 then 0 
	  else (sum(LineAmts) - sum(CostAmts)) / sum(LineAmts) end ,
	sum(LineAmts) as TD_SalesDollar,
	count(*) as TD_OrderCount,
	sum(LineCounts) as TD_LineCount,
	sum(LineWeights) as TD_LbsShipped, 
	TD_PricePerLb = case sum(LineWeights) when 0 then 0 
	  else sum(LineAmts) / sum(LineWeights) end 
	into #DashBoardDailySums
	--
	from (select 
		Orders.ADUserID,
		Orders.CustShipLoc AS Loc_No,
		CurMonth, 
		CurYear, 
		DayOfMonth, 
		(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineAmts,
		(select sum(Lines.QtyShipped*Lines.UnitCost) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as CostAmts ,
		(select count(*) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCounts,
		(select sum(Lines.QtyShipped * Lines.GrossWght) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
		FROM 
			(select 
			Dates.MonthValue AS CurMonth, 
			Dates.YearValue AS CurYear, 
			* from #DashBoardOrders (NOLOCK) 
			INNER JOIN
			DashboardRanges Dates (NOLOCK) ON ARPostDt >= Dates.BegDate AND 
			ARPostDt <= Dates.EndDate
			WHERE (Dates.DashboardParameter = 'CurrentDay')) Orders 
			) Users 
		--
	GROUP BY ADUserID, Loc_No, CurMonth, CurYear, DayOfMonth

	if @ShowResults = 1 select * from #DashBoardDailySums order BY ADUserID, Loc_No


	-- create average totals
	select 
	ADUserID,
	Loc_No,
	CurMonth, 
	CurYear, 
	(sum(LineAmts) - sum(CostAmts))/DayOfMonth as AVG_GrossMarginDollar,
	AVG_GrossMarginPct=case sum(LineAmts) when 0 then 0 
	  else (sum(LineAmts) - sum(CostAmts)) / sum(LineAmts) end ,
	sum(LineAmts)/DayOfMonth as AVG_SalesDollar,
	count(*)/DayOfMonth as AVG_OrderCount,
	sum(LineCounts)/DayOfMonth as AVG_LineCount,
	sum(LineWeights)/DayOfMonth as AVG_LbsShipped, 
	AVG_PricePerLb = case sum(LineWeights) when 0 then 0 
	  else sum(LineAmts) / sum(LineWeights) end 
	into #DashBoardAvgSums
	--
	from (select 
		Orders.ADUserID,
		Orders.CustShipLoc AS Loc_No,
		MonthValue AS CurMonth, 
		YearValue AS CurYear, 
		DayOfMonth, 
		(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineAmts,
		(select sum(Lines.QtyShipped*Lines.UnitCost) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as CostAmts ,
		(select count(*) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCounts,
		(select sum(Lines.QtyShipped * Lines.GrossWght) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
		FROM #DashBoardOrders Orders (NOLOCK)  
		INNER JOIN
		DashboardRanges Dates (NOLOCK) ON ARPostDt >= Dates.BegDate AND 
		ARPostDt <= Dates.EndDate
	WHERE (Dates.DashboardParameter = 'CurrentMonth')		) Users 
	GROUP BY ADUserID, Loc_No, CurMonth, CurYear, DayOfMonth

	if @ShowResults = 1 select * from #DashBoardAvgSums order BY ADUserID, Loc_No

	-- create current month totals
	select 
	ADUserID,
	Loc_No,
	CurMonth, 
	CurYear, 
	(sum(LineAmts) - sum(CostAmts)) as MTD_GrossMarginDollar,
	MTD_GrossMarginPct=case sum(LineAmts) when 0 then 0 
	  else (sum(LineAmts) - sum(CostAmts)) / sum(LineAmts) end ,
	sum(LineAmts) as MTD_SalesDollar,
	count(*) as MTD_OrderCount,
	sum(LineCounts) as MTD_LineCount,
	sum(LineWeights) as MTD_LbsShipped, 
	MTD_PricePerLb = case sum(LineWeights) when 0 then 0 
	  else sum(LineAmts) / sum(LineWeights) end 
	into #DashBoardCurMoSums
	--
	from (select 
		Orders.ADUserID,
		Orders.CustShipLoc AS Loc_No,
		CurMonth, 
		CurYear, 
		DayOfMonth, 
		(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineAmts,
		(select sum(Lines.QtyShipped*Lines.UnitCost) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as CostAmts ,
		(select count(*) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCounts,
		(select sum(Lines.QtyShipped * Lines.GrossWght) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
		FROM 
			(select 
			Dates.MonthValue AS CurMonth, 
			Dates.YearValue AS CurYear, 
			* from #DashBoardOrders (NOLOCK) 
			INNER JOIN
			DashboardRanges Dates (NOLOCK) ON ARPostDt >= Dates.BegDate AND 
			ARPostDt <= Dates.EndDate
			WHERE (Dates.DashboardParameter = 'CurrentMonth')) Orders 
			) Users 
		--
	GROUP BY ADUserID, Loc_No, CurMonth, CurYear, DayOfMonth

	if @ShowResults = 1 select * from #DashBoardCurMoSums order BY ADUserID, Loc_No
	--
	-- create last month totals
	select 
	ADUserID,
	Loc_No,
	CurMonth, 
	CurYear, 
	(sum(LineAmts) - sum(CostAmts)) as LMTD_GrossMarginDollar,
	LMTD_GrossMarginPct=case sum(LineAmts) when 0 then 0 
	  else (sum(LineAmts) - sum(CostAmts)) / sum(LineAmts) end ,
	sum(LineAmts) as LMTD_SalesDollar,
	count(*) as LMTD_OrderCount,
	sum(LineCounts) as LMTD_LineCount,
	sum(LineWeights) as LMTD_LbsShipped, 
	LMTD_PricePerLb = case sum(LineWeights) when 0 then 0 
	  else sum(LineAmts) / sum(LineWeights) end
	into #DashBoardLastMoSums
	--
	from (select 
		Orders.ADUserID,
		Orders.CustShipLoc AS Loc_No,
		CurMonth, 
		CurYear, 
		DayOfMonth, 
		(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineAmts,
		(select sum(Lines.QtyShipped*Lines.UnitCost) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as CostAmts ,
		(select count(*) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCounts,
		(select sum(Lines.QtyShipped * Lines.GrossWght) from
			SODetailHist Lines (NOLOCK) where Orders.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
		FROM 
			(select 
			Dates.MonthValue AS CurMonth, 
			Dates.YearValue AS CurYear, 
			* from #DashBoardOrders (NOLOCK) 
			INNER JOIN
			DashboardRanges Dates (NOLOCK) ON ARPostDt >= Dates.BegDate AND 
			ARPostDt <= Dates.EndDate
			WHERE (Dates.DashboardParameter = 'LastMonth')) Orders 
			) Users 
		--
	GROUP BY ADUserID, Loc_No, CurMonth, CurYear, DayOfMonth

	if @ShowResults = 1 select * from #DashBoardLastMoSums order BY ADUserID, Loc_No
	--
	-- Now extract the summaries
	--
	-- create summary by user and CustShipLoc for branch and territory views
	SELECT 
	ADUsers.ADUserID,
	ADUsers.UserBranch,
	ADUsers.Loc_No,
	Dates.MonthValue as CurMonth,
	Dates.YearValue as CurYear,
	isnull(DashboardDailyRaw.TD_GrossMarginDollar, 0) as TD_GrossMarginDollar,
	isnull(DashboardDailyRaw.TD_GrossMarginPct, 0) as TD_GrossMarginPct,
	isnull(DashboardDailyRaw.TD_SalesDollar, 0) as TD_SalesDollar,
	isnull(DashboardDailyRaw.TD_OrderCount, 0) as TD_OrderCount,
	isnull(DashboardDailyRaw.TD_LineCount, 0) as TD_LineCount,
	isnull(DashboardDailyRaw.TD_LbsShipped, 0) as TD_LbsShipped,
	isnull(DashboardDailyRaw.TD_PricePerLb, 0) as TD_PricePerLb,
	isnull(DashboardCurMonthRaw.MTD_GrossMarginDollar, 0) as MTD_GrossMarginDollar, 
	isnull(DashboardCurMonthRaw.MTD_GrossMarginPct, 0) as MTD_GrossMarginPct, 
	isnull(DashboardCurMonthRaw.MTD_SalesDollar, 0) as MTD_SalesDollar, 
	isnull(DashboardCurMonthRaw.MTD_OrderCount, 0) as MTD_OrderCount, 
	isnull(DashboardCurMonthRaw.MTD_LineCount, 0) as MTD_LineCount, 
	isnull(DashboardCurMonthRaw.MTD_LbsShipped, 0) as MTD_LbsShipped, 
	isnull(DashboardCurMonthRaw.MTD_PricePerLb, 0) as MTD_PricePerLb, 
	isnull(DashboardAvgMonthRaw.AVG_GrossMarginDollar, 0) as AVG_GrossMarginDollar,
	isnull(DashboardAvgMonthRaw.AVG_GrossMarginPct, 0) as AVG_GrossMarginPct,
	isnull(DashboardAvgMonthRaw.AVG_SalesDollar, 0) as AVG_SalesDollar,
	isnull(DashboardAvgMonthRaw.AVG_OrderCount, 0) as AVG_OrderCount,
	isnull(DashboardAvgMonthRaw.AVG_LineCount, 0) as AVG_LineCount,
	isnull(DashboardAvgMonthRaw.AVG_LbsShipped, 0) as AVG_LbsShipped,
	isnull(DashboardAvgMonthRaw.AVG_PricePerLb, 0) as AVG_PricePerLb,
	isnull(DashboardLastMonthRaw.LMTD_GrossMarginDollar, 0) as LMTD_GrossMarginDollar,
	isnull(DashboardLastMonthRaw.LMTD_GrossMarginPct, 0) as LMTD_GrossMarginPct,
	isnull(DashboardLastMonthRaw.LMTD_SalesDollar, 0) as LMTD_SalesDollar,
	isnull(DashboardLastMonthRaw.LMTD_OrderCount, 0) as LMTD_OrderCount,
	isnull(DashboardLastMonthRaw.LMTD_LineCount, 0) as LMTD_LineCount,
	isnull(DashboardLastMonthRaw.LMTD_LbsShipped, 0) as LMTD_LbsShipped,
	isnull(DashboardLastMonthRaw.LMTD_PricePerLb,0) as LMTD_PricePerLb
	into #DashboardUserLocSum
	FROM DashboardRanges Dates, 
		(select *
			from (
				SELECT ADUserID, UserBranch, CustShipLoc AS Loc_No
					FROM #DashBoardOrders (NOLOCK)
				) lev1
			GROUP BY ADUserID, UserBranch, Loc_No) ADUsers  LEFT OUTER JOIN
	#DashBoardCurMoSums DashboardCurMonthRaw (NOLOCK) ON ADUsers.Loc_No = DashboardCurMonthRaw.Loc_No AND 
	ADUsers.ADUserID = DashboardCurMonthRaw.ADUserID LEFT OUTER JOIN
	#DashBoardLastMoSums DashboardLastMonthRaw (NOLOCK) ON ADUsers.Loc_No = DashboardLastMonthRaw.Loc_No AND 
	ADUsers.ADUserID = DashboardLastMonthRaw.ADUserID LEFT OUTER JOIN
	#DashBoardAvgSums DashboardAvgMonthRaw (NOLOCK) ON ADUsers.Loc_No = DashboardAvgMonthRaw.Loc_No AND 
	ADUsers.ADUserID = DashboardAvgMonthRaw.ADUserID LEFT OUTER JOIN
	#DashBoardDailySums DashboardDailyRaw (NOLOCK) ON ADUsers.Loc_No = DashboardDailyRaw.Loc_No AND 
	ADUsers.ADUserID = DashboardDailyRaw.ADUserID
	WHERE (Dates.DashboardParameter = 'CurrentMonth')

	if @ShowResults = 1 select * from #DashboardUserLocSum order BY Loc_No, ADUserID 
	--
	-- Create user summaries and use umbrella branch as location
	SELECT     
	ADUserID AS UserID, 
	UserBranch as Loc_No,
	CurMonth AS CurMonth, 
	CurYear AS CurYear, 
	SUM(TD_GrossMarginDollar) AS TD_GrossMarginDollar, 
	CASE WHEN SUM(TD_SalesDollar) = 0 THEN 0 ELSE SUM(TD_GrossMarginDollar) / SUM(TD_SalesDollar) END AS TD_GrossMarginPct, 
	SUM(TD_SalesDollar) AS TD_SalesDollar, 
	SUM(TD_OrderCount) AS TD_OrderCount, 
	SUM(TD_LineCount) AS TD_LineCount, 
	SUM(TD_LbsShipped) AS TD_LbsShipped, 
	CASE WHEN SUM(TD_LbsShipped) = 0 THEN 0 ELSE SUM(TD_SalesDollar) / SUM(TD_LbsShipped) END AS TD_PricePerLb, 
	SUM(MTD_GrossMarginDollar) AS MTD_GrossMarginDollar, 
	CASE WHEN SUM(MTD_SalesDollar) = 0 THEN 0 ELSE SUM(MTD_GrossMarginDollar) / SUM(MTD_SalesDollar) END AS MTD_GrossMarginPct, 
	SUM(MTD_SalesDollar) AS MTD_SalesDollar, 
	SUM(MTD_OrderCount) AS MTD_OrderCount, 
	SUM(MTD_LineCount) AS MTD_LineCount, 
	SUM(MTD_LbsShipped) AS MTD_LbsShipped, 
	CASE WHEN SUM(MTD_LbsShipped) = 0 THEN 0 ELSE SUM(MTD_SalesDollar) / SUM(MTD_LbsShipped) END AS MTD_PricePerLb, 
	SUM(AVG_GrossMarginDollar) AS AVG_GrossMarginDollar, 
	CASE WHEN SUM(AVG_SalesDollar) = 0 THEN 0 ELSE SUM(AVG_GrossMarginDollar) / SUM(AVG_SalesDollar) END AS AVG_GrossMarginPct, 
	SUM(AVG_SalesDollar) AS AVG_SalesDollar, 
	SUM(AVG_OrderCount) AS AVG_OrderCount, 
	SUM(AVG_LineCount) AS AVG_LineCount, 
	SUM(AVG_LbsShipped) AS AVG_LbsShipped, 
	CASE WHEN SUM(AVG_LbsShipped) = 0 THEN 0 ELSE SUM(AVG_SalesDollar) / SUM(AVG_LbsShipped) END AS AVG_PricePerLb, 
	SUM(LMTD_GrossMarginDollar) AS LMTD_GrossMarginDollar, 
	CASE WHEN SUM(LMTD_SalesDollar) = 0 THEN 0 ELSE SUM(LMTD_GrossMarginDollar) / SUM(LMTD_SalesDollar) END AS LMTD_GrossMarginPct, 
	SUM(LMTD_SalesDollar) AS LMTD_SalesDollar, 
	SUM(LMTD_OrderCount) AS LMTD_OrderCount, 
	SUM(LMTD_LineCount) AS LMTD_LineCount, 
	SUM(LMTD_LbsShipped) AS LMTD_LbsShipped, 
	CASE WHEN SUM(LMTD_LbsShipped) = 0 THEN 0 ELSE SUM(LMTD_SalesDollar) / SUM(LMTD_LbsShipped) END AS LMTD_PricePerLb
	into #DashBoardUserSum
	FROM #DashboardUserLocSum        
	GROUP BY ADUserID, UserBranch, CurMonth, CurYear

	if @ShowResults = 1 select * from #DashBoardUserSum order BY UserID, Loc_No

	--
	-- Create branch summaries
	SELECT 	Loc_No, 
	CurMonth, 
	CurYear, 
	SUM(TD_GrossMarginDollar) as TD_GrossMarginDollar, 
	TD_GrossMarginPct = case SUM(TD_SalesDollar) when 0 then 0 else SUM(TD_GrossMarginDollar) / SUM(TD_SalesDollar)end, 
	SUM(TD_SalesDollar) as TD_SalesDollar, 
	SUM(TD_OrderCount) as TD_OrderCount, 
	SUM(TD_LineCount) as TD_LineCount, 
	SUM(TD_LbsShipped) as TD_LbsShipped, 
	TD_PricePerLb = case SUM(TD_LbsShipped)when 0 then 0 else SUM(TD_SalesDollar) / SUM(TD_LbsShipped) end, 
	min(TDBrnExpBud) as TDBrnExpBud, 
	--CSR 03/13/09: Removed +(SUM(TD_SalesDollar))*0.10 after min(TDBrnExpBud)
	SUM(MTD_GrossMarginDollar) as MTD_GrossMarginDollar, 
	MTD_GrossMarginPct = case SUM(MTD_SalesDollar)when 0 then 0 else SUM(MTD_GrossMarginDollar) / SUM(MTD_SalesDollar) end, 
	SUM(MTD_SalesDollar) as MTD_SalesDollar,
	SUM(MTD_OrderCount) as MTD_OrderCount, 
	SUM(MTD_LineCount) as MTD_LineCount, 
	SUM(MTD_LbsShipped) as MTD_LbsShipped, 
	MTD_PricePerLb = case SUM(MTD_LbsShipped)when 0 then 0 else SUM(MTD_SalesDollar) / SUM(MTD_LbsShipped) end, 
	min(MTDBrnExpBud) as MTDBrnExpBud, 
	--CSR 03/13/09: Removed +(SUM(MTD_SalesDollar)) *0.10 after min(MTDBrnExpBud)
	AVG_GrossMarginDollar = case DayOfMonth when 0 then 0 else SUM(MTD_GrossMarginDollar)/DayOfMonth end, 
	AVG_GrossMarginPct = case SUM(MTD_SalesDollar)*DayOfMonth when 0 then 0 else (SUM(MTD_GrossMarginDollar)/DayOfMonth) / (SUM(MTD_SalesDollar)/DayOfMonth) end , 
	AVG_SalesDollar = case DayOfMonth when 0 then 0 else SUM(MTD_SalesDollar)/DayOfMonth end, 
	AVG_OrderCount = case DayOfMonth when 0 then 0 else SUM(MTD_OrderCount)/DayOfMonth end, 
	AVG_LineCount = case DayOfMonth when 0 then 0 else SUM(MTD_LineCount)/DayOfMonth end, 
	AVG_LbsShipped = case DayOfMonth when 0 then 0 else SUM(MTD_LbsShipped)/DayOfMonth end, 
	AVG_PricePerLb = case SUM(MTD_LbsShipped)*DayOfMonth When 0 then 0 else (SUM(MTD_SalesDollar)/DayOfMonth) / (SUM(MTD_LbsShipped)/DayOfMonth) end, 
	AVGBrnExpBud = case DayOfMonth when 0 then 0 else (min(MTDBrnExpBud))/DayOfMonth end, 
	--CSR 03/13/09: removed sum(BUD_GMPerLb) Removed +(SUM(MTD_SalesDollar)) after min(MTDBrnExpBud)
	BUD_GrossMarginDollar = isnull(
		(select sum(BUD_GrossMarginDollar) 
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0), 
	--Case Statement added by Charles
	BUD_GrossMarginPct = isnull(
		(select Case when sum(BUD_SalesDollar) = 0 then 0 else sum(BUD_GrossMarginDollar)/sum(BUD_SalesDollar) end
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0), 
	BUD_SalesDollar = isnull(
		(select sum(BUD_SalesDollar) 
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0),0 as BUD_OrderCount,
	0 as BUD_LineCount,
	BUD_LbsShipped = isnull(
		(select sum(BUD_LbsShipped) 
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0),
	BUD_PricePerLb = case isnull(
		(select sum(BUD_LbsShipped) 
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0) when 0 then 0 else isnull(
			(select sum(BUD_SalesDollar)/sum(BUD_LbsShipped) 
			from DashBoardBudgets (NOLOCK)
			where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
				and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
				and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0) end,
	BUD_GMPerLb = isnull(
		(select sum(BUD_GMPerLb) 
		from DashBoardBudgets (NOLOCK) 
		where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0),
	BUDBrnExpBud = min(BUDBrnExpBud)
	into #DashboardBranchSum
	FROM #DashboardUserLocSum (NOLOCK), 
		DashboardRanges Dates (NOLOCK), 
		DashboardBUDBrnExp (NOLOCK) 
	WHERE (Dates.DashboardParameter = 'CurrentMonth')
	and #DashboardUserLocSum.Loc_No = DashboardBUDBrnExp.LocNo
	GROUP BY Loc_No, CurMonth, CurYear, DayOfMonth
	-- CSR 03/03/09: Removed +(isnull(
		--(select sum(BUD_SalesDollar)*.10 
		--from DashBoardBudgets (NOLOCK) 
		--where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
		--and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear) 
		--and (DashBoardBudgets.Loc_No = #DashboardUserLocSum.Loc_No)),0))
	-- from after sum(BUD_GMPerLb) 

	if @ShowResults = 1 select * from #DashboardBranchSum order BY Loc_No
	--
	-- Create Company summary
	SELECT #DashboardUserLocSum.CurMonth, #DashboardUserLocSum.CurYear, 
	SUM(TD_GrossMarginDollar) as TD_GrossMarginDollar, 
	TD_GrossMarginPct = case SUM(TD_SalesDollar) 
	when 0 then 0
	else SUM(TD_GrossMarginDollar) / SUM(TD_SalesDollar)
	end, 
	SUM(TD_SalesDollar) as TD_SalesDollar, 
	SUM(TD_OrderCount) as TD_OrderCount, 
	SUM(TD_LineCount) as TD_LineCount, 
	SUM(TD_LbsShipped) as TD_LbsShipped, 
	TD_PricePerLb = case SUM(TD_LbsShipped)
	when 0 then 0
	else SUM(TD_SalesDollar) / SUM(TD_LbsShipped) end, 
	TDBrnExpBud = (SELECT sum(TDBrnExpBud) FROM DashboardBUDBrnExp (NOLOCK)), 
	-- CSR 03/09/09: removed +(SUM(TD_SalesDollar)*0.10) after (NOLOCK))
	SUM(MTD_GrossMarginDollar) as MTD_GrossMarginDollar, 
	MTD_GrossMarginPct = case SUM(MTD_SalesDollar)
	when 0 then 0
	else SUM(MTD_GrossMarginDollar) / SUM(MTD_SalesDollar) end, 
	SUM(MTD_SalesDollar) as MTD_SalesDollar,
	SUM(MTD_OrderCount) as MTD_OrderCount, 
	SUM(MTD_LineCount) as MTD_LineCount, 
	SUM(MTD_LbsShipped) as MTD_LbsShipped, 
	MTD_PricePerLb = case SUM(MTD_LbsShipped)
	when 0 then 0
	else SUM(MTD_SalesDollar) / SUM(MTD_LbsShipped) end, 
	MTDBrnExpBud = (SELECT sum(MTDBrnExpBud) FROM DashboardBUDBrnExp (NOLOCK)), 
	-- CSR 03/13/09: removed +(SUM(MTD_SalesDollar)*0.10)
	AVG_GrossMarginDollar = case DayOfMonth when 0 then 0 else SUM(MTD_GrossMarginDollar)/DayOfMonth end, 
	AVG_GrossMarginPct = case SUM(MTD_SalesDollar)*DayOfMonth
	when 0 then 0
	else (SUM(MTD_GrossMarginDollar)/DayOfMonth) / (SUM(MTD_SalesDollar)/DayOfMonth) end , 
	AVG_SalesDollar = case DayOfMonth when 0 then 0 else SUM(MTD_SalesDollar)/DayOfMonth end, 
	AVG_OrderCount = case DayOfMonth when 0 then 0 else SUM(MTD_OrderCount)/DayOfMonth end, 
	AVG_LineCount = case DayOfMonth when 0 then 0 else SUM(MTD_LineCount)/DayOfMonth end, 
	AVG_LbsShipped = case DayOfMonth when 0 then 0 else SUM(MTD_LbsShipped)/DayOfMonth end, 
	AVG_PricePerLb = case SUM(MTD_LbsShipped)*DayOfMonth
	when 0 then 0
	else (SUM(MTD_SalesDollar)/DayOfMonth) / (SUM(MTD_LbsShipped)/DayOfMonth) end, 
	AVGBrnExpBud = case DayOfMonth 
		when 0 then 0 
		else ((SELECT sum([MTDBrnExpBud]) FROM DashboardBUDBrnExp (NOLOCK)))/DayOfMonth end, 
		-- CSR 03/13/09: removed +(SUM(MTD_SalesDollar)*0.10) from after (NOLOCK)))
	BUD_GrossMarginDollar = isnull((select sum(BUD_GrossMarginDollar) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0),
	BUD_GrossMarginPct = isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0),
	BUD_SalesDollar = isnull((select sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0),
	0 as BUD_OrderCount,
	0 as BUD_LineCount,
	BUD_LbsShipped  = isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0),
	BUD_PricePerLb = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0) when 0 then 0 else
	isnull((select sum(BUD_SalesDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0) end,
	BUD_GMPerLb = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0) when 0 then 0 else 
	isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK) where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth)
	and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0) end,
	BUDBrnExpBud = (SELECT sum(BUDBrnExpBud) FROM DashboardBUDBrnExp (NOLOCK)) 
	--CSR 03/13/09: removed +(isnull((select sum(BUD_SalesDollar)*.10 from DashBoardBudgets (NOLOCK) 
	--where (DashBoardBudgets.CurMonth = #DashboardUserLocSum.CurMonth) 
	--and (DashBoardBudgets.CurYear = #DashboardUserLocSum.CurYear)),0))
	--after (NOLOCK)) 
	into #DashboardCompanySum
	FROM #DashboardUserLocSum (NOLOCK), DashboardRanges Dates (NOLOCK)
	WHERE (Dates.DashboardParameter = 'CurrentMonth')
	GROUP BY #DashboardUserLocSum.CurMonth, #DashboardUserLocSum.CurYear, DayOfMonth

	if @ShowResults = 1 select * from #DashboardCompanySum
	--
	declare @Region varchar(20)
	-- East Region
	set @Region = 'East'
	--
	select TempRaw.*,
	(CorpData.MTD_GrossMarginDollar)/2 AS AVG_GrossMarginDollar, 
	AVG_GrossMarginPct = case (CorpData.MTD_SalesDollar)
	when 0 then 0
	else ((CorpData.MTD_GrossMarginDollar)) / ((CorpData.MTD_SalesDollar)) end , 
	(CorpData.MTD_SalesDollar)/2 AS AVG_SalesDollar, 
	(CorpData.MTD_OrderCount)/2 AS AVG_OrderCount, 
	(CorpData.MTD_LineCount)/2 AS AVG_LineCount, 
	(CorpData.MTD_LbsShipped)/2 as AVG_LbsShipped, 
	AVG_PricePerLb = case (CorpData.MTD_LbsShipped)
	when 0 then 0
	else ((CorpData.MTD_SalesDollar)) / ((CorpData.MTD_LbsShipped)) end
	into #DashboardEastSum
	from #DashboardCompanySum CorpData, 
	(SELECT UserData.CurMonth, UserData.CurYear, 
		SUM(UserData.TD_GrossMarginDollar) as TD_GrossMarginDollar, 
		TD_GrossMarginPct = case SUM(UserData.TD_SalesDollar) 
		when 0 then 0
		else SUM(UserData.TD_GrossMarginDollar) / SUM(UserData.TD_SalesDollar)
		end, 
		SUM(UserData.TD_SalesDollar) as TD_SalesDollar, 
		SUM(UserData.TD_OrderCount) as TD_OrderCount, 
		SUM(UserData.TD_LineCount) as TD_LineCount, 
		SUM(UserData.TD_LbsShipped) as TD_LbsShipped, 
		TD_PricePerLb = case SUM(UserData.TD_LbsShipped)
		when 0 then 0
		else SUM(UserData.TD_SalesDollar) / SUM(UserData.TD_LbsShipped) end, 
		SUM(UserData.MTD_GrossMarginDollar) as MTD_GrossMarginDollar, 
		MTD_GrossMarginPct = case SUM(UserData.MTD_SalesDollar)
		when 0 then 0
		else SUM(UserData.MTD_GrossMarginDollar) / SUM(UserData.MTD_SalesDollar) end, 
		SUM(UserData.MTD_SalesDollar) as MTD_SalesDollar,
		SUM(UserData.MTD_OrderCount) as MTD_OrderCount, 
		SUM(UserData.MTD_LineCount) as MTD_LineCount, 
		SUM(UserData.MTD_LbsShipped) as MTD_LbsShipped, 
		MTD_PricePerLb = case SUM(UserData.MTD_LbsShipped)
		when 0 then 0
		else SUM(UserData.MTD_SalesDollar) / SUM(UserData.MTD_LbsShipped) end, 
		BUD_GrossMarginDollar = isnull((select sum(BUD_GrossMarginDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_GrossMarginPct = isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_SalesDollar = isnull((select sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		0 as BUD_OrderCount,
		0 as BUD_LineCount,
		BUD_LbsShipped = isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_PricePerLb  = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) when 0 then 0 else
		isnull((select sum(BUD_SalesDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) end,
		BUD_GMPerLb  = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) when 0 then 0 else
		isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) end
		FROM #DashboardUserLocSum UserData (NOLOCK), DashboardRanges Dates (NOLOCK), LocMaster (NOLOCK) 
		WHERE (Dates.DashboardParameter = 'CurrentMonth') 
		and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)
		GROUP BY UserData.CurMonth, UserData.CurYear, DayOfMonth) TempRaw

	if @ShowResults = 1 select * from #DashboardEastSum
	--
	-- West Region
	set @Region = 'West'
	--
	select TempRaw.*,
	(CorpData.MTD_GrossMarginDollar)/2 AS AVG_GrossMarginDollar, 
	AVG_GrossMarginPct = case (CorpData.MTD_SalesDollar)
	when 0 then 0
	else ((CorpData.MTD_GrossMarginDollar)) / ((CorpData.MTD_SalesDollar)) end , 
	(CorpData.MTD_SalesDollar)/2 AS AVG_SalesDollar, 
	(CorpData.MTD_OrderCount)/2 AS AVG_OrderCount, 
	(CorpData.MTD_LineCount)/2 AS AVG_LineCount, 
	(CorpData.MTD_LbsShipped)/2 as AVG_LbsShipped, 
	AVG_PricePerLb = case (CorpData.MTD_LbsShipped)
	when 0 then 0
	else ((CorpData.MTD_SalesDollar)) / ((CorpData.MTD_LbsShipped)) end
	into #DashboardWestSum
	from #DashboardCompanySum CorpData, 
	(SELECT UserData.CurMonth, UserData.CurYear, 
		SUM(UserData.TD_GrossMarginDollar) as TD_GrossMarginDollar, 
		TD_GrossMarginPct = case SUM(UserData.TD_SalesDollar) 
		when 0 then 0
		else SUM(UserData.TD_GrossMarginDollar) / SUM(UserData.TD_SalesDollar)
		end, 
		SUM(UserData.TD_SalesDollar) as TD_SalesDollar, 
		SUM(UserData.TD_OrderCount) as TD_OrderCount, 
		SUM(UserData.TD_LineCount) as TD_LineCount, 
		SUM(UserData.TD_LbsShipped) as TD_LbsShipped, 
		TD_PricePerLb = case SUM(UserData.TD_LbsShipped)
		when 0 then 0
		else SUM(UserData.TD_SalesDollar) / SUM(UserData.TD_LbsShipped) end, 
		SUM(UserData.MTD_GrossMarginDollar) as MTD_GrossMarginDollar, 
		MTD_GrossMarginPct = case SUM(UserData.MTD_SalesDollar)
		when 0 then 0
		else SUM(UserData.MTD_GrossMarginDollar) / SUM(UserData.MTD_SalesDollar) end, 
		SUM(UserData.MTD_SalesDollar) as MTD_SalesDollar,
		SUM(UserData.MTD_OrderCount) as MTD_OrderCount, 
		SUM(UserData.MTD_LineCount) as MTD_LineCount, 
		SUM(UserData.MTD_LbsShipped) as MTD_LbsShipped, 
		MTD_PricePerLb = case SUM(UserData.MTD_LbsShipped)
		when 0 then 0
		else SUM(UserData.MTD_SalesDollar) / SUM(UserData.MTD_LbsShipped) end, 
		BUD_GrossMarginDollar = isnull((select sum(BUD_GrossMarginDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_GrossMarginPct = isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_SalesDollar = isnull((select sum(BUD_SalesDollar) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		0 as BUD_OrderCount,
		0 as BUD_LineCount,
		BUD_LbsShipped = isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0),
		BUD_PricePerLb  = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) when 0 then 0 else
		isnull((select sum(BUD_SalesDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) end,
		BUD_GMPerLb  = case isnull((select sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) when 0 then 0 else
		isnull((select sum(BUD_GrossMarginDollar)/sum(BUD_LbsShipped) from DashBoardBudgets (NOLOCK), LocMaster (NOLOCK) where (DashBoardBudgets.CurMonth = UserData.CurMonth)
		and (DashBoardBudgets.CurYear = UserData.CurYear) and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)),0) end
		FROM #DashboardUserLocSum UserData (NOLOCK), DashboardRanges Dates (NOLOCK), LocMaster (NOLOCK) 
		WHERE (Dates.DashboardParameter = 'CurrentMonth') 
		and (LocMaster.LocID = Loc_No)
		and (LocMaster.FFRegion = @Region)
		GROUP BY UserData.CurMonth, UserData.CurYear, DayOfMonth) TempRaw

	if @ShowResults = 1 select * from #DashboardWestSum
	--
	-- Clear and fill the tables
	--
	truncate table DashBoard_UserLoc
	insert into DashBoard_UserLoc 
	( UserID
      ,[Loc_No]
      ,[CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[LMTD_GrossMarginDollar]
      ,[LMTD_GrossMarginPct]
      ,[LMTD_SalesDollar]
      ,[LMTD_OrderCount]
      ,[LMTD_LineCount]
      ,[LMTD_LbsShipped]
      ,[LMTD_PricePerLb]
	)
	select 
      UserID
	  ,[Loc_No]
      ,[CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[LMTD_GrossMarginDollar]
      ,[LMTD_GrossMarginPct]
      ,[LMTD_SalesDollar]
      ,[LMTD_OrderCount]
      ,[LMTD_LineCount]
      ,[LMTD_LbsShipped]
      ,[LMTD_PricePerLb]
	from #DashBoardUserSum
	where not
		(TD_SalesDollar = 0
		and MTD_SalesDollar = 0
		and LMTD_SalesDollar = 0)
	--
	--
	truncate table DashBoard_Branch
	insert into DashBoard_Branch 
	(
      [Loc_No]
      ,[CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[TDBrnExpBud]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[MTDBrnExpBud]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[AVGBrnExpBud]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
      ,[BUDBrnExpBud]
	)
	select 
      [Loc_No]
      ,[CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[TDBrnExpBud]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[MTDBrnExpBud]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[AVGBrnExpBud]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
      ,[BUDBrnExpBud]
	from #DashboardBranchSum
	--
	truncate table DashBoard_Company
	insert into DashBoard_Company 
	(
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[TDBrnExpBud]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[MTDBrnExpBud]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[AVGBrnExpBud]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
      ,[BUDBrnExpBud]
	)
	select 
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[TDBrnExpBud]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[MTDBrnExpBud]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[AVGBrnExpBud]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
      ,[BUDBrnExpBud]
	from #DashboardCompanySum
	--
	truncate table DashBoard_EastRegion
	insert into DashBoard_EastRegion 
	(
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
	)
	select 
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
	from #DashboardEastSum
	--
	truncate table DashBoard_WestRegion
	insert into DashBoard_WestRegion 
	(
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
	)
	select 
      [CurMonth]
      ,[CurYear]
      ,[TD_GrossMarginDollar]
      ,[TD_GrossMarginPct]
      ,[TD_SalesDollar]
      ,[TD_OrderCount]
      ,[TD_LineCount]
      ,[TD_LbsShipped]
      ,[TD_PricePerLb]
      ,[MTD_GrossMarginDollar]
      ,[MTD_GrossMarginPct]
      ,[MTD_SalesDollar]
      ,[MTD_OrderCount]
      ,[MTD_LineCount]
      ,[MTD_LbsShipped]
      ,[MTD_PricePerLb]
      ,[AVG_GrossMarginDollar]
      ,[AVG_GrossMarginPct]
      ,[AVG_SalesDollar]
      ,[AVG_OrderCount]
      ,[AVG_LineCount]
      ,[AVG_LbsShipped]
      ,[AVG_PricePerLb]
      ,[BUD_GrossMarginDollar]
      ,[BUD_GrossMarginPct]
      ,[BUD_SalesDollar]
      ,[BUD_OrderCount]
      ,[BUD_LineCount]
      ,[BUD_LbsShipped]
      ,[BUD_PricePerLb]
	from #DashboardWestSum


--exec pDashBoardTempExtracts
--go


END

GO
