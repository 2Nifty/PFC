UPDATE	SOHeaderHist
SET	TotalOrder = OrderExt
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyOrdered * SODetailHist.ListUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SoHeaderHist.InvoiceNo
--include the WHERE for YESTERDAY
	AND [ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))
