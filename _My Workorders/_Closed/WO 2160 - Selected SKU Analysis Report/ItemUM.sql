
--------------------
-- Build #tItemUM --
--------------------
--Less than 10 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			Base.ItemNo,
			isnull(Base.BaseStkUM,'') as BaseStkUM,
			isnull(Base.BaseStkUMQty,0) as BaseStkUMQty,
			--PurchPriceAlt
			isnull(Base.PurchPriceAltUM,'') as PurchPriceAltUM,
			isnull(Base.PurchPriceAltUMQty,0) as PurchPriceAltUMQty,
			isnull(Base.PurchPriceAltBaseUMQty,0) as PurchPriceAltBaseUMQty,
			isnull(Base.PurchPriceAltUMWght,0) as PurchPriceAltUMWght,
			--PurchCostAlt
			isnull(AltPurch.PurchCostAltUM,'') as PurchCostAltUM,
			isnull(AltPurch.PurchCostAltUMQty,0) as PurchCostAltUMQty,
			isnull(AltPurch.PurchCostAltBaseUMQty,0) as PurchCostAltBaseUMQty,
			isnull(AltPurch.PurchCostAltUMWght,0) as PurchCostAltUMWght,
			--AltSell
			isnull(AltSell.AltSellUM,'') as AltSellUM,
			isnull(AltSell.AltSellUMQty,0) as AltSellUMQty,
			isnull(AltSell.AltSellBaseUMQty,0) as AltSellBaseUMQty,
			isnull(AltSell.AltSellUMWght,0) as AltSellUMWght,
			--SuperEqv
			isnull(SuperEqv.SuperUM,'') as SuperUM,
			isnull(SuperEqv.SuperUMQty,0) as SuperUMQty,
			isnull(SuperEqv.SuperBaseUMQty,0) as SuperBaseUMQty,
			isnull(SuperEqv.SuperUMWght,0) as SuperUMWght
	INTO	#tItemUM
	FROM	(


			select IM.ItemNo, IM.PriceUM, IM.CostPurUM, IM.SellUM, IM.SuperUM,
					 IUM.* FROM ItemMaster IM inner join ItemUM IUM ON pItemMasterID = fItemMasterID WHERE ItemNo = '00200-2400-021'

			SELECT	IM.ItemNo,
					IM.SellStkUM as BaseStkUM,			--base stk uom
					IM.SellStkUMQty as BaseStkUMQty,	--base stk qty
					IM.PriceUM as PurchPriceAltUM,		--purch alt UM
					IUM.QtyPerUM as PurchPriceAltUMQty,
					IUM.AltSellStkUMQty as PurchPriceAltBaseUMQty,
					IUM.Weight as PurchPriceAltUMWght
			FROM	ItemMaster IM inner join
					ItemUM IUM
			ON		pItemMasterID = fItemMasterID
			WHERE	IM.ItemNo='00200-2400-021' and IM.PriceUM = IUM.UM

			) Base

			INNER JOIN

			(

			SELECT	IM.ItemNo,
					IM.CostPurUM as PurchCostAltUM,		--purch alt
					IUM.QtyPerUM as PurchCostAltUMQty,
					IUM.AltSellStkUMQty as PurchCostAltBaseUMQty,
					IUM.Weight as PurchCostAltUMWght
			FROM	ItemMaster IM inner join
					ItemUM IUM
			ON		pItemMasterID = fItemMasterID
			WHERE	IM.ItemNo='00200-2400-021' and IM.CostPurUM = IUM.UM

			) AltPurch

			ON		Base.ItemNo = AltPurch.ItemNo INNER JOIN

			(

			SELECT	IM.ItemNo,
					IM.SellUM as AltSellUM,			--alt sell
					IUM.QtyPerUM as AltSellUMQty,
					IUM.AltSellStkUMQty as AltSellBaseUMQty,
					IUM.Weight as AltSellUMWght
			FROM	ItemMaster IM inner join
					ItemUM IUM
			ON		pItemMasterID = fItemMasterID
			WHERE	IM.ItemNo='00200-2400-021' and IM.SellUM = IUM.UM

			) AltSell

			ON		Base.ItemNo = AltSell.ItemNo INNER JOIN

			(

			SELECT	IM.ItemNo,
					IM.SuperUM as SuperUM,		--super eqv
					IUM.QtyPerUM as SuperUMQty,
					IUM.AltSellStkUMQty as SuperBaseUMQty,
					IUM.Weight as SuperUMWght
			FROM	ItemMaster IM inner join
					ItemUM IUM
			ON		pItemMasterID = fItemMasterID
			WHERE	IM.ItemNo='00200-2400-021' and IM.SuperUM = IUM.UM

			) SuperEqv

			ON		Base.ItemNo = SuperEqv.ItemNo

--select * from #tItemUM






			select IM.ItemNo, IM.SellUM, IUM.* FROM ItemMaster IM inner join ItemUM IUM ON pItemMasterID = fItemMasterID WHERE ItemNo = '00200-2400-021'


select * from #tItemUM




			SELECT	IM.ItemNo,
					IM.SellUM as AltSellUM,			--alt sell
					IUM.QtyPerUM as AltSellUMQty,
					IUM.AltSellStkUMQty as AltSellBaseUMQty,
					IUM.Weight as AltSellUMWght
			FROM	ItemMaster IM inner join
					ItemUM IUM
			ON		pItemMasterID = fItemMasterID
			WHERE	IM.SellUM = IUM.UM and ItemNo = '00200-2400-021'


