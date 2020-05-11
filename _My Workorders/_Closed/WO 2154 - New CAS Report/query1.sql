--Customers or Chains to Report
SELECT	InsideRep.RepName AS InsideRep, OutsideRep.RepName AS OutsideRep, Cust.*
--	pCustMstrID, CustNo, CustName,
--	InsideRep.RepName AS InsideRep, OutsideRep.RepName AS OutsideRep
FROM	CustomerMaster Cust (NoLock) LEFT OUTER JOIN
	RepMaster InsideRep (NoLock)
ON	Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
	RepMaster OutsideRep (NoLock)
ON	Cust.SlsRepNo = OutsideRep.RepNo
WHERE	Cust.CustShipLocation = '15' AND
	Cust.ChainCd = 'WHIT' AND
	SalesTerritory = 'SFS01' AND
	OutsideRep.RepName = 'Kevin Chavis' AND
	InsideRep.RepName = 'Eligio Lopez' --AND
--	RegionalMgr = '' AND
--	BuyGroup = ''







select ChainCd, count(ChainCd)
from CustomerMAster
where CustShipLocation='15'
group by ChainCd
order by count(chaincd)



update CustomerMaster
set SalesTerritory = 'SFS01'
WHERE	CustShipLocation = '15' AND
	ChainCd = 'WHIT' AND
	pCustMstrID > 8000 and pCustMstrID < 9000


DECLARE	@BegDt datetime
DECLARE @EndDt datetime

	SELECT	@BegDt = CurFiscalMthBeginDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalMonth as VARCHAR(2)) + CAST(FiscalCalYear as VARCHAR(4)) = '122009'

	SELECT	@EndDt = CurFiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalMonth as VARCHAR(2)) + CAST(FiscalCalYear as VARCHAR(4)) = '122009'
select @BegDt, @EndDt


select ARPostDt as dt, SellToCustNo, *
from SOHeaderHist SOH
where (SellToCustNo = '089686' or SellToCustNo = '089689' or SellToCustNo = '089763') and
CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @BegDt and @EndDt
order by ARPostDt




exec sp_columns CustomerMaster




declare @file varchar(255)
--set @file='c:\WO2154_CustList.xls'	--C drive on DEV
--set @file='c:\WO2154_ChainList.xls'	--C drive on DEV
set @file = '\\pfcfiles\UserDB\AppDev\Tod\Test\WO2154_CustList.xls'

declare @sql varchar(400)
set @sql='EXEC master.dbo.xp_cmdshell ''COPY ' + @file + ' C:\test.xls'''
print @sql
exec (@sql)


declare @file varchar(255)
set @file='"C:/WO2154_ChainList.xls"'
exec master..xp_fileexist @file



declare @sql nvarchar(4000)
--set @sql = '(SELECT	F1 as Value FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;HDR=NO;Database=c:\WO2154_CustList.xls'',''SELECT * FROM [Sheet1$]''))'
set @sql = '(SELECT	F1 as Value FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;HDR=NO;Database=' + @file + ''',''SELECT * FROM [Sheet1$]''))'
print @sql

exec (@sql)


declare @tempTbl table(Value varchar(100))
INSERT INTO @tempTbl(Value) exec (@sql)
select * from @tempTbl
select CustNo, ChainCd, * from CustomerMaster Cust
where	isnull(Cust.CustNo,'') IN (SELECT Value FROM @tempTbl)
--where isnull(Cust.ChainCd,'') IN (SELECT Value FROM @tempTbl)


set @sql='EXEC master.dbo.xp_cmdshell ''DEL C:\test.xls'''
print @sql
exec (@sql)





select ChainCd from SOHeaderHist SOH (NoLock) INNER JOIN
						CustomerMaster Cust (NoLock)
ON		SOH.SellToCustNo = Cust.CustNo
--where isnull(chaincd,'') <> '' and CustshipLocation='15'
where isnull(chaincd,'') = 'BEST-2' or isnull(chaincd,'') = 'COPP'


