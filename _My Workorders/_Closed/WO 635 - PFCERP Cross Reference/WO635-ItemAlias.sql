
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

--Exceptions
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, [Cross-Reference Type]
from [Porteous$Item Cross Reference]
WHERE [Cross-Reference Type] <> 1 or [Item No_] = '' or [Cross-Reference Type No_] = '' or [Cross-Reference No_] = ''
UNION
select distinct [Item No_], [Cross-Reference Type No_] as CustNo, [Cross-Reference No_] as XREF, [Cross-Reference Type]
from [DTQ_ItemCrossReference]
WHERE [Cross-Reference Type] <> 1 or [Item No_] = '' or [Cross-Reference Type No_] = '' or [Cross-Reference No_] = ''




truncate table ItemAlias

select count(*) from ItemAlias


select top 50 * from [Porteous$Item Cross Reference]
select top 50 * from [DTQ_ItemCrossReference]




SELECT     ItemNo + AliasItemNo + OrganizationNo AS UniqueID, COUNT(*) AS [Count]
FROM         ItemAlias
GROUP BY ItemNo + AliasItemNo + OrganizationNo
HAVING      (COUNT(*) > 1)





SELECT     *, ItemNo AS Expr1, AliasItemNo AS Expr3, OrganizationNo AS Expr2
FROM         ItemAlias
WHERE     (OrganizationNo = '200301') 
order by ItemNo, OrganizationNo, AliasItemNo



SELECT     *
FROM         ItemAlias
WHERE     (OrganizationNo = '054270') AND (ItemNo = '00100-3063-020') AND (AliasItemNo = 'BCQ10C120210')
--WHERE     (OrganizationNo = '013515') AND (ItemNo = '00790-0621-409') AND (AliasItemNo = '6158DECK')
--WHERE     (OrganizationNo = '082351') AND (ItemNo = '02333-2322-408') AND (AliasItemNo = 'RHD#HW3-134')
--WHERE     (OrganizationNo = '042895') AND (ItemNo = '00252-2400-021') AND (AliasItemNo = '1180280')
--WHERE     (OrganizationNo = '028989') AND (ItemNo = '00800-2024-401') AND (AliasItemNo = 'ATLCOTT1-1E2')




SELECT     *
FROM         [Porteous$Item Cross Reference]
WHERE     ([Item No_] = '00252-2400-021') and
		([Cross-Reference Type No_] = '042895') and
		([Cross-Reference No_] = '1180280')

SELECT     *
from		 DTQ_ItemCrossReference
WHERE     ([Item No_] = '00252-2400-021') and
		([Cross-Reference Type No_] = '042895') and
		([Cross-Reference No_] = '1180280')




SELECT     *
FROM         [Porteous$Item Cross Reference]
WHERE     ([Item No_] = '00800-2024-401') and
		([Cross-Reference Type No_] = '028989') and
		([Cross-Reference No_] = 'ATLCOTT1-1E2')

SELECT     *
from		 DTQ_ItemCrossReference
WHERE     ([Item No_] = '00800-2024-401') and
		([Cross-Reference Type No_] = '028989') and
		([Cross-Reference No_] = 'ATLCOTT1-1E2')





SELECT     *
FROM         [Porteous$Item Cross Reference]
WHERE     ([Item No_] = '02333-2322-408') and
		([Cross-Reference Type No_] = '082351') and
		([Cross-Reference No_] = 'RHD#HW3-134')

SELECT     *
from		 DTQ_ItemCrossReference
WHERE     ([Item No_] = '02333-2322-408') and
		([Cross-Reference Type No_] = '082351') and
		([Cross-Reference No_] = 'RHD#HW3-134')



SELECT     *
FROM         [Porteous$Item Cross Reference]
WHERE     ([Item No_] = '00790-0621-409') and
		([Cross-Reference Type No_] = '013515') and
		([Cross-Reference No_] = '6158DECK')

SELECT     *
from		 DTQ_ItemCrossReference
WHERE     ([Item No_] = '00100-3063-020') and
		([Cross-Reference Type No_] = '013515') and
		([Cross-Reference No_] = '6158DECK')



SELECT     *
FROM         [Porteous$Item Cross Reference]
WHERE     ([Item No_] = '00100-3063-020') and
		([Cross-Reference Type No_] = '054270') and
		([Cross-Reference No_] = 'BCQ10C120210')

SELECT     *
from		 DTQ_ItemCrossReference
WHERE     ([Item No_] = '00100-3063-020') and
		([Cross-Reference Type No_] = '054270') and
		([Cross-Reference No_] = 'BCQ10C120210')







