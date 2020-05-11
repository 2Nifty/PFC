

--Create #BuyGrpCatDesc
DROP TABLE #BuyGrpCatDesc
SELECT	tCatDesc.CatNo as CatNo,
		tCatDesc.CatDesc as CatDesc,
		tbuyGrp.GroupNo as BuyGrpNo,
		tbuyGrp.Description as BuyGrpDesc
INTO	#BuyGrpCatDesc
FROM	(SELECT	BuyGrp.GroupNo,
				BuyGrp.Category,
				BuyGrp.Description
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups BuyGrp) tBuyGrp RIGHT OUTER JOIN
		(SELECT	LD.ListValue as CatNo,
				LD.ListDtlDesc as CatDesc
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
		 ON		LM.plistmasterid = LD.flistmasterid
		 WHERE	LM.ListName = 'CategoryDesc') tCatDesc
		ON		tBuyGrp.Category = tCatDesc.CatNo
--select * from #BuyGrpCatDesc


--Get FiscalPeriod info from DashboardRanges
DECLARE	@Period varchar(6),
		@BegPer	datetime,
		@EndPer	datetime

----Current MTD (201106) thru 6/09 - less than 1 minute - 16,722 records
SELECT	@Period = YearValue * 100 + MonthValue,
		@BegPer = BegDate,
		@EndPer = EndDate
FROM	DashboardRanges
WHERE	DashboardParameter = 'CurrentMonth'


--Hard code specific FiscalPeriodNo here
----201104 - less than 1 minute - 32,984 records
----201105 - less than 1 minute - 30,833 records
--SET	@Period = '201104'
--SET	@BegPer = '2011-March-27'
--SET	@EndPer = '2011-april-30'

--select	@Period as Period, @BegPer as BegPer, @EndPer as EndPer


--DELETE current FiscalPeriod records
DELETE
FROM	CustCatSalesSummary
WHERE	FiscalPeriodNo = @Period


--INSERT current FiscalPeriod records
INSERT INTO	CustCatSalesSummary
			(CustomerNo,
			 Category,
			 CategoryDesc,
			 BuyCategory,
			 BuyGroupDesc,
--			 Location,
			 FiscalPeriodNo,
			 SalesDollars,
			 SalesCost,
			 TotalWeight,
			 EntryID,
			 EntryDt)
SELECT		--DISTINCT
			Hdr.SellToCustNo as CustomerNo,
			LEFT(Dtl.ItemNo, 5) AS Category,
			BuyGrp.[CatDesc] as CategoryDesc,
			BuyGrp.[BuyGrpNo] as BuyCategory,
			BuyGrp.[BuyGrpDesc] as BuyGroupDesc,
--			Hdr.CustShipLoc AS Location,
			@Period as FiscalPeriodNo,
			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS SalesDollars,
			SUM(Dtl.UnitCost * Dtl.QtyShipped) AS SalesCost,
			SUM(Dtl.GrossWght * Dtl.QtyShipped) AS TotalWeight,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			#BuyGrpCatDesc BuyGrp (NoLock)
ON			LEFT(Dtl.ItemNo, 5) = BuyGrp.CatNo
WHERE		Hdr.ARPostDt between @BegPer and @EndPer
GROUP BY	Hdr.SellToCustNo, LEFT(Dtl.ItemNo, 5), BuyGrp.CatDesc, BuyGrp.BuyGrpNo, BuyGrp.BuyGrpDesc
--			, FiscalPeriodNo, Hdr.CustShipLoc


--------------------------------------------------------------------------------------------------------------------------


--15020
select count(*) from CustCatsalesSummary


order by Hdr.SellToCustNo, LEFT(Dtl.ItemNo, 5)



select * from CustCatSalesSummary
order by CustomerNo, Category





select	Hdr.ARPostDt,
		Hdr.OrderNo,
		Hdr.InvoiceNo,
		Hdr.EntryID,
		Cust.CustNo as [CustomerMaster.CustNo],
		Cust.CustShipLocation as [CustomerMaster.CustShipLocation],
		Hdr.SellToCustNo as [SOHist.SellToCustNo],
		Hdr.CustShiploc as [SOHist.CustShipLoc]
from	CustomerMaster Cust (NoLock) inner join
		SOHeaderHist Hdr (NoLock)
on		Cust.CustNo = Hdr.SellTocustNo
where	Cust.CustShipLocation <> Hdr.CustShiploc and
		ARPostDt > '2011-Mar-01'
order by Hdr.ARPostDt DESC,  Hdr.InvoiceNo ASC













select FiscalPeriodNo, CalendarFiscalPeriod, * from CustomerSalesSummary where fiscalperiodno > '201101'