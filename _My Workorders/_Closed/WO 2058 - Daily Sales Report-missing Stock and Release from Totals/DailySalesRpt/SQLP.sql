select * from FootballInvRaw
where Branch=07
order by Posted


Exec pDailySalesAnalysis '14','08-01-2010','08-28-2010'



select * from FootballInvRaw
where Branch='14' and Posted between '08-01-2010' and '08-28-2010'


--CREATE   VIEW [dbo].[FootballInvRaw] as
SELECT 	ADUserID,
	Branch,
	Posted, 
--OrderType, OrderTypeDsc,
	sum(LineAmts) as InvoiceSalesDollar,
	sum(LineAmts) - sum(CostAmts) as InvoiceMarginDollar,
	count(*) as InvoiceOrderCount,
	sum(LineCounts) as InvoiceLineCount,
	sum(LineWeights) as InvoicePounds
FROM 	(
	SELECT 
	ADUserID = case WHEN Invs.CustShipLoc=Dsh_Brd_BrnNo 
			THEN Invs.ADUserID
  			WHEN isnull(Dsh_Brd_BrnNo,'xx')='xx' 
			THEN 'UL-'+Invs.ADUserID
  			ELSE 'Support Team' END,
	Invs.CustShipLoc AS Branch,
	Invs.ARPostDt as Posted,
OrderNo, OrderRelNo, InvoiceNo,
OrderType, OrderTypeDsc,
	(select sum(Lines.QtyShipped*Lines.NetUnitPrice) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as Sales, --LineAmts,
	(select sum(Lines.QtyShipped*Lines.UnitCost) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as Cost, --CostAmts ,
	(select count(*) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineCount, --LineCounts,
	(select sum(Lines.QtyShipped * Lines.GrossWght) from
		SODetailHist Lines where Invs.pSOHeaderHistID = Lines.fSOHeaderHistID) as LineWeights
	FROM DashBoardInvoicesWithADUser Invs
	left outer join DashBoardUserBranch ON ADUserID = DshBrd_WindowsId

where CustShipLoc='14' and ARPostDt between '08-01-2010' and '08-28-2010'

) raw 

where Branch='14' and Posted between '08-01-2010' and '08-28-2010'

GROUP BY Branch, ADUserID, Posted --, OrderType, OrderTypeDsc

select * from SOHeaderHist


select * from DashBoardUserBranch
select * from DashBoardInvoicesWithADUser
order by OrderType

--CREATE view [dbo].[DashBoardInvoicesWithADUser] as
select	ADUserID = case isnull(DashboardUsersTemp.UserID,'***')
			when '***' then SOHeaderHist.EntryID 
			else DashboardUsersTemp.UserID
		   end, *
from	SOHeaderHist (NOLOCK) left outer join
	DashboardUsersTemp  (NOLOCK)
on	SOHeaderHist.EntryID = DashboardUsersTemp.UserID
WHERE	(ARPostDt > DATEADD(m, - 3, GETDATE())) and isnumeric(OrderType) = 1 and OrderType < 50

order by OrderType













select * from FootballCRRaw
where Branch='07' and Posted between '08-01-2010' and '08-28-2010'



