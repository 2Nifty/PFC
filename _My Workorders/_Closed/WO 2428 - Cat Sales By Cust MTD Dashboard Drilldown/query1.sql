

--Create #CategoryDesc
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


truncate table CustCatSalesSummary

INSERT INTO CustCatSalesSummary
(
[CustomerNo],
Category,
[FiscalPeriodNo],
CategoryDesc,
BuyCategory,
--BuyCategoryDesc,
SalesDollars,
SalesCost,
NoofOrders,
OtherSalesCost,
OtherSalesDol,
CommissionDollars,
TotalWeight,
NoofPFCSOEQuotes,
NoofPFCSOEOrders,
NoofWebQuotes,
NoofWebOrders,
NoofDirectConnectQuotes,
NoofDirectConnectOrders,
NoofSDKQuotes,
NoofSDKOrders,
NoofInxSQLQuotes,
NoofInxSQLOrders,
NoofTimesFilledWeb,
NoofTimesPartialWeb,
NoofTimesZerosWeb,
NoofTimesFilledPFCSOE,
NoofTimesPartialPFCSOE,
NoofTimesZerosPFCSOE,
NoofTimesFilledDirectConnect,
NoofTimesPartialDirectConnect,
NoofTimesZerosDirectConnect,
NoofTimesFilledSDK,
NoofTimesPartialSDK,
NoofTimesZerosSDK,
NoofTimesFilledInxSQL,
NoofTimesPartialInxSQL,
NoofTimesZerosInxSQL,
NoofPFCSOEOnlyOrders,

[EntryID],
EntryDt

)

--DEVPERP (865,607 row(s) affected) 3 minutes
SELECT
	CustSumm.[CustomerNo],
	LEFT(CustSumm.[ItemNo],5) as Category,
	CustSumm.[FiscalPeriodNo],

--	CustSumm.[CalendarFiscalPeriod]
--from CustomerSalesSummary (NoLock) CustSumm

	BuyGrp.[CatDesc] as CategoryDesc,
	BuyGrp.[BuyGrpNo] as BuyCategory,
