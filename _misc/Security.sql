
select	pSecGroupID, GroupName, SecurityGroupApp, GroupDesc, Comments, DeleteDt, EntryID, EntryDt, ChangeID, ChangeDt  --,*
from	SecurityGroups
--where GroupName LIKE '%AC%'
order by GroupName


-----------------------------------------------------------


--CHARINDEX = 0; LEN = 3
select CHARINDEX('(','ARA'), len(rtrim('ARA'))

--Why doesn't this work?
--This causes an error: Invalid length parameter passed to the left function.
--Since CHARINDEX = 0, it should execute the ELSE and should never execute the left function
select	CASE
	   WHEN CHARINDEX('(','ARA') > 0 --and CHARINDEX ('(','ARA') < len(rtrim('ARA'))-1 
		THEN rtrim(left('ARA',CHARINDEX('(','ARA')-1))
		ELSE rtrim('ARA')
	END


--If I put the parenthesis in the string, it will now function.
--Now, CHARINDEX = 5; LEN = 7
select CHARINDEX('(','ARA (W)'), len(rtrim('ARA (W)'))

--Since CHARINDEX = 5, it executes the THEN to take LEFT ('ARA (W)',5) to return 'ARA', no problem
select	CASE
	   WHEN CHARINDEX('(','ARA (W)') > 0 --and CHARINDEX ('(','ARA') < len(rtrim('ARA'))-1 
		THEN rtrim(left('ARA (W)',CHARINDEX('(','ARA (W)')-1))
		ELSE rtrim('ARA (W)')
	END



select	CASE
	   WHEN CHARINDEX('(',GroupName) > 0 
		THEN rtrim(left(GroupName,CHARINDEX('(',GroupName)-1))
		ELSE rtrim(GroupName)
	END
FROM	SecurityGroups


-----------------------------------------------------------


--exec sp_columns SecurityGroups

--select * from SecurityMembers

--update SecurityGroups set GroupName = '3462:1234567890123456789012345' where GroupName='3462'
--update SecurityGroups set SecurityGroupApp = 'TBD', Comments='To Be Determined' where GroupName='ACKF'
--update SecurityGroups set DeleteDt=NULL where DeleteDt is not NULL
--delete from SecurityGroups where EntryID='tod'



--Find Groups to which a specific user is assigned
select	DISTINCT
	SecurityUsers.pSecUserID, SecurityUsers.UserName,
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



select * from SecurityMembers where SecUserId=12

select * from SecurityGroups where pSecGroupID=935 or pSecGroupID=925


--update SecurityGroups set GroupName='WOS (W)' where pSecGroupID=917
--update SecurityGroups set GroupName='Maintenance (W)' where pSecGroupID=917





--exec pSOESelect "[Tables]", "TableCd", "TableCd='tod' AND TableType='FGHTADD'"



--exec UGEN_SP_Select "dbo.SecurityGroups", "pSecGroupID AS ID, GroupName, SecurityGroupApp, GroupDesc, Comments", "GroupName is not null Order By GroupName"




----------------------------------------------


select * from ListMaster inner join ListDetail on pListMasterID=fListMasterID
where ListName='SecurityGrpApp'




----------------------------------------------

select * from SoftLockStats
where EntryDt > getdate()-1 and UserCurrentApp='Sec'


delete from SoftLockStats
where EntryDt > getdate()-1 and UserCurrentApp='Sec' and EntryID='tod'

