
select * from PERP.dbo.CustomerContact
where ContactType='AP' and CustNo='000010'
order by ContactType, CustNo


update PERP.dbo.CustomerContact
set Name='Tod'
where ContactType='AP' and CustNo='000010'

-------------------------------------------------------------------

--UPDATE Existing AP Contacts (with CBR)
UPDATE	PERP.dbo.CustomerContact
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
	 FROM	PERP.dbo.CustomerMaster ERPCust INNER JOIN
		PERP.dbo.CustomerAddress Addy
	 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
	 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
	ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE	CBR.[Business Relation Code] = 'CUST' AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
		(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_])) APCont
WHERE	PERP.dbo.CustomerContact.ContactType = 'AP' AND PERP.dbo.CustomerContact.ContactCd = 'P' AND
	PERP.dbo.CustomerContact.fCustAddrID = APCont.fCustAddrID AND
	PERP.dbo.CustomerContact.CustNo = APCont.CustNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
	(PERP.dbo.CustomerContact.[Name] <> APCont.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.JobTitle <> APCont.JobTitle COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.Phone <> APCont.Phone COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.FaxNo <> APCont.FaxNo COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.EmailAddr <> APCont.EmailAddr COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.Department <> APCont.Department COLLATE SQL_Latin1_General_CP1_CI_AS)




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
 FROM	PERP.dbo.CustomerMaster ERPCust INNER JOIN
	PERP.dbo.CustomerAddress Addy
 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	CBR.[Business Relation Code] = 'CUST' AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
	(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   PERP.dbo.CustomerContact
		    WHERE  ContactType = 'AP' AND ContactCd = 'P' AND
			   fCustAddrID = AddyID.pCustomerAddressID AND CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS)


-------------------------------------------------------------------

--UPDATE Existing AP Contacts (no CBR)
UPDATE	PERP.dbo.CustomerContact
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
	 FROM	PERP.dbo.CustomerMaster ERPCust INNER JOIN
		PERP.dbo.CustomerAddress Addy
	 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
	 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
	ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE	Cust.[Primary Contact No_] <> '' AND Cust.[Primary Contact No_] IS NOT null AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
		(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
		NOT EXISTS (SELECT *
			    FROM   [Porteous$Contact Business Relation] CBR
			    WHERE  CBR.[Business Relation Code] = 'CUST' AND CBR.[No_]=Cust.[No_])) APCont
WHERE	PERP.dbo.CustomerContact.ContactType = 'AP' AND PERP.dbo.CustomerContact.ContactCd = 'P' AND
	PERP.dbo.CustomerContact.fCustAddrID = APCont.fCustAddrID AND
	PERP.dbo.CustomerContact.CustNo = APCont.CustNo COLLATE SQL_Latin1_General_CP1_CI_AS AND
	(PERP.dbo.CustomerContact.[Name] <> APCont.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.JobTitle <> APCont.JobTitle COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.Phone <> APCont.Phone COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.FaxNo <> APCont.FaxNo COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.EmailAddr <> APCont.EmailAddr COLLATE SQL_Latin1_General_CP1_CI_AS OR
	 PERP.dbo.CustomerContact.Department <> APCont.Department COLLATE SQL_Latin1_General_CP1_CI_AS)









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
 FROM	PERP.dbo.CustomerMaster ERPCust INNER JOIN
	PERP.dbo.CustomerAddress Addy
 ON	ERPCust.pCustMstrID = Addy.fCustomerMasterID
 WHERE	(Addy.Type='P' OR Addy.Type='')) AddyID
ON	AddyID.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	Cust.[Primary Contact No_] <> '' AND Cust.[Primary Contact No_] IS NOT null AND Cust.[Contact] <> '' AND Cust.[Contact] IS NOT null AND
	(Cust.[Bill-to Customer No_] = '' OR Cust.[Bill-to Customer No_] = Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   [Porteous$Contact Business Relation] CBR
		    WHERE  CBR.[Business Relation Code] = 'CUST' AND CBR.[No_]=Cust.[No_]) AND
	NOT EXISTS (SELECT *
		    FROM   PERP.dbo.CustomerContact
		    WHERE  ContactType = 'AP' AND ContactCd = 'P' AND
			   fCustAddrID = AddyID.pCustomerAddressID AND CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS)


-------------------------------------------------------------------


select * from PERP.dbo.CustomerContact
where ContactType='AP' and pCustContactsID=4213 --and CustNo='000010'
order by ContactType, CustNo


select CustContacts as cont, fCustContactsID, * from PERP.dbo.CustomerAddress
where 
(CustContacts <>'' and  CustContacts is not null) or
(fCustContactsID<>'' and  fCustContactsID is not null)
order by cont

update PERP.dbo.CustomerAddress
set CustContacts = '',
	fCustContactsID=''



-------------------------------------------------------------------



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




------Update CustContacts = [Name]
----UPDATE	CustomerAddress
----SET	CustContacts = APCont.[Name],
----	ChangeID = 'WO1334_UpdCustContactAP',
----	ChangeDt = GETDATE()
----FROM	CustomerContact APCont
---WHERE	APCont.ContactType = 'AP' AND APCont.ContactCd = 'P' AND APCont.fCustAddrID = CustomerAddress.pCustomerAddressID AND
----	(CustomerAddress.[CustContacts] = '' or CustomerAddress.[CustContacts] is null)






