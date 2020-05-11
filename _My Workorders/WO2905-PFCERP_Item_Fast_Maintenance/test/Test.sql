
'00170-2410-024'
'00170-2410-201'
'00170-2412-024'
'00170-2412-100'
'02720-1010-421'
'02720-1010-431'
'02720-1010-451'
'02720-1010-481'
'00056-2830-081'
'00056-2830-451'
'00056-2830-481'


select
--	PCLBFTInd, EntryID, EntryDt, ChangeID, ChangeDt, * 
pclbftind,
pItemMasterId,ItemNo,
CatDesc,ItemSize,Finish,DiameterDesc,LengthDesc,
CustNo,BoxSize,PPICode,Tariff,
WebEnabledInd,CertRequiredInd,HazMatInd,QualityInd,PalPtnrInd,
ListPrice,HundredWght,Wght,
PCLBFTInd as PCLBFT,SellStkUM,SellUM,CostPurUM,SuperUM,PcsPerPallet,
EntryID,EntryDt,ChangeID,ChangeDt,' ',
ItemDesc, GrossWght, case when sellstkumqty=0 then 0 else pcsperpallet/sellstkumqty end as SuperUM
from	ItemMaster --inner join
--	ItemUM
--on	pitemmasterid=fitemmasterid

where
--(EntryDt < getdate()-120 and changedt < getdate()-120) --and entryid<>'twhite' and changeid<>'twhite'
--	and isnull(entryid,'') <> '' and isnull(changeid,'') not in ('','Deleted Nav3_7')
--
--order  by PCLBFTIND, ItemNo

--PC Items (6)
--and 

(ItemNo in 

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
))



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
--and left(Changeid,2) > 14
order by ItemNo


update ItemMaster
set Finish='ZB' 
where Finish='lTES'


------------------------------------------------------------------


--01CatDesc-FMtest
--Verify CatDesc, ItemDesc & Length exceptions
--select * from t_20120705_IMFastMaintUpdate16042tod_CatDesc
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_CatDesc', 'CatDesc', '01CatDesc-FMtest'


--02ItemSize-FMtest
--Verify ItemSize, ItemDesc & Length exceptions
--select * from t_20120705_IMFastMaintUpdate16042tod_ItemSize
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_ItemSize', 'ItemSize', '02ItemSize-FMtest'

--03Finish-FMtest
--Verify Finish, ItemDesc & Length exceptions
--select * from t_20120705_IMFastMaintUpdate16042tod_Finish
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_Finish', 'Finish', '03Finish-FMtest'

--04DiameterDesc-FMtest
--Verify DiameterDesc & Length exceptions
--select * from t_20120705_IMFastMaintUpdate16042tod_DiameterDesc
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_DiameterDesc', 'DiameterDesc', '04DiameterDesc-FMtest'

--05LengthDesc-FMtest
--Verify LengthDesc & Length exceptions
--select * from t_20120705_IMFastMaintUpdate16042tod_LengthDesc
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_LengthDesc', 'LengthDesc', '05LengthDesc-FMtest'


--06CustNo-FMtest
--Verify CustNo, Zero Pad & Bad Custs
--select * from t_20120705_IMFastMaintUpdate16042tod_CustNo
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_CustNo', 'CustNo', '06CustNo-FMtest'


--07BoxSize-FMtest
--Verify BoxSize, Zero Pad & Bad Code
--UPDATE Gross Wght
--select * from t_20120705_IMFastMaintUpdate16042tod_BoxSize
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_BoxSize', 'BoxSize', '07BoxSize-FMtest'


--08PPICode-FMtest
--Zero Pad and Verify PPICode against ItemPPICd list
--select * from t_20120705_IMFastMaintUpdate16042tod_PPICode
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_PPICode', 'PPICode', '08PPICode-FMtest'

--09Tariff-FMtest
--Verify Tariff against GERTARIFF table
--select * from t_20120705_IMFastMaintUpdate16042tod_Tariff
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_Tariff', 'Tariff', '09Tariff-FMtest'


--10WebEnabledInd-FMtest
--Verify WebEnabledInd 0=No; 1=yes
--select * from t_20120705_IMFastMaintUpdate16042tod_WebEnabledInd
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_WebEnabledInd', 'WebEnabledInd', '10WebEnabledInd-FMtest'


--11CertRequiredInd-FMtest
--Verify CertRequiredInd 0=No; 1=yes
--select * from t_20120705_IMFastMaintUpdate16042tod_CertRequiredInd
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_CertRequiredInd', 'CertRequiredInd', '11CertRequiredInd-FMtest'


