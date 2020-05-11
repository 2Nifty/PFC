
select * from CustomerMaster where CustNo='201700' or CustNo='202449' or CustNo='201626' or CustNo='201701'
order by pCustMstrID

--delete from CustomerMaster where CustNo='201700' or CustNo='202449' or CustNo='201626' or CustNo='201701'



select Name1, * from CustomerAddress where 
fCustomerMasterID='11521' or
fCustomerMasterID='11583' or
fCustomerMasterID='11688' or
fCustomerMasterID='11690' or
fCustomerMasterID='11689' or
fCustomerMasterID='11691' or
fCustomerMasterID='11687' or
fCustomerMasterID='11692' or
fCustomerMasterID='11713' or
fCustomerMasterID='11714' or
fCustomerMasterID='11715' or 
fCustomerMasterID='11716'
order by fCustomerMasterID

--delete from CustomerAddress where 
--fCustomerMasterID='11521' or
--fCustomerMasterID='11583' or
--fCustomerMasterID='11688' or
--fCustomerMasterID='11690' or
--fCustomerMasterID='11689' or
--fCustomerMasterID='11691' or
--fCustomerMasterID='11687' or
--fCustomerMasterID='11692'



select * from CustomerContact where
fCustAddrID='575418' or
fCustAddrID='958784' or
fCustAddrID='3017594' or
fCustAddrID='958785' or
fCustAddrID='3017595' or
fCustAddrID='3017766' or
fCustAddrID='2554723' or
fCustAddrID='2554724' or
fCustAddrID='3017669' or
fCustAddrID='3017671' or
fCustAddrID='2554725' or
fCustAddrID='3017670' or
fCustAddrID='3017672' or
fCustAddrID='3017767'





select DeleteDt, * from CustomerMaster where DeleteDt is not null and DeleteDt <>''

select * from CustomerMaster where CustNo='043750' or CustNo='1' or CustNo='110000' or CustNo='190000'

select Name1, * from CustomerAddress where 
fCustomerMasterID=8357 or
fCustomerMasterID=8892 or
fCustomerMasterID=9820 or
fCustomerMasterID=11603

select * from CustomerContact where
fCustAddrID=8357 or
fCustAddrID=8892 or 
fCustAddrID=9820 or
fCustAddrID=1197596

