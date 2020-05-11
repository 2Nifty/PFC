
drop table #tItemUM
go

--------------------
-- Build #tItemUM --
--------------------
--Less than 10 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			--Base
			Base.ItemNo,
			isnull(Base.BaseStkUM,'') as BaseStkUM,
			isnull(Base.BaseStkQty,0) as BaseStkQty,
			isnull(Base.AltUM,'') as AltUM,
			--AltPurch
			isnull(AltPurch.AltPurchUM,'') as AltPurchUM,
			isnull(AltPurch.AltPurchQty,0) as AltPurchQty,
			--AltSell
			isnull(AltSell.AltSellUM,'') as AltSellUM,
			isnull(AltSell.AltSellQty,0) as AltSellQty,
			--SuperUM
			isnull(SuperEqv.SuperUM,'') as SuperUM,
			isnull(SuperEqv.SuperQty,0) as SuperQty
	INTO	#tItemUM
	FROM	(--Base
			 SELECT	IM.ItemNo,
					IM.SellStkUM as BaseStkUM,
					IM.SellStkUMQty as BaseStkQty,
					IM.PriceUM as AltUM
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.PriceUM = IUM.UM --AND
--					--Category
--					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
--					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
--					--Size
--					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
--					--Variance
--					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
--					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
--																			 ELSE isnull(substring(@StrVar,1,1),'')
--															END and
--					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
--																			 ELSE isnull(substring(@StrVar,2,1),'')
--															END and
--					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
--																			 ELSE isnull(substring(@StrVar,3,1),'')
--															END) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)
			) Base LEFT OUTER JOIN
			(--AltPurch
			 SELECT	IM.ItemNo,
					IM.CostPurUM as AltPurchUM,
					IUM.AltSellStkUMQty as AltPurchQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.CostPurUM = IUM.UM --AND
--					--Category
--					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
--					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
--					--Size
--					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
--					--Variance
--					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
--					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
--																			 ELSE isnull(substring(@StrVar,1,1),'')
--															END and
--					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
--																			 ELSE isnull(substring(@StrVar,2,1),'')
--															END and
--					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
--																			 ELSE isnull(substring(@StrVar,3,1),'')
--															END) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)
			) AltPurch
			ON		Base.ItemNo = AltPurch.ItemNo LEFT OUTER JOIN
			(--AltSell
			 SELECT	IM.ItemNo,
					IM.SellUM as AltSellUM,
					IUM.AltSellStkUMQty as AltSellQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SellUM = IUM.UM --AND
--					--Category
--					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
--					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
--					--Size
--					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
--					--Variance
--					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
--					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
--																			 ELSE isnull(substring(@StrVar,1,1),'')
--															END and
--					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
--																			 ELSE isnull(substring(@StrVar,2,1),'')
--															END and
--					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
--																			 ELSE isnull(substring(@StrVar,3,1),'')
--															END) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)
			) AltSell
			ON		Base.ItemNo = AltSell.ItemNo LEFT OUTER JOIN
			(--SuperUM
			 SELECT	IM.ItemNo,
					IM.SuperUM as SuperUM,
					IUM.QtyPerUM as SuperQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SuperUM = IUM.UM --AND
--					--Category
--					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
--					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
--					--Size
--					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
--					--Variance
--					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
--					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
--																			 ELSE isnull(substring(@StrVar,1,1),'')
--															END and
--					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
--																			 ELSE isnull(substring(@StrVar,2,1),'')
--															END and
--					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
--																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
--																			 ELSE isnull(substring(@StrVar,3,1),'')
--															END) or
--					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)
			) SuperEqv
			ON		Base.ItemNo = SuperEqv.ItemNo

where Base.ItemNo='00200-2400-021'

select * from #tItemUM
