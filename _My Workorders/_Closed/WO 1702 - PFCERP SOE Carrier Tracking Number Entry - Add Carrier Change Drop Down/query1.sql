select BOLNO, OrderCarrier, OrderCarName as CarName,  * from SOHeaderRel where InvoiceDt is null and OrderNo ='100073'
order by OrderCarName
--exec sp_columns SOHeaderRel


select	LM.ListName, LM.ListDesc, LM.Comments,
	LD.ListValue, LD.ListDtlDesc,
	Tbl.TableCd, Tbl.Dsc,
	LD.*
from	ListMaster LM inner join
	ListDetail LD
on	LM.pListMasterID = LD.fListMasterID inner join
	Tables Tbl
on	Tbl.TableCd = LD.ListValue
where	LM.ListName = 'ApprovedCarriers' and Tbl.TableType = 'CAR'
order by LM.ListName, LD.ListValue


select * from listMaster where	ListName = 'ApprovedCarriers'

select *
from OpenDataSource('SQLOLEDB','Data Source=pfcrfdb;User ID=pfcnormal;Password=pfcnormal').SLive.dbo.tblCarriers
where CarrierCode in (select ShortDsc from Tables where TableType='CAR')

select * from Tables
where TableType='CAR'
order by TableCd



------------------------------------------------------------------------------------------


DELETE
FROM	ListDetail
WHERE	fListMasterID in (SELECT pListMasterID FROM ListMaster WHERE ListName = 'ApprovedCarriers')



--query for DTS to populate new list
SELECT	LM.pListMasterID as fListMasterID,
	TBL.TableCd as ListValue,
	TBL.Dsc as ListDtlDesc,
	0 as SequenceNo,	--???
	'WO1702' as EntryID,
	GetDate() as EntryDt
FROM	ListMaster LM, Tables TBL INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcrfdb;User ID=pfcnormal;Password=pfcnormal').SLive.dbo.tblCarriers SLive
ON	TBL.ShortDsc = SLive.CarrierCode
WHERE	LM.ListName = 'ApprovedCarriers' AND TableType='CAR'


UPDATE	ListDetail
SET	SequenceNo = pListDetailID - SeqID
FROM	(SELECT	TOP 1 pListDetailID-1 AS SeqID
	 FROM	ListMaster INNER JOIN
		ListDetail
	 ON	pListMasterID = fListMasterID
	 WHERE	ListName = 'ApprovedCarriers') wrk,
	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID = fListMasterID
WHERE	ListName = 'ApprovedCarriers'



--Populate ddl
SELECT	Tbl.TableCd, Tbl.Dsc --,
FROM	ListMaster LM INNER JOIN
	ListDetail LD
ON	LM.pListMasterID = LD.fListMasterID INNER JOIN
	Tables Tbl
ON	Tbl.TableCd = LD.ListValue
WHERE	LM.ListName = 'ApprovedCarriers' AND Tbl.TableType = 'CAR'
ORDER BY Tbl.TableCd

------------------------------------------------------------------------------------------


SELECT	pListDetailID - SeqID
FROM	(SELECT	TOP 1 pListDetailID-1 AS SeqID
	 FROM	ListMaster INNER JOIN
		ListDetail
	 ON	pListMasterID = fListMasterID
	 WHERE	ListName = 'ApprovedCarriers') wrk,
	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID = fListMasterID
WHERE	ListName = 'ApprovedCarriers'




select Dsc, len(Dsc) 
from Tables
where TableType='CAR'
order by len(Dsc) 


update tables
set Dsc='SALT LAKE CITY TRANSFER'
where TableCd='SLC Trf'



update ListMaster set ListName = 'ApprovedCarriers' where ListName = 'ShipLiveCar'

update ListDetail set 