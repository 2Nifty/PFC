select DiameterDesc, LengthDesc, ChangeDt, *
from PFCReports.dbo.tItemMaster
where --pitemMasterID <10
ItemNo in 
('00020-2408-000',
'00020-2408-001',
'00020-2408-020',
'00020-2408-021',
'00020-2408-022',
'00020-2408-030',
'00020-2408-031',
'00020-2408-201',
'00020-2408-400')


delete from PFCReports.dbo.tItemMaster
where pitemMasterID <10


update [Porteous$Item]
set DiameterDesc='DIA', LengthDesc='LEN'
where [No_]='00020-2408-400'


select DiameterDesc, LengthDesc, *
from PFCLive.dbo.[Porteous$Item]



00020-2408-000
00020-2408-001
00020-2408-020
00020-2408-021
00020-2408-022
00020-2408-030
00020-2408-031
00020-2408-201
00020-2408-400





SELECT	Porteous$Item.[No_] AS ItemNo, 
--	isnull((SELECT	MAX([No_])
--		FROM	[Porteous$Production BOM Line]
--		WHERE	[Line No_] = 10000 AND [Porteous$Production BOM Line].[Production BOM No_] = [Porteous$Item].[No_]),'') AS ParentProdNo,
	Porteous$Item.[Description] AS ItemDesc,
	'S' AS ItemStat,
	'N' AS Rectrans,
	'' AS Specification,
	Porteous$Item.[Harmonizing Tariff Code] AS Tariff,
	Porteous$Item.[Cat_ No_ Description] AS CatDesc,
	Porteous$Item.[Plating Type] AS Finish,
	Porteous$Item.[Size No_ Description] AS ItemSize,
	Porteous$Item.[Item Disc_ Group] as PriceCat,
	Porteous$Item.[Super Equiv_ Qty_] * Porteous$Item.[Qty__Base UOM] AS PcsPerPallet,
	Porteous$Item.[Base Unit of Measure] AS SellStkUM,
	Porteous$Item.[Qty__Base UOM] AS SellStkUMQty,
