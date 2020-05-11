select pCustMstrID, CustNo, CustName, AddrLine1, AddrLine2, City, State, PostCd, Country, PhoneNo, FaxPhoneNo, 
                            ContractSchd1, ContractSchd2, ContractSchd3, ContractSchedule4, ContractSchedule5, ContractSchedule6, ContractSchedule7, 
                            TargetGrossMarginPct, WebDiscountPct, WebDiscountInd, CustomerDefaultPrice, CustomerPriceInd, CM.ChangeId, CM.ChangeDt
from CustomerMaster CM (NoLock) INNER JOIN CustomerAddress (NoLock) ON pCustMstrID = fCustomerMasterID
WHERE CustNo='002901' and Type='P'





exec pSOESelect 'CustomerMaster (NoLock) INNER JOIN CustomerAddress (NoLock) ON pCustMstrID = fCustomerMasterID ',
'CustNo, CustName, AddrLine1, AddrLine2, City, State, PostCd, Country, PhoneNo, FaxPhoneNo ',



exec sp_columns CustomerAddress



select * from Customermaster where CustNo='555555'

select * from CustomerAddress where fCustomerMasterID=11442



select * from ListMaster inner join ListDetail on pListMasterID=fListMasterId where Listname='CustPriceInd' or ListName = 'CustDefPriceSchd' or ListName='CustContractSchd1'
order by Listname, SequenceNo

update ListDetail set ListValue='F' where pListDetailID=4574





