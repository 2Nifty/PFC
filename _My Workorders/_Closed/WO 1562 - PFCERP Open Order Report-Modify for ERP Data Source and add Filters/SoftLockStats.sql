select distinct SOHeaderRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=fSOHeaderRelID
order by SellToCustNo


--98 total rows
--only 1 row for SOHeaderRel
select * from SoftLockStats --where EntryID='tod'
where TableRowItem='SOHeaderRel'



exec pSoftLock 'SOHeaderRel','Lock','5','intranet','SOE'


exec pSoftLock 'SOHeaderRel','Release','6','intranet','SOE'