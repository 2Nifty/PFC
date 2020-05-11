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

DECLARE	@BegCurPer datetime,
		@EndCurPer datetime,
		@BegLastPer datetime,
		@EndLastPer datetime,
		@BegPrevPer datetime,
		@EndPrevPer datetime,
		@BegCurYTD datetime,
		@EndCurYTD datetime,
		@BegCurMTD datetime,
		@EndCurMTD datetime,
		@LastPeriod varchar(6),
		@LastYTD varchar(4),
		@BegLastYTD datetime,
		@EndLastYTD datetime,
		@PrevPeriod varchar(6),
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


	SELECT @LastPeriod = CAST(substring(@Period,1,4) - 1 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))
	SELECT @PrevPeriod = CAST(substring(@Period,1,4) - 2 as VARCHAR(4)) + CAST(substring(@Period,5,6) as VARCHAR(2))

	--SET Begin & End Period Dates
	SELECT	@BegCurPer = CurFiscalMthBeginDt,
			@EndCurPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
--	select @BegCurPer, @EndCurPer

	SELECT	@BegLastPer = CurFiscalMthBeginDt,
			@EndLastPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @LastPeriod
--	select @BegLastPer, @EndLastPer

	SELECT	@BegPrevPer = CurFiscalMthBeginDt,
			@EndPrevPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @PrevPeriod
--	select @BegPrevPer, @EndPrevPer

	--SET Current Fiscal MTD & YTD
	SELECT	@BegCurYTD = CurFiscalYearBeginDt,
			@EndCurYTD = @EndCurPer,
			@BegCurMTD = @BegCurPer,
			@EndCurMTD = @EndCurPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndCurPer
--	select @BegCurYTD, @EndCurYTD, @BegCurMTD, @EndCurMTD

	--SET Last Year's Fiscal
	SELECT	@LastYTD = FiscalYear,
			@BegLastYTD = CurFiscalYearBeginDt,
			@EndLastYTD = @EndLastPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndLastPer
--	select @LastYTD, @BegLastYTD, @EndLastYTD

	--SET 2 Years Previous Fiscal
	SELECT	@PrevYTD = FiscalYear,
			@BegPrevYTD = CurFiscalYearBeginDt,
			@EndPrevYTD = @EndPrevPer
	FROM	FiscalCalendar
	WHERE	CurrentDt = @EndPrevPer
--	select @PrevYTD, @BegPrevYTD, @EndPrevYTD


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

			--Load Chain Codes and Names
			SELECT	LD.ListValue as ChainCd,
					LD.ListDtlDesc as ChainName
			INTO	#tChainList
			FROM	ListMaster LM (NoLock) INNER JOIN
					ListDetail LD (NoLock)
			ON		LM.pListMasterID = LD.fListMasterID
			WHERE	LM.ListName = 'CustChainName'

			IF (@FilterCd = 'NoFilter' or @FilterCd = 'CustNo')
				BEGIN
					--No filter or specific CustNo
					print ' - No filter; or specific CustNo [' + @FilterCd + ']'

					SELECT	DISTINCT
							Cust.pCustMstrID as CustID,
							Cust.CustNo,
							Cust.CustName,
							'Cust' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
--							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo
				END

			IF (@FilterCd = 'ChainCd')
				BEGIN
					--Use Specific ChainCd only
					print ' - Use specific ChainCd only [' + @FilterCd + ']'

					SELECT	DISTINCT
							Cust.ChainCd as CustID,
							Cust.ChainCd as CustNo,
							isnull(Chain.ChainName,'n/a') as CustName,
							'Chain' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Cust.ChainCd = Chain.ChainCd LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
--							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.ChainCd
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

					SELECT	DISTINCT
							Cust.ChainCd as CustID,
							Cust.ChainCd as CustNo,
							isnull(Chain.ChainName,'n/a') as CustName,
							'Chain' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Cust.ChainCd = Chain.ChainCd LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') IN (SELECT Value FROM @FilterTbl) AND
