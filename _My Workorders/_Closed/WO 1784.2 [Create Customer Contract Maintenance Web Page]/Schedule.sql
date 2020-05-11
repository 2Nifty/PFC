
select DISTINCT ContractSchd1 from CustomerMaster where ContractSchd1 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchd1 <>''


select DISTINCT ContractSchd2 from CustomerMaster where ContractSchd2 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchd2 <>''


select DISTINCT ContractSchd3 from CustomerMaster where ContractSchd3 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchd3 <>''


select DISTINCT ContractSchedule4 from CustomerMaster where ContractSchedule4 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchedule4 <>''



select DISTINCT ContractSchedule5 from CustomerMaster where ContractSchedule5 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchedule5 <>''




select DISTINCT ContractSchedule6 from CustomerMaster where ContractSchedule6 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchedule6 <>''




select DISTINCT ContractSchedule7 from CustomerMaster where ContractSchedule7 not in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='CustContractSchd') and ContractSchedule7 <>''
