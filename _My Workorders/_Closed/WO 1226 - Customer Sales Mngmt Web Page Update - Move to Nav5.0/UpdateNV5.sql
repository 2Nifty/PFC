--select * from [Porteous$Salesperson_Purchaser]


update [Porteous$Salesperson_Purchaser]
set [Inside Sales]=old.[Inside Sales]
from [Porteous$Salesperson_Purchaser] new inner join
OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Salesperson_Purchaser] old
on old.[Code]=new.[Code] collate SQL_Latin1_General_CP1_CI_AS


update	[Porteous$Customer]
set	[Backorder]=old.[Backorder],
	[Chain Name]=old.[Chain Name],
	[Customer Disc_ Group]=old.[Customer Disc_ Group],
	[Customer Price Group]=old.[Customer Price Group],
	[E-Ship Agent Service]=old.[E-Ship Agent Service],
	[Free Freight]=old.[Free Freight],
	[Inside Salesperson]=old.[Inside Salesperson],
	[Shipment Method Code]=old.[Shipment Method Code],
	[Shipping Agent Code]=old.[Shipping Agent Code],
	[Shipping Location]=old.[Shipping Location],
	[Shipping Payment Type]=old.[Shipping Payment Type],
	[Usage Location]=old.[Usage Location]
from	[Porteous$Customer] new inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Customer] old
on	old.[No_]=new.[No_] collate SQL_Latin1_General_CP1_CI_AS


select ChainCd, * from tERPCustUpdate




--do both NV5 and NV3.7
update	[Porteous$Customer]
set	[Last Date Modified]=old.[Last Date Modified],
	[Last Modified By]=old.[Last Modified By]
from	[Porteous$Customer] new inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tWO1226Customer] old
on	old.[No_]=new.[No_] collate SQL_Latin1_General_CP1_CI_AS



--ERP
update	[CustomerMaster]
set	[ChangeDt]=old.[Last Date Modified
	[ChangeID]=old.[Last Modified By]
from	[CustomerMaster] new inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tWO1226Customer] old
on	old.[No_]=new.[CustNo] collate SQL_Latin1_General_CP1_CI_AS






select * from [Porteous$Chain Name]
select * from [Porteous$Shipping Agent]
SELECT * FROM [Porteous$E-Ship Agent Service]


SELECT [E-Ship Agent Service] FROM [Porteous$E-Ship Agent Service] ORDER BY [Shipping Agent Code]



select [E-Ship Agent Service] from [Porteous$Customer]