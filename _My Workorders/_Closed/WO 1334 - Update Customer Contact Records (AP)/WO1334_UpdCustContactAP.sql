
select * from tCustomerContact
where ContactType='AP' and CustNo='000010'
order by ContactType, CustNo


update tCustomerContact
set Name='Tod'
where ContactType='AP' and CustNo='000010'

-------------------------------------------------------------------


UPDATE	tCustomerContact
SET	[Name] = APCont.[Name],
	JobTitle = APCont.JobTitle,
	Phone = APCont.Phone,
	FaxNo = APCont.FaxNo,
	EmailAddr = APCont.EmailAddr,
	Department = APCont.Department,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	(
	--SELECT Cust Contact Records with corresponding CBR record
	SELECT	AddyID.pCustomerAddressID AS fCustAddrID,
		Cust.[No_] AS CustNo,
		'AP' AS ContactType,
		Cust.[Contact] AS [Name],
		'A/P Manager' AS JobTitle,
		Cont.[Phone No_] AS Phone,
		Cont.[Fax No_] AS FaxNo,
		Cont.[E-Mail] AS EmailAddr,
		'' AS Department,
		'P' AS ContactCd,
		'Y' AS AllowMarketingEmailInd --,
--		AddyID.Type AS AddressType,
--		CBR.[Business Relation Code] AS CBRCode,
--		Cont.*
	FROM	[Porteous$Contact] Cont INNER JOIN
		[Porteous$Contact Business Relation] CBR
	ON	Cont.[No_] = CBR.[Contact No_] INNER JOIN
		[Porteous$Customer] Cust
	ON	CBR.[No_] = Cust.[No_] INNER JOIN
	(SELECT	ERPCust.CustNo, ERPCust.pCustMstrID, Addy.* 
	 FROM	tCustomerMaster ERPCust INNER JOIN
		tCustomerAddress Addy
	 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
	 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
	ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE	CBR.[Business Relation Code] = 'CUST' AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
		(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_])) APCont
WHERE	tCustomerContact.ContactType = 'AP' AND tCustomerContact.ContactCd = 'P' AND
	tCustomerContact.fCustAddrID = APCont.fCustAddrID AND tCustomerContact.CustNo = APCont.CustNo AND
	(tCustomerContact.[Name] <> APCont.[Name] OR tCustomerContact.JobTitle <> APCont.JobTitle OR
	 tCustomerContact.Phone <> APCont.Phone OR tCustomerContact.FaxNo <> APCont.FaxNo OR
	 tCustomerContact.EmailAddr <> APCont.EmailAddr OR tCustomerContact.Department <> APCont.Department)




--SELECT Cust Contact Records with corresponding CBR record that are not already loaded
SELECT	AddyID.pCustomerAddressID AS fCustAddrID,
	Cust.[No_] AS CustNo,
	'AP' AS ContactType,
	Cust.[Contact] AS [Name],
	'A/P Manager' AS JobTitle,
	Cont.[Phone No_] AS Phone,
	Cont.[Fax No_] AS FaxNo,
	Cont.[E-Mail] AS EmailAddr,
	'' AS Department,
	EntryID = 'WO1334_UpdCustContactAP',
	EntryDt = GETDATE(),
	'P' AS ContactCd,
	'Y' AS AllowMarketingEmailInd --,
--	AddyID.Type AS AddressType,
--	CBR.[Business Relation Code] AS CBRCode,
--	Cont.*
FROM	[Porteous$Contact] Cont INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	Cont.[No_] = CBR.[Contact No_] INNER JOIN
	[Porteous$Customer] Cust
