select * from [Porteous$Sales Cr_Memo Line] 

where [Posting Date]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))



select * from [Porteous$Sales Invoice Line] 


where [Posting Date]=CAST(DATEPART(yyyy,Getdate()-1) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()-1) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()-1) AS varchar(2))



--entered date=yyyy-mm-dd 00:00:00.000
select getdate()-1