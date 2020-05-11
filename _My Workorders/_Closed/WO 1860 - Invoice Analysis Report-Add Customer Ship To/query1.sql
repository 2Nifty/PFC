--158 distinct - less than 1 second
SELECT	DISTINCT RepName AS Rep --, *
FROM	RepMaster
WHERE	RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx'
ORDER BY RepName


--37 distinct - 36 seconds
SELECT	DISTINCT RepName AS Rep --, *
FROM	RepMaster INNER JOIN
	SOHeaderHist
ON	SalesRepName = RepName
WHERE	RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx'
ORDER BY RepName


--37 distinct - 35 seconds
SELECT	DISTINCT RepName AS Rep --, *
FROM	RepMaster 
WHERE	RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx' AND
	RepName IN (SELECT DISTINCT SalesRepName FROM SOHeaderHist)
ORDER BY RepName



select max (arpostdt) from Soheaderhist


--displayed as Sales Person in right hand column on report
select SalesRepName, * from SOHeaderHist where invoiceno='108439'





select
CONVERT(nvarchar(10), SOHeaderHist.ARPostDt , 101) as [ARDate],SOHeaderHist.CustShipLoc as Branch, --OrderType,
		                            Case when SOHeaderHist.OrderType = '0' then 'Warehouse'
		                            when SOHeaderHist.OrderType = '1' then 'Mill'
		                            when SOHeaderHist.OrderType = '2' then 'StockRelease'
		                            when SOHeaderHist.OrderType = '0' then 'SpecialProcess'
		                            when SOHeaderHist.OrderType = '0' then 'PalletPartner'
		                            else 'Warehouse'
		                            End as OrderType,SOHeaderHist.City as ShipToCity, 
		                            SOHeaderHist.State as ShipToState,SOHeaderHist.SellToCustNo as CustNo, 
		                            SOHeaderHist.SellToCustName as CustName,CustomerMaster.ChainCd as Chain, 
		                            SOHeaderHist.InvoiceNo as DocNo,SOHeaderHist.CustPONo as CustPO, 
		                            SOHeaderHist.NetSales,SOHeaderHist.TotalOrder - SOHeaderHist.NetSales AS NetExp, 
		                            SOHeaderHist.TotalOrder AS TotAR,SOHeaderHist.NetSales - SOHeaderHist.TotalCost AS GMDollar, 
		                            Case 	when SOHeaderHist.NetSales = 0 then 0 
		                            Else ((SOHeaderHist.NetSales - SOHeaderHist.TotalCost) / SOHeaderHist.NetSales)*100 
		                            End as GMPct,SOHeaderHist.ShipWght as TotWgt, 
                                    SOHeaderHist.shipmethodname as ShipMethod,SOHeaderHist.CustSvcRepName as InsideSalesPerson,SOHeaderHist.SalesRepName as SalesPerson
from SOHeaderHist LEFT OUTER JOIN CustomerMaster ON SOHeaderHist.SellToCustNo = CustomerMaster.CustNo
where ARPostDt>='12/15/2009' and ARPostDt <='12/30/2009' and CustShipLoc='04'