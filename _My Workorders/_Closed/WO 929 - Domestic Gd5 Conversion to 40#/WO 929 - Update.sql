
--Set [Web Enabled] on NewItem
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 1
FROM
(SELECT	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) AS CheckItem04, CheckItem02,
	OldItem.[No_] AS OldItem, NewItem.[No_] AS NewItem,
	OldItem.[Web Enabled] AS OldWebEnabled, NewItem.[Web Enabled] AS NewWebEnabled
 FROM	[Porteous$Item] NewItem
INNER JOIN
(SELECT	LEFT([No_],11) + RIGHT([No_],1) AS CheckItem02, *
 FROM	[Porteous$Item]
 WHERE SUBSTRING([No_],12,2)='02') OldItem
ON	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) = CheckItem02
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewItem.[No_] = [40Lb].[Item]) ItemUpd
WHERE	OldWebEnabled = 1 and [No_]=NewItem

--Set [Web Enabled]=0 on OldItem
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 0
FROM
(SELECT	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) AS CheckItem04, CheckItem02,
	OldItem.[No_] AS OldItem, NewItem.[No_] AS NewItem,
	OldItem.[Web Enabled] AS OldWebEnabled, NewItem.[Web Enabled] AS NewWebEnabled
 FROM	[Porteous$Item] NewItem
INNER JOIN
(SELECT	LEFT([No_],11) + RIGHT([No_],1) AS CheckItem02, *
 FROM	[Porteous$Item]
 WHERE SUBSTRING([No_],12,2)='02') OldItem
ON	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) = CheckItem02
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewItem.[No_] = [40Lb].[Item]) ItemUpd
WHERE	[No_]=OldItem



--Update [Sales Velocity Code]
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Sales Velocity Code]=OldSKU.[Sales Velocity Code]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]

--Update [Sales Velocity Code]='N' on OldSKU
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Sales Velocity Code]='N'
FROM	[Porteous$Stockkeeping Unit] OldSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem04, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='04') NewSKU
ON	(LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1)=CheckItem04) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]
WHERE	SUBSTRING(OldSKU.[Item No_],12,2)='02'



--Update [Stock] Code
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Stock]=OldSKU.[Stock]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]



--Update [Reorder Point] when not ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND((OldSKU.[Reorder Point] * 1.25),0)
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]
WHERE	OldSKU.[Reorder Point] NOT LIKE '%.8%'

--Update [Reorder Point] when ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND(((OldSKU.[Reorder Point] - 0.8) * 1.25),0)
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]
WHERE	OldSKU.[Reorder Point] LIKE '%.8%'

--Update [Reorder Point] to end in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=NewSKU.[Reorder Point] + 0.8
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, *
 FROM [Porteous$Stockkeeping Unit]
 WHERE	SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].t40PoundSKU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t40PoundSKU

--SELECT AUE Items for update
SELECT	OldSKU.[Item No_] AS OldItem, OldSKU.[Location Code] AS OldLoc
INTO	t40PoundSKU
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, * from [Porteous$Stockkeeping Unit]
 where SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]



--Backup AUE Items
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tAUEBackupGrade5') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tAUEBackupGrade5

SELECT	AUE.*
INTO	tAUEBackupGrade5
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	t40PoundSKU) [40Lb]
ON	AUE.[Item No_]=[40Lb].[OldItem] and AUE.[Usage Location]=[40Lb].[OldLoc]


--Update Actual Usage Entry [Item No_], [Source Item No_] and [Variance No_]
UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_] = SUBSTRING(AUE.[Item No_],1,11) + '04' + SUBSTRING(AUE.[Item No_],14,1),
	[Source Item No_] = SUBSTRING([Source Item No_],1,11) + '04' + SUBSTRING([Source Item No_],14,1),
	[Variance No_] = '04' + SUBSTRING([Variance No_],3,1),
	[Source Quantity] = ROUND(([Source Quantity] * 1.25),0),
	[Quantity] = ROUND(([Quantity] * 1.25),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	t40PoundSKU) [40Lb]
ON	AUE.[Item No_]=[40Lb].[OldItem] and AUE.[Usage Location]=[40Lb].[OldLoc]









--Update SODetailHist Invoice History
UPDATE	PFCReports.[dbo].SODetailHist
SET	[ItemNo] = SUBSTRING([ItemNo],1,11) + '04' + SUBSTRING([ItemNo],14,1),
	[QtyShipped] = ROUND(([QtyShipped] * 1.25),0),
	[QtyOrdered] = ROUND(([QtyOrdered] * 1.25),0)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	t40PoundSKU) [40Lb]
ON	[ItemNo]=[40Lb].[OldItem] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=[40Lb].[OldLoc] COLLATE SQL_Latin1_General_CP1_CI_AS