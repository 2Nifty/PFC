select * 
--delete
from dbo.ItemAliasUploadQueue where OrganizationNo='200301' --or OrganizationNo='002901'


select distinct entryid from ItemAliasUploadQueue


SELECT COUNT(*) 
FROM   ItemAlias (NoLock) 
WHERE  OrganizationNo = '200301' and isnull(DeleteDt,'') = ''