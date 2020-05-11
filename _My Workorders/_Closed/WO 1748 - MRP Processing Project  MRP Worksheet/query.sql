exec pWOSSetFilters



select LM.ListName, LM.ListDesc, LD.*
from ListMaster LM inner join ListDetail LD on pListMasterID=fListMasterID
where ListName='WOActions' or ListName='WOPriorityCd'
order by LM.ListName, LD.SequenceNo


select *
from WOWorkSheet
--where SUBSTRING(WOItemNo,7,4) = '2401'
--where AcceptActionDt is not null
Order By ActionStatus ASC, WOItemNo ASC, PriorityCd ASC


--exec pSOESelect 'WOWorkSheet (NOLOCK) ', 'UsageVelocityCd, ActionStatus, PriorityCd, WOItemNo, WOItemDesc, ActionQty, ActionType, AcceptActionDt, WOBranch, WODueDt, ParentItemNo', ' ActionStatus = ''EXCEPTION'' ORDER BY ActionStatus ASC, WOItemNo ASC, PriorityCd ASC'


update WOWorkSheet
set AcceptActionDt=null
--set WOBranch='04'
--where right(PriorityCd,1)='5'


select * from LocMaster
--where Loctype='M'

--update LocMaster set LocType='M'
--where LocID='01' or LocID='80'