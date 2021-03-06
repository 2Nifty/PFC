USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pDashboardCSRPerformance]    Script Date: 11/16/2011 17:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Sathish
-- Create date: 1/10/2011
-- Description:	Procedure to create CSR Performance report
-- Step 1: Read all the MTD record from SOHeaderHist and create MTDTemp table then create MTD column data
-- Step 2: From the MTD temp table filter only day sales & create Day column data
-- Step 3: Filter TempTable using order source to create eCommerce Order & Lines Rows
-- Step 4: Read ERP.DTQ_CustomerQuotation table to create CSR Order & Lines Rows
-- Step 5: Compute Avg Column (we are computing Avg column separately to calculate forcast column)
-- =============================================
CREATE PROCEDURE [dbo].[pDashboardCSRPerformance] @userId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from	
	SET NOCOUNT ON;
	 	
	declare @CurDateBegin  datetime;
	declare @CurDateEnd	datetime;
	declare @MTDBegin datetime;
	declare @MTDEnd datetime;
	declare @curMonth integer;
	declare @curYear integer; 	
	declare @totWorkDaysofMonth integer;
	declare @CurDateofMonth integer;
	declare @CustCnt integer;
	declare @ActCnt integer;	
	declare @Lns integer;
	declare @ActCntMTD integer;	
	declare @LnsMTD integer;
	declare @eComOrdDol integer;
	declare @eComGMPct decimal(18,2);
	declare @eComOrd integer;
	declare @eComLns integer;
	declare @eComOrdDolMTD integer;
	declare @eComGMPctMTD decimal(18,2);
	declare @eComOrdMTD integer;
	declare @eComLnsMTD integer;
	declare @CSROrd integer;
	declare @CSRLns integer;
	declare @CSROrdMTD integer;
	declare @CSRLnsMTD integer;	
	declare @GMDolAvg integer;
	declare @GMPctAvg decimal(18,2);
	declare @SlsDolAvg integer;
	declare @OrdAvg integer;
	declare @LnsAvg integer;
	declare @CustCntAvg integer;
	declare @ActCntAvg integer;
	declare @eComOrdDolAvg integer;
	declare @eComGMPctAvg  decimal(18,2);
	declare @eComOrdAvg integer;
	declare @eComLnsAvg integer;
	declare @CSROrdAvg integer;
	declare @CSRLnsAvg integer;
	declare @LbsAvg integer;
	declare @PriceLbAvg decimal(18,3);
	declare @GMLbAvg decimal(18,3);

	declare @GMDolFcst integer;	
	declare @SlsDolFcst integer;
	declare @OrdFcst integer;
	declare @LnsFcst integer;
	declare @CustCntFcst integer;
	declare @ActCntFcst integer;
	declare @eComOrdDolFcst integer;	
	declare @eComOrdFcst integer;
	declare @eComLnsFcst integer;
	declare @CSROrdFcst integer;
	declare @CSRLnsFcst integer;
	declare @LbsFcst integer;
	
	-- Get the dashborad date values
	Select	@CurDateBegin=BegDate,
			@CurDateEnd=EndDate						
	From	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges
	Where	DashboardParameter='CurrentDay'
	
	Select	@MTDBegin=BegDate,
			@MTDEnd=EndDate,			
			@CurDateofMonth=[DayOfMonth],
			@curMonth = MonthValue,
			@curYear = YearValue
	From	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges
	Where	DashboardParameter='CurrentMonth'

	Select	@totWorkDaysofMonth = count(*)
	From	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.FiscalCalendar 
	Where	FiscalCalMonth=@curMonth and FiscalCalYear=@curYear and WorkDay=1

	-- Get total cust assigned for this CSR
	select	CustNo
	Into	#tempAssignedCustNo
	from	CustomerMaster CM (NOLOCK)  Left Outer Join 
			RepMaster RM (NOLOCK)
			On CM.SupportRepNo = RM.RepNo						
	Where	RM.RepNotes like @userId
	
	Select @CustCnt=@@Rowcount
	
	-- Step 1: Get MTD data from SOHeaderHist & create MTD Column values

		-- MTD Columns Data (SOHeader Values)	
		Select	 SOH.SellToCustNo
				,SOH.OrderNo
				,SOH.NetSales as NetSales			
				,SOH.TotalCost as TotalCost			
				,SOH.ShipWght as ShipWght
				,RM.RepNotes
				,SOH.InvoiceDt
				,SOH.OrderSource	
		Into	#tempMTDSOHdrHist
		FROM	RepMaster (NOLOCK) RM RIGHT OUTER JOIN
				CustomerMaster (NOLOCK) CM ON RM.RepNo = CM.SupportRepNo RIGHT OUTER JOIN
				SOHeaderHist  (NOLOCK) SOH ON CM.CustNo = SOH.SellToCustNo
		where	SOH.InvoiceDt between @MTDBegin and @MTDEnd
				and RM.RepNotes like @userId
				and SOH.DeleteDt is null
		
		-- MTD Columns Data (SODetail values - to get the No of lines)
		Select	 SOD.LineNumber as LineNumber
				,SOH.InvoiceDt	
				,SOH.OrderSource		
		Into	#tempMTDSODetailHist
		FROM	RepMaster RM RIGHT OUTER JOIN
				CustomerMaster (NOLOCK) CM ON RM.RepNo = CM.SupportRepNo RIGHT OUTER JOIN
				SOHeaderHist (NOLOCK) SOH ON CM.CustNo = SOH.SellToCustNo RIGHT OUTER JOIN
				SODetailHist (NOLOCK) SOD ON SOH.pSOHeaderHistID = SOD.fSOHeaderHistID
		where	SOH.InvoiceDt between @MTDBegin and @MTDEnd	 
				and RM.RepNotes like @userId
				and SOH.DeleteDt is null
				and SOD.DeleteDt is null 				
		
		-- MTD: Total no of Lines Created	
		Set @LnsMTD = @@rowcount;

		-- MTD: Total Cust Bought
		Select	@ActCntMTD=count(distinct SellToCustNo) 
		From	#tempMTDSOHdrHist	

	--	End of Step 1 

	-- Step 2: Filter Day data from MTD temp table & create Day Column values
		
		Select	 SellToCustNo
				,OrderNo
				,NetSales as NetSales
				,TotalCost as TotalCost			
				,ShipWght as ShipWght
				,RepNotes
				,OrderSource	
		Into	#tempDaySOHdrHist
		FROM	#tempMTDSOHdrHist
		where	InvoiceDt between @CurDateBegin and @CurDateEnd			
		
		-- Get SODetail values (to get the No of lines)
		Select	LineNumber as LineNumber
				,OrderSource			
		Into	#tempDaySODetailHist
		FROM	#tempMTDSODetailHist
		where	InvoiceDt between @CurDateBegin and @CurDateEnd							
		
		-- Day: Total no of Lines Created	
		Set @Lns = @@rowcount;
		
		-- Day: Total Cust Bought
		Select	@ActCnt=count(distinct SellToCustNo) 
		From	#tempDaySOHdrHist	

	--	End of Step 2

	-- Step 3: Day eCommerce data 

		Select	 @eComOrdDol = Cast(Sum((NetSales)) as Decimal(18,0))
				,@eComGMPct = Cast(Case when Sum(NetSales) = 0 then 0  else ((Sum((NetSales-TotalCost))/Sum(NetSales) * 100)) End as Decimal(18,2))
				--,@eComOrd=Count(*)
		FROM	#tempDaySOHdrHist
		where	OrderSource in ('DC','IX','WQ','FP','EI')

		-- MTD eCommerce data
		Select	 @eComOrdDolMTD = Cast(Sum((NetSales)) as Decimal(18,0))
				,@eComGMPctMTD = Cast(Case when Sum(NetSales) = 0 then 0  else ((Sum((NetSales-TotalCost))/Sum(NetSales) * 100)) End as Decimal(18,2))
				,@eComGMPctAvg = Cast(Case when Sum(NetSales) = 0 then 0  else (((Sum(NetSales-TotalCost) / @CurDateofMonth) / (Sum(NetSales)/ @CurDateofMonth) * 100)) End as Decimal(18,2))
				--,@eComOrdMTD = Count(*)
		FROM	#tempMTDSOHdrHist
		where	OrderSource in ('DC','IX','WQ','FP','EI')
		
