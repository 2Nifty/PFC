select * from ItemAliasUploadqueue


update ItemAliasUploadqueue
set ItemNo='00901-3026-450'
where pItemAliasUpQueID=3855



--Find records with identical Cust & Item numbers
SELECT	Que.*, 'Duplicate PFC Item No' AS ExcReason
FROM	ItemAliasUploadQueue Que (NoLock) INNER JOIN
	(SELECT	OrganizationNo + AliasType + ItemNo as CustPlusItem,
		COUNT(OrganizationNo + AliasType + ItemNo) as RecCount
	 FROM	ItemAliasUploadQueue (NoLock)
	 Group By OrganizationNo + AliasType + ItemNo) tmp
ON	Que.OrganizationNo + Que.AliasType + Que.ItemNo = tmp.CustPlusItem
WHERE	tmp.RecCount > 1 AND
	Que.pItemAliasUpQueID NOT IN (SELECT pItemAliasUpQueID
				  FROM	 ItemAliasUploadQueue (NoLock)
				  WHERE	 ItemNo NOT IN (SELECT ItemNo FROM ItemMaster (NoLock)))






SELECT OrganizationNo, AliasType, OrganizationNo + AliasType as DelKey
from ItemAliasUploadQueue


SELECT	*
FROM	ItemAlias (NoLock)
WHERE	OrganizationNo + AliasType IN (SELECT DISTINCT OrganizationNo + AliasType FROM ItemAliasUploadQueue (NoLock))




--DELETE ItemAlias records for each Customer in the Upload Queue
DELETE
FROM	ItemAlias
WHERE	OrganizationNo + AliasType IN (SELECT DISTINCT OrganizationNo + AliasType FROM ItemAliasUploadQueue (NoLock))
