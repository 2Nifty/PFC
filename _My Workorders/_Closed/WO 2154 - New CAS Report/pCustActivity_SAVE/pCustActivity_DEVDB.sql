use DEVPERP
go

drop proc pCustActivity
go

CREATE PROCEDURE [dbo].[pCustActivity]
	@Action varchar(50),				--CREATE:  creates temp table for param file data
										--GetList: returns the requested Customer records
										--GetHist: returns the requested SO History records
	@Period varchar(6),
	@CustShipLocation varchar(10),
	@ChainCd varchar(25),
	@ChainList nvarchar(4000),
	@CustNo varchar(10),
	@CustList nvarchar(4000),
	@FilterCd varchar(25),				--NoFilter; ChainCd; ChainXLS; ChainList; CustNo; CustXLS; CustList;
	@SalesTerritory varchar(10),
	@OutsideRep varchar(40),
	@InsideRep varchar(40),
	@RegionalMgr varchar(40),
	@BuyGroup varchar(4),
	@ParamTbl varchar(255),
	@UserName varchar(50)

AS

DECLARE	@BegDt datetime,
		@EndDt datetime,
		@BegCurYTD datetime,
		@EndCurYTD datetime,
		@BegCurMTD datetime,
		@EndCurMTD datetime,
		@LastYTD varchar(4),
		@BegLastYTD datetime,
		@EndLastYTD datetime,
		@PrevYTD varchar(4),
		@BegPrevYTD datetime,
		@EndPrevYTD datetime

DECLARE @SQL nvarchar(4000)
DECLARE @FilterTbl table(Value varchar(100))

