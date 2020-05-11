SELECT * 
--INTO [t_20120613_IMFastMaint02Update15867tod_CatDesc] 
FROM OpenRowSet('Microsoft.ACE.OLEDB.12.0',
				'Excel 12.0;Database=\\pfcfiles\ItemFastMaint\test.xls;IMEX=1',
				'SELECT * FROM [Sheet1$]') 
--				'SELECT [Item] as ItemNo, [Orig: Category Desc] as Orig_CatDesc, [Mod: Category Desc] as CatDesc FROM [CatDesc] WHERE isnull([Orig: Category Desc],'''') <> isnull([Mod: Category Desc],'''')') 




SELECT     *
FROM       OpenRowSet('Microsoft.Jet.OLEDB.4.0',
				'Excel 8.0;Database=\\pfcfiles\ItemFastMaint\test.xls;IMEX=1',
				'SELECT * FROM [Sheet1$]') 




SELECT     *
FROM       OpenRowSet('Microsoft.Jet.OLEDB.4.0',
                     'Excel 8.0;Database=\\pfcfiles\UserDB\AppDev\Tod\02-Open\IMFastMaint02Export15867tod_CatDesc;IMEX=1',
                     'select * from [CatDesc$]')













SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=\\pfcfiles\ItemFastMaint\test.xls','SELECT * FROM [Sheet1$]')

SELECT * 
--INTO [t_20120613_IMFastMaint02Update15867tod_CatDesc]
FROM OpenRowSet('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=\\pfcfiles\ItemFastMaint\IMFastMaint02Import15867tod.xls;IMEX=1', 'SELECT * FROM [CatDesc] WHERE 1=1')






SELECT * 
--INTO [t_20120613_IMFastMaint02Update15867tod_CatDesc] 
FROM OpenRowSet('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=\\pfcfiles\ItemFastMaint\IMFastMaint02Import15867tod.xls;IMEX=1', 'SELECT [Item] as ItemNo, [Orig: Category Desc] as Orig_CatDesc, [Mod: Category Desc] as CatDesc FROM [CatDesc] WHERE 1=1')




--Let's create a specific table to hold the data: IMFastMaint
--	pIMFastMaintID
--	ItemNo
--	OriginalData
--	NewData
--	EntryDt
--	EntryID
--	CompleteDt
--	CompleteID
--	ExceptionInd
--	ExceptionMsg

----------------------------------------------------------------------------------------------

--Update Field: ItemMaster.CatDesc
--SELECT all modified data FROM t_20120613_IMFastMaint02Update15867tod_CatDesc
INSERT	INTO	tIMFastMaintTest				(ItemNo, DataField, 				 OriginalData, NewData, 				 EntryDt, EntryID)		SELECT	 ItemNo, isnull([CatDesc],'') as DataField,				 isnull([Orig_CatDesc],'') as OriginalData, isnull([CatDesc],'') as NewData,				 CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) as EntryDt, 'TODtest3' as EntryID		FROM	 [t_20120613_IMFastMaint02Update15867tod_CatDesc]		WHERE	 isnull([CatDesc],'') <> '' AND 				 isnull([Orig_CatDesc],'') <> isnull([CatDesc],'') COLLATE Latin1_General_CS_AS
select * from tIMFastMaintTestdelete from tIMFastMaintTest
where isnull(EntryID,'') = 'TODtest9'





select * from [t_20120614_IMFastMaint02Update15871tod_PPICode] 


select	LM.ListName, LD.ListValue as FieldName, LD.ListDtlDesc as FieldDesc
from	ListMaster LM inner join
		ListDetail LD
on		LM.pListMasterID = LD.fListMasterID
where	LM.ListName = 'IMFastFields'


select	[CODE] as ValidFinish
from	CatalogPlating
order by [Code]



select ChangeID, BoxSize, * from ItemMaster where ChangeID='TodTestBoxSizeBULK'


select * from tIMFastMaintTest where EntryID='TodTestBoxSizeBULK'


select * from tIMFastMaintTest where EntryID='TodTest9' and ISNUMERIC(NewData)<>1



select * from
t_20120614_IMFastMaint02Update15871tod_BoxSize 


select distinct Orig_BoxSize
 from
t_20120614_IMFastMaint02Update15871tod_BoxSize 
order by Orig_BoxSize


SELECT DISTINCT rtrim(ItemNo) FROM ItemMaster (NOLOCK) WHERE ItemStat = 'M'
 and
rtrim(ItemNo) not in (select distinct Orig_BoxSize
 from
t_20120614_IMFastMaint02Update15871tod_BoxSize )


SELECT * FROM OpenRowSet('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=\\pfcfiles\ItemFastMaint\IMFastMaint02Import15916tod.xls;IMEX=1', 'SELECT [Item] as ItemNo, [Orig: Harmonizing Code] as Orig_Tariff, [Mod: Harmonizing Code] as Tariff FROM [Tariff] WHERE 1=1')


select distinct Tariff from itemMaster



update t_20120614_IMFastMaint02Update15871tod_BoxSize
set BoxSize=001


select 
changeid as ID, changedt, ListPrice, Tariff, catdesc,
* from ItemMaster where ChangeID='todtest3'

select * from tIMFastMaintTest 



delete from tIMFastMaintTest


select ListPrice, ChangeID, ChangeDT, * from ItemMaster 
--update ItemMaster set ListPrice = 0.88, changeid='reset'
where ItemNo in
(
'00200-0001-661',
'00200-2400-000',
'00200-2400-001',
'00200-2400-002',
'00200-2400-004',
'00200-2400-020',
'00200-2400-022'
)

select Tariff, ChangeID, ChangeDT, * from ItemMaster 
--update ItemMaster set Tariff = 'xxx', changeid='reset'
where ItemNo in
(
'00200-2400-024',
'00200-2400-025',
'00200-2400-026',
'00200-2400-027',
'00200-2400-029'
)


select * from softlockstats where tablerowitem='ItemMaster'

declare @LockStat varchar(5)
@LockStat = 



DECLARE @LockID VARCHAR(50)
DECLARE @LockStat VARCHAR(5)
DECLARE @tSoftLockStat TABLE (EntryID VARCHAR(50), Status VARCHAR(5))
INSERT	INTO @tSoftLockStat EXEC psoftlock 'ItemMaster', 'Lock', 1, 'todtest9','FIMM'
INSERT	INTO @tSoftLockStat EXEC psoftlock 'ItemMaster', 'Lock', 1, 'todtest9','FIMM'

select * from @tSoftLockStat

--SELECT	@LockID = EntryID, @LockStat = Status FROM @tSoftLockStat
--PRINT	'ID: ' + @LockID + ' - Status: ' + @LockStat
delete	@tSoftLockStat
--PRINT	'ID: ' + @LockID + ' - Status: ' + @LockStat
delete	@tSoftLockStat
select * from @tSoftLockStat
INSERT	INTO @tSoftLockStat EXEC psoftlock 'ItemMaster', 'Lock', 1, 'todtest9','FIMM'
select * from @tSoftLockStat



EXEC psoftlock 'ItemMaster', 'Lock', 168174, 'todtestlock','FIMM'



select * from softlockstats where tablerowitem='ItemMaster'
