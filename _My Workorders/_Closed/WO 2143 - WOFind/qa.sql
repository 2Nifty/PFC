
--Exec [pWOFind] 'crojas', '', '', '', '2010-Dec-01' ,'2010-Dec-03'
--Exec [pWOFind] 'crojas', '', '', '', '' ,''
--Exec [pWOFind] '', '', '', '', '' ,''


select distinct changeid from POHeader POH
WHERE	--isnull(POH.DeleteDt,'') = '' AND isnull(POD.DeleteDt,'') = '' AND
	POH.POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType') 


update POHeader set ChangeID=EntryID 
where ChangeID='dbo'
--where pPOHeaderID = 11179


select * from POHeader where ChangeID='dbo'


--------------------------------------------------------------------------------------


declare @StartDt datetime,
	@EndDt datetime


set @StartDt = '2009-Dec-03'
set @EndDt = '2010-Dec-03'
set @EndDt = @EndDt + ' 23:59:59.59'

select @StartDt as Strdt, @EndDt as EndDt

select POH.EntryId as ID, POH.ChangeId, POH.OrderDt, *
FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID
WHERE	--isnull(POH.DeleteDt,'') = '' AND isnull(POD.DeleteDt,'') = '' AND
	POH.POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType') and
	isnull(POH.OrderDt,'') >= CAST(@StartDt as DATETIME) AND 
	isnull(POH.OrderDt,'') <= CAST(@EndDt as DATETIME) 
--and CAST (FLOOR (CAST (POH.OrderDt AS FLOAT)) AS DATETIME) = 
and isnull(POH.EntryID,'') <> '' --and  isnull(POH.ChangeID,'dbo') <> 'dbo'
order by POH.EntryID
