exec sp_Columns SODetailHist



select 
	QtyOrdered, ROUND(SODetailHist.QtyOrdered,0,1),
	QtyShipped, ROUND(SODetailHist.QtyShipped,0,1),
	SODetailHist.GrossWght, SODetailHist.NetWght, SODetailHist.NetUnitPrice,SODetailHist.UnitCost
	ExtendedGrossWght, ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.GrossWght,
	ExtendedNetWght, ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetWght,
	ExtendedPrice, ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetUnitPrice,
	ExtendedCost, ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.UnitCost

 from SODetailHist inner join SOHeaderHist on SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID inner join
	PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo COLLATE Latin1_General_CS_AS
WHERE	((NVLINE.Type = 2) OR (NVLINE.Type = 1 AND NVLINE.No_ = '3021')) AND NVLINE.No_ <> ''	--Do we need this WHERE?

and
(	QtyOrdered <> ROUND(SODetailHist.QtyOrdered,0,1) or
	QtyShipped <> ROUND(SODetailHist.QtyShipped,0,1) or
	ExtendedGrossWght <> ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.GrossWght or
	ExtendedNetWght <> ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetWght or
	ExtendedPrice <> ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetUnitPrice or
	ExtendedCost <> ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.UnitCost)

