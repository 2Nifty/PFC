select * 
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
order by RefSONo


select RefSONo, SellToCustNo as CustNo, TotalCost, TotalCost2, * from SOHeader where left(RefSONo,9) in
('SO3108422',
'SO3108423',
'SO3108424',
'SO3108425',
'SO3108426',
'SO3108427',
'SO3108428',
'SO3108429',
'SO3108430',
'SO3108431',
'SO3108432',
'SO3108433',
'SO3108434',
'SO3108435',
'SO3108436',
'SO3108437',
'SO3108438',
'SO3108439',
'SO3108440',
'SO3108441',
'SO3108442')
order by SellToCustNo


select * from SOComments where fSOHeaderID in 