BEGIN
	-- ============================================
	-- Date		Developer	Action          
	-- --------------------------------------------
	-- 12/22/2010	Tod		Create
	-- ============================================


	--SET Beginning Period Date
	SELECT	@BegDt = CurFiscalMthBeginDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + CAST(FiscalCalMonth as VARCHAR(2)) = @Period

	--SET Ending Period Date
	SELECT	@EndDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + CAST(FiscalCalMonth as VARCHAR(2)) = @Period

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME),
			@BegCurMTD = CurFiscalMthBeginDt,
			@EndCurMTD = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	FROM	FiscalCalendar
	WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
	--select @BegCurYTD, @EndCurYTD, @BegCurMTD, @EndCurMTD

	--SET Last Year's Fiscal
	SELECT	@LastYTD = FiscalYear,
			@BegLastYTD = CurFiscalYearBeginDt,
			@EndLastYTD = CurFiscalYearEndDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate()-365 AS FLOAT)) AS DATETIME)
	--select @LastYTD, @BegLastYTD, @EndLastYTD

	--SET 2 Years Previous Fiscal
	SELECT	@PrevYTD = FiscalYear,
			@BegPrevYTD = CurFiscalYearBeginDt,
			@EndPrevYTD = CurFiscalYearEndDt
	FROM	FiscalCalendar
	WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate()-730 AS FLOAT)) AS DATETIME)
	--select @PrevYTD, @BegPrevYTD, @EndPrevYTD


	-------------------------------------------
	-- Create temp table for param file data --
	-------------------------------------------
	IF (@Action = 'CREATE')
		BEGIN
			print 'Create temp table for param file data'

			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @ParamTbl + ']') AND type in (N'U'))
				BEGIN
					SET @SQL = 'DROP TABLE [dbo].[' + @ParamTbl + ']'
					print 'DROP: ' + @SQL
					EXEC (@SQL)
				END

			SET @SQL = 'CREATE TABLE [dbo].[' + @ParamTbl + ']([Value] [varchar](20) NULL) ON [PRIMARY]'
			print 'CREATE: ' + @SQL
			EXEC (@SQL)
		END

	----------------------------------------
	-- Find Customers or Chains to Report --
	----------------------------------------
	IF (@Action = 'GetList')
		BEGIN
			print 'Find Customers or Chains to Report'

			--Load Regional Managers
			SELECT	RegionalMgr.SalesRegionNo,
					RegionalMgr.RepName,
					RegionalLoc.LocID
			INTO	#tRegionLoc
			FROM	RepMaster RegionalMgr (NoLock) INNER JOIN
					LocMaster RegionalLoc (NoLock)
			ON		RegionalMgr.SalesRegionNo = RegionalLoc.SalesRegionNo
			WHERE	RepClass='R'

			IF (@FilterCd = 'NoFilter' or @FilterCd = 'ChainCd' or @FilterCd = 'CustNo')
				BEGIN
					--No filter or specific CustNo or ChainCd
					print ' - No filter; or specific CustNo or ChainCd [' + @FilterCd + ']'

					SELECT	DISTINCT Cust.pCustMstrID, Cust.CustNo, Cust.CustName
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo
				END

			IF (@FilterCd = 'ChainXLS')
				BEGIN
					--Use ChainXLS Only
					print ' - Use ChainXLS Only [' + @FilterCd + ']'
					print ' - Table: ' + @ParamTbl

					IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @ParamTbl + ']') AND type in (N'U'))
						BEGIN
							SET	@SQL = 'SELECT * FROM ' + @ParamTbl
							print 'LOAD: ' + @SQL
							INSERT INTO @FilterTbl(Value) EXEC (@SQL)
						END

					SELECT	DISTINCT Cust.pCustMstrID, Cust.CustNo, Cust.CustName
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') IN (SELECT Value FROM @FilterTbl) AND
							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo

					IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @ParamTbl + ']') AND type in (N'U'))
						BEGIN
							SET @SQL = 'DROP TABLE [dbo].[' + @ParamTbl + ']'
							print 'DROP: ' + @SQL
							EXEC (@SQL)
						END
				END

			IF (@FilterCd = 'ChainList')
				BEGIN
					--Use ChainList Only
					print ' - Use ChainList Only [' + @FilterCd + ']'

					SELECT	DISTINCT Cust.pCustMstrID, Cust.CustNo, Cust.CustName
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') IN (SELECT Value FROM fListToTablevarchar(REPLACE(@ChainList,'''',''),',')) AND
							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo
				END

			IF (@FilterCd = 'CustXLS')
				BEGIN
					--Use CustXLS Only
					print ' - Use CustXLS Only [' + @FilterCd + ']'
					print ' - Table: ' + @ParamTbl

					IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @ParamTbl + ']') AND type in (N'U'))
						BEGIN
							SET	@SQL = 'SELECT * FROM ' + @ParamTbl
							print 'LOAD: ' + @SQL
							INSERT INTO @FilterTbl(Value) EXEC (@SQL)
						END

					SELECT	DISTINCT Cust.pCustMstrID, Cust.CustNo, Cust.CustName
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
							isnull(Cust.CustNo,'') IN (SELECT Value FROM @FilterTbl) AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo

					IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @ParamTbl + ']') AND type in (N'U'))
						BEGIN
							SET @SQL = 'DROP TABLE [dbo].[' + @ParamTbl + ']'
							print 'DROP: ' + @SQL
							EXEC (@SQL)
						END
				END

			IF (@FilterCd = 'CustList')
				BEGIN
					--Use CustList Only
					print ' - Use CustList Only [' + @FilterCd + ']'
--					print @CustList
--					SELECT Value FROM fListToTablevarchar(@CustList,',') 

					SELECT	DISTINCT Cust.pCustMstrID, Cust.CustNo, Cust.CustName
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
							isnull(Cust.CustNo,'') IN (SELECT Value FROM fListToTablevarchar(REPLACE(@CustList,'''',''),',')) AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo
				END
			DROP TABLE #tRegionLoc
		END

	---------------------------------------
	-- Get Customer & sales History Data --
	---------------------------------------
	IF (@Action = 'GetHist')
		BEGIN
			print 'Get Customer & Sales History Data'

			--#tCatList: Load Categories
			SELECT	LD.ListValue as CatNo,
					LD.ListDtlDesc as CatDesc
			INTO	#tCatList
			FROM	ListMaster LM (NoLock) INNER JOIN
					ListDetail LD (NoLock)
			ON		LM.pListMasterID = LD.fListMasterID
			WHERE	LM.ListName = 'CategoryDesc'

			--#tItemBranch: Load ItemBranch Avg and Price Cost
			SELECT	IM.ItemNo,
					IB.Location,
					IB.UnitCost as AvgCost,
					IB.PriceCost
			INTO	#tItemBranch
			FROM	ItemMaster IM (NoLock) INNER JOIN
					ItemBranch IB (NoLock)
			ON		IM.pItemMasterID = IB.fItemMasterID

			--Table[0] - Customer Header Data
			SELECT	Cust.pCustMstrID,
					Cust.CustNo,
					isnull(Cust.ChainCd,'') as ChainCd,
					isnull(Cust.CustType,'') as CustType,							--Cust Type?
					isnull(Cust.BuyGroup,'') as BuyGroup,