--	isnull((SELECT	MAX([Purchase Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Purchase Qty Alt_] = 1),'') AS CostPurUM,
--	isnull((SELECT	MAX([Purchase Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Purchase Qty Alt_] = 1),'') AS PriceUM,
	Porteous$Item.[Super Equiv_ UOM] AS SuperUM,
--	isnull((SELECT	MAX([Sales Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Sales Qty Alt_] = 1),'') AS SellUM,
--	isnull((SELECT	MAX(Code)
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND Code = 'SL'),'') AS SleeveUM,
	Porteous$Item.[Base Unit of Measure] AS StkUM,
	Porteous$Item.[Net Weight] AS Wght,
	Porteous$Item.[Gross Weight] AS GrossWght,
	Porteous$Item.[Gross Weight] * [Super Equiv_ Qty_] AS CUMGrossWght,
	Porteous$Item.[Net Weight] * [Super Equiv_ Qty_] AS CUMNetWght,
	Porteous$Item.[Weight_100] AS HundredWght,
	Porteous$Item.[UPC Code] AS UPCCd,
	'50' AS CommodityCd,
	'N' AS SerialNoCd,
	'N' AS FormatCd,
	Porteous$Item.[Hazardous] AS HazMatInd,
	Porteous$Item.[Web Enabled] AS WebEnabledInd,
	Porteous$Item.[Corp Fixed Velocity Code] AS CorpFixedVelocity,
	Porteous$Item.[Date Created] AS EntryDt,
	'WO1481' AS EntryID,
	Porteous$Item.[Last Date Modified] AS ChangeDt,
	Porteous$Item.[Category Velocity Code] AS CatVelocityCd,
	Porteous$Item.[Unit Price] AS ListPrice,
	Porteous$Item.[PriceWorkSheetColorInd] AS PriceWorkSheetColorInd,
	Porteous$Item.[Package Grouping] AS PackageGroup,
	Porteous$Item.[Item Group Code] AS ItemPriceGroup,
	Porteous$Item.[Cert] AS CertRequiredInd,
	Porteous$Item.[PPI Code] AS PPICode,
	Porteous$Item.[FQA] AS QualityInd,
	Porteous$Item.[LowProfilePalletPQty] AS LowProfilePalletQty,
	Porteous$Item.[DiameterDesc] AS DiameterDesc,
	Porteous$Item.[LengthDesc] AS LengthDesc
FROM	Porteous$Item
WHERE	Porteous$Item.No_ <> '' AND NOT EXISTS
	(SELECT	ItemNo
	 FROM 	PFCReports.dbo.tItemMaster
	 WHERE	[No_] = ItemNo COLLATE Latin1_General_CS_AS)
ORDER BY [No_]







UPDATE	PFCReports.dbo.tItemMaster
SET	--ParentProdNo = isnull((SELECT	MAX([No_])
	--		       FROM	[Porteous$Production BOM Line]
	--		       WHERE	[Line No_] = 10000 AND [Porteous$Production BOM Line].[Production BOM No_] = Item.[No_]),''),
	ItemDesc = Item.Description,
	--ItemStat = 'S',
	--Rectrans = 'N',
	--Specification = '',
	Tariff = Item.[Harmonizing Tariff Code],
	CatDesc = Item.[Cat_ No_ Description],
	Finish = Item.[Plating Type],
	ItemSize = Item.[Size No_ Description],
	PriceCat = Item.[Item Disc_ Group],
	PcsPerPallet = Item.[Super Equiv_ Qty_] * Item.[Qty__Base UOM],
	SellStkUM  = Item.[Base Unit of Measure],
	SellStkUMQty = Item.[Qty__Base UOM],
	--CostPurUM = isnull((SELECT  MAX([Purchase Price Per Alt_])
	--		    FROM    [Porteous$Item Unit of Measure]
	--		    WHERE   [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Purchase Qty Alt_] = 1),''),
	--PriceUM = isnull((SELECT MAX([Purchase Price Per Alt_])
	--		  FROM   [Porteous$Item Unit of Measure]
	--		  WHERE  [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Purchase Qty Alt_]= 1),''),
	SuperUM = Item.[Super Equiv_ UOM],
	--SellUM = isnull((SELECT	MAX([Sales Price Per Alt_])
	--		 FROM	[Porteous$Item Unit of Measure]
	--		 WHERE	[Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Sales Qty Alt_] = 1),''),
	--SleeveUM = isnull((SELECT MAX(Code)
	--		   FROM   [Porteous$Item Unit of Measure]
	--		   WHERE  [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Code] = 'SL'),''),
	StkUM = Item.[Base Unit of Measure],
	Wght = Item.[Net Weight],
	GrossWght = Item.[Gross Weight],
	CUMGrossWght = Item.[Gross Weight] * [Super Equiv_ Qty_],
	CUMNetWght = Item.[Net Weight] * [Super Equiv_ Qty_],
	HundredWght = Item.[Weight_100],
	UPCCd = Item.[UPC Code],
	--CommodityCd = '50',
	--SerialNoCd = 'N',
	--FormatCd = 'N',
	HazMatInd = Item.[Hazardous],
	WebEnabledInd = Item.[Web Enabled],
	CorpFixedVelocity = Item.[Corp Fixed Velocity Code],
	EntryDt = Item.[Date Created],
	ChangeDt = Item.[Last Date Modified],
	ChangeID = 'WO1481',
	CatVelocityCd = Item.[Category Velocity Code],
	ListPrice = Item.[Unit Price],
	PriceWorkSheetColorInd = Item.[PriceWorkSheetColorInd],
	PackageGroup = Item.[Package Grouping],
	ItemPriceGroup = Item.[Item Group Code],
	CertRequiredInd = Item.[Cert],
	PPICode = Item.[PPI Code],
	QualityInd = Item.[FQA],
	LowProfilePalletQty = Item.[LowProfilePalletPQty],
	DiameterDesc = Item.[DiameterDesc],
	LengthDesc = Item.[LengthDesc]
FROM	Porteous$Item Item

select Item.DiameterDesc, Item.LengthDesc, * from PFCReports.dbo.tItemMaster inner join Porteous$Item Item on ItemNo=[No_] COLLATE Latin1_General_CS_AS
WHERE	Item.[No_] = ItemNo COLLATE Latin1_General_CS_AS AND Item.[Last Date Modified] > '1900-01-01' AND
	(CONVERT(datetime, Item.[Last Date Modified], 112) > CONVERT(datetime, ChangeDt, 112) OR ChangeDt is null)



update Porteous$Item --set [Last Date Modified]=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
set DiameterDesc='DIA', LengthDesc='LEN'
where No_='00020-2408-022'


where [No_] in
('00020-2408-000',
'00020-2408-001',
'00020-2408-020',
'00020-2408-021',
'00020-2408-022',
'00020-2408-030',
'00020-2408-031',
'00020-2408-201',
'00020-2408-400')