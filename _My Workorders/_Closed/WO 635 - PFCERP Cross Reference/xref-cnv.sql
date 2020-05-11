
--Valid xref records
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description, 'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [Porteous$Item Cross Reference]
--WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''
WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference No_] <> ''
UNION
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description, 'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [DTQ_ItemCrossReference]
--WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''
WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference No_] <> ''




select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Cross Reference] XREF
where NOT EXISTS (SELECT * FROM [Porteous$Item Cross Reference]
WHERE 
[Cross-Reference Type No_] = XREF.[Cross-Reference Type No_] COLLATE Latin1_General_CS_AS AND
[Item No_] <> XREF.[Item No_] COLLATE Latin1_General_CS_AS and
[Cross-Reference No_] <> XREF.[Cross-Reference No_] COLLATE Latin1_General_CS_AS) AND
[Item No_] <> '' AND [Cross-Reference No_] <> ''




--Valid xref records
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description,
	CASE [Cross-Reference Type]
	     WHEN '1' THEN 'C'
	     WHEN '2' THEN 'V'
	     WHEN '0' THEN 'G'
	END AS XrefType,
--'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [Porteous$Item Cross Reference]
--WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''
WHERE ([Cross-Reference Type] = 0 OR [Cross-Reference Type] = 1 OR [Cross-Reference Type] = 2) AND
[Item No_] <> '' AND [Cross-Reference No_] <> ''
UNION
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description,
	CASE [Cross-Reference Type]
	     WHEN '1' THEN 'C'
	     WHEN '2' THEN 'V'
	     WHEN '0' THEN 'G'
	END AS XrefType,
--'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [DTQ_ItemCrossReference]
--WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''
WHERE ([Cross-Reference Type] = 0 OR [Cross-Reference Type] = 1 OR [Cross-Reference Type] = 2) AND
[Item No_] <> '' AND [Cross-Reference No_] <> ''


select COUNT(ItemNo+OrganizationNo+AliasItemNo+AliasType), ItemNo+OrganizationNo+AliasItemNo+AliasType from ItemAlias
group by ItemNo+OrganizationNo+AliasItemNo+AliasType
having (COUNT(ItemNo+OrganizationNo+AliasItemNo+AliasType) > 1)
order by ItemNo+OrganizationNo+AliasItemNo+AliasType

select count(*) from ItemAlias


select * from ItemAlias order by ItemNo, OrganizationNo, AliasItemNo


SELECT	count(*)
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] = 0 or [Cross-Reference Type] = 1 or [Cross-Reference Type] = 2




------------------------------------------------------------------\



--Generic Substitution
SELECT	*
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] = 0 AND [Item No_] <> '' AND [Cross-Reference No_] <> ''







--Valid xref records
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description, 'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [Porteous$Item Cross Reference]
WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''
UNION
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description, 'C' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
from [DTQ_ItemCrossReference]
WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''





--Vendor Cross-Reference
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, Description, 'G' as XrefType,
[Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' as EntryID, GetDate() as EntryDate
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] = 2 AND [Item No_] <> '' AND [Cross-Reference No_] <> ''



SELECT DISTINCT	[Item No_], [Cross-Reference Type No_] AS CustNo, [Cross-Reference No_] AS XREF, Description,
		'V' AS XrefType, [Cross-Reference Whse Loc], [Unit of Measure], 'IT Load' AS EntryID, GETDATE() AS EntryDate
FROM		[Porteous$Item Cross Reference]
WHERE		[Cross-Reference Type] = 2 AND [Item No_] <> '' AND [Cross-Reference No_] <> '' AND [Cross-Reference Type No_] <> ''






SELECT	CAST(GETDATE() as TimeStamp(8)) as TimeStamp, ISNULL(ItemNo,'') AS ItemNo, ' ' as Variant, ISNULL(UOM,'') AS UOM,
	CASE AliasType
	     WHEN 'C' THEN '1'
	     WHEN 'V' THEN '2'
	     WHEN 'G' THEN '0'
	END AS XrefType,
	ISNULL(OrganizationNo,'') AS OrganizationNo, ISNULL(AliasItemNo,'') AS AliasItemNo, ISNULL(AliasDesc,'') AS AliasDesc,
	0 as BarCode, ISNULL(AliasWhseNo,'') AS AliasWhseNo, ISNULL(AliasType,'') AS AliasType
FROM	ItemAlias
WHERE	AliasType='C' OR AliasType='V' OR AliasType='G'










select * from [Porteous$Item Cross Reference]
WHERE [Cross-Reference Type] = 1 AND 
--([Item No_] = '' or [Cross-Reference Type No_] = '' or [Cross-Reference No_] = '')
([Item No_] = '' or [Cross-Reference No_] = '')

select * from [Porteous$Item Cross Reference]
WHERE [Cross-Reference Type] = 2 AND 
--([Item No_] = '' or [Cross-Reference Type No_] = '' or [Cross-Reference No_] = '')
([Item No_] = '' or [Cross-Reference No_] = '')


--Generic Substitution
SELECT	*
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] = 0 AND 
([Item No_] = '' or [Cross-Reference No_] = '')


SELECT	*
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] <> 0 AND [Cross-Reference Type] <> 1 AND [Cross-Reference Type] <> 2


SELECT	count(*)
FROM	[Porteous$Item Cross Reference]
WHERE	[Cross-Reference Type] = 0 or [Cross-Reference Type] = 1 or [Cross-Reference Type] = 2






select * from [Porteous$Item Cross Reference]
WHERE ([Cross-Reference Type] = 1 or [Cross-Reference Type] = 2)
AND [Cross-Reference Type No_] = '' AND [Item No_] <> '' and [Cross-Reference No_] <> ''
order by [Item No_]


select * from [Porteous$Item Cross Reference]
WHERE ([Cross-Reference Type] = 0)
AND [Cross-Reference Type No_] = '' AND [Item No_] <> '' and [Cross-Reference No_] <> ''
order by [Item No_]




select count(*) from [Porteous$Item Cross Reference]






select * from [Porteous$Item Cross Reference] XREF
where NOT EXISTS (SELECT * FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Item Cross Reference]
WHERE 
[Cross-Reference Type No_] = XREF.[Cross-Reference Type No_] COLLATE Latin1_General_CS_AS AND
[Item No_] <> XREF.[Item No_] COLLATE Latin1_General_CS_AS and
[Cross-Reference No_] <> XREF.[Cross-Reference No_] COLLATE Latin1_General_CS_AS) AND
[Item No_] <> '' AND [Cross-Reference No_] <> ''










--PFCSQLT.PFCReports
select * from DTQ_ItemCrossReference order by [Cross-Reference Type]


select COUNT(ItemNo+OrganizationNo+AliasItemNo+AliasType), ItemNo+OrganizationNo+AliasItemNo+AliasType from ItemAlias
group by ItemNo+OrganizationNo+AliasItemNo+AliasType
having (COUNT(ItemNo+OrganizationNo+AliasItemNo+AliasType) > 1)




select * from [Porteous$Item Cross Reference]
where [Item No_]='00050-2818-221'-- and [Cross-Reference No_]='277MBZ381'


select * from ItemAlias
where ItemNo='00050-2818-221'
