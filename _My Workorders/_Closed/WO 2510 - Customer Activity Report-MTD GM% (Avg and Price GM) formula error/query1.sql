select * from 
(
select
	FiscalPeriodNo,
	sum(isnull(AvgCostDollars,0)) as AvgDol,
	sum(isnull(PriceCostDollars,0)) as PriceDol
from CustCatSalesSummary
group by FiscalPeriodNo
) tmp
where AvgDol=0 and PriceDol=0

select * from CustCatSalesSummary where fiscalperiodno='201109'


select FiscalPeriodNo from CustCatSalesSummary where sum(isnull(AvgCostDollars,0))=0 and sum(isnull(PriceCostDollars,0))=0
group by FiscalPeriodNo