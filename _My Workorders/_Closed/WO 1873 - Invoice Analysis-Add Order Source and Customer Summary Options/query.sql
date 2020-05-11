--65 records
SELECT	CONVERT(nvarchar(10),Hdr.ARPostDt,101) as [ARDate], 
	Hdr.OrderSource, 
	List.SequenceNo as OrderSourceSeq,
	Hdr.CustShipLoc as Branch, 
	Hdr.OrderTypeDsc as OrderType, 
	Hdr.City as ShipToCity, 
	Hdr.State as ShipToState, 
	Hdr.SellToCustNo as CustNo, 
	Hdr.SellToCustName as CustName, 
	Hdr.InvoiceNo as DocNo, 
	Hdr.CustPONo as CustPO, 
	Hdr.NetSales, 
	Hdr.TotalOrder - Hdr.NetSales as NetExp, 
	Hdr.TotalOrder as TotAR, 
	Hdr.NetSales - Hdr.TotalCost as GMDollar, 
	CASE WHEN Hdr.NetSales = 0 
	     THEN 0 
	     ELSE ((Hdr.NetSales - Hdr.TotalCost) / Hdr.NetSales) * 100 
	END as GMPct, 
	Hdr.ShipWght as TotWgt, 
	Hdr.OrderFreightName as ShipMethod, 
	Hdr.CustSvcRepName as InsideSalesPerson, 
	Hdr.SalesRepName as SalesPerson, 
	Hdr.ShipToName, 
	Cust.ChainCd as Chain, 
	Cust.PriceCd
FROM	SOHeaderHist Hdr (NOLOCK) LEFT OUTER JOIN 
	CustomerMaster Cust (NOLOCK)
ON	Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
	(SELECT	LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
--	 FROM	ListMaster LM INNER JOIN
--		ListDetail LD
	 ON	LM.pListMasterID=LD.fListMasterID
	 WHERE	LM.ListName = 'SOEOrderSource') List
ON	List.ListValue = Hdr.OrderSource
WHERE	Hdr.ARPostDt>= '3/28/2010' and Hdr.ARPostDt<= '6/21/2010' AND
	Hdr.SalesRepNo='0034' AND Hdr.CustShipLoc='01' and List.SequenceNo <> 1
order by 	Hdr.OrderSource





SELECT	LD.*
from 	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD on LM.pListMasterID=LD.fListMasterID
where	LM.ListName='SOEOrderSource'





update SOHeaderHist
SET OrderSource='SK'
WHERE InvoiceNo='213060'

213056
213057
213058
213059
213060


MO
FP
EI
WQ
DC
IX
RQ
SK
