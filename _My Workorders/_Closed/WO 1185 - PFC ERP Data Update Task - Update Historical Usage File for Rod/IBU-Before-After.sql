select Location, ItemNo, CurPeriodNo, CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
	CurNRNoSales, CurNRSalesQty, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
--from tItemBranchUsageBackup
from ItemBranchUsage
where [ItemNo]='00170-2510-500' or [ItemNo]='00170-2503-500' or [ItemNo]='00170-2512-501' or [ItemNo]='00170-3403-501'
order by ItemNo, Location
--where [ItemNo]='00170-2510-020' or [ItemNo]='00170-2503-020' or [ItemNo]='00170-2512-021' or [ItemNo]='00170-3403-021'

where
(Location='05' and ItemNo='00170-2503-020' and CurPeriodNo='200903') or
(Location='09' and ItemNo='00170-2503-020' and CurPeriodNo='200804') or
(Location='09' and ItemNo='00170-2503-020' and CurPeriodNo='200807') or
(Location='10' and ItemNo='00170-2503-020' and CurPeriodNo='200902') or
(Location='10' and ItemNo='00170-2503-020' and CurPeriodNo='200903') or
(Location='12' and ItemNo='00170-2503-020' and CurPeriodNo='200808') or
(Location='12' and ItemNo='00170-2503-020' and CurPeriodNo='200810') or
(Location='15' and ItemNo='00170-2503-020' and CurPeriodNo='200901') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200701') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200703') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200706') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200803') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200804') or
(Location='10' and ItemNo='00170-2510-020' and CurPeriodNo='200809') or
(Location='06' and ItemNo='00170-2512-021' and CurPeriodNo='200811') or
(Location='08' and ItemNo='00170-2512-021' and CurPeriodNo='200901') or
(Location='08' and ItemNo='00170-2512-021' and CurPeriodNo='200903') or
(Location='10' and ItemNo='00170-2512-021' and CurPeriodNo='200901') or
(Location='10' and ItemNo='00170-2512-021' and CurPeriodNo='200903') or
(Location='12' and ItemNo='00170-2512-021' and CurPeriodNo='200903') or
(Location='14' and ItemNo='00170-2512-021' and CurPeriodNo='200901') or
(Location='13' and ItemNo='00170-2512-021' and CurPeriodNo='200902') or
(Location='03' and ItemNo='00170-2512-021' and CurPeriodNo='200901') or
(Location='05' and ItemNo='00170-2512-021' and CurPeriodNo='200901') or
(Location='01' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='01' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='02' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='03' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='04' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='04' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='05' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='05' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='05' and ItemNo='00170-3403-021' and CurPeriodNo='200903') or
(Location='06' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='06' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='07' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='07' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='08' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='08' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='08' and ItemNo='00170-3403-021' and CurPeriodNo='200903') or
(Location='09' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='09' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='10' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='10' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='10' and ItemNo='00170-3403-021' and CurPeriodNo='200903') or
(Location='12' and ItemNo='00170-3403-021' and CurPeriodNo='200903') or
(Location='14' and ItemNo='00170-3403-021' and CurPeriodNo='200902') or
(Location='14' and ItemNo='00170-3403-021' and CurPeriodNo='200903') or
(Location='15' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='18' and ItemNo='00170-3403-021' and CurPeriodNo='200901') or
(Location='18' and ItemNo='00170-3403-021' and CurPeriodNo='200903')
