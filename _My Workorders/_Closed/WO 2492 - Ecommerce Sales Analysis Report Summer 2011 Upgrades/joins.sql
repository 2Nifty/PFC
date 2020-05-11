select * from
(
select	isnull(PendOrd.PurchaseOrderNo,'noPO') as PONo,
	WebQuote.*
from	WebActivityPosting WebQuote left outer join


(select	dtl.QuotationItemDetailID, hdr.PurchaseOrderNo, hdr.PurchaseOrderDate
From	DTQ_CustomerPendingOrder hdr inner join
	DTQ_CustomerPendingOrderDetail dtl
on	hdr.ID = dtl.PurchaseOrderID) PendOrd

on	WebQuote.QuoteNo = PendOrd.QuotationItemDetailID

where QuoteDt > getdate()-200
) tmp
where PONo <> 'noPO'




select * from WebActivityPosting


select	*
From	DTQ_CustomerPendingOrder hdr inner join
	DTQ_CustomerPendingOrderDetail dtl
on	hdr.ID = dtl.PurchaseOrderID



QuotationItemDetailID
from DTQ_CustomerPendingOrderDetail








select * from
(
select	isnull(RelHdr.CustPONo,'noPO') as PONo,
	Quote.*
from	DTQ_CustomerQuotation (NOLOCK) Quote left outer join
	SOHeaderRel (NOLOCK) RelHdr
ON	Quote.SessionID = RelHdr.ReferenceNo
where QuotationDate > getdate()-200
) tmp
where PONo <> 'noPO'


--	(SELECT	*
--	 FROM	SOHeaderRel Hdr (NOLOCK) inner join
--		SODetailRel Dtl (NOLOCK)
--	 ON	Hdr.pSOHeaderRelID = Dtl.fSOHeaderRelID) Rel
--ON	Quote.SessionID = Rel.ReferenceNo


select * from SOHeaderRel



select	isnull(RelHdr.CustPONo,'noPO') as PONo,
	Quote.*
from	DTQ_CustomerQuotation (NOLOCK) Quote left outer join
	SOHeaderRel (NOLOCK) RelHdr
ON	Quote.SessionID = RelHdr.ReferenceNo