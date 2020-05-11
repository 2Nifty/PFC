
--My user in SecurityUsers: pSecUserID = 12
select * from SecurityUsers where UserName='tod'

--I am assigned to Groups 902, 906 & 928
Select DeleteDt,* From SecurityMembers where SecUserId=12


select * from SecurityMembers where SecUserID = 99999

update SecurityMembers
set 	--SecUserID = 12
	--DeleteDt = null --GETDATE()
	SecGroupID = 429
WHERE SecUserID = 12 and SecGroupID = 902


--delete  From SecurityMembers where SecUserId=12  



--SecurityGroups: 429 = Admin (W)
--		  902 = Maintenance (W)
--		  906 = SOE (W)
--		  928 = FghtAdd
select * from SecurityGroups
--where left(GroupName,7)='FghtAdd' or left(GroupName,11)='Maintenance' or left(GroupName,5)='Admin'
where pSecGroupID=429 or pSecGroupID=902 or pSecGroupID=906 or pSecGroupID=928
Order by pSecGroupID


--Find Groups to which a specific user is assigned
select	DISTINCT SecurityUsers.pSecUserID, SecurityUsers.UserName,
	SecurityMembers.SecUserId, SecurityMembers.SecGroupId,
	SecurityGroups.pSecGroupID, SecurityGroups.GroupName, SecurityGroups.GroupDesc, SecurityGroups.SecurityGroupApp, SecurityMembers.DeleteDt
from	SecurityUsers inner join
	SecurityMembers
on	SecurityUsers.pSecUserID = SecurityMembers.SecUserId inner join
	SecurityGroups
on	SecurityMembers.SecGroupID = SecurityGroups.pSecGroupID
WHERE	(SecurityMembers.DeleteDt is null or SecurityMembers.DeleteDt = '') --AND
	--(SecurityGroups.DeleteDt is null or SecurityGroups.DeleteDt = '')
and SecurityUsers.UserName='tod'
order by SecurityUsers.UserName




exec pSOESelect "[Tables]", "TableCd", "TableCd='tod' AND TableType='FGHTADD'"



select * from FreightAdder
where EntryDt > getdate()-1
order by FromLocation, toLocation

delete from FreightAdder
where --EntryDt > getdate()-1
FromLocation = toLocation