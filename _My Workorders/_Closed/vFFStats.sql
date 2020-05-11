create view vFFStats
--Written By: Tod Dixon
--Application: Fantasy Football
--Date Created: 2008-Aug-21

SELECT	WeekNo, HomeTeamLocation+' '+HomeTeamName AS HomeTeam, AwayTeamLocation+' '+AwayTeamName AS AwayTeam, 
	CASE Period
	  WHEN 1 THEN 'Monday'
	  WHEN 2 THEN 'Tuesday'
	  WHEN 3 THEN 'Wednesday'
	  WHEN 4 THEN 'Thursday'
	  WHEN 5 THEN 'Friday'
	END AS Period,
	Location, TeamName, Division, CAST(TeamMemberCount AS INT) AS TeamMemberCount,
	CAST(InvoiceDollars AS Money) AS InvoiceDollars, CAST(CreditDollars AS Money) AS CreditDollars,
	CAST(GPDollars AS Money) AS GPDollars,
	CASE NetLbs
	  WHEN 0 THEN 0
	  ELSE CAST(GPDollars/NetLbs AS Money)
	END AS GPDollarsPerLB,
	ALLGPPct, CAST(Metric1 AS Int) AS RushingYards,
	CAST(NetDollarPerPerson AS Money) AS NetDollarsPerPerson, CAST(Metric2 AS Int) AS PassingYards,
	CAST(GPDollarPerPerson AS Money) AS GPDollarsPerPerson, CAST(Metric3 AS Int) AS PuntReturns,
	CAST(Metric4 AS Int) AS ExtraPoints, NoOfOrdersOver10k, CAST(Metric5 AS Int) AS HailMary,
	CAST(Metric6 AS Int) AS PenaltyYards, CAST(Metric7 AS Int) AS FinalPoints,
	CASE
	  WHEN Metric7 - (FLOOR(Metric7/100) * 100) < 50 THEN FLOOR(Metric7/100) * 7
							 ELSE (FLOOR(Metric7/100) * 7) + 3
	END AS FinalScore
FROM	FFSchedule INNER JOIN
	ContestDetail ON FFSchedule.pFFScheduleID = ContestDetail.fFFScheduleID

go