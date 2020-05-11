exec sp_columns CustomerPrice
select * from CustomerPrice where CustNo='Sockets'
order by ItemNo

select	LD.*
from	ListMaster LM inner join
	ListDetail LD
on	pListMasterID=fListMasterID
where	ListName='CustContractSchd'


exec pCustPriceSched	'Select', 0, '--90DAYNJ+ 90DAYNJ--', 'ItemNo',
			'PriceMeth', null, null, null, null,
			'PriceMethFut', null, null, null, null, 'User'



exec pCustPriceSched	'Update', 5796, 'ContractID', '00200-2408-020',
			'Z', '09/30/10', 33.6923, 23.5846, 25,
			null, null, null, null, 15, 'tod'


exec pCustPriceSched	'Delete', 5796, 'ContractID', 'ItemNo',
			'PriceMeth', null, null, null, null,
			'PriceMethFut', null, null, null, null, 'User'



update CustomerPrice
set CustNo='--90DAYNJ+ 90DAYNJ--'
where CustNo='--90DAYNJ++90DAYNJ--'



update CustomerPrice
set CustNo='--90DAYNJ+ 90DAYNJ--',
	FutPriceMetod = PriceMethod,
	FutEffDt = Effdt,
	AltSellPrice = 111111.111,
	FutAltSellPrice = 222222.222,
	ContractPrice = 333333.333,
	FutContractPrice = 444444.444,
	DiscPct = 7777.7777,
	FutDiscPct = 8888.8888,
	EntryID='pfca.com\t dixon',
	EntryDt = getdate(),
	ChangeID='pfca.com\t dixon',
	ChangeDt = getdate()
where CustNo='--90DAYNJ+ 90DAYNJ--' and ItemNo='00020-2408-021'

update CustomerPrice set DiscPct = 50
where CustNo='--90DAYNJ+ 90DAYNJ--'


	select	CustNo, ItemNo as Item, PriceMethod, FutPriceMetod, EffDt, FutEffDt,
		AltSellPrice, FutAltSellPrice, ContractPrice, FutContractPrice,
		DiscPct, FutDiscPct, EntryID, EntryDt, * from CustomerPrice where CustNo='--90DAYNJ+ 90DAYNJ--'
	order by ItemNo




exec sp_columns CustomerPrice


select LTRIM(RTRIM(PriceMethod)) from CustomerPrice


select CustNo, count(*) as contcount
from CustomerPrice
where CustNo in 
(select ListValue from ListMaster inner join ListDetail on pListMasterID=fListMasterID where ListName='CustContractSchd')
group by CustNo
order by CustNo




	SELECT	pCustomerPriceID,
		CustNo as ContractID,
		ItemNo,
		LTRIM(RTRIM(PriceMethod)) as PriceMethod,
		EffDt,
		AltSellPrice,
		ContractPrice as SellPrice,
		DiscPct * 0.01 as DiscPct,
		LTRIM(RTRIM(FutPriceMetod)) as FutPriceMethod,
		FutEffDt,
		FutAltSellPrice,
		FutContractPrice as FutSellPrice,
		FutDiscPct * 0.01 as FutDiscPct,
		EntryID,
		EntryDt,
		ChangeID,
		ChangeDt
	FROM	CustomerPrice
	WHERE	CustNo = '0002'
order by ItemNo