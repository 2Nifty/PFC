declare @BegDt DATETIME
set @BegDt='2008-09-02'

select CONVERT(DATETIME, '2008-09-02', 102)
select CONVERT(DATETIME, @BegDt-1, 102)



exec pACGetItemBranchDetail '00200-2400-401', '04'



exec pACGetItemBranchDetail_NEW '2008-09-02', '2009-08-29', '00200-2400-401', '04'