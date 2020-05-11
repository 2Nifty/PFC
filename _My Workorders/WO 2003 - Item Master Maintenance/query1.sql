
--select * from ItemMaster



SELECT	left(IM.ItemNo,5) as CatNo,
		substring(IM.ItemNo,7,4) as ItemNo,
		right(IM.ItemNo,3) as VarNo,
		IM.ItemNo,
		IM.LengthDesc,
		IM.DiameterDesc,
		IM.CatDesc,
		IM.ItemSize,
		IM.Finish,
		IM.ItemDesc,
		IM.UPCCd,
		IM.CategoryDescAlt1,
		IM.CategoryDescAlt2,
		IM.CategoryDescAlt3,
		IM.SizeDescAlt1,
		IM.CustNo,
--Vendor Code
--Routing No
--Production BOM
		IM.ParentProdNo,
		IM.CorpFixedVelocity,
		IM.PPICode,
		IM.TariffCd as HarmonizingCd,
		IM.WebEnabledInd,
		IM.CertRequiredInd,
		IM.HazMatInd,
--FQA Item
		IM.PalPtnrInd as PtPartner,
		IM.ListPrice,
		IM.HundredWght,
		IM.GrossWght,
		IM.Wght as NetWght,
		IM.SellStkUM as BaseUOM,
		IM.SellStkUMQty as BaseUOMQty,
		IM.SellUM as SellUOM,
		IM.CostPurUM as PurchUOM,
		IM.SuperUM as SuperUOM
--Super UOM Qty
FROM	ItemMaster (NoLock) IM
WHERE	ItemNo = '00200-2400-021'

