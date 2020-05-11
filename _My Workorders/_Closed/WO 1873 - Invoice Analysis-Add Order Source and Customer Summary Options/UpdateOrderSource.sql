--select OrderSource as Src, * from SOHeaderHist where isnull(OrderSource,'')=''


--Production: 10,210 - Less than 1 minute
--Update SOHeader OrderSource = 'MO' for Portland Orders entered by Mike or Garrett
--Tested against DEVPERP - Less than 1 minute (2,816 row(s) affected)
UPDATE	SOHeader
SET	OrderSource = 'MO'
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')

--Production: 10,103 - Less than 1 minute
--Update SOHeaderRel OrderSource = 'MO' for Portland Orders entered by Mike or Garrett
--Tested against DEVPERP - Less than 1 minute (2,813 row(s) affected)
UPDATE	SOHeaderRel
SET	OrderSource = 'MO'
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')

--Production: 59,085 - Less than 1 minute
--Update SOHeaderHist OrderSource = 'MO' for Portland Orders entered by Mike or Garrett
--Tested against DEVPERP - About 2 minutes (51,904 row(s) affected)
UPDATE	SOHeaderHist
SET	OrderSource = 'MO'
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')


--Production: 246,577 - Less than 1 minute
--Update SOHeader OrderSource = 'RQ'
--Tested against DEVPERP - Less than 1 minute (70,137 row(s) affected)
UPDATE	SOHeader
SET	OrderSource = 'RQ'
WHERE	isnull (OrderSource,'') = ''

--Production: 303,442 - Less than 1 minute
--Update SOHeaderRel OrderSource = 'RQ'
--Tested against DEVPERP - Less than 1 minute (80,265 row(s) affected)
UPDATE	SOHeaderRel
SET	OrderSource = 'RQ'
WHERE	isnull (OrderSource,'') = ''

--Production: 1,470,245 - Less than 1 minute
--Update SOHeaderHist OrderSource = 'RQ'
--Tested against DEVPERP - About 3 minutes (1,278,363 row(s) affected)
UPDATE	SOHeaderHist
SET	OrderSource = 'RQ'
WHERE	isnull (OrderSource,'') = '' 





