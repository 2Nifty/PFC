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






--Find records with identical Cust & Alias Item numbers
SELECT	Que.*, 'Duplicate AliasItem No' AS ExcReason
FROM	ItemAliasUploadQueue Que (NoLock) INNER JOIN
	(SELECT	OrganizationNo + AliasType + AliasItemNo as CustPlusItem,
		COUNT(OrganizationNo + AliasType + AliasItemNo) as RecCount
	 FROM	ItemAliasUploadQueue (NoLock)
	 Group By OrganizationNo + AliasType + AliasItemNo) tmp
ON	Que.OrganizationNo + Que.AliasType + Que.AliasItemNo = tmp.CustPlusItem
WHERE	tmp.RecCount > 1 AND
	Que.pItemAliasUpQueID NOT IN (SELECT pItemAliasUpQueID
				  FROM	 ItemAliasUploadQueue (NoLock)
				  WHERE	 ItemNo NOT IN (SELECT ItemNo FROM ItemMaster (NoLock)))






--Find records with identical Cust & Alias Item numbers
SELECT	Que.*, 'Duplicate Record - 1 record added' AS ExcReason
FROM	ItemAliasUploadQueue Que (NoLock) INNER JOIN
	(SELECT	OrganizationNo + ItemNo + AliasType + AliasItemNo as CustPlusItem,
		COUNT(OrganizationNo + ItemNo + AliasType + AliasItemNo) as RecCount
	 FROM	ItemAliasUploadQueue (NoLock)
	 Group By OrganizationNo + ItemNo + AliasType + AliasItemNo) tmp
ON	Que.OrganizationNo + Que.ItemNo + Que.AliasType + Que.AliasItemNo = tmp.CustPlusItem
WHERE	tmp.RecCount > 1 AND
	Que.pItemAliasUpQueID NOT IN (SELECT pItemAliasUpQueID
				  FROM	 ItemAliasUploadQueue (NoLock)
				  WHERE	 ItemNo NOT IN (SELECT ItemNo FROM ItemMaster (NoLock)))




select * from ItemAliasUploadQueue

--10645
SELECT	DISTINCT
	ItemNo,
	OrganizationNo,
	AliasItemNo,
	AliasDesc,
	AliasType,
	AliasWhseNo,
	UOM,
	CustBinLoc,
	CustClassCd,
	CustomerUPC,
	EntryID,
	getdate() as EntryDt
FROM	ItemAliasUploadQueue




select distinct OrganizationNo from ItemAliasUploadQueue


select * from Itemalias where OrganizationNo='059801'

