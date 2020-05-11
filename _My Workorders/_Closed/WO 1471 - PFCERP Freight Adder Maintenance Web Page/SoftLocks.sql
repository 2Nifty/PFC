select * from SoftLockStats
order by TableRowItem

select * from FreightAdder


--delete from SoftLockStats where TableRowItem='FreightAdder'

--select * from CustomerMaster where CustNo='002901' or CustNo='201543'


exec pSoftLock 'FreightAdder','Lock',49,'intranet','FAM'
exec pSoftLock 'FreightAdder','Release',49,'intranet','FAM'


exec pSoftLock 'CustomerMaster','Release',185,'tod','CM'


select * from CustomerMaster where pCustMstrID=185