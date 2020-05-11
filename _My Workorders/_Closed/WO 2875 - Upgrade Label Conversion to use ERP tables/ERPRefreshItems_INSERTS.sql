--INSERT
SELECT	Porteous$Item.[No_] AS ItemNo, 
	Porteous$Item.[Description] AS ItemDesc,
	Porteous$Item.[Harmonizing Tariff Code] AS Tariff,
	Porteous$Item.[Cat_ No_ Description] AS CatDesc,
	Porteous$Item.[Plating Type] AS Finish,
	Porteous$Item.[Size No_ Description] AS ItemSize,
	Porteous$Item.[Item Disc_ Group] as PriceCat,
	Porteous$Item.[Super Equiv_ Qty_] * Porteous$Item.[Qty__Base UOM] AS PcsPerPallet,
	Porteous$Item.[Base Unit of Measure] AS SellStkUM,
	Porteous$Item.[Qty__Base UOM] AS SellStkUMQty,
	Porteous$Item.[Super Equiv_ UOM] AS SuperUM,
	Porteous$Item.[Base Unit of Measure] AS StkUM,
	Porteous$Item.[Net Weight] AS Wght,
	Porteous$Item.[Gross Weight] AS GrossWght,
	Porteous$Item.[Gross Weight] * [Super Equiv_ Qty_] AS CUMGrossWght,
	Porteous$Item.[Net Weight] * [Super Equiv_ Qty_] AS CUMNetWght,
	Porteous$Item.[Weight_100] AS HundredWght,
	Porteous$Item.[UPC Code] AS UPCCd,
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
	Porteous$Item.[LengthDesc] AS LengthDesc,
	Porteous$Item.[Routing No_] AS BoxSize,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 1],40) as CategoryDescAlt1,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 2],40) as CategoryDescAlt2,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 3],40) as CategoryDescAlt3,
	Porteous$Item.[Size No_ Description Alt_ 1] as SizeDescAlt1,
	Porteous$Item.[Customer No_] as CustNo

FROM	Porteous$Item
WHERE	Porteous$Item.No_ <> '' AND NOT EXISTS
	(SELECT	ItemNo
	 FROM 	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.ItemMaster
	 WHERE	[No_] = ItemNo COLLATE Latin1_General_CS_AS)
ORDER BY [No_]
