

select * from [Porteous$Sales Invoice Line]
where [Document No_]='IP2354961' and
 [No_]='00170-0603-501'


select SOHeaderHist.InvoiceNo, SOHeaderHist.[TotalCost], SOHeaderHist.[UsageLoc], SODetailHist.[LineNumber], SODetailHist.[ItemNo],SODetailHist.[QtyOrdered], SODetailHist.[QtyShipped], [SODetailHist].UnitCost from
	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID
Where  --[ItemNo]='00170-0603-021'
--and 
SOHeaderHist.InvoiceNo='IP2354961'
order by  SODetailHist.[ItemNo], SOHeaderHist.[UsageLoc]


select * from tRodFactor

select DISTINCT SOHeaderHist.InvoiceNo, SOHeaderHist.ARPostDt, SODetailHist.ItemNo, SOHeaderHist.UsageLoc
--into tSOFix
FROM	--OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	--OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	--SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo inner join
	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID
WHERE	--NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=2 AND NVLINE.No_ <> '' AND
	SOHeaderHist.[ARPostDt] <= Cast('2008-09-28 00:00:00.000' as DATETIME) and left(SODetailHist.ItemNo,5)='00170' and right(SODetailHist.ItemNo,3)='021'
and SOHeaderHist.UsageLoc<>11
order by SODetailHist.ItemNo, SOHeaderHist.UsageLoc  --SOHeaderHist.ARPostDt, SOHeaderHist.InvoiceNo

select * from tRodItems
order by [Item No_], [Location Code]

--select * from tSOFix



select SODetailHist.LineNumber
FROM	--OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	--OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	--SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo inner join
	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID
WHERE	--NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=2 AND NVLINE.No_ <> '' AND
	SOHeaderHist.[ARPostDt] >= Cast('2008-09-28 00:00:00.000' as DATETIME)




select sum(SODetailHist.QtyShipped * SODetailHist.GrossWght)
FROM	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID
WHERE	SOHeaderHist.[ARPostDt] >= Cast('2008-09-28 00:00:00.000' as DATETIME)









delete SODetailHist

select SODetailHist.*
FROM	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID
WHERE	SOHeaderHist.[ARPostDt] >= Cast('2008-09-28 00:00:00.000' as DATETIME)


delete 
select *
FROM	SOHeaderHist 
WHERE	SOHeaderHist.[ARPostDt] >= Cast('2008-09-28 00:00:00.000' as DATETIME) and SOHeaderHist.InvoiceNo='SCR169924'









--UPDATE THE DETAIL RECORDS [Porteous$Sales Invoice Header]
UPDATE	SODetailHist
SET	UnitCost = ISNULL(NULLIF(ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC),0), SODetailHist.UnitCost)



FROM	SODetailHist INNER JOIN
	SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON
	NVHDR.[No_]=SoHeaderHist.InvoiceNo LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
--	PFCAC.dbo.[AvgCst_DailyHist] AvgCostTbl ON 
	AvgCostTbl.Branch = SODetailHist.IMLoc AND 
	AvgCostTbl.ItemNo = SODetailHist.ItemNo AND
	AvgCostTbl.CurDate = ARPostDt
WHERE NVHDR.[ERP Upload Flag]=0







select NVHDR.[Document No_], NVLINE.[No_], NVHDR.[Usage Location], NVLINE.[Quantity]	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo inner join
	tRodItems on NVLINE.[No_]=tRodItems.[Item No_] and tRodItems.[Location Code]=NVHDR.[Usage Location]

