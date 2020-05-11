select * from EDITradingPartner
where isnull(LocationCustomerNo,'BAD') not in
(select CustNo from CustomerMaster)






--Get Last EDI SO Order Number from AppPref
SELECT	AppOptionValue,* 
FROM	AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'

--Get Last EDI SW Order Number from AppPref
SELECT	AppOptionValue,* 
FROM	AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'



	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = 'SO3020030', ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'




select * from tWO1376_Daily_SO_EDI_To_ERP


---------------------------------------------------------------------------------------


select EntryDt, EntryID, RefSONo, * from SOHeader NVHDR where 	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP tmp
--		WHERE	'xxx' + left(tmp.RefSONo,9) = left(NVHDR.[RefSONo],12))
		WHERE	left(tmp.RefSONo,9) = left(NVHDR.[RefSONo],9))


UPDATE SOHeader
set RefSONo = 'xxx' + RefSONo
where 	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP tmp
		WHERE	left(tmp.RefSONo,9) = left(SOHeader.[RefSONo],9))


select RefSoNo, * from SOHeader where left(RefSONo,1)='x'


---------------------------------------------------------------------------------------


select ShipLoc, RefSONo, * from SOHeader --where left(RefSONo,2)='SO'
where left(RefSONo,9) in 
('SO3020256',
'SO3021801',
'SO3021805',
'SO3024514',
'SO3026538',
'SO3026541',
'SO3026542',
'SO3026545',
'SO3026614',
'SO3029508',
'SO3029509',
'SO3029510',
'SO3029511',
'SO3029513',
'SO3029515',
'SO3029517',
'SO3029518',
'SO3029519',
'SO3029520')

