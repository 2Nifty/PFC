
--Find missing SKUs
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1185RodAUE') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1185RodAUE

SELECT	*
--INTO	tWO1185RodAUE
FROM
(
SELECT DISTINCT [Item No_] AS OldItem, [Usage Location] AS Location,
	LEFT([Item No_],11) + '02' + RIGHT([Item No_],1) AS NewItem --, [Posting date]
FROM	[Porteous$Actual Usage Entry] AUE
where	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50' AND
	[Usage Location] <> ''
--ORDER BY OldItem, Location
--ORDER BY [Posting date]
) AUE
WHERE EXISTS (SELECT * FROM [Porteous$Stockkeeping Unit] WHERE [Location Code]=Location AND [Item No_]=NewItem)
--WHERE NOT EXISTS (SELECT * FROM [Porteous$Stockkeeping Unit] WHERE [Location Code]=Location AND [Item No_]=NewItem)
ORDER BY OldItem, Location

--------------------------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tCheckRodItems') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tCheckRodItems

--SELECT Items for update
SELECT	DISTINCT OldSKU.[Item No_]--, OldSKU.[Location Code]
INTO	tCheckRodItems
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON	Item.[No_]=NewSKU.[Item No_]
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'
order by OldSKU.[Item No_]


--Find items with no covnersion factor
select * from tCheckRodItems
where NOT EXISTS (SELECT * FROM tRodFactor where [Item No_]=Item)

--------------------------------------------------------------------------------------------------------------


--Update Actual Usage Entry [Source Quantity] Positive Quantities
UPDATE	[Porteous$Actual Usage Entry]
SET	[Source Quantity] = ROUND(([Source Quantity] * RodFactor.UseFct),0)

--select  DISTINCT AUE.*
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
--WHERE	AUE.[Source Quantity] > 0
--order by AUE.[Item No_]



--Update Actual Usage Entry [Item No_], [Source Item No_] and [Variance No_]
UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_] = SUBSTRING(AUE.[Item No_],1,11) + '02' + SUBSTRING(AUE.[Item No_],14,1),
	[Source Item No_] = SUBSTRING([Source Item No_],1,11) + '02' + SUBSTRING([Source Item No_],14,1),
	[Variance No_] = '02' + SUBSTRING([Variance No_],3,1)
--select DISTINCT AUE.*
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item

------------------------------------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tRodItems') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tRodItems

--SELECT Items for update
SELECT	OldSKU.[Item No_], OldSKU.[Location Code]
INTO	tRodItems
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON	Item.[No_]=NewSKU.[Item No_]
INNER JOIN tRodFactor RodFactor
ON	OldSKU.[Item No_]=RodFactor.Item
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'





select * from tRodItems
where [Item No_]='00170-3002-501'
order by [Item No_]






if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tAUEBackup') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tAUEBackup

SELECT	AUE.*
--INTO	tAUEBackup
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
--INNER JOIN tRodFactor RodFactor
--ON	Rods.[Item No_]=RodFactor.Item




--Update Actual Usage Entry [Item No_], [Source Item No_] and [Variance No_]
UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_] = SUBSTRING(AUE.[Item No_],1,11) + '02' + SUBSTRING(AUE.[Item No_],14,1),
	[Source Item No_] = SUBSTRING([Source Item No_],1,11) + '02' + SUBSTRING([Source Item No_],14,1),
	[Variance No_] = '02' + SUBSTRING([Variance No_],3,1)

select *
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item