ON	CBR.[No_] = Cust.[No_] INNER JOIN
(SELECT	ERPCust.CustNo, ERPCust.pCustMstrID, Addy.* 
 FROM	tCustomerMaster ERPCust INNER JOIN
	tCustomerAddress Addy
 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	CBR.[Business Relation Code] = 'CUST' AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
	(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   tCustomerContact
		    WHERE  ContactType = 'AP' AND ContactCd = 'P' AND
			   fCustAddrID = AddyID.pCustomerAddressID AND CustNo = Cust.[No_])


-------------------------------------------------------------------


UPDATE	tCustomerContact
SET	[Name] = APCont.[Name],
	JobTitle = APCont.JobTitle,
	Phone = APCont.Phone,
	FaxNo = APCont.FaxNo,
	EmailAddr = APCont.EmailAddr,
	Department = APCont.Department,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	(
	--SELECT Cust Contact Records with no corresponding CBR record
	SELECT	AddyID.pCustomerAddressID AS fCustAddrID,
		Cust.[No_] AS CustNo,
		'AP' AS ContactType,
		Cust.[Contact] AS [Name],
		'A/P Manager' AS JobTitle,
		Cont.[Phone No_] AS Phone,
		Cont.[Fax No_] AS FaxNo,
		Cont.[E-Mail] AS EmailAddr,
		'' AS Department,
		'P' AS ContactCd,
		'Y' AS AllowMarketingEmailInd --,
	--	AddyID.Type AS AddressType,
	--	Cont.*
	FROM	[Porteous$Contact] Cont INNER JOIN
		[Porteous$Customer] Cust
	ON	Cont.[No_] = Cust.[Primary Contact No_] INNER JOIN
	(SELECT	ERPCust.CustNo, ERPCust.pCustMstrID, Addy.* 
	 FROM	tCustomerMaster ERPCust INNER JOIN
		tCustomerAddress Addy
	 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
	 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
	ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE	Cust.[Primary Contact No_] <> '' AND Cust.[Primary Contact No_] IS NOT null AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
		(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
		NOT EXISTS (SELECT *
			    FROM   [Porteous$Contact Business Relation] CBR
			    WHERE  CBR.[Business Relation Code] = 'CUST' AND CBR.[No_]=Cust.[No_])) APCont
WHERE	tCustomerContact.ContactType = 'AP' AND tCustomerContact.ContactCd = 'P' AND
	tCustomerContact.fCustAddrID = APCont.fCustAddrID AND tCustomerContact.CustNo = APCont.CustNo AND
	(tCustomerContact.[Name] <> APCont.[Name] OR tCustomerContact.JobTitle <> APCont.JobTitle OR
	 tCustomerContact.Phone <> APCont.Phone OR tCustomerContact.FaxNo <> APCont.FaxNo OR
	 tCustomerContact.EmailAddr <> APCont.EmailAddr OR tCustomerContact.Department <> APCont.Department)








--SELECT Cust Contact Records with no corresponding CBR record that are not already loaded
SELECT	AddyID.pCustomerAddressID AS fCustAddrID,
	Cust.[No_] AS CustNo,
	'AP' AS ContactType,
	Cust.[Contact] AS [Name],
	'A/P Manager' AS JobTitle,
	Cont.[Phone No_] AS Phone,
	Cont.[Fax No_] AS FaxNo,
	Cont.[E-Mail] AS EmailAddr,
	'' AS Department,
	EntryID = 'WO1334_UpdCustContactAP',
	EntryDt = GETDATE(),
	'P' AS ContactCd,
	'Y' AS AllowMarketingEmailInd --,
--	AddyID.Type AS AddressType,
--	Cont.*
FROM	[Porteous$Contact] Cont INNER JOIN
	[Porteous$Customer] Cust
ON	Cont.[No_] = Cust.[Primary Contact No_] INNER JOIN
(SELECT	ERPCust.CustNo, ERPCust.pCustMstrID, Addy.* 
 FROM	tCustomerMaster ERPCust INNER JOIN
	tCustomerAddress Addy
 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	Cust.[Primary Contact No_] <> '' AND Cust.[Primary Contact No_] IS NOT null AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
	(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   [Porteous$Contact Business Relation] CBR
		    WHERE  CBR.[Business Relation Code] = 'CUST' AND CBR.[No_]=Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   tCustomerContact
		    WHERE  ContactType = 'AP' AND ContactCd = 'P' AND
			   fCustAddrID = AddyID.pCustomerAddressID AND CustNo = Cust.[No_])


-------------------------------------------------------------------


select * from tCustomerContact
where ContactType='AP' and pCustContactsID=4213 --and CustNo='000010'
order by ContactType, CustNo


select CustContacts as cont, fCustContactsID, * from tCustomerAddress
where 
(CustContacts <>'' and  CustContacts is not null) or
(fCustContactsID<>'' and  fCustContactsID is not null)
order by cont

update tCustomerAddress
set CustContacts = '',
	fCustContactsID=''



-------------------------------------------------------------------




UPDATE	tCustomerAddress
SET	fCustContactsID = APCont.pCustContactsID,
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	tCustomerContact APCont
WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = tCustomerAddress.pCustomerAddressID AND
	(tCustomerAddress.fCustContactsID = '' OR tCustomerAddress.fCustContactsID is null)



UPDATE	tCustomerAddress
SET	CustContacts = Cont.[Name],
	ChangeID = 'WO1334_UpdCustContactAP',
	ChangeDt = GETDATE()
FROM	tCustomerContact Cont
WHERE	pCustContactsID = fCustContactsID AND (CustContacts = '' OR CustContacts is null)



----UPDATE	tCustomerAddress
----SET	CustContacts = APCont.[Name],
----	ChangeID = 'WO1334_UpdCustContactAP',
----	ChangeDt = GETDATE()
----FROM	tCustomerContact APCont
----WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = tCustomerAddress.pCustomerAddressID AND
----	(tCustomerAddress.[CustContacts] = '' or tCustomerAddress.[CustContacts] is null)


