
select * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170') and SUBSTRING([Item No_],12,2)='02'
order by [Item No_]



select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170') and SUBSTRING([Item No_],12,2)='50'



select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00170') and SUBSTRING([Item No_],12,2)='02'




select LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1) AS CheckItem02, CheckItem50, OldSKU.[Reorder Point], Rod.UseFct, * from [Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
FULL OUTER JOIN
tRodFactor Rod
ON NewSKU.[Item No_]=Rod.Item
where (LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
				    LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'
				    AND OldSKU.[Reorder Point] NOT LIKE '%.8%'




UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND((OldSKU.[Reorder Point] * .02),0)
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] NOT LIKE '%.8%'

UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=1
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] NOT LIKE '%.8%' AND NewSKU.[Reorder Point] < 1












select * from [Porteous$Item] where (LEFT([No_],5)='00170' or LEFT([No_],5)='00170' or LEFT([No_],5)='00170' or
				    LEFT([No_],5)='00170' or LEFT([No_],5)='00170') and SUBSTRING([No_],12,2)='50'
order by [No_]

select * from [Porteous$Item] where (LEFT([No_],5)='00170' or LEFT([No_],5)='00170' or LEFT([No_],5)='00170' or
				    LEFT([No_],5)='00170' or LEFT([No_],5)='00170') and SUBSTRING([No_],12,2)='02'
order by [No_]




Insert into [Porteous$Stockkeeping Unit]
SELECT     *
FROM         [Porteous$Stockkeeping Unit]
WHERE     ([Item No_] = '00170-0603-501')














SELECT	LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1) AS CheckItem02, CheckItem50, NewSKU.[Reorder Point], Rod.UseFct, *
FROM	[Porteous$Stockkeeping Unit] OldSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') NewSKU
ON (LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1)=CheckItem50) AND OldSKU.[Location Code]=NewSKU.[Location Code]
INNER JOIN
tRodFactor Rod
ON NewSKU.[Item No_]=Rod.Item
where (LEFT(OldSKU.[Item No_],5)='00170' or LEFT(OldSKU.[Item No_],5)='00171' or LEFT(OldSKU.[Item No_],5)='04170' or
				    LEFT(OldSKU.[Item No_],5)='04171' or LEFT(OldSKU.[Item No_],5)='04172') and SUBSTRING(OldSKU.[Item No_],12,2)='02'
				    AND NewSKU.[Reorder Point] LIKE '%.8%'



--Update [Reorder Point] when ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=ROUND((NewSKU.[Reorder Point] * Rod.UseFct),0)
FROM	[Porteous$Stockkeeping Unit] OldSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') NewSKU
ON (LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1)=CheckItem50) AND OldSKU.[Location Code]=NewSKU.[Location Code]
INNER JOIN tRodFactor Rod
ON NewSKU.[Item No_]=Rod.Item
WHERE	(LEFT(OldSKU.[Item No_],5)='00170' or LEFT(OldSKU.[Item No_],5)='00171' or LEFT(OldSKU.[Item No_],5)='04170' or
	 LEFT(OldSKU.[Item No_],5)='04171' or LEFT(OldSKU.[Item No_],5)='04172') and SUBSTRING(OldSKU.[Item No_],12,2)='02' and
	 NewSKU.[Reorder Point] LIKE '%.8%'

--Set [Reorder Point]=.8 when < 1 and ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=.8
FROM	[Porteous$Stockkeeping Unit] OldSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') NewSKU
ON (LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1)=CheckItem50) AND OldSKU.[Location Code]=NewSKU.[Location Code]
WHERE	(LEFT(OldSKU.[Item No_],5)='00170' or LEFT(OldSKU.[Item No_],5)='00171' or LEFT(OldSKU.[Item No_],5)='04170' or
	 LEFT(OldSKU.[Item No_],5)='04171' or LEFT(OldSKU.[Item No_],5)='04172') and SUBSTRING(OldSKU.[Item No_],12,2)='02' and
	 NewSKU.[Reorder Point] LIKE '%.8%' AND OldSKU.[Reorder Point] < 1

--Add +.8 to [Reorder Point] when > 1 and ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=OldSKU.[Reorder Point] + 0.8
FROM	[Porteous$Stockkeeping Unit] OldSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') NewSKU
ON (LEFT(OldSKU.[Item No_],11) + RIGHT(OldSKU.[Item No_],1)=CheckItem50) AND OldSKU.[Location Code]=NewSKU.[Location Code]
WHERE	(LEFT(OldSKU.[Item No_],5)='00170' or LEFT(OldSKU.[Item No_],5)='00171' or LEFT(OldSKU.[Item No_],5)='04170' or
	 LEFT(OldSKU.[Item No_],5)='04171' or LEFT(OldSKU.[Item No_],5)='04172') and SUBSTRING(OldSKU.[Item No_],12,2)='02' and
	 NewSKU.[Reorder Point] LIKE '%.8%' AND OldSKU.[Reorder Point] > 1


















select * from [Porteous$Item]



--SELECT Items for update
SELECT	LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1) AS CheckItem02, CheckItem50,
	OldSKU.[Sales Velocity Code], NewSKU.[Sales Velocity Code] AS NewSVC, OldSKU.[Stock], NewSKU.[Stock] AS NewCode,
	Item.[No_] as NewItem, Item.[Web Enabled],
	*
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON Item.[No_]=NewSKU.[Item No_]
where (LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
				    LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'



--Update Web Enabled
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 1
FROM	[Porteous$Item] Item
INNER JOIN
(SELECT	*
FROM	[Porteous$Stockkeeping Unit]) NewSKU
ON Item.[No_]=NewSKU.[Item No_]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Location Code]=01 and NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'



--Update [Sales Velocity Code]
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Sales Velocity Code]=OldSKU.[Sales Velocity Code]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
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
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'





--Set [Reorder Point]=1 when < 1 and not ending in .8
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point]=1
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
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
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN tRodFactor Rod
ON OldSKU.[Item No_]=Rod.Item
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
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
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
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 OldSKU.[Reorder Point] LIKE '%.8%' AND NewSKU.[Reorder Point] > 1








--Update [Standard Cost], [Unit Cost] & [Last Direct Cost] from [Porteous$Item]
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Standard Cost]=Item.[Standard Cost], [Unit Cost]=Item.[Unit Cost], [Last Direct Cost]=Item.[Last Direct Cost]
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(SELECT	LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, *
 FROM	[Porteous$Stockkeeping Unit]
 WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON NewSKU.[Item No_]=Item.[No_]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'





select * from [Porteous$Actual Usage Entry]








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

select * from tRodItems



UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_] = SUBSTRING(AUE.[Item No_],1,11) + '02' + SUBSTRING(AUE.[Item No_],14,1),
	[Source Item No_] = SUBSTRING([Source Item No_],1,11) + '02' + SUBSTRING([Source Item No_],14,1),
	[Variance No_] = '02' + SUBSTRING([Variance No_],3,1) --,
	--[Source Quantity] = ROUND(([Source Quantity] * RodFactor.UseFct),0), [Quantity] = ROUND(([Quantity] * RodFactor.UseFct),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item

