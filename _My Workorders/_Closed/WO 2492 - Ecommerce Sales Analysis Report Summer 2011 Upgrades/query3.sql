
-- **CustomerMaster
--SELECT * FROM ##tCustMaster_FF783B75
--DROP TABLE ##tCustMaster_FF783B75
SELECT	CustQuote.CustomerNumber, CM.CustShipLocation as SalesLocationCode 
--INTO	##tCustMaster_FF783B75 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS WHERE	CustQuote.DeleteFlag = 0 and 1=1 AND (Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' GROUP BY CustQuote.CustomerNumber, CM.CustShipLocation
 

select * from 
OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
where CM.CustShipLocation = '15'


--------------------------------------------------------------------------------------------------------



-- **eCommerce Quotes
--SELECT * FROM ##tECommQuote_DD494BAE
--DROP TABLE ##tECommQuote_DD494BAE


select	Quote.CustomerNumber as QuoteCust,
		count(Quote.CustomerNumber) as QuoteCount,
		sum(isnull(Quote.eCommExtAmount,0)) as eCommExtAmount,
		sum(isnull(Quote.eCommExtWeight,0)) as eCommExtWeight
from
(

SELECT	
CustQuote.CustomerNumber,
CustQuote.SessionID,
--CustQuote.*

		count(CustQuote.QuoteNumber) as NoOfECommQuotes,
 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as eCommExtAmount,
 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtWeight 

--INTO	##tECommQuote_DD494BAE 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 				isnull(LD.SequenceNo,0) as Sequence
 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		CustQuote.OrderSource = Src.OrdSrc 
WHERE	CustQuote.DeleteFlag = 0 and Src.Sequence = 1 and 1=1 AND 
		(Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
GROUP BY CustQuote.CustomerNumber, CustQuote.SessionID
 
) Quote
group by Quote.CustomerNumber




select 
CustomerNumber,


* from DTQ_CustomerQuotation


where CustomerNumber='001003'




update DTQ_CustomerQuotation
set QuoteNumber = '001015'
where id =








select count(*)as TotCount from DTQ_CustomerQuotation

--one line item per quote number
select count(*) as DistinctQuoteNo from
(select distinct(QuoteNumber) from DTQ_CustomerQuotation) tmp

--multiple quote numbers for each SessionId
select count(*) as DistinctSess from
(select distinct(SessionID) from DTQ_CustomerQuotation) tmp







-----------------------------------------------------------------------------------------------------------



-- **eCommerce Orders
--SELECT * FROM ##tECommOrder_A4B07752
--DROP TABLE ##tECommOrder_A4B07752
SELECT	CustQuote.CustomerNumber,
PendOrdDtl.*

-- 		count(CustQuote.QuoteNumber) as NoOfECommOrders,
-- 		Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtOrdWeight,
-- 		Sum(PendOrdDtl.TotalPrice) as eCommExtOrdAmount 
--INTO	##tECommOrder_A4B07752 
FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN
 		DTQ_CustomerQuotation CustQuote (NOLOCK) 
ON		PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN
 		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) 
ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus ='true' inner join
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 				isnull(LD.SequenceNo,0) as Sequence
 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		CustQuote.OrderSource = Src.OrdSrc 
WHERE	Src.Sequence = 1 and 1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2009 AND Month(PendOrdHdr.PurchaseOrderDate) = 12) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1 
--GROUP BY CustQuote.CustomerNumber
 






-----------------------------------------------------------------------------------------------------------







-- **Manual Quotes
--SELECT * FROM ##tManualQuote_832551D3
--DROP TABLE ##tManualQuote_832551D3
SELECT	CustQuote.CustomerNumber, count(CustQuote.QuoteNumber) as NoOfManualQuotes, 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount, 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight 
--INTO	##tManualQuote_832551D3 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN 		(SELECT	LD.ListValue as OrdSrc, 				isnull(LD.SequenceNo,0) as Sequence 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD 		 ON		LM.pListMasterID = LD.fListMasterID 		 WHERE	LM.ListName = 'SOEOrderSource') Src ON		CustQuote.OrderSource = Src.OrdSrc WHERE	CustQuote.DeleteFlag = 0 and Src.Sequence <> 1 and 1=1 AND (Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1 GROUP BY CustQuote.CustomerNumber
 
