USE [PFCReports]
GO

drop proc [dbo].[pCustActivityGetList]
go

/****** Object:  StoredProcedure [dbo].[pCustActivityGetList]    Script Date: 06/23/2011 15:54:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pCustActivityGetList]
	@Action varchar(50),				--CREATE: creates the temp table for param file data
										--GET: gets the list of valid records for reporting
	@Period varchar(6),
	@CustShipLocation varchar(10),
	@ChainCd varchar(25),
	@ChainList nvarchar(4000),
	@CustNo varchar(10),
	@CustList nvarchar(4000),
	@FilterCd varchar(25),				--NoFilter; Branch-xx; ChainCd; ChainXLS; ChainList; CustNo; CustXLS; CustList;
	@SalesTerritory varchar(10),
	@OutsideRep varchar(40),
	@InsideRep varchar(40),
	@RegionalMgr varchar(40),
	@BuyGroup varchar(4),
	@ParamTbl varchar(255)
AS

DECLARE	@SQL nvarchar(4000)

BEGIN
	-- ======================================================
	-- Date		Developer	Action          
	-- ------------------------------------------------------
	-- 12/22/2010	Tod		Create
	-- ------------------------------------------------------
	-- ------------------------------------------------------
	-- NOTE: This procedure runs against PFCSQLP.PFCReports
	--		 and uses OpenDataSource to PFCERPDB for
	--		 ListMaster & ListDetail tables.
	-- ======================================================

	-----------------------------------------------
	-- Create the temp table for param file data --
	-----------------------------------------------
	IF (@Action = 'CREATE')
		BEGIN
			print 'Create the temp table for param file data'

			IF	EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[' + @ParamTbl + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
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
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.RepMaster RegionalMgr INNER JOIN
					OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster RegionalLoc
			ON		RegionalMgr.SalesRegionNo = RegionalLoc.SalesRegionNo
			WHERE	RepClass='R'

			--Load Chain Codes and Names
			SELECT	LD.ListValue as ChainCd,
					LD.ListDtlDesc as ChainName
			INTO	#tChainList
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListMaster] LM INNER JOIN
					OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ListDetail] LD
			ON		LM.pListMasterID = LD.fListMasterID
			WHERE	LM.ListName = 'CustChainName'

			IF (LEFT(@FilterCd,7) = 'Branch-')
				BEGIN
					--Branch Summary
					print ' - Branch Summary [' + @FilterCd + ']'

					SELECT	@CustShipLocation as RecID,
							'Branch-' + @CustShipLocation + ' summary' as RecName,
							'Summ' as RecType
					FROM	CustomerActivity CA (NoLock)
					WHERE	CA.Period = @Period AND
							CA.RecordType = 'Summ' AND
							isnull(CA.LookupValue,'') = isnull(@FilterCd,'')
					ORDER BY CA.LookupValue
				END

			IF (@FilterCd = 'NoFilter' or @FilterCd = 'CustNo')
				BEGIN
					--No filter or specific CustNo
					print ' - No filter; or specific CustNo [' + @FilterCd + ']'

					SELECT	DISTINCT
							isnull(Cust.CustNo, Activity.ActivityCust) as RecID,
							isnull(Cust.CustName, 'n/a') as RecName,
							'Cust' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityCust,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Cust' AND
									isnull(CA.LookupValue,'') LIKE CASE isnull(@CustNo,'') WHEN '' THEN '%' ELSE @CustNo END) Activity INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		Cust.CustNo = Activity.ActivityCust LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY isnull(Cust.CustNo, Activity.ActivityCust)
				END

			IF (@FilterCd = 'ChainCd')
				BEGIN
					--Use Specific ChainCd only
					print ' - Use specific ChainCd only [' + @FilterCd + ']'

					SELECT	DISTINCT
							Activity.ActivityChain as RecID,
							isnull(Chain.ChainName, 'n/a') as RecName,
							'Chain' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityChain,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Chain' AND
									isnull(CA.LookupValue,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END) Activity LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Activity.ActivityChain = Chain.ChainCd
					ORDER BY Activity.ActivityChain
				END

			IF (@FilterCd = 'ChainXLS')
				BEGIN
					--Use ChainXLS Only
					print ' - Use ChainXLS Only [' + @FilterCd + ']'
					print ' - Table: ' + @ParamTbl

					IF	EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[' + @ParamTbl + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
						BEGIN
							CREATE TABLE #ChainXLS ([Value] VARCHAR(100))
							SET	@SQL = 'SELECT * FROM ' + @ParamTbl
							print 'LOAD #ChainXLS: ' + @SQL
							INSERT INTO #ChainXLS(Value) EXEC (@SQL)
						END

					SELECT	DISTINCT
							Activity.ActivityChain as RecID,
							isnull(Chain.ChainName, 'n/a') as RecName,
							'Chain' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityChain,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Chain' AND
									isnull(CA.LookupValue,'') IN (SELECT Value FROM #ChainXLS)) Activity LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Activity.ActivityChain = Chain.ChainCd
					ORDER BY Activity.ActivityChain

					IF	EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[' + @ParamTbl + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
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
					SET @ChainList = REPLACE(@ChainList,'''','')
--					print @ChainList
--					SELECT Value FROM fListToTablevarchar(@ChainList,',') 

					SELECT	DISTINCT
							Activity.ActivityChain as RecID,
							isnull(Chain.ChainName, 'n/a') as RecName,
							'Chain' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityChain,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Chain' AND
									isnull(CA.LookupValue,'') IN (SELECT Value FROM fListToTablevarchar(@ChainList,','))) Activity LEFT OUTER JOIN
							#tChainList Chain (NoLock)
					ON		Activity.ActivityChain = Chain.ChainCd
					ORDER BY Activity.ActivityChain
				END

			IF (@FilterCd = 'CustXLS')
				BEGIN
					--Use CustXLS Only
					print ' - Use CustXLS Only [' + @FilterCd + ']'
					print ' - Table: ' + @ParamTbl

					IF	EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[' + @ParamTbl + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
						BEGIN
							CREATE TABLE #CustXLS ([Value] VARCHAR(100))
							SET	@SQL = 'SELECT * FROM ' + @ParamTbl
							print 'LOAD #CustXLS: ' + @SQL
							INSERT INTO #CustXLS(Value) EXEC (@SQL)
						END

					SELECT	DISTINCT
							isnull(Cust.CustNo, Activity.ActivityCust) as RecID,
							isnull(Cust.CustName, 'n/a') as RecName,
							'Cust' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityCust,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Cust' AND
									isnull(CA.LookupValue,'') IN (SELECT Value FROM #CustXLS)) Activity INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		Cust.CustNo = Activity.ActivityCust LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY isnull(Cust.CustNo, Activity.ActivityCust)

					IF	EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[' + @ParamTbl + ']') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
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
					SET @CustList = REPLACE(@CustList,'''','')
--					print @CustList
--					SELECT Value FROM fListToTablevarchar(@CustList,',') 

					SELECT	DISTINCT
							isnull(Cust.CustNo, Activity.ActivityCust) as RecID,
							isnull(Cust.CustName, 'n/a') as RecName,
							'Cust' as RecType
					FROM	(SELECT	CA.LookupValue as ActivityCust,
									CA.Period as ActivityPer
							 FROM	CustomerActivity CA (NoLock)
							 WHERE	CA.Period = @Period AND
									CA.RecordType = 'Cust' AND
									isnull(CA.LookupValue,'') IN (SELECT Value FROM fListToTablevarchar(@CustList,','))) Activity INNER JOIN
							CustomerMaster Cust (NoLock)
					ON		Cust.CustNo = Activity.ActivityCust LEFT OUTER JOIN
							RepMaster InsideRep (NoLock)
					ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
							RepMaster OutsideRep (NoLock)
					ON		Cust.SlsRepNo = OutsideRep.RepNo LEFT OUTER JOIN
							#tRegionLoc RegionLoc (NoLock)
					ON		Cust.CustShipLocation = RegionLoc.LocID
					WHERE	isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
							isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
							isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
							isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END AND
							isnull(RegionLoc.RepName,'') LIKE CASE isnull(@RegionalMgr,'') WHEN '' THEN '%' ELSE @RegionalMgr END AND
							isnull(Cust.BuyGroup,'') LIKE CASE isnull(@BuyGroup,'') WHEN '' THEN '%' ELSE @BuyGroup END
					ORDER BY isnull(Cust.CustNo, Activity.ActivityCust)
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

exec pCustActivityGetList	'GET',			--Command
							'200909',					--Period
							'15', 						--CustShipLocation
							'',	  						--ChainCd
							'',							--ChainList
							'',							--CustNo
							'',						--CustList
							'NoFilter',					--FilterCd
							'',							--SalesTerritory
							'',							--OutsideRep
							'',							--InsideRep
							'',							--RegionalMgr
							'',							--BuyGroup
							''							--ParamTbl
*/
END
