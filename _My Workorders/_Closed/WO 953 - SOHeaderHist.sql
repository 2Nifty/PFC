select InvoiceNo, ARPostDt, CustShipLoc from SOHeaderHist
where CustShipLoc=21


UPDATE	SOHeaderHist
SET	CustShipLoc=10
WHERE	CustShipLoc=21

