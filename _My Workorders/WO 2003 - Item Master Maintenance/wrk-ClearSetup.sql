declare @SessionID varchar(20)

set @SessionID = '11124'


DELETE
--select EntryID, ChangeID, DeleteID, *
FROM	ItemMaster
WHERE	EntryId like '%Temp-%' or
		DeleteId like '%SETUP-%'

DELETE
--select EntryID, ChangeID, DeleteID, *
FROM	ItemUM
WHERE	EntryId like '%Temp-%' or
		DeleteId like '%SETUP-%'


--select EntryID, ChangeID, DeleteID, * from ItemMaster where itemno='00123-0123-123'


select EntryID, EntryDt, ChangeID, ChangeDt, * from ItemMaster where (EntryDt > getdate()-90 or changedt > getdate()-90) and entryid<>'twhite' and changeid<>'twhite'

select * from itemum where (EntryDt > getdate()-90 or changedt > getdate()-90) and entryid<>'twhite' and isnull(changeid,'')<>'twhite' and fitemmasterid not in (53798,54292)

select * from itembranch where (EntryDt > getdate()-90 or changedt > getdate()-90) and entryid<>'twhite' and isnull(changeid,'')<>'twhite' and fitemmasterid not in (53798,54292)


select * from itemum where (EntryDt > getdate()-14 or changedt > getdate()-14) and entryid<>'twhite' and changeid<>'twhite' and
fitemmasterid in (select pitemmasterid from ItemMaster)

select EntryID, EntryDt, ChangeID, ChangeDt, * from Itemmaster where pitemmasterid in
(
168241,
168242,
168243,
168244,
168260
)


delete from ItemMaster where pitemmasterid in
(
168241,
168242,
168243,
168244,
168260
)
delete from itemum where fitemmasterid in 
(
168241,
168242,
168243,
168244,
168260
)


delete from ItemMaster where DeleteID='SETUP-11100' or itemNo='00200-4200-123' or pitemmasterid=167357

delete from ItemUM where DeleteID='SETUP-11100' or fitemmasterid=167357

-------------------------------------------------------------------------------

select * 
--delete 
from ItemMaster
where entryid='tod'


select deleteid, deletedt, * 
from ItemMaster
where isnull(DeleteID,'') <> ''
--UPDATE ItemMaster set DeleteID=null, DeleteDt = null where DeleteID='tod'


select deleteid, deletedt, * 
from ItemUM
where isnull(DeleteID,'') <> ''
--UPDATE ItemUM set DeleteID=null, DeleteDt = null where DeleteID='tod'


select * 
--delete
from ItemUM
where fItemMasterID not in 
(select pitemmasterid from ItemMaster)





select * from SoftLockStats
where UserCurrentApp='IMM'
order by EntryDt desc


delete from softlockstats
where UserCurrentApp='IMM'