'?Key Cust?' as KeyCust,
'?Comm Rep?' as CommRep,
					isnull(Cust.CustName,'') as CustName,
					isnull(Addr.AddrLine1,'') as AddrLine1,
					isnull(Addr.AddrLine2,'') as AddrLine2,
					isnull(Addr.City,'') as City,
					isnull(Addr.State,'') as [State],
					isnull(Addr.PostCd,'') as PostCd,
					isnull(Addr.PhoneNo,'') as PhoneNo,
					isnull(Addr.FaxPhoneNo,'') as FaxPhoneNo,
'?Contact?' as Contact,
					isnull(Cust.CustShipLocation,'') as SalesBranch,
					isnull(Loc.LocName,'') as LocName,
					isnull(InsideRep.RepNo,'') as InsideRepNo,
					isnull(InsideRep.RepName,'') as InsideRepName,
					isnull(OutsideRep.RepNo,'') as SalesRepNo,					--Sales Rep?
					isnull(OutsideRep.RepName,'') as SalesRepName,
'?Hub?' as Hub,
'?Terms?' as Terms,
					isnull(Cust.CreditLmt,'') as CreditLmt,
					--PFC Fields
					isnull(Cust.ContractSchd1,'') as ContractSchd1,
					isnull(Cust.ContractSchd2,'') as ContractSchd2,
					isnull(Cust.ContractSchd3,'') as ContractSchd3,
					isnull(Cust.ContractSchedule4,'') as ContractSchd4,
					isnull(Cust.ContractSchedule5,'') as ContractSchd5,
					isnull(Cust.ContractSchedule6,'') as ContractSchd6,
					isnull(Cust.ContractSchedule7,'') as ContractSchd7,
					isnull(Cust.TargetGrossMarginPct,0) as TargetGrossMarginPct,	--Default Gross Mgn %?
					isnull(Cust.GrossMarginPct,0) as GrossMarginPct,				--Default Gross Mgn %?
					isnull(Cust.WebDiscountPct,0) as WebDiscountPct,
					isnull(Cust.WebDiscountInd,'') as WebDiscountInd,
					isnull(Cust.CustomerDefaultPrice,0) as CustomerDefaultPrice,	--Default Price?
					isnull(Cust.CustomerPriceInd,'') as CustomerPriceInd
					--,Cust.*, Addr.*
			FROM	CustomerMaster Cust (NoLock) LEFT OUTER JOIN
					CustomerAddress Addr (NoLock)
			ON		Cust.pCustMstrID = Addr.fCustomerMasterID LEFT OUTER JOIN
					LocMaster Loc (NoLock)
			ON		Cust.CustShipLocation = Loc.LocID LEFT OUTER JOIN
					RepMaster InsideRep (NoLock)
			ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
					RepMaster OutsideRep (NoLock)
			ON		Cust.SlsRepNo = OutsideRep.RepNo
			WHERE	Cust.pCustMstrID = @CustNo AND
					isnull(Addr.Type,'') in ('','P')

			--Table[1] - Customer A/R Aging Data
			SELECT	Cust.pCustMstrId,
					Cust.CustNo,
					CAST(CAS.CurYear as CHAR(4)) + CAST(RIGHT(100+CAS.CurMonth,2) as CHAR(2)) as Period,
					CAS.AgingCur,
					CAS.Aging30,
					CAS.Aging60,
					CAS.AgingOver90 as Aging90,
					CAS.AgingTot,
					CAS.AgingCurPct,
					CAS.Aging30Pct,
					CAS.Aging60Pct,
					CAS.Aging90Pct,
					CAS.DSO
					--,*
			FROM	CustomerMaster Cust (NoLock) INNER JOIN
					OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CAS_CustomerData CAS --(NoLock)
			ON		Cust.CustNo = CAS.CustNo
			WHERE	Cust.pCustMstrID = @CustNo AND
					CAST(CAS.CurYear as CHAR(4)) + CAST(RIGHT(100+CAS.CurMonth,2) as CHAR(2)) = @Period

			--Table[2] - Sales Activity By Customer
			SELECT	isnull(CAS.MonthName,'~month~') as [MonthName],
					--CM - Fiscal Month/Current Year
					isnull(CAS.CMCorpRank,'') as CMCorpRank,
					isnull(CAS.CMTerRank,'') as CMTerRank,
					isnull(CAS.CMSales,0) as CMSales,
					isnull(CAS.CMGM,0) as CMGM,
					isnull(CAS.CMGMPct,0) as CMGMPct,
					isnull(CAS.CMLbs,0) as CMLbs,
					isnull(CAS.CMGMPerLb,0) as CMGMPerLb,
					isnull(CAS.CMAvgDolPerOrder,0) as CMAvgDolPerOrder,
					isnull(CAS.CMAvgDolPerLine,0) as CMAvgDolPerLine,
					isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
					isnull(CAS.CMOESales,0) as CMOESales,
					isnull(CAS.CMEComSales,0) as CMEComSales,
					isnull(CAS.CMMillSales,0) as CMMillSales,
					isnull(CAS.CMOELbs,0) as CMOELbs,
					isnull(CAS.CMEComLbs,0) as CMEComLbs,
					isnull(CAS.CMMillLbs,0) as CMMillLbs,
					isnull(CAS.CMOEOrders,0) as CMOEOrders,
					isnull(CAS.CMEComOrders,0) as CMEComOrders,
					isnull(CAS.CMMillOrders,0) as CMMillOrders,
					isnull(CAS.CMOELines,0) as CMOELines,
					isnull(CAS.CMEComLines,0) as CMEComLines,
					isnull(CAS.CMMillLines,0) as CMMillLines,
					isnull(CAS.CMOEQDol,0) as CMOEQDol,
					isnull(CAS.CMEComQDol,0) as CMEComQDol,
					isnull(CAS.CMOEQOrders,0) as CMOEQOrders,
					isnull(CAS.CMEComQOrders,0) as CMEComQOrders,
					isnull(CAS.CMOEQLines,0) as CMOEQLines,
					isnull(CAS.CMEComQLines,0) as CMEComQLines,
					isnull(CAS.CMRGACount,0) as CMRGACount,
					isnull(CAS.CMCreditCount,0) as CMCreditCount,
					--LM - Fiscal Month/Last Year
					isnull(CAS.LMCorpRank,'') as LMCorpRank,
					isnull(CAS.LMTerRank,'') as LMTerRank,
					isnull(CAS.LMSales,0) as LMSales,
					isnull(CAS.LMGM,0) as LMGM,
					isnull(CAS.LMGMPct,0) as LMGMPct,
					isnull(CAS.LMLbs,0) as LMLbs,
					isnull(CAS.LMGMPerLb,0) as LMGMPerLb,
					isnull(CAS.LMAvgDolPerOrder,0) as LMAvgDolPerOrder,
					isnull(CAS.LMAvgDolPerLine,0) as LMAvgDolPerLine,
					--isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
					isnull(CAS.LMOESales,0) as LMOESales,
					isnull(CAS.LMEComSales,0) as LMEComSales,
					isnull(CAS.LMMillSales,0) as LMMillSales,
					isnull(CAS.LMOELbs,0) as LMOELbs,
					isnull(CAS.LMEComLbs,0) as LMEComLbs,
					isnull(CAS.LMMillLbs,0) as LMMillLbs,
					isnull(CAS.LMOEOrders,0) as LMOEOrders,
					isnull(CAS.LMEComOrders,0) as LMEComOrders,
					isnull(CAS.LMMillOrders,0) as LMMillOrders,
					isnull(CAS.LMOELines,0) as LMOELines,
					isnull(CAS.LMEComLines,0) as LMEComLines,
					isnull(CAS.LMMillLines,0) as LMMillLines,
					isnull(CAS.LMOEQDol,0) as LMOEQDol,
					isnull(CAS.LMEComQDol,0) as LMEComQDol,
					isnull(CAS.LMOEQOrders,0) as LMOEQOrders,
					isnull(CAS.LMEComQOrders,0) as LMEComQOrders,
					isnull(CAS.LMOEQLines,0) as LMOEQLines,
					isnull(CAS.LMEComQLines,0) as LMEComQLines,
					isnull(CAS.LMRGACount,0) as LMRGACount,
					isnull(CAS.LMCreditCount,0) as LMCreditCount,
					--CY - Fiscal Year/Current Year
					isnull(CAS.CYCorpRank,'') as CYCorpRank,
					isnull(CAS.CYTerRank,'') as CYTerRank,
					isnull(CAS.CYSales,0) as CYSales,
					isnull(CAS.CYGM,0) as CYGM,
					isnull(CAS.CYGMPct,0) as CYGMPct,
					isnull(CAS.CYLbs,0) as CYLbs,
					isnull(CAS.CYGMPerLb,0) as CYGMPerLb,
					isnull(CAS.CYAvgDolPerOrder,0) as CYAvgDolPerOrder,
					isnull(CAS.CYAvgDolPerLine,0) as CYAvgDolPerLine,
					isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
					isnull(CAS.CYOESales,0) as CYOESales,
					isnull(CAS.CYEComSales,0) as CYEComSales,
					isnull(CAS.CYMillSales,0) as CYMillSales,
					isnull(CAS.CYOELbs,0) as CYOELbs,
					isnull(CAS.CYEComLbs,0) as CYEComLbs,
					isnull(CAS.CYMillLbs,0) as CYMillLbs,
					isnull(CAS.CYOEOrders,0) as CYOEOrders,
					isnull(CAS.CYEComOrders,0) as CYEComOrders,
					isnull(CAS.CYMillOrders,0) as CYMillOrders,
					isnull(CAS.CYOELines,0) as CYOELines,
					isnull(CAS.CYEComLines,0) as CYEComLines,
					isnull(CAS.CYMillLines,0) as CYMillLines,
					isnull(CAS.CYOEQDol,0) as CYOEQDol,
					isnull(CAS.CYEComQDol,0) as CYEComQDol,
					isnull(CAS.CYOEQOrders,0) as CYOEQOrders,
					isnull(CAS.CYEComQOrders,0) as CYEComQOrders,
					isnull(CAS.CYOEQLines,0) as CYOEQLines,
					isnull(CAS.CYEComQLines,0) as CYEComQLines,
					isnull(CAS.CYRGACount,0) as CYRGACount,
					isnull(CAS.CYCreditCount,0) as CYCreditCount,
					--LY - Fiscal Year/Last Year
					isnull(CAS.LYCorpRank,'') as LYCorpRank,
					isnull(CAS.LYTerRank,'') as LYTerRank,
					isnull(CAS.LYSales,0) as LYSales,
					isnull(CAS.LYGM,0) as LYGM,
					isnull(CAS.LYGMPct,0) as LYGMPct,
					isnull(CAS.LYLbs,0) as LYLbs,
					isnull(CAS.LYGMPerLb,0) as LYGMPerLb,
					isnull(CAS.LYAvgDolPerOrder,0) as LYAvgDolPerOrder,
					isnull(CAS.LYAvgDolPerLine,0) as LYAvgDolPerLine,
					--isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
					isnull(CAS.LYOESales,0) as LYOESales,
					isnull(CAS.LYEComSales,0) as LYEComSales,
					isnull(CAS.LYMillSales,0) as LYMillSales,
					isnull(CAS.LYOELbs,0) as LYOELbs,
					isnull(CAS.LYEComLbs,0) as LYEComLbs,
					isnull(CAS.LYMillLbs,0) as LYMillLbs,
					isnull(CAS.LYOEOrders,0) as LYOEOrders,
					isnull(CAS.LYEComOrders,0) as LYEComOrders,
					isnull(CAS.LYMillOrders,0) as LYMillOrders,
					isnull(CAS.LYOELines,0) as LYOELines,
					isnull(CAS.LYEComLines,0) as LYEComLines,
					isnull(CAS.LYMillLines,0) as LYMillLines,
					isnull(CAS.LYOEQDol,0) as LYOEQDol,
					isnull(CAS.LYEComQDol,0) as LYEComQDol,
					isnull(CAS.LYOEQOrders,0) as LYOEQOrders,
					isnull(CAS.LYEComQOrders,0) as LYEComQOrders,
					isnull(CAS.LYOEQLines,0) as LYOEQLines,
					isnull(CAS.LYEComQLines,0) as LYEComQLines,
					isnull(CAS.LYRGACount,0) as LYRGACount,
					isnull(CAS.LYCreditCount,0) as LYCreditCount
					--,CAS.*
			FROM	CustomerMaster Cust (NoLock) INNER JOIN
					CustomerActivity CAS (NoLock)
			ON		Cust.CustNo = CAS.LookupValue
			WHERE	Cust.pCustMstrID = @CustNo AND
					CAS.RecordType = 'CustNo' AND
					CAS.Period = @Period

			--Table[3] - Sales History By Category (Grid)
			SELECT	tCatList.CatNo as GroupNo,
					tCatList.CatDesc as GroupDesc,
					tCatSales.SalesCurYTD,
					tCatSales.SalesCurMTD,
					'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
					tCatSales.SalesLastYTD,
					'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr,
					tCatSales.SalesPrevYTD,
					tCatSales.WghtCurYTD,
					tCatSales.WghtCurMTD,
					tCatSales.GMDlrCurYTD,
					tCatSales.GMDlrCurMTD,
					tCatSales.AvgGMPctYTD,
					tCatSales.AvgGMPctMTD,
					tCatSales.PriceGMPctYTD,
					tCatSales.PriceGMPctMTD,
					tCatSales.DlrPerLbCurYTD,
					tCatSales.DlrPerLbCurMTD,
					tCatSales.GMPerLbCurYTD,
					tCatSales.GMPerLbCurMTD
			FROM	(SELECT	isnull(tCurYTD.CatNo, isnull(tCurMTD.CatNo, isnull(tLastYTD.CatNo, isnull(tPrevYTD.CatNo,'NoCat')))) as CatNo,
							isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0) as SalesCurYTD,
							isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0) as SalesCurMTD,
							isnull(tLastYTD.PriceLastYTD,0) * isnull(tLastYTD.QtyLastYTD,0) as SalesLastYTD,
							isnull(tPrevYTD.PricePrevYTD,0) * isnull(tPrevYTD.QtyPrevYTD,0) as SalesPrevYTD,
							isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0) as WghtCurYTD,
							isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0) as WghtCurMTD,
							(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as GMDlrCurYTD,
							(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as GMDlrCurMTD,

							CASE (isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.AvgCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / (isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							END as AvgGMPctYTD,

							CASE (isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.AvgCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / (isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							END as AvgGMPctMTD,

							CASE (isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.PriceCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / (isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							END as PriceGMPctYTD,

							CASE (isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.PriceCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / (isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							END as PriceGMPctMTD,

							CASE (isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE (isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) / (isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							END as DlrPerLbCurYTD,

							CASE (isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / (isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							END as GMPerLbCurYTD,

							CASE (isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE (isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) / (isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							END as DlrPerLbCurMTD,

							CASE (isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
									WHEN 0 THEN 0
									ELSE ((isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / (isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							END as GMPerLbCurMTD
					 FROM	 --tCurYTD: Year To Date Sales
							(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
									SUM(Dtl.NetUnitPrice) as PriceCurYTD,
									SUM(Dtl.QtyShipped) as QtyCurYTD,
									SUM(Dtl.GrossWght) as WghtCurYTD,
									SUM(Dtl.UnitCost) as CostCurYTD,
									SUM(IB.AvgCost) as AvgCostCurYTD,
									SUM(IB.PriceCost) as PriceCostCurYTD
							 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
									SODetailHist Dtl (NoLock)
							 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
									CustomerMaster Cust (NoLock)
							 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
									#tItemBranch IB (NoLock)
							 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location	
							 WHERE	Cust.pCustMstrID = @CustNo AND
									CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurYTD and @EndCurYTD
							 GROUP BY LEFT(Dtl.ItemNo,5)) tCurYTD FULL OUTER JOIN
							 --tCurMTD: Month To Date Sales
							(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
									SUM(Dtl.NetUnitPrice) as PriceCurMTD,
									SUM(Dtl.QtyShipped) as QtyCurMTD,
									SUM(Dtl.GrossWght) as WghtCurMTD,
									SUM(Dtl.UnitCost) as CostCurMTD,
									SUM(IB.AvgCost) as AvgCostCurMTD,
									SUM(IB.PriceCost) as PriceCostCurMTD
							 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
									SODetailHist Dtl (NoLock)
							 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
									CustomerMaster Cust (NoLock)
							 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
									#tItemBranch IB (NoLock)
							 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
							 WHERE	Cust.pCustMstrID = @CustNo AND
									CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurMTD and @EndCurMTD
							 GROUP BY LEFT(Dtl.ItemNo,5)) tCurMTD
							ON	tCurYTD.CatNo = tCurMTD.CatNo FULL OUTER JOIN
							 --tLastYTD: Last Year Sales
							(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
									SUM(Dtl.NetUnitPrice) as PriceLastYTD,
									SUM(Dtl.QtyShipped) as QtyLastYTD
							 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
									SODetailHist Dtl (NoLock)
							 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
									CustomerMaster Cust (NoLock)
							 ON		Cust.CustNo = Hdr.SellToCustNo
							 WHERE	Cust.pCustMstrID = @CustNo AND
									CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegLastYTD and @EndLastYTD
							 GROUP BY LEFT(Dtl.ItemNo,5)) tLastYTD
							ON	tCurMTD.CatNo = tLastYTD.CatNo FULL OUTER JOIN
							 --tPrevYTD: 2 Years Previous Sales
							(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
									SUM(Dtl.NetUnitPrice) as PricePrevYTD,
									SUM(Dtl.QtyShipped) as QtyPrevYTD
							 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
									SODetailHist Dtl (NoLock)
							 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
									CustomerMaster Cust (NoLock)
							 ON		Cust.CustNo = Hdr.SellToCustNo
							 WHERE	Cust.pCustMstrID = @CustNo AND
									CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegPrevYTD and @EndPrevYTD
							 GROUP BY LEFT(Dtl.ItemNo,5)) tPrevYTD
							ON	tLastYTD.CatNo = tPrevYTD.CatNo) tCatSales INNER JOIN
					 --tCatList: Category Desc
					(SELECT * FROM #tCatList (NoLock)) tCatList
					ON	tCatSales.CatNo = tCatList.CatNo











			DROP TABLE	#tCatList
			DROP TABLE	#tItemBranch
		END


	--------------------------
	-- For Testing Purposes --
	--------------------------
/*
exec pCustActivity	'GetList',		--Command
					'200912',		--Period
					'15', 			--CustShipLocation
					'',		  		--ChainCd
					'',				--ChainList
					'',				--CustNo
					'',				--CustList
					'NoFilter',		--FilterCd
					'',				--SalesTerritory
					'',				--OutsideRep
					'',				--InsideRep
					'',				--RegionalMgr
					'',				--BuyGroup
					'',				--ParamTbl
					'Tod'			--UserName


exec pCustActivity	'GetHist',		--Command
					'200912',		--Period
					'', 			--CustShipLocation
					'',		  		--ChainCd
					'',				--ChainList
					'107',			--CustNo
					'',				--CustList
					'',				--FilterCd
					'',				--SalesTerritory
					'',				--OutsideRep
					'',				--InsideRep
					'',				--RegionalMgr
					'',				--BuyGroup
					'',				--ParamTbl
					'Tod'			--UserName


exec pCustActivity	'GetList',		--Command
					'200912',		--Period
					'15', 			--CustShipLocation
					'WHIT',  		--ChainCd
					'',				--ChainList
					'',				--CustNo
					'',				--CustList
					'ChainCd',		--FilterCd
					'',				--SalesTerritory
					'Kevin Chavis',	--OutsideRep
					'',				--InsideRep
					'',				--RegionalMgr
					'',				--BuyGroup
					'',				--ParamTbl
					'Tod'			--UserName

exec pCustActivity	'GetList',					--Command
					'200912',					--Period
					'15', 						--CustShipLocation
					'',	  						--ChainCd
					'',							--ChainList
					'',							--CustNo
					'''001003'',''001811''',	--CustList
					'CustList',					--FilterCd
					'',							--SalesTerritory
					'',							--OutsideRep
					'',							--InsideRep
					'',							--RegionalMgr
					'',							--BuyGroup
					'',							--ParamTbl
					'Tod'						--UserName
*/
END
GO
