exec sp_columns [Porteous$Contact]
exec sp_columns [Porteous$Contact Business Relation]

select * from [Porteous$Vendor]
select * from [Porteous$Contact]
select * from [Porteous$Contact Business Relation]

SELECT		[CBR5.0].[Business Relation Code], [CBR5.0].[Contact No_],
		[Contact5.0].*
--INTO		tERPVendInsert
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] [CBR5.0]
ON		[Contact5.0].[No_] = [CBR5.0].[Contact No_]
WHERE		[CBR5.0].[Business Relation Code] = 'VEND'



delete from [Porteous$Vendor]
where [No_]=1000100 or [No_]=1000101 or [No_]=1000102


select * from [Porteous$Contact]
where [No_]='CT035086' or
[No_]='CT035087' or
[No_]='CT035088' or
[No_]='CT035089' or
[No_]='CT035090' or
[No_]='CT888888'


select * from [Porteous$Contact Business Relation]
where [Contact No_]='CT035086' or
[Contact No_]='CT035087' or
[Contact No_]='CT035088' or
[Contact No_]='CT035089' or
[Contact No_]='CT035090' or
[Contact No_]='CT666666'


select [Landed Cost Code], * from [Porteous$Vendor]
order by [Landed Cost Code] DESC


select *  from [Porteous$Vendor]