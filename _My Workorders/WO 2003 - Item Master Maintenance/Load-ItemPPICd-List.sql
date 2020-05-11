
select top 1 ld.* 
into #tItemPPICd
from listmaster lm inner join listdetail ld
on lm.plistmasterid=ld.flistmasterid
where lm.listname='ItemPPICd'
order by Listvalue

--exec sp_columns ListDetail

select * from #tItemPPICd

fListMasterID
ListValue
ListDtlDesc
SequenceNo
GLAccountNo
Comments
EntryID
EntryDt
ChangeID
ChangeDt
StatusCd
GroupCd
GroupSequence
ListPercent
CalcDuty

--------------------------------------------------------

DECLARE	@fListMasterID INT

SELECT	@fListMasterID = pListMasterID
FROM	ListMaster
WHERE	ListName = 'ItemPPICd'

print	@fListMasterID

DELETE
FROM	ListDetail
WHERE	fListMasterID = @fListMasterID

INSERT INTO		ListDetail
				(fListMasterID
				 ,ListValue
				 ,ListDtlDesc
				 ,SequenceNo
				 ,GLAccountNo
				 ,EntryID
				 ,EntryDt)
SELECT DISTINCT	@fListMasterID as fListMasterID,
				PPICode as ListValue,
				'PPI Code' as ListDtlDesc, 
				1 as SequenceNo,
				0 as GLAccountNo,
				'LoadFromIM' as EntryID,
				getdate() as EntryDt
FROM	ItemMaster
WHERE	isnull(PPICode,'') <> ''
ORDER BY PPICode





select * from #tItemPPICd




select * from Listmaster inner join listdetail on plistmasterid=flistmasterid where listname='ItemPPICd'
