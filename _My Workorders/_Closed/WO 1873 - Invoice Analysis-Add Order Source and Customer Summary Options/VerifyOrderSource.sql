

--Total: 256,787
--256,787-10,210 = 246,577
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc--, *
FROM	SOHeader (Nolock)
WHERE	isnull (OrderSource,'') = ''

--Portland: 10,210
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc, *
FROM	SOHeader (Nolock)
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')




--Total: 313,545
--313,545-10,103 = 303,442
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc--, *
FROM	SOHeaderRel (Nolock)
WHERE	isnull (OrderSource,'') = '' 

--Portland: 10,103
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc, *
FROM	SOHeaderRel (Nolock)
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')



--Total: 1,529,330
--1,529,330-59,085 = 1,470,245
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc--, *
FROM	SOHeaderHist (Nolock)
WHERE	isnull (OrderSource,'') = ''

--Portland: 59,085
SELECT	EntryId as Ent, OrderLoc as OrdLoc, OrderSource as OrdSrc, *
FROM	SOHeaderHist (Nolock)
WHERE	isnull (OrderSource,'') = '' and OrderLoc='03' and
	(EntryID='MCROWTHER' or EntryID='GBRANDERHORST')


--2570
select --count(*) 
	distinct OrderSource
from SOHeader (nolock) where isnull (OrderSource,'') <> '' and OrderSource <> 'MO' and OrderSource <> 'RQ'

--3450
select --count(*) 
	distinct OrderSource
from SOHeaderRel (nolock) where isnull (OrderSource,'') <> '' and OrderSource <> 'MO' and OrderSource <> 'RQ'

--4278
select --count(*) 
	distinct OrderSource
from SOHeaderHist (nolock) where isnull (OrderSource,'') <> '' and OrderSource <> 'MO' and OrderSource <> 'RQ'



select count(*) from SOHeader (nolock) where isnull (OrderSource,'') = ''

select count(*) from SOHeaderRel (nolock) where isnull (OrderSource,'') = ''

select count(*) from SOHeaderHist (nolock) where isnull (OrderSource,'') = ''