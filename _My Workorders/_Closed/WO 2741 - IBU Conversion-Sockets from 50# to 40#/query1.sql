
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------



drop table #tNewSKUList

--#tNewSKUList - All valid 040 SKUs
SELECT	DISTINCT
	IB.Location,
	LEFT(IM.ItemNo,11) + '020' as OldItem,
	IB.Location + LEFT(IM.ItemNo,11) + '020' as OldSKU,
	cast(0.0 as float) as OldSellStkQty,
	'     ' as OldSellStkUM,
	IM.ItemNo as NewItem,
	IB.Location + ItemNo as NewSKU,
	cast(0.0 as float) as NewSellStkQty,
	'     ' as NewSellStkUM
INTO	#tNewSKUList
FROM	ItemMaster IM (NoLock) INNER JOIN
	ItemBranch IB (NoLock)
ON	IM.pItemMasterID = IB.fItemMasterID
WHERE	RIGHT(IM.ItemNo,3) = '040' AND 
	((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
	 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))

select * from #tNewSKUList

------------------------------------------------------------

drop table #tNewIBUList

--#tNewIBUList - All valid 040 SKUs that have 020 usage
SELECT	tNewSKU.*
INTO	#tNewIBUList
FROM	#tNewSKUList tNewSKU (NoLock)
WHERE	tNewSKU.OldSKU in (SELECT DISTINCT IBU.Location + IBU.ItemNo as IBUSKU FROM ItemBranchUsage IBU (NoLock))


--UPDATE #tNewIBUList: Set OldSellStkQty & UM
UPDATE	#tNewIBUList
SET	OldSellStkQty = IM.SellStkUMQty,
	OldSellStkUM = IM.SellStkUM
FROM	ItemMaster IM (NoLock)
WHERE	#tNewIBUList.OldItem = IM.ItemNo

--UPDATE #tNewIBUList: Set NewSellStkQty & UM
UPDATE	#tNewIBUList
SET	NewSellStkQty = IM.SellStkUMQty,
	NewSellStkUM = IM.SellStkUM
FROM	ItemMaster IM (NoLock)
WHERE	#tNewIBUList.NewItem = IM.ItemNo


select * from #tNewIBUList
--where isnull(OldSellStkUM,'') <> '' and isnull(NewSellStkUM,'') <> '' and isnull(OldSellStkUM,'') = isnull(NewSellStkUM,'')

-------------------------------------------------------------------


select * from #tNewIBUList











--===================================================================================================================================



select	IM.ItemNo, UM.*
from	ItemMaster IM (NoLock) inner join
	ItemUM UM (NoLock)
on	IM.pItemMasterID = UM.fItemMasterID
WHERE	(RIGHT(IM.ItemNo,3) = '020' or RIGHT(IM.ItemNo,3) = '040') AND 
	((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
	 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))
order by IM.ItemNo


select * from ItemUM where fitemmasterid=139010



select * from ItemMaster where itemno='00900-0208-040'




SELECT	*
FROM	(SELECT	IM.pItemMasterID,
		IB.Location,
		IM.ItemNo as OldItem,
		0 as OldUOMQty,
		LEFT(IM.ItemNo,11) + '040' as NewItem,
		0 as NewUOMQty,
		IB.Location + LEFT(IM.ItemNo,11) + '040' as NewSKU
	 FROM	ItemMaster IM (NoLock) INNER JOIN
		ItemBranch IB (NoLock)
	 ON	IM.pItemMasterID = IB.fItemMasterID
	 WHERE	RIGHT(IM.ItemNo,3) = '020' AND 
		((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
		 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))) tSKU
WHERE	tSKU.NewSKU IN (SELECT NewSKU FROM #tNewSKUList)


select * from #tNewSKUList



SELECT	IB.Location, IM.ItemNo
FROM	ItemMaster IM (NoLock) INNER JOIN
	ItemBranch IB (NoLock)
ON	IM.pItemMasterID = IB.fItemMasterID
WHERE	RIGHT(IM.ItemNo,3) = '040' AND 
	((LEFT(IM.ItemNo,5) >= '00900' AND LEFT(IM.ItemNo,5) <= '00999') OR
	 (LEFT(IM.ItemNo,5) >= '20900' AND LEFT(IM.ItemNo,5) <= '20999'))






select * from ItemUM
where fitemmasterid=152816


