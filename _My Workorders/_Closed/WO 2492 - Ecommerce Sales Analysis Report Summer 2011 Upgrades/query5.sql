SELECT	ManualQuote.CustNo as CustomerNumber,
 		ManualQuote.SalesLocationCode,
 		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes,
 		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount,
 		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight 
--INTO	##tManualQuote_D8E49C25 
FROM	(


SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				Quote.SessionID,
 				count(Quote.QuoteNumber) as NoOfManualQuotes,
 				sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtAmount,
 				sum(Quote.GrossWeight * Quote.RequestQuantity) as ManualExtWeight
 		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN
 						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(Quote.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] <> 1 AND 0=0 AND CM.PriceCd <> 'X' AND 
				11=11 AND Year(Quote.QuotationDate) = 2010 AND Month(Quote.QuotationDate) = 12 AND 22=22
 		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID

) ManualQuote 
GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode
 









SELECT	tQuote.QuoteNumber,
		tQuote.OrderSource,
--		SourceDesc
		tQuote.LineCount,
		tQuote.QuotationDate,
		tQuote.ExpiryDate,
		tQuote.RequestQuantity,
		tQuote.ExtPrice,
		tQuote.ExtWeight

FROM	(SELECT	Quote.SessionID as QuoteNumber,
 				Quote.OrderSource,
 				count(Quote.PFCItemNo) as LineCount,
 				MAX(Quote.QuotationDate) as QuotationDate,
 				MAX(Quote.ExpiryDate) as ExpiryDate,
 				sum(Quote.RequestQuantity) as RequestQuantity,
 				sum(Quote.UnitPrice * Quote.RequestQuantity) as ExtPrice,
 				sum(Quote.GrossWeight * Quote.RequestQuantity) as ExtWeight 
		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) 
		 GROUP BY Quote.SessionID, Quote.OrderSource) tQuote LEFT OUTER JOIN
		CustomerMaster CM (NOLOCK)
ON		tQuote.









--basic orders from DTQ
SELECT	CM.CustNo,
 		CM.CustShipLocation as SalesBranchofRecord,
 		Quote.SessionID as QuoteNumber,
		Quote.OrderSource as OrdSrc,
		Src.OrdSrcDsc,
 		count(Quote.PFCItemNo) as LineCount,
 		MAX(Quote.QuotationDate) as QuotationDate,
 		MAX(Quote.ExpiryDate) as ExpiryDate,
 		sum(Quote.RequestQuantity) as RequestQuantity,
 		sum(Quote.UnitPrice * Quote.RequestQuantity) as ExtPrice,
 		sum(Quote.GrossWeight * Quote.RequestQuantity) as ExtWeight 
FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 		CustomerMaster CM (NOLOCK) 
ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
				isnull(LD.ListDtlDesc,'No Desc') as OrdSrcDsc,
 				isnull(LD.SequenceNo,0) as [Sequence]
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 				ListDetail LD (NOLOCK)
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		isnull(Quote.OrderSource,'RQ') = Src.OrdSrc 
GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID, Quote.OrderSource, Src.OrdSrcDsc
ORDER BY CM.CustNo, CM.CustShipLocation, Quote.SessionID 




--basic quotes from WebActivity
SELECT	CM.CustNo,
 		CM.CustShipLocation as SalesBranchofRecord,
 		WebActivity.SessionID as QuoteNumber,
		WebActivity.OrderSource as OrdSrc,
		Src.OrdSrcDsc,
 		count(WebActivity.ItemNo) as LineCount,
 		MAX(WebActivity.QuoteDt) as QuotationDate,
 		null as ExpiryDate,
 		sum(WebActivity.Qty) as RequestQuantity,
 		sum(WebActivity.SellPrice * WebActivity.Qty) as ExtPrice,
 		sum(IM.GrossWght * WebActivity.Qty) as ExtWeight 
FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 		CustomerMaster CM (NOLOCK) 
ON		CM.CustNo = WebActivity.CustNo INNER JOIN
		ItemMaster IM (NOLOCK)
ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
				isnull(LD.ListDtlDesc,'No Desc') as OrdSrcDsc,
 				isnull(LD.SequenceNo,0) as [Sequence]
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 				ListDetail LD (NOLOCK)
 		 ON		LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		isnull(WebActivity.OrderSource,'RQ') = Src.OrdSrc 
GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID, WebActivity.OrderSource, Src.OrdSrcDsc
ORDER BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID 


select * from WebActivityPosting












select * 
update WebActivityPosting
set MakeOrderID='T', MakeOrderDt='09/23/2011'
where SessionID='10120110'

exec sp_columns WebActivityPosting





--	**eCommerce Orders FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1 AND WebActivity.OrderCompletionStatus = 1
			--SELECT * FROM ##tECommOrder_CA72CC45
			--DROP TABLE ##tECommOrder_CA72CC45
SELECT	ECommOrder.CustNo as CustomerNumber,
 		ECommOrder.SalesLocationCode,
 		count(ECommOrder.NoOfECommOrders) as NoOfECommOrders,
 		sum(isnull(ECommOrder.eCommExtOrdAmount,0)) as eCommExtOrdAmount,
 		sum(isnull(ECommOrder.eCommExtOrdWeight,0)) as eCommExtOrdWeight 
--INTO	##tECommOrder_CA72CC45 
FROM	(

SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				WebActivity.SessionID,
isnull(WebActivity.MakeOrderID,''),
 				count(WebActivity.QuoteNo) as NoOfECommOrders,
 				Sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtOrdAmount,
 				Sum(IM.GrossWght * WebActivity.Qty) as eCommExtOrdWeight



 		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN
 						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(WebActivity.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] = 1 AND
-- 				isnull(WebActivity.MakeOrderID,'') <> '' AND 
0=0 AND CM.PriceCd <> 'X' AND 
				1=1 AND Year(WebActivity.QuoteDt) = 2010 AND Month(WebActivity.QuoteDt) = 12 AND 2=2
 		 GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID, isnull(WebActivity.MakeOrderID,'')


) ECommOrder 
GROUP BY  ECommOrder.CustNo, ECommOrder.SalesLocationCode
-- END: Get eCommerce Quote & Order Data