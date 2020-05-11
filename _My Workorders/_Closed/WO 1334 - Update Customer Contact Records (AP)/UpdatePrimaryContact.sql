select * from tCustomerContact where fCustAddrID='128' --CustNo='001395'

select * from tCustomerMaster where CustNo='001395'

select * from tCustomerAddress where fCustomerMasterID='128'


truncate table tCustomerContact
truncate table tCustomerMaster
truncate table tCustomerAddress



select Cust.[Primary Contact No_],Cont.[No_], Cust.[Contact],Cont.[Name],Cust.[Bill-to Customer No_],* from [Porteous$Customer] Cust inner join [Porteous$Contact] Cont on Cust.[Primary Contact No_]=Cont.[No_] 
where Cust.[Primary Contact No_]<>'' and Cust.[Primary Contact No_] is not null and Cust.[Contact] <> Cont.[Name] and Cust.[Contact] <> '' and Cust.[Contact] is not null



select * from [Porteous$Contact] where [No_]='CT028078'



alter table tCustomerContact add ContactNoNV  varchar(10)


select * from tCustomerContact

select  distinct fCustomerMasterID from tCustomerAddress where fCustContactsID is not null
order by fCustomerMasterID

select ContactNoNV, * from tCustomerContact 
where fCustAddrID = 314 or
fCustAddrID = 1330724 or
fCustAddrID = 1338530


select * from 	--tCustomerMaster Cust inner join
		tCustomerAddress Addie inner join
		tCustomerContact Cust on Addie.pCustomerAddressID = Cust.fCustAddrID


-----------------------------------------------------------------------------

--UPDATE CustomerAddress
----Step A - UPDATE fCustContactsID = null & CustContacts = null
UPDATE	tCustomerAddress
SET	fCustContactsID=null,
	CustContacts = null


----Step B - UPDATE fCustContactsID = pCustContactsID based on [Porteous$Customer.[Primary Contact No_]
UPDATE	tCustomerAddress
SET	fCustContactsID = APCont.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	[Porteous$Customer] NVCust INNER JOIN
	tCustomerContact APCont
ON	NVCust.[Primary Contact No_] = APCont.ContactNoNV INNER JOIN
	tCustomerMaster ERPCust
ON	NVCust.[No_] = ERPCust.CustNo
where	NVCust.[Primary Contact No_] <>'' AND NVCust.[Primary Contact No_] is not null AND
--	NVCust.[No_] = ERPCust.CustNo AND
--	tCustomerAddress.fCustomerMasterID = ERPCust.pCustMstrID AND
	tCustomerAddress.pCustomerAddressID = APCont.fCustAddrID


----Step C - UPDATE fCustContactsID = pCustContactsID based on AP Contacts
UPDATE	tCustomerAddress
SET	fCustContactsID = APCont.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	tCustomerContact APCont
WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = tCustomerAddress.pCustomerAddressID AND
	(tCustomerAddress.fCustContactsID = '' OR tCustomerAddress.fCustContactsID is null)


----Step D - UPDATE remaining fCustContactsID = pCustContactsID
UPDATE	tCustomerAddress
SET	fCustContactsID = Upd.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	tCustomerAddress Addie INNER JOIN
	(SELECT	fCustAddrID, MIN(pCustContactsID) AS pCustContactsID FROM tCustomerContact GROUP BY fCustAddrID) Upd
ON	Addie.pCustomerAddressID = Upd.fCustAddrID
WHERE	(Addie.fCustContactsID = '' OR Addie.fCustContactsID is null)


----Step E - UPDATE CustContacts = [Name] based on fCustContactsID
UPDATE	tCustomerAddress
SET	CustContacts = Cont.[Name],
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	tCustomerContact Cont
WHERE	pCustContactsID = fCustContactsID AND (CustContacts = '' OR CustContacts is null)





select * from tCustomerAddress where ChangeID = 'WO1334_UpdCustContactAP'

select *   -- distinct fCustomerMasterID 
from tCustomerAddress where fCustContactsID is not null

select fCustContactsID, * from tCustomerAddress Addie
where NOT EXISTS (SELECT * FROM tCustomerContact where fCustAddrID = Addie.pCustomerAddressID) --and fCustContactsID is not null




-----------------------------------------------------------------------------


--Update fCustContactsID = pCustContactsID
UPDATE	CustomerAddress
SET	fCustContactsID = APCont.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	CustomerContact APCont
WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = CustomerAddress.pCustomerAddressID AND
	(CustomerAddress.fCustContactsID = '' OR CustomerAddress.fCustContactsID is null)


--Update CustContacts = [Name]
UPDATE	CustomerAddress
SET	CustContacts = Cont.[Name],
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	CustomerContact Cont
WHERE	pCustContactsID = fCustContactsID AND (CustContacts = '' OR CustContacts is null)



-----------------------------------------------------------------------------




select fCustContactsID, CustContacts, CustNo as No, * from tCustomerAddress inner join tCustomerMaster on fCustomerMasterID=pCustMstrID
where fCustContactsID is not null
order by No

select ContactNoNV, * from tCustomerContact where pCustContactsID=6994 or pCustContactsID=6980


select * from tCustomerMaster where CustNo='003699'
select * from tCustomerAddress where fCustomerMasterID=300
select * from tCustomerContact where ContactNoNV='CT024254'--CustNo='003699'


--Update fCustContactsID = pCustContactsID
UPDATE	tCustomerAddress
SET	fCustContactsID = APCont.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
--FROM	CustomerContact APCont
--WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = CustomerAddress.pCustomerAddressID AND
--	(CustomerAddress.fCustContactsID = '' OR CustomerAddress.fCustContactsID is null)


--select DISTINCT NVCust.[Primary Contact No_], APCont.ContactNoNV, NVCust.[No_]
FROM	[Porteous$Customer] NVCust INNER JOIN
	tCustomerContact APCont
ON	NVCust.[Primary Contact No_] = APCont.ContactNoNV --INNER JOIN
--	tCustomerMaster ERPCust
--ON	NVCust.[No_] = ERPCust.CustNo
where	NVCust.[Primary Contact No_] <>'' and NVCust.[Primary Contact No_] is not null AND
	NVCust.[No_] = ERPCust.CustNo AND
	tCustomerAddress.fCustomerMasterID = ERPCust.pCustMstrID AND
--	APCont.fCustAddrID = tCustomerAddress.pCustomerAddressID





--Update CustContacts = [Name]
UPDATE	CustomerAddress
SET	CustContacts = Cont.[Name],
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	CustomerContact Cont
WHERE	pCustContactsID = fCustContactsID AND (CustContacts = '' OR CustContacts is null)
