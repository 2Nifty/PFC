Select	Item,
					Metric,
					GroupNo,
					GrpDesc,
					DonGroup,
					DonGroupNo,	
					SUM(GT) as GT
				
				From(
					Select	Item,
						WkYrNo,
						max(ExpRcptDt) as WkDay,
						'1Pounds' as Metric,
						GroupNo,
						GrpDesc,
						DonGroup,
						DonGroupNo,
						sum(Br1ExtWgt) as Carson,
						sum(Br15ExtWgt) as SFS,
						sum(Br2ExtWgt) as Hay,
						sum(Br3ExtWgt) as POR,
						sum(Br4ExtWgt) as SLC,
						sum(Br5ExtWgt) as SEA,
						sum(Br6ExtWgt) as VAN,
						sum(Br7ExtWgt) as DAL,
						sum(Br8ExtWgt) as HOU,
						sum(Br9ExtWgt) as ATL,
						sum(Br10ExtWgt) as CHI,
						sum(Br12ExtWgt) as DEN,
						sum(Br13ExtWgt) as TAM,
						sum(Br14ExtWgt) as KAN,
						sum(Br16ExtWgt) as CLE,
						sum(Br18ExtWgt) as NJ,
						Sum(GTLbs) as GT
						
					From(
						SELECT	Item,
							ExpRcptDt, 
							GroupNo,
							GrpDesc,
							DonGroup,
							DonGroupNo,
							DATEPART(yy,ExpRcptDt)*100 + DATEPART(ww,ExpRcptDt) as WkYrNo,
							Loc, 
							Case when Loc = '01' then SUM(ExtWgt) else 0 end AS Br1ExtWgt, 
							Case when Loc = '02' then SUM(ExtWgt) else 0 end AS Br2ExtWgt, 
							Case when Loc = '03' then SUM(ExtWgt) else 0 end AS Br3ExtWgt, 
							Case when Loc = '04' then SUM(ExtWgt) else 0 end AS Br4ExtWgt, 
							Case when Loc = '05' then SUM(ExtWgt) else 0 end AS Br5ExtWgt, 
							Case when Loc = '06' then SUM(ExtWgt) else 0 end AS Br6ExtWgt, 
							Case when Loc = '07' then SUM(ExtWgt) else 0 end AS Br7ExtWgt, 
							Case when Loc = '08' then SUM(ExtWgt) else 0 end AS Br8ExtWgt, 
							Case when Loc = '09' then SUM(ExtWgt) else 0 end AS Br9ExtWgt, 
							Case when Loc = '10' then SUM(ExtWgt) else 0 end AS Br10ExtWgt, 
							Case when Loc = '12' then SUM(ExtWgt) else 0 end AS Br12ExtWgt, 
							Case when Loc = '13' then SUM(ExtWgt) else 0 end AS Br13ExtWgt, 
							Case when Loc = '14' then SUM(ExtWgt) else 0 end AS Br14ExtWgt, 
							Case when Loc = '15' then SUM(ExtWgt) else 0 end AS Br15ExtWgt, 
							Case when Loc = '16' then SUM(ExtWgt) else 0 end AS Br16ExtWgt, 
							Case when Loc = '18' then SUM(ExtWgt) else 0 end AS Br18ExtWgt, 
							Case when Loc = '30' then SUM(ExtWgt) else 0 end AS Br30ExtWgt, 
							Case when Loc = '40' then SUM(ExtWgt) else 0 end AS Br40ExtWgt, 
							Case when Loc = '80' then SUM(ExtWgt) else 0 end AS Br80ExtWgt, 							
							Case when Loc between '00' and '18' then SUM(ExtWgt) else 0 end as GTLbs
							
						FROM         
							(SELECT	POL.[Buy-from Vendor No_] AS VendNo, 
								VND.[Search Name] AS ShortName, 
								POL.[Location Code] AS Loc, 
								POL.No_ AS Item, 
								BUY.GroupNo,
								BUY.Description as GrpDesc,
								BUY.ReportGroup as DonGroup,
								BUY.ReportGroupNo as DonGroupNo,
								POL.[Outstanding Quantity] AS QtyToRcv, 
								POL.[Net Weight] AS NetWgt, 
								POL.[Unit Cost] AS POCost, 
								POL.[Cat_ No_] AS Cat, 
								POL.[Outstanding Net Weight] AS ExtWgt, 
								Case 	when POL.[Expected Receipt Date]<CAST({ fn CURDATE() } AS DATETIME) then CAST({ fn CURDATE() } AS DATETIME)-7 
									else POL.[Expected Receipt Date] 
								end AS ExpRcptDt, 
								POL.[Gen_ Bus_ Posting Group] AS Type, 
								POL.[PO Status Code] AS StatusCd, 
								POL.[Outstanding Quantity] * POL.[Unit Cost] AS ExtFOB
							FROM	 OPENDATASOURCE ('SQLOLEDB', 'Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal' ).PFCLive.[dbo].[Porteous$Purchase Line] POL  
							INNER JOIN  OPENDATASOURCE ('SQLOLEDB', 'Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal' ).PFCLive.[dbo].Porteous$Vendor VND ON 
								POL.[Buy-from Vendor No_] = VND.No_
							INNER JOIN  OPENDATASOURCE ('SQLOLEDB', 'Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal' ).PFCLive.[dbo].[Porteous$Item] IM ON
								IM.[No_]=POL.[No_]
							LEFT OUTER JOIN CategoryBuyGroups BUY (NoLock) ON 
									LEFT(POL.No_, 5) = BUY.Category COLLATE Latin1_General_CS_AS
							WHERE	(POL.Type = 2) 
								AND (POL.[Outstanding Quantity] > 0) 
								AND (POL.[Expected Receipt Date] > CONVERT(DATETIME, '2010-01-01 00:00:00', 102)) 
								AND (POL.[PO Status Code] = 'B')
								And left([Document No_],1) in ('0','1','2')
								And substring(POL.No_,12,1) in ('0','1','5')
								And IM.[Web Enabled] ='1'
							) tmp
						GROUP BY Loc, ExpRcptDt , GroupNo, GrpDesc, DonGroup, DonGroupNo, Item
						) tmp2
					Group by WkYrNo , GroupNo, GrpDesc, DonGroup, DonGroupNo, Item
					
					) tmp3
				--WHERE Metric = '1Pounds'
				
				GROUP BY Metric, GroupNo, GrpDesc, DonGroup, DonGroupNo, Item