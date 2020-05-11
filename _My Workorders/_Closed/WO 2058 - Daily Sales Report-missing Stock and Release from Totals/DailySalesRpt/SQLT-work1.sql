select ARPostDt, CustShipLoc, * from SOHeaderHist where ARPostDt > '2009-01-01' order by ARPostDt, CustShipLoc 



select * from FootballInvRaw





/****** Object:  View dbo.FootballInvRaw    Script Date: 10/30/2006 11:39:39 AM ******/
/****** 				    Revision Date: 06/20/2008 by CSR ******/
-- WO753 {Use Average Cost}
CREATE   VIEW [dbo].[FootballInvRaw] as
SELECT 	ADUserID,
	Branch,
	Posted, 
	sum(LineAmts) as InvoiceSalesDollar,
	sum(LineAmts) - sum(CostAmts) as InvoiceMarginDollar,
	count(*) as InvoiceOrderCount,
	sum(LineCounts) as InvoiceLineCount,
	sum(LineWeights) as InvoicePounds
FROM 	(SELECT 
	ADUserID = case WHEN Invs.CustShipLoc=Dsh_Brd_BrnNo 
			THEN Invs.ADUserID
  			WHEN isnull(Dsh_Brd_BrnNo,'xx')='xx' 
			THEN 'UL-'+Invs.ADUserID
  			ELSE 'Support Team' END,
	Invs.CustShipLoc AS Branch,
	Invs.ARPostDt as Posted,
	(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineAmts,
	(select sum(Lines.QtyShipped*Lines.UnitCost) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as CostAmts ,
	(select count(*) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCounts,
	(select sum(Lines.QtyShipped * Lines.GrossWght) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
	FROM DashBoardInvoicesWithADUser Invs
	left outer join DashBoardUserBranch ON ADUserID = DshBrd_WindowsId) raw 
GROUP BY Branch, ADUserID, Posted


select * from DashBoardInvoicesWithADUser




Exec pDailySalesAnalysis '07','08-01-2010','08-28-2010'