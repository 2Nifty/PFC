--UPDATE
UPDATE	PFCReports.dbo.ItemMaster
SET
		ItemDesc = Item.Description,
		Tariff = Item.[Harmonizing Tariff Code],
		CatDesc = Item.[Cat_ No_ Description],
		Finish = Item.[Plating Type],
		ItemSize = Item.[Size No_ Description],
		PriceCat = Item.[Item Disc_ Group],
		PcsPerPallet = Item.[Super Equiv_ Qty_] * Item.[Qty__Base UOM],
		SellStkUM  = Item.[Base Unit of Measure],
		SellStkUMQty = Item.[Qty__Base UOM],
		SuperUM = Item.[Super Equiv_ UOM],
		StkUM = Item.[Base Unit of Measure],
		Wght = Item.[Net Weight],
		GrossWght = Item.[Gross Weight],
		CUMGrossWght = Item.[Gross Weight] * [Super Equiv_ Qty_],
		CUMNetWght = Item.[Net Weight] * [Super Equiv_ Qty_],
		HundredWght = Item.[Weight_100],
		UPCCd = Item.[UPC Code],
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
		LengthDesc = Item.[LengthDesc],
		BoxSize = Item.[Routing No_],

CategoryDescAlt1 = left(Porteous$Item.[Cat_ No_ Description Alt_ 1],40),
CategoryDescAlt2 = left(Porteous$Item.[Cat_ No_ Description Alt_ 2],40),
CategoryDescAlt3 = left(Porteous$Item.[Cat_ No_ Description Alt_ 3],40),
SizeDescAlt1 = Porteous$Item.[Size No_ Description Alt_ 1],

		CustNo = Item.[Customer No_]
FROM	OpenDataSource('SQLOLEDB','Data Source=ENTERPRISESQL;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.Porteous$Item Item
WHERE	Item.[No_] = ItemNo COLLATE Latin1_General_CS_AS --AND Item.[Last Date Modified] > '1900-01-01' AND
--	(CONVERT(datetime, Item.[Last Date Modified], 112) > CONVERT(datetime, ChangeDt, 112) OR ChangeDt is null)
