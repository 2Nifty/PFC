--Update [Porteous$Item Cross Reference].[Cross-Reference No_] and [Cross-Reference Whse Loc] from ItemAlias on PFCSQLP

UPDATE		[Porteous$Item Cross Reference]
SET		[Porteous$Item Cross Reference].[Cross-Reference No_] = ItemNo,
		[Porteous$Item Cross Reference].[Cross-Reference Whse Loc] = AliasWhseNo
FROM		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemAlias
INNER JOIN	[Porteous$Item Cross Reference]
ON		ItemNo Collate database_Default = [Porteous$Item Cross Reference].[Item No_] Collate database_Default and
		OrganizationNo Collate database_Default = [Porteous$Item Cross Reference].[Cross-Reference Type No_] Collate database_Default
WHERE		[Porteous$Item Cross Reference].[Cross-Reference Type]=1 and [Porteous$Item Cross Reference].[Item No_] <> ''




SELECT DISTINCT
                      CAST(GETDATE() AS TimeStamp(8)) AS TimeStamp, ItemAlias.ItemNo, ItemAlias.UOM, '1' AS XrefType, ItemAlias.OrganizationNo, 
                      ItemAlias.AliasItemNo, ItemAlias.AliasDesc, ItemAlias.AliasWhseNo, ItemAlias.AliasType
FROM         (SELECT DISTINCT ItemNo, OrganizationNo, AliasItemNo
                       FROM          ItemAlias
                       WHERE      AliasType = 'C' AND ItemNo <> '') MasterAlias Left OUTER JOIN
                      ItemAlias ON MasterAlias.ItemNo = ItemAlias.ItemNo AND MasterAlias.OrganizationNo = ItemAlias.OrganizationNo AND 
                      MasterAlias.AliasItemNo = ItemAlias.AliasItemNo
WHERE	ItemAlias.AliasType='C' and ItemAlias.ItemNo<>''




SELECT DISTINCT
                      CAST(GETDATE() AS TimeStamp(8)) AS TimeStamp, ItemAlias.ItemNo, ItemAlias.UOM, '1' AS XrefType, ItemAlias.OrganizationNo, 
                      ItemAlias.AliasItemNo, ItemAlias.AliasDesc, ItemAlias.AliasWhseNo, ItemAlias.AliasType
FROM         ItemAlias inner join (SELECT DISTINCT ItemNo, OrganizationNo, AliasItemNo
                       FROM          ItemAlias
                       WHERE      AliasType = 'C' AND ItemNo <> '') MasterAlias
ON MasterAlias.ItemNo = ItemAlias.ItemNo AND MasterAlias.OrganizationNo = ItemAlias.OrganizationNo AND 
                      MasterAlias.AliasItemNo = ItemAlias.AliasItemNo
WHERE	ItemAlias.AliasType='C' and ItemAlias.ItemNo<>''



SELECT DISTINCT
                      CAST(GETDATE() AS TimeStamp(8)) AS TimeStamp, ItemAlias.ItemNo, ItemAlias.UOM, '1' AS XrefType, ItemAlias.OrganizationNo, 
                      ItemAlias.AliasItemNo, ItemAlias.AliasDesc, ItemAlias.AliasWhseNo, ItemAlias.AliasType
FROM         ItemAlias inner join ItemAlias MasterAlias
ON MasterAlias.ItemNo = ItemAlias.ItemNo AND MasterAlias.OrganizationNo = ItemAlias.OrganizationNo AND 
                      MasterAlias.AliasItemNo = ItemAlias.AliasItemNo
WHERE	ItemAlias.AliasType='C' and ItemAlias.ItemNo<>''
group by ItemAlias.ItemNo, ItemAlias.OrganizationNo, ItemAlias.AliasItemNo






SELECT	CAST(GETDATE() as TimeStamp(8)) as TimeStamp, ItemNo, ' ' as Variant, UOM, '1' AS XrefType, OrganizationNo, AliasItemNo, AliasDesc, 0 as BarCode, AliasWhseNo, AliasType
FROM	ItemAlias
WHERE	AliasType='C'





SELECT DISTINCT (ItemNo+OrganizationNo+AliasItemNo), *
                       FROM          ItemAlias
                       WHERE      AliasType = 'C' AND ItemNo <> ''




SELECT	ItemNo+OrganizationNo+AliasItemNo as UniqueID, CAST(GETDATE() as TimeStamp(8)) as TimeStamp, ItemNo, ' ' as Variant, UOM, '1' AS XrefType, OrganizationNo, AliasItemNo, AliasDesc, 0 as BarCode, AliasWhseNo, AliasType
FROM	ItemAlias
Group By ItemNo+OrganizationNo+AliasItemNo
having	AliasType='C' AND ItemNo <> ''


SELECT	ItemNo, OrganizationNo, AliasItemNo
FROM	ItemAlias
WHERE AliasType='C' AND ItemNo <> ''
Group By ItemNo, OrganizationNo, AliasItemNo




SELECT	DISTINCT CAST(GETDATE() as TimeStamp(8)) as TimeStamp, ItemNo, UOM, '1' AS XrefType, OrganizationNo, AliasItemNo, AliasDesc,
			AliasWhseNo, AliasType
FROM	ItemAlias
WHERE	AliasType='C' and ItemNo<>''
order by ItemNo



SELECT	DISTINCT ItemNo, OrganizationNo, AliasItemNo
FROM	ItemAlias
WHERE	AliasType='C' and ItemNo<>''
order by ItemNo



DELETE FROM	[Porteous$Item Cross Reference]
WHERE		[Cross-Reference Type]=1


select * from [Porteous$Item Cross Reference]
WHERE		[Cross-Reference Type]=1 and [Item No_]<>''
order by [Item No_]






select * from

OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Cross Reference]
WHERE		[Cross-Reference Type]=1 and [Item No_] <> ''



exec sp_columns [Porteous$Item Cross Reference]

