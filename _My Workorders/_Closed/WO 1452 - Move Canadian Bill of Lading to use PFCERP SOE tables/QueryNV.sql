exec spCanadaBL '326697'

select * from tempLandedCostLines

exec sp_columns tempLandedCostLines


select [Quantity], [Quantity Shipped], [Qty_ to Ship], * from [Porteous$Transfer Line]
where [Document No_]='TO1215193'


