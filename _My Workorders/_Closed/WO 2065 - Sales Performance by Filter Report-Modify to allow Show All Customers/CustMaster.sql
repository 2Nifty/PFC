--7464 rows
select CustShipLocation, PriceCd, * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
where CreditInd not in ('X','E') --and CustShipLocation = '15'
