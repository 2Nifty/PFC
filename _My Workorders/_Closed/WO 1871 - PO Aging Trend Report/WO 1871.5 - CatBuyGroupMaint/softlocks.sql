select * from SoftLockStats where TableRowItem='CategoryBuyGroups'


exec sp_columns SoftLockStats


delete from SoftLockStats where  TableRowItem='CategoryBuyGroups'


update SoftLockStats set TypeofRowItem='00024' where  TableRowItem='CategoryBuyGroups' and TypeofRowItem='24'



exec pSoftLock 


select * from CategoryBuyGroups

delete from CategoryBuyGroups where Category='00024'

select *  from CategoryBuyGroups where Category='00024'

exec sp_columns CategoryBuyGroups
