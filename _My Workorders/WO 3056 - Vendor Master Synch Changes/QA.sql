SELECT	AppOptionType, AppOptionValue
FROM	AppPref
WHERE	ApplicationCd = 'AP' AND (AppOptionType = 'LastVendNV5.0CnvDt' or AppOptionType = 'LstVendConNV5.0CnvDt')




select EntryDt, EntryID, ChangeDt, ChangeID, DeleteDt, * from VendorMaster
where left(EntryID,7) = 'WO1046_' or left(ChangeID,7) = 'WO1046_'

select EntryDt, EntryID, ChangeDt, ChangeID, DeleteDt, * from VendorAddress
where left(EntryID,7) = 'WO1046_' or left(ChangeID,7) = 'WO1046_'

select EntryDt, EntryID, ChangeDt, ChangeID, DeleteDt, * from VendorContact
where left(EntryID,7) = 'WO1046_' or left(ChangeID,7) = 'WO1046_'





select * from VendorContact where ContactNoNV='CT023497'

select * 
delete
from VendorMaster where vendno in ('1000074','1000569')


select * 
delete
from VendorAddress where fvendmstrid in (536,550)


select * 
delete
from VendorContact where fvendaddrid in (542,556)






select type, vendormaster.* from VendorMaster inner join vendoraddress on pvendmstrid=fvendmstrid inner join VendorContact on pvendaddrid=fvendaddrid
where left(type,2)='pt'



where vendno in ('0009130', '0009131')

select * from VendorAddress where fvendmstrid=223



where left(type,2)='pt'


