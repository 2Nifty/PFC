SELECT	SKU.[Reorder Point], SKU.[Sales Velocity Code], SKU.[Reorder Pt Change Policy], UPD.[Base ROP], SKU.*
FROM	[Porteous$Stockkeeping Unit] SKU INNER JOIN
	tWO1309_VarcoROPUpdates UPD
ON	SKU.[Item No_] = UPD.[Item No#]
WHERE	SKU.[Location Code] = '15'
--where [Item No_]='00050-2408-301' and [Location Code]='15'



UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point] = UPD.[Base ROP], --+ 0.3,
	[Sales Velocity Code] = 'S',
	[Reorder Pt Change Policy] = 2  --Special (.3)
FROM	[Porteous$Stockkeeping Unit] SKU INNER JOIN
	tWO1309_VarcoROPUpdates UPD
ON	SKU.[Item No_] = UPD.[Item No#]
WHERE	SKU.[Location Code] = '15'


UPDATE	[Porteous$Stockkeeping Unit]
SET	[Reorder Point] = SKU.[Reorder Point] + 0.3
FROM	[Porteous$Stockkeeping Unit] SKU INNER JOIN
	tWO1309_VarcoROPUpdates UPD
ON	SKU.[Item No_] = UPD.[Item No#]
WHERE	SKU.[Location Code] = '15'


--select * from tWO1309_VarcoROPUpdates




CREATE TABLE [tWO1309_VarcoROPUpdates] (
[Item No#] nvarchar (255) NULL, 
[Size No# Description] nvarchar (255) NULL, 
[Item Description] nvarchar (255) NULL, 
[Plating] nvarchar (255) NULL, 
[*Inventory] float NULL, 
[Reorder Point] float NULL, 
[Base ROP] float NULL )
