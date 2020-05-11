select * from CustomerMaster where CustNo='200301'


exec UGEN_SP_SELECT 'customerMaster','pcustmstrID','custno=200301'




exec UGEN_SP_SELECT 'customerAddress','Name1,PostCd,City,State,AddrLine1','fcustomermasterid=10135 and type not in(''DSHP'',''SHP'')'



select pCustMstrID, CustNo, CustName, CustomerAddress.* from CustomerMaster inner join CustomerAddress on pCustMstrID=fCustomerMasterId where custno=200301

