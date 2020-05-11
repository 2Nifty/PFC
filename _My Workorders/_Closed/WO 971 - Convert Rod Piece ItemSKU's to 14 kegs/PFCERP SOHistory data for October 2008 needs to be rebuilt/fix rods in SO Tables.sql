

--select SOHeaderHist.InvoiceNo, SOHeaderHist.ARPostDt, SOHeaderHist.[TotalCost], SOHeaderHist.[UsageLoc], SODetailHist.[LineNumber], SODetailHist.[ItemNo], Rods.Item, SODetailHist.[QtyOrdered], SODetailHist.[QtyShipped], Rods.Qty, [SODetailHist].UnitCost
update	SODetailHist
Set	[ItemNo]=Rods.Item, [QtyOrdered]=Rods.Qty, [QtyShipped]=Rods.Qty
FROM	SOHeaderHist inner join
	SODetailHist on pSOHeaderHistID = fSOHeaderHistID inner join 
(select NVHDR.[No_] as Invoice, NVLINE.[No_] as Item, NVLINE.[Line No_]	as Line, NVHDR.[Usage Location] as Loc, NVLINE.[Quantity] as Qty	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo inner join
	tRodItems on NVLINE.[No_]=tRodItems.[Item No_] and tRodItems.[Location Code]=NVHDR.[Usage Location]) Rods
on SOHeaderHist.InvoiceNo=Rods.Invoice and SODetailHist.[ItemNo]<>Rods.Item and SOHeaderHist.[UsageLoc]=Rods.Loc and SODetailHist.[LineNumber]=Rods.Line

