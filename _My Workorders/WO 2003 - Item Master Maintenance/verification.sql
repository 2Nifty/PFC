

select im.pitemmasterid, im.itemno, im.EntryId as IMEntryID, im.EntryDt as IMEntryDt, im.ChangeID as IMChangeID, im.ChangeDt as IMChangeDt, im.DeleteId, im.DeleteDt,
		im.CategoryDescalt1, im.CategoryDescalt2, im.CategoryDescalt3, im.sellstkumqty, um.*
from ItemMaster IM inner join itemum UM on IM.pitemmasterid=um.fitemmasterid

where ItemNo in
('00200-2400-020' --,
--'00200-4200-401'--,
--'00200-4200-021'
)



('00500-0520-020',
'00500-0520-021',
'00500-0520-401',
'00500-0520-500',
'00500-0520-501')


select * from ItemUM

update itemmaster
set PCLBFTInd=left(ItemUM.UM,2)
from 
ItemMaster inner join ItemUM on pitemmasterid=fitemmasterid and SellStkUMqty=AltSellStkUMQty




select	IM.ItemNo, 
			IM.HundredWght,
			IM.Wght as NetWght,
			IM.GrossWght,

UM.UM as PCLBFT, UM.AltSellStkUMQty as BaseUOMQty, IM.PCLBFTInd,			
			IM.SellStkUM as BaseUOM,
			IM.SellStkUMQty as BaseUOMQty,
			IM.PcsPerPallet,
			IM.SellUM as SellUOM,
			IM.CostPurUM as PurchUOM,
			IM.SuperUM as SuperUOM,
			CASE WHEN IM.SellStkUMQty = 0
				 THEN 0
				 ELSE IM.PcsPerPallet / IM.SellStkUMQty
			END as SuperUOMQty
from ItemMaster (nolock) IM inner join
	 ItemUM (nolock) UM
on	 IM.pitemmasterid=UM.fitemmasterid and IM.SellStkUMqty=UM.AltSellStkUMQty
where ItemNo in 
('00400-2408-000',
'00400-2408-001',
'00400-2408-020',
'00400-2408-021',
'00400-2408-061',
'00400-2408-401',
'00400-2408-411',
'00400-2408-451',
'00400-2408-500',
'00400-2408-501',
'00400-2408-801',
'00400-2408-811',
'00200-2400-000',
'00200-2400-001',
'00200-2400-002',
'00200-2400-004',
'00200-2400-020',
'00200-2400-021',
'00200-2400-022',
'00200-2400-023',
'00200-2400-024',
'00200-2400-041',
'00200-2400-061',
'00200-2400-100',
'00200-2400-101',
'00200-2400-102',
'00200-2400-104',
'00200-2400-110',
'00200-2400-111',
'00200-2400-114',
'00200-2400-200',
'00200-2400-201',
'00200-2400-202',
'00200-2400-211',
'00200-2400-241',
'00200-2400-271',
'00200-2400-400',
'00200-2400-401',
'00200-2400-404',
'00200-2400-411',
'00200-2400-450',
'00200-2400-451',
'00200-2400-454',
'00200-2400-461',
'00200-2400-464',
'00200-2400-469',
'00200-2400-471',
'00200-2400-474',
'00200-2400-491',
'00200-2400-500',
'00200-2400-501',
'00200-2400-502',
'00200-2400-504',
'00200-2400-571',
'00200-2400-601',
'00200-2400-772',
'00200-2400-801',
'00200-2400-811',
'00200-2400-821',
'00200-2400-834',
'00200-2400-851',
'00200-2400-854',
'00200-2400-891',
'00200-2400-951',
'00200-2400-954',
'00200-2400-961',
'00200-2400-971',
'00200-2400-974',
'00200-2400-981',
'00200-2400-984',
'00200-4200-000',
'00200-4200-001',
'00200-4200-004',
'00200-4200-010',
'00200-4200-014',
'00200-4200-020',
'00200-4200-021',
'00200-4200-022',
'00200-4200-024',
'00200-4200-100',
'00200-4200-101',
'00200-4200-104',
'00200-4200-200',
'00200-4200-201',
'00200-4200-204',
'00200-4200-210',
'00200-4200-400',
'00200-4200-401',
'00200-4200-450',
'00200-4200-451',
'00200-4200-471',
'00200-4200-500',
'00200-4200-501',
'00200-4200-504',
'00200-4200-571',
'00200-4200-951',
'00200-4200-971',
'00200-4200-999')






--select * from itemMaster


select itemno from itemmaster where left(itemno,10)='00200-4200'







select * from itemmaster
where pitemmasterid not in
(
select distinct fitemmasterid
from itemum where rtrim(um)='LB' and fitemmasterid in
(select pitemmasterid from itemmaster)
--order by fitemmasterid
)





select ItemNo, Tariff, TariffCd from ItemMaster