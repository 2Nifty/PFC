
select PCLBFTInd, pitemmasterid, itemno,
SellStkUM, SellUM, CostPurUM, SuperUM,
 SellStkUmQty, PcsPerPallet, IM.entrydt, IM.entryid, IM.changedt, IM.changeid, UM, AltSellStkUMQty, QtyPerUM, UM.entrydt, UM.entryid,UM.Changedt, UM.changeid
from itemmaster im (nolock) inner join itemum um (nolock) on pitemmasterid=fitemmasterid
where 

IM.ChangeID='18PCLBFTInd-FMretest'

order by itemno, um


ItemNo in 



(

'00170-2410-024',
'00170-2410-201',
'00170-2412-024',
'00170-2412-100',
'02720-1010-421',
'02720-1010-431',
'02720-1010-451',
'02720-1010-481',
'00056-2830-081',
'00056-2830-451',
'00056-2830-481'
)


order by itemno, um





(


'00087-2660-082',
'00170-2610-100',
'00384-2824-084',
'00900-3232-080'


)
order by itemno, um

(
'00086-2873-500',
'02720-0812-451',
'04172-4206-201'
)
order by itemno, um



				SELECT	IM.ItemNo, IM.DensityFactor
				FROM	ItemMaster (NoLock) IM
				WHERE	IM.ItemStat = 'M' and RTRIM(IM.ItemNo) in (SELECT BoxSize FROM ItemMaster WHERE pItemMasterID in (142892,
148707,
151472,
151475,
166699,
150020
  ))

update itemmaster set grosswght=1 where pitemmasterid=143152







select * from IMFastMaint

SELECT DISTINCT rtrim(ItemNo) FROM ItemMaster (NOLOCK) WHERE ItemStat = 'M' and rtrim(ItemNo)='111'

select * from Listmaster where ListName='ItemPPICd'
select * from ListDetail where flistmasterid=157

SELECT DISTINCT Dsc FROM TABLES (NOLOCK) WHERE TableType='GERTARIFF'

select EntryID, EntryDt, ChangeID, ChangeDt, * 
from ItemMaster 
where changedt > getdate()-1  -- and entryid<>'twhite' and changeid<>'twhite'

exec sp_columns ItemMaster

--select * from itemum where (EntryDt > getdate()-14 or changedt > getdate()-14) and entryid<>'twhite' and isnull(changeid,'')<>'twhite' and fitemmasterid not in (53798,54292)


--exec [pIMUpdFastMaint] 't_20120629_IMFastMaint02Update15976tod_CatDesc', 'CatDesc', 'TODTextCopy'


select	

entrydt, changedt, 
pItemMasterId,
ItemNo,

CatDesc,
ItemSize,
Finish,
DiameterDesc,
LengthDesc,
CustNo,
BoxSize,
PPICode,
Tariff,
WebEnabledInd,
CertRequiredInd,
HazMatInd,
QualityInd,
PalPtnrInd,
ListPrice,
HundredWght,
Wght,
PCLBFTInd,
SellStkUM,
SellUM,
CostPurUM,
SuperUM,
PcsPerPallet,
EntryID,
EntryDt,
ChangeID,
ChangeDt
from	ItemMaster where --itemNo='00024-2730-024'
PCLBFTInd='FT' and


 (EntryDt < getdate()-120 and changedt < getdate()-120) --and entryid<>'twhite' and changeid<>'twhite'
	and isnull(entryid,'') <> '' and isnull(changeid,'') not in ('','Deleted Nav3_7')
order by ItemNo


select	
--	distinct (right(ItemNo,3))
--	distinct (changeid) 
	EntryID, EntryDt, ChangeID, ChangeDt, * 
from	ItemMaster where (EntryDt < getdate()-90 and changedt < getdate()-90) --and entryid<>'twhite' and changeid<>'twhite'
	and isnull(entryid,'') <> '' and isnull(changeid,'') not in ('','Deleted Nav3_7')

and PCLBFTInd = 'FT'
and right(ItemNo,3)  in ('100','101','104','161')

order by right(ItemNo,3)




select
--	PCLBFTInd, EntryID, EntryDt, ChangeID, ChangeDt, * 
pItemMasterId,
ItemNo,

CatDesc,
ItemSize,
Finish,
DiameterDesc,
LengthDesc,
CustNo,
BoxSize,
PPICode,
Tariff,
WebEnabledInd,
CertRequiredInd,
HazMatInd,
QualityInd,
PalPtnrInd,
ListPrice,
HundredWght,
Wght,
PCLBFTInd,
SellStkUM,
SellUM,
CostPurUM,
SuperUM,
PcsPerPallet,
EntryID,
EntryDt,
ChangeID,
ChangeDt,
ItemDesc
from	ItemMaster --inner join
--	ItemUM
--on	pitemmasterid=fitemmasterid

where (EntryDt < getdate()-90 and changedt < getdate()-90) --and entryid<>'twhite' and changeid<>'twhite'
	and isnull(entryid,'') <> '' and isnull(changeid,'') not in ('','Deleted Nav3_7')
--PC Items (6)
and 

(ItemNo in 
(
'00900-3232-080',
'00056-2420-081',
'00087-2660-082',
'00384-2824-084',
'00086-2624-088',
'00661-0816-089'
)
--LB Items (5)
or ItemNo in 
(
'00380-2820-020',
'00390-4200-021',
'00375-2600-024',
'00370-2300-028',
'00370-3400-029'
)
--FT Items (4)
or ItemNo in 
(
'00170-2610-100',
'00170-4106-101',
'00170-4210-104',
'99999-6969-161'
))

order by ItemNo


select fitemmasterid, ItemNo,
UM.UM, AltSellStkUMQty, QtyPerUM, UM.EntryID, UM.EntryDt, UM.ChangeID, UM.ChangeDt

from	ItemMaster inner join
	ItemUM UM
on	pitemmasterid=fitemmasterid

where 
--PC Items (6)


(ItemNo in 
(
'00900-3232-080',
'00056-2420-081',
'00087-2660-082',
'00384-2824-084',
'00086-2624-088',
'00661-0816-089'
)
--LB Items (5)
or ItemNo in 
(
'00380-2820-020',
'00390-4200-021',
'00375-2600-024',
'00370-2300-028',
'00370-3400-029'
)
--FT Items (4)
or ItemNo in 
(
'00170-2610-100',
'00170-4106-101',
'00170-4210-104',
'99999-6969-161'
))

order by ItemNo, UM




