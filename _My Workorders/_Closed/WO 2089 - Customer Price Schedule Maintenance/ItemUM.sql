select * from CustomerPrice
where CustNo='--90DAYNJ+ 90DAYNJ--'
and ItemNo='00200-2400-400'



select SellUM, sellstkum, * from ItemMaster where ItemNo='00156-3232-004'

select * from ItemUM where fItemMasterID=51740

--M
--update ItemMaster set SellUM='M' where ItemNo='00156-3232-004'




SELECT	Item.ItemNo, Item.ItemDesc, Item.CatDesc, Item.ItemSize,
	Item.SellUM, Item.SellStkUM, UM.UM, UM.AltSellStkUMQty
FROM	ItemMaster Item (NoLock) LEFT OUTER JOIN
	ItemUM UM (NoLock)
ON	Item.pItemMasterID = UM.fItemMasterID and Item.SellUM = UM.UM

WHERE  ItemNo='00156-3232-004'




exec pSOEGetItemAlias '00156-3232-004', '000000', '00', 'PFC'


exec [pMaintCustPriceSched] 'Item',0,'','00156-3232-004','','',0,0,0,'','',0,0,0,''

exec [pMaintCustPriceSched] 'Item',0,'','00020-2408-020','','',0,0,0,'','',0,0,0,''



select count(*) from ItemMaster


select Len(SellUM), SellUM, * from ItemMaster where Len(SellUM) > 1 order by LEN(SellUM)