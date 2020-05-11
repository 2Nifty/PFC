--exec sp_columns itemnotes

SELECT	Notes.DeleteDt, Notes.*
FROM	ItemMaster IM (NoLock) LEFT OUTER JOIN
		ItemNotes Notes (NoLock)
ON		IM.pItemMasterID = Notes.fItemMasterID
WHERE	--isnull(Notes.DeleteDt,'') = '' AND
		IM.ItemNo = '00050-2818-221' --AND	--lblItemNo
--		Notes.[Type] = 'A' AND				--ddlType
--		Notes.FormsCd = 'AP'				--ddlFormCd

print @@RowCount

update itemnotes set deletedt=null where pitemnotesid in (921,923,924)



select * from ItemNotes where ItemNo='00057-2522-021'

delete from ItemNotes where isnull(DeleteDt,'') <> '' and ItemNo='00057-2522-021'



select DeleteDt, * from ItemMaster where ItemNo='00020-2408-020'


			SELECT	IM.pItemMasterID,
					IM.ItemNo,
					IM.CatDesc,
					IM.ItemDesc,
					isnull(Notes.pItemNotesID,0) as pItemNotesID,
					isnull(Notes.ItemNo,'') as NotesItem,
					isnull(Notes.[Type],'') as [Type],
					isnull(Notes.FormsCd,'') as FormCd,
					isnull(Notes.Notes,'NONOTES') as Notes,
					isnull(Notes.EntryID,'') as EntryID,
					Notes.EntryDt,
					isnull(Notes.ChangeID,'') as ChangeID,
					Notes.ChangeDt
			FROM	ItemMaster IM (NoLock) LEFT OUTER JOIN
					ItemNotes Notes (NoLock)
			ON		IM.pItemMasterID = Notes.fItemMasterID --and isnull(Notes.DeleteDt,'') = ''
			WHERE	IM.ItemNo = '00020-2408-020'





select * 
--delete
from SoftLockStats
where TableRowItem='ItemNotes' -- and EntryID='Tod'
order by EntryDt DESC

update SoftLockStats
set EntryID='Pete'
where TableRowItem='ItemNotes' and EntryID='Tod'


select * from ItemNotes where pItemNotesID=921



update ItemNotes set DeleteDt = null, DeleteID=null
where left(DeleteID,3) = 'Tod' and ItemNo='00050-2818-221'


select * from ItemNotes where left(EntryID,3) <> 'tod' order by ItemNo


select * from 
(
select count(ItemNo) as notecount, ItemNo from ItemNotes where left(EntryID,3) <> 'tod'
 group by itemNo
) tmp
where NoteCount > 1

