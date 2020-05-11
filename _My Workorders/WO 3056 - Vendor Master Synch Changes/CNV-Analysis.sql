
select * from VendorMaster
select * from VendorAddress

select	VM.pVendMstrID, VA.pVendAddrID, VM.VendNo, VM.fPayToNo, VM.Code as ShortCode, isnull(VA.Type,'NO ADDR') as Type
from	VendorMaster VM (NoLock) left outer join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
order by VendNo, isnull(VA.Type,'NO ADDR')



select	VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where VM.VendNo in
(
select	VM.VendNo--, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where VA.Type='BF'
) 




UPDATE	VendorMaster
SET	fPayToNo = ''
WHERE	pVendMstrID = fPayToNo


--all the pay to recs (3971)
select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where	isnull(fPayToNo,'') = ''


--all the BF recs (237)
select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
WHERE	fPayToNo in 
(
--pay to IDs (3971)
select pVendMstrID
from	VendorMaster VM 
where	isnull(fPayToNo,'') = '' 
)


--4211
select count(*) from vendormaster
--4211
select count(*) from vendoraddress
--4211
select count(*)
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID



------------------------------------------------------------------------------------------------





select fPayToNo, * from VendorMaster where isnull(fPayToNo,'') <> ''



--all the pay to recs (3971)
select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where	isnull(fPayToNo,'') = ''


--all the BF recs (237)
select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
WHERE	fPayToNo in 
(
--pay to IDs (3971)
select pVendMstrID
from	VendorMaster VM 
where	isnull(fPayToNo,'') = '' 
)


------------------------------------------------------------------------------------------------




select * from VendorAddress where fVendMstrID in


--UPDATE PTBF Vendors
UPDATE	VendorAddress
SET	Type = 'PTBF'
WHERE	fVendMstrID in (SELECT	pVendMstrID
			FROM	VendorMaster VM (NoLock)
			WHERE	isnull(fPayToNo,'') = '' and
				pVendMstrID not in (SELECT fPayToNo FROM VendorMaster VM (NoLock) WHERE	isnull(fPayToNo,'') <> ''))


------------------------------------------------------------------------------------------------



select * from vendormaster where fPayToNo in (
select pVendMstrID--,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where VendNo in

('0900800',
'0901900',
'0904000',
'0904000',
'0909200',
'0916501')
)



------------------------------------------------------------------------------------------------


--LUYON is loaded like this.  One PT with many BF
select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where vendno='0009130'

select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID
where fPaytono=906





-------------------------------------------------------------------------------------------------

select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID where pVendMstrID in
(
131,
565,
870

)


select pVendMstrID,fPayToNo, VM.VendNo, VM.Code as ShortCode, VA.Type
from	VendorMaster VM (NoLock) inner join
	VendorAddress VA (NoLock)
ON	VM.pVendMstrID = VA.fVendMstrID where pVendMstrID in

(131,
285,
317,
318,
466,
565,
597,
804,
857,
870,
1133,
1205,
1246,
1247,
1248,
1263,
1292,
1293,
1480,
1481,
2048,
2225,
2257,
2299,
2303,
2344,
2345,
2365,
2397,
2405,
2408,
2428,
2501,
2537,
2538,
2677,
2688,
2695,
2823,
2996,
3030,
3076,
3125,
3149,
3150,
3166,
3228,
3256,
3267,
3285,
3298,
3300,
3301,
3303,
3304,
3305,
3309,
3329,
3333,
3342,
3343,
3348,
3431,
3468,
3594,
3608,
3639)
and  pVendMstrID <> fPayToNo
order by fPaytoNo



SELECT	pVendMstrID, VendNo
	 FROM	VendorMaster (NoLock)
where VendNo='0005404'


UPDATE	VendorMaster
SET	fPayToNo = UPD.pVendMstrID
FROM	(SELECT	pVendMstrID, VendNo
	 FROM	VendorMaster (NoLock)) UPD
WHERE	fPayToNo = UPD.VendNo
go


select fPayToNo, * from VendorMaster




select countrycd from POHeader