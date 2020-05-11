SELECT	CustQuote.CustomerNumber,
--CustQuote.OrderCompletionStatus,
--CustQuote.PFCItemNo,
--CustQuote.*
 count(CustQuote.QuoteNumber) as NoofQuotes,
 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ExtAmount,
 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ExtWeight 
--INTO	##PFCM_22906788
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 				LD.SequenceNo as Sequence
 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		CustQuote.OrderSource = Src.OrdSrc 
WHERE	CustQuote.DeleteFlag = 0 and 1=1 AND 
		(Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND 
		CM.CustShipLocation like '%15%' AND CustQuote.OrderSource like '%WQ%'

and CustQuote.OrderCompletionStatus <> 1

GROUP BY CustQuote.CustomerNumber




select * 
from DTQ_CustomerQuotation

update DTQ_CustomerQuotation
set OrderCompletionStatus=0

Where ID in
(33175,33326)
--PFCItemNo in ('00200-2400-024','00205-2500-020') and CustomerNumber='000001'



-------------------------------------------------------------------------------------------------



SELECT	CustQuote.CustomerNumber,
 		count(CustQuote.QuoteNumber) as NoofOrders,
 		Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ExtOrdWeight,
 		Sum(PendOrdDtl.TotalPrice) as ExtOrdAmount 
--INTO	##PFCY_7483503C 
FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN
 		DTQ_CustomerQuotation CustQuote (NOLOCK) 
ON		PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN
 		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) 
ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus ='true' inner join
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 				LD.SequenceNo as Sequence
 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		CustQuote.OrderSource = Src.OrdSrc 
where	1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2009 AND Month(PendOrdHdr.PurchaseOrderDate) = 12) AND 
		CM.CustShipLocation like '%15%' AND PendOrdHdr.OrderSource like '%WQ%' 

and CustQuote.OrderCompletionStatus <> 1

group by CustQuote.CustomerNumber
