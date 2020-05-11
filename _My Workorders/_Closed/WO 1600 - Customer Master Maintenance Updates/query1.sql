select	CustNo, ContractSchd1, ContractSchd3, ContractSchedule4, ContractSchedule5, ContractSchedule6, ContractSchedule7, 
BuyGroup, RebateGroup,
--AllowDelProofInd, AllowPartialsInd, AllowSubsInd, ASNInd, BackOrderInd, EDI870Ind, ResidentialDeliveryInd,

	CustomerDefaultPrice, CustomerPriceInd,
	WebDiscountPct, WebDiscountInd, IRSEINNo,
	BuyGroup, RebateGroup, SODocSortInd,
	PORequiredInd, CertRequiredInd, InvDeliveryInd,
	TransferLocation, ResidentialDeliveryInd, 
	*
from	CustomerMaster
where	CustNo='002401'
--CustNo='059381'


--update CustomerMaster set WebDiscountInd=null
--where	CustNo='002401'


--exec sp_columns CustomerMaster


--select * from CustomerMaster where WebDiscountInd is null




------------------------------------------------------------------

select distinct RebateGroup from CustomerMaster

select	LM.ListName, LM.ListDesc, LM.Comments,
	LD.ListValue, LD.ListDtlDesc --,
	--*
from	ListMaster LM inner join ListDetail LD on pListMasterID = fListMasterID
where	ListName = 'SODocSortInd' or ListName = 'InvDeliveryInd' or 
	ListName = 'CustDefPriceSchd' or ListName = 'BuyGrp' or Listname='CustRebateGrp'
order by LM.ListName, LD.ListValue


--select * from ListMaster where ListName = 'CustInvoiceDelInd'
--delete from ListMaster where ListName = 'CustResidentDelInd'

Update listmaster set Comments='Used in Customer Maintenance'
where ListName = 'CustDefPriceSchd' or ListName = 'BuyGrp' or Listname='CustRebateGrp'


select * from ListMaster  order by ListName




select	LD.*
from	ListMaster LM inner join ListDetail LD on pListMasterID = fListMasterID   --order by pListMasterID
where	ListName = 'BuyGrp' 




