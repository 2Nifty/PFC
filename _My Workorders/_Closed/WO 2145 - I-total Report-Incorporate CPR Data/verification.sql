SELECT
--	CPR.ItemNo,
--					CPR.LocationCode,
					count(*) as reccount,

				sum(isnull(CPR.Avail_Cost,0)) as AvailCost,
				sum(isnull(CPR.Avail_Wgt,0)) as AvailWght,
				sum(isnull(CPR.Avail_Qty,0)) as AvailQty,

--				isnull(CPR.Avail_Cost,0) as AvailCost,
--				isnull(CPR.Avail_Wgt,0) as AvailWght ,
--				isnull(CPR.Avail_Qty,0) as AvailQty,

				sum(isnull(CPR.Trf_Cost,0)) as TrfCost,
				sum(isnull(CPR.Trf_Wgt,0)) as TrfWght,
				sum(isnull(CPR.Trf_Qty,0)) as TrfQty,

				sum(isnull(CPR.OW_Cost,0)) as OTWCost,
				sum(isnull(CPR.OW_Wgt,0)) as OTWWght,
				sum(isnull(CPR.OW_Qty,0)) as OTWQty,

				0 as RTSBCost,
				sum(isnull(CPR.RTSBQty,0) * isnull(CPR.Net_Wgt,0)) as RTSBWght,
				sum(isnull(CPR.RTSBQty,0)) as RTSBQty,

					sum(isnull(CPR.OO_Cost,0)) as OnOrdCost,
					sum(isnull(CPR.OO_Wgt,0)) as OnOrdWght,
					sum(isnull(CPR.OO_Qty,0)) as OnOrdQty

--					isnull(CPR.Use_30Day_Qty,0) as Use30DayQty

	FROM	PFCAC.dbo.AvgCst_Daily AC (NoLock) INNER JOIN
			ItemMaster IM (NoLock)
	ON		AC.ItemNo = IM.ItemNo LEFT OUTER JOIN
				CPR_Daily CPR (NoLock)
	ON		AC.ItemNo = CPR.ItemNo AND AC.Branch = CPR.LocationCode
	WHERE   AC.BegQOH > 0 AND AC.Branch not in ('00','17','99','Transit') -- AND AC.CurDate BETWEEN @BegDate AND @EndDate
--and (CPR.LocationCode BETWEEN '01' AND '90') and charindex('-',CPR.LocationCode) = 0




--select LocationCode, charindex('-',LocationCode)
--from CPR_Daily


select ItemNo + ' ' + Branch
from rptItotal
where itotGroup='Branch'



SELECT
		 CPR.ItemNo + ' ' + CPR.LocationCode
--		CPR.*
FROM	PFCAC.dbo.AvgCst_Daily AC (NoLock) INNER JOIN
			ItemMaster IM (NoLock)
ON		AC.ItemNo = IM.ItemNo LEFT OUTER JOIN
		CPR_Daily CPR (NoLock)
ON		AC.ItemNo = CPR.ItemNo AND AC.Branch = CPR.LocationCode
WHERE   AC.BegQOH > 0 AND AC.Branch not in ('00','17','99','Transit') -- AND AC.CurDate BETWEEN @BegDate AND @EndDate
--and (CPR.LocationCode BETWEEN '01' AND '90') and charindex('-',CPR.LocationCode) = 0
and 	CPR.ItemNo + ' ' + CPR.LocationCode not in 

(
select  ItemNo + ' ' + Branch
from rptItotal
where itotGroup='Branch'
)





select 
					count(*) as reccount,
					sum(isnull(RTSBCost,0)) as Cost,
					sum(isnull(RTSBWght,0)) as Wght,
					sum(isnull(RTSBQty,0)) as Qty
from rptItotal
where itotGroup='Branch'

select * from rptItotal


select sum(isnull(BegQOH,0)) as BegQOH, sum(isnull(begac,0)) as BegAC, sum(isnull(IM.Wght,0)) as NetWght,

sum(isnull(BegQOH,0) * isnull(IM.Wght,0)) as OTWWght,
sum(isnull(BegQOH,0) * isnull(BegAc,0)) as OTWCost

FROM	PFCAC.dbo.AvgCst_Daily AC (NoLock) INNER JOIN
		ItemMaster IM (NoLock)
ON		AC.ItemNo = IM.ItemNo
WHERE   AC.BegQOH > 0 AND AC.Branch not in ('00','17','99','Transit') and
AC.Branch = 'VENDTRANS'
