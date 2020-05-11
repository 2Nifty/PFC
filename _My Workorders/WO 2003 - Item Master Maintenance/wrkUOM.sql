
select EntryID, EntryDt, ChangeID, ChangeDt, DeleteID, DeleteDt, * from ItemMaster IM
where	IM.ItemNo in ('00200-2600-401','00050-3022-130','00123-0004-005')
--where	IM.ItemNo in ('00200-4200-401','00123-0004-005')

select	IM.pItemMasterID, IM.ItemNo,  UOM.*
from	ItemMaster (NoLock) IM inner join
		ItemUM (NoLock) UOM
ON		IM.pItemMasterID = UOM.fItemMasterID
where	IM.ItemNo in ('00200-2600-401','00050-3022-130','00123-0004-005')
--where	IM.ItemNo in ('00200-4200-401','00123-0004-005')

update ItemUM set Deletedt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), deleteid='tod-test'
where fitemmasterid=53914 and UM='FT'

--delete from ItemUM where EntryID='tod'


select distinct itemno from itemmaster where pitemmasterid not in (select distinct fitemmasterid from itemum)


select * from ItemUM


			INSERT INTO	ItemUM
						(fItemMasterID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit, Weight, Volume, SequenceNo, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd)
			SELECT		@ItemID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit, Weight, Volume, SequenceNo, 'CopyTemp', CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), null, null, StatusCd
			FROM		ItemUM



delete from ItemUM where fitemmasterid=54292 and UM='LB'




-------------------------------------------------------------------------------



SELECT	pItemMasterID, ItemNo, PCLBFtInd, SuperUMQty
FROM	ItemMaster



--UPDATE new IM.PCLBFTInd from ItemUM
UPDATE	ItemMaster
SET		PCLBFTInd = left(UM.UM,2)
select distinct ItemNo, UM.UM
FROM	ItemMaster IM (NoLock) inner join
		ItemUM UM (NoLock)
ON		IM.pItemMasterID = UM.fItemMasterID and IM.SellStkUMqty = UM.AltSellStkUMQty




--UPDATE new IM.SuperUMQty from ItemUM
UPDATE	ItemMaster
SET		SuperUMQty = UM.QtyPerUM
FROM	ItemMaster IM (NoLock) inner join
		ItemUM UM (NoLock)
ON		IM.pItemMasterID = UM.fItemMasterID and IM.SuperUM = UM.UM

