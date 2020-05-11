--Exec [pQuoteAndOrderDtlV2] '10','2011','','','','200836','','MANUAL_ORD','FALSE','1127600550'


Month=10&Year=2011&
StartDate=&EndDate=&
CustomerNumber=200836&CustomerName=D S Sales and Service&
RepName=All&RepNo=&OrdSrc=ALL&ItemNotOrd=false&
SrcTyp=MISSED_ECOMM&QuoteNumber=1110311143



-- whereWebActivity: 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND 1=1 AND Year(WebActivity.QuoteDt) = 2010 AND Month(WebActivity.QuoteDt) = 12 AND isnull(WebActivity.OrderSource,'RQ') = 'WQ' AND WebActivity.SessionID like '%1110311143%' AND 2=2
-- whereQuote: 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND 11=11 AND Year(Quote.QuotationDate) = 2010 AND Month(Quote.QuotationDate) = 12 AND Quote.SessionID like '%1110311143%' AND 22=22
 
-- **MISSED_ECOMM
SELECT	CM.CustNo as CustomerNumber,
  		CM.CustShipLocation as SalesBranchofRecord,
  		WebActivity.SessionID as QuoteNumber,
 		CONVERT(nvarchar(20), WebActivity.QuoteDt, 101) as QuotationDate,
  		null as ExpiryDate,
 		isnull(WebActivity.OrderSource,'n/a') as OrderSource,
 		Src.OrdSrcDsc as QuoteMethod,
 		isnull(PendHdr.PurchaseOrderNo,'No PO') as PurchaseOrderNo,
 		PendHdr.PurchaseOrderDate,
  		WebActivity.CustItemNo as UserItemNo,
  		WebActivity.ItemNo as PFCItemNo,
 		IM.ItemDesc as Description,
 		isnull(cast((round(WebActivity.Qty,0)) as Decimal(25,0)),0) as RequestQuantity,
 		isnull(cast((round(WebActivity.AvailQty,0)) as Decimal(25,0)),0) as RunningAvailQty,
 		isnull(cast((round(WebActivity.SellPrice,2)) as Decimal(25,2)),0) as UnitPrice,
 		0 as Margin,
 		WebActivity.SellUM as PriceUOM,
 		isnull(cast((round(WebActivity.SellPrice * WebActivity.Qty,2)) as Decimal(25,2)),0) as TotalPrice,
 		isnull(cast((round(IM.GrossWght * WebActivity.Qty,1)) as Decimal(25,1)),0) as GrossWeight,
 		isnull(PendHdr.ECommUserName,'NA') as ECommUserName,
 		isnull(PendHdr.ECommIPAddress,'NA') as ECommIPAddress,
  		isnull(PendHdr.ECommPhoneNo,'NA') as ECommPhoneNo 
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
ON		isnull(WebActivity.OrderSource,'RQ') = Src.OrdSrc LEFT OUTER JOIN
 		DTQ_CustomerPendingOrderDetail PendDtl (NOLOCK) 
ON		WebActivity.SessionID = PendDtl.QuotationItemDetailID LEFT OUTER JOIN
 		DTQ_CustomerPendingOrder PendHdr (NOLOCK) 
ON		PendHdr.ID = PendDtl.PurchaseOrderID 
WHERE	0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND 1=1 AND 
		Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10 AND --isnull(WebActivity.OrderSource,'RQ') = 'WQ' AND
		WebActivity.SessionID like '%1110311143%' AND 2=2
ORDER BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID 




		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				WebActivity.SessionID,
WebActivity.QuoteRowID,
WebActivity.MakeOrderID
 		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = WebActivity.ItemNo
 		 WHERE	isnull(WebActivity.MakeOrderID,'') = '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND
				Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10 and
WebActivity.SessionID like '%1110311143%'




 
-- **MANUAL_ORD
SELECT	
Quote.MakeOrderID,
CM.CustNo as CustomerNumber,
  		CM.CustShipLocation as SalesBranchofRecord,
  		Quote.SessionID as QuoteNumber,
 		CONVERT(nvarchar(20), Quote.QuotationDate, 101) as QuotationDate,
  		Quote.ExpiryDate,
 		isnull(Quote.OrderSource,'n/a') as OrderSource,
 		Src.OrdSrcDsc as QuoteMethod,
 		isnull(RelHdr.CustPONo,'No PO') as PurchaseOrderNo,
 		RelHdr.OrderDt as PurchaseOrderDate,
 		Quote.UserItemNo,
  		Quote.PFCItemNo,
 		Quote.Description,
 		isnull(cast((round(Quote.RequestQuantity,0)) as Decimal(25,0)),0) as RequestQuantity,
 		isnull(cast((round(Quote.AvailableQuantity,0)) as Decimal(25,0)),0) as RunningAvailQty,
 		isnull(cast((round(Quote.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice,
 		0 as Margin,
 		Quote.PriceUOM,
 		isnull(cast((round(Quote.UnitPrice * Quote.RequestQuantity,2)) as Decimal(25,2)),0) as TotalPrice,
 		isnull(cast((round(Quote.GrossWeight * Quote.RequestQuantity,1)) as Decimal(25,1)),0) as GrossWeight,
 		'Manual' as ECommUserName,
 		'Manual' as ECommIPAddress,
  		'Manual' as ECommPhoneNo 
FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
  		CustomerMaster CM (NOLOCK)
ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN
 		SOHeaderRel RelHdr (NOLOCK) 
ON		Quote.SessionID = RelHdr.ReferenceNo LEFT OUTER JOIN
  		(SELECT	LD.ListValue as OrdSrc,
 				isnull(LD.ListDtlDesc,'No Desc') as OrdSrcDsc,
  				isnull(LD.SequenceNo,0) as [Sequence]
  		 FROM	ListMaster LM (NOLOCK) INNER JOIN
  				ListDetail LD (NOLOCK)
  		 ON		LM.pListMasterID = LD.fListMasterID
  		 WHERE	LM.ListName = 'SOEOrderSource') Src 
ON		isnull(Quote.OrderSource,'RQ') = Src.OrdSrc 
WHERE	0=0 AND CM.CustNo like '%200836%' AND 11=11 AND 
		Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10 AND
--		Src.Sequence <> 1 AND 
--isnull(Quote.MakeOrderID,'') <> '' AND 
Quote.SessionID like '%1110311143%' AND 22=22 
ORDER BY CM.CustNo, CM.CustShipLocation, Quote.SessionID 


