select * from ItemUPC



insert into ItemUPC (ItemType,UPCCd,EntryID,EntryDt)
values ('BULK','087302xxxxxx'
087302 752 202



select distinct UPCCd from ItemMaster


truncate table itemupc

insert into ItemUPC (ItemNO, ItemType, UPCCd, EntryID, EntryDt)
select [no], [type], [Final UPC Value], EntryID, EntryDt from pkgUPC 

update ItemUPC
set ItemNo = '', changeid=null, changedt=null, entrydt='3/27/2012'

update itemUPC
set UPCCd = '0'+UpcCd

--Clear existing assigned UPC's
UPDATE	ItemUPC
SET		ItemNo = '',
		ChangeID = null,
		ChangeDt = null
go

--Reassign all UPC's
UPDATE	ItemUPC
SET		ItemNo = IM.ItemNo,
		ChangeID='WO2003-AssignedItems',
		Changedt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
FROM	ItemMaster IM
WHERE	ItemUPC.UPCCd = IM.UPCCd
go




select upccd, * from ItemMaster where UPCCd not in
(select Upccd from ItemUPC) and isnull(upccd,'') <> ''




select * from ItemUPC order by UPCCd


select distinct UPCCd from ItemMaster
where UPCCd in 
(select UPCCd from ItemUPC)


select UPCCd from ItemUPC
where UPCCd='082893349671'



select * from pkgUPC

select distinct ItemType from itemupc

update itemupc
set ChangeID='WO2003-AssignedItems',
	Changedt='2/16/2012'



select * from itemupc
where isnull(ItemNo,'') = ''


select * from ItemUPC where 
--ItemNo='00200-2800-401'
pitemUPCID in (101212, 101134)

update ItemUPC set ItemNo='00200-2800-401', Changeid='dixon' where pitemupcid=101134

update ItemUPC set ItemNo='', Changeid='dixon' where pitemupcid=101212




select top 1 * from ItemUPC where ItemNo='' order by UPCCd

select * from ItemUPC where UPCCd='082893012179'



select * from ItemUPC
where ItemNo='00200-4200-401'


update ItemUPC
SET		ItemNo='',
		changeid='TEST', changedt=getdate()+999
where ItemNo='00200-4200-401' and 
left(changeid,4)='TEMP'


update ItemUPC
SET		ItemNo=''
where upccd ='082893012186'


select * from ItemUPC
--update ItemUPC set 		changeid='TEST', changedt=getdate()+999
where pitemupcid in 
(5,6,
101216,
101217)

select * from SoftLockStats order by EntryDt desc




