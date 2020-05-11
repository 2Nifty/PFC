select ListName, ListDesc, ListMaster.Comments, ListValue AS [POType (ListValue)], ListDtlDesc as [POTypeName (ListDtlDesc)], SequenceNo as [POSubType (SequenceNo)]
From ListMaster INNER JOIN ListDetail ON pListMasterID=fListMasterID
where ListName='poeordertypes'


select *
From ListMaster INNER JOIN ListDetail ON pListMasterID=fListMasterID
where ListName='poeordertypes'


select * from ListDetail order by --fListMasterID
pListDetailID

-----------------------------------------------------------------------------


select POType, POTypeName, POSubType from POHeader
order by POType



--UPDATE POTypeName & POSubType
UPDATE	POHeader
SET	POTypeName = ListDtlDesc,
	POSubType = SequenceNo
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	POHeader
ON	POType = ListValue
WHERE	ListName='poeordertypes'