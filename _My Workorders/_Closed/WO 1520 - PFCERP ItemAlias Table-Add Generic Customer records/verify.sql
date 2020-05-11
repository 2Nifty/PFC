select * from ItemAlias 
where (ItemNo='00050-2408-022' or ItemNo='00050-2408-400' or ItemNo='00050-2408-401') and
	(OrganizationNo='005281' or OrganizationNo='000000')
order by OrganizationNo