select OrderType, OrderTypeDsc, SubType from SOHeader order by OrderType




--UPDATE OrderType

--Pallet Partners
UPDATE	SOHeader
SET	OrderType = 'PP'
WHERE	OrderType = '4'


--Special Processing
UPDATE	SOHeader
SET	OrderType = '00'
WHERE	OrderType = '3'


--Stock & Release
UPDATE	SOHeader
SET	OrderType = '04'
WHERE	OrderType = '2'



--UPDATE OrderTypeDesc & SubType
UPDATE	SOHeader
SET	OrderTypeDsc = ListDtlDesc,
	SubType = SequenceNo
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	SOHeader
ON	OrderType = ListValue
WHERE	ListName='soeordertypes'


update SOHeader set OrderType=RIGHT(OrderType,3)



select * From ListMaster INNER JOIN ListDetail ON pListMasterID=fListMasterID
where ListName='soeordertypes'


delete from ListMaster where ListName='soeordertypes'



