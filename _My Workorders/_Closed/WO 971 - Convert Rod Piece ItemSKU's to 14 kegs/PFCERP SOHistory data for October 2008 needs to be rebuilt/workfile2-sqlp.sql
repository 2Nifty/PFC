update [Porteous$Sales Cr_Memo Header]
set [ERP Upload Flag]=0
select DISTINCT NVHDR.[No_]
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	PFCLive.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_]
	
WHERE	[ERP Upload Flag]=0 and 
--NVHDR.[ERP Upload Flag]=0 AND ((NVLINE.Type=1 and NVLINE.No_<>'3021') OR (NVLINE.Type<>1 AND NVLINE.Type<>2)) AND
NVHDR.[Posting Date] >= Cast('2008-09-28 00:00:00.000' as DATETIME)



update [Porteous$Sales Cr_Memo Header]
set [ERP Upload Flag]=1
--select *
FROM	[Porteous$Sales Cr_Memo Header]
WHERE	[ERP Upload Flag]=0 and [Posting Date] <= Cast('2008-10-27 00:00:00.000' as DATETIME)




