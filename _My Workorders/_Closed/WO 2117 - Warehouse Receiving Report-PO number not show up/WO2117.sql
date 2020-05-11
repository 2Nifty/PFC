select ContainerNo,* from LPNAuditControl where Location='15'


exec [pWHSRcvRprtData] '15', '00099999991012721610', ''






--select * from LPNAuditControl


select License_plate, * 
FROM OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.BINLOCAT 

where Location='05' and isnull(License_plate,'') <> ''





exec pWHSRcvRprtData '05','','TO1222687'




select distinct Rel.OrderNo, Rel.CustPoNo, LPN.DocumentNo
from	LPNAuditControl LPN left outer  join
	SOHeaderRel Rel
on	cast(Rel.OrderNo as varchar(20)) = LPN.DocumentNo



