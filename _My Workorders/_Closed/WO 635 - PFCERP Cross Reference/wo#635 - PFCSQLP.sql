select ItemNo, OrganizationNo, AliasItemNo, AliasWhseNo from ItemAlias


select * from
OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTNT.dbo.[Porteous$Item Cross Reference]



select [Item No_], [Cross-Reference Type No_], [Cross-Reference No_], [Cross-Reference Whse Loc] from
OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTNT.dbo.[Porteous$Item Cross Reference]
INNER JOIN
ItemAlias ON [Item No_]=Itemalias.ItemNo and [Cross-Reference Type No_]=ItemAlias.OrganizationNo
WHERE [Cross-Reference Type]=1 and [Item No_] <> ''


--Update [Porteous$Item Cross Reference].[Cross-Reference No_] and [Cross-Reference Whse Loc] from ItemAlias
UPDATE		OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTNT.dbo.[Porteous$Item Cross Reference] XREF
SET		[Cross-Reference No_] = ItemAlias.ItemNo,
		[Cross-Reference Whse Loc] = ItemAlias.AliasWhseNo
FROM		XREF
INNER JOIN	ItemAlias
ON		[Item No_]=Itemalias.ItemNo and [Cross-Reference Type No_]=ItemAlias.OrganizationNo
WHERE 		[Cross-Reference Type]=1 and [Item No_] <> ''


select [Item No_], [Cross-Reference Type No_], [Cross-Reference No_], [Cross-Reference Whse Loc] from [Porteous$Item Cross Reference]
where [Cross-Reference Type No_]='003081' and [Item No_]='00200-2400-020'



--query to PFCSQLT from any SQL server
select * from
OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTNT.dbo.[Porteous$Item Cross Reference]


--Excel Spreadsheet query
select * from
OpenDataSource('Microsoft.Jet.OLEDB.4.0','Data Source="c:\test.XLS";User ID=Admin;Password=;Extended properties=Excel 5.0')...TestRange
--TestRange is a Named Range (find it under Insert Menu > Name > Add)



UPDATE		CPR_Daily
SET		Critical = 'Y'
FROM		CPR_Daily INNER JOIN
		CriticalItemDetail ON CPR_Daily.ItemNo = CriticalItemDetail.ItemNo and CPR_Daily.LocationCode = CriticalItemDetail.LocationCode
WHERE		CriticalItemDetail.CriticalFlag = '1'