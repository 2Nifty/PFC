	Select	a.customerNumber, CM.CustShipLocation as SalesLocationCode
						from	DTQ_CustomerQuotation a (NOLOCK) inner join
--							OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
DEVPERP.dbo.CustomerMaster CM
					on		CM.CustNo = a.customerNumber  COLLATE Latin1_General_CS_AS
					where	a.DeleteFlag=0 and  (Year(a.QuotationDate) = 2009 AND Month(a.QuotationDate) = 12) AND CM.CustShipLocation like '%15%'	group by a.CustomerNumber, CM.CustShipLocation




select distinct CustomerNumber from DTQ_CustomerQuotation a (nolock)
where	a.DeleteFlag=0 and  
	(Year(a.QuotationDate) = 2009 AND Month(a.QuotationDate) = 12)
order by CustomerNumber

 AND 
	
CM.CustShipLocation like '%15%'	group by a.CustomerNumber, CM.CustShipLocation



update DEVPERP.dbo.CustomerMaster
--set CustShipLocation='15'
set PriceCd='X'

select PriceCd, * from DEVPERP.dbo.CustomerMaster
where CustNo='004401' or CustNo='201190'   or CustNo='000001'


 