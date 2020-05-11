--select * from dbo.sysobjects where id = object_id(N'tERPVendInsert') and OBJECTPROPERTY(id, N'IsUserTable')=1


select [Primary Contact No_], * from [Porteous$Vendor] where [No_]='1002636' or [No_]='1002637' or [No_]='1002640' or [No_]='1002580'
select * from [Porteous$Contact] where [No_]='CT035329' or [No_]='CT035330' or [No_]='CT035331' or [No_]='CT035332' or [No_]='CT035335' or [No_]='CT035042' or [No_]='CT035043'

select * from [Porteous$Contact Business Relation]
--where [Contact No_]='CT035329' or [Contact No_]='CT035330' or [Contact No_]='CT035331' or [Contact No_]='CT035332'
where [No_]='1002636' or [No_]='1002637' or [No_]='1002640' or [No_]='1002580'


--delete from [Porteous$Vendor] where [No_]='1002640'  --[No_]='1002636' or [No_]='1002637'
--delete  from [Porteous$Contact] where [No_]='CT035335'  --[No_]='CT035329' or [No_]='CT035330' or [No_]='CT035331' or [No_]='CT035332'

--delete from [Porteous$Contact Business Relation]
--where [No_]='1002640'
--where [Contact No_]='CT035329' or [Contact No_]='CT035330' or [Contact No_]='CT035331' or [Contact No_]='CT035332'


select * from tERPVendInsert
select * from tERPVendDelete
select * from tERPVendUpdate


select * from tERPVendContInsert
select * from tERPVendContDelete
select * from tERPVendContUpdate


select * from tERPVendCBRInsert
select * from tERPVendCBRDelete
select * from tERPVendCBRUpdate


