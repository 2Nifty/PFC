--PFCSQLP.PFCReports

--update CustomerContact
--set fCustAddrID=null

select * from CustomerContact
select * from CustomerMaster

select count(*) from 
OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster

select Addie.* from 
OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust inner join
OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerAddress Addie on pCustMstrID=fCustomerMasterID
where type='P' or type=''





UPDATE	CustomerContact
SET	fCustAddrID = Addie.pCustomerAddressID
--select	Cust.pCustMstrID, Cust.CustNo, Cust.CustName, Addie.pCustomeraddressID, Addie.Type, Addie.fCustomerMasterID, Addie.Name1, Contact.*
FROM	CustomerContact Contact INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust ON Contact.CustNo = Cust.CustNo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerAddress Addie ON Cust.pCustMstrID = Addie.fCustomerMasterID
Where	Addie.Type = 'P' or Addie.Type = ''
