
--SELECT Items for update
SELECT	LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1) AS CheckItem02, CheckItem50,
	OldSKU.[Sales Velocity Code], NewSKU.[Sales Velocity Code] AS NewSVC, OldSKU.[Stock], NewSKU.[Stock] AS NewCode,
	Item.[No_] as NewItem, NewSKU.[Location Code], Item.[Web Enabled], Item.[Standard Cost] AS [Item.Standard Cost], NewSKU.[Standard Cost],
	Item.[Unit Cost] AS [Item.Unit Cost], NewSKU.[Unit Cost],
	Item.[Last Direct Cost] AS [Item.Last Direct Cost], NewSKU.[Last Direct Cost],
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







SELECT	*
FROM	[Porteous$Stockkeeping Unit]
WHERE	(LEFT([Item No_],5)='00170' or LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or
	 LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and SUBSTRING([Item No_],12,2)='02'
-- and
--	 [Location Code]=01 and [Sales Velocity Code] >= 'A' and [Sales Velocity Code] <= 'K'





--Update Web Enabled
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 1
FROM	[Porteous$Item] Item
INNER JOIN
(SELECT	*
FROM	[Porteous$Stockkeeping Unit]) NewSKU
ON Item.[No_]=NewSKU.[Item No_]
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON (LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
WHERE	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02' and
	 NewSKU.[Location Code]=01 and NewSKU.[Sales Velocity Code] >= 'A' and NewSKU.[Sales Velocity Code] <= 'K'


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