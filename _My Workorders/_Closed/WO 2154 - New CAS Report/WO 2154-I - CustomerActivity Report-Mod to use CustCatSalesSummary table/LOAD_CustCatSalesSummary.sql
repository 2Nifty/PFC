
--Build temp tables
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
		 ON	LM.plistmasterid = LD.flistmasterid
		 WHERE	LM.ListName = 'CategoryDesc') tCatDesc
		ON	tBuyGrp.Category = tCatDesc.CatNo
--select * from #BuyGrpCatDesc

--Create #tItemBranch
SELECT	IM.ItemNo,
	IB.Location,
	IB.UnitCost as AvgCost,
	IB.PriceCost
INTO	#tItemBranch
FROM	ItemMaster IM (NoLock) INNER JOIN
	ItemBranch IB (NoLock)
ON	IM.pItemMasterID = IB.fItemMasterID
--select * from #tItemBranch


DECLARE	@BegPer varchar(6),
	@EndPer varchar(6),
	@cPeriod varchar(6),
	@cBegPerDt datetime,
	@cEndPerDt datetime

SET	@BegPer = '201009'
SELECT	@EndPer = CAST(FiscalCalYear as VARCHAR(4)) + RIGHT(CAST(100+FiscalCalMonth as VARCHAR(3)),2)
FROM 	FiscalCalendar
WHERE	CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)


set @EndPer = '201108'

--Select @BegPer, @EndPer

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

	--DELETE existing records for @cPeriod
	DELETE
	FROM	CustCatSalesSummary
	WHERE	FiscalPeriodNo = @cPeriod
	
	--INSERT new records for @cPeriod
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
			 AvgCostDollars,
			 PriceCostDollars,
			 EntryID,
			 EntryDt)
	SELECT		--DISTINCT
			Hdr.SellToCustNo as CustomerNo,
			LEFT(Dtl.ItemNo, 5) AS Category,
			BuyGrp.[CatDesc] as CategoryDesc,
			BuyGrp.[BuyGrpNo] as BuyCategory,
			BuyGrp.[BuyGrpDesc] as BuyGroupDesc,
			@cPeriod as FiscalPeriodNo,
			SUM(Dtl.NetUnitPrice * Dtl.QtyShipped) AS SalesDollars,
			SUM(Dtl.UnitCost * Dtl.QtyShipped) AS SalesCost,
			SUM(Dtl.GrossWght * Dtl.QtyShipped) AS TotalWeight,
			SUM(isnull(IB.AvgCost,0) * Dtl.QtyShipped) as AvgCostDollars,
			SUM(isnull(IB.PriceCost,0) * Dtl.QtyShipped) as PriceCostDollars,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
	FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
	ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			#tItemBranch IB (NoLock)
	ON		Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location LEFT OUTER JOIN
			#BuyGrpCatDesc BuyGrp (NoLock)
	ON		LEFT(Dtl.ItemNo, 5) = BuyGrp.CatNo
	WHERE		Hdr.ARPostDt between @cBegPerDt and @cEndPerDt
	GROUP BY	Hdr.SellToCustNo, LEFT(Dtl.ItemNo, 5), BuyGrp.CatDesc, BuyGrp.BuyGrpNo, BuyGrp.BuyGrpDesc

	select	@cPeriod as Period, @cBegPerDt as BegPerDt, @cEndPerDt as EndPerDt, count(*) as RecCount,
		sum(salesDollars) as TotSales, sum(SalesCost) as TotCost, sum(totalWeight) as TotWght
	FROM 	CustCatSalesSummary
	WHERE	FiscalPeriodNo = @cPeriod

	FETCH NEXT FROM  PerCursor INTO @cPeriod, @cBegPerDt, @cEndPerDt

   END
CLOSE PerCursor
DEALLOCATE PerCursor

DROP TABLE #BuyGrpCatDesc
DROP TABLE #tItemBranch

go