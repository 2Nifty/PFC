select	SUM(CurNoofSales) as CurNoofSales, sum(CurSalesQty) as CurSalesQty,
	sum(CurSalesDol) as CurSalesDol, sum(CurSalesWght) as CurSalesWght,
	sum(CurCostDol) as CurCostDol,
	SUM(CurNRNoSales) as CurNRNoSales, sum(CurNRSalesQty) as CurNRSalesQty,
	sum(CurNRSalesDol) as CurNRSalesDol, sum(CurNRSalesWght) as CurNRSalesWght,
	sum(CurNRCostDol) as CurNRCostDol
from ItemBranchUsageHist



select 
	Count(*) AS SlsCnt,
	SUM(SODH.QtyShipped) AS SlsQty,
	SUM(SODH.NetUnitPrice * SODH.QtyShipped) AS SlsDol,
	SUM(SODH.UnitCost * SODH.QtyShipped) AS SlsCost,
	SUM(IM.Wght * SODH.QtyShipped) AS SlsWght

		FROM	SOHeaderHist SOHH (NoLock) INNER JOIN
				SODetailHist SODH (NoLock)
		ON		SOHH.pSOHeaderHistID = SODH.fSOHeaderHistID INNER JOIN
				ItemMaster IM (NoLock)
		ON		SODH.ItemNo = IM.ItemNo
		WHERE 	(SOHH.SubType <= 50 OR SOHH.SubType = 53 OR SOHH.SubType = 54) AND
				ISNULL(SOHH.DeleteDt,'') = '' AND ISNULL(SODH.DeleteDt,'') = '' AND
				SODH.ItemNo <> '00000-0000-000' AND
				SOHH.InvoiceDt > '09/25/2007'




---------------------------------------------------------------------------------------------------------------------------------------





