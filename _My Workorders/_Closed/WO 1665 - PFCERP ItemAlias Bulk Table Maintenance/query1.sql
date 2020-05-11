select * from ItemAlias
where OrganizationNo='002901' --and ( ItemNo='00200-2400-020' and AliasItemNo='12345' and AliasType='C')


truncate table ItemAliasUploadQueue
select * from ItemAliasUploadQueue



--update ItemAlias
--set DeleteDt = getdate()
--where pItemAliasID = 1321831

update ItemAlias
set --AliasWhseNo=null, AliasDesc=null, 
AliasType='C'
where OrganizationNo='002901'

--select * from ItemMaster where ItemNo='00200-2400-020'


--delete from ItemAlias where pItemAliasID=1321902





exec sp_columns ItemAliasUploadQueue


select * from ItemAlias
where OrganizationNo='002901'

--excel columns
select	ItemNo AS Item,
	AliasItemNo AS XRef,
	AliasWhseNo,
	AliasDesc,
	AliasType,
	UOM,
	CustBinLoc,
	CustClassCd,
	CustomerUPC,
	OrganizationNo
from	ItemAlias
where	OrganizationNo='002901'


SELECT ItemNo AS Item, AliasItemNo AS XRef, AliasWhseNo, AliasDesc, AliasType, UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo FROM ItemAlias WHERE OrganizationNo='
002901'




update ItemAliasUploadQueue
set ItemNo='00200-2400-401'--, --AliasDesc='test', AliasWhseNo='test'

where pItemAliasUpQueID=26




-----------------------------------------------------------
--Batch file verification


select * from ItemAliasUploadQueue



--Find records with bad items
SELECT	Que.*, 'Invalid PFC Item No' AS ExcReason
FROM	ItemAliasUploadQueue Que
WHERE	Que.ItemNo NOT IN (SELECT ItemNo FROM ItemMaster)


--Find all records where Cust, Item are identical
SELECT	Que.*
FROM	ItemAliasUploadQueue Que INNER JOIN
	(SELECT	OrganizationNo + ItemNo as CustPlusItem, COUNT(OrganizationNo + ItemNo) as RecCount
	 FROM	ItemAliasUploadQueue
	 Group By OrganizationNo + ItemNo) tmp
ON	Que.OrganizationNo + Que.ItemNo = tmp.CustPlusItem
WHERE	tmp.RecCount > 1 AND
	pItemAliasUpQueID NOT IN (SELECT pItemAliasUpQueID
				  FROM	 ItemAliasUploadQueue
				  WHERE	 ItemNo NOT IN (SELECT ItemNo FROM ItemMaster))


select * from tItemAliasUploadExceptions

update tItemAliasUploadExceptions set EntryID='tod' where ItemNo='00200-2400-999'

SELECT ExcReason AS Error, ItemNo AS Item, AliasItemNo AS XRef, AliasWhseNo, AliasDesc, AliasType, UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo, EntryID, EntryDt
FROM	tItemAliasUploadExceptions

SELECT	ExcReason AS Error,
	ItemNo AS Item,
	AliasItemNo AS XRef,
	AliasWhseNo,
	AliasDesc,
	AliasType,
	UOM,
	CustBinLoc,
	CustClassCd,
	CustomerUPC,
	OrganizationNo,
	EntryID,
	EntryDt
FROM	tItemAliasUploadExceptions


--DELETE exceptions from Queue
DELETE
FROM	ItemAliasUploadQueue
WHERE	pItemAliasUpQueID IN (SELECT pItemAliasUpQueID FROM tItemAliasUploadExceptions)



SELECT	*
FROM	ItemAliasUploadQueue
WHERE	exists

(SELECT	DISTINCT
	ItemNo,
	AliasItemNo,
	OrganizationNo
FROM	ItemAliasUploadQueue)

select * from tItemAliasUploadQueue



--DELETE ItamAlias records for each Customer in the Upload Queue
DELETE
FROM	ItemAlias
WHERE	OrganizationNo IN (SELECT DISTINCT OrganizationNo FROM ItemAliasUploadQueue)


select * from ItemAlias where OrganizationNo='002901' --order by pItemAliasID
order by ItemNo, AliasItemNo

select * from ItemAliasDeletes
--where OrganizationNo='002901' 
order by ItemNo, AliasItemNo


truncate table ItemAliasDeletes


exec sp_columns ItemAlias

select max (pItemAliasID) from ItemAlias



--update securityUsers set EmailAddress='tdixon@porteousfastener.com' where Username='tod'

select * from securityUsers where username='tod'
SELECT UserName, EmailAddress FROM SecurityUsers WHERE UserName='tod'







SELECT	*
FROM	ItemAlias
WHERE	OrganizationNo IN (SELECT DISTINCT OrganizationNo FROM ItemAliasUploadQueue)



select * from ItemAliasUploadQueue
--where OrganizationNo='002901' 
order by ItemNo, AliasItemNo

update ItemAlias
set	ItemNo='00280-1000-501',
	AliasItemNo='002801000500',
	AliasDesc='d002801000500',
	AliasWhseNo='w002801000500',
	UOM='PC',
	CustBinLoc='b002801000500',
	CustClassCd='CL0',
	CustomerUpc='UPC0'
where pItemaliasID=1369215

delete from ItemAlias where pItemaliasID=1369216


update itemAlias
set CustBinLoc='002002400401'
where CustBinLoc='b002002400401'

exec sp_columns Itemalias


select SellStkUm, * from ItemMaster where ItemNo='00280-1000-500'


select SellStkUm, * from ItemMaster where SellStkUM<>'CT' and SellStkUM <>'BX'

select * from CustomerMaster where CustNo='002901'