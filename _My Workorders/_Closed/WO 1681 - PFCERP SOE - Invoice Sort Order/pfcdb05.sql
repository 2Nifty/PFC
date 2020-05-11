
select [Invoice Detail Sort], No_, [Last Date Modified], [Last Modified By] from [Porteous$Customer] where No_='002901'



select [Invoice Detail Sort], * from [Porteous$Customer]
where No_ > 00200
order by No_


update [Porteous$Customer]
set [Invoice Detail Sort]=1
where No_='002901'


update [Porteous$Customer]
set [Invoice Detail Sort]=2
where No_='000401'


update [Porteous$Customer]
set [Invoice Detail Sort]=3
where No_='000405'


update [Porteous$Customer]
set [Invoice Detail Sort]=4
where No_='000406'


update [Porteous$Customer]
set [Invoice Detail Sort]=5
where No_='002901'



drop table dbo.[tERPCustUpdate]

select * 
into 	dbo.[tERPCustUpdate]
from 	[Porteous$Customer]
where 	No_='002901'


select [Invoice Detail Sort], * from dbo.[tERPCustUpdate]