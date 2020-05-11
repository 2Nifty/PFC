select count(*) from SOheaderHist WHERE  SubType is not null 


--UPDATE Invoices
UPDATE	SOHeaderHist
SET	DiscountAmount = CASE	WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
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
	ChangeDt = GETDATE(),
	ChangeID = 'WO1504'
FROM	PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR
WHERE	SOHeaderHist.InvoiceNo = NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	SubType is not null



--UPDATE Credit Memos
UPDATE	SOHeaderHist
SET	DiscountAmount = CASE	WHEN [Payment Discount %] > 100 THEN ISNULL(NetSales, 0) * 100 * 0.01
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
	ChangeDt = GETDATE(),
	ChangeID = 'WO1504'
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Header] NVHDR
WHERE	SOHeaderHist.InvoiceNo = NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	SubType is not null
