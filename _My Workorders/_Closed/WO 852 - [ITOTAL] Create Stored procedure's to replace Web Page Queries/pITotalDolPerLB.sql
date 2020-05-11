CREATE PROCEDURE dbo.pITotalDolPerLB

@Period datetime

AS
----pITotalDolPerLB
----Written By: Tod Dixon
----Application: Inventory Management/ITotal


--Get Branch $/LB total
SELECT	isNULL(CAST(CASE SUM(QtyOnHand*NetWght)
               WHEN 0 THEN 0
                      ELSE SUM(QtyOnHand * AvgCost) / SUM(QtyOnHand * NetWght)
               END as decimal(18,3)),0) as TotBrDolPerLb
FROM	rptITotal
--WHERE	CurrentDt = '2008-08-01' AND ITotGroup = 'Branch'
WHERE	CurrentDt = @Period AND ITotGroup = 'Branch'


--Get OTW $/LB total
SELECT	isNULL(CAST(CASE SUM(isNULL(QtyOnHand,0) * isNULL(NetWght,0))
	       WHEN 0 THEN 0
	              ELSE SUM(QtyOnHand * AvgCost) / SUM(QtyOnHand * NetWght)
	       END as decimal(18,3)),0) as TotBrDolPerLb
FROM	rptITotal
--WHERE	CurrentDt = '2008-08-01' AND ITotGroup = 'OnTheWater'
WHERE	CurrentDt = @Period AND ITotGroup = 'OnTheWater'

GO