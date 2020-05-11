DECLARE	
		@Period varchar(6),
		@CustNo varchar(10)

set @Period = '201204'
set @CustNo = '011571'


drop table #tCustCat
drop table #tCustItem

select CustomerNo,
		sum(SalesDollars) as SalesDollars, sum(SalesCost) as SalesCost,
		sum(TotalWeight) as TotalWeight, sum(AvgCostDollars) as AvgCostDollars, sum(PriceCostDollars) as PriceCostDollars
into #tCustCat
from CustCatSalesSummary
--where FiscalPeriodNo=@Period --and CustomerNo=@CustNo 
where FiscalPeriodNo<'201208'
group by CustomerNo
order by CustomerNo
select * from #tCustCat

select	CustNo as iCustomerNo, --left(ItemNo,5) as iCategory, FiscalPeriodNo as iFiscalPeriodNo,
		sum(SalesDollars) as iSalesDollars, sum(SalesCost) as iSalesCost,
		sum(TotalWeight) as iTotalWeight, sum(AvgCostDollars) as iAvgCostDollars, sum(PriceCostDollars) as iPriceCostDollars
into	#tCustItem
from tCustItemSalesSummary 
--where FiscalPeriodNo=@Period --and CustNo=@CustNo 
where FiscalPeriodNo<'201208'
group by CustNo--, left(ItemNo,5), FiscalPeriodNo
order by CustNo--, left(ItemNo,5), FiscalPeriodNo
select * from #tCustItem


select * from #tCustCat where CustomerNo not in (select iCustomerNo from #tCustItem)
select * from #tCustItem where iCustomerNo not in (select CustomerNo from #tCustCat)


select	isnull(tCat.CustomerNo,isnull(tItem.iCustomerNo,'NoCust')) as CustNo,
		SalesDollars,
		iSalesDollars,
		SalesCost,
		iSalesCost,
		TotalWeight,
		iTotalWeight,
		AvgCostDollars,
		iAvgCostDollars,
		PriceCostDollars,
		iPriceCostDollars
from	#tCustCat tCat full outer join
		#tCustItem tItem
on		tCat.CustomerNo=tItem.iCustomerNo
where	--SalesDollars<>iSalesDollars --or 
		--SalesCost<>iSalesCost --or 
		--TotalWeight<>iTotalWeight --or 
		--AvgCostDollars<>iAvgCostDollars --or
		PriceCostDollars<>iPriceCostDollars	--332 differences
order by isnull(tCat.CustomerNo,isnull(tItem.iCustomerNo,'NoCust'))



-------------------------------------------------------------

--custCat
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
			SUM(isnull(IB.AvgCost,0) * Dtl.QtyShipped) as AvgCostDollars,
			SUM(isnull(IB.PriceCost,0) * Dtl.QtyShipped) as PriceCostDollars,
			system_user as [EntryID],
			CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]
FROM		SOHeaderHist Hdr (NoLock) INNER JOIN
			SODetailHist Dtl (NoLock)
ON			Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
			#tItemBranch IB (NoLock)
ON			Dtl.ItemNo = IB.ItemNo AND Dtl.IMLoc = IB.Location LEFT OUTER JOIN
			#BuyGrpCatDesc BuyGrp (NoLock)
ON			LEFT(Dtl.ItemNo, 5) = BuyGrp.CatNo
WHERE		Hdr.ARPostDt between @BegPer and @EndPer
			AND ISNULL(Hdr.DeleteDt,'') = ''
GROUP BY	Hdr.SellToCustNo, LEFT(Dtl.ItemNo, 5), BuyGrp.CatDesc, BuyGrp.BuyGrpNo, BuyGrp.BuyGrpDesc