select count(*) from SOHeader
select * from SOHeader where DiscountAmount is not null

select NetSales, * from PFCReports.dbo.SOHeader
select [Payment Discount %],ROUND([Payment Discount %],0,1) * 0.01,* from [Porteous$Sales Header] where [Payment Discount %] <> 0

select  RefSONo, [No_], NetSales, [Payment Discount %], ROUND([Payment Discount %],0,1) * 0.01 as DiscPct, 
	CASE WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
	     WHEN [Payment Discount %] < -100 THEN ISNULL(NetSales, 0) * -100 * 0.01
	     ELSE ISNULL(NetSales, 0) * ROUND([Payment Discount %],0,1) * 0.01
	END as DiscountAmount,
	[Pmt_ Discount Date], [Due Date]
from	PFCReports.dbo.SOHeader inner join
	[Porteous$Sales Header]
on	RefSONo = [No_] collate SQL_Latin1_General_CP1_CI_AS
WHERE	([Document Type] = 1 OR [Document Type] = 3 OR [Document Type] = 5) AND
	([No_] < 'SRA' OR [No_] > 'SRA1178701')



--UPDATE DiscountAmount
UPDATE	SOHeader
SET	DiscountAmount = CASE	WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
				WHEN [Payment Discount %] < -100 THEN ISNULL(NetSales, 0) * -100 * 0.01
				ELSE ISNULL(NetSales, 0) * ROUND([Payment Discount %],0,1) * 0.01
			 END
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header]
WHERE	RefSONo = [No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



---------------------------------------------------------------------------------------------------------------------------------------


select NetSales, * from PFCReports.dbo.SOHeaderHist
select [Payment Discount %],ROUND([Payment Discount %],0,1) * 0.01,* from [Porteous$Sales Invoice Header] where [Payment Discount %] <> 0
select [Payment Discount %],ROUND([Payment Discount %],0,1) * 0.01,* from [Porteous$Sales Cr_Memo Header] where [Payment Discount %] <> 0

select [Pmt_ Discount Date] as dt, * from [Porteous$Sales Invoice Header] where [Pmt_ Discount Date] < '1900-01-01'



select  InvoiceNo, [No_], NetSales, [Payment Discount %], ROUND([Payment Discount %],0,1) * 0.01 as DiscPct, 
	CASE WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
	     WHEN [Payment Discount %] < -100 THEN ISNULL(NetSales, 0) * -100 * 0.01
	     ELSE ISNULL(NetSales, 0) * ROUND([Payment Discount %],0,1) * 0.01
	END as DiscountAmount,
	[Pmt_ Discount Date], [Due Date]
from	PFCReports.dbo.SOHeaderHist inner join
	[Porteous$Sales Invoice Header]
on	InvoiceNo = [No_] collate SQL_Latin1_General_CP1_CI_AS




select  InvoiceNo, [No_], NetSales, [Payment Discount %], ROUND([Payment Discount %],0,1) * 0.01 as DiscPct, 
	CASE WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
	     WHEN [Payment Discount %] < -100 THEN ISNULL(NetSales, 0) * -100 * 0.01
	     ELSE ISNULL(NetSales, 0) * ROUND([Payment Discount %],0,1) * 0.01
	END as DiscountAmount,
	[Pmt_ Discount Date], [Due Date]
from	PFCReports.dbo.SOHeaderHist inner join
	[Porteous$Sales Cr_Memo Header]
on	InvoiceNo = [No_] collate SQL_Latin1_General_CP1_CI_AS




	DiscountAmount = CASE	WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
				WHEN [Payment Discount %] < -100 THEN ISNULL(NetSales, 0) * -100 * 0.01
				ELSE ISNULL(NetSales, 0) * ROUND([Payment Discount %],0,1) * 0.01
			 END,
	DiscountDt =	 CASE	WHEN NVHDR.[Pmt_ Discount Date] = '' OR NVHDR.[Pmt_ Discount Date] is null OR NVHDR.[Pmt_ Discount Date] < '1900-01-01'
				THEN ARPostDt
				ELSE NVHDR.[Pmt_ Discount Date]
			 END,
	ARDueDt =	 CASE	WHEN NVHDR.[Due Date] = '' OR NVHDR.[Due Date] is null OR NVHDR.[Due Date] < '1900-01-01'
				THEN ARPostDt
				ELSE NVHDR.[Due Date]
			 END,


select ARDueDt from PFCReports.dbo.SOHeaderHist where ARDueDt is not null


--------------------------------------------------------------------------------------------------------------------


--Update [Net Sales] - [Porteous$Sales Invoice Header]
UPDATE	SOHeaderHist
SET	NetSales = OrderExt
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.NetUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON
		NVHDR.[No_]=SoHeaderHist.InvoiceNo
	 WHERE	NVHDR.[ERP Upload Flag]=0
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SoHeaderHist.InvoiceNo


--Update [Net Sales] - [Porteous$Sales Cr_Memo Header]
UPDATE	SOHeaderHist
SET	NetSales = OrderExt
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.NetUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON
		NVHDR.[No_]=SoHeaderHist.InvoiceNo
	 WHERE	NVHDR.[ERP Upload Flag]=0
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SoHeaderHist.InvoiceNo