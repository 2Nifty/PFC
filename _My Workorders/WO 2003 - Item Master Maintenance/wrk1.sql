select ParentProdNo, * from ItemMaster

update ItemMaster 
set EntryDT = getdate()-1000, entryid='system'
	--CustNo='' 
where pitemmasterid=2



select DeleteDt, isnull(DeleteDt,'') as DeleteDt from ItemMaster



select * from BOM
where ParentItemNo = '00020-2408-500'


select * from BOMDetail
where ChildNo='00020-2408-020'



select max(len(boxsize)) from Itemmaster

exec sp_columns itemmaster




insert into itemmaster (ItemNo, EntryID, EntryDt)
values ('12345-1234-123','InsTemp', CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))


select 
			IM.CategoryDescAlt1 as AltDesc,
			IM.CategoryDescAlt2 as AltDesc2,
			IM.CategoryDescAlt3 as AltDesc3,
			IM.SizeDescAlt1 as AltSize,
* from ItemMaster IM where EntryID='InsTemp' or

ItemNo='12345-1234-123' or itemno='00123-0123-123'


delete from ItemMaster
where EntryID='InsTemp'
 where ItemNo='12345-1234-123' or itemno='00123-0123-123'






UPDATE ItemMaster 
SET ItemNo = '00020-2408-020',
 LengthDesc = '', 
DiameterDesc = '', 
CatDesc = 'Grade 2 Cap Screw NC', 
ItemSize = '2408', 
Finish = '', 
ItemDesc = '1/4-20 X 1/2 Grade 2 Cap Screw NC PL', 
UPCCd = '087302010012', 
CategoryDescAlt1 = 'test desc', 
CategoryDescAlt2 = 'test desc2',
 CategoryDescAlt3 = 'test desc3', 
SizeDescAlt1 = '1/4-20 X 1/2', 
CustNo = '', 
ParentProdNo = '00020-2408-500', 
CorpFixedVelocity = 'I',
 PPICode = '', 
TariffCd = '', 
WebEnabledInd = True, 
CertRequiredInd = False, 
HazMatInd = False, 
PalPtnrInd = False, 
--ListPrice = '$78.50', 
HundredWght = '1.180', 
GrossWght = '60.111',
 Wght = '59.000', 
SellStkUM = 'CT', 
SellStkUMQty = '5000', 
SellUM = 'M', 
CostPurUM = 'M', 
SuperUM = 'PT', 
EntryID = CASE WHEN EntryID = 'InsTemp' THEN 'tod' ELSE EntryID END, 
ChangeID = 'tod', 
ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) 
WHERE pItemMasterID = 3 



UPDATE ItemMaster SET ItemNo = '00020-2408-020', LengthDesc = '', DiameterDesc = '', CatDesc = 'Grade 2 Cap Screw NC', ItemSize = '2408', Finish = '', ItemDesc = '1/4-20 X 1/2 Grade 2 Cap Screw NC PL', UPCCd = '087302010012', CategoryDescAlt1 = 'test desc', CategoryDescAlt2 = 'test desc2', CategoryDescAlt3 = 'test desc3', SizeDescAlt1 = '1/4-20 X 1/2', CustNo = '', ParentProdNo = '00020-2408-500', CorpFixedVelocity = 'I', PPICode = '', TariffCd = '', WebEnabledInd = 1, CertRequiredInd = 0, HazMatInd = 0, PalPtnrInd = 0, ListPrice = '78.50', HundredWght = '1.180', GrossWght = '60.111', Wght = '59.000', SellStkUM = 'CT', SellStkUMQty = '5000', SellUM = 'M', CostPurUM = 'M', SuperUM = 'PT', EntryID = CASE WHEN EntryID = 'InsTemp' THEN 'tod' ELSE EntryID END, ChangeID = 'tod', ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) WHERE pItemMasterID = 3 






select * from ItemUOM