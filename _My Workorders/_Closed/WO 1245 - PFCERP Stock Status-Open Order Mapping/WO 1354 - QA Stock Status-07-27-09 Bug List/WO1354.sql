
select	RefSONo, Dtl.*
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeader Hdr inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SODetail Dtl
on	pSOHeaderID=Dtl.fSOHeaderID
where	RefSONo='SRA1202790' or RefSONo='SRA1198914'	--Returns
   or	RefSONo='SO3007388'				--Backorder
   or	RefSONo='SC148804'				--Credit

select	*
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOExpense
where	DocumentLoc='SRA1202790' or DocumentLoc='SRA1198914'	--Returns
   or	DocumentLoc='SO3007388'					--Backorder
   or	DocumentLoc='SC148804'					--Credit


select	[Order Type], [Back Order], [Order Date], *
from	[Porteous$Sales Header]
where	[No_]='SRA1202790' or [No_]='SRA1198914' 	--Returns
   or	[No_]='SO3007388'				--Backorder
   or	[No_]='SC148804'				--Credit
--order by [Order Type]


select	Quantity, [Back Order Qty], [Unit Price], [Unit Cost], *
from	[Porteous$Sales Line]
where	[Document No_]='SRA1202790' or [Document No_]='SRA1198914'	--Returns
   or	[Document No_]='SO3007388'					--Backorder
   or	[Document No_]='SC148804'					--Credit



select * from [Porteous$Sales Header] Hdr inner join
		[Porteous$Sales Line] Line on
	Hdr.[No_]=Line.[Document No_]
where Hdr.[Back Order] = 1 and Line.[Back Order Qty] <> 0






select * from [Porteous$Sales Line] where [Back Order Qty] <> 0

select * from [Porteous$Sales Header] where [No_]='SO2998321'
select * from [Porteous$Sales Line] where [Document No_]='SO2998321'








select * 
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas'






select Dtl.Quantity, Dtl.[Original Qty], Dtl.* from [Porteous$Sales Header] Hdr inner join
		[Porteous$Sales Line] Dtl on Hdr.[No_]=Dtl.[Document No_]
where (Hdr.[Document Type]=3 or Hdr.[Document Type]=5) and 
	(Dtl.[Quantity] < 0 or Dtl.[Original Qty] < 0 )
