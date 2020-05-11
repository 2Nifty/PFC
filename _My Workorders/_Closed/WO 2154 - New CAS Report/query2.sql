SELECT	Cust.pCustMstrID,
		Cust.CustNo,
		isnull(Cust.ChainCd,'') as ChainCd,
		isnull(Cust.CustType,'') as CustType,
		isnull(Cust.BuyGroup,'') as BuyGroup,
'Key Cust' as KeyCust,
'Comm Rep' as CommRep,
		isnull(Cust.CustName,'') as CustName,
		isnull(Addr.AddrLine1,'') as AddrLine1,
		isnull(Addr.AddrLine2,'') as AddrLine2,
		isnull(Addr.City,'') as City,
		isnull(Addr.State,'') as [State],
		isnull(Addr.PostCd,'') as PostCd,
		isnull(Addr.PhoneNo,'') as PhoneNo,
		isnull(Addr.FaxPhoneNo,'') as FaxPhoneNo,
'Contact' as Contact,
		isnull(Cust.ShipLocation,'') as ShipLocation,						--Sales Branch?
		isnull(InsideRep.RepNo,'') as InsideRepNo,
		isnull(InsideRep.RepName,'') as InsideRepName,
		isnull(OutsideRep.RepNo,'') as OutsideRepNo,		--Sales Rep?
		isnull(OutsideRep.RepName,'') as OutsideRepName,
'Hub' as Hub,
'Terms' as Terms,
		isnull(Cust.CreditLmt,'') as CreditLmt,

		--PFC Fields
		isnull(Cust.ContractSchd1,'') as ContractSchd1,
		isnull(Cust.ContractSchd2,'') as ContractSchd2,
		isnull(Cust.ContractSchd3,'') as ContractSchd3,
		isnull(Cust.ContractSchedule4,'') as ContractSchd4,
		isnull(Cust.ContractSchedule5,'') as ContractSchd5,
		isnull(Cust.ContractSchedule6,'') as ContractSchd6,
		isnull(Cust.ContractSchedule7,'') as ContractSchd7,
		isnull(Cust.TargetGrossMarginPct,0) as TargetGrossMarginPct,		--Default Gross Mgn %?
		isnull(Cust.GrossMarginPct,0) as GrossMarginPct,					--Default Gross Mgn %?
		isnull(Cust.WebDiscountPct,0) as WebDiscountPct,
		isnull(Cust.WebDiscountInd,'') as WebDiscountInd,
		isnull(Cust.CustomerDefaultPrice,0) as CustomerDefaultPrice,
		isnull(Cust.CustomerPriceInd,'') as CustomerPriceInd --,


		--Cust.*, Addr.*
FROM	CustomerMaster Cust (NoLock) INNER JOIN
		CustomerAddress Addr (NoLock)
ON		Cust.pCustMstrID = Addr.fCustomerMasterID LEFT OUTER JOIN
		RepMaster InsideRep (NoLock)
ON		Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
		RepMaster OutsideRep (NoLock)
ON		Cust.SlsRepNo = OutsideRep.RepNo



WHERE	pCustMstrID = 1811 AND Addr.Type in ('DSHP','P')
--where CustNo='024061'




--exec sp_columns CustomerMaster



select * from LocMaster