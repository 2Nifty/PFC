SELECT	Item,
	Metric,
	GroupNo,
	GrpDesc,
	DonGroup,
	DonGroupNo,
	Sum(GTLbs) as GT
FROM	(SELECT	Item,
		'1Pounds' as Metric,
		GroupNo,
		GrpDesc,
		DonGroup,
		DonGroupNo,
		Case when Loc between '00' and '18' then SUM(ExtWgt) else 0 end as GTLbs
	 FROM	(SELECT	POL.[Location Code] AS Loc, 
			POL.No_ AS Item, 
			BUY.GroupNo,
			BUY.Description as GrpDesc,
			BUY.DonGroup,
			BUY.DonGroupNo,
			POL.[Outstanding Net Weight] AS ExtWgt --, 
		 FROM	PFCLive.[dbo].[Porteous$Purchase Line] POL INNER JOIN
		 	PFCLive.[dbo].[Porteous$Item] IM
		 ON	IM.[No_]=POL.[No_] LEFT OUTER JOIN
		 	CAS_CatGrpDesc BUY (NoLock)
		 ON	LEFT(POL.No_, 5) = BUY.Category COLLATE Latin1_General_CS_AS
		 WHERE	(POL.Type = 2) AND (POL.[Outstanding Quantity] > 0) AND
		 	(POL.[Expected Receipt Date] > CONVERT(DATETIME, '2010-01-01 00:00:00', 102)) AND (POL.[PO Status Code] = 'B') AND
			left([Document No_],1) in ('0','1','2') AND 
			substring(POL.No_,12,1) in ('0','1','5') AND
			IM.[Web Enabled] ='1') PO
	 GROUP BY Loc, GroupNo, GrpDesc, DonGroup, DonGroupNo, Item)tmp2
GROUP BY Metric, GroupNo, GrpDesc, DonGroup, DonGroupNo, Item