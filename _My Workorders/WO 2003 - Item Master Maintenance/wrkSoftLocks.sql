select * from SoftLockStats order by EntryDt desc


update SoftLockStats set EntryID='testtod' where TableRowItem='ItemMaster' and typeofrowitem=54284


delete from SoftLockStats where EntryID='tod'

update
ItemUM 
--select * from 
--Itemmaster 
set Deletedt=null, deleteid=null
where fitemmasterid=54284
where itemno='00200-4200-021'

select * from ItemUM where fitemmasterid=54284
select * from itemmaster where pitemmasterid=167374

exec sp_columns ItemMaster



select * from ItemUM

select * from ItemUPC