--							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.ChainCd

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

					SELECT	DISTINCT
							Cust.ChainCd as CustID,
							Cust.ChainCd as CustNo,
							isnull(Chain.ChainName,'n/a') as CustName,
							'Chain' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Cust.ChainCd = Chain.ChainCd LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.ChainCd,'') IN (SELECT Value FROM fListToTablevarchar(REPLACE(@ChainList,'''',''),',')) AND
--							isnull(Cust.CustNo,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.ChainCd
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

					SELECT	DISTINCT
							Cust.pCustMstrID as CustID,
							Cust.CustNo,
							Cust.CustName,
							'Cust' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
--							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
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

					SELECT	DISTINCT
							Cust.pCustMstrID as CustID,
							Cust.CustNo,
							Cust.CustName,
							'Cust' as RecType
					FROM	SOHeaderHist SOH (NoLock) INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurPer and @EndCurPer AND
							isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
--							isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
							isnull(Cust.CustNo,'') IN (SELECT Value FROM fListToTablevarchar(REPLACE(@CustList,'''',''),',')) AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY Cust.CustNo
				END
			DROP TABLE	#tRegionLoc
			DROP TABLE	#tChainList
		END

	---------------------------------------
	-- Get Customer & sales History Data --
	---------------------------------------
	IF (@Action = 'GetHist')
		BEGIN
			print 'Get Customer & Sales History Data'

			-----------------
			-- Work Tables --
			-----------------
			--#tCatList: Load Categories
			SELECT	tCatList.CatNo,
					tCatList.CatDesc,
					BuyGrp.GroupNo as BuyGroupNo,
					BuyGrp.Description as BuyGroupDesc
			INTO	#tCatList
			FROM	(SELECT	LD.ListValue as CatNo,
							LD.ListDtlDesc as CatDesc
					 FROM	ListMaster LM (NoLock) INNER JOIN
							ListDetail LD (NoLock)
					 ON		LM.pListMasterID = LD.fListMasterID
					 WHERE	LM.ListName = 'CategoryDesc') tCatList LEFT OUTER JOIN
					CategoryBuyGroups BuyGrp (NoLock)
			ON		tCatList.CatNo = BuyGrp.Category

			--#tCustType: Load Customer Type Description
			SELECT	LD.ListValue as CustTypeCd, LD.ListDtlDesc as CustTypeDesc
			INTO	#tCustType
			FROM	ListMaster LM (NoLock) INNER JOIN
					ListDetail LD (NoLock)
			ON		LM.pListMasterID = LD.fListMasterID
			WHERE	LM.ListName = 'CustType'

			--#tTerms: Load Term Descriptions
			SELECT	TableCd as TermCd, Dsc as TermDesc, ShortDsc
			INTO	#tTerms
			FROM	Tables (NoLock)
			WHERE	TableType = 'TRM'

			--#tItemBranch: Load ItemBranch Avg and Price Cost
			SELECT	IM.ItemNo,
					IB.Location,
					IB.UnitCost as AvgCost,
					IB.PriceCost
			INTO	#tItemBranch
			FROM	ItemMaster IM (NoLock) INNER JOIN
					ItemBranch IB (NoLock)
			ON		IM.pItemMasterID = IB.fItemMasterID

			--#tCurYTD: Year To Date Sales
			SELECT	tCurYTD.CatNo,
					SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as SalesCurYTD,
					SUM(isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as CostCurYTD,
					SUM(isnull(tCurYTD.AvgCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as AvgCostCurYTD,
					SUM(isnull(tCurYTD.PriceCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as PriceCostCurYTD,
					SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) as WghtCurYTD,
					SUM((isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - (isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) as GMDlrCurYTD,
					CASE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.AvgCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					END as AvgGMPctYTD,
					CASE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.PriceCostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					END as PriceGMPctYTD,
					CASE SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							WHEN 0 THEN 0
							ELSE SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) / SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					END as DlrPerLbCurYTD,
					CASE SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurYTD.PriceCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0)) - SUM(isnull(tCurYTD.CostCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))) / SUM(isnull(tCurYTD.WghtCurYTD,0) * isnull(tCurYTD.QtyCurYTD,0))
					END as GMPerLbCurYTD
			INTO	#tCurYTD
			FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
							Dtl.NetUnitPrice as PriceCurYTD,
							Dtl.QtyShipped as QtyCurYTD,
							Dtl.GrossWght as WghtCurYTD,
							Dtl.UnitCost as CostCurYTD,
							IB.AvgCost as AvgCostCurYTD,
							IB.PriceCost as PriceCostCurYTD
					 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
							SODetailHist Dtl (NoLock)
					 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
							CustomerMaster Cust (NoLock)
					 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
							#tItemBranch IB (NoLock)
					 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurYTD and @EndCurYTD) tCurYTD
			GROUP BY tCurYTD.CatNo

			--#tCurMTD: Month To Date Sales
			SELECT	tCurMTD.CatNo,
					SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as SalesCurMTD,
					SUM(isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as CostCurMTD,
					SUM(isnull(tCurMTD.AvgCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as AvgCostCurMTD,
					SUM(isnull(tCurMTD.PriceCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as PriceCostCurMTD,
					SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) as WghtCurMTD,
					SUM((isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - (isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) as GMDlrCurMTD,
					CASE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.AvgCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					END as AvgGMPctMTD,
					CASE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.PriceCostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					END as PriceGMPctMTD,
					CASE SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							WHEN 0 THEN 0
							ELSE SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) / SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					END as DlrPerLbCurMTD,
					CASE SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
							WHEN 0 THEN 0
							ELSE (SUM(isnull(tCurMTD.PriceCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0)) - SUM(isnull(tCurMTD.CostCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))) / SUM(isnull(tCurMTD.WghtCurMTD,0) * isnull(tCurMTD.QtyCurMTD,0))
					END as GMPerLbCurMTD
			INTO	#tCurMTD
			FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
							Dtl.NetUnitPrice as PriceCurMTD,
							Dtl.QtyShipped as QtyCurMTD,
							Dtl.GrossWght as WghtCurMTD,
							Dtl.UnitCost as CostCurMTD,
							IB.AvgCost as AvgCostCurMTD,
							IB.PriceCost as PriceCostCurMTD
					 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
							SODetailHist Dtl (NoLock)
					 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
							CustomerMaster Cust (NoLock)
					 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
							#tItemBranch IB (NoLock)
					 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegCurMTD and @EndCurMTD) tCurMTD
			GROUP BY tCurMTD.CatNo

			--#tLastYTD: Last Year Sales
			SELECT	tLastYTD.CatNo,
					SUM(isnull(tLastYTD.PriceLastYTD,0) * isnull(tLastYTD.QtyLastYTD,0)) as SalesLastYTD
			INTO	#tLastYTD
			FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
							Dtl.NetUnitPrice as PriceLastYTD,
							Dtl.QtyShipped as QtyLastYTD
					 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
							SODetailHist Dtl (NoLock)
					 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
							CustomerMaster Cust (NoLock)
					 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
							#tItemBranch IB (NoLock)
					 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegLastYTD and @EndLastYTD) tLastYTD
			GROUP BY tLastYTD.CatNo

			--#tPrevYTD: 2 Years Previous Sales
			SELECT	tPrevYTD.CatNo,
					SUM(isnull(tPrevYTD.PricePrevYTD,0) * isnull(tPrevYTD.QtyPrevYTD,0)) as SalesPrevYTD
			INTO	#tPrevYTD
			FROM	(SELECT	LEFT(Dtl.ItemNo,5) as CatNo,
							Dtl.NetUnitPrice as PricePrevYTD,
							Dtl.QtyShipped as QtyPrevYTD
					 FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
							SODetailHist Dtl (NoLock)
					 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID INNER JOIN
							CustomerMaster Cust (NoLock)
					 ON		Cust.CustNo = Hdr.SellToCustNo INNER JOIN
							#tItemBranch IB (NoLock)
					 ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location
					 WHERE	Cust.pCustMstrID = @CustNo AND
							CAST(FLOOR(CAST(Hdr.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegPrevYTD and @EndPrevYTD) tPrevYTD
			GROUP BY tPrevYTD.CatNo

			--#tSOHist: Sales History
			SELECT	isnull(Cat.CatNo,'') as CatNo,
					isnull(Cat.CatDesc,'') as CatDesc,
					isnull(Cat.BuyGroupNo,'') as BuyGroupNo,
					isnull(Cat.BuyGroupDesc,'') as BuyGroupDesc,
					isnull(tSOHist.SalesCurYTD,0) as SalesCurYTD,
					isnull(tSOHist.CostCurYTD,0) as CostCurYTD,
					isnull(tSOHist.AvgCostCurYTD,0) as AvgCostCurYTD,
					isnull(tSOHist.PriceCostCurYTD,0) as PriceCostCurYTD,
					isnull(tSOHist.WghtCurYTD,0) as WghtCurYTD,
					isnull(tSOHist.GMDlrCurYTD,0) as GMDlrCurYTD,
					isnull(tSOHist.AvgGMPctYTD,0) as AvgGMPctYTD,
					isnull(tSOHist.PriceGMPctYTD,0) as PriceGMPctYTD,
					isnull(tSOHist.DlrPerLbCurYTD,0) as DlrPerLbCurYTD,
					isnull(tSOHist.GMPerLbCurYTD,0) as GMPerLbCurYTD,
					isnull(tSOHist.SalesCurMTD,0) as SalesCurMTD,
					isnull(tSOHist.CostCurMTD,0) as CostCurMTD,
					isnull(tSOHist.AvgCostCurMTD,0) as AvgCostCurMTD,
					isnull(tSOHist.PriceCostCurMTD,0) as PriceCostCurMTD,
					isnull(tSOHist.WghtCurMTD,0) as WghtCurMTD,
					isnull(tSOHist.GMDlrCurMTD,0) as GMDlrCurMTD,
					isnull(tSOHist.AvgGMPctMTD,0) as AvgGMPctMTD,
					isnull(tSOHist.PriceGMPctMTD,0) as PriceGMPctMTD,
					isnull(tSOHist.DlrPerLbCurMTD,0) as DlrPerLbCurMTD,
					isnull(tSOHist.GMPerLbCurMTD,0) as GMPerLbCurMTD,
					isnull(tSOHist.SalesLastYTD,0) as SalesLastYTD,
					isnull(tSOHist.SalesPrevYTD,0) as SalesPrevYTD
			INTO	#tSOHist
			FROM	#tCatList Cat (NoLock) INNER JOIN
					(SELECT	isnull(tCurYTD.CatNo, isnull(tCurMTD.CatNo, isnull(tLastYTD.CatNo, isnull(tPrevYTD.CatNo,'NoCat')))) as CatNo,
							tCurYTD.SalesCurYTD,
							tCurYTD.CostCurYTD,
							tCurYTD.AvgCostCurYTD,
							tCurYTD.PriceCostCurYTD,
							tCurYTD.WghtCurYTD,
							tCurYTD.GMDlrCurYTD,
							tCurYTD.AvgGMPctYTD,
							tCurYTD.PriceGMPctYTD,
							tCurYTD.DlrPerLbCurYTD,
							tCurYTD.GMPerLbCurYTD,
							tCurMTD.SalesCurMTD,
							tCurMTD.CostCurMTD,
							tCurMTD.AvgCostCurMTD,
							tCurMTD.PriceCostCurMTD,
							tCurMTD.WghtCurMTD,
							tCurMTD.GMDlrCurMTD,
							tCurMTD.AvgGMPctMTD,
							tCurMTD.PriceGMPctMTD,
							tCurMTD.DlrPerLbCurMTD,
							tCurMTD.GMPerLbCurMTD,
							tLastYTD.SalesLastYTD,
							tPrevYTD.SalesPrevYTD
					 FROM	#tCurYTD tCurYTD (NoLock) FULL OUTER JOIN
							#tCurMTD tCurMTD (NoLock)
					 ON		tCurYTD.CatNo = tCurMTD.CatNo FULL OUTER JOIN
							#tLastYTD tLastYTD (NoLock)
					 ON		tCurYTD.CatNo = tLastYTD.CatNo FULL OUTER JOIN
							#tPrevYTD tPrevYTD (NoLock)
					 ON		tCurYTD.CatNo = tPrevYTD.CatNo) tSOHist
					ON		tSOHist.CatNo = Cat.CatNo


			-----------------
			-- Main Tables --
			-----------------
			--Table[0] - Customer Header Data
			SELECT	Cust.pCustMstrID,
					Cust.CustNo,
					isnull(Cust.ChainCd,'') as ChainCd,
					isnull(CustType.CustTypeDesc,isnull(Cust.CustType,'')) as CustType,
					isnull(Cust.BuyGroup,'') as BuyGroup,
					'n/a' as KeyCust,
					'n/a' as CommRep,
					isnull(Cust.CustName,'') as CustName,
					isnull(Addr.AddrLine1,'') as AddrLine1,
					isnull(Addr.AddrLine2,'') as AddrLine2,
					isnull(Addr.City,'') as City,
					isnull(Addr.State,'') as [State],
					isnull(Addr.PostCd,'') as PostCd,
					isnull(Addr.PhoneNo,'') as PhoneNo,
					isnull(Addr.FaxPhoneNo,'') as FaxPhoneNo,
					isnull(Addr.CustContacts,'') as Contact,
					isnull(Cust.CustShipLocation,'') as SalesBranch,
					isnull(Loc.LocName,'') as LocName,
					isnull(InsideRep.RepNo,'') as InsideRepNo,
					isnull(InsideRep.RepName,'') as InsideRepName,
					isnull(OutsideRep.RepNo,'') as SalesRepNo,
					isnull(OutsideRep.RepName,'') as SalesRepName,
					Loc.SupportBranch1 + ' ' + Loc.SupportBranch2 as Hub,
					isnull(Terms.TermDesc,isnull(BillTo.TradeTermCd,'')) as Terms,
					isnull(Cust.CreditLmt,'') as CreditLmt,
					--PFC Fields
					isnull(Cust.ContractSchd1,'') as ContractSchd1,
					isnull(Cust.ContractSchd2,'') as ContractSchd2,
					isnull(Cust.ContractSchd3,'') as ContractSchd3,
					isnull(Cust.ContractSchedule4,'') as ContractSchd4,
					isnull(Cust.ContractSchedule5,'') as ContractSchd5,
					isnull(Cust.ContractSchedule6,'') as ContractSchd6,
					isnull(Cust.ContractSchedule7,'') as ContractSchd7,
					isnull(Cust.TargetGrossMarginPct,0) as DefaultGrossMarginPct,
--					isnull(Cust.GrossMarginPct,0) as GrossMarginPct,
					isnull(Cust.WebDiscountPct,0) as WebDiscountPct,
					CASE isnull(Cust.WebDiscountInd,'')
						WHEN '0' THEN 'No'
						WHEN '1' THEN 'Yes'
						ELSE ''
					END as WebDiscountInd,
					isnull(Cust.CustomerDefaultPrice,'') as CustomerDefaultPrice,
					isnull(Cust.CustomerPriceInd,'') as CustomerPriceInd
--					,Cust.*, Addr.*
			FROM	CustomerMaster Cust (NoLock) INNER JOIN
					CustomerMaster BillTo (NoLock)
			ON		Cust.fBillToNo = BillTo.CustNo LEFT OUTER JOIN
					CustomerAddress Addr (NoLock)
			ON		Cust.pCustMstrID = Addr.fCustomerMasterID LEFT OUTER JOIN
					#tCustType CustType (NoLock)
			ON		Cust.CustType = CustType.CustTypeCd LEFT OUTER JOIN
					#tTerms Terms (NoLock)
			ON		BillTo.TradeTermCd = Terms.TermCd LEFT OUTER JOIN
					LocMaster Loc (NoLock)
			ON		Cust.CustShipLocation = Loc.LocID LEFT OUTER JOIN
					RepMaster InsideRep (NoLock)
			ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
					RepMaster OutsideRep (NoLock)
			ON		Cust.SlsRepNo = OutsideRep.RepNo
			WHERE	Cust.pCustMstrID = @CustNo AND isnull(Addr.Type,'') in ('','P')

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
--					,*
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
					CASE isnull(LMSales,0)
						WHEN 0 THEN 0
						ELSE (isnull(CMSales,0) - isnull(LMSales,0)) / isnull(LMSales,0)
					END as CMSalesPct,
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
--					isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
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
					CASE isnull(LYSales,0)
						WHEN 0 THEN 0
						ELSE (isnull(CYSales,0) - isnull(LYSales,0)) / isnull(LYSales,0)
					END as CYSalesPct,
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
--					isnull(CAS.WeeklyGoal,0) as WeeklyGoal,
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
--					,CAS.*
			FROM	CustomerMaster Cust (NoLock) INNER JOIN
					CustomerActivity CAS (NoLock)
			ON		Cust.CustNo = CAS.LookupValue
			WHERE	Cust.pCustMstrID = @CustNo AND
					CAS.RecordType = 'Cust' AND
					CAS.Period = @Period

			--Table[3] - Sales History By Category (Grid)
			SELECT	tSOHist.CatNo as GroupNo,
					tSOHist.CatDesc as GroupDesc,
					tSOHist.SalesCurYTD,
					tSOHist.CostCurYTD,
					tSOHist.AvgCostCurYTD,
					tSOHist.PriceCostCurYTD,
					tSOHist.WghtCurYTD,
					tSOHist.GMDlrCurYTD,
					tSOHist.AvgGMPctYTD,
					tSOHist.PriceGMPctYTD,
					tSOHist.DlrPerLbCurYTD,
					tSOHist.GMPerLbCurYTD,
					tSOHist.SalesCurMTD,
					tSOHist.CostCurMTD,
					tSOHist.AvgCostCurMTD,
					tSOHist.PriceCostCurMTD,
					tSOHist.WghtCurMTD,
					tSOHist.GMDlrCurMTD,
					tSOHist.AvgGMPctMTD,
					tSOHist.PriceGMPctMTD,
					tSOHist.DlrPerLbCurMTD,
					tSOHist.GMPerLbCurMTD,
					tSOHist.SalesLastYTD,
					tSOHist.SalesPrevYTD,
					'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
					'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr
			FROM	#tSOHist tSOHist
			ORDER BY tSOHist.SalesCurYTD DESC, tSOHist.SalesLastYTD DESC, tSOHist.SalesPrevYTD DESC

			--Table[4] - Sales History By Buy Group (Grid)
			SELECT	tSOHistBuyGrp.*,
					'YTD ' + @LastYTD + ' Sales $' as LastYTDHdr,
					'YTD ' + @PrevYTD + ' Sales $' as PrevYTDHdr
			FROM	(SELECT	tSOHist.BuyGroupNo as GroupNo,
							tSOHist.BuyGroupDesc as GroupDesc,
							SUM(tSOHist.SalesCurYTD) as SalesCurYTD,
							SUM(tSOHist.CostCurYTD) as CostCurYTD,
							SUM(tSOHist.AvgCostCurYTD) as AvgCostCurYTD,
							SUM(tSOHist.PriceCostCurYTD) as PriceCostCurYTD,
							SUM(tSOHist.WghtCurYTD) as WghtCurYTD,
							SUM(tSOHist.GMDlrCurYTD) as GMDlrCurYTD,
--							SUM(tSOHist.AvgGMPctYTD) as AvgGMPctYTD,
--							SUM(tSOHist.PriceGMPctYTD) as PriceGMPctYTD,
							CASE SUM(tSOHist.SalesCurYTD)
									WHEN 0 THEN 0
									ELSE (SUM(tSOHist.SalesCurYTD) - SUM(tSOHist.AvgCostCurYTD)) / SUM(tSOHist.SalesCurYTD)
							END as AvgGMPctYTD,
							CASE SUM(tSOHist.SalesCurYTD)
									WHEN 0 THEN 0
									ELSE (SUM(tSOHist.SalesCurYTD) - SUM(tSOHist.PriceCostCurYTD)) / SUM(tSOHist.SalesCurYTD)
							END as PriceGMPctYTD,
							SUM(tSOHist.DlrPerLbCurYTD) as DlrPerLbCurYTD,
							SUM(tSOHist.GMPerLbCurYTD) as GMPerLbCurYTD,
							SUM(tSOHist.SalesCurMTD) as SalesCurMTD,
							SUM(tSOHist.CostCurMTD) as CostCurMTD,
							SUM(tSOHist.AvgCostCurMTD) as AvgCostCurMTD,
							SUM(tSOHist.PriceCostCurMTD) as PriceCostCurMTD,
							SUM(tSOHist.WghtCurMTD) as WghtCurMTD,
							SUM(tSOHist.GMDlrCurMTD) as GMDlrCurMTD,
--							SUM(tSOHist.AvgGMPctMTD) as AvgGMPctMTD,
--							SUM(tSOHist.PriceGMPctMTD) as PriceGMPctMTD,
							CASE SUM(tSOHist.SalesCurMTD)
									WHEN 0 THEN 0
									ELSE (SUM(tSOHist.SalesCurMTD) - SUM(tSOHist.AvgCostCurMTD)) / SUM(tSOHist.SalesCurMTD)
							END as AvgGMPctMTD,
							CASE SUM(tSOHist.SalesCurMTD)
									WHEN 0 THEN 0
									ELSE (SUM(tSOHist.SalesCurMTD) - SUM(tSOHist.PriceCostCurMTD)) / SUM(tSOHist.SalesCurMTD)
							END as PriceGMPctMTD,
							SUM(tSOHist.DlrPerLbCurMTD) as DlrPerLbCurMTD,
							SUM(tSOHist.GMPerLbCurMTD) as GMPerLbCurMTD,
							SUM(tSOHist.SalesLastYTD) as SalesLastYTD,
							SUM(tSOHist.SalesPrevYTD) as SalesPrevYTD
					 FROM	#tSOHist tSOHist
					 GROUP BY tSOHist.BuyGroupNo, tSOHist.BuyGroupDesc) tSOHistBuyGrp
			ORDER BY tSOHistBuyGrp.SalesCurYTD DESC, tSOHistBuyGrp.SalesLastYTD DESC, tSOHistBuyGrp.SalesPrevYTD DESC

			DROP TABLE	#tCatList
			DROP TABLE	#tCustType
			DROP TABLE	#tTerms
			DROP TABLE	#tItemBranch
			DROP TABLE	#tCurYTD
			DROP TABLE	#tCurMTD
			DROP TABLE	#tLastYTD
			DROP TABLE	#tPrevYTD
			DROP TABLE	#tSOHist

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
					'AAB',  		--ChainCd
					'',				--ChainList
					'',				--CustNo
					'',				--CustList
					'ChainCd',		--FilterCd
					'',				--SalesTerritory
					'',				--OutsideRep
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
