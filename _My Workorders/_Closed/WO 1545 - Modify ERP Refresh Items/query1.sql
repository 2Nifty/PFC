UPDATE	PFCReports.dbo.ItemUM
SET	--fItemMasterID = pItemMasterID,
	--UM = NVUOM.[Code], 
	AltSellStkUMQty = NVUOM.[Alt_ Base Qty_],
	QtyPerUM = NVUOM.[Qty_ per Unit of Measure],
	--UnitsPerUnit = 1,
	Weight = NVUOM.Weight,
	Volume = NVUOM.Cubage, 
	--SequenceNo = 1,
	ChangeID = 'WO1481',
	ChangeDt = NVUOM.[Last Date Modified]
	--StatusCd = '0'
FROM	[Porteous$Item Unit of Measure] NVUOM INNER JOIN
	[Porteous$Item] 
ON	NVUOM.[Item No_] = [Porteous$Item].[No_] INNER JOIN
	PFCReports.dbo.ItemMaster Item
ON	NVUOM.[Item No_] = Item.ItemNo COLLATE Latin1_General_CS_AS INNER JOIN
	PFCReports.dbo.ItemUM UM
ON	Item.pItemMasterID = UM.fItemMasterID
WHERE	NVUOM.[Code] = UM.UM COLLATE Latin1_General_CS_AS AND NVUOM.[Last Date Modified] > '1900-01-01' AND
	(CONVERT(datetime, NVUOM.[Last Date Modified], 112) > CONVERT(datetime, UM.ChangeDt, 112) OR UM.ChangeDt is null)





UPDATE	PFCReports.dbo.ItemMaster
SET	ParentProdNo = isnull((SELECT	MAX([Production BOM No_])
			       FROM	[Porteous$Production BOM Line]
			       WHERE	[Line No_] = 10000 AND [Porteous$Production BOM Line].[No_] = Item.[No_]),''),
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
	CostPurUM = isnull((SELECT  MAX([Purchase Price Per Alt_])
			    FROM    [Porteous$Item Unit of Measure]
			    WHERE   [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Purchase Qty Alt_] = 1),''),
	PriceUM = isnull((SELECT MAX([Purchase Price Per Alt_])
			  FROM   [Porteous$Item Unit of Measure]
			  WHERE  [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Purchase Qty Alt_]= 1),''),
	SuperUM = Item.[Super Equiv_ UOM],
	SellUM = isnull((SELECT	MAX([Sales Price Per Alt_])
			 FROM	[Porteous$Item Unit of Measure]
			 WHERE	[Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Sales Qty Alt_] = 1),''),
	SleeveUM = isnull((SELECT MAX(Code)
			   FROM   [Porteous$Item Unit of Measure]
			   WHERE  [Porteous$Item Unit of Measure].[Item No_] = Item.[No_] AND [Code] = 'SL'),''),
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
	QualityInd = Item.[FQA]
FROM	Porteous$Item Item
WHERE	Item.[No_] = ItemNo COLLATE Latin1_General_CS_AS AND Item.[Last Date Modified] > '1900-01-01' AND
	(CONVERT(datetime, Item.[Last Date Modified], 112) > CONVERT(datetime, ChangeDt, 112) OR ChangeDt is null)








--626768 records
select count(*) from PFCReports.dbo.ItemUM



select * from PFCReports.dbo.ItemMaster 
where ItemNo='00020-2408-000' or ItemNo='00020-2408-001'

select ChangeDt, ChangeID, * from PFCReports.dbo.ItemUM
where fItemMasterID=1 or fItemMasterID=2

--update PFCReports.dbo.ItemUM
--set ChangeDt=null, ChangeID=null
--where fItemMasterID=1 or fItemMasterID=2

select [Last Date Modified], * from [Porteous$Item Unit of Measure]
where [Item No_]='00020-2408-000' or [Item No_]='00020-2408-001'


update  [Porteous$Item Unit of Measure]
set [Last Date Modified]= CAST(FLOOR(CAST(GetDate() AS FLOAT))AS DATETIME)
where ([Item No_] ='00020-2408-000' and Code='KG') or ([Item No_] ='00020-2408-001' and Code='M')

select distinct ChangeDt from PFCReports.dbo.ItemUm order by ChangeDt
select distinct [Last Date Modified] from [Porteous$Item Unit of Measure]

update [Porteous$Item Unit of Measure]
set [Last Date Modified]= '1753-01-01'
where [Last Date Modified] > '1900-01-01'