SELECT     *
FROM         [Porteous$Item Cross Reference] INNER JOIN
                      DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
                      [Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
                      [Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
--WHERE     ([Porteous$Item Cross Reference].[Item No_] = '00020-2408-021')
ORDER BY [Porteous$Item Cross Reference].[Item No_], [Porteous$Item Cross Reference].[Cross-Reference Type No_], 
                      [Porteous$Item Cross Reference].[Cross-Reference No_]





--Verify [Unit of Measure] field [Porteous$Item Cross Reference] (NV)
UPDATE	[Porteous$Item Cross Reference]
SET	[Porteous$Item Cross Reference].[Unit of Measure] = DTQ_ItemCrossReference.[Unit of Measure]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Unit of Measure] <> DTQ_ItemCrossReference.[Unit of Measure])


--Verify [Unit of Measure] field [DTQ_ItemCrossReference (DTQ)
UPDATE	DTQ_ItemCrossReference
SET	DTQ_ItemCrossReference.[Unit of Measure] = [Porteous$Item Cross Reference].[Unit of Measure]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Unit of Measure] <> DTQ_ItemCrossReference.[Unit of Measure])






--Verify Description field [Porteous$Item Cross Reference] (NV)
UPDATE	[Porteous$Item Cross Reference]
SET	[Porteous$Item Cross Reference].[Description] = DTQ_ItemCrossReference.[Description]

FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Description] = '') AND
	([Porteous$Item Cross Reference].[Description] <> DTQ_ItemCrossReference.[Description])


--Verify Description field [DTQ_ItemCrossReference (DTQ)
UPDATE	DTQ_ItemCrossReference
SET	DTQ_ItemCrossReference.[Description] = [Porteous$Item Cross Reference].[Description]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	(DTQ_ItemCrossReference.[Description] = '') AND
	([Porteous$Item Cross Reference].[Description] <> DTQ_ItemCrossReference.[Description])


--Verify Description field [Porteous$Item Cross Reference] specific for Customer 090901
UPDATE	[Porteous$Item Cross Reference]
SET	[Porteous$Item Cross Reference].[Description] = DTQ_ItemCrossReference.[Description]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Cross-Reference Type No_] = '090901') AND
	([Porteous$Item Cross Reference].[Description] <> DTQ_ItemCrossReference.[Description])






--Verify [Cross-Reference Whse Loc] field [DTQ_ItemCrossReference (DTQ)
UPDATE	DTQ_ItemCrossReference
SET	DTQ_ItemCrossReference.[Cross-Reference Whse Loc] = [Porteous$Item Cross Reference].[Cross-Reference Whse Loc]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	((DTQ_ItemCrossReference.[Cross-Reference Whse Loc] = '') OR (DTQ_ItemCrossReference.[Cross-Reference Whse Loc] = '0')) AND
	 ([Porteous$Item Cross Reference].[Cross-Reference Whse Loc] <> DTQ_ItemCrossReference.[Cross-Reference Whse Loc])


--Verify [Cross-Reference Whse Loc] field [Porteous$Item Cross Reference] (NV)
UPDATE	[Porteous$Item Cross Reference]
SET	[Porteous$Item Cross Reference].[Cross-Reference Whse Loc] = DTQ_ItemCrossReference.[Cross-Reference Whse Loc]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Cross-Reference Whse Loc] <> DTQ_ItemCrossReference.[Cross-Reference Whse Loc])



--Verify [Unit of Measure] field [Porteous$Item Cross Reference] (NV)
UPDATE	[Porteous$Item Cross Reference]
SET	[Porteous$Item Cross Reference].[Unit of Measure] = DTQ_ItemCrossReference.[Unit of Measure]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	([Porteous$Item Cross Reference].[Unit of Measure] <> '') AND
	([Porteous$Item Cross Reference].[Unit of Measure] <> DTQ_ItemCrossReference.[Unit of Measure])


--Verify [Unit of Measure] field [DTQ_ItemCrossReference (DTQ)
UPDATE	DTQ_ItemCrossReference
SET	DTQ_ItemCrossReference.[Unit of Measure] = [Porteous$Item Cross Reference].[Unit of Measure]
FROM	[Porteous$Item Cross Reference] INNER JOIN
	DTQ_ItemCrossReference ON [Porteous$Item Cross Reference].[Item No_] = DTQ_ItemCrossReference.[Item No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference Type No_] = DTQ_ItemCrossReference.[Cross-Reference Type No_] AND 
	[Porteous$Item Cross Reference].[Cross-Reference No_] = DTQ_ItemCrossReference.[Cross-Reference No_]
WHERE	(DTQ_ItemCrossReference.[Unit of Measure] <> '') AND
	([Porteous$Item Cross Reference].[Unit of Measure] <> DTQ_ItemCrossReference.[Unit of Measure])










