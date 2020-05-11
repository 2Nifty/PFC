select * from itemmaster where itemno in ('00020-2408-020','00020-2525-020')

select fitemmasterid, Location as LocID, StockInd, SalesVelocityCd as SVC, ReorderPoint as ROP, EntryID, EntryDt, ChangeID, ChangeDt
from itembranch where fitemmasterid in (3,370) order by fitemmasterid, location



--exec sp_columns itembranch


--delete from itembranch where entryid='tod-test'