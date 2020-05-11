
select SOHeaderHist.InvoiceNo, SOHeaderHist.ARPostDt, SODetailHist.LineNumber, SODetailHist.ItemNo, SODetailHist.IMLoc, NVHDR.[ERP Upload Flag],
	AvgCostTbl.Branch,
	AvgCostTbl.ItemNo,AvgCostTbl.CurDate
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON
	NVHDR.[No_]=SoHeaderHist.InvoiceNo LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
WHERE NVHDR.[ERP Upload Flag]=0


select SOHeaderHist.InvoiceNo, SOHeaderHist.ARPostDt, SODetailHist.LineNumber, SODetailHist.ItemNo, SODetailHist.IMLoc, NVHDR.[ERP Upload Flag],
	AvgCostTbl.Branch,
	AvgCostTbl.ItemNo,AvgCostTbl.CurDate
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON
	NVHDR.[No_]=SoHeaderHist.InvoiceNo LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
WHERE NVHDR.[ERP Upload Flag]=0





--UPDATE THE HEADER RECORDS
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.UnitCost) as ExtAvgCost
	FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON
		NVHDR.[No_]=SoHeaderHist.InvoiceNo
		Group By InvoiceNo) ExtCost 
WHERE	ExtCost.InvoiceNo = SoHeaderHist.InvoiceNo AND NVHDR.[ERP Upload Flag]=0








--UPDATE THE DETAIL RECORDS [Porteous$Sales Invoice Header]
UPDATE	SODetailHist
SET	UnitCost = ISNULL(NULLIF(ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC),0), SODetailHist.UnitCost)
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON
	NVHDR.[No_]=SoHeaderHist.InvoiceNo LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
WHERE NVHDR.[ERP Upload Flag]=0


--UPDATE THE DETAIL RECORDS [Porteous$Sales Cr_Memo Header]
UPDATE	SODetailHist
SET	UnitCost = ISNULL(NULLIF(ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC),0), SODetailHist.UnitCost)
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON
	NVHDR.[No_]=SoHeaderHist.InvoiceNo LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
WHERE NVHDR.[ERP Upload Flag]=0


--UPDATE THE HEADER RECORDS [Porteous$Sales Invoice Header]
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.UnitCost) as ExtAvgCost
	FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON
		NVHDR.[No_]=SoHeaderHist.InvoiceNo AND NVHDR.[ERP Upload Flag]=0
		Group By InvoiceNo) ExtCost 
WHERE	ExtCost.InvoiceNo = SoHeaderHist.InvoiceNo


--UPDATE THE HEADER RECORDS [Porteous$Sales Cr_Memo Header]
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyShipped * SODetailHist.UnitCost) as ExtAvgCost
	FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON
		NVHDR.[No_]=SoHeaderHist.InvoiceNo AND NVHDR.[ERP Upload Flag]=0
		Group By InvoiceNo) ExtCost 
WHERE	ExtCost.InvoiceNo = SoHeaderHist.InvoiceNo

