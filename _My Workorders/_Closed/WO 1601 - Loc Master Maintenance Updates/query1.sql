select	LocID, AllowSplitEDI, USDutyCalcReq, ShortCode, BigQuoteMinimum, USDutyCalcReq, LocEmail, ShipFromSupportBr1, ShipFromSupportBr2, ShipFromSupportBr3, ShipFromSupportBr4, *
from	LocMaster


update LocMaster set ChangeID=null



select CustNo, UsageLocation from CustomerMaster
where CustNo='002401'


exec sp_columns LocMaster




select	LM.ListName, LM.ListDesc, LM.Comments,
	LD.ListValue, LD.ListDtlDesc --,
	--LD.*
from	ListMaster LM inner join ListDetail LD on pListMasterID = fListMasterID
where	ListName = 'USDutyCalcReq'
order by LM.ListName, LD.ListValue





--exec pSOEUpdate "LocMaster", 