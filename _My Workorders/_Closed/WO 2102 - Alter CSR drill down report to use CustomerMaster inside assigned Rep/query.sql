select
a.username as UserName
from
dbo.UCOR_UserSetup a join  dbo.UCOR_UserType b on a.UserType=b.typeID
where
a.CompanyId=05 and b.Type='Customer Sales Rep' order by username


select * from PERP.dbo.ListDetail
where ListValue='jclements'

--------------------------------------------------------------------------

select
isnull(RM.RepNotes,'') as UserName --, *
from
PERP.dbo.RepMaster RM
where
RM.LocationNo = '05' AND RM.RepClass = 'I' AND RM.RepStatus = 'A'


--------------------------------------------------------------------------


a.CompanyId=05 and b.Type='Customer Sales Rep' order by username

set nocount on
select * from PERP.dbo.RepMaster


select * from PERP.dbo.SecurityUsers

--------------------------------------------------------------------------


select [Inside Sales Rep], * from PERP.dbo.CustomerMaster
exec sp_columns CustomerMaster