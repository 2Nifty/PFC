select	RefSONo, ItemNo
from	SOHeader Hdr inner join
	SODetail Dtl
on	Hdr.pSOHeaderID = Dtl.fSOHeaderID
WHERE
RefSONo='SO3031132' or
RefSONo='SO3032913' or
RefSONo='SO3032919' or
RefSONo='SO3032923' or
RefSONo='SO3032925' or
RefSONo='SO3032926' or
RefSONo='SW5073973' or
RefSONo='SW5074016' or
RefSONo='SW5083457' or
RefSONo='SW5083875' or
RefSONo='SW5084010' or
RefSONo='SW5084147'
order by ItemNo



select	RefSONo, ItemNo
from	SOHeader Hdr inner join
	SODetail Dtl
on	Hdr.pSOHeaderID = Dtl.fSOHeaderID
WHERE
ItemNo='00201-4100-401' and left(RefSONo,2)='SO' and RefSONo <> 'SO3031132'


select * from SOHeader where RefSONo='SO3031132'

select Dtl.*
from	SOHeader Hdr inner join
	SODetail Dtl
on	Hdr.pSOHeaderID = Dtl.fSOHeaderID
WHERE RefSONo='SO3031132' and ItemNo='00201-4100-401'



select * from SOHeader where OrderNo='1004525'

select Dtl.*
from	SOHeader Hdr inner join
	SODetail Dtl
on	Hdr.pSOHeaderID = Dtl.fSOHeaderID
where OrderNo='1004525'



select OrderNo, OrderFreightCd as [Hdr.OrderFreightCd], OrderFreightName as [Hdr.OrderFreightName], Dtl.FreightCd as [Dtl.FreightCd]
from	SOHeader Hdr inner join
	SODetail Dtl
on	Hdr.pSOHeaderID = Dtl.fSOHeaderID
where Hdr.OrderNo='1004545'

--Hdr.OrderNo='1004533' or Hdr.OrderNo='1004534' or Hdr.OrderNo='1004535' or Hdr.OrderNo='1004536'  or Hdr.OrderNo='1004525' 





select * from CustomerMaster where CustNo='005941' or CustNo='081433'

select * from CustomerAddress where fCustomerMasterID=417 or fCustomerMasterID=7482
order by fCustomerMasterID