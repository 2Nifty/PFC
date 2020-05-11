select * from tWO778_SODetailHist order by fSOHeaderHistID

select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist
where RefSONo='SO3107844'

update tWO778_SODetailHist 
set fSOHeaderHistID=1314920
where RefSONo='SO3107844'


select * from tWO778_SOExpenseHist


select RefSONo, * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist
where pSOHeaderHistID in
(select fSOHeaderHistID from tWO778_SODetailHist)


update  tWO778_SODetailHist set fSOHeaderHistID=null


update tWO778_SODetailHist
set fSOHeaderHistID = NewSO.[NewID]
from (SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID, SO.RefSONo AS OrigSO
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo) NewSO
WHERE	NewSO.OrigSO = tWO778_SODetailHist.RefSONo




UPDATE	tWO778_SODetailHist
SET	fSOHeaderHistID = NewSO.[NewID]
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID, RefSONo
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo) NewSO
WHERE	NewSO.[NewID] = fSOHeaderHistID


UPDATE	tWO778_SOExpenseHist
SET	fSOHeaderHistID = NewSO.OrigID
FROM	(SELECT SO.pSOHeaderHistID AS [NewID], tSO.pSOHeaderHistID AS OrigID
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SO INNER JOIN
		tWO778_SOHeaderHist tSO
	 ON	SO.RefSONo = tSO.RefSONo) NewSO
WHERE	NewSO.[NewID] = fSOHeaderHistID




select * from tWO778_SOHeaderHist
select RefSONo AS NV, * from tWO778_SODetailHist
--where RefSONo='SO3107844'
order by RefSONo

update tWO778_SODetailHist
set RefSONo='SO3107844'
from SOHeaderHist erp
where tWO778_SODetailHist.RefSONo is null


update tWO778_SODetailHist
set RefSONo=erp.RefSONo
from SOHeaderHist erp
where fSOHeaderHistID=pSOHeaderHistID



select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist
where RefSONo='SO3107844'




