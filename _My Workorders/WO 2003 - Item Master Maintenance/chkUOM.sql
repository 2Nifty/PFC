select SellUM, CostPurUM, * from ItemMaster 
where ItemNo='00200-4200-401'

select * from ItemUM where fitemmasterid=54329





select ListValue as UM from ListDetail where flistmasterid=155 order by UM

select	IM.CostPurUM, count(IM.CostPurUM) as reccnt
		--distinct IM.ItemNo, IM.SellUM
		--ItemNo, 
		--UM.UM, UM.AltSellStkUMQty as AltQty, UM.QtyPerUM as QtyPer,
		--HundredWght, Wght as NetWght, PCLBFTInd, SellStkUM as BaseUOM, SellStkUMQty as BaseUOMQty,
		--PcsPerPallet, SellUM, CostPurUM, SuperUM, case when SellStkUMQty = 0 then 0 else PcsPerPallet / SellStkUMQty end as SuperUMQty
from	ItemMaster IM (Nolock) inner join
		ItemUM UM (Nolock)
on		IM.pItemmasterid = UM.fitemmasterid and PCLBFTInd='PC' and
		CostPurUM in (select ListValue as UM from ListDetail where flistmasterid=155)
group by IM.CostPurUM
order by CostPurUM
--order by SellUM, ItemNo


select ItemNo from ItemMaster
where PCLBFTInd = 'FT' and
		SellUM = 'MFT' and
		costPurUM = 'MFT'
order by itemno


select distinct SellUM, CostPurUM from
(

select	distinct IM.ItemNo, IM.SellUM, CostPurUM
		--ItemNo, 
		--UM.UM, UM.AltSellStkUMQty as AltQty, UM.QtyPerUM as QtyPer,
		--HundredWght, Wght as NetWght, PCLBFTInd, SellStkUM as BaseUOM, SellStkUMQty as BaseUOMQty,
		--PcsPerPallet, SellUM, CostPurUM, SuperUM, case when SellStkUMQty = 0 then 0 else PcsPerPallet / SellStkUMQty end as SuperUMQty
from	ItemMaster IM (Nolock) inner join
		ItemUM UM (Nolock)
on		IM.pItemmasterid = UM.fitemmasterid and PCLBFTInd='FT' and
		SellUM in (select ListValue as UM from ListDetail where flistmasterid=155)
--order by SellUM, ItemNo
) tmp






select	ItemNo, UM.UM, UM.AltSellStkUMQty as AltQty, UM.QtyPerUM as QtyPer, 
		HundredWght, Wght as NetWght, PCLBFTInd, SellStkUM as BaseUOM, SellStkUMQty as BaseUOMQty,
		PcsPerPallet, SellUM, CostPurUM, SuperUM, PcsPerPallet / SellStkUMQty as SuperUMQty, IM.ChangeDt
from	ItemMaster IM (Nolock) inner join
		ItemUM UM (Nolock)
on		IM.pItemmasterid = UM.fitemmasterid
where IM.changedt < getdate()-30 --and isnull(SuperUM,'')<>'' and PCLBFTInd = 'PC'
and
ItemNo in
(
'00019-2408-101',
'00019-2410-100',
'00019-2412-021',
'00026-2416-951',
'00026-2416-961',
'00026-2416-971',
'00026-2416-981',
'00026-2416-994',
'00050-4242-060',
'00056-3263-410',
'00056-3263-411',
'00080-4052-400',
'00080-4052-402',
'00080-4230-302',
'00152-3262-000',
'00152-3262-004',
'00152-3262-020',
'00152-3262-024',
'00170-0601-501',
'00170-0603-021',
'00170-0603-500',
'00170-1003-024',
'00170-1203-500',
'00170-2406-100',
'00173-2406-441',
'00173-2803-501',
'00302-0044-500',
'00370-0800-501',
'00370-1000-501',
'00370-5400-500',
'00370-5400-501',
'00380-2521-501',
'00690-2524-019',
'00719-4171-020',
'00761-2016-780',
'00762-0718-407',
'00762-0718-408',
'00762-0718-409',
'00930-2619-029',
'01400-0606-500',
'01762-0926-400',
'02329-2400-501',
'20960-0001-660',
'78073-0001-599',
'78073-0620-011',
'78143-0169-500',
'78143-0180-500',
'78143-0182-500',
'99907-1003-899',
'99907-1015-899',
'99999-4743-250',
'99999-5356-020',
'99999-6208-260',
'99999-6212-260',
'99999-6804-163'
)
order by PCLBFTInd, ItemNo


select distinct PCLBFTInd from ItemMaster


select * from itemmaster
order by itemno
exec sp_columns itemmaster


select * from
(select pitemmasterid, itemno, PCLBFTInd, SellStkUMQty
from ItemMaster where ItemStat='S' and PCLBFTInd='LB' and  changedt < getdate()-30) IM
inner join
(select fitemmasterid, UM, AltSellStkUMQty as AltQty, QtyPerUM as QtyPer
from ItemUM where UM in ('C','CFT','CWT','M','MFT','MWT')) UM

on IM.pitemmasterid=UM.fitemmasterid
order by ItemNo, UM




select * from Listmaster where Listname='ItemUMDivisor'
select * from Listdetail where flistmasterid=153