select RefSONo AS NV, InvoiceNo, * from tWO778_SOHeaderHist
order by RefSONo


select DeleteDt, RefSONo AS NV, InvoiceNo, ARPostDt, NetSales, OrderNo, SellToCustNo, SellToCustName, * from SOHeaderHist
where RefSONo in (Select RefSONo from tWO778_SOHeaderHist) and left(InvoiceNo,2)<>'IP'
and
RefSONo <>'SO3107835' and
RefSONo <>'SO3107833' and
RefSONo <>'SO3107834' and
RefSONo <>'SO3107841' and
RefSONo <>'SO3107840' and
RefSONo <>'SO3107836' and
RefSONo <>'SO3107837' and
RefSONo <>'SO3107842' and
RefSONo <>'SO3107820' and
RefSONo <>'SO3107800' and
RefSONo <>'SO3107798' and
RefSONo <>'SO3107799'
order by RefSONo--pSOHeaderHistID



select * from SODetailHist where fSOHeaderHistID=1309816



select * from tWO778_SODetailHist
order by fSOHeaderHistID, LineNumber



select distinct  fSOHeaderHistID, LineNumber from tWO778_SODetailHist
order by fSOHeaderHistID, LineNumber


select pSOHeaderHistID, RefSONo AS NV, InvoiceNo, * from SOHeaderHist
where RefSONo in (Select RefSONo from tWO778_SOHeaderHist) and left(InvoiceNo,2)<>'IP'
order by pSOHeaderHistID




select * from tWO778_SODetailHist
where fSOHeaderHistID in (select pSOHeaderHistID from SOHeaderHist
where RefSONo in (Select RefSONo from tWO778_SOHeaderHist) and left(InvoiceNo,2)<>'IP')
order by fSOHeaderHistID




--select getdate()-12

select RefSONo AS NV, InvoiceNo, OrderNo, ARPostDt, SellToCustNo, SellToCustName, * from SOHeaderHist
where ARPostDt >  getdate()-13 and left(InvoiceNo,2)='IP'
order by RefSONo 




--ERP Invoices
select	RefSONo AS NV, InvoiceNo, OrderNo, ARPostDt, SellToCustNo, SellToCustName, NetSales, * from SOHeaderHist
where 	RefSONo in (select RefSONo from SOHeaderHist
		    where ARPostDt >  getdate()-13 and left(InvoiceNo,2)='IP') and
	left(InvoiceNo,2)<>'IP'
order by RefSONo, InvoiceNo



--NV Invoices
select	RefSONo AS NV, InvoiceNo, ARPostDt, NetSales, SellToCustNo, SellToCustName, * from SOHeaderHist
where 	RefSONo in (select RefSONo from SOHeaderHist
		    where ARPostDt >  getdate()-13 and left(InvoiceNo,2)<>'IP') and
	left(InvoiceNo,2)='IP'
order by RefSONo, InvoiceNo



select distinct fSOHeaderHistID from SODetailHist
where fSOHeaderHistID=1306499 or
fSOHeaderHistID=1306498 or
fSOHeaderHistID=1306497 or
fSOHeaderHistID=1306496 or
fSOHeaderHistID=1306495 or
fSOHeaderHistID=1306494 or
fSOHeaderHistID=1306486 or
fSOHeaderHistID=1306485 or
fSOHeaderHistID=1306484 or
fSOHeaderHistID=1314925 or
fSOHeaderHistID=1314926 or
fSOHeaderHistID=1314924 or
fSOHeaderHistID=1314923 or
fSOHeaderHistID=1309004 or
fSOHeaderHistID=1314913 or
fSOHeaderHistID=1314914 or
fSOHeaderHistID=1314911 or
fSOHeaderHistID=1314917 or
fSOHeaderHistID=1314918 or
fSOHeaderHistID=1309003 or
fSOHeaderHistID=1314916 or
fSOHeaderHistID=1314915 or
fSOHeaderHistID=1314919 or
fSOHeaderHistID=1309002
order by fSOHeaderHistID



select * from tWO778_SOHeaderHist


------------------------------------------------------


SELECT	RefSONo, InvoiceNo AS [ERP InvoiceNo], OrderNo AS [ERP OrderNo], NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
FROM	SOHeaderHist
WHERE	RefSONo in (SELECT	RefSONo
		    FROM	tWO778_SOHeaderHist) AND
	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP'






