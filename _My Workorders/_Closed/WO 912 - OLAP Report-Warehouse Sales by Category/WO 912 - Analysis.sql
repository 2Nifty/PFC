
SELECT
  Category,
  SUM(NetUnitPrice * QtyShipped) AS SalesDollars, 
  SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped) AS MarginDollars,
  CASE SUM(NetUnitPrice * QtyShipped)
    WHEN 0 THEN 0
    ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(NetUnitPrice * QtyShipped)
  END AS MarginPct,
  SUM(QtyShipped * NetWght) AS Pounds,
  CASE SUM(QtyShipped * NetWght)
    WHEN 0 THEN 0
    ELSE SUM(NetUnitPrice * QtyShipped) / SUM(QtyShipped * NetWght)
  END AS SalesDollarsPerLB,
  CASE SUM(QtyShipped * NetWght)
    WHEN 0 THEN 0
    ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(QtyShipped * NetWght)
  END AS MarginDollarsPerLB,
  CASE SUM(QtyShipped * NetWght)
    WHEN 0 THEN 0
    ELSE SUM(QtyShipped * StandardCost) / SUM(QtyShipped * NetWght)
  END AS StdCostPerLB,
  CASE SUM(QtyShipped * NetWght)
    WHEN 0 THEN 0
    ELSE SUM(QtyShipped * ReplacementCost) / SUM(QtyShipped * NetWght)
  END AS ReplCostPerLB,
  SUM(QtyOnHand * AvgCost) AS OnHandDollars,
  SUM(QtyOnHand * NetWght) AS OnHandPounds,
  CASE SUM(ThirtyDayUsageQty)
    WHEN 0 THEN 0
    ELSE SUM(QtyOnHand / ThirtyDayUsageQty * ACNet)
  END AS OnHandMonths,
  CASE SUM(QtyOnHand * AvgCost)
    WHEN 0 THEN 0
    ELSE (SUM(NetUnitPrice * QtyShipped) - SUM(UnitCost * QtyShipped)) / SUM(QtyOnHand * AvgCost)
  END AS MarginPerOnHand
FROM (
SELECT
  SOD.ItemNo, LEFT(SOD.ItemNo, 5) AS Category, SOH.ARPostDt, SOH.ShipLoc,
  SOD.NetUnitPrice,
  SOD.QtyShipped,
  SOD.UnitCost,
  SOD.NetWght,
  AC.StandardCost,
  AC.ReplacementCost,
  AC.QtyOnHand,
  AC.AvgCost,
  AC.ThirtyDayUsageQty,
  AC.NetWght AS ACNet
FROM	SOHeaderHist SOH INNER JOIN
	SODetailHist SOD ON SOH.pSOHeaderHistID = SOD.fSOHeaderHistID LEFT OUTER JOIN
	rptITotal AC ON AC.CurrentDt = SOH.ARPostDt AND
			AC.Branch = SOH.ShipLoc AND
			AC.ItemNo = SOD.ItemNo
WHERE	SOD.ItemNo<>'' and SOD.ItemNo<>'00000-0000-000' and
--	ARPostDt >= '2008-06-01' and ARPostDt <= '2008-06-07'
--	ARPostDt >= '2008-06-08' and ARPostDt <= '2008-06-14'
--	ARPostDt >= '2008-06-15' and ARPostDt <= '2008-06-21'
--	ARPostDt >= '2008-06-22' and ARPostDt <= '2008-06-28'
--	ARPostDt >= '2008-06-29' and ARPostDt <= '2008-07-05'
--	ARPostDt >= '2008-07-06' and ARPostDt <= '2008-07-12'
--	ARPostDt >= '2008-07-13' and ARPostDt <= '2008-07-19'
--	ARPostDt >= '2008-07-20' and ARPostDt <= '2008-07-26'
--	ARPostDt >= '2008-07-27' and ARPostDt <= '2008-08-02'
--	ARPostDt >= '2008-08-03' and ARPostDt <= '2008-08-09'
--	ARPostDt >= '2008-08-10' and ARPostDt <= '2008-08-16'
--	ARPostDt >= '2008-08-17' and ARPostDt <= '2008-08-23'
	ARPostDt >= '2008-08-24' and ARPostDt <= '2008-08-30'
) CatMeasurement
Group By Category
Order By Category