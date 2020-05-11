select * from BOM
where EntryID='TOD'


select * from BOMDetail
where EntryID='TOD'

delete from BOMDetail
where EntryID='TOD'



update Bomdetail
set BillType = 'S'

--select * from Bomdetail
where isnull(BillType,'')=''


select * from ItemUM
where fItemMasterID=141463



select * from BOMDetail where ParetnItemNo

--delete from BOM where EntryID='TOD'



select pBOMId, pBOMDetailID
			FROM	BOM Hdr (NoLock) left outer join
					BOMDetail Dtl (NoLock)
			ON		Hdr.pBOMID = Dtl.fBOMID


select count(*) from BOM
select * from BOM
where ParentItemNo='00020-2408-401'

select count(*) from BOMDetail
select * 
from BOMDetail where fBOMID=38441


select * from BOM where isnull(deletedt,'') <> ''
select * from BOMDetail where isnull(deletedt,'') <> ''


update BOM set deletedt=null where isnull(deletedt,'') <> ''
update BOMDetail set deletedt=null where isnull(deletedt,'') <> ''



select * from ItemMaster
where pitemmasterid=53811





delete from BOM where pBOMID=38436

insert into BOM (ParentItemNo,EntryID) VALUES ('12345-1234-123','TOD')



			SELECT	Dtl.*
			FROM	BOM Hdr (NoLock) left outer join
					BOMDetail Dtl (NoLock)
			ON		Hdr.pBOMID = Dtl.fBOMID
			WHERE	Hdr.ParentItemNo = '00200-2400-021' AND isnull(Hdr.DeleteDt,'') = '' AND isnull(Dtl.DeleteDt,'') = ''


select distinct ItemNo from
ItemMaster where ItemNo not in
(
select distinct ParentItemNo from bom
)
and left(itemno,6)='00020-'
order by itemno



99


update bom
set Billtype='R'
where pbomid=144





99
select * from BOMDetail where fbomid=


--find BOM with no detail
select * from BOM where pBOMID not in
(select distinct fBOMID from BOMDetail)

select * 
delete
from BOM
where ParentItemNo='00200-2400-021'


select * 
--delete
from BOMDetail where fbomid=13
