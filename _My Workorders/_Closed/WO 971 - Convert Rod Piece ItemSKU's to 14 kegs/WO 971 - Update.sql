
--SELECT Items for update
SELECT	LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1) AS CheckItem02, CheckItem50,
	OldSKU.[Sales Velocity Code], NewSKU.[Sales Velocity Code] AS NewSVC, OldSKU.[Stock], NewSKU.[Stock] AS NewStockCode,
	Item.[No_] as NewItem, NewSKU.[Location Code], Item.[Web Enabled], Item.[Standard Cost] AS [Item.Standard Cost], NewSKU.[Standard Cost],
	Item.[Unit Cost] AS [Item.Unit Cost], NewSKU.[Unit Cost],
	Item.[Last Direct Cost] AS [Item.Last Direct Cost], NewSKU.[Last Direct Cost],
	*
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




Select * from [Porteous$Stockkeeping Unit] where [Item No_]='00170-0603-501'
Select * from [Porteous$Stockkeeping Unit] where [Item No_]='00170-0603-021'




--SELECT AUE Items for update
SELECT	LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1) AS CheckItem02, CheckItem50,
	OldSKU.[Sales Velocity Code], NewSKU.[Sales Velocity Code] AS NewSVC, OldSKU.[Stock], NewSKU.[Stock] AS NewStockCode,
	AUE.[Item No_] as AUEItem, AUE.[Usage Location], NewSKU.[Location Code], 
	*
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Actual Usage Entry] AUE
ON	AUE.[Item No_]=OldSKU.[Item No_] and AUE.[Usage Location]=OldSKU.[Location Code]
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'

--Verify AUE Update
Select * from [Porteous$Actual Usage Entry] where [Item No_]='00170-0603-021' and ([Usage Location]=01 or [Usage Location]=02 or [Usage Location]=08)  


SELECT	ItemNo, QtyShipped, QtyOrdered, UsageLoc, PFCReports.[dbo].SODetailHist.*
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
where	[ItemNo]='00170-0603-021'
and ([UsageLoc]=01 or [UsageLoc]=02 or [UsageLoc]=08)  


----------Reorder points-------------------------


--Update [Reorder Point] when not ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND((OldSKU.[Reorder Point] * Rod.UseFct),0)
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN tRodFactor Rod
ON	OldSKU.[Item No_]=Rod.Item
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] NOT LIKE '%.8%'

--Set [Reorder Point]=1 when < 1 and not ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=1
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] NOT LIKE '%.8%' AND NewSKU.[Reorder Point] < 1


--Update [Reorder Point] when ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND((OldSKU.[Reorder Point] * Rod.UseFct),0)
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN tRodFactor Rod
ON	OldSKU.[Item No_]=Rod.Item
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] LIKE '%.8%'

--Set [Reorder Point]=.8 when < 1 and ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=.8
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] LIKE '%.8%' AND NewSKU.[Reorder Point] < 1

--Add +.8 to [Reorder Point] when > 1 and ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=NewSKU.[Reorder Point] + 0.8
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] LIKE '%.8%' AND NewSKU.[Reorder Point] > 1




----------SVC & Stock Codes----------------------


--Update [Sales Velocity Code]
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Sales Velocity Code]=OldSKU.[Sales Velocity Code]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'

--Update [Stock]=1 when New Sales Velocity Code is A-K
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Stock]=1
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'

--Update [Stock]=0 when New Sales Velocity Code is NOT A-K
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Stock]=0
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	(NewSKU.[Sales Velocity Code] < 'A' or NewSKU.[Sales Velocity Code] > 'K')





----------Web Enabled----------------------------


--Update [Web Enabled]=1 when New Sales Velocity for Loc 01 is A-K
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 1
FROM	[Porteous$Item] Item
INNER JOIN
(SELECT	*
FROM	[Porteous$Stockkeeping Unit]) NewSKU
ON	Item.[No_]=NewSKU.[Item No_]
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Location Code]=01 and NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'

--Update [Web Enabled]=0 when New Sales Velocity for Loc 01 is NOT A-K
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 0
FROM	[Porteous$Item] Item
INNER JOIN
(SELECT	*
FROM	[Porteous$Stockkeeping Unit]) NewSKU
ON	Item.[No_]=NewSKU.[Item No_]
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Location Code]=01 and (NewSKU.[Sales Velocity Code] < 'A' or NewSKU.[Sales Velocity Code] > 'K')

--
--UPDATE	[Porteous$Item]
--SET	[Web Enabled] = 1
--FROM	[Porteous$Item] Item
--INNER JOIN
--(SELECT	*
--FROM	[Porteous$Stockkeeping Unit]) NewSKU
--ON Item.[No_]=NewSKU.[Item No_]
--WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
--	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
--	 NewSKU.[Location Code]=01 and NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'
--





----------Costs----------------------------------


--Update [Standard Cost], [Unit Cost] & [Last Direct Cost] from [Porteous$Item]
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Standard Cost]=Item.[Standard Cost], [Unit Cost]=Item.[Unit Cost], [Last Direct Cost]=Item.[Last Direct Cost]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON	NewSKU.[Item No_]=Item.[No_]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'





----------AUE------------------------------------


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
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'

--select * from tRodItems


--might have to do one pass to update the Quantities * RodFactor
--one pass to update the quantities that come out less than 1
--final pass to update the item numbers



