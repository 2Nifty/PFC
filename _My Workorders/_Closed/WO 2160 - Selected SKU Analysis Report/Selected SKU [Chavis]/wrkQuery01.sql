--Less than 10 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			--Base
			Base.ItemNo,
--			isnull(Base.BaseStkUM,'') as BaseStkUM,
			isnull(Base.BaseStkQty,0) as BaseStkQty,
--			isnull(Base.AltUM,'') as AltUM,
			--AltPurch
--			isnull(AltPurch.AltPurchUM,'') as AltPurchUM,
--			isnull(AltPurch.AltPurchQty,0) as AltPurchQty,
			--AltSell
			isnull(AltSell.AltSellUM,'') as AltSellUM,
			isnull(AltSell.AltSellQty,0) as AltSellQty,
			--SuperUM
			isnull(SuperEqv.SuperUM,'') as SuperUM,
			isnull(SuperEqv.SuperQty,0) as SuperQty
--INTO	#tItemUM
	FROM	(--Base
			 SELECT	IM.ItemNo,
					IM.SellStkUM as BaseStkUM,
					IM.SellStkUMQty as BaseStkQty,
					IM.PriceUM as AltUM
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.PriceUM = IUM.UM AND
IM.ItemNo='00200-5200-020') Base LEFT OUTER JOIN
			(--AltPurch
			 SELECT	IM.ItemNo,
					IM.CostPurUM as AltPurchUM,
					IUM.AltSellStkUMQty as AltPurchQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.CostPurUM = IUM.UM AND
IM.ItemNo='00200-5200-020') AltPurch
			ON		Base.ItemNo = AltPurch.ItemNo LEFT OUTER JOIN
			(--AltSell
			 SELECT	IM.ItemNo,
					IM.SellUM as AltSellUM,
					IUM.AltSellStkUMQty as AltSellQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SellUM = IUM.UM AND
IM.ItemNo='00200-5200-020') AltSell
			ON		Base.ItemNo = AltSell.ItemNo LEFT OUTER JOIN
			(--SuperUM
			 SELECT	IM.ItemNo,
					IM.SuperUM as SuperUM,
					IUM.QtyPerUM as SuperQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SuperUM = IUM.UM AND
IM.ItemNo='00200-5200-020') SuperEqv
			ON		Base.ItemNo = SuperEqv.ItemNo
where Base.ItemNo='00200-5200-020'
--select * from #tItemUM






select IM.ItemNo, IM.SellStkUM as BaseUM, UM.QtyPerUM as BaseQtyPer, UM.AltSellStkUMQty as AltSellQty, IM.SellUM
from ItemMaster IM (Nolock) inner join
	 ItemUM UM (Nolock)
on	IM.pItemMasterID = UM.fItemMasterID
where IM.SellStkUM = UM.UM 
--and isnull(UM.AltSellStkUMQty,0) <> 0 and isnull(UM.AltSellStkUMQty,0) <> 1
and isnull(UM.QtyPerUM,0) <> 1





select * from ItemUM