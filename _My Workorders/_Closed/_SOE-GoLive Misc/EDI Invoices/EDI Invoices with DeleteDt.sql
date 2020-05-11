
--9 headers
select RefSONo as NV, InvoiceNo, OrderNo, NetSales, ARPostDt, DeleteDt, * from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null
order by RefSONo

--0 lines
select * from SODetailHist
where fSOHeaderHistID in
(select pSOHeaderHistID from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null)


--0 expenses
select * from SOExpenseHist
where fSOHeaderHistID in
(select pSOHeaderHistID from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null)


--0 comments
select * from SOCommentsHist
where fSOHeaderHistID in
(select pSOHeaderHistID from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null)



---------------------------------------------------------


--9 headers
select * from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null
order by RefSONo


delete from SOHeaderHist where DeleteDt <> '' and DeleteDt is not null







select * from CustomerContact