--12HazMatInd-FMtest
--Verify HazMatInd 0=No; 1=yes
--select * from t_20120705_IMFastMaintUpdate16042tod_HazMatInd
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_HazMatInd', 'HazMatInd', '12HazMatInd-FMtest'


--13QualityInd-FMtest
--Verify QualityInd 0=No; 1=yes
--select * from t_20120705_IMFastMaintUpdate16042tod_QualityInd
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_QualityInd', 'QualityInd', '13QualityInd-FMtest'


--14PalPtnrInd-FMtest
--Verify PalPtnrInd 0=No; 1=yes
--select * from t_20120705_IMFastMaintUpdate16042tod_PalPtnrInd
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_PalPtnrInd', 'PalPtnrInd', '14PalPtnrInd-FMtest'



--15ListPrice-FMtest
--Verify ListPrice Numeric, negative, zero
--select * from t_20120705_IMFastMaintUpdate16042tod_ListPrice
exec [pIMUpdFastMaint] 't_20120705_IMFastMaintUpdate16042tod_ListPrice', 'ListPrice', '15ListPrice-FMtest'


--16HundredWght-FMtest
--Verify HundredWght Numeric, negative, zero
--select * from t_20120706_IMFastMaintUpdate16063tod_HundredWght
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_HundredWght', 'HundredWght', '16HundredWght-FMtest-2'

--17Wght-FMtest
--Verify Wght Numeric, negative, zero
--select * from t_20120706_IMFastMaintUpdate16063tod_Wght
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_Wght', 'Wght', '17Wght-FMtest-2'


--select * from t_20120706_IMFastMaintUpdate16063tod_PCLBFTInd
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_PCLBFTInd', 'PCLBFTInd', '18PCLBFTInd-FMtest-Reset'


--select * from t_20120706_IMFastMaintUpdate16063tod_SellStkUM
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_SellStkUM', 'SellStkUM', '19SellStkUM-FMtest-Reset'


--select * from t_20120706_IMFastMaintUpdate16063tod_SellUM
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_SellUM', 'SellUM', '20SellUM-FMtest-Reset'


--select * from t_20120706_IMFastMaintUpdate16063tod_CostPurUM
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_CostPurUM', 'CostPurUM', '21CostPurUM-FMtest-Reset'

--select * from t_20120706_IMFastMaintUpdate16063tod_SuperUM
exec [pIMUpdFastMaint] 't_20120706_IMFastMaintUpdate16063tod_SuperUM', 'SuperUM', '22SuperUM-FMtest-Reset'




--select * from t_20120709_IMFastMaintUpdate16076tod_PcsPerPallet
exec [pIMUpdFastMaint] 't_20120709_IMFastMaintUpdate16076tod_PcsPerPallet', 'PcsPerPallet', '23PcsPerPallet-FMtest'



--select * from t_20120718_IMFastMaintUpdate16147tod_PCLBFTInd
exec [pIMUpdFastMaint] 't_20120718_IMFastMaintUpdate16147tod_PCLBFTInd', 'PCLBFTInd', '18PCLBFTInd-TOD'


select * from [t_20120726_IMFastMaintUpdate16208tod_Finish]   
exec [pIMUpdFastMaint] 't_20120726_IMFastMaintUpdate16208tod_Finish', 'FINISH', 'TOD-test finish'




------------------------------------------------------------------------------------------

select *, len(Finish) from t_20120703_IMFastMaintUpdate16031tod_Finish


select * from t_20120705_IMFastMaintUpdate16042tod_Wght
select * from IMFastMaint where --isnull(completedt,0) <> 0 and 
DataField='Wght' and pimfastmaintid > 203


select ItemNo, PCLBFTInd, HundredWght, Wght, grossWght
from ItemMaster where pitemmasterid in 
(
165462,
148707,
151475,
142367,
166699


)
order by itemno



delete from IMFastMaint where entryid <> 'tod'
='Finish'

select * from IMFastMaint

select changeid, changedt, * from ItemMaster where changeid='tod'

update itemmaster
set changeid='' where changeid='tod'

truncate table IMFastMaint



select * from t_20120705_IMFastMaintUpdate16042tod_DiameterDesc

update t_20120705_IMFastMaintUpdate16042tod_DiameterDesc
set DiameterDesc = replace(DiameterDesc,'Well','We''ll')



select Finish, changedt, changeid, * from itemMaster where itemno='00200-2600-029'


