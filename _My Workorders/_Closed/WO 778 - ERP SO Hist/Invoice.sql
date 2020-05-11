select * from [Porteous$Sales Invoice Line]
where [Order Date] > getdate()-200 and [Document No_] >'IP2370999'
Order By Type, [Document No_], [Line No_]

select * from [Porteous$Sales Invoice Header]
where [Order Date] > getdate()-200 and [No_] >'IP2370999'
Order By [No_]


exec sp_columns [Porteous$Sales Invoice Line]