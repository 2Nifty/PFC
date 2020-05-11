
exec UGEN_SP_Select 
'SOHeaderHist Hdr (NOLOCK) LEFT OUTER JOIN CustomerMaster Cust (NOLOCK) ON Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN (SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo FROM   OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListMaster LM INNER JOIN OpenDataSource(''SQLOLEDB'',''Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal'').PERP.dbo.ListDetail LD ON     LM.pListMasterID=LD.fListMasterID WHERE  LM.ListName = ''SOEOrderSource'') List ON List.ListValue = Hdr.OrderSource'
,
'Hdr.*', 'Hdr.ARPostDt>=''2010-07-15'' AND Hdr.CustShipLoc=''15'''



select
CONVERT(nvarchar(10),Hdr.ARPostDt,101) as [ARDate],
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
Hdr.OrderSource,
List.SequenceNo as OrderSourceSeq,
Cust.ChainCd as Chain,
Cust.PriceCd
from 
SOHeaderHist Hdr (NOLOCK) LEFT OUTER JOIN
CustomerMaster Cust (NOLOCK) ON Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
(SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo
 FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
        OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
 ON     LM.pListMasterID=LD.fListMasterID
 WHERE  LM.ListName = 'SOEOrderSource') List
ON List.ListValue = Hdr.OrderSource