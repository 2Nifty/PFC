--compare NV5 vs NV3
select NV5No, NV3No, NV5Rep, NV3Rep, NV5Mod, NV3Mod, NV5ModBy, NV3ModBy
--select distinct NV3ModBy
--select max(NV3Mod)
from
(
select NV5Cust.[Inside Salesperson] as NV5Rep, NV5Cust.[No_] as NV5No, NV5Cust.[Last Date Modified] as NV5Mod, NV5Cust.[Last Modified By] as NV5ModBy,
	NV3Cust.[Inside Salesperson] as NV3Rep, NV3Cust.[No_] as NV3No, NV3Cust.[Last Date Modified] as NV3Mod, NV3Cust.[Last Modified By] as NV3ModBy
from [Porteous$Customer] NV5Cust inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Customer] NV3Cust
on	NV3Cust.[No_]=NV5Cust.[No_] collate Latin1_General_CS_AS) tmp
--where NV5Rep <> NV3Rep collate Latin1_General_CS_AS
where NV3Mod > NV5Mod --and NV3ModBy='PARREOLA'
and NV3Mod > getdate()-1

--compare NV5 vs ERP
select NV5No, ERPNo, NV5Rep, ERPRep
from
(
select NV5Cust.[Inside Salesperson] as NV5Rep, NV5Cust.[No_] as NV5No, 
	ERPCust.SupportRepNo as ERPRep, ERPCust.CustNo as ERPNo
from [Porteous$Customer] NV5Cust inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster] ERPCust
on	ERPCust.CustNo=NV5Cust.[No_] collate Latin1_General_CS_AS) tmp
where NV5Rep <> ERPRep collate Latin1_General_CS_AS




--NV5
select [Inside Salesperson], [No_], * from [Porteous$Customer]
where [No_]='028075'


--NV3.7
select [Inside Salesperson], [No_], * from OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Customer]
where [No_]='028075'




--ERP
select SupportRepNo, CustNo from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster]
where CustNo='003075'



--NV5
select
[Account Opened],
[Address],
[Address 2],
[Allow Line Disc_],
[Amount],
[Application Method],
[Backorder],
[Bank Communication],
[Base Calendar Code],
[Bill-to Customer No_],
[Block Payment Tolerance],
[Blocked],
[Budgeted Amount],
[Cert Required],
[Chain Name],
[City],
[Collection Method],
[Combine Shipments],
[Contact],
[Country_Region Code],
[County],
[Credit Limit (LCY)],
[Credit Update],
[Currency Code],
[Customer Disc_ Group],
[Customer Posting Group],
[Customer Price Code],
[Customer Price Group],
[Customer Type],
[Document Delivery],
[EDI Invoice],
[E-Mail],
[E-Ship Agent Service],
[Fax No_],
[Fin_ Charge Terms Code],
[Free Freight],
[Gen_ Bus_ Posting Group],
[Global Dimension 1 Code],
[Global Dimension 2 Code],
[Home Page],
[Inside Salesperson],
[Invoice Copies],
[Invoice Detail Sort],
[Invoice Disc_ Code],
[IRS EIN Number],
[Language Code],
[Last Date Modified],
[Last Modified By],
[Last Statement No_],
[Last Update],
[Location Code],
[Name],
[Name 2],
[No_],
[No_ Series],
[Our Account No_],
[Payment Method Code],
[Payment Terms Code],
[Phone No_],
[Picture],
[Place of Export],
[Post Code],
[Prices Including VAT],
[Primary Contact No_],
[Print Statements],
[Priority],
[Purchase Order Required],
[Rebate Group],
[Reminder Terms Code],
[Reserve],
[Residential Delivery],
[Responsibility Center],
[Salesperson Code],
[Search Name],
[Service Zone Code],
[Shipment Method Code],
[Shipping Advice],
[Shipping Agent Code],
[Shipping Agent Service Code],
[Shipping Location],
[Shipping Payment Type],
[Shipping Time],
[Statistics Group],
[Tax Area Code],
[Tax Exemption No_],
[Tax Liable],
[Telex Answer Back],
[Telex No_],
[Territory Code],
[timestamp],
[UPS Zone],
[Usage Location],
[VAT Bus_ Posting Group],
[VAT Registration No_]
from [Porteous$Customer]
where [No_]='020010'



--NV3.7
select 
[Account Opened],
[Address],
[Address 2],
[Allow Line Disc_],
[Amount],
[Application Method],
[Backorder],
[Bank Communication],
[Base Calendar Code],
[Bill-to Customer No_],
[Block Payment Tolerance],
[Blocked],
[Budgeted Amount],
[Cert Required],
[Chain Name],
[City],
[Collection Method],
[Combine Shipments],
[Contact],
[Country Code],
[County],
[Credit Limit (LCY)],
[Credit Update],
[Currency Code],
[Customer Disc_ Group],
[Customer Posting Group],
[Customer Price Code],
[Customer Price Group],
[Customer Type],
[Document Delivery],
[EDI Invoice],
[E-Mail],
[E-Ship Agent Service],
[Fax No_],
[Fin_ Charge Terms Code],
[Free Freight],
[Gen_ Bus_ Posting Group],
[Global Dimension 1 Code],
[Global Dimension 2 Code],
[Home Page],
[Inside Salesperson],
[Invoice Copies],
[Invoice Detail Sort],
[Invoice Disc_ Code],
[IRS EIN Number],
[Language Code],
[Last Date Modified],
[Last Modified By],
[Last Statement No_],
[Last Update],
[Location Code],
[Name],
[Name 2],
[No_],
[No_ Series],
[Our Account No_],
[Payment Method Code],
[Payment Terms Code],
[Phone No_],
[Picture],
[Place of Export],
[Post Code],
[Prices Including VAT],
[Primary Contact No_],
[Print Statements],
[Priority],
[Purchase Order Required],
[Rebate Group],
[Reminder Terms Code],
[Reserve],
[Residential Delivery],
[Responsibility Center],
[Salesperson Code],
[Search Name],
[Service Zone Code],
[Shipment Method Code],
[Shipping Advice],
[Shipping Agent Code],
[Shipping Agent Service Code],
[Shipping Location],
[Shipping Payment Type],
[Shipping Time],
[Statistics Group],
[Tax Area Code],
[Tax Exemption No_],
[Tax Liable],
[Telex Answer Back],
[Telex No_],
[Territory Code],
[timestamp],
[UPS Zone],
[Usage Location],
[VAT Bus_ Posting Group],
[VAT Registration No_]
from OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Customer]
where [No_]='020010'









--VENDOR

--compare NV5 vs NV3
select max(NV3Mod)
--select NV5No, NV3No, NV5Mod, NV3Mod--, NV5ModBy, NV3ModBy
--select distinct NV3ModBy
from
(
select NV5Cust.[No_] as NV5No, NV5Cust.[Last Date Modified] as NV5Mod, --NV5Cust.[Last Modified By] as NV5ModBy,
	NV3Cust.[No_] as NV3No, NV3Cust.[Last Date Modified] as NV3Mod--, NV3Cust.[Last Modified By] as NV3ModBy
from [Porteous$Vendor] NV5Cust inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3Cust
on	NV3Cust.[No_]=NV5Cust.[No_] collate Latin1_General_CS_AS) tmp
--where NV5Rep <> NV3Rep collate Latin1_General_CS_AS
where NV3Mod > NV5Mod --and NV3ModBy='PARREOLA'



exec sp_columns [Porteous$Vendor]