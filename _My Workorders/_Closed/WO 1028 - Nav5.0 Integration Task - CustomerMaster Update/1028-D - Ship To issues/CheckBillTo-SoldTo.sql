select	fBillToNo, CustCd, *
from	CustomerMaster
where	CustNo='052935'   --BTST
or	CustNo='079117'   --BTST
or	CustNo='052651'   --ST
or	CustNo='071965'   --BTST
or	CustNo='100000'   --BT
Order By pCustMstrID


select * from CustomerAddress where 
(fCustomerMasterID=5039 or
fCustomerMasterID=5059 or
fCustomerMasterID=6609 or
fCustomerMasterID=7291 or
fCustomerMasterID=8358) AND
(Type='' or Type='P')
order by fCustomerMasterID




select [Bill-to Customer No_], * from PFCFINANCE.dbo.[Porteous$Customer] where [No_]=[Bill-to Customer No_]


select distinct CustCd from CustomerMaster
select * from CustomerMaster where CustCd='BT'