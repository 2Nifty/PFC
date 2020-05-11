
--exec [pSOEProcessCustCatSlsSumm]

----PFCSQLP Load stats
----201009 - 25,949 records ~ 30 seconds
----201010 - 30,788 records ~ 30 seconds
----201011 - 24,610 records ~ 15 seconds
----201012 - 23,625 records ~ 15 seconds
----201101 - 27,340 records ~ 15 seconds
----201102 - 25,584 records ~ 15 seconds
----201103 - 26,989 records ~ 15 seconds
----201104 - 32,948 records ~ 30 seconds
----201105 - 30,833 records ~ 30 seconds
----201106 - 16,722 records ~ 15 seconds [MTD as of 6/9]


select	*
from	CustCatSalesSummary
where FiscalPeriodNo='201106'
and Category='00050'


drop proc [pSOEProcessCustCatSlsSumm]
go


CREATE procedure [dbo].[pSOEProcessCustCatSlsSumm]
as

----[pSOEProcessCustCatSlsSumm]
----Written By: Tod Dixon
----Application: Sales Management

--Create #BuyGrpCatDesc
SELECT	tCatDesc.CatNo as CatNo,
		tCatDesc.CatDesc as CatDesc,
		tBuyGrp.GroupNo as BuyGrpNo,
		tBuyGrp.Description as BuyGrpDesc
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

SELECT	@Period = YearValue * 100 + MonthValue,
		@BegPer = BegDate,
		@EndPer = EndDate
FROM	DashboardRanges
WHERE	DashboardParameter = 'CurrentMonth'

--	=================================================================
--	--Hard code specific FiscalPeriodNo here
--			SET	@Period = '201104'
--			SET	@BegPer = '2011-mar-27'
--			SET	@EndPer = '2011-apr-30'
--	--select @Period as Period, @BegPer as BegPer, @EndPer as EndPer
--	=================================================================

--DELETE existing records for @Period
DELETE
FROM	CustCatSalesSummary
WHERE	FiscalPeriodNo = @Period

--INSERT new records for @Period
INSERT INTO	CustCatSalesSummary
			(CustomerNo,
			 Category,
			 CategoryDesc,
			 BuyCategory,
			 BuyGroupDesc,
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
go



