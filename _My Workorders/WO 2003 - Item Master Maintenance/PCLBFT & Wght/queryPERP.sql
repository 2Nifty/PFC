select ItemNo, PCLBFTInd, round(Wght,2,0) as Wght, (SellStkUMQty * HundredWght) / 100 as CalcWght, SellStkUMQty, HundredWght
from ItemMaster 
where ItemStat='S' and
(Wght >= ((SellStkUMQty * HundredWght) / 100) + 0.1 or
Wght <= ((SellStkUMQty * HundredWght) / 100) - 0.1)
and PCLBFTInd <> 'LB'



select Wght, GrossWght, (SellStkUMQty * HundredWght) / 100 as CalcWght, SellStkUMQty, HundredWght, * from ItemMaster 
where [ItemNo] in ('00928-3420-040','00900-0804-040','00912-1004-040')


----------------------------------------------------------------------------------------------


--1193 records do not match in PERP
--	(573) PCLBFT = null
--	(608) PCLBFT = PC
--	(12) PCLBFT = FT
select	ItemNo, PCLBFTInd, wght,
	cast(round(Wght,4) as decimal(10,4)) as RoundWght,
	cast( round(SellStkUMQty / 100 * HundredWght,4) as decimal(10,4)) as CalcWght,
	SellStkUMQty, HundredWght,
	EntryID, EntryDt, ChangeID, ChangeDt 
from ItemMaster (NOLOCK)
where ItemStat='S' and isnull(PCLBFTInd,'') in ('','PC','FT') and
cast(round(Wght,4) as decimal(10,4)) <> cast( round(SellStkUMQty / 100 * HundredWght,4) as decimal(10,4))



--1860 records do not match in PERP
--	PCLBFT = LB
select	ItemNo, PCLBFTInd, wght, SellStkUMQty,
	cast(round(Wght,4) as decimal(10,4)) as Wght,
	cast(round(SellStkUMQty,4) as decimal(10,4)) as SellStkUMQty,
	HundredWght,
	EntryID, EntryDt, ChangeID, ChangeDt 
from ItemMaster (NOLOCK)
where ItemStat='S' and isnull(PCLBFTInd,'') in ('LB') and
cast(round(Wght,4) as decimal(10,4)) <> cast(round(SellStkUMQty,4) as decimal(10,4))




----------------------------------------------------------------------------------------------





select distinct PCLBFTInd from ItemMaster where ItemStat='S'


select PCLBFTInd, SellStkUMqty, * from ItemMaster where ItemNo='00020-3450-400'

select AltSellStkUMQty, * from ItemUM where fitemmasterid=1650




--UPDATE new IM.PCLBFTInd from ItemUM
UPDATE      ItemMaster
SET         PCLBFTInd = left(UM.UM,2)

select *
FROM  ItemMaster IM (NoLock) inner join
            ItemUM UM (NoLock)
ON          IM.pItemMasterID = UM.fItemMasterID and IM.SellStkUMqty = UM.AltSellStkUMQty
WHERE       UM.UM in ('PC','LB','FT')
GO

