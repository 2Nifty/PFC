select [Pay-to Vendor No_], * from [Porteous$Vendor] where [No_] in ('0004843','0484300')
select [Pay-to Vendor No_], * from [Porteous$Vendor] where [No_] in ('0004890','0008000')
select [Pay-to Vendor No_], * from [Porteous$Vendor] where [No_] in ('0005404','0005405')
select [Pay-to Vendor No_], * from [Porteous$Vendor] where [No_] in ('0002188','0218800')
select [Pay-to Vendor No_], * from [Porteous$Vendor] where [No_] in ('0003553','0914500')


131
565
870

select [Pay-to Vendor No_] , * from [Porteous$Vendor]


select [Pay-to Vendor No_], * from [Porteous$Vendor] where isnull([Pay-to Vendor No_],'') <> '' and [Pay-to Vendor No_] not in 
(
select [No_] from [Porteous$Vendor] where isnull([No_],'') <> ''
)