
select POOrderNO from POHeaderHist where isnull(CompleteDt,'') = ''

and POOrderNO in (select POOrderNo from POHeader)

select count(*) from POHeader
select count(*) from POHeader where isnull(CompleteDt,'') = ''
select count(*) from POHeader where isnull(CompleteDt,'') <> ''

select count(*) from POHeaderHist
select count(*) from POHeaderHist where isnull(CompleteDt,'') = ''
select count(*) from POHeaderHist where isnull(CompleteDt,'') <> ''


select CompleteDt, * from POHeaderHist where isnull(CompleteDt,'') <> '' order by CompleteDt
select * from PODetailHist where isnull(CompleteDt,'') = ''

-----------------------------------------------------------------------

select count(*) from PODetailHist
where fPOHeaderHistID not in (select distinct pPOHeaderHistID from POHeaderHist)

select count(*) from POExpenseHist
where fPOHeaderID not in (select distinct pPOHeaderHistID from POHeaderHist)

select count(*) from POCommentsHist
where fPOHeaderHistID not in (select distinct pPOHeaderHistID from POHeaderHist)

select  count(*) from POHeaderHist
where	pPOHeaderHistid not in (select distinct fPOHeaderHistID from PODetailHist) and 
		pPOHeaderHistid not in (select distinct fPOHeaderID from POExpenseHist)


--------------------------------------------------------------------------

select count(*) from PODetail
where fPOHeaderID not in (select distinct pPOHeaderID from POHeader)

select count(*) from POExpense
where fPOHeaderID not in (select distinct pPOHeaderID from POHeader)

select count(*) from POComments
where fPOHeaderID not in (select distinct pPOHeaderID from POHeader)

select count(*) from POHeader
where	pPOHeaderid not in (select distinct fPOHeaderID from PODetail) and 
		pPOHeaderid not in (select distinct fPOHeaderID from POExpense)

-------------------------------------------------------------------


select QtyOrdered, QtyReceived, QtyOrdered-QtyReceived as Outstanding, HD1.POOrderNo, DT1.*
from POHeader HD1 inner join PODetail DT1 on pPOHeaderID = fPOHeaderid
where HD1.POOrderno in
(
--List of POs in open table also in hist table
select distinct HD2.POOrderNo from POHeader HD2
where HD2.POOrderNo in (select distinct Hist.POOrderNo from POHeaderHist Hist)
)
--and QtyOrdered-QtyReceived > 0
order by HD1.POOrderno, DT1.POLineNo

-------------------------------------------------------------------

select Dtl.QtyOrdered, Dtl.QtyReceived, Dtl.* from POHeaderHist Hdr inner join PODetailHist Dtl on pPOHeaderHistID = fPOHeaderHistID

where Hdr.POOrderno in ('10083002','10122331')



select Dtl.QtyOrdered, Dtl.QtyReceived, Dtl.* from POHeader Hdr inner join PODetail Dtl on pPOHeaderID = fPOHeaderID
where Hdr.POOrderno in ('10083002','10122331')




-------------------------------------------------------------------

select * from POHeader where POOrderNo in ('10083002','10122331')

select * from POExpense where fPOHeaderID in (981,593)


-------------------------------------------------------------------


--Total Headers: 38078
select count(*) from POHeader

--Open Headers: 3084 (25909 - 22483 = 3426) - 3133
select count(*) from POHeader where isnull(CompleteDt,'') = ''

--Complete Headers: 34994
select count(*) from POHeader where isnull(CompleteDt,'') <> ''



--Total Lines: 470693
select count(*) from POHeader inner join PODetail on pPOHeaderID = fPOHeaderid

--Open Lines: 62126 (20828) - 62280
select count(*) from POHeader inner join PODetail on pPOHeaderID = fPOHeaderid where isnull(POHeader.CompleteDt,'') = ''

--Complete Lines: 408567
select count(*) from POHeader inner join PODetail on pPOHeaderID = fPOHeaderid where isnull(POHeader.CompleteDt,'') <> ''



--Total Exp: 96
select count(*) from POHeader inner join POExpense on pPOHeaderID = fPOHeaderid

--Open Exp: 8 - 63
select count(*) from POHeader inner join POExpense on pPOHeaderID = fPOHeaderid where isnull(CompleteDt,'') = ''

--Complete Exp: 88
select count(*) from POHeader inner join POExpense on pPOHeaderID = fPOHeaderid where isnull(CompleteDt,'') <> ''



--Total Cmt: 220079
select count(*) from POHeader inner join POcomments on pPOHeaderID = fPOHeaderid

--Open Cmt: 17415 - 19610
select count(*) from POHeader inner join POcomments on pPOHeaderID = fPOHeaderid where isnull(CompleteDt,'') = ''

--Complete Cmt: 202664
select count(*) from POHeader inner join POcomments on pPOHeaderID = fPOHeaderid where isnull(CompleteDt,'') <> ''

--------------------------------------------------


-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

drop table #tHistID

select DISTINCT pPOHeaderHistID 
into #tHistID
from POHeaderHist
where POOrderNo in (select distinct POOrderNo from POHeader)
go
select * from #tHistID




--(62277 row(s) affected)
--(61 row(s) affected)
--(19564 row(s) affected)
--(3131 row(s) affected)

DELETE
FROM	PODetailHist
WHERE	fPOHeaderHistID in 
		(select * from #tHistID)
GO

DELETE
FROM	POExpenseHist
WHERE	fPOHeaderID in 
		(select * from #tHistID)
GO

DELETE
FROM	POCommentsHist
WHERE	fPOHeaderHistID in 
		(select * from #tHistID)
GO

DELETE
FROM	POHeaderHist
WHERE	pPOHeaderHistID in 
		(select * from #tHistID)
GO


