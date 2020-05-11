select * from listmaster where listname in ('SuperEquivUOM','SellPurUOM','ItemCalcUOM','PCLBFTInd')


select * from ListMaster where plistmasterid=159
select * from ListDetail where flistmasterid=159

delete from ListMaster where plistmasterid=159


select ListName, ListValue, ListDtlDesc
from listmaster (nolock) inner join listdetail (nolock) on plistmasterid=flistmasterid
where listname in ('SuperEquivUOM','SellPurUOM','ItemCalcUOM','PCLBFTInd')
order by ListName, ListValue


insert into listmaster
(ListName, ListDesc, SystemRequiredInd, UserOptionInd, ListStatusCd, Comments, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd)
select ListName, ListDesc, SystemRequiredInd, UserOptionInd, ListStatusCd, Comments, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd
select *
from perp.dbo.listmaster where listname in ('SuperEquivUOM','SellPurUOM','ItemCalcUOM')


insert into listdetail
(fListMasterID
,ListValue
,ListDtlDesc
,SequenceNo
,GLAccountNo
,Comments
,EntryID
,EntryDt
,ChangeID
,ChangeDt
,StatusCd
,GroupCd
,GroupSequence
,ListPercent
,CalcDuty)
select
162
,ListValue
,ListDtlDesc
,SequenceNo
,GLAccountNo
,Comments
,EntryID
,EntryDt
,ChangeID
,ChangeDt
,StatusCd
,GroupCd
,GroupSequence
,ListPercent
,CalcDuty
from perp.dbo.ListDetail where flistmasterid=163

exec sp_columns listdetail 