-- **Manual Orders
--SELECT * FROM ##tManualOrder_59ABA0B9
--DROP TABLE ##tManualOrder_59ABA0B9
SELECT	CustQuote.CustomerNumber, 		count(CustQuote.QuoteNumber) as NoOfManualOrders, 		Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtOrdWeight, 		Sum(PendOrdDtl.TotalPrice) as ManualExtOrdAmount 
--INTO	##tManualOrder_59ABA0B9 
FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN 		DTQ_CustomerQuotation CustQuote (NOLOCK) ON		PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN 		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus ='true' inner join 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN 		(SELECT	LD.ListValue as OrdSrc, 				isnull(LD.SequenceNo,0) as Sequence 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD 		 ON		LM.pListMasterID = LD.fListMasterID 		 WHERE	LM.ListName = 'SOEOrderSource') Src ON		CustQuote.OrderSource = Src.OrdSrc WHERE	Src.Sequence <> 1 and 1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2009 AND Month(PendOrdHdr.PurchaseOrderDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1 GROUP BY CustQuote.CustomerNumber
 
-- **Missed eCommerce Quotes
--SELECT * FROM ##tMissedECommQuote_56CCFF3A
--DROP TABLE ##tMissedECommQuote_56CCFF3A
SELECT	CustQuote.CustomerNumber, count(CustQuote.QuoteNumber) as NoOfECommQuotes, 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as eCommExtAmount, 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as eCommExtWeight 
--INTO	##tMissedECommQuote_56CCFF3A 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN 		(SELECT	LD.ListValue as OrdSrc, 				isnull(LD.SequenceNo,0) as Sequence 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD 		 ON		LM.pListMasterID = LD.fListMasterID 		 WHERE	LM.ListName = 'SOEOrderSource') Src ON		CustQuote.OrderSource = Src.OrdSrc WHERE	CustQuote.DeleteFlag = 0 and Src.OrdSrc = 'WQ' and CustQuote.OrderCompletionStatus <> 1 and 1=1 AND (Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' GROUP BY CustQuote.CustomerNumber
 
-- **Missed Manual Quotes
--SELECT * FROM ##tMissedManualQuote_0C1E31FD
--DROP TABLE ##tMissedManualQuote_0C1E31FD
SELECT	CustQuote.CustomerNumber, count(CustQuote.QuoteNumber) as NoOfManualQuotes, 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount, 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight 
--INTO	##tMissedManualQuote_0C1E31FD 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM ON		CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN 		(SELECT	LD.ListValue as OrdSrc, 				isnull(LD.SequenceNo,0) as Sequence 		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN 				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD 		 ON		LM.pListMasterID = LD.fListMasterID 		 WHERE	LM.ListName = 'SOEOrderSource') Src ON		CustQuote.OrderSource = Src.OrdSrc WHERE	CustQuote.DeleteFlag = 0 and Src.OrdSrc = 'RQ' and CustQuote.OrderCompletionStatus <> 1 and 1=1 AND (Year(CustQuote.QuotationDate) = 2009 AND Month(CustQuote.QuotationDate) = 12) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' GROUP BY CustQuote.CustomerNumber
 
-- **Compile & return the complete dataset
--SELECT * FROM ##tResultB8B005B5
--DROP TABLE ##tResultB8B005B5
SELECT	##tCustMaster_FF783B75.CustomerNumber, ##tCustMaster_FF783B75.SalesLocationCode, 			ISNULL(##tECommQuote_DD494BAE.NoOfECommQuotes,0) as NoOfECommQuotes, 			ISNULL(cast((round(##tECommQuote_DD494BAE.eCommExtAmount,2)) as Decimal(25,2)),0) as eCommExtAmount, 			ISNULL(cast((round(##tECommQuote_DD494BAE.eCommExtWeight,1)) as Decimal(25,1)),0) as eCommExtWeight, 			ISNULL(##tECommOrder_A4B07752.NoOfECommOrders,0) as NoOfECommOrders, 			ISNULL(cast((round(##tECommOrder_A4B07752.eCommExtOrdAmount,2)) as Decimal(25,2)),0) as eCommExtOrdAmount, 			ISNULL(cast((round(##tECommOrder_A4B07752.eCommExtOrdWeight,1)) as Decimal(25,1)),0) as eCommExtOrdWeight, 			ISNULL(##tManualQuote_832551D3.NoOfManualQuotes,0) as NoOfManualQuotes, 			ISNULL(cast((round(##tManualQuote_832551D3.ManualExtAmount,2)) as Decimal(25,2)),0) as ManualExtAmount, 			ISNULL(cast((round(##tManualQuote_832551D3.ManualExtWeight,1)) as Decimal(25,1)),0) as ManualExtWeight, 			ISNULL(##tManualOrder_59ABA0B9.NoOfManualOrders,0) as NoOfManualOrders, 			ISNULL(cast((round(##tManualOrder_59ABA0B9.ManualExtOrdAmount,2)) as Decimal(25,2)),0) as ManualExtOrdAmount, 			ISNULL(cast((round(##tManualOrder_59ABA0B9.ManualExtOrdWeight,1)) as Decimal(25,1)),0) as ManualExtOrdWeight, 			ISNULL(##tMissedECommQuote_56CCFF3A.NoOfECommQuotes,0) as NoOfMissedECommQuotes, 			ISNULL(cast((round(##tMissedECommQuote_56CCFF3A.eCommExtAmount,2)) as Decimal(25,2)),0) as MissedECommExtAmount, 			ISNULL(cast((round(##tMissedECommQuote_56CCFF3A.eCommExtWeight,1)) as Decimal(25,1)),0) as MissedECommExtWeight, 			ISNULL(##tMissedManualQuote_0C1E31FD.NoOfManualQuotes,0) as NoOfMissedManualQuotes, 			ISNULL(cast((round(##tMissedManualQuote_0C1E31FD.ManualExtAmount,2)) as Decimal(25,2)),0) as MissedManualExtAmount, 			ISNULL(cast((round(##tMissedManualQuote_0C1E31FD.ManualExtWeight,1)) as Decimal(25,1)),0) as MissedManualExtWeight 
--INTO	##tResultB8B005B5 
FROM	##tCustMaster_FF783B75 LEFT OUTER JOIN ##tECommOrder_A4B07752 ON		##tCustMaster_FF783B75.CustomerNumber = ##tECommOrder_A4B07752.CustomerNumber LEFT OUTER JOIN ##tECommQuote_DD494BAE ON		##tCustMaster_FF783B75.CustomerNumber = ##tECommQuote_DD494BAE.CustomerNumber LEFT OUTER JOIN ##tManualQuote_832551D3 ON		##tCustMaster_FF783B75.CustomerNumber = ##tManualQuote_832551D3.CustomerNumber LEFT OUTER JOIN ##tManualOrder_59ABA0B9 ON		##tCustMaster_FF783B75.CustomerNumber = ##tManualOrder_59ABA0B9.CustomerNumber LEFT OUTER JOIN ##tMissedECommQuote_56CCFF3A ON		##tCustMaster_FF783B75.CustomerNumber = ##tMissedECommQuote_56CCFF3A.CustomerNumber LEFT OUTER JOIN ##tMissedManualQuote_0C1E31FD ON		##tCustMaster_FF783B75.CustomerNumber = ##tMissedManualQuote_0C1E31FD.CustomerNumber
