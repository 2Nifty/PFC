--12
select *
from SOHeaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799'

--292
select *
from SODetailHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')




--NONE
select *
from SOExpenseHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')



--24
select *
from SOCommentsHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')



--------------------------------------------



--292
delete
from SODetailHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')



--NONE
delete
from SOExpenseHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')



--24
delete
from SOCommentsHist
where fSOHeaderHistID in
(select pSOHeaderHistID --*
from SOheaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799')



--12
delete
from SOHeaderHist
where
InvoiceNo='69899' or
InvoiceNo='69900' or
InvoiceNo='69894' or
InvoiceNo='69898' or
InvoiceNo='69527' or
InvoiceNo='69528' or
InvoiceNo='69495' or
InvoiceNo='69524' or
InvoiceNo='69529' or
InvoiceNo='69765' or
InvoiceNo='69766' or
InvoiceNo='72799'