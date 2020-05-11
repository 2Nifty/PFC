declare @tablename varchar(200)
declare @temptable varchar(200)

set @tablename = 'tCustActivity_tod_9746'

--drop table tCustActivity_tod_9746

SELECT @temptable = QUOTENAME(TABLE_NAME)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = @tablename


select * from @temptable
--select * from tCustActivity_tod_9746



drop table #tTod
declare @CustList nvarchar(4000)
set @CustList = '001003,001811'
select @CustList as List into #tTod
select * from #tTod



			SELECT	DISTINCT
--				InsideRep.RepName AS InsideRep, OutsideRep.RepName AS OutsideRep, Cust.*
				Cust.pCustMstrID, Cust.CustNo, Cust.CustName,
				InsideRep.RepName AS InsideRep, OutsideRep.RepName AS OutsideRep
			FROM	SOHeaderHist SOH (NoLock) INNER JOIN
				CustomerMaster Cust (NoLock)
			ON	SOH.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
				RepMaster InsideRep (NoLock)
			ON	Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
				RepMaster OutsideRep (NoLock)
			ON	Cust.SlsRepNo = OutsideRep.RepNo
			WHERE	--CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt AND
				--isnull(Cust.CustShipLocation,'') LIKE CASE isnull(@CustShipLocation,'') WHEN '' THEN '%' ELSE @CustShipLocation END AND
				--isnull(Cust.ChainCd,'') LIKE CASE isnull(@ChainCd,'') WHEN '' THEN '%' ELSE @ChainCd END AND
--				isnull(Cust.CustNo,'') IN (001003,001811) --AND
				isnull(Cust.CustNo,'') IN (SELECT * FROM #tTod) --AND
				--isnull(Cust.SalesTerritory,'') LIKE CASE isnull(@SalesTerritory,'') WHEN '' THEN '%' ELSE @SalesTerritory END AND
				--isnull(OutsideRep.RepName,'') LIKE CASE isnull(@OutsideRep,'') WHEN '' THEN '%' ELSE @OutsideRep END AND
				--isnull(InsideRep.RepName,'') LIKE CASE isnull(@InsideRep,'') WHEN '' THEN '%' ELSE @InsideRep END --AND
--				RegionalMgr = '' AND
--				BuyGroup = ''
			ORDER BY Cust.CustNo
