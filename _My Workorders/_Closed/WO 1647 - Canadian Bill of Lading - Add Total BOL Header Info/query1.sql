select * from SOHeaderRel where OrderType='TO'
order by pSOHeaderRelID

exec pBOLRpt 'TODTEST'
select * from tLandedCostLines
order by [TO #]


SELECT	COUNT(DISTINCT [TO #]) AS TRFCount,
	COUNT([Item No_]) AS LineCount,
	SUM([Net Wgt Ext]) AS TotalNetWght
FROM	dbo.tLandedCostLines
WHERE	[BL No] = 'TODTEST'



SELECT	--COUNT(DISTINCT[OrderNo])
	NetWght, QtyOrdered, *
FROM	SOHeaderRel INNER JOIN
	SODetailRel
ON	pSOHeaderRelID=fSOHeaderRelID
WHERE	BOLNO = 'TODTEST'


delete from tLandedCostLines where CatLineCount=6


OrderNo in
('78134',
'78157',
'78244',
'78734',
'78747',
'79045',
'79066',
'79070',
'79151',
'79233'
)




UPDATE SOheaderRel
set BOLNO = 'TODTEST'
--WHERE BOLNO = 'TODTEST'
where OrderNo  in
('78134',
'78157',
'78244',
'78734',
'78747',
'79045',
'79066',
'79070',
'79151',
'79233'
)




UPDATE	dbo.tLandedCostLines
SET	TRFCount = Calc.TRFCount,
	LineCount = Calc.LineCount,
	TotalNetWght = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT OrderNo) AS TRFCount,
		COUNT(ItemNo) AS LineCount,
		SUM(NetWght * QtyOrdered) AS TotalNetWght
	 FROM	SOHeaderRel INNER JOIN
		SODetailRel
	 ON	pSOHeaderRelID = fSOHeaderRelID
	 WHERE	OrderType = 'TO' AND BOLNO = 'TODTEST') Calc



UPDATE	dbo.tLandedCostLines
SET	TRFCountLanded = Calc.TRFCount,
	LineCountLanded = Calc.LineCount,
	TotalNetWghtLanded = Calc.TotalNetWght
FROM	(SELECT	COUNT(DISTINCT [TO #]) AS TRFCount,
		COUNT([Item No_]) AS LineCount,
		SUM([Net Wgt Ext]) AS TotalNetWght
	 FROM	dbo.tLandedCostLines
	 WHERE	[BL No] = 'TODTEST') Calc


select top 1
TrfCount, LineCount, TotalNetWght, TrfCountLanded, LineCountLanded, TotalNetWghtLanded
from tLandedCostLines

exec sp_columns tLandedCostLines