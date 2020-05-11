select distinct entrydt from CustCatSalesSummary order by EntryDt
select distinct FiscalPeriodNo from CustCatSalesSummary order by FiscalPeriodNo

select distinct entrydt from tCustItemSalesSummary order by EntryDt
select distinct FiscalPeriodNo from tCustItemSalesSummary  order by FiscalPeriodNo

------------------------------------------------------------------------------------


DECLARE	@BegPer varchar(6),
	@EndPer varchar(6),
	@cPeriod varchar(6),
	@cBegPerDt datetime,
	@cEndPerDt datetime

set @BegPer = '200809'
set @EndPer = '201208'

DECLARE PerCursor CURSOR FOR
	SELECT	DISTINCT
		CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) as Period,
		CurFiscalMthBeginDt as FiscalMthBeginDt,
		CurFiscalMthEndDt as FiscalMthEndDt
	FROM 	FiscalCalendar
	WHERE	CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) >= @BegPer AND
		CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2) <= @EndPer
	ORDER BY CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)


OPEN PerCursor
FETCH NEXT FROM PerCursor INTO @cPeriod, @cBegPerDt, @cEndPerDt
WHILE @@FETCH_STATUS = 0
   BEGIN
		exec tProcessCustItemSalesSumm @cPeriod, @cBegPerDt, @cEndPerDt
	FETCH NEXT FROM  PerCursor INTO @cPeriod, @cBegPerDt, @cEndPerDt
   END
CLOSE PerCursor
DEALLOCATE PerCursor



------------------------------------------------------------------------------------



--3 minutes on SQLP

use pfcreports

truncate table tCustItemSalesSummary

exec tProcessCustItemSalesSumm '200909', '2009-aug-30', '2009-Sep-26'
exec tProcessCustItemSalesSumm '200910', '2009-sep-27', '2009-oct-31'
exec tProcessCustItemSalesSumm '200911', '2009-nov-01', '2009-nov-28'
exec tProcessCustItemSalesSumm '200912', '2009-nov-29', '2009-dec-26'
exec tProcessCustItemSalesSumm '201001', '2009-dec-27', '2010-jan-30'
exec tProcessCustItemSalesSumm '201002', '2010-jan-31', '2010-feb-27'
exec tProcessCustItemSalesSumm '201003', '2010-feb-28', '2010-mar-27'
exec tProcessCustItemSalesSumm '201004', '2010-mar-28', '2010-may-01'
exec tProcessCustItemSalesSumm '201005', '2010-may-02', '2010-may-29'
exec tProcessCustItemSalesSumm '201006', '2010-may-30', '2010-jun-26'
exec tProcessCustItemSalesSumm '201007', '2010-jun-27', '2010-jul-31'
exec tProcessCustItemSalesSumm '201008', '2010-aug-01', '2010-aug-28'


exec tProcessCustItemSalesSumm '200909', '2009-aug-30', '2009-Sep-26'
exec tProcessCustItemSalesSumm '200910', '2009-sep-27', '2009-oct-31'
exec tProcessCustItemSalesSumm '200911', '2009-nov-01', '2009-nov-28'
exec tProcessCustItemSalesSumm '200912', '2009-nov-29', '2009-dec-26'
exec tProcessCustItemSalesSumm '201001', '2009-dec-27', '2010-jan-30'
exec tProcessCustItemSalesSumm '201002', '2010-jan-31', '2010-feb-27'
exec tProcessCustItemSalesSumm '201003', '2010-feb-28', '2010-mar-27'
exec tProcessCustItemSalesSumm '201004', '2010-mar-28', '2010-may-01'
exec tProcessCustItemSalesSumm '201005', '2010-may-02', '2010-may-29'
exec tProcessCustItemSalesSumm '201006', '2010-may-30', '2010-jun-26'
exec tProcessCustItemSalesSumm '201007', '2010-jun-27', '2010-jul-31'
exec tProcessCustItemSalesSumm '201008', '2010-aug-01', '2010-aug-28'

exec tProcessCustItemSalesSumm '201009', '2010-aug-29', '2010-sep-25'
exec tProcessCustItemSalesSumm '201010', '2010-sep-26', '2010-oct-30'
exec tProcessCustItemSalesSumm '201011', '2010-oct-31', '2010-nov-27'
exec tProcessCustItemSalesSumm '201012', '2010-nov-28', '2010-dec-25'
exec tProcessCustItemSalesSumm '201101', '2010-dec-26', '2011-jan-29'
exec tProcessCustItemSalesSumm '201102', '2011-jan-30', '2011-feb-26'
exec tProcessCustItemSalesSumm '201103', '2011-feb-27', '2011-mar-26'
exec tProcessCustItemSalesSumm '201104', '2011-mar-27', '2011-apr-30'
exec tProcessCustItemSalesSumm '201105', '2011-may-01', '2011-may-28'
exec tProcessCustItemSalesSumm '201106', '2011-may-29', '2011-jun-25'
exec tProcessCustItemSalesSumm '201107', '2011-jun-26', '2011-jul-30'
exec tProcessCustItemSalesSumm '201108', '2011-jul-31', '2011-aug-27'

exec tProcessCustItemSalesSumm '201109', '2011-aug-28', '2011-sep-24'
exec tProcessCustItemSalesSumm '201110', '2011-sep-25', '2011-oct-29'
exec tProcessCustItemSalesSumm '201111', '2011-oct-30', '2011-nov-26'
exec tProcessCustItemSalesSumm '201112', '2011-nov-27', '2011-dec-24'
exec tProcessCustItemSalesSumm '201201', '2011-dec-25', '2012-jan-28'
exec tProcessCustItemSalesSumm '201202', '2012-jan-29', '2012-feb-25'
exec tProcessCustItemSalesSumm '201203', '2012-feb-26', '2012-mar-24'
exec tProcessCustItemSalesSumm '201204', '2012-mar-25', '2012-apr-28'
exec tProcessCustItemSalesSumm '201205', '2012-apr-29', '2012-may-26'
exec tProcessCustItemSalesSumm '201206', '2012-may-27', '2012-jun-23'
exec tProcessCustItemSalesSumm '201207', '2012-jun-24', '2012-jul-28'
exec tProcessCustItemSalesSumm '201208', '2012-jul-29', '2012-aug-25'

--exec tProcessCustItemSalesSumm '201209', '2012-aug-28', '2012-sep-24'
--exec tProcessCustItemSalesSumm '201210', '2012-sep-25', '2012-oct-29'
--exec tProcessCustItemSalesSumm '201211', '2012-oct-30', '2012-nov-26'
--exec tProcessCustItemSalesSumm '201212', '2012-nov-27', '2012-dec-24'

select FiscalPeriodNo, sum(SalesDollars) as Sales, sum(SalesCost) as Cost, sum(TotalWeight) as Wght 
from tCustItemSalesSummary 
group by FiscalPeriodNo
order by FiscalPeriodNo
--order by CustNo, ItemNo, FiscalPeriodNo


select * from tCustItemSalesSummary

select FiscalPeriodNo, sum(SalesDollars) as Sales, sum(SalesCost) as Cost, sum(TotalWeight) as Wght 
from tCustItemSalesSummary 
group by FiscalPeriodNo
order by FiscalPeriodNo
--order by CustNo, ItemNo, FiscalPeriodNo

select FiscalPeriodNo, sum(SalesDollars) as Sales, sum(SalesCost) as Cost, sum(TotalWeight) as Wght 
from CustCatSalesSummary 
group by FiscalPeriodNo
order by FiscalPeriodNo
--order by CustNo, ItemNo, FiscalPeriodNo
