--Update [Porteous$Item Cross Reference].[Cross-Reference No_] and [Cross-Reference Whse Loc] from ItemAlias on PFCSQLP
UPDATE		[Porteous$Item Cross Reference]
SET		[Porteous$Item Cross Reference].[Cross-Reference No_] = ItemNo,
		[Porteous$Item Cross Reference].[Cross-Reference Whse Loc] = AliasWhseNo
FROM		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemAlias
INNER JOIN	[Porteous$Item Cross Reference]
ON		ItemNo=[Porteous$Item Cross Reference].[Item No_] and OrganizationNo=[Porteous$Item Cross Reference].[Cross-Reference Type No_]
WHERE 		[Porteous$Item Cross Reference].[Cross-Reference Type]=1 and [Porteous$Item Cross Reference].[Item No_] <> ''




select [Item No_], [Cross-Reference Type No_], [Cross-Reference No_], [Cross-Reference Whse Loc] from

OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTNT.dbo.[Porteous$Item Cross Reference]
INNER JOIN
ItemAlias ON [Item No_]=Itemalias.ItemNo and [Cross-Reference Type No_]=ItemAlias.OrganizationNo
WHERE [Cross-Reference Type]=1 and [Item No_] <> ''




select * from
OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Cross Reference]