--		Select	@eComLnsMTD = Count(*)
--		FROM	#tempMTDSODetailHist
--		where	OrderSource in ('DC','IX','WQ','FP','EI')

		-- eComm Order & Lns count are calculated separatly using PFCQuoteDB tables (may be deleted)
			-- Select Query For no.of Quotes
			Select	[EntryDt] as QuotationDate
					,SessionID
			Into	#tempMTDeComQuotes		
			From	WebActivityPosting (NOLOCK)		
			Where	Cast(CONVERT(nvarchar(20), [EntryDt], 101) as Datetime)  between @MTDBegin and @MTDEnd
					And [CustNo] in ( Select	CustNo from #tempAssignedCustNo)		
					And OrderSource in ('DC','IX','WQ')

			-- MTD eCom Quotes
			Select	@eComLnsMTD = @@rowcount;

			-- Select Query for no.of orders
			Select  PO.PurchaseOrderDate	
			Into	#tempMTDeComOrds	
			From    DTQ_CustomerPendingOrderDetail POD  (NOLOCK) INNER JOIN
					DTQ_CustomerPendingOrder PO (NOLOCK) ON POD.PurchaseOrderID = PO.ID
			Where	(Cast(CONVERT(nvarchar(20),PurchaseOrderDate , 101) as Datetime) between @MTDBegin AND @MTDEnd)
					and PO.CustomerNumber in ( Select	CustNo from #tempAssignedCustNo)
					and PO.OrderSource in ('DC','IX','WQ')
				
			-- MTD eCom Orders		
			Select	@eComOrdMTD = @@rowcount

			-- Day eCom Quotes
			Select	@eComLns = count(*)					
			FROM	#tempMTDeComQuotes
			where	Cast(CONVERT(nvarchar(20), QuotationDate, 101) as Datetime) between @CurDateBegin and @CurDateEnd	
			
			-- Day eCom Orders
			Select	@eComOrd = count(*)
			From	#tempMTDeComOrds	
			where	(Cast(CONVERT(nvarchar(20), PurchaseOrderDate , 101) as Datetime) between @CurDateBegin and @CurDateEnd)
					

		-- End of eCom Calc (using PFCQuoteDB)

	-- End of Step 3

	-- Step 4: Read ERP.DTQ_Quotation to create CSR Quote's row		
		select	Quote.QuotationDate,
				Quote.SessionID				
		into	#tempMTDCSRQuotes
		from	DTQ_CustomerQuotation Quote (NOLOCK)
		where	QuotationDate between @MTDBegin and @MTDEnd
				and Quote.DeleteDt is null
				and CustomerNumber in ( Select	CustNo from #tempAssignedCustNo)
		
		-- MTD CSR Quotes
		Select @CSRLnsMTD = @@rowcount;

		Select @CSROrdMTD = count(distinct SessionID)
		From #tempMTDCSRQuotes				
				
		-- Day CSR Quotes
		Select	@CSRLns = count(*)					
		FROM	#tempMTDCSRQuotes
		where	QuotationDate between @CurDateBegin and @CurDateEnd	
			
		Select	@CSROrd = count(distinct SessionID)					
		FROM	#tempMTDCSRQuotes
		where	QuotationDate between @CurDateBegin and @CurDateEnd	
		
	-- End of Step 4

	-- Step 5: Compute Avg Column
	
		Select	@GMDolAvg = Cast(Sum((NetSales-TotalCost)) / @CurDateofMonth as Decimal(18,0))
				,@GMPctAvg = Cast((Case when Sum(NetSales) = 0 then 0  else ((Sum(NetSales-TotalCost) / @CurDateofMonth)/(Sum(NetSales)/ @CurDateofMonth) * 100) End ) as Decimal(18,2)) 
				,@SlsDolAvg = Cast(Sum(NetSales) / @CurDateofMonth as Decimal(18,0)) 
				,@OrdAvg = Count(*) / @CurDateofMonth
				,@LnsAvg = @LnsMTD / @CurDateofMonth 
				,@CustCntAvg = @CustCnt / @CurDateofMonth 
				,@ActCntAvg = @ActCntMTD / @CurDateofMonth 
				,@eComOrdDolAvg = @eComOrdDolMTD / @CurDateofMonth
				,@eComGMPctAvg = @eComGMPctAvg 
				,@eComOrdAvg = @eComOrdMTD / @CurDateofMonth 
				,@eComLnsAvg = @eComLnsMTD / @CurDateofMonth 
				,@CSROrdAvg = @CSROrdMTD / @CurDateofMonth 
				,@CSRLnsAvg = @CSRLnsMTD / @CurDateofMonth
				,@LbsAvg = Cast(Sum(ShipWght)/@CurDateofMonth as Decimal(18,0)) 
				,@PriceLbAvg = Cast((Case when Sum(ShipWght) = 0 then 0  else ((Sum(NetSales) / @CurDateofMonth ) /(Sum(ShipWght)/ @CurDateofMonth) ) End) as Decimal(18,3)) 
				,@GMLbAvg = Cast((Case when Sum(ShipWght) = 0 then 0  else ((Sum(NetSales-TotalCost)/ @CurDateofMonth)/(Sum(ShipWght)/ @CurDateofMonth)) End)  as Decimal(18,3)) 
		FROM	#tempMTDSOHdrHist	
		
	-- End of Step 5

	-- Output: Day Column 
	Select	 Cast(isnull(Sum((NetSales-TotalCost)),0) as Decimal(18,0)) as GMDol			
			,Cast(isnull(Case when Sum(NetSales) = 0 then 0  else ((Sum((NetSales-TotalCost))/Sum(NetSales) * 100)) End,0) as Decimal(18,2)) as GMPct			
			,Cast(isnull(Sum(NetSales),0) as Decimal(18,0)) as SlsDol
			,Count(*) as Ord
			,@Lns as Lns
			,@CustCnt as CustCnt
			,@ActCnt as ActCnt
			,isnull(@eComOrdDol,0) as eComOrdDol
			,isnull(@eComGMPct,0) as eComGMPct
			,@eComOrd as eComOrd
			,@eComLns as eComLns
			,@CSROrd as CSROrd
			,@CSRLns as CSRLns
			,Cast(isnull(Sum(ShipWght),0) as Decimal(18,0)) as Lbs
			,Cast(isnull(Case when Sum(ShipWght) = 0 then 0  else (Sum(NetSales)/Sum(ShipWght)) End,0) as Decimal(18,3)) as PriceLb
			,Cast(isnull(Case when Sum(ShipWght) = 0 then 0  else (Sum(NetSales-TotalCost)/Sum(ShipWght)) End,0) as Decimal(18,3)) as GMLb						
	FROM	#tempDaySOHdrHist		
	
	-- Output: Avg Column 
	Select	 isnull(@GMDolAvg,0) as GMDolAvg
			,isnull(@GMPctAvg,0) As GMPctAvg
			,isnull(@SlsDolAvg,0) as SlsDolAvg
			,@OrdAvg as OrdAvg
			,@LnsAvg as LnsAvg
			,@CustCntAvg as CustCntAvg
			,@ActCntAvg as ActCntAvg
			,isnull(@eComOrdDolAvg,0) as eComOrdDolAvg
			,isnull(@eComGMPctAvg,0) as eComGMPctAvg
			,@eComOrdAvg as eComOrdAvg
			,@eComLnsAvg as eComLnsAvg
			,@CSROrdAvg as CSROrdAvg
			,@CSRLnsAvg as CSRLnsAvg
			,isnull(@LbsAvg,0) as LbsAvg
			,isnull(@PriceLbAvg,0) as PriceLbAvg
			,isnull(@GMLbAvg,0) as GMLbAvg	

	-- Output: MTD Column 
	Select	 Cast(isnull(Sum((NetSales-TotalCost)),0) as Decimal(18,0)) as GMDolMTD
			,Cast(isnull(Case when Sum(NetSales) = 0 then 0  else ((Sum((NetSales-TotalCost))/Sum(NetSales) * 100)) End,0) as Decimal(18,2)) As GMPctMTD
			,Cast(isnull(Sum(NetSales),0) as Decimal(18,0)) as SlsDolMTD
			,Count(*) as OrdMTD
			,@LnsMTD as LnsMTD
			,@CustCnt as CustCntMTD
			,@ActCntMTD as ActCntMTD
			,isnull(@eComOrdDolMTD,0) as eComOrdDolMTD
			,isnull(@eComGMPctMTD,0) as eComGMPctMTD
			,@eComOrdMTD as eComOrdMTD
			,@eComLnsMTD as eComLnsMTD
			,@CSROrdMTD as CSROrdMTD
			,@CSRLnsMTD as CSRLnsMTD
			,Cast(isnull(Sum(ShipWght),0) as Decimal(18,0)) as LbsMTD
			,Cast(isnull(Case when Sum(ShipWght) = 0 then 0  else (Sum(NetSales)/Sum(ShipWght)) End,0) as Decimal(18,3)) as PriceLbMTD
			,Cast(isnull(Case when Sum(ShipWght) = 0 then 0  else (Sum(NetSales-TotalCost)/Sum(ShipWght)) End,0) as Decimal(18,3)) as GMLbMTD
	FROM	#tempMTDSOHdrHist	

	-- Output: Forecast Column 
	Select	isnull(@GMDolAvg * @totWorkDaysofMonth,0) as GMDolFcst
			,isnull(@SlsDolAvg  * @totWorkDaysofMonth,0) as SlsDolFcst
			,@OrdAvg  * @totWorkDaysofMonth as OrdFcst
			,@LnsAvg * @totWorkDaysofMonth as LnsFcst
			,@CustCntAvg * @totWorkDaysofMonth as  CustCntFcst
			,@ActCntAvg * @totWorkDaysofMonth as ActCntFcst 
			,isnull(@eComOrdDolAvg * @totWorkDaysofMonth,0) as eComOrdDolFcst
			,@eComOrdAvg * @totWorkDaysofMonth as eComOrdFcst
			,@eComLnsAvg * @totWorkDaysofMonth as eComLnsFcst
			,@CSROrdAvg * @totWorkDaysofMonth as CSROrdFcst
			,@CSRLnsAvg * @totWorkDaysofMonth as CSRLnsFcst
			,isnull(@LbsAvg  * @totWorkDaysofMonth,0) as LbsFcst

	-- output: Goals Column
	Select	cast(isnull(GMGoal * @totWorkDaysofMonth,0) as decimal(18,0)) as GMDolGoal
			,cast(isnull(GMPctGoal,0)as decimal(18,2)) as GMPctGoal
			,cast(isnull(SalesGoal * @totWorkDaysofMonth,0) as decimal(18,0)) as SlsGoal
			,cast(isnull(eComSalesGoal * @totWorkDaysofMonth,0) as decimal(18,0)) as eComSlsGoal
			,cast(isnull(eComGMPct,0) as decimal(18,2)) as eComGMPctGoal
			,cast(isnull(PricePerLbGoal,0)as decimal(18,3)) as PriceLbGoal  
			,cast(isnull(GMPerLbGoal,0)as decimal(18,3)) as GMLbGoal
	From	RepMaster (NOLOCK)
	Where	RepNotes like @userId

	--output: Data Used in CSR Dashboard page	
	Select	RepName
			,RepNo
			,RepNotes 
			,@CurDateBegin as CurDateBegin
			,@CurDateEnd as CurDateEnd
			,@MTDBegin as MothBegDate 
			,@MTDEnd as MothEndDate
	From	RepMaster (NOLOCK) RM			
	Where	RM.RepNotes like @userId

	-- Testing Data
	-- print 'Day Begin Dt:' + Cast(@CurDateBegin as varchar(20))+ ' ' + 'Day End Dt' + Cast(@CurDateEnd as varchar(20))
	-- print 'CurDateofMonth' + Cast(@CurDateofMonth as varchar(10))
	-- print 'Total Work Days of Month:' + Cast(@totWorkDaysofMonth as varchar(10))
END

-- Exec [pDashboardCSRPerformanceV2] 'kvesneski'
-- Table1: Day Column Data
-- Table2: Avg Column Data
-- Table3: MTD Column Data
-- Table4: Forcast Column Data
-- Table5: Goal Column Data
-- Table6: Rep data used in dashboard page

