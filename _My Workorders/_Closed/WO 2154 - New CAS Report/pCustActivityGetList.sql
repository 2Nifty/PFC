use DEVPERP
go

drop proc pCustActivityGetList
go

CREATE PROCEDURE [dbo].[pCustActivityGetList]
	@Action varchar(50),				--CREATE: creates the temp table for param file data
										--GET: gets the list of valid records for reporting
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
	@ParamTbl varchar(255)
AS

DECLARE	@BegCurPer datetime,
		@EndCurPer datetime,
		@SQL nvarchar(4000)

DECLARE	@FilterTbl table(Value varchar(100))

BEGIN
	-- ============================================
	-- Date		Developer	Action          
	-- --------------------------------------------
	-- 12/22/2010	Tod		Create
	-- ============================================

	--SET Begin & End Period Dates
	SELECT	@BegCurPer = CurFiscalMthBeginDt,
			@EndCurPer = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) = @Period
--	select @BegCurPer, @EndCurPer

	-----------------------------------------------
	-- Create the temp table for param file data --
	-----------------------------------------------
	IF (@Action = 'CREATE')
		BEGIN
			print 'Create the temp table for param file data'

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
	IF (@Action = 'GET')
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
							Cust.CustNo as RecID,
							Cust.CustName as RecName,
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
							Cust.ChainCd as RecID,
							isnull(Chain.ChainName,'n/a') as RecName,
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
							Cust.ChainCd as RecID,
							isnull(Chain.ChainName,'n/a') as RecName,
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
							Cust.ChainCd as RecID,
							isnull(Chain.ChainName,'n/a') as RecName,
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
							Cust.CustNo as RecID,
							Cust.CustName as RecName,
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
							Cust.CustNo as RecID,
							Cust.CustName as RecName,
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


	--------------------------
	-- For Testing Purposes --
	--------------------------
/*
exec pCustActivityGetList	'GET',			--Command
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
							''				--ParamTbl


exec pCustActivityGetList	'GET',			--Command
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
							''				--ParamTbl

exec pCustActivityGetList	'GET',			--Command
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
							''							--ParamTbl
*/
END
GO
