USE [PFCReports]
GO

drop proc [pITotalMTDTrend]
go


/****** Object:  StoredProcedure [dbo].[pITotalMTDTrend]    Script Date: 04/20/2011 14:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pITotalMTDTrend]
AS
----pITotalMTDTrend
----Written By: Charles Rojas
----Application: Inventory Management/ITotal [WO981]
----Create Date 10/30/08 

SELECT	*
FROM	--Table1
		(SELECT	CurrentDt,
				sum(BranchCost) as BrnCost,
				sum(BranchWgt) as BrnWgt,
				case when sum(BranchWgt) = 0 then 0 else sum(BranchCost) / sum(BranchWgt) end as BrnPerLb,
				sum(OTWCost) as OTWCost,
				sum(OTWWgt) as OTWWgt,
				case when sum(OTWWgt) = 0 then 0 else sum(OTWCost) / sum(OTWWgt) end as OTWPerLb,

				SUM(isnull(AvailCost,0)) as AvailCost,
				SUM(isnull(AvailWght,0)) as AvailWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(AvailQty,0))
					ELSE SUM(isnull(AvailQty,0)) / SUM(isnull(Use30DayQty,0))
				END as AvailMonths,
				SUM(isnull(TrfCost,0)) as TrfCost,
				SUM(isnull(TrfWght,0)) as TrfWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(TrfQty,0))
					ELSE SUM(isnull(TrfQty,0)) / SUM(isnull(Use30DayQty,0))
				END as TrfMonths,
--				SUM(isnull(OTWCost,0)) as OTWCost,
--				SUM(isnull(OTWWght,0)) as OTWWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(OTWQty,0))
					ELSE SUM(isnull(OTWQty,0)) / SUM(isnull(Use30DayQty,0))
				END as OTWMonths,
				SUM(isnull(RTSBCost,0)) as RTSBCost,
				SUM(isnull(RTSBWght,0)) as RTSBWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(RTSBQty,0))
					ELSE SUM(isnull(RTSBQty,0)) / SUM(isnull(Use30DayQty,0))
				END as RTSBMonths,
				SUM(isnull(OnOrdCost,0)) as OnOrdCost,
				SUM(isnull(OnOrdWght,0)) as OnOrdWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(OnOrdQty,0))
					ELSE SUM(isnull(OnOrdQty,0)) / SUM(isnull(Use30DayQty,0))
				END as OnOrdMonths

		 FROM	--raw1
				(SELECT	CurrentDt,
						ITotalGroup, 
						Case when ItotalGroup <> 'On-the-Water' then SUM(ExtendedAvgCost) else 0 end AS BranchCost, 
						Case when ItotalGroup <> 'On-the-Water' then SUM(ExtendedNetWght) else 0 end AS BranchWgt,
						Case when ItotalGroup = 'On-the-Water' then SUM(ExtendedAvgCost) else 0 end AS OTWCost, 
						Case when ItotalGroup = 'On-the-Water' then SUM(ExtendedNetWght) else 0 end AS OTWWgt,

						SUM(isnull(AvailCost,0)) as AvailCost,
						SUM(isnull(AvailWght,0)) as AvailWght,
						SUM(isnull(AvailQty,0)) as AvailQty,
						SUM(isnull(TrfCost,0)) as TrfCost,
						SUM(isnull(TrfWght,0)) as TrfWght,
						SUM(isnull(TrfQty,0)) as TrfQty,
--						SUM(isnull(OTWCost,0)) as OTWCost,
--						SUM(isnull(OTWWght,0)) as OTWWght,
						SUM(isnull(OTWQty,0)) as OTWQty,
						SUM(isnull(RTSBCost,0)) as RTSBCost,
						SUM(isnull(RTSBWght,0)) as RTSBWght,
						SUM(isnull(RTSBQty,0)) as RTSBQty,
						SUM(isnull(OnOrdCost,0)) as OnOrdCost,
						SUM(isnull(OnOrdWght,0)) as OnOrdWght,
						SUM(isnull(OnOrdQty,0)) as OnOrdQty,
						SUM(isnull(Use30DayQty,0)) as Use30DayQty

				 FROM	(SELECT	DashboardParameter, 
								BegDate, 
								EndDate
						 FROM	DashboardRanges
						 WHERE	(DashboardParameter = 'CurrentMonth')) DSH INNER JOIN
						rptITotalHist
				 ON		rptITotalHist.CurrentDt BETWEEN DSH.BegDate AND DSH.EndDate
				 GROUP BY CurrentDt, ITotalGroup) raw1
Group by CurrentDt) Table1
UNION
SELECT	*
FROM	 --Table2
		(SELECT	CurrentDt,
				sum(BranchCost) as BrnCost,
				sum(BranchWgt) as BrnWgt,
				case when sum(BranchWgt) = 0 then 0 else sum(BranchCost) / sum(BranchWgt) end as BrnPerLb,
				sum(OTWCost) as OTWCost,
				sum(OTWWgt) as OTWWgt,
				case when sum(OTWWgt) = 0 then 0 else sum(OTWCost) / sum(OTWWgt) end as OTWPerLb,

				SUM(isnull(AvailCost,0)) as AvailCost,
				SUM(isnull(AvailWght,0)) as AvailWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(AvailQty,0))
					ELSE SUM(isnull(AvailQty,0)) / SUM(isnull(Use30DayQty,0))
				END as AvailMonths,
				SUM(isnull(TrfCost,0)) as TrfCost,
				SUM(isnull(TrfWght,0)) as TrfWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(TrfQty,0))
					ELSE SUM(isnull(TrfQty,0)) / SUM(isnull(Use30DayQty,0))
				END as TrfMonths,
--				SUM(isnull(OTWCost,0)) as OTWCost,
--				SUM(isnull(OTWWght,0)) as OTWWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(OTWQty,0))
					ELSE SUM(isnull(OTWQty,0)) / SUM(isnull(Use30DayQty,0))
				END as OTWMonths,
				SUM(isnull(RTSBCost,0)) as RTSBCost,
				SUM(isnull(RTSBWght,0)) as RTSBWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(RTSBQty,0))
					ELSE SUM(isnull(RTSBQty,0)) / SUM(isnull(Use30DayQty,0))
				END as RTSBMonths,
				SUM(isnull(OnOrdCost,0)) as OnOrdCost,
				SUM(isnull(OnOrdWght,0)) as OnOrdWght,
				CASE SUM(isnull(Use30DayQty,0))
					WHEN 0 THEN SUM(isnull(OnOrdQty,0))
					ELSE SUM(isnull(OnOrdQty,0)) / SUM(isnull(Use30DayQty,0))
				END as OnOrdMonths

		 FROM	 --raw2
				(SELECT	CurrentDt,
						ITotGroup, 
						Case when ItotGroup <> 'On-the-Water' then SUM(QtyOnHand * AvgCost) else 0 end AS BranchCost, 
						Case when ItotGroup <> 'On-the-Water' then SUM(QtyOnHand * NetWght) else 0 end AS BranchWgt,
						Case when ItotGroup = 'On-the-Water' then SUM(QtyOnHand * AvgCost) else 0 end AS OTWCost, 
						Case when ItotGroup = 'On-the-Water' then SUM(QtyOnHand * NetWght) else 0 end AS OTWWgt,

						SUM(isnull(AvailCost,0)) as AvailCost,
						SUM(isnull(AvailWght,0)) as AvailWght,
						SUM(isnull(AvailQty,0)) as AvailQty,
						SUM(isnull(TrfCost,0)) as TrfCost,
						SUM(isnull(TrfWght,0)) as TrfWght,
						SUM(isnull(TrfQty,0)) as TrfQty,
--						SUM(isnull(OTWCost,0)) as OTWCost,
--						SUM(isnull(OTWWght,0)) as OTWWght,
						SUM(isnull(OTWQty,0)) as OTWQty,
						SUM(isnull(RTSBCost,0)) as RTSBCost,
						SUM(isnull(RTSBWght,0)) as RTSBWght,
						SUM(isnull(RTSBQty,0)) as RTSBQty,
						SUM(isnull(OnOrdCost,0)) as OnOrdCost,
						SUM(isnull(OnOrdWght,0)) as OnOrdWght,
						SUM(isnull(OnOrdQty,0)) as OnOrdQty,
						SUM(isnull(Use30DayQty,0)) as Use30DayQty

				 FROM	rptITotal
				 GROUP BY CurrentDt, ITotGroup) raw2
		 Group by CurrentDt) Table2
Order by CurrentDt desc
