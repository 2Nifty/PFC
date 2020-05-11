--PFCSQLP.PFCReports


			--Table[1] - Customer A/R Aging Data
			SELECT	Cust.pCustMstrId,
					Cust.CustNo,
					CAST(CAS.CurYear as CHAR(4)) + CAST(RIGHT(100+CAS.CurMonth,2) as CHAR(2)) as Period,
					CAS.AgingCur,
					CAS.Aging30,
					CAS.Aging60,
					CAS.AgingOver90 as Aging90,
					CAS.AgingTot,
					CAS.AgingCurPct,
					CAS.Aging30Pct,
					CAS.Aging60Pct,
					CAS.Aging90Pct,
					CAS.DSO
					,CAS.*
			FROM	CustomerMaster Cust (NoLock) INNER JOIN
--				OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CAS_CustomerData CAS --(NoLock)
				CAS_CustomerData CAS --(NoLock)
			ON	Cust.CustNo = CAS.CustNo
			WHERE	Cust.pCustMstrID = 1811 AND
					CAST(CAS.CurYear as CHAR(4)) + CAST(RIGHT(100+CAS.CurMonth,2) as CHAR(2)) = '200912'




--Cust Type
select CustType, * from Customermaster where CustNo='024061' --Translate from CustType List - if no match, default to value in CustMast
select [Customer Type], * from PFCLive.dbo.[Porteous$Customer] where [No_]='024061'


select * from ListMaster where ListName='CustType'
select * from Listdetail where fListMasterID=14





--Hub
select ShipLocation from Customermaster where CustNo='024061'
select HubSort, SupportBranch1, SupportBranch2, SupportBranch1 + ' ' + SupportBranch2 as HubSat, * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster where LocID='15'
select [Code], [Alt_ 1 Location] + ' '+ [Alt_ 2 Location] as HubSatellites from PFCLive.dbo.[Porteous$Location] where [Code]='15'




--Reps
select	insiderep.repNo as InsideNo,
	InsideRep.RepName as InsideSales,
	OutSideRep.RepNo as SalesNo,
	OutSideRep.RepName as Salesrep
from	CustomerMaster Cust (NoLock) LEFT OUTER JOIN
	RepMaster InsideRep (NoLock)
ON	Cust.SupportRepNo = InsideRep.RepNo LEFT OUTER JOIN
	RepMaster OutsideRep (NoLock)
ON	Cust.SlsRepNo = OutsideRep.RepNo 
where	Cust.pCustMstrID = 1811




--Contact
select [Contact], * from PFCLive.dbo.[Porteous$Customer] where [No_]='024061'
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerAddress where fCustomerMasterID = 1811 and isnull(Type,'') in ('','P')
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerContact 
--where left(name,4)='Jodi'
where fCustAddrID=1811 or fCustAddrID=107 
order by CustNo



--terms (Sathish)
select [Payment Terms Code], * from PFClive.dbo.[Porteous$Customer] where [No_]='024061'

select [Description] as terms, * from PFClive.dbo.[Porteous$Payment Terms]
where [Code] = '18'


select CustShipLocation, ShipLocation, * from Customermaster where CustNo='024061'



select CustomerPriceInd,* from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster --where CustNo='024061'
where isnull(CustomerPriceInd,'') <> ''



exec sp_columns CustomerMaster








select * from CuvnalSum
