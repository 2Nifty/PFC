
update 	SOHeaderHist
SET	TotalCost2=null
where SubType is not null


--UPDATE TotalCost2  [2 minutes - 1171032 rows]
UPDATE	SOHeaderHist
SET	TotalCost2 = OrderExt2
FROM	(SELECT	InvoiceNo,
		SUM(SODetailHist.QtyShipped * SODetailHist.UnitCost2) as OrderExt2
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist
	 ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SOHeaderHist.InvoiceNo

and SubType is not null


-----------------------------------------------------------------------------


update 	SOHeaderHist
SET	TotalOrder=null
where SubType is not null

--UPDATE NonTaxAmt  [2 minutes - 1171032 rows]
UPDATE	SOHeaderHist
SET	NonTaxAmt = OrderExt
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.NetUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist
	 ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SOHeaderHist.InvoiceNo
and SubType is not null

--UPDATE TotalOrder  [< 1 minute - 1177765 rows]
UPDATE	SOHeaderHist
SET	TotalOrder = ISNULL(TaxSum,0) + ISNULL(NonTaxAmt,0) + ISNULL(TaxExpAmt,0) + ISNULL(NonTaxExpAmt,0) + ISNULL(TaxAmt,0)
FROM	SOHeaderHist
where SubType is not null


----------------------------------------------------------------------------------------------------------------------

select count(*) from SOHeaderHist where SubType is not null




select NetSales, RefSoNo, * from PFCReports.dbo.SOHeaderHist where --NetSales is null and 
TotalCost2 = 602658.61320000000000000000
and SubType is not null


select InvoiceNo, NonTaxAmt from PFCReports.dbo.SOHeaderHist where NonTaxAmt is not null 

order by TotalCost2





select TotalCost2 from PFCReports.dbo.SOHeaderHist 


select TotalCost2, InvoiceNo, * from PFCReports.dbo.SOHeaderHist where InvoiceNo='' 
Select [Order No_],* from [Porteous$Sales Invoice Header] where [Order No_]=''


select distinct TotalCost2, InvoiceNo, SODetailHist.*
from PFCReports.dbo.SODetailHist SODetailHist inner join
PFCReports.dbo.SOHeaderHist SOHeaderHist on SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
where InvoiceNo=''




select RefSONo, * from PFCReports.dbo.SOHeader where RefSONo='' 


select distinct TotalCost2, RefSONo, SODetail.*
from PFCReports.dbo.SODetail SODetail inner join
PFCReports.dbo.SOHeader SOHeader on SODetail.fSOHeaderID = SOHeader.pSOHeaderID
where RefSONo=''





SELECT	InvoiceNo,
		SODetailHist.QtyShipped, SODetailHist.UnitCost2
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist
	 ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 where InvoiceNo='IP1967640' or InvoiceNo='IP2571634'