--	BuyGrp.[BuyGrpDesc] as BuyCategoryDesc,

	isnull(SUM(CustSumm.[SalesDollars]),0) as SalesDollars,
	isnull(SUM(CustSumm.[SalesCost]),0) as SalesCost,
	isnull(SUM(CustSumm.[NoofOrders]),0) as NoofOrders,
	isnull(SUM(CustSumm.[OtherSalesCost]),0) as OtherSalesCost,
	isnull(SUM(CustSumm.[OtherSalesDol]),0) as OtherSalesDol,
	isnull(SUM(CustSumm.[CommissionDollars]),0) as CommissionDollars,
	isnull(SUM(CustSumm.[TotalWeight]),0) as TotalWeight,
	isnull(SUM(CustSumm.[NoofPFCSOEQuotes]),0) as NoofPFCSOEQuotes,
	isnull(SUM(CustSumm.[NoofPFCSOEOrders]),0) as NoofPFCSOEOrders,
	isnull(SUM(CustSumm.[NoofWebQuotes]),0) as NoofWebQuotes,
	isnull(SUM(CustSumm.[NoofWebOrders]),0) as NoofWebOrders,
	isnull(SUM(CustSumm.[NoofDirectConnectQuotes]),0) as NoofDirectConnectQuotes,
	isnull(SUM(CustSumm.[NoofDirectConnectOrders]),0) as NoofDirectConnectOrders,
	isnull(SUM(CustSumm.[NoofSDKQuotes]),0) as NoofSDKQuotes,
	isnull(SUM(CustSumm.[NoofSDKOrders]),0) as NoofSDKOrders,
	isnull(SUM(CustSumm.[NoofInxSQLQuotes]),0) as NoofInxSQLQuotes,
	isnull(SUM(CustSumm.[NoofInxSQLOrders]),0) as NoofInxSQLOrders,
	isnull(SUM(CustSumm.[NoofTimesFilledWeb]),0) as NoofTimesFilledWeb,
	isnull(SUM(CustSumm.[NoofTimesPartialWeb]),0) as NoofTimesPartialWeb,
	isnull(SUM(CustSumm.[NoofTimesZerosWeb]),0) as NoofTimesZerosWeb,
	isnull(SUM(CustSumm.[NoofTimesFilledPFCSOE]),0) as NoofTimesFilledPFCSOE,
	isnull(SUM(CustSumm.[NoofTimesPartialPFCSOE]),0) as NoofTimesPartialPFCSOE,
	isnull(SUM(CustSumm.[NoofTimesZerosPFCSOE]),0) as NoofTimesZerosPFCSOE,
	isnull(SUM(CustSumm.[NoofTimesFilledDirectConnect]),0) as NoofTimesFilledDirectConnect,
	isnull(SUM(CustSumm.[NoofTimesPartialDirectConnect]),0) as NoofTimesPartialDirectConnect,
	isnull(SUM(CustSumm.[NoofTimesZerosDirectConnect]),0) as NoofTimesZerosDirectConnect,
	isnull(SUM(CustSumm.[NoofTimesFilledSDK]),0) as NoofTimesFilledSDK,
	isnull(SUM(CustSumm.[NoofTimesPartialSDK]),0) as NoofTimesPartialSDK,
	isnull(SUM(CustSumm.[NoofTimesZerosSDK]),0) as NoofTimesZerosSDK,
	isnull(SUM(CustSumm.[NoofTimesFilledInxSQL]),0) as NoofTimesFilledInxSQL,
	isnull(SUM(CustSumm.[NoofTimesPartialInxSQL]),0) as NoofTimesPartialInxSQL,
	isnull(SUM(CustSumm.[NoofTimesZerosInxSQL]),0) as NoofTimesZerosInxSQL,
	isnull(SUM(CustSumm.[NoofPFCSOEOnlyOrders]),0) as NoofPFCSOEOnlyOrders,

	system_user as [EntryID],
	CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as [EntryDt]

--	CustSumm.[PostingDt],
--	CustSumm.[ChangeID],
--	CustSumm.[ChangeDt],
--	CustSumm.[StatusCd],

FROM	CustomerSalesSummary (NoLock) CustSumm LEFT OUTER JOIN
		#BuyGrpCatDesc (NoLock) BuyGrp
ON		LEFT(CustSumm.[ItemNo],5) = BuyGrp.CatNo
		
GROUP BY CustSumm.[CustomerNo], LEFT(CustSumm.[ItemNo],5), CustSumm.[FiscalPeriodNo],
		BuyGrp.[CatDesc], BuyGrp.[BuyGrpNo], BuyGrp.[BuyGrpDesc]


--------------------------------------------------------------------------------------------------


select * from CustCatSalesSummary
truncate table CustCatSalesSummary

truncate table CustomerSalesSummary

select distinct FiscalPeriodNo
from CustCatSalesSummary
order by FiscalPeriodNo


update CustCatSalesSummary
set FiscalPeriodNo='201104'
where FiscalPeriodNo='201002'



select * from CustCatSalesSummary 
where CustomerNo+Category in 
(select CustomerNo+Category from CustCatSalesSummary where FiscalPeriodNo='201106')
and 
(FiscalPeriodNo='201105' or FiscalPeriodNo='201104')


select ListDetail.* from ListMaster inner join ListDetail on plistmasterid=flistmasterid where ListName='BuyCategories'



select ListDetail.* from ListMaster inner join ListDetail on plistmasterid=flistmasterid where ListName='BuyCategories'

select ListDetail.* from ListMaster inner join ListDetail on plistmasterid=flistmasterid where ListName='CategoryDesc'



select * from CategoryBuyGroups

select * from ListMaster





--http://localhost/intranetsite/DashboardDrilldown/CatSalesRpt.aspx?Location=15&LocName=SFS&Range=MTD&Category=00024

