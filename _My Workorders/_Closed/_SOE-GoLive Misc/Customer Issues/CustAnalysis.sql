select [Last Date Modified], * from [Porteous$Customer] where No_=008262

select CustCd, fBillToNo, ChangeDt, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster
where CustNo=008262

select Type, ChangeDt, ChangeID, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerAddress
where fCustomerMasterID=654


update [Porteous$Customer]
set 	[Last Date Modified]=CAST(FLOOR(CAST(GetDate() AS FLOAT))AS DATETIME),
	[Last Modified By]='TOD'
where [No_]='008262'


select *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderRel
where OrderNo=31470