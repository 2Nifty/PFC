
select CustCd, * from CustomerMaster where CustCd='BT' and pCustMstrID=8358
select CustCd, * from CustomerMaster where fBillToNo='100000'


select LocationName, Cust.CustNo, Addr.* from CustomerAddress Addr inner join
CustomerMaster Cust on pCustMstrID = fCustomerMasterID
-- where fCustomerMasterID=8358
order by fCustomerMasterID






select	CustNo, CustCd, tmp.*
from	CustomerMaster inner join
	(select	Addr.fCustomerMasterID, DSHP.Type as [DSHP.Type], Addr.Type as [Addr.Type],
		CASE WHEN DSHP.Name2 <> Addr.Name2 THEN DSHP.Name2 ELSE '' END as [DSHP.Name2], CASE WHEN DSHP.Name2 <> Addr.Name2 THEN Addr.Name2 ELSE '' END as [Addr.Name2],
		CASE WHEN DSHP.AddrLine1 <> Addr.AddrLine1 THEN DSHP.AddrLine1 ELSE '' END as [DSHP.AddrLine1], CASE WHEN DSHP.AddrLine1 <> Addr.AddrLine1 THEN Addr.AddrLine1 ELSE '' END as [Addr.AddrLine1],
		CASE WHEN DSHP.AddrLine2 <> Addr.AddrLine2 THEN DSHP.AddrLine2 ELSE '' END as [DSHP.AddrLine2], CASE WHEN DSHP.AddrLine2 <> Addr.AddrLine2 THEN Addr.AddrLine2 ELSE '' END as [Addr.AddrLine2],
		CASE WHEN DSHP.City <> Addr.City THEN DSHP.City ELSE '' END as [DSHP.City], CASE WHEN DSHP.City <> Addr.City THEN Addr.City ELSE '' END as [Addr.City],
		CASE WHEN DSHP.State <> Addr.State THEN DSHP.State ELSE '' END as [DSHP.State], CASE WHEN DSHP.State <> Addr.State THEN Addr.State ELSE '' END as [Addr.State],
		CASE WHEN DSHP.PostCd <> Addr.PostCd THEN DSHP.PostCd ELSE '' END as [DSHP.PostCd], CASE WHEN DSHP.PostCd <> Addr.PostCd THEN Addr.PostCd ELSE '' END as [Addr.PostCd],
		CASE WHEN DSHP.Country <> Addr.Country THEN DSHP.Country ELSE '' END as [DSHP.Country], CASE WHEN DSHP.Country <> Addr.Country THEN Addr.Country ELSE '' END as [Addr.Country],
		CASE WHEN DSHP.PhoneNo <> Addr.PhoneNo THEN DSHP.PhoneNo ELSE '' END as [DSHP.PhoneNo], CASE WHEN DSHP.PhoneNo <> Addr.PhoneNo THEN Addr.PhoneNo ELSE '' END as [Addr.PhoneNo],
		CASE WHEN DSHP.CustContacts <> Addr.CustContacts THEN DSHP.CustContacts ELSE '' END as [DSHP.CustContacts], CASE WHEN DSHP.CustContacts <> Addr.CustContacts THEN Addr.CustContacts ELSE '' END as [Addr.CustContacts],
		CASE WHEN DSHP.UPSZone <> Addr.UPSZone THEN DSHP.UPSZone ELSE '' END as [DSHP.UPSZone], CASE WHEN DSHP.UPSZone <> Addr.UPSZone THEN Addr.UPSZone ELSE '' END as [Addr.UPSZone],
--		DSHP.UPSZone as [DSHP.UPSZone1], Addr.UPSZone as [Addr.UPSZone1],
		CASE WHEN DSHP.FaxPhoneNo <> Addr.FaxPhoneNo THEN DSHP.FaxPhoneNo ELSE '' END as [DSHP.FaxPhoneNo], CASE WHEN DSHP.FaxPhoneNo <> Addr.FaxPhoneNo THEN Addr.FaxPhoneNo ELSE '' END as [Addr.FaxPhoneNo],
		CASE WHEN DSHP.Email <> Addr.Email THEN DSHP.Email ELSE '' END as [DSHP.Email], CASE WHEN DSHP.Email <> Addr.Email THEN Addr.Email ELSE '' END as [Addr.Email],
		CASE WHEN DSHP.LocationName <> Addr.LocationName THEN DSHP.LocationName ELSE '' END as [DSHP.LocationName], CASE WHEN DSHP.LocationName <> Addr.LocationName THEN Addr.LocationName ELSE '' END as [Addr.LocationName],
		CASE WHEN DSHP.Name1 <> Addr.Name1 THEN DSHP.Name1 ELSE '' END as [DSHP.Name1], CASE WHEN DSHP.Name1 <> Addr.Name1 THEN Addr.Name1 ELSE '' END as [Addr.Name1]
	 from	CustomerAddress Addr inner join
		(select * from CustomerAddress where Type='DSHP') DSHP
	 on	DSHP.fCustomerMasterID = Addr.fCustomerMasterID
	 where	(Addr.Type = '' or Addr.Type = 'P') and
		(DSHP.Name2 <> Addr.Name2 OR 
		 DSHP.AddrLine1 <> Addr.AddrLine1 OR 
		 DSHP.AddrLine2 <> Addr.AddrLine2 OR 
		 DSHP.City <> Addr.City OR 
		 DSHP.State <> Addr.State OR 
		 DSHP.PostCd <> Addr.PostCd OR 
		 DSHP.Country <> Addr.Country OR 
		 DSHP.PhoneNo <> Addr.PhoneNo OR 
		 DSHP.CustContacts <> Addr.CustContacts OR 
		 DSHP.UPSZone <> Addr.UPSZone OR 
		 DSHP.FaxPhoneNo <> Addr.FaxPhoneNo OR 
		 DSHP.Email <> Addr.Email OR 
		 DSHP.LocationName <> Addr.LocationName OR 
		 DSHP.Name1 <> Addr.Name1)) tmp
on	CustomerMaster.pCustMstrID = tmp.fCustomerMasterID
order by CustomerMaster.CustNo




