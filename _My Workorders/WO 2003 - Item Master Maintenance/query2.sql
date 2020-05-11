select * from ItemUM



select 
pitemmasterid,
case WHEN ENTRYID='InsTemp' or ENTRYID='CopyTemp' THEN 'INSERT/COPY'
	ELSE EntryID
END as EntryID
 from ItemMaster


update ItemMaster
set Entryid='system' where pitemmasterid=2



select * 
delete from ItemMaster where ItemNo='00020-2408-999'


exec [pTempIMaint3] '00020-2408-020', 'GET'
exec [pTempIMaint3] '00020-2408-999', 'GET'


select EntryID, DeleteID, * from ItemMaster where ItemNo='00123-0004-005'

changeid='tod'

update ItemMaster set ItemNo='00020-2408-020' where pitemmasterid=3


	exec [pTempIMaint3] '00123-0004-005', 'SELECT'


select * from ItemMaster where deleteid='tod'


update itemmaster set deletedt=null, deleteid=null where pitemmasterid=3 or pitemmasterid=53811





delete from ItemMaster where EntryId='tod' or left(Deleteid,5)='setup' or left(EntryID,8)='CopyTemp' or left(EntryID,7)='InsTemp'
update ItemMaster set deletedt=null, deleteid=null where isnull(deleteid,'') <> ''

delete from ItemUM where EntryId='tod' or left(Deleteid,5)='setup' or left(EntryID,8)='CopyTemp' or left(EntryID,7)='InsTemp'
update ItemMaster set deletedt=null, deleteid=null where isnull(deleteid,'') <> ''


select EntryID, DeleteID, * from ItemMaster where ItemNo='00123-0004-005'

select * from itemmaster where left(Itemno,5)='00500'

select * from ItemCategory
order by category



select * from Itemmaster
where finish in ('grn','wht','red')

exec sp_columns ItemMaster




select * from ListMaster where ListName='PCLBFTInd'


update itemmaster set superum='FP' where itemno='00200-4200-021'



exec sp_columns itemmaster