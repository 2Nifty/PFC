select * from ItemAlias
where [OrganizationNo]='005281' and 
(EntryDt=GetDate() or ChangeDt=GetDate())
order by ItemNo




delete from ItemAlias

where [OrganizationNo]='005281'