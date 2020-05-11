--Exec [pQuoteAndOrderHdrV2] '10','2011','','','15','200836','','MISSED_ECOMM','FALSE'
--Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','ECOMM','FALSE'
--Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','MISSED_ECOMM','FALSE'


  
-- **MISSED_ECOMM
SELECT	CM.CustNo as CustomerNumber,
  		CM.CustShipLocation as SalesBranchofRecord,
  		WebActivity.SessionID as QuoteNumber,
 		WebActivity.OrderSource as OrdSrc,
 		Src.OrdSrcDsc as QuoteMethod,
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
WHERE	0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND 1=1 AND
		Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10
and isnull(WebActivity.MakeOrderID,'') = ''
--		AND isnull(WebActivity.OrderSource,'RQ') = 'WQ' AND 2=2
GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID, WebActivity.OrderSource, Src.OrdSrcDsc
ORDER BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID 


 		 WHERE	--WebActivity.OrderSource = 'WQ' AND
 				isnull(WebActivity.MakeOrderID,'') = '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND
				Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10


-------------------------------------------------------------------------------------------

--Exec [pQuoteAndOrderHdrV2] '10','2011','','','15','200836','','MISSED_MANUAL','FALSE'
  
-- **MISSED_MANUAL
SELECT	CM.CustNo as CustomerNumber,
  		CM.CustShipLocation as SalesBranchofRecord,
  		Quote.SessionID as QuoteNumber,
 		Quote.OrderSource as OrdSrc,
 		Src.OrdSrcDsc as QuoteMethod,
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
WHERE	0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND 11=11 AND 
isnull(Quote.MakeOrderID,'') = '' and
		Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10
--AND isnull(Quote.OrderSource,'RQ') = 'RQ' AND 22=22

GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID, Quote.OrderSource, Src.OrdSrcDsc
ORDER BY CM.CustNo, CM.CustShipLocation, Quote.SessionID 