--Update Actual Usage Entry [Source Quantity] Positive Quantities
UPDATE	[Porteous$Actual Usage Entry]
SET	[Source Quantity] = ROUND(([Source Quantity] * RodFactor.UseFct),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	AUE.[Source Quantity] > 0

--Update Actual Usage Entry [Source Quantity] = 1 when [Source Quantity] = 0
UPDATE	[Porteous$Actual Usage Entry]
SET	[Source Quantity] = 1
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
WHERE	AUE.[Source Quantity] = 0

--Update Actual Usage Entry [Source Quantity] Negative Quantities
UPDATE	[Porteous$Actual Usage Entry]
SET	[Source Quantity] = ROUND(([Source Quantity] * RodFactor.UseFct),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	AUE.[Source Quantity] < 0

--Update Actual Usage Entry [Source Quantity] = -1 when [Source Quantity] = 0
UPDATE	[Porteous$Actual Usage Entry]
SET	[Source Quantity] = -1
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
WHERE	AUE.[Source Quantity] = 0


--Update Actual Usage Entry [Quantity] Positive Quantities
UPDATE	[Porteous$Actual Usage Entry]
SET	[Quantity] = ROUND(([Quantity] * RodFactor.UseFct),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	AUE.[Quantity] > 0

--Update Actual Usage Entry [Quantity] = 1 when [Quantity] = 0
UPDATE	[Porteous$Actual Usage Entry]
SET	[Quantity] = 1
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
WHERE	AUE.[Quantity] = 0

--Update Actual Usage Entry [Quantity] Negative Quantities
UPDATE	[Porteous$Actual Usage Entry]
SET	[Quantity] = ROUND(([Quantity] * RodFactor.UseFct),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	AUE.[Quantity] < 0

--Update Actual Usage Entry [Quantity] = -1 when [Quantity] = 0
UPDATE	[Porteous$Actual Usage Entry]
SET	[Quantity] = -1
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
WHERE	AUE.[Quantity] = 0

--Update Actual Usage Entry [Item No_], [Source Item No_] and [Variance No_]
UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_] = SUBSTRING(AUE.[Item No_],1,11) + '02' + SUBSTRING(AUE.[Item No_],14,1),
	[Source Item No_] = SUBSTRING([Source Item No_],1,11) + '02' + SUBSTRING([Source Item No_],14,1),
	[Variance No_] = '02' + SUBSTRING([Variance No_],3,1)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]




SELECT	*
--INTO	PFCReports.[dbo].tSODetailZeroShipped
FROM	PFCReports.[dbo].SODetailHist
WHERE	(LEFT([ItemNo],5)='00170' or LEFT([ItemNo],5)='00171' or LEFT([ItemNo],5)='04170' or LEFT([ItemNo],5)='04171' or LEFT([ItemNo],5)='04172') and
	 SUBSTRING([ItemNo],12,2)='50' and [QtyShipped]=0

SELECT	*
--INTO	PFCReports.[dbo].tSODetailZeroOrdered
FROM	PFCReports.[dbo].SODetailHist
WHERE	(LEFT([ItemNo],5)='00170' or LEFT([ItemNo],5)='00171' or LEFT([ItemNo],5)='04170' or LEFT([ItemNo],5)='04171' or LEFT([ItemNo],5)='04172') and
	 SUBSTRING([ItemNo],12,2)='50' and [QtyOrdered]=0



--Update Invoice History [QtyShipped] Positive Quantities
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyShipped] = ROUND(([QtyShipped] * RodFactor.UseFct),0)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	[QtyShipped] > 0

--Update Invoice History [QtyShipped] = 1 when [QtyShipped] = 0
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyShipped] = 1
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	[QtyShipped] = 0 and
	NOT EXISTS (SELECT * FROM PFCReports.[dbo].tSODetailZeroShipped)

--Update Invoice History [QtyShipped] Negative Quantities
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyShipped] = ROUND(([QtyShipped] * RodFactor.UseFct),0)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	[QtyShipped] < 0

--Update Invoice History [QtyShipped] = -1 when [QtyShipped] = 0
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyShipped] = -1
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	[QtyShipped] = 0 and
	NOT EXISTS (SELECT * FROM PFCReports.[dbo].tSODetailZeroShipped)


--Update Invoice History [QtyOrdered] Positive Quantities
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyOrdered] = ROUND(([QtyOrdered] * RodFactor.UseFct),0)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	[QtyOrdered] > 0

--Update Invoice History [QtyOrdered] = 1 when [QtyOrdered] = 0
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyOrdered] = 1
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	[QtyOrdered] = 0 and
	NOT EXISTS (SELECT * FROM PFCReports.[dbo].tSODetailZeroOrdered)

--Update Invoice History [QtyOrdered] Negative Quantities
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyOrdered] = ROUND(([QtyOrdered] * RodFactor.UseFct),0)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
WHERE	[QtyOrdered] < 0

--Update Invoice History [QtyOrdered] = -1 when [QtyOrdered] = 0
UPDATE	PFCReports.[dbo].SODetailHist
SET	[QtyOrdered] = -1
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	[QtyOrdered] = 0 and
	NOT EXISTS (SELECT * FROM PFCReports.[dbo].tSODetailZeroOrdered)





--Update Invoice History [ItemNo]
UPDATE	PFCReports.[dbo].SODetailHist
SET	[ItemNo] = SUBSTRING([ItemNo],1,11) + '02' + SUBSTRING([ItemNo],14,1)
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
