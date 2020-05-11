

--SELECT Invoices
SELECT     TOP 100 SOHeaderHist.InvoiceNo, SOHeaderHist.TotalCost, SOHeaderHist.ARPostDt, SODetailHist.LineNumber, SODetailHist.ItemNo, 
                      SODetailHist.QtyOrdered, SODetailHist.UnitCost
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE     (SOHeaderHist.TotalCost IS NOT NULL) AND (SODetailHist.UnitCost IS NOT NULL)
ORDER BY SOHeaderHist.InvoiceNo



select  top 100 SOHeaderHist.totalCost, SOHeaderHist.InvoiceNo,
	UnitCost, QtyOrdered, (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC)), QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC)), fSOHeaderHistID, InvoiceNo
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
--include the WHERE for YESTERDAY
where	[ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))
	AND SOHeaderHist.totalCost > 0
order by SOHeaderHist.InvoiceNo





--SELECT THE HEADER RECORDS
SELECT	totalCost, pSOHeaderHistID, ARPostDt, AvgCostExt.InvoiceNo, ExtAvgCost
FROM	(SELECT	InvoiceNo, fSOHeaderHistID, SUM(SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))) as ExtAvgCost
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--		PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
		AvgCostTbl.Branch = SODetailHist.IMLoc AND 
		AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
		AvgCostTbl.CurDate = ARPostDt
	 Group By InvoiceNo, fSOHeaderHistID)	AvgCostExt INNER JOIN
						SOHeaderHist on AvgCostExt.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
WHERE	AvgCostExt.InvoiceNo = SoHeaderHist.InvoiceNo
--include the WHERE for YESTERDAY
	AND [ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))


--SELECT THE DETAIL RECORDS
select  top 100 UnitCost, QtyOrdered, (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC)), QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC)), fSOHeaderHistID, InvoiceNo
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
--include the WHERE for YESTERDAY
where	[ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))



---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------



--UPDATE THE DETAIL RECORDS
UPDATE	SODetailHist
SET	UnitCost = (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))
FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
--include the WHERE for YESTERDAY
where	[ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))




--UPDATE THE HEADER RECORDS
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, fSOHeaderHistID, SUM(SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))) as ExtAvgCost
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--		PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
		AvgCostTbl.Branch = SODetailHist.IMLoc AND 
		AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
		AvgCostTbl.CurDate = ARPostDt
	 Group By InvoiceNo, fSOHeaderHistID)	AvgCostExt 
WHERE	AvgCostExt.InvoiceNo = SoHeaderHist.InvoiceNo
--include the WHERE for YESTERDAY
	AND [ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))



--UPDATE THE HEADER RECORDS  (**REVISED**) ... do the DETAIL first
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyOrdered * SODetailHist.UnitCost) as ExtAvgCost
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtCost 
WHERE	ExtCost.InvoiceNo = SoHeaderHist.InvoiceNo
--include the WHERE for YESTERDAY
	AND [ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))





----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------



SELECT	totalCost, pSOHeaderHistID, InvoiceNo, ARPostDt,
	SODetailHist.fSOHeaderHistID, SODetailHist.ItemNo, SODetailHist.LineNumber, SODetailHist.IMLoc, SODetailHist.QtyOrdered,
	ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC) as AvgCost,
	SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC)) as ExtAvgCost
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt




UPDATE	SOHeaderHist
SET	TotalCost = SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
where	[ARPostDt]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))






SELECT	totalCost, pSOHeaderHistID, InvoiceNo, ARPostDt,
	SODetailHist.fSOHeaderHistID, SODetailHist.ItemNo, SODetailHist.LineNumber, SODetailHist.IMLoc, SODetailHist.QtyOrdered,
	ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC) as AvgCost,
	SUM(SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))) as ExtAvgCost
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
Group By InvoiceNo




SELECT	totalCost, pSOHeaderHistID, ARPostDt,
	(SELECT	InvoiceNo, SUM(SODetailHist.QtyOrdered * (ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC))) as ExtAvgCost
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID LEFT OUTER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--		PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
		AvgCostTbl.Branch = SODetailHist.IMLoc AND 
		AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
		AvgCostTbl.CurDate = ARPostDt
	 Group By InvoiceNo)
FROM	SOHeaderHist 



----------------------------------------------------------------------------------------------------------------------

select count(*) from SODetailHist



SELECT	SODetailHist.ItemNo,
	SODetailHist.PostingDate,
	SODetailHist.IMLoc,
	ISNULL(NULLIF (EndAC, 0), BegAC) as AvgCost
FROM	PFCAC.dbo.[AvgCst_DailyHist] RIGHT OUTER JOIN
	SODetailHist ON Branch = SODetailHist.IMLoc AND 
	ItemNo = SODetailHist.ItemNo AND CurDate = SoDetailHist.PostingDate



OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFAC.dbo.[AvgCst_DailyHist]










select * from PFCAC.dbo.[AvgCst_DailyHist] where 
	PFCAC.dbo.[AvgCst_DailyHist].ItemNo = '00100-2862-021' AND
	PFCAC.dbo.[AvgCst_DailyHist].CurDate = ARPostDt



PFCAC.dbo.[AvgCst_DailyHist]



select * from SOHeaderHist