SELECT	ERP.*, NV.InvoiceNo AS [NV InvoiceNo], NV.NetSales AS [NV NetSales], NV.ARPostDt AS [NV ARPostDt], NV.DeleteDt AS [NV DeleteDt], NV.SellToCustNo, NV.SellToCustName
FROM	tWO778_SOHeaderHist NV INNER JOIN
(SELECT	RefSONo, InvoiceNo AS [ERP InvoiceNo], OrderNo AS [ERP OrderNo], NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist
 WHERE	RefSONo in (SELECT	RefSONo
		    FROM	tWO778_SOHeaderHist) AND
	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP') ERP
ON	NV.RefSONo = ERP.RefSONo
WHERE	NV.RefSONo in (SELECT	RefSONo
		       FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist 
		       WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP')
Order By ERP.RefSONo








SELECT	ERP.*, NV.InvoiceNo AS [NV InvoiceNo], NV.NetSales AS [NV NetSales], NV.ARPostDt AS [NV ARPostDt], NV.DeleteDt AS [NV DeleteDt], NV.SellToCustNo, NV.SellToCustName
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.tWO778_SOHeaderHist NV INNER JOIN
(SELECT	RefSONo, InvoiceNo AS [ERP InvoiceNo], OrderNo AS [ERP OrderNo], NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
 FROM	SOHeaderHist
 WHERE	RefSONo in (SELECT	RefSONo
		    FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.tWO778_SOHeaderHist) AND
	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP') ERP
ON	NV.RefSONo = ERP.RefSONo
WHERE	NV.RefSONo in (SELECT	RefSONo
		       FROM	SOHeaderHist 
		       WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP')
Order By ERP.RefSONo





IF ((SELECT COUNT(*)
     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.tWO778_SOHeaderHist NV INNER JOIN
     (SELECT	RefSONo, InvoiceNo AS [ERP InvoiceNo], OrderNo AS [ERP OrderNo], NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
      FROM	SOHeaderHist
      WHERE	RefSONo in (SELECT	RefSONo
			    FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.tWO778_SOHeaderHist) AND
		LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP') ERP
     ON		NV.RefSONo = ERP.RefSONo
     WHERE	NV.RefSONo in (SELECT	RefSONo
			       FROM	SOHeaderHist 
			       WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP')) > 0)

   BEGIN
	PRINT 'Rejections found'
	Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','jtoves@porteousfastener.com, crojas@porteousfastener.com, twhite@porteousfastener.com',
					   'WO1341 - ERP EDI Invoice Rejections',
					   'Attached please find a list of NV EDI Invoices that were rejected due to duplicate ERP Invoices already posted.',
					   '\\pfcfiles\userdb\WO1341_ERP_Rejections.csv'
   END
ELSE 
   BEGIN
	PRINT 'No rejections found'
   END




-------------------------------------------------------




SELECT	*
FROM	tWO778_SOHeaderHist
WHERE	RefSONo  not in (SELECT	RefSONo
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist
			WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP')





UPDATE	tWO778_SODetailHist
SET	fSOHeaderHistID = NewSO.[NewID]
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo
	 WHERE	LEFT(SO.InvoiceNo,2) = 'IP') NewSO
WHERE	NewSO.OrigID = fSOHeaderHistID
go

UPDATE	tWO778_SODetailHist
SET	fSOHeaderHistID = null
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo
	 WHERE	LEFT(SO.InvoiceNo,2) <> 'IP') NewSO
WHERE	NewSO.OrigID = fSOHeaderHistID
go


UPDATE	tWO778_SOExpenseHist
SET	fSOHeaderHistID = NewSO.[NewID]
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo
	 WHERE	LEFT(SO.InvoiceNo,2) = 'IP') NewSO
WHERE	NewSO.OrigID = fSOHeaderHistID
go

UPDATE	tWO778_SOExpenseHist
SET	fSOHeaderHistID = null
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo
	 WHERE	LEFT(SO.InvoiceNo,2) <> 'IP') NewSO
WHERE	NewSO.OrigID = fSOHeaderHistID
go




SELECT	*
FROM	tWO778_SOExpenseHist
WHERE	fSOHeaderHistID is not null