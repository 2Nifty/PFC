select	* from [Porteous$Item Cross Reference]
--where [Cross-Reference No_]='HW18S'

where	[Cross-Reference Type] = 0 and
	([Cross-Reference Type No_] = '' or [Cross-Reference Type No_] is null)



select count(*) from PFCTNT.dbo.[Porteous$Item Cross Reference] where [Cross-Reference Type] = 1
AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''

select count(*) from PFCTNT.dbo.[Porteous$Item Cross Reference]
WHERE	([Cross-Reference Type No_] = '' or [Cross-Reference Type No_] is null) and
	[Cross-Reference Type] = 0


select count(*) from PFCReports.dbo.ItemAlias where AliasType='C' and OrganizationNo<>'000000'

select count(*) from PFCReports.dbo.ItemAlias where OrganizationNo='000000'




DELETE FROM PFCTNT.dbo.[Porteous$Item Cross Reference]
WHERE [Cross-Reference Type] = 1 AND [Item No_] <> '' AND [Cross-Reference Type No_] <> '' AND [Cross-Reference No_] <> ''

SELECT	count(*)
FROM	PFCReports.dbo.ItemAlias
WHERE	AliasType='C' AND OrganizationNo <> '000000'



DELETE FROM PFCTNT.dbo.[Porteous$Item Cross Reference]
WHERE	([Cross-Reference Type No_] = '' or [Cross-Reference Type No_] is null) and
	[Cross-Reference Type] = 0

SELECT	count(*)
FROM	PFCReports.dbo.ItemAlias
WHERE	OrganizationNo = '000000'






--Generic xref records
SELECT --DISTINCT
	[Item No_] as ItemNo,
	'000000' as OrganizationNo,
	[Cross-Reference No_] as AliasItemNo,
	[Description] as AliasDesc,
	'C' as AliasType,
	[Cross-Reference Whse Loc] as AliasWhseNo,
	[Unit of Measure] as UOM,
	'WO1520' as EntryID,
	GetDate() as EntryDt
FROM	[Porteous$Item Cross Reference]
WHERE	([Cross-Reference Type No_] = '' or [Cross-Reference Type No_] is null) and
	[Cross-Reference Type] = 0


DELETE FROM PFCTNT.dbo.[Porteous$Item Cross Reference]
WHERE	([Cross-Reference Type No_] = '' or [Cross-Reference Type No_] is null) and
	[Cross-Reference Type] = 0

SELECT	CAST(GETDATE() as TimeStamp) as TimeStamp,
	ISNULL(ItemNo,'') AS ItemNo,
	ISNULL(UOM,'') AS UOM,
	'0' AS XrefType,
	'' AS OrganizationNo,
	ISNULL(AliasItemNo,'') AS AliasItemNo,
	ISNULL(AliasDesc,'') AS AliasDesc,
	0 as BarCode,
	ISNULL(AliasWhseNo,'') AS AliasWhseNo,
	ISNULL(AliasType,'') AS AliasType
FROM	ItemAlias
WHERE	OrganizationNo = '000000'